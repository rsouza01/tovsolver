!-----------------------------------------------------------------------
!
! RAdS Jan12.
! Copyright (C) 2011-2014 by Rodrigo Alvares de Souza.
! Mail: <rsouza01@gmail.com>. Web: "http://www.astro.iag.usp.br/~rsouza/".
! This program may be copied and/or distributed freely. See the
! _ terms and conditions in the files in the doc/ subdirectory.
!
!
! MODULE: linked_list_module
!
!> @author
!> Rodrigo Souza
!
! DESCRIPTION:
!> Linked list related stuff
!
!-----------------------------------------------------------------------
module linked_list_module
use types
use global_constants


	implicit none

	contains

	subroutine ll_allocate(list)
    implicit none
        Type(EquationOfStateValue), pointer, intent(inout) :: list

        allocate(list)

	end subroutine ll_allocate


	subroutine ll_insert_ordered(list, node)
    implicit none
        Type(EquationOfStateValue), pointer :: list
        Type(EquationOfStateValue), pointer :: node

        allocate(list)

	end subroutine ll_insert_ordered


end module linked_list_module
