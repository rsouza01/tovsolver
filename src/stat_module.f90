!-----------------------------------------------------------------------
!
! RAdS Jan12.
! Copyright (C) 2011-2014 by Rodrigoo Alvares de Souza.
! Mail: <rsouza01@gmail.com>. Web: "http://www.astro.iag.usp.br/~rsouza/".
! This program may be copied and/or distributed freely. See the
! _ terms and conditions in the files in the doc/ subdirectory.
!
!
! MODULE: stat_module
!
!> @author
!> Rodrigo Souza
!
! DESCRIPTION:
!> Information theory related stuff
!
!-----------------------------------------------------------------------
module stat_module
use types
use global_constants
use config_module
use util

	implicit none

	contains

	double precision function calc_infor_entropy(parameters, t, Y, V)
    implicit none
        type(ConfigParameters) :: parameters
        double precision :: t
        double precision :: Y(N_DIFF_EQUATIONS)
        double precision :: V(N_VARIABLES)

        double precision :: delta_radius
        double precision :: rho
        double precision :: radius

        calc_infor_entropy = 0.

        if (V(IDX_ENERGY_DENSITY_BAR) > 0.) then

            radius = (parameters%scale_radius * t) * &
                CONVERSION_LENGTH(parameters%UNIT_SYSTEM)

            delta_radius = (parameters%scale_radius * parameters%diff_eq_step) * &
                CONVERSION_LENGTH(parameters%UNIT_SYSTEM)
            !write(*,*) "(radius, delta_radius) = (", radius, ", ", delta_radius, ")"

            rho = V(IDX_ENERGY_DENSITY_BAR) * parameters%RHO_0
            !write(*,*) "(rho) = (", rho, ")"

            !write(*,*) radius, ",", rho

            calc_infor_entropy = - parameters%K_entropy * &
                rho * log_n(rho, 2.0D0) * &
                    4 * const_pi * radius**2. * delta_radius

            !write(*,*) "(coord_radial, densidade, delta_raio, I_parcial) = (", &
            !    radius, ", ", rho, ", ", delta_radius, ", ", calc_infor_entropy, ")"

        end if

        !write(*,*) "(infor_entropy, radius, delta_eta, rho) = (", calc_infor_entropy, ", ", radius, ", ", delta_eta, ", ", rho, ")"

	end function calc_infor_entropy


	double precision function calc_infor_disequilibrium(parameters, t, Y, V)
    implicit none
        type(ConfigParameters) :: parameters
        double precision :: t
        double precision :: Y(N_DIFF_EQUATIONS)
        double precision :: V(N_VARIABLES)

        double precision :: radius
        double precision :: delta_radius
        double precision :: rho

        delta_radius = (parameters%scale_radius * parameters%diff_eq_step) * &
            CONVERSION_LENGTH(parameters%UNIT_SYSTEM)

        radius = (parameters%scale_radius * t) * &
            CONVERSION_LENGTH(parameters%UNIT_SYSTEM)

        rho = V(IDX_ENERGY_DENSITY_BAR) * parameters%RHO_0

        calc_infor_disequilibrium = parameters%K_entropy * rho**2 * 4. * const_pi * radius**2. * delta_radius

	end function calc_infor_disequilibrium


	double precision function calc_baryon_number(parameters, t, Y, V)
    implicit none
        type(ConfigParameters) :: parameters
        double precision :: t
        double precision :: Y(N_DIFF_EQUATIONS)
        double precision :: V(N_VARIABLES)

        double precision :: delta_eta
        double precision :: metric_term
        double precision :: barionic_density
        double precision :: radius
        double precision :: mass
        double precision :: scale_radius
        double precision :: scale_mass

        scale_radius = parameters%scale_radius

        scale_mass = parameters%scale_mass

        delta_eta = scale_radius * parameters%diff_eq_step

        radius = scale_radius * t

        mass = scale_mass * V(IDX_MASS_BAR)

        barionic_density = parameters%BARYONIC_DENSITY_0 * &
            barionic_density_from_eos_table(parameters, V(IDX_ENERGY_DENSITY_BAR))

        metric_term = 1. - 2. * GRAVITATIONAL_CONSTANT(parameters%UNIT_SYSTEM) * mass / &
            (LIGHT_SPEED_SCALE(parameters%UNIT_SYSTEM)**2. * radius)

        calc_baryon_number = 4. * const_pi * (metric_term)**(-0.5) * &
            radius** 2. * barionic_density * delta_eta

        !write (*, *) "(radius, barionic_density, calc_baryon_number) = (", radius, &
        !   ", " , barionic_density, ", ", calc_baryon_number, ")"

        !write(*,*) "(metric_term, calc_baryon_number) = ", metric_term, calc_baryon_number

	end function calc_baryon_number



end module stat_module
