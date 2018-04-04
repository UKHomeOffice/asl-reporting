set terminal png size 800,600 enhanced font "Serif,10"
set title "Development Team Project Weather"
set output 'weather.png'
set xdata time
set timefmt "%d/%m/%Y"
set xtics rotate
set xrange ["01/01/2018":"30/06/2018"]
set xtics "01/01/2018", 1209600, "30/06/2018"
set xtics font "Serif,10"
plot "weather.dat" using 1:2 with lines title "Weather Score"
