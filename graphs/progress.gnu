set terminal png size 800,600 enhanced font "Serif,10"
set output 'progress.png'
set key left

set xtics rotate
set grid y
set style data histograms
set style histogram rowstacked
set boxwidth 0.5
set style fill solid 1.0 border -1
set ytics 10 nomirror
set yrange [:600]
set ylabel "Number of Issues"
set ytics 10

plot 'progress.dat' using 2 t "Done", '' using 3 t "Doing", '' using 4:xtic(1) t "ToDo"
