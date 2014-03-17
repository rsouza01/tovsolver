!-----------------------------------------------------------------------
! IAG USP
!-----------------------------------------------------------------------
!
! MODULE: npe_ruffini_solver
!
!> @author
!> Rodrigo Souza
!
! DESCRIPTION:
!> Solve equilibrium equations for a npe system
!
!gfortran -o build/npe_ruffini_solver.o -c -g src/npe_ruffini_solver.f90
!gfortran -o build/solver_module.o -c -g src/solver_module.f90
!gfortran -o build/global_constants.o -c -g src/global_constants.f90
!gfortran -o build/types_module.o -c -g src/types_module.f90
!gfortran -o build/runge_kutta4_module.o -c -g src/runge_kutta4_module.f90
!gfortran -o build/config_module.o -c -g src/config_module.f90
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











