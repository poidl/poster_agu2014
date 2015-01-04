function pis = depth_iso_simple(fs,ps,f,p,derr)

    % This is quickly adapted from depth_ntp_simple.m,
    % in which f=f(s,ct,p) and the goal is to have as few evaluations of f as possible.
    % Here, f is given, so this may be unnecessarily complicated. Bisection
    % is not necessary, just find the closest zero crossing and do linear
    % interpolation in between.

    % search in one direction only, based on the initial value of F (at bottle
    % depth). Note that this function will generally not find all zero
    % crossings (possibly including stable ones), and may find unstable zero crossings.

%    omega_user_input; % get delta
    delta=1e-11;
%warning('delta may be inappropriate')

%     if nargin==6
%         drho=0*s0; % drho is a zero vector
%     end
    
    nxy=size(f,2);

    inds=1:nxy;

    pis = nan(1,nxy);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % discard land; inds contains the indices of remaining points
    [fs,ps,f,p,derr,inds]=discard_land_iso(fs,ps,f,p,derr,inds);

    nz=size(f,1);
    nxy=size(f,2);
    inds_wet=1:nxy;

    p0_stacked=repmat(ps(:)',[nz 1]);

    k=sum(p0_stacked>=p,1); % adjacent bottle looking up. values 1 to nz.
    k3d=k+nz*(0:nxy-1); % 3-d
    kinc=nan*ones(1,nxy); % increment of k

    f_=f(k3d);
    p_=p(k3d);
    searched=~isnan(f_);
    %%%%%%%%%%%%%%%%%%%%%%%%
    ww=~isnan(f);
    cs=cumsum(ww,1);
    su=ones(size(cs));
    su(cs~=0)=0;
    kf=sum(su,1)+1; % vertical index of shallowest data point
    if any(kf<1| kf>nz)
        error('something is wrong') % land should have been discarded above
    end
    stmp=f(end:-1:1,:,:);
    ww=~isnan(stmp);
    cs=cumsum(ww,1);
    su=ones(size(cs));
    su(cs~=0)=0;
    kl=sum(su,1)+1; 
    kl=nz-kl+1;% vertical index of deepest data point
    if any(kl<1| kl>nz)
        error('something is wrong') % land should have been discarded above
    end
    %keyboard
    %kf3d=kf+nz*(0:nxy-1); % 3-d
    %%%%%%%%%%%%%%%%%%%%%%%%

    go_shallow_old=false(1,nxy);
    go_deep_old=false(1,nxy);

    bisect=false(1,nxy);
    done=false(1,nxy);
    cnt=0;

    while any(~done)
        cnt=cnt+1;
        bottle = fs;
        cast=f_;
%keyboard
        F=cast-bottle+derr;

        go_shallow = F >=  delta; % go shallower to find first bottle pair
        go_deep    = F <= -delta; % go deeper to find first bottle pair

    %    if cnt==1
    %keyboard

            searched(~isnan(F))=true;
            % F is nan at the current depth but well defined elsewhere in the
            % watercolumn
            
            nskip_up=k(inds_wet)-kl(inds_wet);
            nskip_down=kf(inds_wet)-k(inds_wet);        
            go_shallow_nan= isnan(F)  & ~searched & (nskip_up>0); 
            go_deep_nan= isnan(F) & ~searched & (nskip_down>0);
            % fix for floating nans in gamma_i fields:
            % the past few lines do not work if the starting point is nan,
            % but there are well defined values above AND below that nan (a
            % case which can't happen for s,t,p data, and which should not
            % happen in gamma code. but does happen in gamma_i).
            trouble=kf(inds_wet)<k(inds_wet) & k(inds_wet)<kl(inds_wet);
            trouble= isnan(F)  & ~searched & trouble;
            if any(trouble)
                % usually not good to call this function on non-monotonous
                % second argument...
                pis_trouble=var_on_surf_stef(p(:,inds_wet(trouble)),f(:,inds_wet(trouble)),fs(inds_wet(trouble)));
            end
            
            go_shallow=go_shallow | go_shallow_nan;
            go_deep=go_deep | go_deep_nan;        
    %     else
    %         keyboard
    %         go_shallow(search_initial)=go_shallow(search_initial) | (isnan(F(search_initial)) & (k_>kf_));
    %         go_deep(search_initial)=go_deep(search_initial) | (isnan(F(search_initial)) & (k_<kf_));
    %     end

        final= abs(F)<delta; % hit zero

        pis(inds(inds_wet(final)))=p_(final);
        
        % fix floating nans
        if any(trouble)
            pis(inds(inds_wet(trouble)))=pis_trouble;
            final=final|trouble;
        end

        cfb = (go_shallow_old & go_deep & searched); % crossed from below
        cfa = (go_deep_old & go_shallow & searched); % crossed from above
        crossed= cfb|cfa;
        start_bis = (crossed & ~bisect); % start bisection here
        bisect = (bisect | start_bis); % bisect here

        search_initial = (go_deep|go_shallow) & ~bisect & ~final;

        kinc(inds_wet(go_deep & search_initial))= 1;
        kinc(inds_wet(go_shallow & search_initial))=-1;

        kinc(inds_wet(go_deep_nan & search_initial))= nskip_down(inds_wet(go_deep_nan & search_initial));
        kinc(inds_wet(go_shallow_nan & search_initial))=-nskip_up(inds_wet(go_shallow_nan & search_initial));   


        k=k+kinc;
        k3d=k3d+kinc;
        k_=k(inds_wet(search_initial));%+kinc(inds_wet(search_initial)); %_i
        k3d_=k3d(inds_wet(search_initial));%+kinc(inds_wet(search_initial)); %_i
        %kf_=kf(inds_wet(search_initial));%+kinc(inds_wet(search_initial));

        out=(k_<1)|(k_>nz); % above or below domain %_i
        out2=false(1,length(final)); %_bi
        out2(search_initial)= out; %_bi

        %done=isnan(F)|final|out2; 
        %keyboard
        done=(isnan(F) & searched) |final|out2; %_bi

        k3d_=k3d_(~out);   
        search_initial=search_initial(~done);
        bisect=bisect(~done);
        crossed=crossed(~done);
        searched=searched(~done);

        %disp(cnt)
        %keyboard
        if ~all((search_initial & ~bisect) | (~search_initial & bisect)) % either bisect or keep searching
            error('something is wrong')
        end  

        if cnt>1
            f1=f1(~done);
            p1=p1(~done);
            f2=f2(~done);
            p2=p2(~done);
            f2(crossed)=f1(crossed);
            p2(crossed)=p1(crossed);
        else
            f2=f_(~done);
            p2=p_(~done);
        end
        f1=f_(~done);  
        p1=p_(~done);
    %%%%%%%%%%%%%%%%%%
    % data for next evaluation of F
        fs=fs(~done);

        derr=derr(~done);
        f_=nan*ones(1,sum(~done));
        p_=nan*ones(1,sum(~done));
        f_(search_initial)=f(k3d_); 
        p_(search_initial)=p(k3d_);

        if any(bisect)
            f_(bisect) =0.5*(f1(bisect) +f2(bisect));
            p_(bisect) =0.5*(p1(bisect) +p2(bisect));
        end
    %%%%%%%%%%%%%%%%%%    

        go_shallow_old=go_shallow(~done);
        go_deep_old=go_deep(~done);

        inds_wet=inds_wet(~done);   
    end

end




function [fs,ps,field,p,derr,inds]=discard_land_iso(fs,ps,field,p,derr,inds)
    iwet=~isnan(fs);

    iland=all(isnan(field));
    iwet=iwet & ~iland;
    
    fs=fs(iwet);
    ps=ps(iwet);
    derr=derr(iwet);
    field=field(:,iwet);
    p=p(:,iwet);
    inds=inds(iwet);
end
