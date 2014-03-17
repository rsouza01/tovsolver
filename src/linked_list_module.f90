!-----------------------------------------------------------------------
! IAG USP
!-----------------------------------------------------------------------
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
        Type(EquationOfStateValue), pointer :: list

        allocate(list)

	end subroutine ll_allocate


	subroutine ll_insert_ordered(list, node)
    implicit none
        Type(EquationOfStateValue), pointer :: list
        Type(EquationOfStateValue), pointer :: node

        allocate(list)

	end subroutine ll_insert_ordered


end module linked_list_module
