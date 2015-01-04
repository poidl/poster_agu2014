mypath=/home/nfs/z3439823/mymatlab/poster/figures

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
	file="field/field_$item.txt"
	touch $file
	pdfs=($(ls field/*$item*.pdf))
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
