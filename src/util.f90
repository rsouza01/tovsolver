!-----------------------------------------------------------------------
! IAG USP
!-----------------------------------------------------------------------
!
! MODULE: utl
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

	double precision function log_n(argument, base)
    implicit none
        double precision :: argument
        double precision :: base

        log_n = log(argument)/log(base)
    end function


end module util
