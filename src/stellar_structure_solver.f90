!-----------------------------------------------------------------------
!
! RAdS Jan12.
! Copyright (C) 2011-2014 by Rodrigo Alvares de Souza.
! Mail: <rsouza01@gmail.com>. Web: "http://www.astro.iag.usp.br/~rsouza/".
! This program may be copied and/or distributed freely. See the
! _ terms and conditions in the files in the doc/ subdirectory.
!
!
! PROGRAM: TOV_Solver
!
! MODULE:  stellar_structure_solver
!
!> @author
!> Rodrigo Souza
!
! DESCRIPTION:
!> Implements a generic framework for a TOV system.
!
!
!-----------------------------------------------------------------------
program stellar_structure_solver

use config_module
use solver_module

implicit none

	type(ConfigParameters) :: parameters
	type(CommandLineParameters) :: cl_parameters
	integer :: error

	parameters%RHO_0 = 0
	cl_parameters%RHO_0 = 0
	parameters%P_0_bar = 0.

	call get_command_line_parameters(cl_parameters, error)

	!Exits the program returning the error
	if (error /= 0) then
		call exit(error)
	end if

	parameters%RHO_0 = cl_parameters%RHO_0

	call read_config(cl_parameters, parameters, error)
	!Exits the program returning the error
	if (error /= 0) then
		call exit(error)
	end if

	call print_init(cl_parameters, parameters, error)

	call process_calculations(parameters, error)

	!call process_calculations_variable_step_size(parameters, error)

	!Exits the program returning the error
	if (error /= 0) then
		call exit(error)
	end if

    call unload_eos_table(cl_parameters, parameters)

end program stellar_structure_solver











