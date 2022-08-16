#include <pthread.h>
#include <unistd.h>
#include <malloc.h>
//#include <stdio.h>
#include <time.h>
#include <math.h>
#include <string.h>
#include <semaphore.h>
#include <stdlib.h>


double GENERATION_RATE = 100.0;     //generation rate
int Num_atoms=0;// number of total aatoms
char molecules[][20]={"H20","CO2","NO2","NH3","nn"};// array to print molecules
int exitcode=0;
sem_t NO2_Create;//semaphores to wake up create threads
sem_t NH3_Create;
sem_t CO2_Create;
sem_t H2O_Create;

sem_t O_Create;// semaphores to indicate an atom is created
sem_t C_Create;
sem_t N_Create;
sem_t H_Create;

sem_t create;// semaphore to block multiple atoms generated at the same time
sem_t infoupdate;// info update semaphores
sem_t infoupdatemain;// directing info update to main
int moleculetype=0;
double sleeptime;// sleeptime
int atomid=0;// golbal variable to create a timestamp

                     
            
pthread_t ocreate;// atom create threads
pthread_t ccreate; 
pthread_t ncreate;  
pthread_t hcreate;


pthread_t co2_produce;// molecule produce threads
pthread_t nh3_produce;
pthread_t h2o_produce;
pthread_t no2_produce;
int Doneatoms = 0;                
                
	
int numberofatoms=40;
int numberofc=40;
int numberofo=40;
int numberofn=40;
int numberofh=40;
double exponential(double lambda);
void *Produce_C(){
        
    
    
    while(numberofc>0){// create count
        sem_wait(&create);// wait for semaphore
        sem_post(&C_Create);// update the created C count
        
        double sleepc=(unsigned int)(exponential(GENERATION_RATE)*1000000);
        numberofc--;// decrease number of left atoms
        
        printf("C with ID: %d is created \n",atomid);// print to console that atom is created
        
        
        atomid=atomid+1;// increase timestamp
        sem_post(&create);// release semaphore
        sem_post(&CO2_Create);// wake up co2 create to check if co2 cna be created
        usleep(sleepc);


    }
};
void *Produce_O(){ //SAME AS PRODUCE_C
    while(numberofo>0){
        sem_wait(&create);
        sem_post(&O_Create);

        double sleepo=(unsigned int)(exponential(GENERATION_RATE)*1000000);
        numberofo--;
        printf("O with ID: %d is created \n",atomid);
        atomid=atomid+1;
        sem_post(&create);
        sem_post(&CO2_Create);
        sem_post(&NO2_Create);
        usleep(sleepo);
     }};
void *Produce_H(){ //SAME AS PRODUCE_C
    while(numberofh>0){
        sem_wait(&create);
        sem_post(&H_Create);

        double sleeph=(unsigned int)(exponential(GENERATION_RATE)*1000000);
        numberofh--;
         printf("H with ID: %d is created \n",atomid);
        atomid=atomid+1;
        sem_post(&create);
        sem_post(&H2O_Create);
        sem_post(&NH3_Create);
        usleep(sleeph);

    }};
void *Produce_N(){ //SAME AS PRODUCE_C
    while(numberofn>0){
        sem_wait(&create);
        sem_post(&N_Create);

        double sleepn=(unsigned int)(exponential(GENERATION_RATE)*1000000);
        numberofn--;
         printf("N with ID: %d is created \n",atomid);
        atomid=atomid+1;
        sem_post(&create);
        sem_post(&NH3_Create);
        sem_post(&NO2_Create);
        usleep(sleepn);


    }};

void *CO2_Produce(){// THREAD TO PRODUCE A CO2
int ccount=0;//C count
int ocount=0;//O count
while(1){
    sem_wait(&CO2_Create);// wait for a wake up call from produce threads
    if(ccount==0)// if there is a need for C check the C create semiphore
        if(sem_trywait(&C_Create)==0)// if the semaphore is decreased, atom was available and used
        ccount=ccount+1;
    while(ocount<2){// check if there is a need for O
        if(sem_trywait(&O_Create)==0){// check the semaphroe
        ocount=ocount+1;}// if the semaphore is decreased then increase O count
        else break;}// break if the semaphore could not be downed
    if((ocount==2)&&(ccount==1))// if the number of C and O is enough create atom
    {sem_wait(&infoupdate);// wait for info update to be your turn
    ccount=0;// reset count
    ocount=0;
    moleculetype=2;// update molecule  type
    sem_post(&infoupdatemain);// signal main to print
    }


}


};
void *NO2_Produce(){// SAME AS CO2_PRODUCE
    int ncount=0;
    int ocount=0;
    while(1){
        sem_wait(&NO2_Create);
    if(ncount==0)
        if(sem_trywait(&N_Create)==0)
        ncount=ncount+1;
    while(ocount<2){
        if(sem_trywait(&O_Create)==0){
        ocount=ocount+1;}
        else break;}
    if((ocount==2)&&(ncount==1))
    {
       sem_wait(&infoupdate);
       ncount=0;
       ocount=0;
    moleculetype=3;
    sem_post(&infoupdatemain); 
    }

}
};
void *NH3_Produce(){// SAME AS CO2_PRODUCE
    int ncount=0;
    int hcount=0;
    while(1){
    sem_wait(&NH3_Create);
    
    if(ncount==0)
        if(sem_trywait(&N_Create)==0)
        ncount=ncount+1;
    while(hcount<3){
        if(sem_trywait(&H_Create)==0){
        hcount=hcount+1;}
        else break;}
    if((hcount==3)&&(ncount==1))
    {sem_wait(&infoupdate);
    hcount=0;
    ncount=0;
    moleculetype=4;
    sem_post(&infoupdatemain);}

}
};
void *H2O_Produce(){// SAME AS CO2_PRODUCE
    int hcount=0;
    int ocount=0;
    while(1){
    sem_wait(&H2O_Create);
    if(ocount==0)
        if(sem_trywait(&O_Create)==0)
        ocount=ocount+1;
    while(hcount<2){
        if(sem_trywait(&H_Create)==0){
        hcount=hcount+1;}
        else break;}
    if((hcount==2)&&(ocount==1))
    {sem_wait(&infoupdate);
    hcount=0;
    ocount=0;
    moleculetype=1;
    sem_post(&infoupdatemain);}

}
};




