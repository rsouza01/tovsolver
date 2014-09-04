!-----------------------------------------------------------------------
!
! RAdS Jan12.
! Copyright (C) 2011-2014 by Rodrigo Alvares de Souza.
! Mail: <rsouza01@gmail.com>. Web: "http://www.astro.iag.usp.br/~rsouza/".
! This program may be copied and/or distributed freely. See the
! _ terms and conditions in the files in the doc/ subdirectory.
!
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
