function [N2, N2_p, N2_rho, N2_alpha ,N2_beta] = gsw_Nsquared_min(SA,CT,p,lat)

% gsw_Nsquared_min         buoyancy (Brunt-Vaisala) frequency squared (N^2)
%                                                        (48-term equation)
%==========================================================================
% 
% USAGE:  
%  [N2, N2_p, N2_rho, N2_alpha ,N2_beta] = gsw_Nsquared_min(SA,CT,p,{lat})
%
% DESCRIPTION:
%  Calculates the minimum buoyancy frequency squared (N^2)(i.e. the 
%  Brunt-Vaisala frequency squared) between two bottles from the equation,
%
%           2      2             beta.d(SA) - alpha.d(CT)
%         N   =  g  .rho_local. -------------------------
%                                          dP
%
%  The pressure increment, dP, in the above formula is in Pa, so that it is
%  10^4 times the pressure increment dp in dbar. 
%
%  Note. This routine uses rho from "gsw_rho", which is the computationally
%  efficient 48-term expression for density in terms of SA, CT and p.  The    
%  48-term equation has been fitted in a restricted range of parameter 
%  space, and is most accurate inside the "oceanographic funnel" described 
%  in McDougall et al. (2011).  The GSW library function 
%  "gsw_infunnel(SA,CT,p)" is avaialble to be used if one wants to test if 
%  some of one's data lies outside this "funnel".  
%
% INPUT:  
%  SA  =  Absolute Salinity                                        [ g/kg ]
%  CT  =  Conservative Temperature (ITS-90)                       [ deg C ]
%  p   =  sea pressure                                             [ dbar ]
%         ( i.e. absolute pressure - 10.1325 dbar )
%
% OPTIONAL:
%  lat  =  latitude in decimal degrees north                [ -90 ... +90 ]
%  Note. If lat is not supplied, a default gravitational acceleration
%    of 9.7963 m/s^2 (Griffies, 2004) will be applied.
%
%  SA & CT need to have the same dimensions. 
%  p & lat (if provided) may have dimensions 1x1 or Mx1 or 1xN or MxN, 
%  where SA & CT are MxN.
%
% OUTPUT:
%  N2       =  minimum Brunt-Vaisala Frequency squared            [ 1/s^2 ]
%  N2_p     =  pressure of minimum N2                              [ dbar ]
%  N2_rho   =  density at the minimum N2                          [ kg/m3 ]
%  N2_alpha =  thermal expansion coefficient with respect           [ 1/K ]
%              to Conservative Temperature at the minimum N2
%  N2_beta  =  saline contraction coefficient at constant          [ kg/g ]
%              Conservative Temperature at the minimum N2
%
% AUTHOR:  
%  Trevor McDougall and Paul Barker                    [ help@teos-10.org ]
%
% VERSION NUMBER: 3.01 (16th April, 2012)
%
% REFERENCES:
%  Griffies, S. M., 2004: Fundamentals of Ocean Climate Models. Princeton, 
%   NJ: Princeton University Press, 518 pp + xxxiv.
%   
%  IOC, SCOR and IAPSO, 2010: The international thermodynamic equation of 
%   seawater - 2010: Calculation and use of thermodynamic properties.  
%   Intergovernmental Oceanographic Commission, Manuals and Guides No. 56,
%   UNESCO (English), 196 pp.  Available from http://www.TEOS-10.org
%    See section 3.10 and Eqn. (3.10.2) of this TEOS-10 Manual. 
%
%  McDougall T.J., P.M. Barker, R. Feistel and D.R. Jackett, 2013:  A 
%   computationally efficient 48-term expression for the density of 
%   seawater in terms of Conservative Temperature, and related properties
%   of seawater.  To be submitted to J. Atm. Ocean. Technol., xx, yyy-zzz.
%
%   The software is available from http://www.TEOS-10.org
%
%==========================================================================

%--------------------------------------------------------------------------
% Check variables and resize if necessary
%--------------------------------------------------------------------------

if ~(nargin == 3 | nargin == 4)
   error('gsw_Nsquared:  Requires three or four inputs')
end %if
if ~(nargout >= 2)
   error('gsw_Nsquared:  Requires at least two outputs')
end %if

[ms,ns] = size(SA);
[mt,nt] = size(CT);
[mp,np] = size(p);

if (mt ~= ms | nt ~= ns)
    error('gsw_Nsquared: SA and CT must have same dimensions')
end

