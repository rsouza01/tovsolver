!-----------------------------------------------------------------------
!
! RAdS May2014.
! Copyright (C) 2011-2014 by Rodrigo Alvares de Souza.
! Mail: <rsouza01@gmail.com>. Web: "http://www.astro.iag.usp.br/~rsouza/".
! This program may be copied and/or distributed freely. See the
! _ terms and conditions in the files in the doc/ subdirectory.
!
! MODULE: linked_list_eos_class
!
!> @author
!> Rodrigo Souza
!
! DESCRIPTION:
!> Object oriented linked list designed for Equations of State.
!
!-----------------------------------------------------------------------

module linked_list_eos_class

use linked_list_class

implicit none

        !---------------------------------------------------------------
        !EoS Linked list
        !---------------------------------------------------------------
        type, public, extends(linked_list) :: eos_list

        end type eos_list


        !---------------------------------------------------------------
        !Restrict access from the actual procedure names
        !---------------------------------------------------------------
        !private :: allocate_linked_list_node_sub
        
        

end module linked_list_eos_class
