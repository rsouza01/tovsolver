#!/bin/bash


./tovsolver-eos-converter.py --eosfile=../MFTQCD_B_38MeV_auto.csv --from nuclear --to cgs > MFTQCD_B_38MeV_CGS.csv

./tovsolver-eos-converter.py --eosfile=../MFTQCD_B_75_7MeV_auto.csv --from nuclear --to cgs > MFTQCD_B_75_7MeV_CGS.csv
