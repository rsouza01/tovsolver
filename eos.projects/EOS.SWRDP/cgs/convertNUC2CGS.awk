#!/usr/bin/awk -f

#
# Input:
# Column 1: Energy Density [g cm-3]
# Column 2: Pressure [g cm-3]
# Column 3: Baryon number density [fm-3]
#
# OUTPUT FORMAT
# mass density [g/cm3], pressure [erg/cm3], baryon density [1/cm3]
#
# chemical potential = (energy density + pressure)/n_B = ($2 + $3)/$1

BEGIN { 
	# CONSTANTS
        LIGHT_SPEED_SQUARED=8.99E+020
	MEV_TO_ERG=1.6021773e-6
	FM3_TO_CM3=1.00E-039
	CONV_ENERGY_NUC2CGS=MEV_TO_ERG/FM3_TO_CM3

        outputHeader = "# mass density [g cm-3], pressure [erg cm-3], baryon density [1/fm-3]"

	# Commands
        outputFooter = outputHeader
        print outputHeader
} { 
  
  # This snippet checks wheter the line starts with a comment character
  if($1!~/^#/){
    mass_density = $1* CONV_ENERGY_NUC2CGS/LIGHT_SPEED_SQUARED
    pressure = $2*CONV_ENERGY_NUC2CGS
    baryon_density = $3/FM3_TO_CM3

    printf "%.6e, %.6e, %.e\n", mass_density, pressure, baryon_density
  } else {
      print $0
  }

} END { 

        print outputFooter

}

