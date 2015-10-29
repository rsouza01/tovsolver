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


from eos import EoS
from tovequations import TOVEquations
from numerical import RungeKuttaParameters
from tovnumerical import TOVRungeKutta
import atomic_constants as atmc
import math

import numpy as np

import matplotlib.pyplot as plt


class TOVSolverConfig:
    """ Configuration class for TOV equation solving. """

    def __init__(self, central_energy=0.0, eos_file_name="", config_name="tov_solver.conf"):
        self.__central_energy = central_energy
        self.__config_name = config_name
        self.__eos_file_name = eos_file_name

        self.__a = (atmc.LIGHT_SPEED ** 2. / (4. * math.pi * atmc.GRAVITATIONAL_CONSTANT * self.__central_energy)) ** .5
        self.__m_star = 4. * math.pi * self.__central_energy * self.__a ** 3.

    def getRadiusScaleFactor(self):
        return self.__a

    def getMassScaleFactor(self):
        return self.__m_star

    def getCentralEnergy(self):
        return self.__central_energy

    def getConfigFileName(self):
        return self.__config_name

    def getEoSFileName(self):
        return self.__eos_file_name


class TOVSolver:
    """ TOV equation solver. """

    __inferior_lim = 1e-15
    __superior_lim = 3
    __ode_steps = 2000

    def __init__(self, tov_solver_config):
        self.__config = tov_solver_config

    def run(self):

        self.output_header()

        # TODO: File name must be read from config file.
        eos = EoS(self.__config.getEoSFileName(),
                  self.__config.getCentralEnergy(),
                  verbose=False)

        tovEquations = TOVEquations(eos)

        # Initial conditions, all values dimensionless.

        mass_0 = 0
        # energy_0 = 1
        # pressure_0 = eos.pressure_from_energy(energy_0)
        pressure_0 = 0.474932

        rk_parameters = RungeKuttaParameters(
            first_element=self.__inferior_lim,
            last_element=self.__superior_lim,
            rk_steps=self.__ode_steps,
            functions=[tovEquations.delta_M_delta_eta, tovEquations.delta_P_delta_eta],
            initial_conditions=[mass_0, pressure_0],
            verbose=False)

        rk4 = TOVRungeKutta(rk_parameters)

        rk4.run()

        star_mass = rk4.getMass() * self.__config.getMassScaleFactor() / atmc.SUN_MASS

        # The result is dimensionless. It must be converted to km.
        star_radius = rk4.getRadius() * self.__config.getRadiusScaleFactor() * 1e-18

        self.output_summary(star_mass, star_radius)

        # eta = np.linspace(self.__inferior_lim, self.__superior_lim, self.__ode_steps)
        #
        # for solution in tov_solution:
        #     plt.plot(eta, solution, label='Pressure')
        #
        #     # plot results
        #     print("Plotting...")
        #     plt.grid(True)
        #     plt.figure(2)

    def output_header(self):

        header_format = \
            ("#---------------------------------------------------------------------------------------------\n"
             "#                     TOV Solver\n"
             "#---------------------------------------------------------------------------------------------\n"
             "# Config File     : {}\n"
             "# EoS File        : {}\n"
             "# RHO_0 (MeV/fm3) : {}\n"
             "# P_0             : 0\n"
             "# SCALE_RADIUS    : 0\n"
             "# SCALE_MASS      : 0\n"
             "#---------------------------------------------------------------------------------------------\n")

        print(header_format.format(
            self.__config.getConfigFileName(),
            self.__config.getEoSFileName(),
            self.__config.getCentralEnergy()))

    def output_summary(self, star_mass, star_radius):

        summary_format = \
            ("#---------------------------------------------------------------------------------------------\n"
             "#                                            SUMMARY\n"
             "#---------------------------------------------------------------------------------------------\n"
             "#\n"
             "# Star Radius (km)            : {}\n"
             "#\n"
             "# Star Mass (Solar Units)     : {}\n"
             "#\n"
             "# Baryon Number               :\n"
             "#\n"
             "# Information Entropy         :\n"
             "# Disequilibrium              :\n"
             "# Complexity                  :\n"
             "#\n"
             "#---------------------------------------------------------------------------------------------\n")

        print(summary_format.format(star_radius, star_mass))