int main(int argc, char *argv[])
{
	
    int option;
    int atomt;
    
    

    while((option = getopt(argc,argv,"m:g:")) !=-1)
    {
        switch(option)
        {
            
            case 'm':
                numberofatoms = atof(optarg);
                break;
            case 'g':
                GENERATION_RATE = atof(optarg);
                break;
        }
    }
    numberofc=numberofh=numberofn=numberofo=numberofatoms;  // take input and change the number of atoms or generation rate
    numberofatoms=numberofatoms*4;  //
    
    printf("numberOfEachAtom    : %d\n", numberofatoms);
    printf("GENERATION_RATE   : %f\n", GENERATION_RATE);
    
  
    
    sem_init(&CO2_Create,0,0);//initate semaphores
    sem_init(&NO2_Create,0,0);
    sem_init(&H2O_Create,0,0);
    sem_init(&NH3_Create,0,0);

    sem_init(&C_Create,0,0);// initiate atom producing semaphores
    sem_init(&C_Create,0,0);
    sem_init(&C_Create,0,0);
    sem_init(&C_Create,0,0);

    sem_init(&create,0,1);// initate create semaphore with start value 1, since it is needed for production start
    sem_init(&infoupdate,0,1);// initiate infoupdate with 1 since it is ineeded for info printing
    sem_init(&infoupdatemain,0,0);
    
     
        
    pthread_create(&ccreate, NULL, Produce_C, NULL); // create thrad
    pthread_create(&ocreate, NULL, Produce_O, NULL);
    pthread_create(&ncreate, NULL, Produce_N, NULL);
    pthread_create(&hcreate, NULL, Produce_H, NULL);

    pthread_create(&h2o_produce, NULL, H2O_Produce, NULL);// create thread
    pthread_create(&no2_produce, NULL, NO2_Produce, NULL);
    pthread_create(&co2_produce, NULL, CO2_Produce, NULL);
    pthread_create(&nh3_produce, NULL, NH3_Produce, NULL);
    
    
    while(1){
        
        if(sem_trywait(&infoupdatemain)==0){// wait for info
        printf("%s is created \n",molecules[moleculetype-1]);// print molecule
        sem_post(&infoupdate);}
        if((numberofc==0)&&(numberofh==0)&&(numberofn==0)&&(numberofo==0)){// if all atoms are produced 
        for(int i=0;i<20;i++){// wait for 20 more turns so that the molecule produce threads can produce remaning atoms
        if(sem_trywait(&infoupdatemain)==0)
        printf("%s is created \n",molecules[moleculetype-1]);
        sem_post(&infoupdate);
        usleep(100);
        
        }
        break;
        }
        


    }


    
    //delete threads
    
    

     pthread_cancel(ccreate);
     pthread_cancel(ccreate);
     pthread_cancel(ccreate);
     pthread_cancel(ccreate);

     pthread_cancel(h2o_produce);
     pthread_cancel(no2_produce);
     pthread_cancel(co2_produce);
     pthread_cancel(nh3_produce);

     sem_destroy(&O_Create);
     sem_destroy(&H_Create);
     sem_destroy(&N_Create);
     sem_destroy(&C_Create);

     sem_destroy(&CO2_Create);
     sem_destroy(&NO2_Create);
     sem_destroy(&H2O_Create);
     sem_destroy(&CO2_Create);

     sem_destroy(&infoupdate);
     sem_destroy(&infoupdatemain);
     sem_destroy(&create);
       // pthread_cond_destroy(&tubeConds[i]);  

    //free dynamic memories
   // destroytube(tubes, numberOftubes);
    //free(tubeThreads);
}
double exponential(double lambda)
{
    double u = rand() / (RAND_MAX + 1.0);
    return -log(1-u) / lambda;
}