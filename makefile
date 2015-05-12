#!/usr/bin/make -f
#
#
# makefile - Instals the tovsolver toolchain.
#
# Author: 	Rodrigo Alvares de Souza
# 			rsouza01@gmail.com
#
#
# History:
# Version 0.1: 2015/05/11 (rsouza) - Creating the file.
#
# TODO: The makefile should verify if the eos.projects dir exists.
#		Verifications and sanity checks.
#
#

INSTALL_DIR = ./eos.projects
SRC_DIR = ./src

TOVSOLVER_DIR = ./src

.PHONY: all install tovsolver

all: install tovsolver

install: tovsolver
	@echo 'Installing tovsolver...'

	mkdir -p $(INSTALL_DIR)
	ln -s -r ./codeblocks/bin/Debug/tovsolver $(INSTALL_DIR)
	cp $(SRC_DIR)/scripts/* $(INSTALL_DIR)/
	cd $(INSTALL_DIR) && ./tovsolver-gentemplate.sh

tovsolver: 
	@echo 'Building tovsolver...'
	cd $(TOVSOLVER_DIR) && $(MAKE)
