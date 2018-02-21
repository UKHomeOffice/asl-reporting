set terminal png size 800,600 enhanced font "Serif,10"
set title "Risk Monitoring Chart"
set output 'risk.png'
set xdata time
set timefmt "%d/%m/%Y"
set xtics rotate
set xrange ["01/01/2018":"30/06/2018"]
set yrange ["0":"10000"]
set xtics "01/01/2018", 1209600, "30/06/2018"
set xtics font "Serif,10"
plot "risk.csv" using 1:2 with lines title "Risk Exposure"
