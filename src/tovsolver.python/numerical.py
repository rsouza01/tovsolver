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

import numpy as np
from collections import namedtuple


class RungeKuttaParameters(namedtuple('RungeKutta4', 'first_element last_element rk_steps initial_conditions functions verbose')):
    """
    Named tuple that represents the RK parameters
    """
    pass


class RungeKutta(object):
    """ Runge Kutta implementation. """

    def __init__(self, array_t, functions, initial_conditions, verbose=False):
        self.__array_t = array_t
        self.__functions = functions
        self.__initial_conditions = initial_conditions
        self.__verbose = verbose

        print("initial_conditions = %s" % initial_conditions)


    def __init__(self, rk_parameters):

        self.__functions = rk_parameters.functions
        self.__initial_conditions = rk_parameters.initial_conditions
        self.__verbose = rk_parameters.verbose

        self.__first_element = rk_parameters.first_element
        self.__last_element = rk_parameters.last_element
        self.__total_steps = rk_parameters.rk_steps

        self.__h = (self.__last_element - self.__first_element)/self.__total_steps

        self.__array_t = np.linspace(self.__first_element, self.__last_element, self.__total_steps)

    def run(self):

        m = len(self.__functions)
        ws = self.__initial_conditions

        t = self.__first_element

        h = self.__h

        k1 = [0 for x in range(0, m)]
        k2 = [0 for x in range(0, m)]
        k3 = [0 for x in range(0, m)]
        k4 = [0 for x in range(0, m)]

        #print("k1=%s, k2=%s, k3=%s, k4=%s" % (k1, k2, k3, k4))

        #print("****************************************************\n")

        ws_k2 = []; ws_k3 = []; ws_k4 = [];

        # print(self.__array_t)

        for i in range(1, self.__total_steps):

            for j in range(0, m):
                k1[j] = h * self.__functions[j](t, ws)
            # print("k1 = %s" % str(k1))

            for j in range(0, m):
                ws_k2.append(ws[j] + 0.5*k1[j])

            for j in range(0, m):
                # ws_k2 = [el + 0.5*k1[j] for el in ws]
                k2[j] = h * self.__functions[j](t+0.5*h, ws_k2)
            # print("k2 = %s" % str(k2))

            for j in range(0, m):
                ws_k3.append(ws[j] + 0.5*k2[j])

            for j in range(0, m):
                # ws_k3 = [el + 0.5*k2[j] for el in ws]
                k3[j] = h * self.__functions[j](t+0.5*h, ws_k3)
            # print("k3 = %s" % str(k3))

            for j in range(0, m):
                ws_k4.append(ws[j] + k2[j])

            for j in range(0, m):
                # ws_k4 = [el + k3[j] for el in ws]
                k4[j] = h * self.__functions[j](t+h, ws_k4)
            # print("k4 = %s" % str(k4))

            for j in range(0, m):
                ws[j] += (k1[j] + 2.*k2[j] + 2.*k3[j] + k4[j])/6.

            t = self.__first_element + i * h

            if self.__verbose:
                print("(i, t, m, p) = (%d, %f, %e, %e)" % (i, t, ws[0], ws[1]))

            self.perform_calculations(t, ws)

            if(self.must_stop(t,ws)):
                print("Stop condition reached.")
                break

            # print("****************************************************\n")

        # TODO: Return interpolated functions.

        return ws

    def must_stop(self, eta, ws):
        return False

    def perform_calculations(self, eta, ws):
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

    #rk4 = RungeKutta(array_t=eta, functions=functions, initial_conditions=initial_conditions, verbose=True)

    #rk4.run()

