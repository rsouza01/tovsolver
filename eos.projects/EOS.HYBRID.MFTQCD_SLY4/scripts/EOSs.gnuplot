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

#set yrange[0:2e35]
#set xrange[0:2e15]

set log x
set log y

set encoding iso
set terminal post eps enhanced mono
set output './EoSs.eps'

set style fill pattern 7


set title 'EoSs'


plot '../mft.qcd.eos.38.CGS.csv' using 1:2  title 'MFTQCD 38' with lines, \
	'../mft.qcd.eos.75.CGS.csv' using 1:2  title 'MFTQCD 75'  with lines, \
	'../SLY4_cgs.csv' using 1:2  title 'Sly4' with lines
	

