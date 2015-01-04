function gam=lsqr_submit(A,y,nit,gamma_initial)


disp('starting LSQR()')
tic
[gam,flag,relres,iter,resvec,lsvec] = lsqr(A,y,1e-15,nit,[],[],gamma_initial);
exec_time_write('data/exec_time/runtime_lsqr.txt',toc)
nit_done=length(lsvec); % number if iterations
write_scalar('data/exec_time/nit.txt',nit_done);
display(['LSQR() took ',num2str(toc),' seconds for ',num2str(nit_done),' iterations']);
%keyboard
if length(lsvec)==length(resvec)
    mynorm=lsvec./resvec;
else
    mynorm=lsvec./resvec(2:end);
end
disp(['Arnorm/(anorm*rnorm) final: ', num2str(mynorm(end))])
disp(['Flag: ', num2str(flag)])
save('data/mynorm.mat','mynorm')

%save(['data/gamma_p_',num2str(ii),'.mat'])
