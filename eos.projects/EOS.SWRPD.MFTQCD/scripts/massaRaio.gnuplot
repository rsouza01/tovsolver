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

set output './plots/MASSA_RAIO_MFT.QCD.B_100_XI_0.0075.eps' 

set xrange[0:11]
set yrange[0:2.3]

set title 'Massa Raio'

plot './output/starStructureOutput.csv' using 3:4 with points lt rgb "blue" pointtype 7 ps 0.2 title 'MFT QCD'

####################################################################################################


#set title 'Massa Raio - Quark core only'
#set xrange[0:4]
#set yrange[0:0.8]

#set output './plots/MASSA_RAIO_QC_MFT.QCD.B_100_XI_0.0075.eps' 

#plot './output/starStructureOutput.csv' using 5:6 with points lt rgb "red" pointtype 7 ps 0.2 title 'MFT QCD'

####################################################################################################

set title 'Densidade central x Massa'
set xlabel 'Densidade Central [erg/cm^3]' font "Helvetica,20"
set ylabel 'Massa [M/M_{Sun}]' font "Helvetica,20"
set xrange[1e34:6e36]
set yrange[0:2.3]

set output './plots/EPSILON_MASSA_QC_MFT.QCD.B_100_XI_0.0075.eps' 

plot './output/starStructureOutput.csv' using 1:4 with points lt rgb "blue" pointtype 7 ps 0.3 title 'MFT QCD', \
# './output/starStructureOutput.csv' using 1:6 with points lt rgb "orange" pointtype 7 ps 0.3 title 'MFT QCD'

####################################################################################################

set title 'Densidade central x Raio'
set xlabel 'Densidade Central [erg/cm^3]' font "Helvetica,20"
set ylabel 'Raio (km)' font "Helvetica,20"
set xrange[1e34:3e36]
set yrange[0:11]

set output './plots/EPSILON_RAIO_QC_MFT.QCD.B_100_XI_0.0075.eps' 

plot './output/starStructureOutput.csv' using 1:3 with points lt rgb "blue" pointtype 7 ps 0.3 title 'MFT QCD', \
# './output/starStructureOutput.csv' using 1:5 with points lt rgb "orange" pointtype 7 ps 0.3 title 'MFT QCD'

