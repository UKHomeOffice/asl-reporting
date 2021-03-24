set terminal png size 800,600 enhanced font "Serif,10"
if (!exists("filename")) filename='roadmap.dat'
set output 'roadmapVisualisation.png' 
set yrange [0 to 5000]
set style fill solid
set style data histogram
set style histogram rowstack gap 1
set style fill solid border -1
set boxwidth 0.9
set key autotitle columnheader
set xtics border in scale 0,0 nomirror rotate by -45  autojustify
set title '24th March 2021' 
plot filename using 2:xtic(1) ti col , '' using 3 ti col, '' using 4 ti col
