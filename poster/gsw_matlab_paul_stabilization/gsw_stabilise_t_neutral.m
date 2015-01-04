function SA_out = gsw_stabilise_t_neutral(SA_in,t,p)

% gsw_stabilise_t                      adjusts salinities (SA) to produce a
%                              neutrally stable water column (48 term eqn.)
%==========================================================================
%
% USAGE:
%  SA_out = gsw_stabilise_t_neutral(SA_in,t,p)
%
% DESCRIPTION:
%  This function stabilises a water column, this is achieved by minimally
%  adjusting only the Absolute Salinity SA values such that the minimum
%  stability is adjusted to be atleast 2 x 10^-8. There are no changes
%  made to either in-situ temperature or pressure.
%
%  Note that the 48-term equation has been fitted in a restricted range of
%  parameter space, and is most accurate inside the "oceanographic funnel"
%  described in McDougall et al. (2011).  The GSW library function
%  "gsw_infunnel(SA,CT,p)" is avaialble to be used if one wants to test if
%  some of one's data lies outside this "funnel".
%
% INPUT:
%  SA_in  =  uncorrected Absolute Salinity                         [ g/kg ]
%  t   =  in-situ temperature (ITS-90)                            [ deg C ]
%  p   =  sea pressure                                             [ dbar ]
%         ( i.e. absolute pressure - 10.1325 dbar )
%
%  SA_in & t need to have the same dimensions.
%  p may have dimensions 1x1 or Mx1 or 1xN or MxN, where SA_in & t are MxN.
%
% OUTPUT:
%  SA_out  =  corrected stablised Absolute Salinity                [ g/kg ]
%
% AUTHOR:
%  Paul Barker and Trevor McDougall                    [ help@teos-10.org ]
%
% VERSION NUMBER: 3.01 (12th December, 2011)
%
% REFERENCES:
%
%  McDougall T.J., P.M. Barker, R. Feistel and D.R. Jackett, 2011:  A
%   computationally efficient 48-term expression for the density of
%   seawater in terms of Conservative Temperature, and related properties
%   of seawater.  To be submitted to Ocean Science Discussions.
%
%  Jackett, D.R. and T.J. McDougall, 1995: Minimal Adjustment of
%   Hydrostatic Profiles to Achieve Static Stability.  J. Atmos. Oceanic
%   Techn., 12, 381-389.
%
%  The software is available from http://www.TEOS-10.org
%
%==========================================================================

%--------------------------------------------------------------------------
% Check variables and resize if necessary
%--------------------------------------------------------------------------

%codegen

if ~(nargin == 3 | nargin == 5)
    error('gsw_stabilise_t_neutral:  Requires three inputs')
end
figs = 0;
if nargin == 5
    figs = 1;
end

[ms,ns] = size(SA_in);
[mt,nt] = size(t);
[mp,np] = size(p);

if (mt ~= ms | nt ~= ns)
    error('gsw_stabilise_t_neutral: SA_in and t must have same dimensions')
end

if (mp == 1) & (np == 1)                    % p scalar - fill to size of SA
    p = p*ones(size(SA_in));
elseif (ns == np) & (mp == 1)               % p is row vector,
    p = p(ones(1,ms), :);                   % copy down each column.
elseif (ms == mp) & (np == 1)               % p is column vector,
    p = p(:,ones(1,ns));                    % copy across each row.
elseif (ns == mp) & (np == 1)               % p is a transposed row vector,
    p = p.';                                % transpose then
    p = p(ones(1,ms), :);                   % copy down each column.
elseif (ms == mp) & (ns == np)
    % ok
else
    error('gsw_stabilise_t_neutral: Inputs array dimensions arguments do not agree')
end %if

if ms == 1
    SA_in = SA_in.';
    t = t.';
    p = p.';
    transposed = 1;
else
    transposed = 0;
end

%--------------------------------------------------------------------------
% Start of the calculation
%--------------------------------------------------------------------------

db2Pa = 1e4;

[ms,ns] = size(SA_in);
SA_out = nan(size(SA_in));

