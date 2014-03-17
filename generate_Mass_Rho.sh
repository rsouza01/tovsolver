#!/bin/bash


_INPUT_DIR="./output/"
_OUTPUT_DIR="./output/"
_MASS_RHO_FILE=${_OUTPUT_DIR}'massRho.csv'
rhoPattern="RHO_0 "
massPattern="Star Mass (Solar Units)"

echo " "
echo " "
echo '#******************************************************'
echo '#*******  TOV Solver Mass/Density Extractor  ***********'
echo '#******************************************************'
echo " "
echo "#Diretório de output: '${_OUTPUT_DIR}'."
echo "#Arquivo de output: '${_MASS_RHO_FILE}'."
echo " "

#Substituo o INTERNAL FIELD SEPARATOR, mas antes guardo uma cópia.
OLD_IFS=$IFS
IFS=':'

echo "#rho,mass" > $_MASS_RHO_FILE

for _FILE_NAME in ${_INPUT_DIR}*.txt; do 

	echo "Processing $_FILE_NAME file.."; 
	cat $_FILE_NAME | while read line; do 
		if [[ "$line" == *$rhoPattern* ]]
		then
			#Substituo o '=' pelo ':' pra poder usar o IFS.
			line=${line//=/:}
			arr=($line)
			rho=${arr[1]}
			echo $rho
		elif [[ "$line" == *$massPattern* ]]
		then
			arr=($line)
			mass=${arr[1]}
			echo "${rho}	${mass}" >> $_MASS_RHO_FILE
		fi

	done

done


#Restituo o INTERNAL FIELD SEPARATOR
IFS=$OLD_IFS

echo "Processamento concluído."

gnuplot massaRho.gnuplot

evince massaRho.eps
