!-----------------------------------------------------------------------
!
! RAdS Jan12.
! Copyright (C) 2011-2014 by Rodrigo Alvares de Souza.
! Mail: <rsouza01@gmail.com>. Web: "http://www.astro.iag.usp.br/~rsouza/".
! This program may be copied and/or distributed freely. See the
! _ terms and conditions in the files in the doc/ subdirectory.
!
!
! MODULE: output_module
!
!> @author
!> Rodrigo Souza
!
! DESCRIPTION:
!> Output related routines
!
!-----------------------------------------------------------------------
module output_module

use types
use global_constants

	implicit none

	contains

    !> \brief Prints the formated output (header).
    !!
    !! \param parameters
    !! \param t
    !! \param V
    !!
	subroutine print_header_output(parameters, t, V)
		type(ConfigParameters), intent(in) :: parameters
		double precision, intent(in) :: t
		double precision, intent(in) :: V(N_VARIABLES)

		write (*,'(A)') '#---------------------------------------------------------------------------------------------'
		write (*,'(A)') '#                                 PROFILES'
		write (*,'(A)') '#---------------------------------------------------------------------------------------------'
		write (*,'(A)') '#              t            mass_bar             rho_bar               P_bar'
		write (*,'(A)') '#--------------- ------------------- ------------------- -------------------'


	end subroutine print_header_output

    !> \brief Prints the formated output (footer).
    !!
    !! \param parameters
    !! \param t
    !! \param V
    !!
	subroutine print_footer_output(parameters, t, V)
		type(ConfigParameters) :: parameters
		double precision :: t
		double precision :: V(N_VARIABLES)

		write (*,'(A)') '#--------------- ------------------- ------------------- -------------------'
		write (*,'(A)') '#              t            mass_bar             rho_bar               P_bar'
		write (*,'(A)') '#---------------------------------------------------------------------------'


	end subroutine print_footer_output

    !> \brief Prints formated output to the screen.
    !!
    !! \param parameters
    !! \param t
    !! \param V
    !!
	subroutine print_formated_output(parameters, t, V)
		type(ConfigParameters), intent(in) :: parameters
		double precision, intent(in) :: t
		double precision, intent(in) :: V(N_VARIABLES)

		double precision :: radius

        character(len=50) :: eosData_Line       = "(A, F15.5, E20.10, E20.10, E20.10)"

		radius = t

        write (*, eosData_Line) ' ', t, &
                V(IDX_MASS_BAR), &
                V(IDX_RHO_BAR),  &
                V(IDX_PRESSURE_BAR)

        !write (*,*) '(t, mass, density, pressure) = (', t, ', ', V(IDX_MASS_BAR),', ', &
        !    V(IDX_RHO_BAR),', ', V(IDX_PRESSURE_BAR), ')'

	end subroutine print_formated_output

    !> \brief Prints the summary at the end of the execution.
    !!
    !! \param parameters
    !! \param t
    !! \param V
    !!
    subroutine print_summary(parameters, t, V)
		type(ConfigParameters) :: parameters
		double precision :: t
		double precision :: V(N_VARIABLES)

        double precision :: radiusUnitSystem

        radiusUnitSystem = V(IDX_RADIUS_BAR) * parameters%scale_radius

		write (*,'(A)') '#---------------------------------------------------------------------------------------------'
		write (*,'(A)') '#                      SUMMARY'
		write (*,'(A)') '#---------------------------------------------------------------------------------------------'

        write (*,'(A, E20.10)') '# Pressure                    : ', V(IDX_PRESSURE_BAR)

        !write (*,*) '# Pressure                    : ', V(IDX_PRESSURE_BAR)

        write (*,'(A)') '#'

        write (*,'(A, E20.10)') '# Star Radius (dimensionless) : ', V(IDX_RADIUS_BAR)
        write (*,*) '# Star Radius (', UNIT_SYSTEM_DESCR(parameters%UNIT_SYSTEM), ')           : ', &
            radiusUnitSystem

        write (*,*) '# Star Radius (Solar Units)   : ', &
            radiusUnitSystem/SOLAR_RADIUS(parameters%UNIT_SYSTEM)


        write (*,*) '# Star Radius (km)            : ', &
            radiusUnitSystem * CONVERSION_LENGTH(parameters%UNIT_SYSTEM)

        write (*,*) '#'

        write (*,*) '# Star Mass (dimensionless)   : ', V(IDX_MASS_BAR)
        write (*,*) '# Star Mass (', UNIT_SYSTEM_DESCR(parameters%UNIT_SYSTEM),')             : ', &
            V(IDX_MASS_BAR) * parameters%scale_mass
        write (*,*) '# Star Mass (Solar Units)     : ', &
            (V(IDX_MASS_BAR) * parameters%scale_mass) / (SOLAR_MASS(parameters%UNIT_SYSTEM))

        if (parameters%eos_file_provides_baryonic_density) then
            write (*,*) '#'
            write (*,*) '# Baryon Number               : ', V(IDX_BARYON_NUMBER)
        end if

        write (*,*) '#'

        write (*,*) '# Information Entropy         :  ', V(IDX_INFOR_ENTROPY)
        write (*,*) '# Disequilibrium              :  ', V(IDX_DISEQUILIBRIUM)
        write (*,*) '# Complexity                  :  ', exp(V(IDX_INFOR_ENTROPY)) * V(IDX_DISEQUILIBRIUM)

        write (*,*) '#'
		write (*,'(A)') '#---------------------------------------------------------------------------------------------'


	end subroutine print_summary

    !> \brief Print in the screen the parameters of the system.
    !!
    !! \param cl_parameters
    !! \param parameters
    !!
	subroutine print_config(cl_parameters, parameters)
		implicit none

		type(CommandLineParameters) :: cl_parameters
		type(ConfigParameters) :: parameters

		write (*,'(A)') '#---------------------------------------------------------------------------------------------'
        write (*,'(A, A)') '# Config File: ', cl_parameters%parameter_file
        write (*,'(A, A)') '# EoS File: ', parameters%eos_file_name

		write (*,'(A, i13)') '# max_rk_steps : ', parameters%max_rk_steps
		write (*,'(A, f8.5)') '# diff_eq_step : ', parameters%diff_eq_step
		write (*,'(A, f8.5)') '# interpolation_tolerance : ', parameters%interpolation_tolerance
		write (*,'(A, f8.5)') '# max_diff_eq_step : ', parameters%max_diff_eq_step
		write (*,'(A, f8.5)') '# min_diff_eq_step : ', parameters%min_diff_eq_step

        write (*,'(A, l)') '# output_summary_only: ', parameters%output_summary_only
        write (*,'(A, l)') '# verbose_eos: ', parameters%verbose_eos
        write (*,'(A, l)') '# verbose_interpolation_coeficients: ', parameters%verbose_interpolation_coeficients
        write (*,'(A, l)') '# output_gnuplot_style: ', parameters%output_gnuplot_style
        write (*,'(A, l)') '# eos_file_provides_baryonic_density: ', parameters%eos_file_provides_baryonic_density

        write (*,'(A, A)') '# INTERPOLATION METHOD : ', INTERPOLATION_METHODS_DESCR(parameters%INTERPOLATION_METHOD);

        write (*,'(A, A)') '# UNIT SYSTEM : ', UNIT_SYSTEM_DESCR(parameters%UNIT_SYSTEM);

        write (*,'(A, e10.5)') '# RHO_0 : ', parameters%RHO_0
        write (*,'(A, e10.5)') '# RHO_ADIM : ', parameters%RHO_ADIM
        write (*,'(A, e10.5)') '# cutoff_RHO_0 : ', parameters%cutoff_RHO_0
        write (*,'(A, e10.5)') '# cutoff_density : ', parameters%cutoff_density

        write (*,'(A, e10.5)') '# P_0 : ', parameters%P_0;

        if (parameters%eos_file_provides_baryonic_density) then
            write (*,'(A, e10.5)') '# BARYONIC_DENSITY_0 : ', parameters%BARYONIC_DENSITY_0
        end if

        write (*,'(A, e10.5)') '# SCALE_RADIUS : ', parameters%scale_radius
        write (*,'(A, e10.5)') '# SCALE_MASS : ', parameters%scale_mass


        write (*,'(A, e10.5)') '# log_base_calc_infor_entropy : ', parameters%log_base_calc_infor_entropy
        write (*,'(A, e10.5)') '# K_entropy : ', parameters%K_entropy

        if(parameters%verbose_eos .eqv. .true.) then
            call print_eos_table(cl_parameters, parameters)
        end if


		write (*,'(A)') '#---------------------------------------------------------------------------------------------'
        if(parameters%verbose_interpolation_coeficients .eqv. .true.) then
            call print_interpolation_table(cl_parameters, parameters)
        end if
		write (*,'(A)') ' '

	end subroutine print_config


    !> \brief Load in memory the values from the EoS Table.
    !!
    !! \param cl_parameters
    !! \param parameters
    !!
    subroutine print_eos_table(cl_parameters, parameters)
        implicit none

        type(CommandLineParameters) :: cl_parameters
        type(ConfigParameters) :: parameters

        Type(EquationOfStateValue), pointer :: eos_element

        character(len=50) :: eosData_Line       = "(A, i3, E15.5, E15.5, E15.5, E15.5, E15.5, E15.5)"


        eos_element => parameters%first_element

		write (*,'(A)') '#---------------------------------------------------------------------------------------------'
		write (*,'(A)') '# EoS Table'
		write (*,'(A)') '#---------------------------------------------------------------------------------------------'
		write (*,'(A)') '#  j      pressure           P_bar           rho         rho_bar     rho_baryon rho_baryon_bar'
		write (*,'(A)') '#--- -------------- -------------- -------------- -------------- -------------- --------------'

        do while(associated(eos_element%next_element))

            write (*, eosData_Line) '#', &
                    eos_element%idx_j, &
                    eos_element%pressure, &
                    eos_element%pressure_bar, &
                    eos_element%rho, &
                    eos_element%rho_bar, &
                    eos_element%baryonic_number_density, &
                    eos_element%baryonic_number_density_bar

            eos_element => eos_element%next_element
        end do

    end subroutine print_eos_table

    !> \brief Prints in the screen the coeficients calculated by the cubic spline interpolation.
    !!
    !! \param cl_parameters
    !! \param parameters
    !!
    subroutine print_interpolation_table(cl_parameters, parameters)
        implicit none

        type(CommandLineParameters) :: cl_parameters
        type(ConfigParameters) :: parameters

        Type(EquationOfStateValue), pointer :: eos_element

        character(len=50) :: eosData_Line       = "(A, i3, E15.5, E15.5, E15.5, E15.5, E15.5, E15.5)"

		write (*,'(A)') '#---------------------------------------------------------------------------------------------'
		write (*,'(A)') '# Cubic Spline Coeficients  - RHO_FROM_PRESSURE Table'
		write (*,'(A)') '#---------------------------------------------------------------------------------------------'
		write (*,'(A)') '#  j        rho_bar          P_bar              a              b              c              d'
		write (*,'(A)') '#--- -------------- -------------- -------------- -------------- -------------- --------------'
        eos_element => parameters%first_element
        do while(associated(eos_element%next_element))

            write (*, eosData_Line) '#', eos_element%idx_j, &
                    eos_element%rho_bar, eos_element%pressure_bar, &
                    eos_element%RHO_FROM_PRESSURE%a, & ! ',', &
                    eos_element%RHO_FROM_PRESSURE%b, & ! ',', &
                    eos_element%RHO_FROM_PRESSURE%c, & ! ',', &
                    eos_element%RHO_FROM_PRESSURE%d

            eos_element => eos_element%next_element
        end do
		write (*,'(A)') '#--- -------------- -------------- -------------- -------------- -------------- --------------'
		write (*,'(A)') '#  j        rho_bar          P_bar              a              b              c              d'
		write (*,'(A)') '#---------------------------------------------------------------------------------------------'

		write (*,'(A)') '#---------------------------------------------------------------------------------------------'
		write (*,'(A)') '# Cubic Spline Coeficients  - PRESSURE_FROM_RHO Table'
		write (*,'(A)') '#---------------------------------------------------------------------------------------------'
		write (*,'(A)') '#  j        rho_bar          P_bar              a              b              c              d'
		write (*,'(A)') '#--- -------------- -------------- -------------- -------------- -------------- --------------'
        eos_element => parameters%first_element
        do while(associated(eos_element%next_element))

            write (*, eosData_Line) '#', eos_element%idx_j, &
                    eos_element%rho_bar, eos_element%pressure_bar, &
                    eos_element%PRESSURE_FROM_RHO%a, & ! ',', &
                    eos_element%PRESSURE_FROM_RHO%b, & ! ',', &
                    eos_element%PRESSURE_FROM_RHO%c, & ! ',', &
                    eos_element%PRESSURE_FROM_RHO%d

            eos_element => eos_element%next_element
        end do
		write (*,'(A)') '#--- -------------- -------------- -------------- -------------- -------------- --------------'
		write (*,'(A)') '#  j        rho_bar          P_bar              a              b              c              d'
		write (*,'(A)') '#---------------------------------------------------------------------------------------------'


    end subroutine print_interpolation_table

end module output_module
