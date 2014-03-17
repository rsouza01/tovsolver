!-----------------------------------------------------------------------
! IAG USP
!-----------------------------------------------------------------------
!
! MODULE: prototypes
!
!> @author
!> Rodrigo Souza
!
! DESCRIPTION:
!> Configuration related routines
!
!-----------------------------------------------------------------------
module prototypes

	implicit none

    interface

        subroutine set_initial_conditions(parameters, Y, V)
        use types
        use global_constants
        implicit none

            type(ConfigParameters) :: parameters
            double precision :: Y(N_DIFF_EQUATIONS)
            double precision :: V(N_VARIABLES)

        end subroutine set_initial_conditions

        subroutine process_specific_calculations(parameters, t, Y, V)
        use types
        use global_constants
        implicit none
            type(ConfigParameters) :: parameters
            double precision :: t
            double precision :: Y(N_DIFF_EQUATIONS)
            double precision :: V(N_VARIABLES)

        end subroutine process_specific_calculations

        double precision function derivative(parameters, t, Y, V, equationNumber)
        use types
        use global_constants
        implicit none
            type(ConfigParameters) :: parameters
            double precision :: t
            double precision :: Y(N_DIFF_EQUATIONS)
            double precision :: V(N_VARIABLES)
            integer :: equationNumber


        end function derivative


        logical function can_stop(parameters, t, Y, V)
        use types
        use global_constants
        implicit none
            type(ConfigParameters) :: parameters
            double precision :: t
            double precision :: Y(N_DIFF_EQUATIONS)
            double precision :: V(N_VARIABLES)

        end function can_stop

    end interface

end module prototypes
