mypath=/home/nfs/z3439823/mymatlab/poster/figures

docs=( \
#field_jackett96_ew99_v2 \#
#field_jackett96_ew99mod_v2 \#
field_jackett96_gamma_i_v1 \
field_jackett96_gamma_i_v2 \
field_jackett96_gamma_n \
\
#field_nemo_4deg_ew99_v2 \#
#field_nemo_4deg_ew99mod_v2 \#
field_nemo_4deg_gamma_i_v1 \
field_nemo_4deg_gamma_i_v2 \
field_nemo_4deg_gamma_n \
\
#field_wghc_4deg_ew99_v2 \#
#field_wghc_4deg_ew99mod_v2 \#
field_wghc_4deg_gamma_i_v1 \
field_wghc_4deg_gamma_i_v2 \
field_wghc_4deg_gamma_n \
\
#field_woa13_4deg_ew99_v2 \#
#field_woa13_4deg_ew99mod_v2 \#
field_woa13_4deg_gamma_i_v1 \
field_woa13_4deg_gamma_i_v2 \
field_woa13_4deg_gamma_n \
)

rm field/*
for item in ${docs[*]}
do
	file="field/$item.txt"
	touch $file
	pdfs=($(ls $mypath/$item*))
	cnt=0
	for pdf in ${pdfs[*]}
	do
		cnt=$[cnt + 1]
		echo "\includepdf{""$pdf""}" >> $file
		if [[ "$cnt" -eq 5 ]]; then
			echo "\clearpage" >> $file
			cnt=0
		fi
	done
./latex_txt2tex.sh $file
done
