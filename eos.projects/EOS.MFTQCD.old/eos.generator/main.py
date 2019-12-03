#!/usr/bin/python

#================================================
# Authors:  
#		Rodrigo Souza 
#		<rsouza01@gmail.com>
#       2015-06-07
#================================================

#================================================
#  Numerical and plotting libraries
#================================================

from datetime import datetime

"""
Escolha um ou outro.
"""
#import eos_generator_from_fit as eos
import eos_generator as eos

import sys
import getopt
import numpy as np
from enum import Enum

#opts, args = getopt.getopt(sys.argv, "r", ["redir"])

#for opt, arg in opts:
#	if opt in ("-r", "--redir"):
#		sys.stdout = open("./eos.csv", "w")
#print opts , args


#================================================
# Initialization Routines
#================================================
initTime = datetime.now()


#================================================

eos.fFuncMain()

#================================================
# Finalization Routines
#================================================


endTime = datetime.now()
print "\n\n\n================================================"
print "Time elapsed: %d ms." % ((endTime - initTime).microseconds)
print "Done!"
print "================================================"


