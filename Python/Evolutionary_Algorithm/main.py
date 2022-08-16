# -*- coding: utf-8 -*-
"""
Created on Sat Apr  9 20:23:37 2022

@author: AlperenKoyun
"""
import matplotlib.pyplot as plt
import cv2
import numpy as np
import random
from math import floor
from copy import deepcopy
blank_image = np.full((180, 180, 3), (255, 255, 255), np.uint8)
cv2.imwrite('color_img.jpg', blank_image)
#cv2.imshow('color_img.jpg',blank_image)
#cv2.waitKey(10000)
#cv2.destroyAllWindows()


def checkboundary(x,y,Rad):
    if((x+Rad)<0):
        return False
    elif((x-Rad)>180):
        return False
    elif((y+Rad)<0):
        return False
    elif((y-Rad)>180):
        return False
    else:
        return True


class gene:
    def	__init__(self, x=0, y=0, radius=0, blue=0, green=0, red=0, alpha=0):
        self.x 	= random.randint(-15,width+15)
        self.y 	= random.randint(-10,height+10)
		#initialize x and y with boundaries a little outside of the desired one
        self.radius = random.randint(1,40)
        #circule radius is between 1 and 40
		
        while(not checkboundary(self.x,self.y,self.radius)):
            #reinitialize if not in boundary
            self.x 	= random.randint(-15,width+15)
            self.y 	= random.randint(-10,height+10)
            self.radius = random.randint(1,40)
		
        self.blue	= random.randint(0,255)
        self.green	= random.randint(0,255)
        self.red	= random.randint(0,255)

        self.alpha	= random.random()
        
    def mutation(self, mutationtype):#mutation method
        tempx=self.x
        tempy=self.y
        if(mutationtype=="unguided"):##initialize random if unguided
            self.x 	= random.randint(-15,width+15)
            self.y 		= random.randint(-10,height+10)
            self.radius 	= random.randint(1,40)
            while(not checkboundary(self.x,self.y,self.radius)):
                self.x 	= random.randint(-15,width+15)
                self.y 	= random.randint(-10,height+10)
                self.radius = random.randint(1,40)
            self.blue	= random.randint(0,255)
            self.green	= random.randint(0,255)
            self.red	= random.randint(0,255)
            self.alpha	= random.random()
            
        elif(mutationtype=="guided"):#reinitialize with values close to original
            self.x 	= random.randint(tempx - width/4, tempx + width/4)
            self.y 	= random.randint(tempy - height/4, tempy + height/4)
            if (self.radius < 10):
                self.radius = random.randint(1, self.radius + 10)
            else:
                self.radius = random.randint(self.radius - 10, self.radius + 10)
            while(not checkboundary(self.x,self.y,self.radius)):
                self.x 	= random.randint(tempx - width/4, tempx + width/4)
                self.y 	= random.randint(tempy - height/4, tempy + height/4) 
                if (self.radius < 10):
                    self.radius = random.randint(1, self.radius + 10)
                else:
                    self.radius = random.randint(self.radius - 10, self.radius + 10)
                    
            if (self.alpha - 0.25 < 0):
                self.alpha = random.uniform(0, self.alpha + 0.25)
            elif (self.alpha + 0.25 > 1):
                self.alpha = random.uniform(self.alpha - 0.25, 1)
            else:
                self.alpha    = random.uniform(self.alpha - 0.25, self.alpha + 0.25)
                    
            if (self.blue - 64 < 0):
                self.blue = random.randint(0, self.blue + 64)
            elif (self.blue + 64 > 255):
                self.blue = random.randint(self.blue - 64, 255)
            else:
                self.blue    = random.randint(self.blue - 64, self.blue + 64)
            if (self.green - 64 < 0):
                self.green = random.randint(0, self.green + 64)
            elif (self.green + 64 > 255):
                self.green = random.randint(self.green - 64, 255)
            else:
                self.green    = random.randint(self.green - 64, self.green + 64)
            if (self.red - 64 < 0):
                self.red = random.randint(0, self.red + 64)
            elif (self.red + 64 > 255):
                self.red = random.randint(self.red - 64, 255)
            else:
                self.red = random.randint(self.red - 64, self.red + 64)
            
            
            
            
            
            
