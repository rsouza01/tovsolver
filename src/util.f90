!-----------------------------------------------------------------------
! IAG USP
!-----------------------------------------------------------------------
!
! MODULE: util
!
!> @author
!> Rodrigo Souza
!
! DESCRIPTION:
!> Utility routines
!
!-----------------------------------------------------------------------
module util
use global_constants

	implicit none

    contains

    !> \brief Evaluates the logarithm of 'argument' to the given 'base', calculated as log(x)/log(base).
    !!
    !! \param argument
    !! \param base
    !! \return the logarithm
    !!
	double precision function log_n(argument, base)
    implicit none
        double precision :: argument
        double precision :: base

        log_n = log(argument)/log(base)
    end function


end module util
