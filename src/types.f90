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
module types
use global_constants

	implicit none


   	!---------------------------------------------------------------------------
	! DESCRIPTION:
	!> Derived type, initialization parameters
	!---------------------------------------------------------------------------
    type :: InterpolationStepValue


        !Interpolation related stuff
        !The values related to interpolation will be calculated
        ! during the EoS table loading.


        double precision :: a = 0., b = 0.

        double precision :: x = 0., h = 0.
        double precision :: c = 0., d = 0., alpha = 0.
        double precision :: l = 0., mu = 0., z = 0.

    end type InterpolationStepValue

    !> \brief
    !!
    type :: EquationOfStateValue
        integer :: idx_j
        double precision :: rho = 0.
        double precision :: pressure = 0.

        double precision :: rho_bar = 0.
        double precision :: pressure_bar = 0.

        double precision :: baryonic_number_density = 0.
        double precision :: baryonic_number_density_bar = 0.

        type(InterpolationStepValue) :: RHO_FROM_PRESSURE, PRESSURE_FROM_RHO
        type(InterpolationStepValue) :: BARYON_DENSITY_FROM_RHO, RHO_FROM_BARYON_DENSITY

        !Linked list related stuff
        type(EquationOfStateValue), pointer :: previous_element => null(), next_element => null()

    end type EquationOfStateValue

	type :: ConfigParameters

		double precision :: diff_eq_step = 1.
		integer :: max_rk_steps = 1000
        double precision :: interpolation_tolerance
        double precision :: max_diff_eq_step
        double precision :: min_diff_eq_step

		character(len=50) :: eos_file_name

        double precision :: cutoff_RHO_0 = 0.0
        double precision :: cutoff_density = 0.0
        double precision :: cutoff_density_bar = 0.0

        double precision :: RHO_0 = 0.0
        double precision :: RHO_ADIM = 0.0
        double precision :: P_0 = 0.0
        double precision :: P_0_bar = 0.0
        double precision :: BARYONIC_DENSITY_0 = 0.0
        double precision :: BARYONIC_DENSITY_0_bar = 0.0
        double precision :: ENERGY_DENSITY_0 = 0.0
        double precision :: scale_radius = 0.0
		double precision :: scale_mass = 0.0
		double precision :: K_entropy = 0.0

		logical :: verbose_eos
        logical :: output_summary_only
        logical :: output_gnuplot_style
        logical :: verbose_interpolation_coeficients
        logical :: eos_file_provides_baryonic_density

        integer :: INTERPOLATION_METHOD
        integer :: UNIT_SYSTEM

        type(EquationOfStateValue), pointer :: first_element
        type(EquationOfStateValue), pointer :: last_element

        !VARIABLE CREATED FOR PERFORMANCE PURPOSES
        type(EquationOfStateValue), pointer :: curr_element


	end type ConfigParameters


    type :: CommandLineParameters
        character(len=32) :: parameter_file
        double precision :: RHO_0 = 0.0
    end type CommandLineParameters

    type :: FunctionParameters
        type(ConfigParameters) :: parameters
        double precision :: Y(N_DIFF_EQUATIONS)
        double precision :: V(N_VARIABLES)
    end type FunctionParameters

    contains

end module types
