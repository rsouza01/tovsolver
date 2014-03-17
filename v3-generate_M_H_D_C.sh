#!/bin/bash


_INPUT_DIR="./output/"
_OUTPUT_DIR="./output/"
_MASS_INFORMATION_FILE=${_OUTPUT_DIR}'M-R-RHOc-H-D-C.csv'
radiusPattern="Star Radius (km)"
massPattern="Star Mass (Solar Units)"
informationPattern="Information Entropy"
disequilibriumPattern="Disequilibrium"
complexityPattern="Complexity"
rhoPattern="RHO_0 "

echo " "
echo " "
echo '#******************************************************'
echo '#*******  TOV Solver Mass/Radius Extractor  ***********'
echo '#******************************************************'
echo " "
echo "#Diretório de output: '${_OUTPUT_DIR}'."
echo "#Arquivo de output: '${_MASS_INFORMATION_FILE}'."
echo " "

#Substituo o INTERNAL FIELD SEPARATOR, mas antes guardo uma cópia.
OLD_IFS=$IFS
IFS=':'

echo "#information,disequilibrium,complexity,mass,radius,rho_c" > $_MASS_INFORMATION_FILE

for _FILE_NAME in ${_INPUT_DIR}*.txt; do 

	echo "Processing $_FILE_NAME file..."; 
	cat $_FILE_NAME | while read line; do 



		if [[ "$line" == *$informationPattern* ]]
		then
			arr=($line)
			information=${arr[1]}
			massInformationOutput=$information
			echo "inf" $information
			#echo "${information} ${disequilibrium} ${complexity} ${mass}" >> $_MASS_INFORMATION_FILE

		elif [[ "$line" == *$disequilibriumPattern* ]]
			then
				arr=($line)
				disequilibrium=${arr[1]}
				massDisequilibriumOutput=$disequilibrium
				echo "dis" $disequilibrium
				#echo "${information} ${disequilibrium} ${complexity} ${mass}" >> $_MASS_INFORMATION_FILE
				
			
		elif [[ "$line" == *$complexityPattern* ]]
			then
				arr=($line)
				complexity=${arr[1]}
				massComplexityOutput=$complexity
				echo "comp" $complexity
				echo "${information} ${disequilibrium} ${complexity} ${mass} ${radius} ${rho}" >> $_MASS_INFORMATION_FILE


		elif [[ "$line" == *$massPattern* ]]
			then
				arr=($line)
				mass=${arr[1]}
				echo "mass" $mass


		elif [[ "$line" == *$radiusPattern* ]]
			then
				arr=($line)
				radius=${arr[1]}
				echo "radius" $radius


		elif [[ "$line" == *$rhoPattern* ]]
			then
#				line=${line//=/:}
				arr=($line)
				rho=${arr[1]}
				echo "rho" $rho
			
		fi

	done

done


#Restituo o INTERNAL FIELD SEPARATOR
IFS=$OLD_IFS

echo "Processamento concluído."

#gnuplot massaInformacao.gnuplot

#evince massaInformacao.eps
