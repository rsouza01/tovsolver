#!/bin/bash
#
#
# tov_single.sh - Executes the TOV solver for a single central density.
#
# Author: 	Rodrigo Alvares de Souza
#			rsouza01@gmail.com
#
#
# History:
# Version 0.4: 2014/04/05 (rsouza) - improving legibility, 
#									adding coments, etc.
#

#Command line arguments
case $1 in

-V | --version)
	echo -n $(basename "$0")
	grep '^# Version ' "$0" | tail -1 | cut -d : -f 1 | tr -d \#
	exit 0
	;;
	
esac

_rho_0=2.42704e-09

echo " "
echo " "
echo '#******************************************************'
echo '#***********   TOV Solver Shell Script  ***************'
echo '#******************************************************'
echo " "

if [ ! -f tov_parameters.sh ]
then
	echo " "
	echo "#Parameters file 'tov_parameters.sh' not found."
	echo " "
	exit -1
fi


source tov_parameters.sh

echo "#EoS file: '${_EOS_FILE_NAME}''."
echo "#Batch configuration file: '${_CONFIG_FILE}'."
echo "#Output directory: '${_OUTPUT_DIR}'."
echo " "

#Does the EoS file exist?

if [ ! -f $_EOS_FILE_NAME ]
then
	echo "#EoS file '${_EOS_FILE_NAME}' not found."
	echo " "
	exit -1
fi

#Does the output dir exist?
if [ ! -d "$_OUTPUT_DIR" ]; then
	echo "#Directory  '${_OUTPUT_DIR}' not found, creating..."
	mkdir $_OUTPUT_DIR
	echo " "
fi


echo '#******************************************************'


commandLine="${_EXECUTAVEL} -rho_0=${_rho_0} -config=${_CONFIG_FILE} > ${_OUTPUT_DIR}out_${_rho_0}.txt"
echo $commandLine
eval $commandLine
		

echo "Processing done."
