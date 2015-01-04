clear all
close all
restoredefaultpath
addpath(genpath('.'))
addpath(genpath('../mymatlab/gsw_matlab_v3_04'))
%addpath(genpath('../mymatlab/gamma_n'))

make_dir('./data_out');
make_dir('./data');


%methods={'gamma_n','gamma_i','ew99_v2','ew99mod_v2','sig0','sig2','sig4'};
%methods={'gamma_n','gamma_i_v1','gamma_i_v2'};
%methods={'gamma_n','gamma_i_v1','ew99_v2','ew99mod_v2','sig0','sig2','sig4'};
methods={'gamma_i_v1','ew99mod_v2','sig2'};
%methods={'ew99mod_v2'};
%methods={'gamma_i_v1'}
%methods={'ew99_v2','ew99mod_v2','ew99_v3','ew99mod_v3'};
%methods={'ew99_v2','ew99_v3'};
%methods={'ew99_v3','ew99mod_v3'};
%methods={'ew99mod_v3'};
%methods={'gamma_n','gamma_i','ew99','ew99mod','ew99_v2','ew99mod_v2','sig0','sig2','sig4'};
%methods={'gamma_i','ew99','ew99mod','ew99_v2','ew99mod_v2','sig0','sig2','sig4'};
%methods={'gamma_i','v2_gamma_i'};
%methods={'ew99_v2','ew99mod_v2'};
%methods={'ew99','ew99_old','ew99mod','ew99mod_old','ew99_v2','ew99mod_v2'};
%methods={'ew99_v2','ew99mod_v2'};
%methods={'sig0'};
%methods={'gamma_i_initial_gamma_n'};
%datasets={'jackett96','woa13_4deg','wghc_4deg','nemo_4deg'};
datasets={'woa13_1deg','wghc_1deg','nemo_1deg'};
%datasets={'wghc_1deg'};
%datasets={'jackett96'};
%datasets={'nemo_4deg','jackett96','woa13_4deg','wghc_4deg'};
%datasets={'woa13_4deg'};
%datasets={'jackett96'}
%datasets={'wghc_4deg'}
%datasets={'idealized01'};
%datasets={'wghc_4deg'};
    %'woa13_4deg'};

run_fields(methods,datasets);
% run_error(methods,datasets);
run_error_grid(methods,datasets);


% error_iso_averaged(methods,datasets);
% error_depth_averaged(methods,datasets);
% stats_pdf_values(methods,datasets);
% stats_pdf_error(methods,datasets);
% stats_pdf_error_allmethods(methods,datasets);
% stats_percent_larger(methods,datasets);
stats_percent_larger_poster();
stats_pdf_error_allmethods_poster();
% stats_nonpositive_values(methods,datasets);
% instabilities_dep_vs_lat(methods,datasets);
% instabilities_percent(methods,datasets);
% plot_b(methods,datasets);
% plot_field(methods,datasets);
% plot_dgdz(methods,datasets);
% plot_bb_section(methods,datasets);

%%%%plot_ct_error(methods,datasets);
% 
% omega_surfaces(datasets);
% get_std_on_omega(methods,datasets);
% plot_std_on_omega(methods,datasets);
% plot_field_on_omega(methods,datasets);

%rms_dp_to_omega(methods,datasets)
%plot_rms_dp_to_omega(methods,datasets)
%matlab_vs_fortran();

