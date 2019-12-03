!-----------------------------------------------------------------------
!
! RAdS May2014.
! Copyright (C) 2011-2014 by Rodrigo Alvares de Souza.
! Mail: <rsouza01@gmail.com>. Web: "http://www.astro.iag.usp.br/~rsouza/".
! This program may be copied and/or distributed freely. See the
! _ terms and conditions in the files in the doc/ subdirectory.
!
! MODULE: main
!
!> @author
!> Rodrigo Souza
!
! DESCRIPTION:
!> Main program designed for tests.
!
!-----------------------------------------------------------------------

program fortran_generics

use linked_list_class
use linked_list_eos_class
use linked_list_eos_node_class

implicit none

        integer :: idx = 0
        
        type(eos_list) :: list_eos
        class(eos_node), pointer :: node_eos
        class(linked_list_node), pointer :: ptr_ln => null()

        real, parameter, dimension(4) :: valores =  &
        (/ -1., 10., 9. , 4./)

        write (*, *) "List default insert type -> ", list_eos%get_insert_type()

        call list_eos%set_insert_type(INSERT_ASC)
        
        write (*, *) "List insert type -> ", list_eos%get_insert_type()

        populateList: do while (idx < 4) 

                write (*, *) "idx = ", idx

                allocate(node_eos)

                call node_eos%initialize_node(valores(idx), valores(idx), valores(idx))
                
                ptr_ln => node_eos

                call list_eos%add_linked_list_node(ptr_ln)

                idx = idx + 1
                
        end do populateList

        

        call list_eos%to_string
        
        call list_eos%deallocate_linked_list

        
end program fortran_generics
