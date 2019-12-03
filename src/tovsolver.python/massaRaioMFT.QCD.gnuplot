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

set xlabel 'Raio (km)' font "Helvetica,20"
set ylabel 'Massa (M/M_{Sun})' font "Helvetica,20"

set output './plots/MASSA_RAIO_MFT.QCD.B_100.eps' 

set xrange[0:11]
set yrange[0:2.3]

set title 'MFT QCD (B = 100 MeV), Massa Raio'

plot './PLOTS_TESE/MFT.QCD/MFT.QCD.B_100_XI_0.0015_starStructureOutput.csv' using 3:4 with points lt rgb "blue" ps 0.2 title 'B=100, xi=0.0015', \
    './PLOTS_TESE/MFT.QCD/MFT.QCD.B_100_XI_0.0030_starStructureOutput.csv' using 3:4 with points lt rgb "blue"  ps 0.2 title 'B=100, xi=0.0030', \
    './PLOTS_TESE/MFT.QCD/MFT.QCD.B_100_XI_0.0045_starStructureOutput.csv' using 3:4 with points lt rgb "blue" ps 0.2 title 'B=100, xi=0.0045', \
    './PLOTS_TESE/MFT.QCD/MFT.QCD.B_100_XI_0.0060_starStructureOutput.csv' using 3:4 with points lt rgb "blue" ps 0.2 title 'B=100, xi=0.0060', \
    './PLOTS_TESE/MFT.QCD/MFT.QCD.B_100_XI_0.0075_starStructureOutput.csv' using 3:4 with points lt rgb "blue" ps 0.2 title 'B=100, xi=0.0075'

