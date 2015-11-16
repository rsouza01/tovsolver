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

from numerical import RungeKutta
from collections import namedtuple


class TOVRK4Result(namedtuple('TOVRK4Result', 'mass pressure eta')):
    """
    Named tuple that represents an EoS value
    """
    pass


class TOVRungeKutta(RungeKutta):
    """ TOV Runge Kutta implementation. """
    __MASS_INDEX = 0
    __PRESSURE_INDEX = 1

    def __init__(self, rk_parameters, cutoff_density_bar=0.0):

        super(TOVRungeKutta, self).__init__(rk_parameters)
        self.__star_eta = 0
        self.__star_mass = 0
        self.__star_pressure = 0
        self.__cutoff_density_bar = cutoff_density_bar

    def must_stop(self, eta, ws):

        if ws[self.__MASS_INDEX] <= self.__cutoff_density_bar or ws[self.__PRESSURE_INDEX] <= 0:
            return True
        else:
            return False

    def perform_calculations(self, eta, ws):
        self.__star_eta = eta
        self.__star_mass = ws[0]
        self.__star_pressure = ws[1]

    def getResult(self):
        return TOVRK4Result(self.__star_mass, self.__star_pressure, self.__star_eta)
