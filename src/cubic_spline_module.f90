!-----------------------------------------------------------------------
!
! RAdS Jan12.
! Copyright (C) 2011-2014 by Rodrigo Alvares de Souza.
! Mail: <rsouza01@gmail.com>. Web: "http://www.astro.iag.usp.br/~rsouza/".
! This program may be copied and/or distributed freely. See the
! _ terms and conditions in the files in the doc/ subdirectory.
!
!
! MODULE: cubic_spline_module
!
!> @author
!> Rodrigo Souza
!
! DESCRIPTION:
!> Interpolation related routines
!
!-----------------------------------------------------------------------
module cubic_spline_module
use global_constants
use types

	implicit none


    contains

   !> \brief Evaluates the 3rd order polynomial to interpolate \rho(P)
    !!
    !! \param eos_element
    !! \param pressure_bar
    !! \return
    !!
    double precision function interpolation_pressure_from_eos(parameters, eos_element, rho_bar)
        type(ConfigParameters), intent(in) :: parameters
        type(EquationOfStateValue), pointer, intent(in) :: eos_element
        double precision, intent(in) :: rho_bar

        double precision :: delta_x_bar

        type(InterpolationStepValue), pointer :: isv

        isv => eos_element%PRESSURE_FROM_RHO

		if(parameters%INTERPOLATION_METHOD == IDX_CUBIC_SPLINE) then

			delta_x_bar = rho_bar - isv%x

			interpolation_pressure_from_eos = isv%a + isv%b * delta_x_bar + &
									  isv%c * delta_x_bar**2. +isv%d * delta_x_bar**3.

		else if(parameters%INTERPOLATION_METHOD == IDX_LINEAR) then

			interpolation_pressure_from_eos = isv%a*(rho_bar - eos_element%rho_bar) + isv%b

		end if


        !write (*, *) '(interpolation_pressure_from_eos ) = (', interpolation_pressure_from_eos, ')';

    end function interpolation_pressure_from_eos

   !> \brief Evaluates the 3rd order polynomial to interpolate \rho(P)
    !!
    !! \param eos_element
    !! \param pressure_bar
    !! \return
    !!
    double precision function interpolation_baryonic_density_from_eos(parameters, eos_element, rho_bar)
		type(ConfigParameters), intent(in) :: parameters
		type(EquationOfStateValue), pointer, intent(in) :: eos_element
        double precision, intent(in) :: rho_bar
        double precision :: delta_x_bar

        type(InterpolationStepValue), pointer :: isv

        isv => eos_element%BARYON_DENSITY_FROM_RHO

		if(parameters%INTERPOLATION_METHOD == IDX_CUBIC_SPLINE) then

			delta_x_bar = rho_bar - isv%x

			interpolation_baryonic_density_from_eos = isv%a + isv%b * delta_x_bar + &
									  isv%c * delta_x_bar**2. +isv%d * delta_x_bar**3.

		else if(parameters%INTERPOLATION_METHOD == IDX_LINEAR) then

			interpolation_baryonic_density_from_eos = isv%a*(rho_bar - eos_element%rho_bar) + isv%b

		end if

        !write (*, *) '(interpolation_pressure_from_eos ) = (', interpolation_pressure_from_eos, ')';

    end function interpolation_baryonic_density_from_eos

    !---------------------------------------------------------------------------
    ! DESCRIPTION:
    !> Evaluates the baryonic number density at a given energy density
    !
    !> Compute \f$ P \f$
    !---------------------------------------------------------------------------
    double precision function barionic_density_from_eos_table(parameters, dimless_rho)
    implicit none
        type(ConfigParameters), intent(in) :: parameters
        double precision, intent(in) :: dimless_rho

        type(EquationOfStateValue), pointer :: eos_value
        double precision :: bar_density_bar

        eos_value => parameters%first_element

        !DEBUG
        !write (*,*) '(dimless_rho, eos_value%rho_bar) = ', '(', &
        !    dimless_rho, ', ', &
        !    eos_value%rho, ' )';

        do while  (associated(eos_value%next_element) .and. .not. (dimless_rho <= eos_value%rho_bar .and. &
            dimless_rho >= eos_value%next_element%rho_bar))

            !write (*,*) '(dimless_rho, eos_value%rho_bar) = ', '(', &
            !    dimless_rho, ', ', &
            !    eos_value%rho_bar, ' )';

            eos_value => eos_value%next_element

        end do

        bar_density_bar = interpolation_baryonic_density_from_eos(parameters, eos_value, dimless_rho)

        barionic_density_from_eos_table = bar_density_bar

    end function barionic_density_from_eos_table


    !---------------------------------------------------------------------------
    ! DESCRIPTION:
    !> Evaluates the pressure P at a given density
    !
    !> Compute \f$ P \f$
    !---------------------------------------------------------------------------
    double precision function pressure_from_eos_table(parameters, dimless_rho)
    implicit none
        type(ConfigParameters), intent(in) :: parameters
        double precision, intent(in) :: dimless_rho

        type(EquationOfStateValue), pointer :: eos_value
        double precision :: pressure_bar

        eos_value => parameters%first_element

        !DEBUG
        !write (*,*) '(dimless_rho, eos_value%rho_bar) = ', '(', &
        !    dimless_rho, ', ', &
        !    eos_value%rho_bar, ' )';

        do while  (.not. (dimless_rho <= eos_value%rho_bar .and. &
            dimless_rho >= eos_value%next_element%rho_bar))

            eos_value => eos_value%next_element

        end do

        pressure_bar = interpolation_pressure_from_eos (parameters, eos_value, dimless_rho)

        pressure_from_eos_table = pressure_bar

    end function pressure_from_eos_table

   !---------------------------------------------------------------------------
    double precision function cs_h(current, next)
    implicit none
    type(InterpolationStepValue), intent(in) :: current, next

        cs_h = next%x - current%x

    end function cs_h

   !---------------------------------------------------------------------------
    double precision function linear_a(x1, y1, x2, y2)
    implicit none
    double precision, intent(in) :: x1, x2, y1, y2;

        linear_a = (y2 - y1)/(x2 - x1);

    end function linear_a

   !---------------------------------------------------------------------------
    double precision function linear_b(x1, y1, x2, y2)
    implicit none
    double precision, intent(in) :: x1, x2, y1, y2;

        linear_b = y1

    end function linear_b

   !---------------------------------------------------------------------------
    double precision function cs_alpha(previous, current, next)
    implicit none
    type(InterpolationStepValue), intent(in) :: previous, current, next
    double precision :: alpha

        if(current%h /= 0. .and. previous%h /= 0.) then
            alpha = (3. / current%h) * (next%a - current%a) - (3. / previous%h) * (current%a - previous%a);
        else
            alpha = 0.
        end if

        !write (*,*) '(alpha) = ', '(', alpha, ')';

        cs_alpha = alpha;

    end function cs_alpha

   !---------------------------------------------------------------------------
    double precision function cs_l(previous, next)
    implicit none
    type(InterpolationStepValue), intent(in) :: previous, next

            cs_l = 2. * (next%x - previous%x) - previous%h * previous%mu;

    end function cs_l

   !---------------------------------------------------------------------------
    double precision function cs_mu(current)
    implicit none
    type(InterpolationStepValue), intent(in) :: current

        if(current%h /= 0.) then
            cs_mu = current%h - current%l;
        else
            cs_mu = 0
        end if

    end function cs_mu

   !---------------------------------------------------------------------------
    double precision function cs_z(previous, current)
    implicit none
    type(InterpolationStepValue), intent(in) :: previous, current

        if(current%h /= 0.) then
            cs_z = (current%alpha - previous%h * previous%z)/current%l;
        else
            cs_z = 0
        end if

    end function cs_z

   !---------------------------------------------------------------------------
    double precision function cs_coeficient_c(current, next)
    implicit none
    type(InterpolationStepValue), intent(in) :: current, next

        if(current%h /= 0.) then
            cs_coeficient_c = current%z - current%mu * next%c;
        else
            cs_coeficient_c = 0;
        end if

    end function cs_coeficient_c

   !---------------------------------------------------------------------------
    double precision function cs_coeficient_b(current, next)
    implicit none
    type(InterpolationStepValue), intent(in) :: current, next

        if(current%h /= .0) then

            cs_coeficient_b = (next%a - current%a) / current%h - &
                current%h * (next%c + 2. * current%c)/3.
        else
            cs_coeficient_b = 0
        end if
    end function cs_coeficient_b

   !---------------------------------------------------------------------------
    double precision function cs_coeficient_d(current, next)
    implicit none
    type(InterpolationStepValue), intent(in) :: current, next

        if(current%h /= 0.) then
            cs_coeficient_d = (next%c - current%c) / (3. * current%h)
        else
            cs_coeficient_d = 0
        end if
    end function cs_coeficient_d

    !---------------------------------------------------------------------------
    ! DESCRIPTION:
    !> Maybe later...
    !---------------------------------------------------------------------------
    subroutine generate_interpolation_values(cl_parameters, parameters)
        implicit none
		type(CommandLineParameters), intent(in) :: cl_parameters
        type(ConfigParameters), intent(in) :: parameters

		if(parameters%INTERPOLATION_METHOD == IDX_CUBIC_SPLINE) then

			call generate_cubic_spline_interpolation_values(cl_parameters, parameters)

		else if(parameters%INTERPOLATION_METHOD == IDX_LINEAR) then

			call generate_linear_interpolation_values(cl_parameters, parameters)

		end if

	end subroutine generate_interpolation_values


    !---------------------------------------------------------------------------
    ! DESCRIPTION:
    !> Maybe later...
    !---------------------------------------------------------------------------
    subroutine generate_cubic_spline_interpolation_values(cl_parameters, parameters)
        implicit none

        type(CommandLineParameters), intent(in) :: cl_parameters
        type(ConfigParameters), intent(in) :: parameters

        Type(EquationOfStateValue), pointer :: eos_element

        !STEP 1 - OK!
        eos_element => parameters%first_element

        do while (associated(eos_element%next_element%next_element))

            eos_element%RHO_FROM_PRESSURE%h = &
                cs_h(eos_element%RHO_FROM_PRESSURE, eos_element%next_element%RHO_FROM_PRESSURE)

            eos_element%PRESSURE_FROM_RHO%h = &
                cs_h(eos_element%PRESSURE_FROM_RHO, eos_element%next_element%PRESSURE_FROM_RHO)

            eos_element%RHO_FROM_BARYON_DENSITY%h = &
                cs_h(eos_element%RHO_FROM_BARYON_DENSITY, eos_element%next_element%RHO_FROM_BARYON_DENSITY)

            eos_element%BARYON_DENSITY_FROM_RHO%h = &
                cs_h(eos_element%BARYON_DENSITY_FROM_RHO, eos_element%next_element%BARYON_DENSITY_FROM_RHO)

            !DEBUG
            !write (*,*) '(j, RHO_FROM_PRESSURE%h, PRESSURE_FROM_RHO%h) = ', '(', &
            !    eos_element%idx_j, ', ', &
            !    eos_element%RHO_FROM_PRESSURE%h, ', ', &
            !    eos_element%PRESSURE_FROM_RHO%h, ')';

            eos_element => eos_element%next_element

        end do

        !STEP 2
        eos_element => parameters%first_element%next_element
        do while (associated(eos_element%next_element%next_element))

            eos_element%RHO_FROM_PRESSURE%alpha = &
                cs_alpha(eos_element%previous_element%RHO_FROM_PRESSURE, &
                    eos_element%RHO_FROM_PRESSURE, &
                    eos_element%next_element%RHO_FROM_PRESSURE)

            eos_element%PRESSURE_FROM_RHO%alpha = &
                cs_alpha(eos_element%previous_element%PRESSURE_FROM_RHO, &
                    eos_element%PRESSURE_FROM_RHO, &
                    eos_element%next_element%PRESSURE_FROM_RHO)

            eos_element%RHO_FROM_BARYON_DENSITY%alpha = &
                cs_alpha(eos_element%previous_element%RHO_FROM_BARYON_DENSITY, &
                    eos_element%RHO_FROM_BARYON_DENSITY, &
                    eos_element%next_element%RHO_FROM_BARYON_DENSITY)

            eos_element%BARYON_DENSITY_FROM_RHO%alpha = &
                cs_alpha(eos_element%previous_element%BARYON_DENSITY_FROM_RHO, &
                    eos_element%BARYON_DENSITY_FROM_RHO, &
                    eos_element%next_element%BARYON_DENSITY_FROM_RHO)

            !DEBUG
            !write (*,*) '(j, R_FROM_P%alpha, P_FROM_R%alpha) = ', '(', &
            !    eos_element%idx_j, ', ', &
            !    eos_element%RHO_FROM_PRESSURE%alpha, ', ', &
            !    eos_element%PRESSURE_FROM_RHO%alpha, ')';

            eos_element => eos_element%next_element

        end do

        !STEP 3
        parameters%first_element%RHO_FROM_PRESSURE%l = 1.
        parameters%first_element%PRESSURE_FROM_RHO%l = 1.

        parameters%first_element%RHO_FROM_PRESSURE%z = 0.
        parameters%first_element%PRESSURE_FROM_RHO%z = 0.

        parameters%first_element%RHO_FROM_PRESSURE%c = 0.
        parameters%first_element%PRESSURE_FROM_RHO%c = 0.

        parameters%first_element%RHO_FROM_BARYON_DENSITY%l = 1.
        parameters%first_element%BARYON_DENSITY_FROM_RHO%l = 1.
        parameters%first_element%RHO_FROM_BARYON_DENSITY%z = 0.
        parameters%first_element%BARYON_DENSITY_FROM_RHO%z = 0.
        parameters%first_element%RHO_FROM_BARYON_DENSITY%c = 0.
        parameters%first_element%BARYON_DENSITY_FROM_RHO%c = 0.

        !STEP 4 - OK
        eos_element => parameters%first_element%next_element

        do while (associated(eos_element%next_element%next_element))


            ! Let's calculate 'l'
            eos_element%RHO_FROM_PRESSURE%l = &
                cs_l(eos_element%previous_element%RHO_FROM_PRESSURE, eos_element%next_element%RHO_FROM_PRESSURE)
            eos_element%PRESSURE_FROM_RHO%l = &
                cs_l(eos_element%previous_element%PRESSURE_FROM_RHO, eos_element%next_element%PRESSURE_FROM_RHO)

            eos_element%RHO_FROM_BARYON_DENSITY%l = &
                cs_l(eos_element%previous_element%RHO_FROM_BARYON_DENSITY, eos_element%next_element%RHO_FROM_BARYON_DENSITY)
            eos_element%BARYON_DENSITY_FROM_RHO%l = &
                cs_l(eos_element%previous_element%BARYON_DENSITY_FROM_RHO, eos_element%next_element%BARYON_DENSITY_FROM_RHO)

            !DEBUG
            !write (*,*) '(j, R_FROM_P%l, P_FROM_R%l) = ', '(', &
            !    eos_element%idx_j, ', ', &
            !    eos_element%RHO_FROM_PRESSURE%l, ', ', &
            !    eos_element%PRESSURE_FROM_RHO%l, ')';


            ! Now calculate 'mu'
            eos_element%RHO_FROM_PRESSURE%mu = cs_mu(eos_element%RHO_FROM_PRESSURE)
            eos_element%PRESSURE_FROM_RHO%mu = cs_mu(eos_element%PRESSURE_FROM_RHO)

            eos_element%RHO_FROM_BARYON_DENSITY%mu = cs_mu(eos_element%RHO_FROM_BARYON_DENSITY)
            eos_element%BARYON_DENSITY_FROM_RHO%mu = cs_mu(eos_element%BARYON_DENSITY_FROM_RHO)

            !DEBUG
            !write (*,*) '(j, R_FROM_P%mu, P_FROM_R%mu) = ', '(', &
            !    eos_element%idx_j, ', ', &
            !    eos_element%RHO_FROM_PRESSURE%mu, ', ', &
            !    eos_element%PRESSURE_FROM_RHO%mu, ')';

            ! And now 'z'
            eos_element%RHO_FROM_PRESSURE%z = &
                cs_z(eos_element%previous_element%RHO_FROM_PRESSURE, eos_element%RHO_FROM_PRESSURE)

            eos_element%PRESSURE_FROM_RHO%z = &
                cs_z(eos_element%previous_element%PRESSURE_FROM_RHO, eos_element%PRESSURE_FROM_RHO)

            eos_element%RHO_FROM_BARYON_DENSITY%z = &
                cs_z(eos_element%previous_element%RHO_FROM_BARYON_DENSITY, eos_element%RHO_FROM_BARYON_DENSITY)

            eos_element%BARYON_DENSITY_FROM_RHO%z = &
                cs_z(eos_element%previous_element%BARYON_DENSITY_FROM_RHO, eos_element%BARYON_DENSITY_FROM_RHO)

            !DEBUG
            !write (*,*) '(j, R_FROM_P%z, P_FROM_R%z) = ', '(', &
            !    eos_element%idx_j, ', ', &
            !    eos_element%RHO_FROM_PRESSURE%z, ', ', &
            !    eos_element%PRESSURE_FROM_RHO%z, ')';

            eos_element => eos_element%next_element

        end do

        !STEP 5 - OK
        eos_element%RHO_FROM_PRESSURE%l = 1.
        eos_element%PRESSURE_FROM_RHO%l = 1.
        eos_element%RHO_FROM_PRESSURE%z = 0.
        eos_element%PRESSURE_FROM_RHO%z = 0.
        eos_element%RHO_FROM_PRESSURE%c = 0.
        eos_element%PRESSURE_FROM_RHO%c = 0.

        eos_element%RHO_FROM_BARYON_DENSITY%l = 1.
        eos_element%BARYON_DENSITY_FROM_RHO%l = 1.
        eos_element%RHO_FROM_BARYON_DENSITY%z = 0.
        eos_element%BARYON_DENSITY_FROM_RHO%z = 0.
        eos_element%RHO_FROM_BARYON_DENSITY%c = 0.
        eos_element%BARYON_DENSITY_FROM_RHO%c = 0.

        !STEP 6 - OK
        eos_element => eos_element%previous_element
        do while (associated(eos_element))

            !Coeficient c
            eos_element%RHO_FROM_PRESSURE%c = &
                cs_coeficient_c(eos_element%RHO_FROM_PRESSURE, eos_element%next_element%RHO_FROM_PRESSURE)
            eos_element%PRESSURE_FROM_RHO%c = &
                cs_coeficient_c(eos_element%PRESSURE_FROM_RHO, eos_element%next_element%PRESSURE_FROM_RHO)

            !Coeficient b
            eos_element%RHO_FROM_PRESSURE%b = &
                cs_coeficient_b(eos_element%RHO_FROM_PRESSURE, eos_element%next_element%RHO_FROM_PRESSURE)
            eos_element%PRESSURE_FROM_RHO%b = &
                cs_coeficient_b(eos_element%PRESSURE_FROM_RHO, eos_element%next_element%PRESSURE_FROM_RHO)

            !Coeficient d
            eos_element%RHO_FROM_PRESSURE%d = &
                cs_coeficient_d(eos_element%RHO_FROM_PRESSURE, eos_element%next_element%RHO_FROM_PRESSURE)
            eos_element%PRESSURE_FROM_RHO%d = &
                cs_coeficient_d(eos_element%PRESSURE_FROM_RHO, eos_element%next_element%PRESSURE_FROM_RHO)

            eos_element%RHO_FROM_BARYON_DENSITY%c = &
                cs_coeficient_c(eos_element%RHO_FROM_BARYON_DENSITY, eos_element%next_element%RHO_FROM_BARYON_DENSITY)
            eos_element%BARYON_DENSITY_FROM_RHO%c = &
                cs_coeficient_c(eos_element%BARYON_DENSITY_FROM_RHO, eos_element%next_element%BARYON_DENSITY_FROM_RHO)

            eos_element%RHO_FROM_BARYON_DENSITY%b = &
                cs_coeficient_b(eos_element%RHO_FROM_BARYON_DENSITY, eos_element%next_element%RHO_FROM_BARYON_DENSITY)
            eos_element%BARYON_DENSITY_FROM_RHO%b = &
                cs_coeficient_b(eos_element%BARYON_DENSITY_FROM_RHO, eos_element%next_element%BARYON_DENSITY_FROM_RHO)

            eos_element%RHO_FROM_BARYON_DENSITY%d = &
                cs_coeficient_d(eos_element%RHO_FROM_BARYON_DENSITY, eos_element%next_element%RHO_FROM_BARYON_DENSITY)
            eos_element%BARYON_DENSITY_FROM_RHO%d = &
                cs_coeficient_d(eos_element%BARYON_DENSITY_FROM_RHO, eos_element%next_element%BARYON_DENSITY_FROM_RHO)

            eos_element => eos_element%previous_element

        end do

	end subroutine generate_cubic_spline_interpolation_values

    !---------------------------------------------------------------------------
    ! DESCRIPTION:
    !> Maybe later...
    !---------------------------------------------------------------------------
    subroutine generate_linear_interpolation_values(cl_parameters, parameters)
        implicit none

        type(CommandLineParameters), intent(in) :: cl_parameters
        type(ConfigParameters), intent(in) :: parameters

        Type(EquationOfStateValue), pointer :: eos_element

        !STEP 1 - OK!
        eos_element => parameters%first_element

        do while (associated(eos_element%next_element%next_element))

            eos_element%RHO_FROM_PRESSURE%a = &
                linear_a(eos_element%pressure_bar, eos_element%rho_bar, &
					eos_element%next_element%pressure_bar, eos_element%next_element%rho_bar);
            eos_element%RHO_FROM_PRESSURE%b = &
                linear_b(eos_element%pressure_bar, eos_element%rho_bar, &
					eos_element%next_element%pressure_bar, eos_element%next_element%rho_bar);

            eos_element%PRESSURE_FROM_RHO%a = &
                linear_a(eos_element%rho_bar, eos_element%pressure_bar, &
					eos_element%next_element%rho_bar, eos_element%next_element%pressure_bar);
            eos_element%PRESSURE_FROM_RHO%b = &
                linear_b(eos_element%rho_bar, eos_element%pressure_bar, &
					eos_element%next_element%rho_bar, eos_element%next_element%pressure_bar);

            eos_element%RHO_FROM_BARYON_DENSITY%a = &
                linear_a(eos_element%baryonic_number_density_bar, eos_element%rho_bar, &
					eos_element%next_element%baryonic_number_density_bar, eos_element%next_element%rho_bar);
            eos_element%RHO_FROM_BARYON_DENSITY%b = &
                linear_b(eos_element%baryonic_number_density_bar, eos_element%rho_bar, &
					eos_element%next_element%baryonic_number_density_bar, eos_element%next_element%rho_bar);

            eos_element%BARYON_DENSITY_FROM_RHO%a = &
                linear_a(eos_element%rho_bar, eos_element%baryonic_number_density_bar, &
					eos_element%next_element%rho_bar, eos_element%next_element%baryonic_number_density_bar);
            eos_element%BARYON_DENSITY_FROM_RHO%b = &
                linear_b(eos_element%rho_bar, eos_element%baryonic_number_density_bar, &
					eos_element%next_element%rho_bar, eos_element%next_element%baryonic_number_density_bar);


            eos_element => eos_element%next_element

        end do


	end subroutine generate_linear_interpolation_values

    !> \brief Function that interpolate the energy density from a given pressure
    !!
    !! \param parameters
    !! \param t
    !! \param Y
    !! \param V
    !! \return
    !!
    double precision function energy_density_from_eos(parameters, t, Y, V)
    implicit none
        type(ConfigParameters), intent(in) :: parameters
        double precision, intent(in) :: t
        double precision, intent(in) :: Y(N_DIFF_EQUATIONS)
        double precision, intent(in) :: V(N_VARIABLES)


        !double precision :: BAG_CONSTANT = 9.23D+034



        !< Must find in the table the correct density



        if(Y(IDX_PRESSURE_BAR) < parameters%last_element%pressure_bar) then
            energy_density_from_eos = 0.
        else
            energy_density_from_eos = density_from_eos_table(parameters, Y(IDX_PRESSURE_BAR))
        end if

        !Analytic expressions for DEBUG purposes only.
        !Uncomment if you are testing

        !rho = P/c^2
        !energy_density_from_eos = V(IDX_PRESSURE_BAR)

        !rho = RHO_0
        !energy_density_from_eos = 1

        !MIT BAG MODEL
        !energy_density_from_eos = 3. * V(IDX_PRESSURE_BAR) + 4. * &
        !    BAG_CONSTANT /(parameters%RHO_0 * LIGHT_SPEED(parameters%UNIT_SYSTEM)**2.)

    end function energy_density_from_eos


    !> \brief Evaluates the 3rd order polynomial to interpolate \rho(P)
    !!
    !! \param eos_element
    !! \param pressure_bar
    !! \return
    !!
    double precision function interpolation_rho_from_eos(parameters, eos_element, pressure_bar)
        type(ConfigParameters), intent(in) :: parameters
        type(EquationOfStateValue), pointer, intent(in) :: eos_element
        double precision, intent(in) :: pressure_bar

        double precision :: delta_x_bar

        type(InterpolationStepValue), pointer :: isv

        double precision :: rho_bar = 0.

        isv => eos_element%RHO_FROM_PRESSURE

		if(parameters%INTERPOLATION_METHOD == IDX_CUBIC_SPLINE) then

			delta_x_bar = pressure_bar - isv%x

			rho_bar = isv%a + isv%b * delta_x_bar + &
									  isv%c * delta_x_bar**2. +isv%d * delta_x_bar**3.

		else if(parameters%INTERPOLATION_METHOD == IDX_LINEAR) then

			rho_bar = isv%a*(pressure_bar - eos_element%pressure_bar) + isv%b

		end if


        interpolation_rho_from_eos = rho_bar

    end function interpolation_rho_from_eos


    !---------------------------------------------------------------------------
    ! DESCRIPTION:
    !> Evaluates the pressure P at a given density
    !
    !> Compute \f$ P \f$
    !---------------------------------------------------------------------------
    double precision function density_from_eos_table(parameters, dimless_pressure)
    implicit none
        type(ConfigParameters), intent(in) :: parameters
        double precision, intent(in) :: dimless_pressure

        double precision :: rho_bar

        type(EquationOfStateValue), pointer :: eos_value

        double precision currentPressure, nextPressure

        !write (*,*) '(dimless_pressure) = (', dimless_pressure, ')'

        if(dimless_pressure <= 0.) then
            rho_bar = 0.
        else

            !Da pra otimizar isso aqui...
            eos_value => parameters%first_element

            currentPressure = parameters%first_element%pressure_bar
            nextPressure = parameters%first_element%next_element%pressure_bar

            do while  (.not. (currentPressure >= dimless_pressure .and. &
                nextPressure < dimless_pressure ))

                !write (*,*) '(currentPressure, nextPressure) = (', currentPressure, ', ', nextPressure, ')'

                if(associated(eos_value%next_element)) then

                    eos_value => eos_value%next_element

                    currentPressure = eos_value%pressure_bar

                    if(associated(eos_value%next_element)) then
                        nextPressure = eos_value%next_element%pressure_bar
                    else
                        nextPressure = 0.
                    end if
                end if


            end do

            rho_bar = interpolation_rho_from_eos (parameters, eos_value, dimless_pressure)

            !write (*,*) '(pressure_bar, rho_bar) = (', dimless_pressure, ', ', rho_bar, ')'
        end if

        density_from_eos_table = rho_bar

    end function density_from_eos_table


end module cubic_spline_module
