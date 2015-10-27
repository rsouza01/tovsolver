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

import numpy as np


class RungeKutta:
    """ Runge Kutta implementation. """

    def __init__(self, array_t, functions, initial_conditions, verbose=False):
        self.__array_t = array_t
        self.__functions = functions
        self.__initial_conditions = initial_conditions
        self.__verbose = verbose

    def run(self):

        m = len(self.__functions)

        alpha = self.__initial_conditions

        w = alpha

        h = self.__array_t[len(self.__array_t) - 1] - self.__array_t[0] / len(self.__array_t)

        t = self.__array_t[0]

        k1 = []
        k2 = []
        k3 = []
        k4 = []

        for i in self.__array_t:

            for j in range(0, m-1):
                k1.append(h * self.__functions[j](t, w))

            for j in range(0, m-1):
                k2.append(h * self.__functions[j](t+h/2, w + k1/2))

            for j in range(0, m-1):
                k3.append(h * self.__functions[j](t+h/2, w + k2/2))

            for j in range(0, m-1):
                k3.append(h * self.__functions[j](t+h, w + k3))

            for j in range(0, m-1):
                w = w + (k1 + 2*k2 + 2*k3 + k4)/6

            t = self.__array_t[0] + i * h

            if(self.__verbose == True):

                print("Iteration %i:")
                print("(i, t) = (%d, %d)" % (i,t))

        pass


def energy_density_interp(pressure):
    return 1

def delta_P_delta_r(eta, y):
    mass, pressure = y[0], y[1]
    energy_density = energy_density_interp(pressure)

    return - ((energy_density + pressure) * (pressure * eta**3. + mass)) / (eta ** 2. * (1. - (2. * mass / eta)))


def delta_M_delta_r(eta, y):
    mass, pressure = y[0], y[1]

    energy_density = energy_density_interp(pressure)

    return eta ** 2. * energy_density


if __name__ == '__main__':

    print("tovnumerical.py")

    functions = [delta_M_delta_r, delta_P_delta_r]
    initial_conditions = [0, 1]
    eta = np.linspace(1e-15, 10, 100)

    rk4 = RungeKutta(array_t=eta, functions=functions, initial_conditions=initial_conditions, verbose=True)

    rk4.run()
