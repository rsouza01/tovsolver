#!/usr/bin/env gnuplot

reset

set datafile separator ","


set grid

#set terminal epslatex colour
#set terminal postscript eps enhanced color font 'Helvetica,10'
set terminal postscript colour
#set terminal png

set output 'MFT_QCD.eps'

#--------------------------------------------------
# Plot 1
#--------------------------------------------------


set title "$\mu_B$ x Pressao"

set ylabel 'Pressao'
set xlabel 'mu_b'

set autoscale x
set autoscale y


plot 'EoS-OFICIAL-SLy4-tabelada-sem-fit.csv' using 4:2 with lines title 'Sly4',\
    'eosLista.dat' using 14:7 with lines title 'B=75.7, F & N'

#--------------------------------------------------
# Plot 2
#--------------------------------------------------

set title "rho_B x varepsilon"

set ylabel '$\varepsilon$'
set xlabel '$\rho_b$'

#set yrange [100:1500]
set xrange [0:1.5]

#set autoscale x
#set autoscale y


plot 'EoS-OFICIAL-SLy4-tabelada-sem-fit.csv' using 3:1 with lines title 'Sly4',\
    'eosLista.dat' using 1:6 with lines title 'B=75.7, F & N'

#--------------------------------------------------
# Plot 3
#--------------------------------------------------

set xlabel 'Pressao'
set ylabel '$\varepsilon$'

set yrange [0:5000]
set xrange [0:1500]

set title "Pressao x varepsilon

plot 'EoS-OFICIAL-SLy4-tabelada-sem-fit.csv' using 2:1 with lines title 'Sly4',\
    'eosLista.dat' using 7:6 with lines title 'B=75.7, F & N'



#--------------------------------------------------
# Plot 4
#--------------------------------------------------

set title "MFTQCD + SLY4"

plot 'EosMaxwell.csv' using 2:1 with lines title ''
