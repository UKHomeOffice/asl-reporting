set terminal svg enhanced size 800,600
set output 'file.svg'
set title "ASL Digital Burnup Chart" font "Serif,32"

set timefmt "%Y%m%d"
set format x "%d-%b-%y"
set xdata time
set xrange ["20200101":"20201231"]
set yrange [0:1700]
set xtics font ", 16"
set xtics rotate by 45 right
set xtics nomirror "20200101",2592000, "20201231"
set mxtics 4
set ytics 

set style line 1 lt 1 lw 2 pt 3 ps 0.5
set style line 2 lt 2 lw 2 pt 3 ps 0.5
set style line 3 lt 3 lw 2 pt 3 ps 0.5
set style line 4 lt 4 lw 2 pt 3 ps 0.5
set style line 5 lt 8 lw 2 pt 3 ps 0.5
set style line 6 lt 6 lw 2 pt 3 ps 0.5
set style line 7 lt 7 lw 2 pt 3 ps 0.5


plot datafile using 1:2 with lines ls 7 title 'Done',\
datafile using 1:3 with lines ls 6 title "Total Backlog"

