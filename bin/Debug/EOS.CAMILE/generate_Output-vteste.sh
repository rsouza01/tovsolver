#!/bin/bash

#Folders and files
_INPUT_DIR="./output/"
_OUTPUT_DIR="./output/"
_MASS_RADIUS_FILE=${_OUTPUT_DIR}'RHOc-Pc-R-M-H-D-C-a.csv'

#Patterns
rhoPattern=" RHO_0"
pressurePattern="P_0"
radiusPatternNUC="Star Radius (NUC)"
radiusPattern="Star Radius (km)"
massPatternNUC="Star Mass (NUC)"
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

echo "#central density,	central pressure, radiusNUC, radius,	massNUC,	mass,	information entropy,	disequilibrium,	complexity, a_param=rho_m/rho_0" > $_MASS_RADIUS_FILE

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
			rho_0_1=`printf "%.10f\n" ${rho_0}`			
		elif [[ "$line" == *$pressurePattern* ]]
		then
			arr=($line)
			p_0=${arr[1]}

		elif [[ "$line" == *$radiusPatternNUC* ]]
		then
			arr=($line)
			radiusNUC=${arr[1]}
			radiusNUC_1=`printf "%.10f\n" ${radiusNUC}`
		elif [[ "$line" == *$radiusPattern* ]]
		then
			arr=($line)
			radius=${arr[1]}

		elif [[ "$line" == *$massPatternNUC* ]]
		then
			arr=($line)
			massNUC=${arr[1]}
			massNUC_1=`printf "%.10f\n" ${massNUC}`
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
			a_param=`echo "scale=10; (${massNUC_1}/(4/3*3.141592654*(${radiusNUC_1})*(${radiusNUC_1})*(${radiusNUC_1})))/(${rho_0_1})" | bc -l`
			echo "${rho_0}	${p_0}	${radiusNUC}	${radius}	${massNUC}	${mass}	${infoEntropy}	${disequilibrium}	${complexity}	${a_param}" >> $_MASS_RADIUS_FILE
		fi
	done

done

#a_param=`echo "scale=10; (${massNUC_1})/(${rho_0_1})" | bc -l`

#Restituo o INTERNAL FIELD SEPARATOR
IFS=$OLD_IFS

echo "#End of processing."

echo "#Processing output figure."
gnuplot massaRaio.gnuplot
echo "#Done."

#evince massaRaio.eps
