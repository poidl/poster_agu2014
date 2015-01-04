base=${1%.txt}
if [[ "$1" == *\/* ]]; then
	dir=${1%/*}
else
	dir="./"
fi
echo $dir

fname="${base}"".tex"
#bname=$(basename $fname)
	
touch $fname

cat latex_header >> $fname
cat $1 >> $fname
cat latex_footer >>$fname

pdflatex -output-directory=$dir $fname
rm $dir/*aux
rm $dir/*log
rm $1
rm $dir/*tex

