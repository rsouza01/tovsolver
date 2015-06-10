#TOV Solver (tovsolver)


##Purpose

The main purpose of this program is to integrate the TOV equations under
some Equation of State.

##Command Line Parameters

-config FILENAME : defines which config file should be read by the program.

-rho_0 : define the value for central energy density (e(R = 0)).

##EOS File format

The file is very simple. It must be formated in 3 columns (comma separated), in the following order:

1. Density (mass density, it will be converted internally to energy density, depending on the chosen unit system).
2. Pressure.
3. Baryon density, if provided.

The data must be sorted as density descending, i.e. from the bigger mass density to the smaller. In the future, one should be abble to inform the data in any sorting.

##Config File Parameters

- **diff_eq_step** : Runge-Kutta step size.

- **max_rk_steps** : Upper limit to the number of steps the program must iterate.

- **interpolation_tolerance** : TODO

- **max_diff_eq_step** : TODO

- **min_diff_eq_step** : TODO

- **verbose_eos** : If TRUE, the program will output the EoS's values. Otherwise, no output.

- **output_summary_only** : If true, the program wil output the summary, but not the profiles. Use false for optimization.

- **output_gnuplot_style** : TODO

- **verbose_interpolation_coeficients** : If true, the program will output the interpolation coeficients.

- **RHO_0** : The central density.

- **interpolation_method** : Two methods are available at the moment: cubic_spline and linear.

- **RHO_ADIM** : TODO

- **cutoff_RHO_0** : TODO

- **cutoff_density** : The density where the program must stop the Runge-Kutta calculations(i.e. a stop condition).

- **K_entropy** : TODO

- **eos_file_name** : The EoS file name.

- **UNIT_SYSTEM** : CGS=1, NUCLEAR=2, SI=3, NUN=4, OTHER=5. You should note that this is not fully implemented. Only CGS and Nuclear units are working up to now.

- **eos_file_provides_baryonic_density** : true or false.

- **log_base_calc_infor_entropy** : TODO

## Usage

It is provided a lot of scripts along the executable. 
