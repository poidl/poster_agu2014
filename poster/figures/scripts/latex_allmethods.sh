datasets=( \
jackett96 \
nemo_4deg \
wghc_4deg \
woa13_4deg \
)

prefixes=( \
error_depth_averaged \
error_iso_averaged_df error_iso_averaged_erms \
stats_pdf_error stats_pdf_values \
stats_percent_larger \
instabilities_dep_vs_lat \
instabilities_percent \
stats_nonpositive_values \
std_on_omega \
)

for prefix in ${prefixes[*]}
do
	pdfs=()
	for ds in ${datasets[*]}
	do
		pdfs+=($(ls ../$ds/$prefix*))
	done
	
	file="./allmethods/""$prefix"".txt"
	touch $file
	cnt=0
	for pdf in ${pdfs[*]}
	do
		echo $pdf
		cnt=$[cnt + 1]
		echo "\includepdf{""$pdf""}" >> $file
		if [[ "$cnt" -eq 5 ]]; then
			echo "\clearpage" >> $file
			cnt=0
		fi		
	done
	./latex_txt2tex.sh $file
done
