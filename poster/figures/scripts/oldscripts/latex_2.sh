mypath=/home/nfs/z3439823/mymatlab/poster/figures

docs=( \
error_depth_averaged \
error_iso_averaged_df error_iso_averaged_erms \
stats_pdf_error stats_pdf_values \
stats_percent_larger \
instabilities_dep_vs_lat \
instabilities_percent \
stats_nonpositive_values \
std_on_omega \
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
		./latex_dumpfigure.sh $pdf $file
		if [[ "$cnt" -eq 5 ]]; then
			echo "\clearpage" >> $file
			cnt=0
		fi
	done
./latex_txt2tex.sh $file
done


