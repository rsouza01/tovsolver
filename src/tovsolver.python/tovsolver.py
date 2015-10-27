#!/usr/bin/python

# tovsolver - Tolman-Ooppenheimer-Volkoff equation solver
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


def usage():
    print(
        "Usage: \n" +
        "    tovsolver.py \n")


def main(argv):

    tovsolverconfig = TOVSolverConfig(central_energy=1396.12)
    tovsolver = TOVSolver(tovsolverconfig)

    tovsolver.run()


if __name__ == "__main__":
    main(sys.argv[1:])