class individual:## individual class
    def    __init__(self, num_genes=50):
        self.fitness = None
        self.num_genes = num_genes
        self.chromosome = [gene() for i in range(0,num_genes)]
    def mutateindividual(self, mutation_prob = 0.2, mutation_type = "guided"):
        while (random.random() < mutation_prob):
            randomgene = random.randint(0, self.num_genes - 1)
            self.chromosome[randomgene].mutation(mutation_type)
            self.fitness = None
    def evalindividual(self, painting):        
        img = np.full((180, 180, 3), (255, 255, 255), np.uint8)
        for gene in self.chromosome:
            tempimage = deepcopy(img)
            cv2.circle(tempimage, (gene.x, gene.y), gene.radius, (gene.blue, gene.green, gene.red), thickness = -1)
            cv2.addWeighted(tempimage, gene.alpha, img, 1 - gene.alpha, 0.0, img)
            self.fitness = -np.sum(np.square(np.subtract(painting.astype(int), img.astype(int))))
    def sortgenes(self):
        self.chromosome.sort(key = lambda x: x.radius, reverse=True)
        #sort function takes lambda expression of each element and list them in descending order
    
    
    def findbestimage(self):
        img = np.full((180, 180, 3), (255, 255, 255), np.uint8)
        self.sortgenes()
        for gene in self.chromosome:
            tempimage = deepcopy(img)
            cv2.circle(tempimage, (gene.x, gene.y), gene.radius, (gene.blue, gene.green, gene.red), thickness = -1)
            cv2.addWeighted(tempimage, gene.alpha, img, 1 - gene.alpha, 0.0, img)
        return img
    
class population:
    #constructor
    def    __init__(self, num_inds = 20, num_genes = 50, tm_size = 5, frac_elites = 0.2, frac_parents = 0.6, mutation_prob = 0.2, mutation_type = "guided"):
        self.num_inds = num_inds
        self.num_genes = num_genes
        self.tm_size = tm_size
        self.frac_elites = frac_elites## initialize according to the given arguments
        self.frac_parents = frac_parents
        self.mutation_prob = mutation_prob
        self.mutation_type = mutation_type
        
        self.individuals = [individual(num_genes=num_genes) for i in range(0, num_inds)]
        
        self.elites = []#array to keep elites
        self.nonelites = []#to keep nonelites
        self.winners = []# to keep winnder
        self.children = []#to keep children
        
        
    
    #this method is used for evaluation of the population    
    def evalpopulation(self, painting):
        for ind in self.individuals:
            ind.evalindividual(painting)
            
    def selection(self):
        self.winners.clear()
        self.elites.clear()#delete previous data
        #sort the individuals
        self.individuals = sorted(self.individuals, key = lambda x: x.fitness, reverse = True)
        
        for i in range(floor(self.num_inds * self.frac_elites)):
            temp = deepcopy(self.individuals[i])
            self.elites.append(temp)
            #find elites

        
        for i in range(floor(self.num_inds * self.frac_parents)):
            #tournament
            self.winners.append(self.pop_tmsel())
        
        for i in range(len(self.elites)):
            self.individuals.pop(len(self.individuals) - 1)

       
        return self.elites[0]#return best
        
    
    def pop_tmsel(self):#selection
        
        winner = random.randrange(0, len(self.individuals))
        best = self.individuals[winner]
        x = self.tm_size
        #tournament 
        for i in range(x):
           
            
            #select a random individual
            temp_index = random.randrange(0, len(self.individuals))
            ind = self.individuals[temp_index]
            #select winner
            if (ind.fitness > best.fitness):
                best = ind
                winner = temp_index
        #remove the winner from the list
        self.individuals.pop(winner)
        #return it
        return best
    
    def crossover(self):
        #clear the previous data
        self.children.clear()
        self.nonelites.clear()
        temp1=deepcopy(self.winners)#save winner
        #crossover
        while(len(self.winners)):
            
            if (len(self.winners) == 1):
                self.children.append(self.winners.pop(0))
            
            else:
                #choose two individuals
                parent1 = self.winners.pop(random.randrange(0, len(self.winners)))
                parent2 = self.winners.pop(random.randrange(0, len(self.winners)))
                #create two children
                children1 = individual(self.num_genes)
                children2 = individual(self.num_genes)
                #crossover
                for j in range(0, self.num_genes):
                    if (random.random() < 0.5):
                        children1.chromosome[j] = parent1.chromosome[j]
                        children2.chromosome[j] = parent2.chromosome[j]
                    else:
                        children1.chromosome[j] = parent2.chromosome[j]
                        children2.chromosome[j] = parent1.chromosome[j]
                
                self.children.append(children1)
                self.children.append(children2)
        #determine the nonelites list
        #self.nonelites = temp1 + self.children comment out this part to try
        #improvement suggestion
        self.nonelites = self.individuals + self.children
        #comment in above to try my suggestion
    
    
    
    def mutatepopulation(self):
        #
        for ind in self.nonelites:#mutate
            ind.mutateindividual(mutation_prob = self.mutation_prob, mutation_type = self.mutation_type)
        #update 
        temp = self.elites + self.nonelites
        self.individuals = deepcopy(temp)
        
    #sory to fitness
    def sortpopulation(self):
        self.individuals.chromosome = sorted(self.individuals, key = lambda x: x.fitness, reverse = True)
    
    #sort to value
    def sortPopRadi(self):
        for ind in self.individuals:
            ind.chromosome.sort(key=lambda x: x.radius, reverse=True)
            



