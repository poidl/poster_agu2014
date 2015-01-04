datasets=( \
jackett96 \
nemo_4deg \
wghc_4deg \
woa13_4deg \
)

methods=( \
gamma_n \
gamma_i_v1 \
gamma_i_v2 \
)

prefix="field_on_omega"

rm -r $prefix
mkdir $prefix

for meth in ${methods[*]}
do
	pdfs=()
	for ds in ${datasets[*]}
	do
		pdfs+=($(ls ../$ds/$meth/$prefix*))
	done
	
	file="$prefix/""$prefix""_""$meth"".txt"
	touch $file
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

	#file="b/$item.txt"
	#touch $file
	#pdfs=($(ls $mypath/$item*))
	#cnt=0
	#for pdf in ${pdfs[*]}
	#do
		#cnt=$[cnt + 1]
		#echo "\includepdf{""$pdf""}" >> $file
		#if [[ "$cnt" -eq 5 ]]; then
			#echo "\clearpage" >> $file
			#cnt=0
		#fi
	#done
#./latex_txt2tex.sh $file
