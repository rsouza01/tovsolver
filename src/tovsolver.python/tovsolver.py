#!/usr/bin/python

# tovsolver - Tolman-Oppenheimer-Volkoff equation solver
# Copyright (C) 2015 Rodrigo Souza <rsouza01@gmail.com>

# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
# 02110-1301, USA.


"""
    tovsolver.py - Python version from old tovsover

    History:
    Version 0.1: 2015/08/29     (rsouza) - Creating the file.

    Usage:
        tovsolver.py

    Example:
        ./tovsolver.py

"""

import sys
from mainsolver import TOVSolver
from mainsolver import TOVSolverConfig
import sys
import getopt


def usage():
    print(
        "Usage: \n" +
        "    tov_solver.py <--config=config_file_name --rho_0=9.9D+9> \n")

def get_cl_parameters(argv):
    '''
    Extracts the command line parameters.
    :param argv:
    :return:
    '''

    number_arguments = len(argv)

    if number_arguments == 0:
        usage()
        sys.exit(2)

    try:
        opts, args = getopt.getopt(argv, "hrc:", ["help", "rho_0=", "config="])
    except getopt.GetoptError as err:
        print(err)
        usage()
        sys.exit(2)

    config_file = "tov_solver.conf"
    rho_0 = 0.

    for opt, arg in opts:

        if opt in ("-r", "--rho_0"):
            rho_0 = float(arg)

        elif opt in ("-c", "--config"):
            config_file = arg

        elif opt == '-h':
            usage()
            exit(0)
        else:
            assert False, "Unhandled exception."

    return [rho_0, config_file]

def main(argv):

    rho_0, config_name = get_cl_parameters(argv)

    tovSolver = TOVSolver(TOVSolverConfig(
        central_energy=rho_0,
        eos_file_name="EoS-OFICIAL-SLy4-tabelada-sem-fit.csv",
        config_name=config_name))

    tovSolver.run()


if __name__ == "__main__":
    main(sys.argv[1:])
