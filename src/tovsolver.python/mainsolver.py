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
import cgs_constants as const
import math

import numpy as np
import scipy.integrate as integrate

import matplotlib.pyplot as plt


class TOVSolverConfig:
    """ Configuration class for TOV equation solving. """

    def __init__(self, central_mass_density=0.0, cutoff_density=0.0, eos_file_name="", config_name="tov_solver.conf"):
        self.__central_mass_density = central_mass_density
        self.__central_energy = central_mass_density * const.LIGHT_SPEED**2
        self.__cutoff_density = cutoff_density

        self.__config_name = config_name
        self.__eos_file_name = eos_file_name

        self.__a = (const.LIGHT_SPEED**2. /
                    (4. * math.pi * const.GRAVITATIONAL_CONSTANT * self.__central_mass_density)) ** .5

        self.__m_star = 4. * math.pi * self.__central_mass_density * self.__a ** 3.

        # print("__cutoff_density = {}".format(self.__cutoff_density))
        # print("a = {}".format(self.__a))
        # print("M* = {}".format(self.__m_star))

    def getCutoffDensity(self):
        return self.__cutoff_density

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
    __ode_steps = 20

    def __init__(self, tov_solver_config):

        self.__config = tov_solver_config

        # TODO: File name must be read from config file.
        self.__eos = EoS(self.__config.getEoSFileName(),
                         self.__config.getCentralEnergy(),
                         verbose=False)

    def evaluate(self, epsilon, pressure):

        eval_epsilon = 0
        eval_pressure = 0

        pressure_0 = self.__eos.pressure_from_energy(1.)
        # pressure_0 = 0

        if epsilon > 0:
            eval_pressure = self.__eos.pressure_from_energy(epsilon)

        if pressure > 0:
            eval_epsilon = self.__eos.energy_from_pressure(pressure)

        self.output_interpolation_header(self.__config.getConfigFileName(),
                                         self.__config.getEoSFileName(),
                                         self.__config.getCentralEnergy(),
                                         pressure_0 * self.__config.getCentralEnergy(),
                                         eval_epsilon * self.__config.getCentralEnergy(),
                                         eval_pressure * self.__config.getCentralEnergy())

    def run(self):
        tovEquations = TOVEquations(self.__eos)

        # Initial conditions, all values dimensionless.
        mass_0 = 0
        energy_0 = 1
        pressure_0 = float(self.__eos.pressure_from_energy(energy_0))

        self.output_header(self.__config.getConfigFileName(),
                           self.__config.getEoSFileName(),
                           self.__config.getCentralEnergy(),
                           pressure_0 * self.__config.getCentralEnergy(),
                           self.__config.getCutoffDensity(),
                           self.__config.getRadiusScaleFactor(),
                           self.__config.getMassScaleFactor())

        rk_parameters = RungeKuttaParameters(
            first_element=self.__inferior_lim,
            last_element=self.__superior_lim,
            rk_steps=self.__ode_steps,
            derivatives=[tovEquations.delta_M_delta_eta, tovEquations.delta_P_delta_eta],
            initial_conditions=[mass_0, pressure_0],
            verbose=False)

        # print("self.__config.getCutoffDensity() = {}".format(type(self.__config.getCutoffDensity())))
        # print("self.__config.getCentralEnergy() = {}".format(type(self.__config.getCentralEnergy())))

        rk4 = TOVRungeKutta(rk_parameters,
                            self.__config.getCutoffDensity()*const.LIGHT_SPEED**2. /
                            self.__config.getCentralEnergy())

        rk4.run()

        # TODO: this part can be improved.

        results = rk4.getResult()

        star_mass = results.mass * self.__config.getMassScaleFactor() / const.SUN_MASS

        # The result is dimensionless. It must be converted to km.
        star_radius = results.eta * self.__config.getRadiusScaleFactor() * const.LENGTH_TO_KM

        # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
        # Aqui voutentar usar a receita de bolo de
        # http://scipy-cookbook.readthedocs.org/items/CoupledSpringMassSystem.html
        # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

        # ODE solver parameters
        abserr = 1.0e-8
        relerr = 1.0e-6
        stoptime = 10.0
        numpoints = 250
        w0 = [mass_0, pressure_0]
        p = []

        t = [stoptime * float(i) / (numpoints - 1) for i in range(numpoints)]

        wsol = integrate.odeint(tovEquations.vector_field, w0, t, args=(p,), atol=abserr, rtol=relerr)

        print(wsol)

        for solution in wsol:
            plt.plot(t, solution, label='Pressure')

            # plot results
            print("Plotting...")
            plt.grid(True)
            plt.figure(2)



        # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #


        self.output_summary(star_mass, star_radius, 0, 0, 0, 0)

        # eta = np.linspace(self.__inferior_lim, self.__superior_lim, self.__ode_steps)
        #
        # for solution in tov_solution:
        #     plt.plot(eta, solution, label='Pressure')
        #
        #     # plot results
        #     print("Plotting...")
        #     plt.grid(True)
        #     plt.figure(2)

    def output_header(self, config_file_name, eos_file_name, epsilon_0, pressure_0, cutoff_density, scale_radius, scale_mass):
        header_format = \
            ("#---------------------------------------------------------------------------------------------\n"
             "#--------------------------------  TOV Solver - Solver Mode  ---------------------------------\n"
             "#---------------------------------------------------------------------------------------------\n"
             "# Config File         : {}\n"
             "# EoS File            : {}\n"
             "# EPSILON_0 (MeV/fm3) : {}\n"
             "# PRESSURE_0          : {}\n"
             "# CUTOFF_DENSITY      : {}\n"
             "# SCALE_RADIUS        : {:0.05e}\n"
             "# SCALE_MASS          : {:0.05e}")

        print(header_format.format(config_file_name,
                                   eos_file_name,
                                   epsilon_0,
                                   pressure_0,
                                   cutoff_density,
                                   scale_radius,
                                   scale_mass))

    def output_summary(self, star_mass, star_radius, baryon_number, info_entropy, diseq, complexity):
        summary_format = \
            ("#---------------------------------------------------------------------------------------------\n"
             "#                                            SUMMARY\n"
             "#---------------------------------------------------------------------------------------------\n"
             "#\n"
             "# Star Radius (km)            : {}\n"
             "#\n"
             "# Star Mass (Solar Units)     : {}\n"
             "#\n"
             "# Baryon Number               : {}\n"
             "#\n"
             "# Information Entropy         : {}\n"
             "# Disequilibrium              : {}\n"
             "# Complexity                  : {}\n"
             "#\n"
             "#---------------------------------------------------------------------------------------------\n")

        print(summary_format.format(star_radius, star_mass, baryon_number, info_entropy, diseq, complexity))

    def output_interpolation_header(self, config_file_name, eos_file_name, epsilon_0, pressure_0, epsilon, pressure):
        header_format = \
            ("#---------------------------------------------------------------------------------------------\n"
             "#----------------------------  TOV Solver - Interpolation Mode  ------------------------------\n"
             "#---------------------------------------------------------------------------------------------\n"
             "# Config File         : {}\n"
             "# EoS File            : {}\n"
             "# EPSILON_0 (MeV/fm3) : {}\n"
             "# PRESSURE_0          : {:05f}\n"
             "#---------------------------------------------------------------------------------------------\n"
             "# Epsilon             : {:05f}\n"
             "# Epsilon (admin)     : {:05f}\n"
             "# Pressure            : {:05f}\n"
             "# Pressure (admin)    : {:05f}\n"
             "#---------------------------------------------------------------------------------------------\n")

        print(header_format.format(config_file_name,
                                   eos_file_name,
                                   epsilon_0,
                                   pressure_0,
                                   epsilon,
                                   epsilon/epsilon_0,
                                   pressure,
                                   pressure/epsilon_0))
