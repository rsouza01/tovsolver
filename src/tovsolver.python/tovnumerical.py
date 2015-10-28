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

class TOVRungeKutta(RungeKutta):
    """ TOV Runge Kutta implementation. """

    def __init__(self, rk_parameters):

        super(TOVRungeKutta, self).__init__(rk_parameters)
        self.__star_eta = 0
        self.__star_mass = 0

    def must_stop(self, eta, ws):

        if ws[1] <= 0:
            self.__star_eta = eta
            self.__star_mass = ws[0]

            return True
        else:
            return False

    def perform_calculations(self, eta, ws):
        pass

    def getMass(self):
        return self.__star_mass

    def getRadius(self):
        return self.__star_eta