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


OBJS_f90d1 = main_generics.o linked_list_class.o linked_list_eos_class.o linked_list_eos_node_class.o

SRC_DIR_f90d1 = ./
OBJS_DIR = obj/Debug/src/
EXE_DIR = bin/Debug/

EXE = generics
FC = gfortran
IDIR = 
FFLAGS = -Wall -Wtabs -Wno-unused-dummy-argument -std=f2003 -g -J$(OBJS_DIR) $(IDIR)
LFLAGS = 
LIBS = 

VPATH = $(SRC_DIR_f90d1):$(OBJS_DIR)
OBJS = $(addprefix $(OBJS_DIR), $(OBJS_f90d1))

all : $(EXE)

$(EXE) : $(OBJS_f90d1)
	@echo "Compiling the executable..."
	@mkdir -p $(EXE_DIR)
	$(FC) -o $(EXE_DIR)$(EXE) $(OBJS) $(LFLAGS) $(LIBS)
	@echo "Done!"

$(OBJS_f90d1):
	@echo "Compiling the sources..."
	@mkdir -p $(OBJS_DIR)
	$(FC) $(FFLAGS) -c $(SRC_DIR_f90d1)$(@:.o=.f90) -o $(OBJS_DIR)$@

clean :
	rm -f $(OBJS_DIR)*.*
	rm -f $(EXE_DIR)$(EXE)

# Dependencies of files

main_generics.o: \
    main_generics.f90 \
    linked_list_eos_class.o \
    linked_list_eos_node_class.o

linked_list_class.o: \
    linked_list_class.f90

linked_list_eos_class.o: \
    linked_list_eos_class.f90 \
    linked_list_class.o

linked_list_eos_node_class.o: \
    linked_list_eos_node_class.f90 \
    linked_list_class.o

