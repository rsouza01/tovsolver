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


import sys
import getopt
import ConfigParser as cp
from collections import namedtuple


class ConfigParameters(namedtuple('ConfigParameters',
                                  'eos_file_name cutoff_density inferior_lim superior_lim ode_steps')):
    """
    Named tuple that represents the parameters in the file tov_solver.conf
    """
    pass


def usage():
    print(
        "Usage: \n" +
        "    tov_solver.py <--config=config_file_name --rho_0=9.9D+9> \n")


def config_section_map(config, section):
    dict1 = {}
    options = config.options(section)

    for option in options:
        try:
            dict1[option] = config.get(section, option)
        except:
            print("exception on %s!" % option)
            dict1[option] = None

    return dict1


def get_cl_parameters(argv):
    """
    Extracts the command line parameters.
    :param argv:
    :return:
    """

    number_arguments = len(argv)

    if number_arguments == 0:
        usage()
        sys.exit(2)

    try:
        opts, args = getopt.getopt(argv, "hr:c:e:p:",
                                   ["help", "rho_0=", "config=", "epsilon=", "pressure="])
    except getopt.GetoptError as err:
        print(err)
        usage()
        sys.exit(2)

    config_file = "tov_solver.conf"
    rho_0 = 0.
    epsilon = 0
    pressure = 0

    for opt, arg in opts:

        if opt in ("-r", "--rho_0"):
            rho_0 = float(arg)

        elif opt in ("-c", "--config"):
            config_file = arg

        elif opt in ("-e", "--epsilon"):
            epsilon = float(arg)

        elif opt in ("-p", "--pressure"):
            pressure = float(arg)

        elif opt == '-h':
            usage()
            exit(0)
        else:
            assert False, "Unhandled exception."

    return rho_0, config_file, epsilon, pressure


def get_parameters_from_conf(config_name):
    config = cp.ConfigParser()
    config.read(config_name)

    # EOS Parameters
    eos_file_name = config_section_map(config, "EOS")["eos_file_name"]
    cutoff_density = float(config_section_map(config, "EOS")["cutoff_density"])

    # RK4 Parameters
    inferior_lim = config_section_map(config, "RK4")["inferior_lim"]
    superior_lim = config_section_map(config, "RK4")["superior_lim"]
    ode_steps = config_section_map(config, "RK4")["ode_steps"]

    config = ConfigParameters(eos_file_name, cutoff_density, inferior_lim, superior_lim, ode_steps)

    return config
