#
#
# massaRho.gnuplot - Generates the mass x density plot
#
# Author: 	Rodrigo Alvares de Souza
#			rsouza01@gmail.com
#
#
# History:
# Version 0.1: 2013/?     (rsouza) - Creating the file.
# Version 0.2: 2015/06/09 (rsouza) - Minor bug fixes.
#
##

reset

set xrange[0:1]
set yrange[1e-5:0.008]

#set xrange[0:30]

#set log x
set log y

set xlabel 'Rho' font "Helvetica,20"
set ylabel 'Massa' font "Helvetica,20"

set encoding iso
set terminal post eps enhanced mono
set output 'massaRho.eps' 

set title 'Massa x Densidade'

plot '../output/massRho.csv' using 1:2  title 'Massa/Rho'
