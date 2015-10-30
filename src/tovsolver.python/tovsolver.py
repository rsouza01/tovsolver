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


from mainsolver import TOVSolver
from mainsolver import TOVSolverConfig
import sys
import tovconfig


def main(argv):

    rho_0, config_name = tovconfig.get_cl_parameters(argv)

    # TODO: this method must be changed to return all other configs.
    eos_file_name = tovconfig.get_file_name_from_conf(config_name)

    tovSolver = TOVSolver(TOVSolverConfig(
        central_energy=rho_0,
        eos_file_name=eos_file_name,
        config_name=config_name))

    tovSolver.run()


if __name__ == "__main__":
    main(sys.argv[1:])
