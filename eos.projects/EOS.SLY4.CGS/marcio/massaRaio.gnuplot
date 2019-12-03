#
#
# massaRaio.gnuplot - Generates the mass x radius plot
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

#Parte Inferior
reset

set xlabel 'Raio' font "Helvetica,20"

set ylabel 'Massa' font "Helvetica,20"

#set xrange[1:12000]
#set yrange[1e-5:3]

#set xrange[0:30]

#set log x
#set log y

set encoding iso
set terminal post eps enhanced mono
set output './massaraio.eps' 

set style fill pattern 7


set title 'Massa Raio'

plot './2massa-raio-rhoc.dat' using 1:2  title 'Massa/Raio'
