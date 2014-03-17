#!/bin/bash

#Folders and files
_INPUT_DIR="./output/"
_OUTPUT_DIR="./output/"
_MASS_RADIUS_FILE=${_OUTPUT_DIR}'massRadius.csv'

#Patterns
rhoPattern=" RHO_0"
pressurePattern="P_0"
radiusPattern="Star Radius (km)"
massPattern="Star Mass (Solar Units)"
infoEntropyPattern="Information Entropy"
diseqPattern="Disequilibrium"
complexityPattern="Complexity"


echo " "
echo " "
echo '#******************************************************'
echo '#*******  TOV Solver Mass/Radius Extractor  ***********'
echo '#******************************************************'
echo " "
echo "# Output folder: '${_OUTPUT_DIR}'."
echo "# Output file: '${_MASS_RADIUS_FILE}'."
echo " "

#Substituo o INTERNAL FIELD SEPARATOR, mas antes guardo uma cópia.
OLD_IFS=$IFS
IFS=':'

echo "#central density,	central pressure, radius,	mass,	information entropy,	disequilibrium,	complexity" > $_MASS_RADIUS_FILE

for _FILE_NAME in ${_INPUT_DIR}*.txt; do 

	echo "# Processing file '$_FILE_NAME'"; 
	cat $_FILE_NAME | while read line; do 

		#	Os campos devem estar em ordem nesse if,
		#	ainda não aprendi a fazer o parse corretamente.
		#	Mas dá pro gasto...
		if [[ "$line" == *$rhoPattern* ]]
		then
			arr=($line)
			rho_0=${arr[1]}
		elif [[ "$line" == *$pressurePattern* ]]
		then
			arr=($line)
			p_0=${arr[1]}
		elif [[ "$line" == *$radiusPattern* ]]
		then
			arr=($line)
			radius=${arr[1]}
		elif [[ "$line" == *$massPattern* ]]
		then
			arr=($line)
			mass=${arr[1]}
		elif [[ "$line" == *$infoEntropyPattern* ]]
		then
			arr=($line)
			infoEntropy=${arr[1]}
		elif [[ "$line" == *$diseqPattern* ]]
		then
			arr=($line)
			disequilibrium=${arr[1]}
		elif [[ "$line" == *$complexityPattern* ]]
		then
			arr=($line)
			complexity=${arr[1]}
			echo "${rho_0}	${p_0}	${radius}	${mass}	${infoEntropy}	${disequilibrium}	${complexity}" >> $_MASS_RADIUS_FILE
		fi
	done

done


#Restituo o INTERNAL FIELD SEPARATOR
IFS=$OLD_IFS

echo "#End of processing."

echo "#Processing output figure."
gnuplot massaRaio.gnuplot
echo "#Done."

#evince massaRaio.eps
