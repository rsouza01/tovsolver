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


import csv
import numpy

from collections import namedtuple
from scipy import interpolate
import cgs_constants as const
# import atomic_constants as const


import matplotlib.pyplot as plt


ENERGY_DENSITY_INDEX = 0
MASS_DENSITY_INDEX = 0
PRESSURE_INDEX = 1
BARYONIC_NUMBER_INDEX = 2


class EoSValue(namedtuple('EoSValue', 'energy pressure baryonic_number')):
    """
    Named tuple that represents an EoS value
    """
    pass


class EoS:

    def __init__(self, filename, central_energy_density, verbose=False):

        self.__filename = filename

        self.__central_energy_density = central_energy_density

        loader = EoSLoader(self.__filename, central_energy_density)

        loader.loadEoSFile()

        interp = EoSInterpolation(loader.getEoSList())

        self.__energy_from_pressure_function = \
            interp.interpolate_spline_energy_from_pressure(plotFit=verbose)

        # TODO: There's something wrong here, it returns a function array instead of a function.
        self.__pressure_from_energy_function = \
            interp.interpolate_spline_pressure_from_energy(plotFit=verbose)

    def energy_from_pressure(self, pressure):

        # print("energy_from_pressure(%f)" % (pressure))

        return self.__energy_from_pressure_function(pressure)

    def pressure_from_energy(self, energy):

        # print("pressure_from_energy(%f)" % (energy))

        return self.__pressure_from_energy_function(energy)


class EoSLoader:
    """ EoS Loader. """

    __eosList = []

    def __init__(self, filename, central_energy_density=1):

        self.__filename = filename
        self.__central_energy_density = central_energy_density

        # print("self.__central_energy_density = {}".format(self.__central_energy_density))

    def getEoSList(self):
        return self.__eosList

    def loadEoSFile(self):

        with open(self.__filename, 'r') as f:
            reader = csv.reader(f)
            for row in reader:
                if not row[0].startswith('#'):
                    eosValue = EoSValue(float(
                        row[MASS_DENSITY_INDEX])*const.LIGHT_SPEED**2./self.__central_energy_density,
                        float(row[PRESSURE_INDEX])/self.__central_energy_density,
                        float(row[BARYONIC_NUMBER_INDEX]))

                    self.__eosList.append(eosValue)

        # print(self.__eosList)

        # firstColumn = [row[0] for row in self.__eosList]

        # print(firstColumn)


class EoSInterpolation:
    """ EoS Interpolation. """

    def __init__(self, eosList):

        self.__eosList = eosList

        self.__energyValues = numpy.asarray(
            [row[MASS_DENSITY_INDEX] for row in self.__eosList],  dtype=numpy.float32)

        self.__pressureValues = numpy.asarray(
            [row[PRESSURE_INDEX] for row in self.__eosList],  dtype=numpy.float32)

        self.__baryonicNumberValues = numpy.asarray(
            [row[BARYONIC_NUMBER_INDEX] for row in self.__eosList],  dtype=numpy.float32)

    def interpolate_spline_energy_from_pressure(self, plotFit=False):

        fc = interpolate.interp1d(self.__pressureValues[::-1], self.__energyValues[::-1])

        if plotFit:
            plt.figure()
            plt.plot(self.__pressureValues,
                     fc(self.__pressureValues), 'x',
                     self.__pressureValues, self.__energyValues)
            plt.legend(['True', 'Cubic Spline'])
            plt.ylabel("Energy")
            plt.xlabel("Pressure")
            plt.title("\epsilon(P)")
            plt.show()

        return fc

    def interpolate_spline_pressure_from_energy(self, plotFit=False):

        fc = interpolate.interp1d(self.__energyValues[::-1], self.__pressureValues[::-1])

        if plotFit:
            plt.figure()
            plt.plot(self.__energyValues,
                     fc(self.__energyValues), 'o',
                     self.__energyValues, self.__pressureValues)
            plt.legend(['True', 'Cubic Spline'])
            plt.xlabel("Energy")
            plt.ylabel("Pressure")
            plt.title("P(e)")
            plt.show()

        return fc
