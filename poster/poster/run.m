restoredefaultpath
addpath(genpath('../gsw_matlab_v3_02'))
addpath(genpath('../data/get_input_data'))
addpath(genpath('../gamma_n'))
addpath(genpath('../neutral_common'))
%addpath(genpath('../poisson/exp015'))
addpath(genpath('../gamma_i/gamma_i_utils/exp048'))
%addpath(genpath('../omega/ansu_utils/exp644'))
addpath(genpath('.'))

make_dir('./data_out');
make_dir('./data');

%methods={'gamma_n','gamma_i','ew99','ew99mod','sig0','sig2','sig4'};
%methods={'gamma_n','ew99','ew99mod','sig0','sig2','sig4'};
%methods={'gamma_n'};
methods={'gamma_i'};
%datasets={'jackett96','woa13_4deg','wghc_4deg','nemo_4deg'};
datasets={'jackett96'};
%datasets={'wghc_4deg'};
run_fields(methods,datasets);
%run_error(methods,datasets);
%omega_surfaces(datasets);
%run_error_grid(methods,datasets);
%error_iso_averaged(methods,datasets);
% stats_pdf_values(methods,datasets);
%error_depth_averaged(methods,datasets);
% stats_pdf_error(methods,datasets);
% stats_percent_larger(methods,datasets);

%get_std_on_omega(methods,datasets);
%plot_std_on_omega(methods,datasets);
%stats_nonpositive_values(methods,datasets);

%rms_dp_to_omega(methods,datasets)
%plot_rms_dp_to_omega(methods,datasets)
%instabilities_dep_vs_lat(methods,datasets)
