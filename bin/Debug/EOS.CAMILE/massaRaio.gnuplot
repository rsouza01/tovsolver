#Parte Inferior
reset

set xlabel 'Raio' font "Helvetica,20"

set ylabel 'Massa' font "Helvetica,20"

#set xrange[1:12000]
#set yrange[1e-5:3]

set xrange[0:25]

#set log x
#set log y

set encoding iso
set terminal post eps enhanced mono
set output 'massaRaio.eps' 

set style fill pattern 7


set title 'Massa Raio'

plot './output/RHOc-Pc-R-M-H-D-C.csv' using 3:4  title 'Massa/Raio'
