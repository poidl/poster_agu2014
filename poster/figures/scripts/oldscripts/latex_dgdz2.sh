mypath=/home/nfs/z3439823/mymatlab/poster/figures
#ew99_v2 \
#ew99mod_v2 \

methods=( \
gamma_n \
gamma_i_v1 \
gamma_i_v2 \
)

datasets=( \
jackett96 \
nemo_4deg \
wghc_4deg \
woa13_4deg \
)

for item in ${methods[*]}
do
	file="dgdz/dgdz_$item.txt"
	touch $file
	pdfs=($(ls dgdz/*$item*.pdf))
	cnt=0
	for pdf in ${pdfs[*]}
	do
		cnt=$[cnt + 1]
		echo $pdf
		echo "\includepdf[pages=-]{""$pdf""}" >> $file
		if [[ "$cnt" -eq 5 ]]; then
			echo "\clearpage" >> $file
			cnt=0
		fi
	done
./latex_txt2tex.sh $file
done
