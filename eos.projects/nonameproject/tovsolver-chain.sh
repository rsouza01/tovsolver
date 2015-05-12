#!/bin/bash
#
#
# tovsolver-chain.sh - Runs a sequence of commands in order to solve the 
#						star profile.
#
# Author: 	Rodrigo Alvares de Souza
#			rsouza01@gmail.com
#
#
# History:
# Version 0.1: 2015/05/12 (rsouza) - Creating the file...
#
##

rm ./output/*.csv && rm ./output/*.txt && ./tovsolver-batch.sh && ./tovsolver-genoutput.sh
