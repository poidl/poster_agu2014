mypath=/home/nfs/z3439823/mymatlab/poster/figures

datasets=( \
# jackett96 \ #
wghc_1deg \
woa13_1deg \
nemo_1deg \
)


texfile="tables.tex"
rm $texfile	
cat latex_header >> $texfile

for ds in ${datasets[*]}
do
	echo $ds
	./table.py $ds
	file="$ds.txt"
	echo " ">>$texfile
	cat $file>> $texfile
	echo " ">>$texfile
done

cat latex_footer >> $texfile
pdflatex $texfile
