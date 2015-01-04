mypath=/home/nfs/z3439823/mymatlab/poster/figures

docs=( \
b_jackett96_ew99_v2 \
b_jackett96_ew99_mod_v2 \
b_jackett96_gamma_i \
b_jackett96_gamma_n \
)

for item in ${docs[*]}
do
	file="$item.txt"
	touch $file
	pdfs=($(ls $mypath/$item*))
	cnt=0
	for pdf in ${pdfs[*]}
	do
		cnt=$[cnt + 1]
		echo "\includepdf{""$pdf""}" > $file
		if [[ "$cnt" -eq 5 ]]; then
			echo "\clearpage" > $file
			cnt=0
		fi
	done
./latex_txt2tex.sh $file
done
