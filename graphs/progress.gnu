set terminal png size 800,600 enhanced font "Serif,10"
set output 'progress.png'
set key left

set timefmt "%Y%m%d"
set xtics rotate
set grid y
set style fill solid 1.0 border -1
set ytics 50 nomirror
set yrange [:2000]
set ylabel "Number of Issues"

# This won't affect histogram plots since they just treat the
# dates in the first columns as literal strings.
set format x "%d-%b-%y" 

# Setting xdata to time precludes the use of histograms.
set xdata time

# 1 week = 604,800 seconds.
# Make the box 50% of its slot.
set boxwidth 302400 absolute

# ($2+$3) is an expression meaning 'add the values in column 2 and
# column 3'; this is effectively the same as row-stacking.
# Data-series should be given in order of decreasing magnitude.
plot "progress.dat" using 1:($2+$3+$4) with boxes lc rgb "purple" title "To Do", \
	"" using 1:($2+$3) with boxes lc rgb "grey" title "Doing", \
	"" using 1:2 with boxes lc rgb "blue" title "Done"
