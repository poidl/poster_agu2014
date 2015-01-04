function pis=iso_surface_pressure(field,p,point)

% make sure the iso-surface intersects with the point 'point'. Using this
% function only makes sense for fields which are vertically non-monotonous.
% Finding iso-surfaces in vertically monotonous fields is easy.

    omega_user_input;
error('should do mutliple iterations and monitor convergence. Wetting not implemented')
    [nz,ny,nx]=size(p);
    p0=point(1);
    ibb=point(2);

    ps= p0+zeros(ny,nx);
    fs=var_on_surf_stef(field,p,ps);
    ps(isnan(fs))=nan;
    %[sns,ctns,pns] = get_connected(sns,ctns,pns,ibb);

    ds_x=circshift(fs,[0 -1])-fs;
    ds_y=circshift(fs,[-1 0])-fs;
    if ~zonally_periodic;
        ds_x(:,nx) = nan;
    end
    ds_y(ny,:) = nan;

    regions=find_regions(fs);

    [derr,~]=solve_lsqr_iso(regions,ds_x,ds_y,ibb);

    pis=depth_iso_simple(fs(:)',ps(:)',field(:,:),p(:,:),derr(:)');
    pis=reshape(pis,[ny nx]);

end


function [derr,res]=solve_lsqr_iso(regions, xx, yy,ibb)
    omega_user_input;
    clamp_on_point=true;

    [yi,xi]=size(xx);
    derr = nan(yi,xi);

    for iregion=1:length(regions)

        region=regions{iregion};

        % set up east-west equations for weighted inversion
        reg=false(1,xi*yi)';
        reg(region)=true;

        en= reg & circshift(reg,-yi); %  find points between which a zonal gradient can be computed. en is true at a point if its eastward neighbor is in the region

        if no_land_mask % in case there is no land mask (e.g. in a climatology data set with too coarse resolution to represent land)
            % 'en_in_other_basin' is true if there is land (in reality) between this point and its eastern neighbour
            error('find_regions() doesn''t have this functionality yet')
            test=ocean(:).*circshift(ocean(:),-yi);
            en_in_other_basin= (test==5) & reg;
            en(en_in_other_basin)=false;
        end
        if ~zonally_periodic;  % remove equations for eastern boundary for zonally-nonperiodic domain
            en((xi-1)*yi+1:xi*yi)=false;
        end
        sreg=cumsum(reg); % sparse indices of points forming the region (points of non-region are indexed with dummy)
        sreg_en=circshift(sreg,-yi); % sparse indices of eastward neighbours

        j1_ew=sreg_en(en);  % j1 are j-indices for matrix coefficient 1
        j2_ew=sreg(en); % j2 are j-indices for matrix coefficient -1

        % set up north-south equations for weighted inversion
        nn= reg & circshift(reg,-1);
        if no_land_mask % in case there is no land mask (e.g. in a climatology data set with too coarse resolution to represent land)
            % 'nn_in_other_basin' is true if there is land (in reality) between this point and its northern neighbour
            test=ocean(:).*circshift(ocean(:),-1);
            nn_in_other_basin= (test==5) & reg;
            nn(nn_in_other_basin)=false;
        end
        nn(yi:yi:xi*yi)=false; % remove equations for northern boundary
        sreg_nn=circshift(sreg,-1);

        j1_ns=sreg_nn(nn);
        j2_ns=sreg(nn);

        % clamp at point
        if ismember(ibb,region)
            j1_condition=sreg(ibb);
        else
            j1_condition=[1:sum(reg)];
        end

        j1=[j1_ew',j1_ns',j1_condition];
        j2=[j2_ew',j2_ns'];

        i2=1:(sum(en)+sum(nn)); % i-indices for matrix coeff. -1
        if ismember(ibb,region)
            i1=[i2, (sum(en)+sum(nn)+1)]; % i-indices for matrix coeff. 1
        else
            i1=[i2, (sum(en)+sum(nn)+1)*ones(1,sum(reg))]; % i-indices for matrix coeff. 1
        end


        % build sparse matrices
        A=sparse([i1,i2],[j1,j2],[ones(1,length(i1)),-ones(1,length(i2))]);
        b=sparse( [xx(en); yy(nn); 0 ]);

        %disp(['solving for region ',int2str(iregion)]);
        switch solver
            case 'iterative'
                tic
                [x,flag,relres,iter,resvec,lsvec] = lsqr(A,b,1e-15,10000);
                %display(['LSQR() took ',num2str(toc),' seconds for ',num2str(length(lsvec)),' iterations']);
                res=relres;
    %             if flag ~=0 
    %                 disp('LSQR did not converge')
    %                 if flag~=1
    %                     disp('MAXIT WAS NOT REACHED')
    %                 end
    %             end
            case 'exact'
                x = (A'*A)\(A'*b);
        end

        x = full(x)';

        % put density changes calculated by the least-squares solver into
        % their appropriate position in the matrix

        derr(region) = x;

    end
end
