!-----------------------------------------------------------------------
!
! RAdS Jan12.
! Copyright (C) 2011-2014 by Rodrigo Alvares de Souza.
! Mail: <rsouza01@gmail.com>. Web: "http://www.astro.iag.usp.br/~rsouza/".
! This program may be copied and/or distributed freely. See the
! _ terms and conditions in the files in the doc/ subdirectory.
!
! MODULE: config_module
!
!> @author
!> Rodrigo Souza
!
! DESCRIPTION:
!> Configuration related routines
!
!-----------------------------------------------------------------------


module config_module
use global_constants
use types
use output_module
use cubic_spline_module
use linked_list_module

	implicit none

    contains

	!---------------------------------------------------------------------------
	! DESCRIPTION:
	!> Get command line parameters
	!---------------------------------------------------------------------------
	subroutine get_command_line_parameters(cl_parameters, error)
		implicit none

		type(CommandLineParameters) :: cl_parameters
		integer, intent(out):: error
		integer :: countArgs
		character(len=32) :: argument
		logical :: has_config_file= .false.

		write (*,'(A)') '#---------------------------------------------------------------------------------------------'
		write (*,'(A)') '#                     TOV Solver'

		!if (iargc() < 1) then
            !write (*,'(A)') 'Usage mode: tov_solver <-config=config_file_name -rho_0=9.9D+9>'
            !write (*,'(A)') '<AAAAA> - optional parameters'
			!error = -1
            !write (*,'(A)') 'Using default config file = tov_solver.conf'

		!else
		do countArgs = 1, iargc()

			call getarg(countArgs, argument)

			if (argument(1:7) == '-config') then

				cl_parameters%parameter_file = argument(9:)
				has_config_file = .true.

			else if (argument(1:6) == '-rho_0') then

				read(argument(8:),*) cl_parameters%RHO_0

			end if
		end do
		!end if

        if(has_config_file .eqv. .false. ) then
            cl_parameters%parameter_file = 'tov_solver.conf'
        end if

		error = 0

	end subroutine get_command_line_parameters


	!---------------------------------------------------------------------------
	! DESCRIPTION:
	!> Print in the screen the initialization of the system
	!---------------------------------------------------------------------------
	subroutine print_init(cl_parameters, parameters, error)
		implicit none

		type(ConfigParameters), intent(in) :: parameters
		type(CommandLineParameters), intent(in) :: cl_parameters
		integer, intent(out) :: error

		call print_config(cl_parameters, parameters)

		error = 0

	end subroutine print_init



 	!---------------------------------------------------------------------------
	! DESCRIPTION:
	!> Read the config from the file specified in the command line
	!---------------------------------------------------------------------------
	subroutine read_config(cl_parameters, parameters, error)
		implicit none

		type(CommandLineParameters) :: cl_parameters
		type(ConfigParameters) :: parameters
		integer, intent(out) :: error

		! Input related variables
		character(len=100) :: buffer, label, interpolation_method
		integer :: pos
		integer, parameter :: fh = 15
		integer :: ios = 0
		integer :: line = 0
        logical :: eos_file_exists

		error = 0

		open(fh, file = cl_parameters%parameter_file)

		! ios is negative if an end of record condition is encountered or if
		! an endfile condition was detected.  It is positive if an error was
		! detected.  ios is zero otherwise.

		do while (ios == 0)
			read(fh, '(A)', iostat=ios) buffer
			if (ios == 0) then
				line = line + 1

				! Find the first instance of =.  Split label and data.
				pos = scan(buffer, '=')
				label = buffer(1:pos)
				buffer = buffer(pos+1:)

				select case (label)
					case ('diff_eq_step=')
					   read(buffer, *, iostat=ios) parameters%diff_eq_step
					case ('max_rk_steps=')
					   read(buffer, *, iostat=ios) parameters%max_rk_steps
					case ('interpolation_tolerance=')
					   read(buffer, *, iostat=ios) parameters%interpolation_tolerance
					case ('max_diff_eq_step=')
					   read(buffer, *, iostat=ios) parameters%max_diff_eq_step
					case ('min_diff_eq_step=')
					   read(buffer, *, iostat=ios) parameters%min_diff_eq_step

					case ('verbose_eos=')
					   read(buffer, *, iostat=ios) parameters%verbose_eos
					case ('output_summary_only=')
					   read(buffer, *, iostat=ios) parameters%output_summary_only
					case ('output_gnuplot_style=')
					   read(buffer, *, iostat=ios) parameters%output_gnuplot_style
					case ('verbose_interpolation_coeficients=')
					   read(buffer, *, iostat=ios) parameters%verbose_interpolation_coeficients

                    case ('RHO_0=')

                        if (parameters%RHO_0 <= 0.0) then
                            read(buffer, *, iostat=ios) parameters%RHO_0
                        end if

                    case ('interpolation_method=')
						read(buffer, *, iostat=ios) interpolation_method

						if(interpolation_method == 'cubic_spline') then
							parameters%INTERPOLATION_METHOD = IDX_CUBIC_SPLINE;
						else if(interpolation_method == 'linear') then
							parameters%INTERPOLATION_METHOD = IDX_LINEAR;
						end if

                    case ('RHO_ADIM=')
                        read(buffer, *, iostat=ios) parameters%RHO_ADIM

                    case ('cutoff_RHO_0=')
                        read(buffer, *, iostat=ios) parameters%cutoff_RHO_0

                    case ('cutoff_density=')
                        read(buffer, *, iostat=ios) parameters%cutoff_density

                    case ('K_entropy=')
                        read(buffer, *, iostat=ios) parameters%K_entropy

                    case ('eos_file_name=')
                       read(buffer, *, iostat=ios) parameters%eos_file_name

                    case ('UNIT_SYSTEM=')
                       read(buffer, *, iostat=ios) parameters%UNIT_SYSTEM

					case ('eos_file_provides_baryonic_density=')
					   read(buffer, *, iostat=ios) parameters%eos_file_provides_baryonic_density

					case ('log_base_calc_infor_entropy=')
					   read(buffer, *, iostat=ios) parameters%log_base_calc_infor_entropy


				end select

			end if
		end do

        if(parameters%RHO_0 <= 0.0) then
            write (*,'(A)') '#---------------------------------------------------------------------------------------------'
            write (*,'(A)') '# ERROR: An initial RHO_0 must be provided, either by command line parameters or via config file.'
            write (*,'(A)') '# SOLUTION: Set the RHO_0 parameter in the file ', cl_parameters%parameter_file, &
                ' or in the command line, and try again.'

            write (*,'(A)') '#---------------------------------------------------------------------------------------------'

            error = -2
            return
        end if

        !Checks for EoS File
        inquire(file=parameters%eos_file_name, exist=eos_file_exists)
        if(eos_file_exists  .eqv. .false. ) then
            write (*,'(A)') '#---------------------------------------------------------------------------------------------'
            write (*,'(A)') '# ERROR: EoS file not found.'
            write (*,'(A)') '# SOLUTION: Set the correct eos_file_name parameter in the file ', cl_parameters%parameter_file, &
                ' or in the command line, and try again.'

            write (*,'(A)') '#---------------------------------------------------------------------------------------------'

            error = -3
            return
        end if

        if(parameters%RHO_ADIM <= 0.0) then
            parameters%RHO_ADIM = parameters%RHO_0
        end if

        parameters%scale_radius = ((LIGHT_SPEED_SCALE(parameters%UNIT_SYSTEM)**2.)/(4. * const_pi * &
            GRAVITATIONAL_CONSTANT(parameters%UNIT_SYSTEM) * parameters%RHO_ADIM))**(.5)

        parameters%scale_mass = 4. * const_pi * parameters%RHO_ADIM * parameters%scale_radius**3.

        call load_eos_table(cl_parameters, parameters);

        !DEBUG Purposes only.
        !call print_eos_table(cl_parameters, parameters);

        call generate_interpolation_values(cl_parameters, parameters)

        parameters%ENERGY_DENSITY_0 = parameters%RHO_ADIM * LIGHT_SPEED(parameters%UNIT_SYSTEM)**2.

        parameters%BARYONIC_DENSITY_0_bar = barionic_density_from_eos_table(parameters, parameters%RHO_0 / parameters%RHO_ADIM);

		parameters%cutoff_density_bar = parameters%cutoff_density / parameters%RHO_ADIM;

		!DEBUG
		!write (*,*) 'parameters%RHO_ADIM => ', parameters%RHO_ADIM
		!write (*,*) 'cutoff_density => ', parameters%cutoff_density
		!write (*,*) 'cutoff_density_bar => ', parameters%cutoff_density_bar

        parameters%P_0_bar = pressure_from_eos_table(parameters, parameters%RHO_0 / parameters%RHO_ADIM);

        parameters%P_0 = parameters%P_0_bar * &
            parameters%RHO_0 * LIGHT_SPEED(parameters%UNIT_SYSTEM)**2;

	end subroutine read_config

    !> \brief Load in memory the values from the EoS Table.
    !!
    !! \param cl_parameters
    !! \param parameters
    !!
    subroutine load_eos_table(cl_parameters, parameters)
        implicit none

        type(CommandLineParameters), intent(in) :: cl_parameters
        type(ConfigParameters), intent(inout) :: parameters

        ! Input related variables
        character(len=50) :: eosFileName
        character(len=100) :: buffer
        integer :: pos_1, pos_2

        integer, parameter :: fh = 16
        integer :: ios = 0
        integer :: line = 0

        double precision :: rho = 0., pressure = 0., baryon_density = 0.

        Type(EquationOfStateValue), pointer :: eos_element

        eosFileName = trim(parameters%eos_file_name)

        call ll_allocate(parameters%first_element)

        parameters%curr_element => parameters%first_element

        eos_element => parameters%first_element

        open(fh, file = eosFileName)

        do while (ios == 0)

            read(fh, '(A)', iostat=ios) buffer

            if (ios == 0) then

                if_sharp : if (buffer(1:1) /= "#" .and. buffer(1:1) /= "") then

                    ! Find the first instance of ','.  Split pressure and rho.
                    pos_1 = scan(buffer, ',')

                    read(buffer(1:pos_1), *, iostat=ios)rho

                    if (parameters%eos_file_provides_baryonic_density) then
                        pos_2 = scan(buffer(pos_1 + 1:), ',')

                        read(buffer(pos_1 + 1: pos_1 + pos_2), *, iostat=ios) pressure

                        read(buffer(pos_1 + pos_2 + 1:), *, iostat=ios) baryon_density
                    else
                        read(buffer(pos_1 + 1:), *, iostat=ios) pressure

                        baryon_density = 0.
                    end if

                    !DEBUG
                    !write (*,*) 'rho, pressure, baryon_density => ', rho, ', ', pressure, ' ,', baryon_density

                    !call ll_insert_ordered(parameters%first_element, )

                    allocate(eos_element%next_element)

                    eos_element%next_element%previous_element => eos_element

                    eos_element%rho = rho

                    if(eos_element%rho > parameters%RHO_0) then
                            parameters%first_element => eos_element
                            if(associated(eos_element%previous_element)) then
                                deallocate (eos_element%previous_element)
                                nullify(eos_element%previous_element)
                            end if
                    end if

                    !write (*,*) 'eos_element%rho, parameters%RHO_0, eos_element%rho - parameters%RHO_0 = ', &
                    !    eos_element%rho, parameters%RHO_0, (eos_element%rho - parameters%RHO_0)

                    !DEBUG
                    !write (*,*) 'first -> rho, pressure, baryon_density => ', parameters%first_element%rho, &
                    !    ', ', parameters%first_element%pressure, ' ,', parameters%first_element%baryonic_number_density

                    !BLOCK
                    line = line + 1

                    eos_element%rho_bar = &
                            eos_element%rho / parameters%RHO_ADIM

                    eos_element%pressure = pressure

                    !write (*,*) 'eos_element%rho, parameters%RHO_0, eos_element%rho - parameters%RHO_0 = ', &
                    !    eos_element%rho, parameters%RHO_0, (eos_element%rho - parameters%RHO_0)

                    eos_element%pressure_bar =  &
                            eos_element%pressure / (parameters%RHO_ADIM * LIGHT_SPEED(parameters%UNIT_SYSTEM)**2.)

                    eos_element%baryonic_number_density = baryon_density

                    if(parameters%eos_file_provides_baryonic_density) then

                        if(parameters%BARYONIC_DENSITY_0 <= 0.0) then
                            parameters%BARYONIC_DENSITY_0 = parameters%first_element%baryonic_number_density;
                        end if

                        eos_element%baryonic_number_density_bar = baryon_density / &
                                parameters%BARYONIC_DENSITY_0;
                    else
                        parameters%BARYONIC_DENSITY_0 = 0;
                        eos_element%baryonic_number_density_bar = 0;
                    end if
                    !These parameter must be initialized somewhere

                    eos_element%idx_j = line

                    eos_element%BARYON_DENSITY_FROM_RHO%x = eos_element%rho_bar;
                    eos_element%BARYON_DENSITY_FROM_RHO%a = eos_element%baryonic_number_density_bar;

                    eos_element%RHO_FROM_BARYON_DENSITY%x = eos_element%baryonic_number_density_bar;
                    eos_element%RHO_FROM_BARYON_DENSITY%a = eos_element%rho_bar;

                    eos_element%RHO_FROM_PRESSURE%x = eos_element%pressure_bar
                    eos_element%RHO_FROM_PRESSURE%a = eos_element%rho_bar

                    eos_element%PRESSURE_FROM_RHO%x = eos_element%rho_bar
                    eos_element%PRESSURE_FROM_RHO%a = eos_element%pressure_bar

                    !BLOCK

                    parameters%last_element => eos_element

                    eos_element => eos_element%next_element

                end if if_sharp !if (buffer(1:1) /= "#") then...
            end if ! if (ios == 0) then...

        end do

        nullify(parameters%first_element%previous_element)

    end subroutine load_eos_table

    !> \brief Free the memory allocated
    !!
    !! \param cl_parameters
    !! \param parameters
    !!
    subroutine unload_eos_table(cl_parameters, parameters)
        implicit none
        type(CommandLineParameters), intent(in) :: cl_parameters
        type(ConfigParameters), intent(in) :: parameters

        Type(EquationOfStateValue), pointer :: eos_element, temp_element

        eos_element => parameters%first_element

        do while (associated(eos_element))

            temp_element => eos_element
            eos_element => eos_element%next_element
            deallocate(temp_element)

        end do
    end subroutine unload_eos_table



end module config_module