if (ms*ns == 1)
    error('gsw_Nsquared: There must be at least 2 bottles')
end

if (mp == 1) & (np == 1)              % p is a scalar - must be two bottles
    error('gsw_Nsquared:  There must be at least 2 bottles')
elseif (ns == np) & (mp == 1)         % p is row vector,
    p = p(ones(1,ms), :);              % copy down each column.
elseif (ms == mp) & (np == 1)         % p is column vector,
    p = p(:,ones(1,ns));               % copy across each row.
elseif (ns == mp) & (np == 1)          % p is a transposed row vector,
    p = p.';                              % transposed then
    p = p(ones(1,ms), :);                % copy down each column.
elseif (ms == mp) & (ns == np)
    % ok
else
    error('gsw_Nsquared: Inputs array dimensions arguments do not agree')
end %if

if ms == 1
    SA = SA.';
    CT = CT.';
    p = p.';
    transposed = 1;
else
    transposed = 0;
end

[mp,np] = size(p);

if exist('lat','var')
    if transposed
        lat = lat.';
    end
    [mL,nL] = size(lat);
    [ms,ns] = size(SA);
    if (mL == 1) & (nL == 1)              % lat scalar - fill to size of SA
        lat = lat*ones(size(SA));
    elseif (ns == nL) & (mL == 1)         % lat is row vector,
        lat = lat(ones(1,ms), :);          % copy down each column.
    elseif (ms == mL) & (nL == 1)         % lat is column vector,
        lat = lat(:,ones(1,ns));           % copy across each row.
    elseif (ms == mL) & (ns == nL)
        % ok
    else
        error('gsw_Nsquared: Inputs array dimensions arguments do not agree')
    end %if
    grav = gsw_grav(lat,p);
else
    grav = 9.7963*ones(size(p));             % (Griffies, 2004)
end %if

%--------------------------------------------------------------------------
% Start of the calculation
%--------------------------------------------------------------------------

db2Pa = 1e4;
Ishallow = 1:(mp-1);
Ideep = 2:mp;

dp = (p(Ideep,:) - p(Ishallow,:));

dSA = (SA(Ideep,:) - SA(Ishallow,:));
dCT = (CT(Ideep,:) - CT(Ishallow,:));

[rho_bottle, alpha_bottle, beta_bottle] = gsw_rho_alpha_beta(SA,CT,p);

N2_shallow = (grav(Ishallow,:).*grav(Ishallow,:)).*(rho_bottle(Ishallow,:)./(db2Pa*dp)).*(beta_bottle(Ishallow,:).*dSA - alpha_bottle(Ishallow,:).*dCT);
N2_deep = (grav(Ideep,:).*grav(Ideep,:)).*(rho_bottle(Ideep,:)./(db2Pa*dp)).*(beta_bottle(Ideep,:).*dSA - alpha_bottle(Ideep,:).*dCT);

N2 = nan(mp-1,np);
N2_p = nan(mp-1,np);
N2_rho = nan(mp-1,np);
N2_alpha = nan(mp-1,np);
N2_beta = nan(mp-1,np);

for Iprofile = 1:np
    dummy_N2 = [N2_shallow(:,Iprofile).';N2_deep(:,Iprofile).']';
    dummy_p = [p(Ishallow,Iprofile)';p(Ideep,Iprofile)']';
    dummy_rho = [rho_bottle(Ishallow,Iprofile)';rho_bottle(Ideep,Iprofile)']';
    dummy_alpha = [alpha_bottle(Ishallow,Iprofile)';alpha_bottle(Ideep,Iprofile)']';
    dummy_beta = [beta_bottle(Ishallow,Iprofile)';beta_bottle(Ideep,Iprofile)']';

    [N2(:,Iprofile),IN2] = min(dummy_N2,[],2);
    
    for Ibottle = 1:mp-1
        N2_p(Ibottle,Iprofile) = dummy_p(Ibottle,IN2(Ibottle));
        N2_rho(Ibottle,Iprofile) = dummy_rho(Ibottle,IN2(Ibottle));
        N2_alpha(Ibottle,Iprofile) = dummy_alpha(Ibottle,IN2(Ibottle));
        N2_beta(Ibottle,Iprofile) = dummy_beta(Ibottle,IN2(Ibottle));
    end
end

if transposed
    N2 = N2.';
    N2_p = N2_p.';
    N2_rho = N2_rho.';
    N2_alpha = N2_alpha.';
    N2_beta = N2_beta.';
end

end