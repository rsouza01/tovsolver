!-----------------------------------------------------------------------
!
! RAdS May2014.
! Copyright (C) 2011-2014 by Rodrigo Alvares de Souza.
! Mail: <rsouza01@gmail.com>. Web: "http://www.astro.iag.usp.br/~rsouza/".
! This program may be copied and/or distributed freely. See the
! _ terms and conditions in the files in the doc/ subdirectory.
!
! MODULE: linked_list_class
!
!> @author
!> Rodrigo Souza
!
! DESCRIPTION:
!> Object oriented linked list.
!
!-----------------------------------------------------------------------

module linked_list_class

	implicit none

        integer, parameter :: INSERT_ASC = 1
        integer, parameter :: INSERT_DESC = 2

        !---------------------------------------------------------------
        ! The linked list
        !---------------------------------------------------------------
        type, public :: linked_list


        private
                
                integer :: insert_type = 0
                
                !First element
                class(linked_list_node), pointer :: head => null()       
                
                !Last element
                class(linked_list_node), pointer :: tail => null()    

        contains
        
                procedure, public :: set_insert_type =>    &
                        set_insert_type_sub

                procedure, public :: get_insert_type => &
                        get_insert_type_sub                        

                procedure, public :: add_linked_list_node =>    &
                        add_linked_list_node_sub
                        
                procedure, public :: deallocate_linked_list =>  &
                        deallocate_linked_list_sub

                procedure, public :: to_string =>       &
                        linked_list_to_string_sub
                        
                        
        end type linked_list

        !---------------------------------------------------------------
        !Linked list node
        !---------------------------------------------------------------
        type, public :: linked_list_node
                private
                !Previous element
                class(linked_list_node), pointer :: previous_element => null()    
                !Next element
                class(linked_list_node), pointer :: next_element => null() 

        contains
                procedure, public :: to_string => &
                        linked_list_node_to_string_sub

        end type linked_list_node

        !---------------------------------------------------------------
        !Restrict access from the actual procedure names
        !---------------------------------------------------------------
        private :: set_insert_type_sub, add_linked_list_node_sub, &
                linked_list_to_string_sub, get_insert_type_sub
        private :: deallocate_linked_list_sub
        
	contains
        
        !---------------------------------------------------------------
        !Sets the insertion type
        !---------------------------------------------------------------
        subroutine set_insert_type_sub(this, insert_type)
                !Parameters
                class(linked_list) :: this
                integer :: insert_type
                
                if(this%insert_type == 0) then
                        this%insert_type = insert_type
                end if
                
        end subroutine set_insert_type_sub

        !---------------------------------------------------------------
        !Gets the insertion type
        !---------------------------------------------------------------
        integer function get_insert_type_sub(this)
                !Parameters
                class(linked_list) :: this

                get_insert_type_sub = this%insert_type

        end function get_insert_type_sub

        !--------------------------------
        !---------------------------------------------------------------
        !Allocates the linked list node
        !---------------------------------------------------------------
        subroutine add_linked_list_node_sub(this, node)
                !Parameters
                class(linked_list) :: this
                class(linked_list_node), pointer :: node
                !Variables
                class(linked_list_node), pointer :: temp_node => null()

                if(.not. associated(this%head)) then
                        
                        this%head => node
                        this%tail => node
                        
                        nullify(this%head%previous_element)
                else
                        this%tail%next_element => node
                        this%tail => node
                        
                        nullify(this%tail%next_element)
                end if
                
                
        end subroutine add_linked_list_node_sub

        !---------------------------------------------------------------
        !Dellocates the linked list
        !---------------------------------------------------------------
        subroutine deallocate_linked_list_sub(this)
                class(linked_list) :: this
                
                !Variables
                class(linked_list_node), pointer :: current_node
                class(linked_list_node), pointer :: temp_node
                
                current_node => this%head

                do while (associated(current_node))
                        
                        temp_node => current_node
                        current_node => current_node%next_element
                        
                        deallocate(temp_node)
                end do
                
                nullify(this%head)
                nullify(this%tail)
        
        end subroutine deallocate_linked_list_sub

        !---------------------------------------------------------------
        !To string
        !---------------------------------------------------------------
        subroutine linked_list_to_string_sub(this)
                !Parameters
                class(linked_list), intent(in) :: this
                !Variables
                class(linked_list_node), pointer :: current_node
                
                current_node => this%head

                do while (associated(current_node))
                        call current_node%to_string
                        current_node => current_node%next_element
                end do    
                        
        end subroutine linked_list_to_string_sub


        !---------------------------------------------------------------
        !To string
        !---------------------------------------------------------------
        subroutine linked_list_node_to_string_sub(this)
                class(linked_list_node), intent(in) :: this
                
                write (*,*) "linked_list_node%to_string"

        end subroutine linked_list_node_to_string_sub



end module linked_list_class
