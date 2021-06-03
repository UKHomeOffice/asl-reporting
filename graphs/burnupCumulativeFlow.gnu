set terminal png size 800,600 enhanced font "Serif,10"
if (!exists("filename")) filename='cumulativeFlow.dat'
set output 'cumulativeFlow.png' 
set style fill solid
set style data histogram
set yrange [2000 to 9000]
set style histogram rowstack gap 1
set style fill solid border -1
set boxwidth 0.9
set key autotitle columnheader
set xtics border in scale 0,0 nomirror rotate by -45  autojustify
set title '2nd June 2021' 
plot filename using 2:xtic(1) ti col , '' using 3 ti col, '' using 4 ti col
