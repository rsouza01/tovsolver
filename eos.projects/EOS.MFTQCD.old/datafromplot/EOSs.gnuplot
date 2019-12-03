#!/usr/bin/env gnuplot

reset

set ylabel 'Pressao'
set xlabel '$\mu_b$'


set xrange [1:1500]

#set logscale y

#set terminal epslatex colour
set terminal postscript eps enhanced color font 'Helvetica,10'

set output 'MFT_QCD.eps'

#set terminal postscript colour
#set output 'MFT_QCD.ps' 

#set terminal png
#set output 'MFT_QCD.png'

set title "Presso"

plot 'MFTQCD_B_75_7MeV_gerado_final.csv' using 4:2 with points title 'B=75.7, Haensel',\
     'MFTQCD_B_75_7MeV_gerado_final.csv' using 5:2 with points title 'B=75.7, F & N'

