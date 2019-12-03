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


set datafile separator ","

set encoding iso
set terminal post eps enhanced mono
set style fill pattern 7

####################################################################################################

set xlabel 'Raio' font "Helvetica,20"
set ylabel 'Massa' font "Helvetica,20"

set output '../plot/massaRaio.eps' 

# set xrange[0:11]
# set yrange[0:2.3]

set title 'Massa Raio'

plot './output/starStructureOutput.csv' using 3:4 with points lt rgb "blue" pointtype 7 ps 0.2 title 'MFT QCD'
