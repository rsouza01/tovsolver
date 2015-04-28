reset

set xrange[1.6:1.62]
set yrange[1e-05:0.01]

#set xrange[0:30]

#set log x
set log y

set xlabel 'Rho' font "Helvetica,20"
set ylabel 'Raio' font "Helvetica,20"

set encoding iso
set terminal post eps enhanced mono
set output 'raioRho.eps' 

set title 'Raio x Densidade'

plot './output/out_1.682840634991866182e+03.txt' using 1:3  title 'Massa/Rho'
