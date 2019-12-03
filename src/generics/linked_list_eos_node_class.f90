!-----------------------------------------------------------------------
!
! RAdS May2014.
! Copyright (C) 2011-2014 by Rodrigo Alvares de Souza.
! Mail: <rsouza01@gmail.com>. Web: "http://www.astro.iag.usp.br/~rsouza/".
! This program may be copied and/or distributed freely. See the
! _ terms and conditions in the files in the doc/ subdirectory.
!
! MODULE: linked_list_eos_node_class
!
!> @author
!> Rodrigo Souza
!
! DESCRIPTION:
!> Object oriented linked list node designed for Equations of State.
!
!-----------------------------------------------------------------------

module linked_list_eos_node_class

use linked_list_class

implicit none

        !---------------------------------------------------------------
        !EoS linked list node
        !---------------------------------------------------------------
        type, public, extends(linked_list_node) :: eos_node

        private
                
                real :: pressure = 0.
                real :: energy_density = 0.
                real :: baryonic_number_density = 0.

                real :: admim_pressure = 0.
                real :: admim_energy_density = 0.
                real :: admim_baryonic_number_density = 0.

        contains
                procedure, public :: initialize_node =>      &
                        initialize_node_sub

                procedure, public :: to_string =>       &
                        linked_list_eos_node_to_string_sub

        end type eos_node

        !---------------------------------------------------------------
        !Restrict access from the actual procedure names
        !---------------------------------------------------------------
        private :: initialize_node_sub, linked_list_eos_node_to_string_sub

        contains
        
        
        !---------------------------------------------------------------
        !Initialize node
        !---------------------------------------------------------------
        subroutine initialize_node_sub(this, pressure, energy_density, &
                baryonic_number_density)
        class(eos_node) :: this
        real, intent(in):: pressure, energy_density, baryonic_number_density
        
                this%pressure = pressure
                this%energy_density = energy_density
                this%baryonic_number_density = baryonic_number_density

        end subroutine initialize_node_sub

        !---------------------------------------------------------------
        !To string
        !---------------------------------------------------------------
        subroutine linked_list_eos_node_to_string_sub(this)
        class(eos_node), intent(in) :: this

                write (*,*) "(pressure, energy_density, baryonic_number_density)", &
                "(", this%pressure, ", ", this%energy_density, ", ",         &
                this% baryonic_number_density,  ")"
                

        end subroutine linked_list_eos_node_to_string_sub

end module linked_list_eos_node_class
