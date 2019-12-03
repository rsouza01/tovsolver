#================================================
# Authors:  
#		Rodrigo Souza 
#		<rsouza01@gmail.com>
#       2015-06-07
#================================================

import numpy as np
import scipy.special as scps

import Atomic_Constants as ac
import scipy
import math
from enum import Enum

from scipy.optimize import fsolve


fm = 5.07e-3


#================================================
# QCD
#================================================
'''
Here come the nucleons.
'''
class Nucleons(Enum):
    proton = 0
    neutron = 1
    
nucleons_masses = np.array([938, 939])


'''
Quarks are ordered here from lower to higher masses.
'''
class Quarks(Enum):
    up = 0
    down = 1
    strange = 2
    charm = 3
    bottom = 4
    top = 5
    
"""
Quarks masses
Source: https://en.wikipedia.org/wiki/Quark :-(
"""
quark_masses = np.array([5, 7, 150, 1290, 4200, 173000]) * fm

quark_fermi_momenta = np.array([1, 1, 1, 1, 1, 1])


class Leptons(Enum):
    electron = 0
    muon = 1
    tau = 2
    electron_neutrino = 3
    muon_neutrino = 4
    tau_neutrino = 5
    
"""
Lepton masses.
Source: https://en.wikipedia.org/wiki/Lepton :-(
"""
lepton_masses = np.array([0.5, 106, 1777, 0, 0.17, 15.5]) * fm

#================================================
#Constants
#================================================


qcd_coupling_g = 1

B_QCD = 1

dynamic_gluon_mass = 1

eos_quark_masses = quark_masses[3:]

"""
Quark degeneracy factor
"""
gamma_Q = 6.
gamma_E = 2.

m_parameter = 1

electron_mass = lepton_masses[Leptons.electron.value]

#================================================
#FUNCTIONS
#================================================

def mu(K_F_i, m_i):
	return np.sqrt(K_F_i**2. + m_i ** 2.)

def println(message):
	print message


"""
Energy
"""

def eos_energy(rho, dynamic_gluon_mass, particles_momenta):
    
    # particles_momenta = [k_u, k_d, k_s, k_e]
    quarks_momenta = np.asarray(particles_momenta[:3])      # [k_u, k_d, k_s]
    electron_momentum = np.asarray(particles_momenta[-1])   # k_e

    varepsilon = (27. * qcd_coupling_g ** 2. / (16 * dynamic_gluon_mass ** 2.)) * rho ** 2. + \
                 B_QCD + \
                 energy_quarks(rho, quarks_momenta) + \
                 energy_electrons(rho, electron_momentum)  # last item

    return varepsilon
    

def energy_quarks(rho, quark_fermi_momenta):

    mu_quarks = mu(quark_fermi_momenta, eos_quark_masses)

    varepsilon = 3 * gamma_Q / (2. * math.pi ** 2.) * \
                 np.sum(
                     quark_fermi_momenta ** 3. * mu_quarks / 4. +
                     eos_quark_masses ** 2. * quark_fermi_momenta * mu_quarks / 8. -
                     eos_quark_masses ** 4. / 8. * np.log(quark_fermi_momenta + mu_quarks) +
                     (eos_quark_masses ** 4. / 16.) * np.log(eos_quark_masses ** 2.)) 

    return varepsilon


def energy_electrons(rho, electron_momentum):
    mu_electron = mu(electron_momentum, electron_mass)

    varepsilon = gamma_Q / (2. * math.pi ** 2.) * \
                 (
                     electron_momentum ** 3. * mu_electron / 4. +
                     electron_mass ** 2. * electron_momentum * mu_electron / 8. -
                     electron_mass ** 4. / 8. * np.log(electron_momentum + mu_electron) +
                     (electron_mass ** 4. / 16.) * np.log(electron_mass ** 2.))

    return varepsilon


"""
Pressure, parameterized by the fermi momenta.
"""
def pressure_q(rho, dynamic_gluon_mass, particles_momenta):

    # particles_momenta = [k_u, k_d, k_s, k_e]
    quarks_momenta = np.asarray(particles_momenta[:3])      # [k_u, k_d, k_s]
    electron_momentum = np.asarray(particles_momenta[-1])   # k_e

    mu_quarks = mu(quark_fermi_momenta, eos_quark_masses)
    mu_electron = mu(electron_momentum, electron_mass)

    pressure = (27. * qcd_coupling_g ** 2. / (16 * dynamic_gluon_mass ** 2.)) * rho ** 2. - \
                 B_QCD + \
                 gamma_Q / (2. * math.pi ** 2.) * \
                 np.sum(
                     quark_fermi_momenta ** 3. * mu_quarks / 4. -
                     3.*eos_quark_masses ** 2. * quark_fermi_momenta * mu_quarks / 8. + \
                     3.*eos_quark_masses ** 4. / 8. * np.log(quark_fermi_momenta + mu_quarks) - \
                     (3.*eos_quark_masses ** 4. / 16.) * np.log(eos_quark_masses ** 2.)) + \
                 gamma_Q / (6. * math.pi ** 2.) * \
                 ( \
                     electron_momentum ** 3. * mu_electron / 4. - \
                     3.*electron_mass ** 2. * electron_momentum * mu_electron / 8. + \
                     3.*electron_mass ** 4. / 8. * np.log(electron_momentum + mu_electron) - \
                     (3.*electron_mass ** 4. / 16.) * np.log(electron_mass ** 2.))
                     

    return pressure

def quarks_momenta(p, parameters):

    # Variaveis
    ku, kd, ks, ke = p

    # Parametros
    rho, mu, md, ms, me = parameters

    # Lista de 
    return (
        ku**3 + kd**3 + ks**3 - 3*math.pi**2 * rho,
        2*ku**3 - kd**3 - ks**3 - ke**3, 
        kd**2 + md**2 -  ks**2 - ms**2, 
        (ku**2 + mu**2)**(.5)  + (ke**2 + me**2)**(.5) - (ks**2 + ms**2)**(.5)
    )

number_output = 6
output_formaters = "{: >20} "*number_output
    
    
def print_program_header():
    println ("="*125)
    println (" "* 45 + " MFTQCD EOS file generator")
    println ("="*125)

    
def print_header():
        
    header = ["rho", "ku", "kd", "ks", "ke", "bag"]

    separator = "="*20
    separators = [separator] * len(header)

    print(output_formaters.format(*separators))
    print(output_formaters.format(*header))
    print(output_formaters.format(*separators))


def print_footer():
    print_header()   

#================================================
#FUNCTION MAIN
#================================================


def fFuncMain():
    print_program_header()
    print_header()

    for rho in np.linspace(0.15, 0.6, 10):
        fsolve_parameters = [rho,
                             eos_quark_masses[Quarks.up.value],
                             eos_quark_masses[Quarks.down.value],
                             eos_quark_masses[Quarks.strange.value],
                             lepton_masses[Leptons.electron.value]]


        # ku, kd, ks, ke = fsolve(quarks_momenta, (1, 1, 1, 1), fsolve_parameters).tolist()
        # print rho, ku, kd, ks, ke

        k_solution = fsolve(quarks_momenta, (1, 1, 1, .1), fsolve_parameters).tolist()

        energy = eos_energy(rho, 1, k_solution)
        print energy


        # bag_constant = (((nucleons_masses[Nucleons.neutron.value]*rho)-(eq + ee - pq - pe)) /2);
        bag_constant = 1

        i_line = ([rho] + k_solution + [bag_constant])

        number_output = 6
        output_formaters = "{: >20} " * number_output
        print(output_formaters.format(*i_line))

    print_footer()
