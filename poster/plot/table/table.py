#!/usr/bin/python
import sys, os
import numpy as np

ds = sys.argv[1] # data set
#ds ='idealized01'
ds_dir = '../../data_out/'+ds # data set directory
f1=ds_dir+'/gamma_i_v1/runtime_root.txt'
f2=ds_dir+'/gamma_i_v1/runtime_lsqr.txt'
#f3=ds_dir+'/ew99_v2/runtime_lsqr.txt'
f4=ds_dir+'/ew99mod_v2/runtime_lsqr.txt'
f5=ds_dir+'/sig0/runtime_sig0.txt'

f6=ds_dir+'/gamma_i_v1/nit.txt'
f7=ds_dir+'/ew99mod_v2/nit.txt'


gr=np.loadtxt(f1)
gl=np.loadtxt(f2)
#ew=np.loadtxt(f3)
ewm=np.loadtxt(f4)
sig=np.loadtxt(f5)

g_nit=np.loadtxt(f6)
ewm_nit=np.loadtxt(f7)


s=[]; ncol=5
s.append( ' \\begin{table} ' )
s.append( ' \centering ' )
s.append( ' \\begin{tabular}{l'+ 'c'*(ncol-1) +'} ' )
s.append( ' \\toprule ' )
s.append( ' \\multicolumn{5}{c}{MATLAB runtime (sec) for dataset \\lstinline{'+ds+'}}  \\\\' )
#s.append( ' \\toprule ' )
s.append( ' \cmidrule{1-5} ' )
s.append( ' & {Root finding   }& {  LSQR   } &  {NIT(LSQR)} & {  Total   }\\\\ ' )
s.append( ' \cmidrule{2-5} ' )
def sstr(x,p):
    fs='%.'+str(int(p))+'f'
    return fs% x
s.append( ' $\gamma^n$ & $\\approx$'+sstr(gr/4.,2)+' & n/a & n/a & $\\approx$'+sstr(gr/4.,2)+' \\\\' )
s.append( ' $\gamma^i$ & '+sstr(gr,2)+' & '+sstr(gl,2)+' & '+sstr(g_nit,2)+' & '+sstr(gr+gl,2)+'\\\\' )
#s.append( ' $\gamma^{EW}$ &  n/a  & '+sstr(ew,2)+' & '+sstr(ew,2)+' \\\\' )
s.append( ' $\gamma^{EWmod}$ &  n/a  & '+sstr(np.sum(ewm),2)+' & '+sstr(np.sum(ewm_nit),2)+' & '+sstr(np.sum(ewm),2)+' \\\\' )
s.append( ' $\sigma_0$ &  n/a  &  n/a &  n/a  & '+sstr(sig,2)+' \\\\' )
s.append( ' \end{tabular} ' )
s.append( ' \end{table} ' )


f = open('./'+ds+'.txt', "w")
for st in s:
	print st
        f.write(st+'\n')
f.close()


# def volume_flux(sname,gname,tind,lonind):
#
# 	return U1m, U2m, U1std, U2std
#
#
#
#
# stats=[[] for i in range(len(vec))]
# for jj in range(len(vec)):
#
#         stats[jj]=[em[0],em[1],em[2],U1m, U1m,\
# 			sd_e[0],sd_e[1],sd_e[2], U1std]
#
# for st in stats:
# 	st[4]=(st[4]/stats[0][3]) #ratio maximal exchange
#
# s=[]; ncol=10
# s.append( ' \\begin{table}\\scriptsize ' )
# s.append( ' \centering ' )
# s.append( ' \\begin{tabular}{'+ 'c'*ncol +'} ' )
# s.append( ' \\toprule ' )
# s.append( ' &\multicolumn{4}{c}{Mean}& $\overline{Q_1}/\overline{Q_1}^{max}$ &\multicolumn{4}{c}{Standard Deviation}\\\\ ' )
# s.append( ' \cmidrule{2-10} ' )
# s.append( ' & \multicolumn{3}{c}{$\eta$} & $Q_1$ &  & \multicolumn{3}{c}{$\eta$} & $Q_1$ \\\\ ')
# s.append( ' \cmidrule{2-10} ' )
# s.append( ' &Sill&Contraction&Exit& & &Sill&Contraction&Exit&  \\\\ ' )
# s.append( ' \cmidrule{2-10} ' )
# label=['BASIC-20','BASIC-40','BASIC-60','BASIC-80']
# def sstr(x,p):
# 	fs='%.'+str(int(p))+'f'
# 	return fs% x
# precision=[1,1,1,3,3,  2,2,2,3]
# for ii in range(len(label)):
# 	sl=label[ii]
# 	for st,jj in zip(stats[ii],precision):
# 		sl=sl+'&'
# 		sl=sl+sstr(st,jj)
#         sl=sl+'\\\\'
#         s.append(sl)
# s.append( ' \end{tabular} ' )
# s.append( ' \end{table} ' )
#
#
# f = open("./tables_tex/table"+str(vec[0])+'_'+str(vec[-1])+'.txt', "w")
# for st in s:
# 	print st
#         f.write(st+'\n')
# f.close()

