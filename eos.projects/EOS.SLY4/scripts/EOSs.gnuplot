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

set xlabel 'log P' font "Helvetica,20"

set ylabel 'log \rho' font "Helvetica,20"

set yrange[1e33:1e38] reverse
#set xrange[0:2e15]

set log x
set log y

set encoding iso
set terminal post eps enhanced mono
set output './EoSs.eps'

set style fill pattern 7


set title 'EoSs'


plot '../Sly4.CGS.csv' using 1:2  title 'Sly4' with lines
	

