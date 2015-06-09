!-----------------------------------------------------------------------
!
! RAdS Jan12.
! Copyright (C) 2011-2014 by Rodrigo Alvares de Souza.
! Mail: <rsouza01@gmail.com>. Web: "http://www.astro.iag.usp.br/~rsouza/".
! This program may be copied and/or distributed freely. See the
! _ terms and conditions in the files in the doc/ subdirectory.
!
!
! MODULE: tov_module
!
!> @author
!> Rodrigo Souza
!
! DESCRIPTION:
!> TOV related types and functions (EDO's and stuff)
!
!-----------------------------------------------------------------------
module tov_module

use types
use global_constants
use config_module
use output_module
use cubic_spline_module
use stat_module

    implicit none

    contains


    !> \brief Set initial conditions
    !!
    !! \param parameters
    !! \param Y
    !! \param V
    !!
    subroutine set_initial_conditions(parameters, Y, V)
    implicit none

        type(ConfigParameters) :: parameters
        double precision :: Y(N_DIFF_EQUATIONS)
        double precision :: V(N_VARIABLES)

        !Initial conditions

        !n = R_bar = 0
        V(IDX_RADIUS_BAR) = 0.

        !M_bar(0) = 0
        V(IDX_MASS_BAR) = 0.

        !Rho_bar(0) = RHO_0 / RHO_ADIM
        V(IDX_RHO_BAR) = parameters%RHO_0 / parameters%RHO_ADIM

        !P_bar(0) = P_0/(Rho_0 * c^2)
        V(IDX_PRESSURE_BAR) = parameters%P_0_bar

        V(IDX_ENERGY_DENSITY_BAR) = V(IDX_RHO_BAR)

        V(IDX_BARYON_NUMBER) = 0.

        V(IDX_INFOR_ENTROPY) = 0.
        V(IDX_DISEQUILIBRIUM) = 0.

        Y(IDX_EQN_DM_DN) = 0.
        Y(IDX_EQN_DP_DN) = V(IDX_PRESSURE_BAR)


        !write (*,*) &
        !    '(IDX_MASS_BAR, IDX_PRESSURE_BAR, IDX_ENERGY_DENSITY_BAR, IDX_RADIUS_BAR, IDX_RHO_BAR) = (', &
        !    V(IDX_MASS_BAR), ' ,', V(IDX_PRESSURE_BAR), ' ,', V(IDX_ENERGY_DENSITY_BAR), ' ,', &
        !    V(IDX_RADIUS_BAR), ' ,', V(IDX_RHO_BAR), ')'


    end subroutine set_initial_conditions

    !> \brief The calculations that should be performed after the runge-kutta.
    !! Conversions and other values that should be calculated go here
    !!
    !! \param parameters
    !! \param t
    !! \param Y
    !! \param V
    !!
    subroutine process_specific_calculations(parameters, t, Y, V)
        type(ConfigParameters) :: parameters
        double precision :: t
        double precision :: Y(N_DIFF_EQUATIONS)
        double precision :: V(N_VARIABLES)

        !OK
        !write (*,*) &
        !    '(IDX_MASS_BAR, IDX_PRESSURE_BAR, IDX_ENERGY_DENSITY_BAR, IDX_RADIUS_BAR, IDX_RHO_BAR) = (', &
        !    V(IDX_MASS_BAR), ' ,', V(IDX_PRESSURE_BAR), ' ,', V(IDX_ENERGY_DENSITY_BAR), ' ,', &
        !    V(IDX_RADIUS_BAR), ' ,', V(IDX_RHO_BAR), ')'

        V(IDX_RADIUS_BAR) = t;

        V(IDX_PRESSURE_BAR) = Y(IDX_EQN_DP_DN);

        V(IDX_ENERGY_DENSITY_BAR) = energy_density_from_eos(parameters, t, Y, V);

        V(IDX_RHO_BAR) = V(IDX_ENERGY_DENSITY_BAR);

        V(IDX_MASS_BAR) = Y(IDX_EQN_DM_DN);

        V(IDX_INFOR_ENTROPY) = V(IDX_INFOR_ENTROPY) + calc_infor_entropy(parameters, t, Y, V);
        V(IDX_DISEQUILIBRIUM) = V(IDX_DISEQUILIBRIUM) + calc_infor_disequilibrium(parameters, t, Y, V);

        V(IDX_SPEED_OF_SOUND) = SQRT((parameters%P_0 * V(IDX_PRESSURE_BAR))/ &
            (parameters%ENERGY_DENSITY_0 * V(IDX_RHO_BAR))) * &
            LIGHT_SPEED_SCALE(parameters%UNIT_SYSTEM)

        if (parameters%eos_file_provides_baryonic_density) then
            V(IDX_BARYON_NUMBER) = V(IDX_BARYON_NUMBER) + calc_baryon_number(parameters, t, Y, V);
        end if


        !write (*,*) V(IDX_ENERGY_DENSITY_BAR) * (parameters%RHO_ADIM * LIGHT_SPEED(parameters%UNIT_SYSTEM)**2.), &
        !', ', V(IDX_PRESSURE_BAR)* (parameters%RHO_ADIM * LIGHT_SPEED(parameters%UNIT_SYSTEM)**2.)


    end subroutine process_specific_calculations

    !---------------------------------------------------------------------------
    ! DESCRIPTION:
    !> Evaluates derivatives at a point
    !---------------------------------------------------------------------------
    double precision function derivative(parameters, t, Y, V, equationNumber)
    implicit none
        type(ConfigParameters) :: parameters
        double precision :: t, Y(N_DIFF_EQUATIONS), V(N_VARIABLES)
        integer :: equationNumber

        double precision :: returnValue

        !write (*,*) &
        !    '(IDX_MASS_BAR, IDX_PRESSURE_BAR, IDX_ENERGY_DENSITY_BAR, IDX_RADIUS_BAR, IDX_RHO_BAR) = (', &
        !    V(IDX_MASS_BAR), ' ,', V(IDX_PRESSURE_BAR), ' ,', V(IDX_ENERGY_DENSITY_BAR), ' ,', &
        !    V(IDX_RADIUS_BAR), ' ,', V(IDX_RHO_BAR), ')'

        select case (equationNumber)
            case (IDX_EQN_DM_DN)
                  returnValue = dM_dn(parameters, t, Y, V);

            case (IDX_EQN_DP_DN)

                    if (parameters%RHO_0 <= parameters%cutoff_RHO_0) then
                        returnValue = dP_dN_Newtonian(parameters, t, Y, V);
                    else
                        returnValue = dP_dn_Relativistic(parameters, t, Y, V);
                    end if

            case default
                returnValue = 0.;

        end select

        derivative = returnValue

    end function derivative

    !---------------------------------------------------------------------------
    ! DESCRIPTION:
    !> Evaluates the pressure P at a point
    !
    !> Compute \f$ P \f$
    !---------------------------------------------------------------------------
    double precision function dM_dn(parameters, t, Y, V)
    implicit none
        type(ConfigParameters) :: parameters
        double precision :: t
        double precision :: Y(N_DIFF_EQUATIONS)
        double precision :: V(N_VARIABLES)

        double precision :: energy_density_bar

        !write (*,*) '(t, energy density) = (', t, ', ', V(IDX_ENERGY_DENSITY_BAR), ')'

        !V(IDX_ENERGY_DENSITY_BAR) = energy_density_from_eos(parameters, t, Y, V)
        energy_density_bar = energy_density_from_eos(parameters, t, Y, V);

        dM_dn = energy_density_bar * t**2.

    end function dM_dn



    !---------------------------------------------------------------------------
    ! DESCRIPTION:
    !> Evaluates the pressure P at a point (TOV)
    !
    !> Compute \f$ P \f$
    !---------------------------------------------------------------------------
    double precision function dP_dn_Relativistic(parameters, t, Y, V)
    implicit none
        type(ConfigParameters) :: parameters
        double precision :: t
        double precision :: Y(N_DIFF_EQUATIONS)
        double precision :: V(N_VARIABLES)

        double precision :: numerator, denominator

        double precision :: energy_density_bar
        double precision :: pressure_bar

        energy_density_bar = energy_density_from_eos(parameters, t, Y, V);
        pressure_bar = Y(IDX_PRESSURE_BAR);

        !write (*,*) &
        !    '(t, MASS, PRESSURE, ENERGY, RADIUS, RHO) = (', t, ', ', &
        !    V(IDX_MASS_BAR), ' ,', V(IDX_PRESSURE_BAR), ' ,', V(IDX_ENERGY_DENSITY_BAR), ' ,', &
        !    V(IDX_RADIUS_BAR), ' ,', V(IDX_RHO_BAR), ')'

        numerator = - (energy_density_bar + pressure_bar)*(pressure_bar*(t**3.) + V(IDX_MASS_BAR));

        denominator = (t**2.) * (1. - 2. * V(IDX_MASS_BAR) / t);

        !write (*,*) '(t, numerator, denominator)', t, ', ', numerator, ', ', denominator, ')'

        dP_dn_Relativistic = numerator / denominator;
    end function dP_dn_Relativistic

    !---------------------------------------------------------------------------
    ! DESCRIPTION:
    !> Evaluates the pressure P at a point (Newtonian)
    !
    !> Compute \f$ P \f$
    !---------------------------------------------------------------------------
    double precision function dP_dn_Newtonian(parameters, t, Y, V)
    implicit none
        type(ConfigParameters) :: parameters
        double precision :: t, Y(N_DIFF_EQUATIONS), V(N_VARIABLES)

        dP_dn_Newtonian = - (V(IDX_MASS_BAR) * V(IDX_ENERGY_DENSITY_BAR) / (t **2.))
    end function dP_dn_Newtonian

    !> \brief Function that decides whether the program must stop.
    !!
    !! \param parameters
    !! \param t
    !! \param Y
    !! \param V
    !! \return
    !!
    logical function can_stop(parameters, t, Y, V)
    implicit none
        type(ConfigParameters) :: parameters
        double precision :: t
        double precision :: Y(N_DIFF_EQUATIONS)
        double precision :: V(N_VARIABLES)

        !can_stop = (V(IDX_PRESSURE_BAR) <= 0.0 .OR. V(IDX_ENERGY_DENSITY_BAR) <= 0.0);
        can_stop = (V(IDX_RHO_BAR) <= parameters%cutoff_density_bar .OR. &
            V(IDX_PRESSURE_BAR) <= 0.0);

        !DEBUG
        !write (*,*) 'cutoff_density_bar, V(IDX_RHO_BAR) => ', parameters%cutoff_density_bar, &
        !    ',', V(IDX_RHO_BAR)


    end function can_stop

end module tov_module
