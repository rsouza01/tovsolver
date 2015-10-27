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


from eos import EoS
from scipy import integrate
from tovequations import TOVEquations

import numpy as np

import matplotlib.pyplot as plt

class TOVSolverConfig:
    """ Configuration class for TOV equation solving. """

    def __init__(self, central_energy=0.0):
        self.central_energy = central_energy


    def getCentralEnergy(self):
        return self.central_energy


class TOVSolver:
    """ TOV equation solver. """

    __inferior_lim = 1e-15
    __superior_lim = 3
    __ode_steps = 2000

    def __init__(self):
        pass

    def __init__(self, tovsolverconfig):
        self.__config = tovsolverconfig

    def run(self):

        print('TOVSolver running...')

        eos = EoS("EoS-OFICIAL-SLy4-tabelada-sem-fit.csv", self.__config.getCentralEnergy())

        tovEquations = TOVEquations(eos)

        eta = np.linspace(self.__inferior_lim, self.__superior_lim, self.__ode_steps)

        energy_0 = 1

        # Initial conditions
        pressure_0 = eos.pressure_from_energy(energy_0)
        mass_0 = 0

        y_0 = [mass_0, pressure_0]

        params = [0]
        tov_solution = integrate.odeint(tovEquations.fTOV, y_0, eta, args=(params,), full_output=1, mxstep=50000)


        # for solution in tov_solution:
        #     plt.plot(eta, solution, label='Pressure')
        #
        #     # plot results
        #     print("Plotting...")
        #     plt.grid(True)
        #     plt.figure(2)
2
