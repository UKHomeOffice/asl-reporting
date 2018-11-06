set terminal png size 800,600 enhanced font "Serif,10"
set title "Risk Monitoring Chart"
set format x "%d-%b-%y"
set output 'risk.png'
set xdata time
set timefmt "%Y%m%d"
set xtics rotate
set xrange ["20180101":"20181231"]
set yrange ["0":"12000"]
set xtics "20180101", 1209600, "20181231"
set xtics font "Serif,10"
plot "risk.dat" using 1:2 with lines title "Risk Exposure"
