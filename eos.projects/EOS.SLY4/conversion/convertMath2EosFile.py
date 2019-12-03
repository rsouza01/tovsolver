#!/usr/bin/python

import sys
import getopt
import csv
import matplotlib.pyplot as plt


class EoSPoint:

    def __init__(self, rho=0, energia=0, pressao=0, nB=0, muB=0, muBGibbs=0):
        self.rho = rho
        self.energia = energia
        self.pressao = pressao 
        self.n_B = nB
        self.muB = (self.energia + self.pressao)/self.n_B
        self.muBGibbs = muBGibbs


def main(argv):

    print("pressao, muB")
    
    listaEoS = []
    lista2EoS = []
    
    for line in open('Sly4.NUC.csv', 'r'):
        
        if(line[0].isdigit()):
            rho, pressao, n_B = line.replace(',', '').split()

            eoSPoint =  EoSPoint(rho=float(rho), energia=0, pressao=float(pressao), nB=float(n_B), muB=0, muBGibbs=0)

            print("%.2f, %.2f" % (eoSPoint.pressao, eoSPoint.muB))
            
            listaEoS.append(eoSPoint)
            

    print("pressao, muB")



    # listaPressoes = [eos.pressao for eos in listaEoS]
    # listamuB = [eos.muB for eos in listaEoS]

    # lista2Pressoes = [eos.pressao for eos in lista2EoS]
    # lista2muBGibbs = [eos.muBGibbs for eos in lista2EoS]
    
    # plt.xlabel(r'$\mu_B$')
    # plt.ylabel('Pressao')
    # plt.grid(True)
    
    # plt.plot(listamuB, listaPressoes)
    # plt.plot(lista2muBGibbs, lista2Pressoes)
    # plt.show()

if __name__ == "__main__":
    main(sys.argv[1:])    