#read painting
painting = cv2.imread("painting.png") #180x180
#extract info
height, width, channels = painting.shape
num_generations = 10000

allfit = []
num_gen_inc = num_generations + 1
x = 0

#loop all cases
# I did not think of putting all cases in a single code at first
# thus this part of the code is taken from efeyitim 
# I can not give a link since it has been put down
while (x != 21):
    temp_generations = 0
    prev_fitness = -9999999999
    allfit.clear()
    #num_inds =  default
    if (x == 0):
        num_inds         = 5
        num_genes         = 50
        tm_size            = 5
        frac_elites        = 0.2
        frac_parents    = 0.6
        mutation_prob    = 0.2
        mutation_type    = "guided"
        num_generations = 10000
        directory = "num_inds5"
    #num_inds = 10
    elif (x == 1):
        num_inds         = 10
        num_genes         = 50
        tm_size            = 5
        frac_elites        = 0.2
        frac_parents    = 0.6
        mutation_prob    = 0.2
        mutation_type    = "guided"
        num_generations = 10000
        directory = "num_inds10"
    #num_inds = 20
    elif (x == 2):
        num_inds         = 20
        num_genes         = 50
        tm_size            = 5
        frac_elites        = 0.2
        frac_parents    = 0.6
        mutation_prob    = 0.2
        mutation_type    = "guided"
        num_generations = 10000
        directory = "num_inds20"
    #num_inds = 50
    elif (x == 3):
        num_inds         = 50
        num_genes         = 50
        tm_size            = 5
        frac_elites        = 0.2
        frac_parents    = 0.6
        mutation_prob    = 0.2
        mutation_type    = "guided"
        num_generations = 10000
        directory = "num_inds50"
    #num_inds = 75
    elif (x == 4):
        num_inds         = 75
        num_genes         = 50
        tm_size            = 5
        frac_elites        = 0.2
        frac_parents    = 0.6
        mutation_prob    = 0.2
        mutation_type    = "guided"
        num_generations = 10000
        directory = "num_inds75"
    #num_genes = 10
    elif (x == 5):
        num_inds         = 20
        num_genes         = 10
        tm_size            = 5
        frac_elites        = 0.2
        frac_parents    = 0.6
        mutation_prob    = 0.2
        mutation_type    = "guided"
        num_generations = 10000
        directory = "num_genes10"
    #num_genes = 25
    elif (x == 6):
        num_inds         = 20
        num_genes         = 25
        tm_size            = 5
        frac_elites        = 0.2
        frac_parents    = 0.6
        mutation_prob    = 0.2
        mutation_type    = "guided"
        num_generations = 10000
        directory = "num_genes25"
    #num_genes = 100
    elif (x == 7):
        num_inds         = 20
        num_genes         = 100
        tm_size            = 5
        frac_elites        = 0.2
        frac_parents    = 0.6
        mutation_prob    = 0.2
        mutation_type    = "guided"
        num_generations = 10000
        directory = "num_genes100"
    #num_genes = 150
    elif (x == 8):
        num_inds         = 20
        num_genes         = 150
        tm_size            = 5
        frac_elites        = 0.2
        frac_parents    = 0.6
        mutation_prob    = 0.2
        mutation_type    = "guided"
        num_generations = 10000
        directory = "num_genes150"
    #tm_size = 2
    elif (x == 9):
        num_inds         = 20
        num_genes         = 50
        tm_size            = 2
        frac_elites        = 0.2
        frac_parents    = 0.6
        mutation_prob    = 0.2
        mutation_type    = "guided"
        num_generations = 10000
        directory = "tm_size2"
    #tm_size = 10
    elif (x == 10):
        num_inds         = 20
        num_genes         = 50
        tm_size            = 10
        frac_elites        = 0.2
        frac_parents    = 0.6
        mutation_prob    = 0.2
        mutation_type    = "guided"
        num_generations = 10000
        directory = "tm_size10"
    #tm_size = 20
    elif (x == 11):
        num_inds         = 20
        num_genes         = 50
        tm_size            = 20
        frac_elites        = 0.2
        frac_parents    = 0.6
        mutation_prob    = 0.2
        mutation_type    = "guided"
        num_generations = 10000
        directory = "tm_size20"
    #frac_elites = 0.05
    elif (x == 12):
        num_inds         = 20
        num_genes         = 50
        tm_size            = 5
        frac_elites        = 0.05
        frac_parents    = 0.6
        mutation_prob    = 0.2
        mutation_type    = "guided"
        num_generations = 10000
        directory = "frac_elites0.05"
    #frac_elites = 0.4
    elif (x == 13):
        num_inds         = 20
        num_genes         = 50
        tm_size            = 5
        frac_elites        = 0.4
        frac_parents    = 0.6
        mutation_prob    = 0.2
        mutation_type    = "guided"
        num_generations = 10000
        directory = "frac_elites0.4"
    #frac_parents = 0.2
    elif (x == 14):
        num_inds         = 20
        num_genes         = 50
        tm_size            = 5
        frac_elites        = 0.2
        frac_parents    = 0.2
        mutation_prob    = 0.2
        mutation_type    = "guided"
        num_generations = 10000
        directory = "frac_parents0.2"
    #frac_parents = 0.4
    elif (x == 15):
        num_inds         = 20
        num_genes         = 50
        tm_size            = 5
        frac_elites        = 0.2
        frac_parents    = 0.4
        mutation_prob    = 0.2
        mutation_type    = "guided"
        num_generations = 10000
        directory = "frac_parents0.4"
    #frac_parents = 0.8
    elif (x == 16):
        num_inds         = 20
        num_genes         = 50
        tm_size            = 5
        frac_elites        = 0.2
        frac_parents    = 0.8
        mutation_prob    = 0.2
        mutation_type    = "guided"
        num_generations = 10000
        directory = "frac_parents0.8"
    #mutation_prob = 0.1
    elif (x == 17):
        num_inds         = 20
        num_genes         = 50
        tm_size            = 5
        frac_elites        = 0.2
        frac_parents    = 0.6
        mutation_prob    = 0.1
        mutation_type    = "guided"
        num_generations = 10000
        directory = "mutation_prob0.1"
    #mutation_prob = 0.5
    elif (x == 18):
        num_inds         = 20
        num_genes         = 50
        tm_size            = 5
        frac_elites        = 0.2
        frac_parents    = 0.6
        mutation_prob    = 0.5
        mutation_type    = "guided"
        num_generations = 10000
        directory = "mutation_prob0.5"
    #mutation_prob = 0.8
    elif (x == 19):
        num_inds         = 20
        num_genes         = 50
        tm_size            = 5
        frac_elites        = 0.2
        frac_parents    = 0.6
        mutation_prob    = 0.8
        mutation_type    = "guided"
        num_generations = 10000
        directory = "mutation_prob0.8"
    #mutation_type = unguided
    elif (x == 20):
        num_inds         = 20
        num_genes         = 50
        tm_size            = 5
        frac_elites        = 0.2
        frac_parents    = 0.6
        mutation_prob    = 0.2
        mutation_type    = "unguided"
        num_generations = 10000
        directory = "unguided"

    print(directory)
    
    pop = population(num_inds=num_inds, num_genes=num_genes, tm_size=tm_size, frac_elites=frac_elites, frac_parents=frac_parents, mutation_prob=mutation_prob, mutation_type=mutation_type)
    
    while (temp_generations != (num_generations)):

        #sort by radius
        pop.sortPopRadi()
        
        
        #evaluate 
        pop.evalpopulation(painting)


        #select winner
        best = pop.selection()
        
        
        
        
        if(((temp_generations)%100)==99):
            print(temp_generations, best.fitness)
        
        #append best fitness to fitness list
        allfit = allfit + [best.fitness]
       
        prev_best = best.fitness
        #crossover
        pop.crossover()
        #mutate 
        pop.mutatepopulation()

        #plot image
        if (temp_generations % 1000 == 999):
            cv2.imwrite("./Images/" + directory + "/GN" + str(temp_generations) + "_NI" + str(num_inds) + "_NG" + str(num_genes) +     "_TS" + str(tm_size) + "_FE" + str(frac_elites) + "_FP" + str(frac_parents) + "_MP" + str(mutation_prob) + "_" + mutation_type + ".png", best.findbestimage())
        
        #increment the current generation number
        temp_generations = temp_generations + 1
    
    
    #plot fitness figure from 1 to 10000
    plt.figure()
    plt.plot(allfit)
    plt.savefig("./Fitness/" + directory + "/1_to_10000" + str(temp_generations) + "_NI" + str(num_inds) + "_NG" + str(num_genes) + "_TS" + str(tm_size) + "_FE" + str(frac_elites) + "_FP" + str(frac_parents) + "_MP" + str(mutation_prob) + "_" + mutation_type + ".png")

    #plot fitness figure from1000 to 10000
    plt.figure()
    plt.plot(allfit[999:])
    plt.savefig("./Fitness/" + directory + "/1000_to_10000" + str(temp_generations) + "_NI" + str(num_inds) + "_NG" + str(num_genes) + "_TS" + str(tm_size) + "_FE" + str(frac_elites) + "_FP" + str(frac_parents) + "_MP" + str(mutation_prob) + "_" + mutation_type + ".png")
    
    
    x = x + 1


            
            
