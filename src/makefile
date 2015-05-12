#!/usr/bin/make -f
#
#
# makefile - Builds the tovsolver executable.
#
# Author: 	Rodrigo Alvares de Souza
# 			rsouza01@gmail.com
#
#
# History:
# Version 0.1: 2015/05/09 (rsouza) - Customizing from codeblocks generated makefile.
#
#
#

OBJS_f90 = output_module.o solver_module.o stat_module.o stellar_structure_solver.o \
cubic_spline_module.o linked_list_module.o prototypes.o config_module.o \
global_constants.o util.o types.o tov_module.o 

SRC_DIR_f90d1 =	./tovsolver/
OBJS_DIR =		../codeblocks/obj/Debug/src/
EXE_DIR =		../codeblocks/bin/Debug/

EXE = tovsolver
FC = gfortran
IDIR = 
CFLAGS = -g -fbacktrace -fbounds-check -Wconversion  -Wall -Wtabs -Wno-unused-dummy-argument -g  -J$(OBJS_DIR) $(IDIR)
LFLAGS = 
LIBS = 

VPATH = $(SRC_DIR_f90d1):$(OBJS_DIR)
OBJS = $(addprefix $(OBJS_DIR), $(OBJS_f90))

all : $(EXE)

$(EXE) : $(OBJS_f90)
	
	@echo ''
	@echo 'Building ' $(EXE) '...'
	@echo ''
	
	@mkdir -p $(EXE_DIR)
	$(FC) -o $(EXE_DIR)$(EXE) $(OBJS) $(LFLAGS) $(LIBS)

$(OBJS_f90):
	@mkdir -p $(OBJS_DIR)
	$(FC) $(CFLAGS) -c $(SRC_DIR_f90d1)$(@:.o=.f90) -o $(OBJS_DIR)$@

clean :
	rm -f $(OBJS_DIR)*.*
	rm -f $(EXE_DIR)$(EXE)

# Dependencies of files
output_module.o: output_module.f90 global_constants.o types.o

solver_module.o: solver_module.f90 config_module.o global_constants.o tov_module.o

stat_module.o: stat_module.f90 config_module.o global_constants.o types.o util.o

stellar_structure_solver.o: stellar_structure_solver.f90 config_module.o solver_module.o

cubic_spline_module.o: cubic_spline_module.f90 global_constants.o types.o

linked_list_module.o: linked_list_module.f90 global_constants.o types.o

prototypes.o: prototypes.f90 global_constants.o types.o

config_module.o: config_module.f90 cubic_spline_module.o global_constants.o linked_list_module.o output_module.o types.o

global_constants.o: global_constants.f90

util.o: util.f90 global_constants.o

types.o: types.f90 global_constants.o

tov_module.o: tov_module.f90 config_module.o cubic_spline_module.o global_constants.o output_module.o stat_module.o types.o
