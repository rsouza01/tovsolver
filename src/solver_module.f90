!-----------------------------------------------------------------------
!
! RAdS Jan12.
! Copyright (C) 2011-2014 by Rodrigo Alvares de Souza.
! Mail: <rsouza01@gmail.com>. Web: "http://www.astro.iag.usp.br/~rsouza/".
! This program may be copied and/or distributed freely. See the
! _ terms and conditions in the files in the doc/ subdirectory.
!
!
! MODULE: solver_module
!
!> @author
!> Rodrigo Souza
!
! DESCRIPTION:
!> Runge-kutta related routines
!
!-----------------------------------------------------------------------
module solver_module
use global_constants
use config_module
use tov_module

	implicit none

	contains

	!---------------------------------------------------------------------------
	! DESCRIPTION:
	!> The hard work
	!---------------------------------------------------------------------------

	subroutine process_calculations(parameters, error)
	implicit none
        !Parameters
		type(ConfigParameters) :: parameters
		integer :: error

		integer :: j = 0
		double precision :: t = 0

		!Variables that hold the integrations values for a single call to Runge-Kutta
		double precision :: Y(N_DIFF_EQUATIONS)

		!Variables that hold the physical relevant values
		double precision :: V(N_VARIABLES)

        t = j * parameters%diff_eq_step

		call set_initial_conditions(parameters, Y, V)

        if(.not. parameters%output_summary_only) then
            call print_header_output(parameters, t, V)
        end if

		do while ( j < parameters%max_rk_steps .and. (.not. can_stop(parameters, t, Y, V)))

            !In the first iteration, it must show the initial conditions.
            if(.not. parameters%output_summary_only) then
                call print_formated_output(parameters, t, V)
            end if

			call runge_kutta_4(parameters, t, Y, V)

			call process_specific_calculations(parameters, t, Y, V)

			j = j + 1

            t = j * parameters%diff_eq_step

		end do

        if(.not. parameters%output_summary_only) then
            call print_footer_output(parameters, t, V)
        end if

        call print_summary(parameters, t, V)

	end subroutine process_calculations


	!---------------------------------------------------------------------------
	! DESCRIPTION:
	!> The hard work
	!---------------------------------------------------------------------------

	subroutine process_calculations_variable_step_size(parameters, error)
	implicit none
        !Parameters
		type(ConfigParameters) :: parameters
		integer :: error

		integer :: j = 0
		double precision :: t = 0

		!Variables that hold the integrations values for a single call to Runge Kutta
		double precision :: Y(N_DIFF_EQUATIONS)

		!Variables that hold the physical relevant values
		double precision :: V(N_VARIABLES)

		logical :: flag = .true.

		double precision :: calculated_h = 0.

		calculated_h = parameters%max_diff_eq_step

        t = j * calculated_h

		call set_initial_conditions(parameters, Y, V)

        if(.not. parameters%output_summary_only) then
            call print_header_output(parameters, t, V)
        end if

		do while ( flag .eqv. .true. .and. j < parameters%max_rk_steps .and. (.not. can_stop(parameters, t, Y, V)))

            !In the first iteration, it must show the initial conditions.
            if(.not. parameters%output_summary_only) then
                call print_formated_output(parameters, t, V)
            end if

			call runge_kutta_fehlberg(parameters, t, Y, V, calculated_h, flag)

			call process_specific_calculations(parameters, t, Y, V)

			j = j + 1

            t = j * calculated_h

		end do

        if(.not. parameters%output_summary_only) then
            call print_footer_output(parameters, t, V)
        end if

        call print_summary(parameters, t, V)

	end subroutine process_calculations_variable_step_size


	!---------------------------------------------------------------------------
	! DESCRIPTION:
	!> runge_kutta_fehlberg
	!---------------------------------------------------------------------------
	subroutine runge_kutta_fehlberg(parameters, t, Y, V, calculated_h, flag)
	implicit none

		type(ConfigParameters) :: parameters
		double precision :: t, Y(N_DIFF_EQUATIONS), V(N_VARIABLES)
		logical :: flag

		double precision :: k1(N_DIFF_EQUATIONS), k2(N_DIFF_EQUATIONS), &
                            k3(N_DIFF_EQUATIONS), k4(N_DIFF_EQUATIONS), &
                            k5(N_DIFF_EQUATIONS), k6(N_DIFF_EQUATIONS)

		integer :: equationNumber
		double precision :: t_linha, calculated_h
		logical :: Rs_leq_TOL = .true. !R's < TOL
		double precision :: R(N_DIFF_EQUATIONS), delta, average_R

        t_linha = t

        !Small adjustment for t=0 in order to avoid the singularity
        if (t == 0.) then
            t_linha = t + calculated_h * 0.001
        end if

        !write (*,'(A)') '----------------------------------------'
		!1st step
        !write (*,'(A)'),'Eq.             K1'
        !write (*,'(A)') '--- --------------'
		do equationNumber = 1, N_DIFF_EQUATIONS, 1
			k1(equationNumber) = calculated_h * derivative(parameters, t_linha, Y, V, equationNumber)
        !    write (*,'(i3, f15.7)') , equationNumber, k1(equationNumber)
		end do

		!2nd step
        !write (*,'(A)'),'Eq.             K2'
        !write (*,'(A)') '--- --------------'
		do equationNumber = 1, N_DIFF_EQUATIONS, 1
			k2(equationNumber) = calculated_h * derivative(parameters, t_linha + calculated_h/4., Y + k1/4., V, equationNumber)
        !    write (*,'(i3, f15.7)') , equationNumber, k2(equationNumber)
		end do

		!3rd step
        !write (*,'(A)'),'Eq.             K3'
        !write (*,'(A)') '--- --------------'
		do equationNumber = 1, N_DIFF_EQUATIONS, 1
			k3(equationNumber) = calculated_h * derivative(parameters, &
                t_linha + 3.*calculated_h/8.,  &
                Y + 3.*k1/32.  + 9.*k2/32., &
                V, equationNumber)
        !    write (*,'(i3, f15.7)') , equationNumber, k3(equationNumber)
		end do

		!4th step
        !write (*,'(A)'),'Eq.             K4'
        !write (*,'(A)') '--- --------------'
		do equationNumber = 1, N_DIFF_EQUATIONS, 1
			k4(equationNumber) = calculated_h * derivative(parameters, &
                t_linha + (12./13.)*calculated_h,  &
                Y + (1932./2197)*k1 - (7200./2197)*k2 + (7296./2197.)*k3, &
                V, equationNumber)
        !    write (*,'(i3, f15.7)') , equationNumber, k4(equationNumber)
		end do

		!5th step
        !write (*,'(A)'),'Eq.             K4'
        !write (*,'(A)') '--- --------------'
		do equationNumber = 1, N_DIFF_EQUATIONS, 1
			k5(equationNumber) = calculated_h * derivative(parameters, &
				t_linha + calculated_h, &
				Y + (439./216.)*k1 - 8.*k2 + (3680./513)*k3 - (845./4104.)*k4, &
				V, equationNumber)
        !    write (*,'(i3, f15.7)') , equationNumber, k5(equationNumber)
		end do

		!6th step
        !write (*,'(A)'),'Eq.             K4'
        !write (*,'(A)') '--- --------------'
		do equationNumber = 1, N_DIFF_EQUATIONS, 1
			k6(equationNumber) = calculated_h * derivative(parameters, &
				t_linha + 0.5*calculated_h,  &
				Y - (8./27.)*k1 - 2.*k2 - (3544./2565.)*k3 - (1859./4104.)*k4 - (11./40.)*k5, &
				V, equationNumber)
        !    write (*,'(i3, f15.7)') , equationNumber, k6(equationNumber)
		end do

		!Calculations
		do equationNumber = 1, N_DIFF_EQUATIONS, 1
			R(equationNumber) = (1./calculated_h) * abs( &
				(1./360.)*k1(equationNumber) - &
				(128./4275.) * k2(equationNumber) - &
				(2197./75240.) * k4(equationNumber) + &
				(1./50.) * k5(equationNumber) + &
				(2./55.)*k6(equationNumber));

			!write (*,*) 'R(', equationNumber, ') = ', R(equationNumber)
			if(R(equationNumber) > parameters%interpolation_tolerance) then
				Rs_leq_TOL = .false.
			end if

			average_R = R(equationNumber) / N_DIFF_EQUATIONS

		end do

		if(Rs_leq_TOL .eqv. .true.) then
			do equationNumber = 1, N_DIFF_EQUATIONS, 1
				Y(equationNumber) = Y(equationNumber) + &
					(25./216.)*k1(equationNumber) + &
					(1408./2565.)*k3(equationNumber) + &
					(2197./4104.)*k4(equationNumber) + &
					(1./5.)*k5(equationNumber)
			end do

			calculated_h = parameters%diff_eq_step

		end if

		delta = 0.84 * (parameters%interpolation_tolerance / average_R)** (1./4.)

		if(delta < 0.1) then
			calculated_h = 0.1 * calculated_h
		elseif(delta >= 4.) then
			calculated_h = 4. * calculated_h
		else
			calculated_h = delta * calculated_h
		end if

		if(calculated_h > parameters%max_diff_eq_step) then
			calculated_h = parameters%max_diff_eq_step
		end if

		if (calculated_h < parameters%min_diff_eq_step) then
			flag = .false.
		end if

	end subroutine runge_kutta_fehlberg

	!---------------------------------------------------------------------------
	! DESCRIPTION:
	!> runge_kutta_4
	!---------------------------------------------------------------------------
	subroutine runge_kutta_4(parameters, t, Y, V)
	implicit none

		type(ConfigParameters) :: parameters
		double precision :: t, Y(N_DIFF_EQUATIONS), V(N_VARIABLES)

		double precision :: k1(N_DIFF_EQUATIONS), k2(N_DIFF_EQUATIONS), &
                            k3(N_DIFF_EQUATIONS), k4(N_DIFF_EQUATIONS)

		integer :: equationNumber
		double precision :: t_linha, h

		h = parameters%diff_eq_step
        t_linha = t

        !Small adjustment for t=0 in order to avoid the singularity
        if (t == 0.) then
            t_linha = t + parameters%diff_eq_step * 0.001
        end if

        !write (*,'(A)') '----------------------------------------'
		!1st step
        !write (*,'(A)'),'Eq.             K1'
        !write (*,'(A)') '--- --------------'
		do equationNumber = 1, N_DIFF_EQUATIONS, 1
			k1(equationNumber) = h * derivative(parameters, t_linha, Y, V, equationNumber)
        !    write (*,'(i3, f15.7)') , equationNumber, k1(equationNumber)
		end do

		!2nd step
        !write (*,'(A)'),'Eq.             K2'
        !write (*,'(A)') '--- --------------'
		do equationNumber = 1, N_DIFF_EQUATIONS, 1
			k2(equationNumber) = h * derivative(parameters, t_linha + h/2., Y + k1/2., V, equationNumber)
        !    write (*,'(i3, f15.7)') , equationNumber, k2(equationNumber)
		end do

		!3rd step
        !write (*,'(A)'),'Eq.             K3'
        !write (*,'(A)') '--- --------------'
		do equationNumber = 1, N_DIFF_EQUATIONS, 1
			k3(equationNumber) = h * derivative(parameters, t_linha + h/2.,  Y + k2/2., V, equationNumber)
        !    write (*,'(i3, f15.7)') , equationNumber, k3(equationNumber)
		end do

		!4th step
        !write (*,'(A)'),'Eq.             K4'
        !write (*,'(A)') '--- --------------'
		do equationNumber = 1, N_DIFF_EQUATIONS, 1
			k4(equationNumber) = h * derivative(parameters, t_linha + h,  Y + k3, V, equationNumber)
        !    write (*,'(i3, f15.7)') , equationNumber, k4(equationNumber)
		end do

		!Calculations
		do equationNumber = 1, N_DIFF_EQUATIONS, 1
			Y(equationNumber) = Y(equationNumber) + ( k1(equationNumber) + 2. * k2(equationNumber) + &
				2. * k3(equationNumber) + k4(equationNumber)) / 6.;
		end do

        !write (*,'(A)') '----------------------------------------'
		!write (*,'(A)'),'         t          Massa        Pressao'
        !write (*,'(A)') '---------- -------------- --------------'

		!write (*,'(f10.5, f15.7 f15.7)') , t, Y(1), Y(2)
        !write (*,'(A)') '----------------------------------------'

	end subroutine runge_kutta_4

end module solver_module
