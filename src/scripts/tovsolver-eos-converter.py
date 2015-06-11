#!/usr/bin/python

"""
    eos-units.py - Converts the eos file from one unit system to other

    Author: 	Rodrigo Alvares de Souza
                rsouza01@gmail.com


    History:
    Version 0.1: 2015/07/10     (rsouza) - Creating the file.


    The file MUST be formated in 3 columns, as stated bellow:
    mass density, pressure, baryonic density.
    
    Only the first two columns will be converted in this version.
    The results will be displayed in the stdout stream. Use redirection to generate
    a new EoS file.

    TODO: Finish the implementation for Nuclear to CGS convertion...
    
    
    Usage:
        eos-units.py -f unit_to_convert_from -t unit_to_convert_to
        eos-units.py --from unit_to_convert_from --to unit_to_convert_to
        eos-units.py --help
        eos-units.py -h
    
"""

import sys
import getopt
import csv

_eos_converter_version = 0.1
_unit_systems = ['cgs', 'nuclear']
_conversion_factors_CGS_TO_NUC = [5.6096e-13, 6.242e-31, 1e-39]
_conversion_factors_NUC_TO_CGS = [1.783e12, 1.6022e33, 1e39]


_unit_system_from = 0    #CGS by default
_unit_system_to   = 1    #NUCLEAR by default

_eos_file_name = ''


def usage():
    print (
        "Usage: \n" +
        "    eos-units.py -e=EOSFILENAME -f unit_to_convert_from -t unit_to_convert_to \n" +
        "    eos-units.py --eosfile=EOSFILENAME --from unit_to_convert_from --to unit_to_convert_to \n" +
        "    eos-units.py --help \n" +
        "    eos-units.py -h\n")

def print_execution_header():
    global _eos_converter_version
    global _unit_systems
    global _unit_system_from
    global _unit_system_to
    global _eos_file_name

    print ("\n\n\n#-----------------------------------------------------")
    print ("# EOS unit converter - Vs %.1f" % _eos_converter_version)
    print ("# Eos File : %s" % _eos_file_name)
    print ("# Converting %s -> %s" % (_unit_systems[_unit_system_from], _unit_systems[_unit_system_to]))
    print ("# DO NOT FORGET TO REMOVE THESE LINES!!!")
    print ("#-----------------------------------------------------\n")
    print ("# Mass density, Pressure, Baryonic density")
    print ("# Mev/fm^3, Mev/fm^3, fm^-3")
    
    


def get_cl_parameters(argv):
    #Extracting the command line parameters.

    try:                                
        opts, args = getopt.getopt(argv, "he:f:t:", ["help", "eosfile=", "from=", "to="])
    except getopt.GetoptError as err:
        print(err)
        usage()
        sys.exit(2)       

    for opt, arg in opts:
        
        
        if opt in ("-f", "--from"):
            if(arg == "cgs"):
                unit_system_from = 0
            elif(arg == "nuclear"):
                unit_system_from = 1
                
        elif opt in ("-t", "--to"):
            if(arg == "cgs"):
                unit_system_to = 0
            elif(arg == "nuclear"):
                unit_system_to = 1

        elif opt in ("-e", "--eosfile"):
            eos_file_name = arg

        elif opt == '-h':
            usage()
            exit(0)
        else:
            assert False, "Unhandled exception."




    return unit_system_from, unit_system_to, eos_file_name

def convert_cgs_to_nuclear(mass_density, pressure, baryon_density):
    
    global _conversion_factors_CGS_TO_NUC
    
    mass_density    *= _conversion_factors_CGS_TO_NUC[0]
    pressure        *= _conversion_factors_CGS_TO_NUC[1]
    baryon_density  *= _conversion_factors_CGS_TO_NUC[2]
    
    return mass_density, pressure, baryon_density

def convert_nuclear_to_cgs(mass_density, pressure, baryon_density):
    global _conversion_factors_NUC_TO_CGS
    
    mass_density    *= _conversion_factors_NUC_TO_CGS[0]
    pressure        *= _conversion_factors_NUC_TO_CGS[1]
    baryon_density  *= _conversion_factors_NUC_TO_CGS[2]
    
    return mass_density, pressure, baryon_density


def process_file(unit_system_from, unit_system_to, eos_file_name):
    with open(_eos_file_name, 'rb') as csvfile:
        reader = csv.reader(csvfile)

        for row in reader:
            if(row[0].startswith("#") != True):
                
                mass_density    = float(row[0])
                pressure        = float(row[1])
                baryon_density  = float(row[2])

                if(unit_system_from == 0 and unit_system_to == 1):
                    mass_density, pressure, baryon_density  = \
                        convert_cgs_to_nuclear(mass_density, pressure, baryon_density)

                elif(unit_system_from == 1 and unit_system_to == 0):
                    mass_density, pressure, baryon_density  = \
                        convert_nuclear_to_cgs(mass_density, pressure, baryon_density)

                
                output = '{0}, {1}, {2}'.format(mass_density, pressure, baryon_density)
                
                print(output)
    

def main(argv):
    global _eos_converter_version
    global _unit_systems
    global _unit_system_from
    global _unit_system_to
    global _eos_file_name


    _unit_system_from, _unit_system_to, _eos_file_name = get_cl_parameters(argv)

    print_execution_header()
    process_file(_unit_system_from, _unit_system_to, _eos_file_name)


if __name__ == "__main__":
    main(sys.argv[1:])    








