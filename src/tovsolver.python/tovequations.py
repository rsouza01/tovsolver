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



class TOVEquations:
    """ TOV equations. """

    __INDEX_MASS = 0
    __INDEX_PRESSURE = 1

    def __init__(self, eos):

        self.__eos = eos

    def vector_field(self, w, t, p):

        return [self.delta_M_delta_eta(t, w),
                self.delta_P_delta_eta(t, w)]

    def delta_M_delta_eta(self, eta, y):
        mass, pressure = y[0], y[1]

        # print("delta_M_delta_r(eta, mass, pressure) = (%f, %e, %e)" % (eta, mass, pressure))

        energy_density = self.__eos.energy_from_pressure(pressure)

        # print("delta_M_delta_r(eta, mass, pressure, energy) = (%f, %f, %f, %f)" % (eta, mass, pressure, energy_density))

        return energy_density * eta ** 2.

    def delta_P_delta_eta(self, eta, y):

        mass, pressure = y[0], y[1]

        print("delta_P_delta_r(eta, mass, pressure) = (%f, %e, %e)" % (eta, mass, pressure))

        energy_density = self.__eos.energy_from_pressure(pressure)

        # print("delta_M_delta_r(eta, mass, pressure, energy) = (%f, %f, %f, %f)" % (eta, mass, pressure, energy_density))

        return -1*((energy_density + pressure) * (pressure * eta**3. + mass)) / ((eta ** 2.) * (1. - (2. * mass / eta)))

