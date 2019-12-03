#================================================
# Authors:  
#		Rodrigo Souza 
#		<rsouza01@gmail.com>
#       2015-06-07
#================================================

import numpy as np
import scipy.special as scps

import Atomic_Constants as ac
import cmath, math
import scipy

#================================================
#Constants
#================================================


a_38 = -56.05
b_38 =  0.3779
c_38 =  0.0003484
d_38 = -2.645e-7
e_38 =  8.889e-11


a_75 = -103.6
b_75 =  0.3204
c_75 = -0.00002133
d_75 =  3.553e-8
e_75 = -1.469e-11

#================================================
#ENUMERATIONS
#================================================

#================================================
#FUNCTIONS
#================================================

def println(message):
	print message

def baryonic_density(density):
	return 1.
	
	
def pressure_38(x):
	
	return a_38 + b_38*x + c_38*x**2. + d_38*x**3. + e_38*x**4.

def pressure_75(x):
	
	return a_75 + b_75*x + c_75*x**2. + d_75*x**3. + e_75*x**4.

#================================================
#FUNCTION MAIN
#================================================


def fFuncMain():
    
	println ("================================================")
	println ("EOS file generator")
	println ("================================================")


	for density in range(3000, 0, -10):
		println ("%.3e, %.3e, %d" % (density, pressure_75(density), baryonic_density(density)))



