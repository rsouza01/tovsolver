#!/bin/bash

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
	echo "#Arquivo de parâmetros 'tov_parameters.sh' não encontrado."
	echo "#Crie o arquivo e execute este script novamente."
	echo " "
	exit -1
fi


source tov_parameters.sh

echo "#Arquivo de EoS: '${_EOS_FILE_NAME}''."
echo "#Arquivo de configuração do lote: '${_CONFIG_FILE}'."
echo "#Diretório de output: '${_OUTPUT_DIR}'."
echo " "

#Testo se o arquivo da EoS existe...

if [ ! -f $_EOS_FILE_NAME ]
then
	echo "#Arquivo da EoS '${_EOS_FILE_NAME}' não encontrado."
	echo " "
	exit -1
fi

#Testo se o diretório de saída existe. Se não, ele é criado.
if [ ! -d "$_OUTPUT_DIR" ]; then
	echo "#Diretório '${_OUTPUT_DIR}' não existe, criando..."
	mkdir $_OUTPUT_DIR
	echo " "
fi


echo '#******************************************************'


commandLine="${_EXECUTAVEL} -rho_0=${_rho_0} -config=${_CONFIG_FILE} > ${_OUTPUT_DIR}out_${_rho_0}.txt"
echo $commandLine
eval $commandLine
		

echo "Processamento concluído."
