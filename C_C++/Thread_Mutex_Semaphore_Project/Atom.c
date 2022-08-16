#include "Atom.h"
#include <pthread.h>
#include <unistd.h>
#include <malloc.h>
#include <time.h>
#include <math.h>
//function to create tubes
struct tube* createTubes()
{
    struct tube* mytubes = malloc(sizeof(struct tube) * numberOftubes);// allocate size for each tube
    Tubeids=malloc(sizeof(int)*numberOftubes);// allocate size for id

    for (int i = 0; i < numberOftubes; i++)// initiate each tube
    {
        Tubeids[i] = i;// initiate tube id
        mytubes[i].atoms=malloc(sizeof(int)* 4);// allocate tube atoms array
        mytubes[i].atoms[0]=0;
        mytubes[i].atoms[1]=0;
        mytubes[i].atoms[2]=0;
        mytubes[i].atoms[3]=0;// initiate tube atoms array to 0
        mytubes[i].tubeID=i;//
        mytubes[i].tubeTS = -1;//initiate tube timestamp  
        mytubes[i].Moleculetype = -1;// initiate tube molocule type
    }

    return mytubes;
}

//function to destroy mtubes
void *destroytube(struct tube* tubes, int numberOftubes)// destroy tubes
{
    for (int i = 0; i < numberOftubes; i++)
    free(tubes[i].atoms);
    free(tubes);

}
 

 



 
void addAtom(struct tube* mtube, int atomtype,int atomid)// add atom to tube
{
    
    //check whether the tube is empty
    //if it is empty
    if (mtube->tubeTS == -1) //first atom
    {
        mtube->tubeTS = atomid;// update timestamp
       
        mtube->Moleculetype =10+ atomtype;// update molecule type 11= just carbon 12= just o 13=just nitrogen 14=just hydrogen
        if(atomtype==1)mtube->Moleculetype =2;
    }
    mtube->atoms[atomtype-1]=mtube->atoms[atomtype-1]+1;// update atom count in array
    //printf("Tube%d content %d %d %d %d \n",mtube->tubeID,mtube->atoms[0],mtube->atoms[1],mtube->atoms[2],mtube->atoms[3]);
        
   
    
    
}



void emptytube(struct tube* mtube)
{
 
    
    //check if the tube is empty,
    if (mtube->tubeTS==-1)
    {
        printf("tube is already empty!\n");
       
    } 
    //find the client in front of the mtube and decrement the current size of this mtube
    mtube->Moleculetype=-1;// reset molocuşe
    mtube->tubeTS=-1;
    mtube->atoms[0]=0;
    mtube->atoms[1]=0;
    mtube->atoms[2]=0;
    mtube->atoms[3]=0;
    // reset all variables
    

}

double exponential(double lambda)// exponential function to calculate sleep time
{
    double x = rand() / (RAND_MAX + 1.0);
    return -log(1-x) / lambda;
}