% if figs
%     fig1 = figure;
%     set(fig1,'pos','default','menubar','none','numbertitle','off', ...
%         'name','GSW stabilise')
%     coast('b',1),
%     
%     lat_pad = 0.2*(max(lat) - min(lat));
%     min_lat = min(lat) - lat_pad;
%     if min_lat < -90
%         min_lat = -90;
%     end
%     max_lat = max(lat) + lat_pad;
%     if max_lat > 90
%         max_lat = 90;
%     end
%     
%     long_pad = 0.2*(max(long) - min(long));
%     min_long = min(long) - long_pad;
%     if min_long < 0
%         min_long = 0;
%     end
%     max_long = max(long) + long_pad;
%     if max_long > 360
%         max_long = 360;
%     end
%     
%     axis([min_long max_long min_lat max_lat])
%     hold on
% end

parfor Iprofile = 1:ns
    
    SA_outt = nan(ms,1);
    
    [Inn] = find(~isnan(SA_in(:,Iprofile) + t(:,Iprofile) + p(:,Iprofile)));
    
    if length(Inn) < 2
        %SA_outt = SA_in(Inn,Iprofile);
        SA_outt(Inn) = SA_in(Inn,Iprofile);
        SA_out(:,Iprofile) = SA_outt;

    else
        %calculate Nsquared
        CT = gsw_CT_from_t(SA_in(:,Iprofile),t(:,Iprofile),p(:,Iprofile));
        [N2,N2_p,N2_rho,N2_alpha,N2_beta] = gsw_Nsquared_min(SA_in(Inn,Iprofile),CT(Inn),p(Inn,Iprofile));
        
        %--------------------------------------------------------------------------
        % Initial stabilisation
        % Make the cast neutrally stable.
        % Adjust SA such that the cast has stabilities greater that 2^-8
        %--------------------------------------------------------------------------
        neutral = 2e-8*ones(size(N2));
        [Iunstable] = find((N2 - neutral) < -5e-10);
        
        if isempty(Iunstable)
            SA_old = SA_in(:,Iprofile);
%             if figs == 1
%                 figure(fig1)
%                 plot(long(Iprofile),lat(Iprofile),'yo')
%                 title([num2str(0.1*round(1000*Iprofile/ns)),' %'])
%                 pause(0.0001)
%             end
        else
            
            SA_old = NaN(ms,1);
            SA_old(Inn) = SA_in(Inn,Iprofile);
            
            mm = length(Inn);
            H = eye(mm);
            f = zeros(mm,1);
            A = eye(mm,mm) - diag(ones(mm-1,1),1);
            A(mm,:) = [];
            
            b_L = -inf*ones(mm-1,1);
            x_L = -inf*ones(mm,1);
            x_U = inf*ones(mm,1);
            x_0 = zeros(mm,1);
            Name = 'stabilise for mixed layer calculation';
            
            Ishallow = Inn([1:(length(Inn)-1)]);
            Ideep = Inn([2:length(Inn)]);
            dp = p(Ideep,Iprofile) - p(Ishallow,Iprofile);
            grav_squared = 95.96749369.*ones(size(dp)); %grav = 9.7963 (Griffies, 2004)
            
            for Number_of_iterations = 1:2
                
                dSA = SA_old(Ideep) - SA_old(Ishallow);
                dCT = CT(Ideep) - CT(Ishallow);
                
                b = dSA - (N2_alpha./N2_beta).*dCT - (db2Pa*dp.*neutral)./(N2_rho.*N2_beta.*grav_squared);
                
                opts = optimset('Algorithm','active-set','Display','off');
                x = quadprog(H,f,A,b,[],[],[],[],[],opts);
                %Prob = qpAssign(H, f, A, b_L, b, x_L, x_U, x_0, Name,...
                %    [], [], [], [], []);
                %Result = tomRun('cplex', Prob, 0);
                
                SA_old(Inn) = SA_old(Inn) + x;
                
                CT = gsw_CT_from_t(SA_old,t(:,Iprofile),p(:,Iprofile));
                
                [N2,N2_p,N2_rho,N2_alpha,N2_beta] = gsw_Nsquared_min(SA_old(Inn),CT(Inn),p(Inn,Iprofile));
                
            end
            
        end
        SA_outt(Inn) = SA_old(Inn);
        SA_out(:,Iprofile) = SA_outt;
        
    end
end

if transposed
    SA_out = SA_out.';
end

end