set terminal png size 800,600 enhanced font "Serif,10"
set output 'roadmap.png'
set style fill solid
set style data histogram
set style histogram rowstack gap 1
set style fill solid border -1
set boxwidth 0.9
set key autotitle columnheader
set xtics border in scale 0,0 nomirror rotate by -45  autojustify
plot 'roadmap.dat' using 1 ti col, 2 ti col, '' using 3 ti col, '' using 4 ti col
