#!/bin/bash

# NÃO MODIFICAR ESTE ARQUIVO. PARA ENTRADA DE PARAMETROS REFERENTES AO
# MODELO INTEGRADO, EDITAR 'tov_parameters.sh'
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
	echo "#Create the file and run this script again."
	echo " "
	exit -1
fi


source tov_parameters.sh

#Substituo o INTERNAL FIELD SEPARATOR, mas antes guardo uma cópia.
OLD_IFS=$IFS
IFS=', '

echo "#EoS file: '${_EOS_FILE_NAME}''."
echo "#Batch config file: '${_CONFIG_FILE}'."
echo "#Output folder: '${_OUTPUT_DIR}'."
echo " "

#Testo se o arquivo da EoS existe...

if [ ! -f $_EOS_FILE_NAME ]
then
	echo "#EoS file '${_EOS_FILE_NAME}' not found."
	echo " "
	exit -1
fi

#Testo se o diretório de saída existe. Se não, ele é criado.
if [ ! -d "$_OUTPUT_DIR" ]; then
	echo "#Folder '${_OUTPUT_DIR}' not found, creating..."
	mkdir $_OUTPUT_DIR
	echo " "
fi


echo '#******************************************************'

declare -i secondsProcessing=0

cat $_EOS_FILE_NAME | while read line; do 
	arr=($line)
	_rho_0=${arr[0]}

	#Se a linha NÃO começar com #, obtenho a densidade associada. 
	# Do contrário descarto.
	if [[ $_rho_0 != '#'* ]];  
	then
		echo "Processing rho_0=${_rho_0}..."

		#beginProcessing=`date +%s`
		beginProcessing=`date +%s%N | cut -b1-13`

		commandLine="${_EXECUTAVEL} -rho_0=${_rho_0} -config=${_CONFIG_FILE} > ${_OUTPUT_DIR}out_${_rho_0}.txt"
		echo $commandLine
		eval $commandLine
		
		#endProcessing=`date +%s`
		endProcessing=`date +%s%N | cut -b1-13`

		secondsProcessing=endProcessing-beginProcessing

		echo "Processing time: $secondsProcessing ms."

		#Testo se o return code é diferente de 0. Se for, deu erro.
		if [ $? -ne 0 ]; then
			echo "ERROR!"
		else
			echo "OK!"
		fi


		echo "__________________________________________________________________________________________________________"
	fi

done

#Restituo o INTERNAL FIELD SEPARATOR
IFS=$OLD_IFS

echo "Done."
