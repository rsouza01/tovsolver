!-----------------------------------------------------------------------
! IAG USP
!-----------------------------------------------------------------------
!
! MODULE: cgs_constants
!
!> @author
!> Rodrigo Souza
!
! DESCRIPTION:
!> Math and physical constants not defined in the language
!
!-----------------------------------------------------------------------
module global_constants
	implicit none


	!NUMBER OF DIFFERENTIAL EQUATIONS
	integer, parameter :: N_DIFF_EQUATIONS = 2

    integer, parameter :: IDX_EQN_DM_DN = 1
    integer, parameter :: IDX_EQN_DP_DN = 2


	!INDEXES
	integer, parameter :: N_VARIABLES = 8

    integer, parameter :: IDX_MASS_BAR = 1
    integer, parameter :: IDX_PRESSURE_BAR = 2
    integer, parameter :: IDX_ENERGY_DENSITY_BAR = 3
    integer, parameter :: IDX_RADIUS_BAR = 4
    integer, parameter :: IDX_RHO_BAR = 5
    integer, parameter :: IDX_BARYON_NUMBER = 6
    integer, parameter :: IDX_INFOR_ENTROPY = 7
    integer, parameter :: IDX_DISEQUILIBRIUM = 8


	double precision, public, parameter :: const_pi = 355./113.

	!UNITS RELATIVE TO INTERPOLATION METHOD
    integer, parameter :: IDX_TOTAL_INTERPOLATION_METHODS = 2

    integer, parameter :: IDX_CUBIC_SPLINE = 1
    integer, parameter :: IDX_LINEAR = 2

    character, parameter, dimension(IDX_TOTAL_INTERPOLATION_METHODS) :: &
		INTERPOLATION_METHODS_DESCR(IDX_TOTAL_INTERPOLATION_METHODS)*6 = &
        (/'CUBIC ', 'LINEAR'/)


    !UNITS RELATIVE TO THE SYSTEM USED
    integer, parameter :: IDX_TOTAL_SYSTEMS = 4
    integer, parameter :: IDX_CGS = 1
    integer, parameter :: IDX_NUCLEAR = 2
    integer, parameter :: IDX_SI = 3
    integer, parameter :: IDX_OTHER = 4

    character, parameter, dimension(IDX_TOTAL_SYSTEMS) :: UNIT_SYSTEM_DESCR(IDX_TOTAL_SYSTEMS)*3 = &
        (/'CGS', 'NUC', 'SI ', 'OTH'/)

    double precision, parameter, dimension(IDX_TOTAL_SYSTEMS) :: LIGHT_SPEED = &
        (/ 2.998D10, 1.0D0, 2.998D8, 0D0 /)

    double precision, parameter, dimension(IDX_TOTAL_SYSTEMS) :: LIGHT_SPEED_SCALE = &
        (/ 2.998D10, 2.998D23, 2.998D8, 0D0 /)

    double precision, parameter, dimension(IDX_TOTAL_SYSTEMS) :: GRAVITATIONAL_CONSTANT =  &
        (/ 6.674D-8, 1.18994D+5, 6.674D-11, 0D0 /)

    double precision, parameter, dimension(IDX_TOTAL_SYSTEMS) :: SOLAR_MASS =  &
        (/ 1.9891D+33, 1.116D+60, 1.9891D+30, 0D0 /)

    double precision, parameter, dimension(IDX_TOTAL_SYSTEMS) :: SOLAR_RADIUS =  &
        (/ 6.955D+10, 6.955D+23, 6.955D+8, 0D0 /)

    double precision, parameter, dimension(IDX_TOTAL_SYSTEMS) :: CONVERSION_LENGTH =  &
        (/ 1.0D-5, 1.0D-18, 1.0D-3, 0D0 /)


end module global_constants
