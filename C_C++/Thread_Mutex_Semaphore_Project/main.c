#include <pthread.h>
#include <unistd.h>
#include <malloc.h>
//#include <stdio.h>
#include <time.h>
#include "Atom.c"
#include <math.h>
#include <string.h>

//gcc main.c-pthread -lm

    
int CarbonAtoms = 20;               //c input
int NitrogenAtoms = 20;              //n input
int OxygenAtoms = 20;                 //o inpuy
int HydrogenAtoms =20;        //h input
double GENERATION_RATE = 100.0;     //g input
int Num_atoms=0;// ttotal number of atoms
char element[5]={"CONH"};// char array used to print atom names like 'C' 'O'
char molecules[][20]={"H20","CO2","NO2","NH3","nn"};//2 dimensional char array used to print molecules


                      
struct Information info;            //information struct variable
pthread_t SupervisrThread;              //thread for the writing the molecules
pthread_t *tubeThreads;             //thread for every desk
pthread_mutex_t UpdateMutex;        //used to update info variable
pthread_mutex_t DoneMutex;          //used to increase done variable
pthread_mutex_t *tubemutexes;       //mutex for each tube
pthread_cond_t SupervisorCond;           //condition signal for supervisor
pthread_cond_t *tubeConds;          //in order to signal tubes to continue
int Doneatoms = 0;                //number of atoms done.
int infoUpdate = 0;                 //check if the info is updated
struct tube* tubes; 	//tubes

//desk thread
void *tubethread (void *args)
{
    int tubenumber = *((int*)args);//find the tube number
  

    pthread_mutex_t *thistubemutex = &tubemutexes[tubenumber];
    pthread_cond_t *thistubeCond = &tubeConds[tubenumber];
    //until all the atoms are done
    while (1)
    {
        //lock the tube first
        pthread_mutex_lock(thistubemutex);
        //wait for wake signal
        pthread_cond_wait(thistubeCond,thistubemutex);
     

         
       //check if a molecule can be created if so create and update info variable
        if((tubes[tubenumber].atoms[1]==1&&tubes[tubenumber].atoms[3]==2)
       ||(tubes[tubenumber].atoms[0]==1&&tubes[tubenumber].atoms[1]==2)
       ||(tubes[tubenumber].atoms[2]==1&&tubes[tubenumber].atoms[1]==2)
       ||(tubes[tubenumber].atoms[2]==1&&tubes[tubenumber].atoms[3]==3)
        ){
        
        pthread_mutex_lock(&UpdateMutex);// lock if molecule will be created
       
        //update info
        info.tubeID=tubenumber;//update info
        info.mytube=&tubes[tubenumber];
        info.Molocule=tubes[tubenumber].Moleculetype;// update molecule type
        emptytube(&tubes[tubenumber]);// emptyout the tube
        
    
        infoUpdate = 1;// update the info flag
        pthread_cond_signal(&SupervisorCond);// send signal to print to console
        pthread_mutex_unlock(&UpdateMutex);// unlock update
        
        }
        pthread_mutex_unlock(thistubemutex);// unlock tube
    }
    //terminate the thread
    pthread_exit(NULL);
}

void *SupervisorThread (void *args)
{
    //work until atoms are done
    while (1)
    {
        //lock the update
        pthread_mutex_lock(&UpdateMutex);
        while (infoUpdate != 1)// wait for info update
        {
            pthread_cond_wait(&SupervisorCond,&UpdateMutex);         
        }
        
        printf("%s is created in tube %d.\n",molecules[info.Molocule-1],info.tubeID);
        
        // print the molecule created in the tube 

        
        

        //reset the infoupdate
        infoUpdate = 0;
        //unlock the supervisor
        pthread_mutex_unlock(&UpdateMutex);// unlock supervisor
    }
    
    pthread_exit(NULL);
}


int main(int argc, char *argv[])
{

    int option;
    int atomt;
    
    

    while((option = getopt(argc,argv,"c:n:o:h:g:")) !=-1)
    {
        switch(option)
        {
            case 'c':
                CarbonAtoms = atoi(optarg);
                break;
            case 'n':
                NitrogenAtoms= atoi(optarg);
                break;
            case 'o':
                OxygenAtoms = atoi(optarg);
                break;
            case 'h':
                HydrogenAtoms = atof(optarg);
                break;
            case 'g':
                GENERATION_RATE = atof(optarg);
                break;
        }// take console input arguments
    }

    //
    printf("CarbonAtoms       : %d\n", CarbonAtoms);
    printf("NitrogenAtoms     : %d\n", NitrogenAtoms);
    printf("OxygenAtoms       : %d\n", OxygenAtoms);
    printf("HydrogenAtoms     : %d\n", HydrogenAtoms);
    printf("GENERATION_RATE   : %f\n", GENERATION_RATE);
    int natoms[4]={CarbonAtoms,NitrogenAtoms,OxygenAtoms,HydrogenAtoms};// number of each atom as an array
    //initialize mutexes
    pthread_mutex_init(&DoneMutex, NULL);// initiate done mutex
    Num_atoms=CarbonAtoms+NitrogenAtoms+OxygenAtoms+HydrogenAtoms;// total number of atoms
    
    tubes = createTubes();// createtubes

    //create tube threads and mutexes
    tubeThreads = malloc(sizeof(pthread_t) * numberOftubes);
    tubemutexes = malloc(sizeof(pthread_mutex_t) * numberOftubes);
    tubeConds = malloc(sizeof(pthread_cond_t) * numberOftubes);
    for (int i = 0; i < numberOftubes ; i++)
    {
        pthread_mutex_init(&(tubemutexes[i]), NULL);
        pthread_cond_init(&(tubeConds[i]), 0);
		pthread_create(&(tubeThreads[i]), NULL, tubethread,(void*) &(Tubeids[i]));
    }
    //initiate threads
    
    
    pthread_mutex_init(&UpdateMutex, NULL);
    pthread_cond_init(&SupervisorCond, 0);
    pthread_create(&SupervisrThread, NULL, SupervisorThread, NULL);

    unsigned int mainThreadSleepTime = 0;       //main thread sleep time 
    //loop until Num_atoms=0
    for (int createAtoms = 0; createAtoms < Num_atoms; createAtoms++)
    {   int truetube = -1; //reset true tube to -1
        int firstempty=-1; //reset firstempty  to -1
        int testts=-1;//reset testts to -1
        int truemoleculetype=-1;//reset molecule to -1
        while(1){
             atomt=(rand()%4)+1;
            if(natoms[atomt-1]!=0)break;// create a random element and check if the element is available
            }//loop again if the element is not availale
            natoms[atomt-1]=natoms[atomt-1]-1;
           
        printf("%c with ID:%d is created \n", element[atomt-1],createAtoms);//print created atom
        mainThreadSleepTime = (unsigned int) (exponential(GENERATION_RATE) * 1000000.0);
        
        // lock tubes
        for (int i = 0; i < numberOftubes; i++){
            pthread_mutex_lock(&tubemutexes[i]);
        }
        for (int i = 0; i < numberOftubes; i++){// find the first empty tube
            if((tubes[i].Moleculetype==-1)&&(tubes[i].tubeTS==-1)&&(firstempty==-1)){
                firstempty=i;
                exit;
            }
        }
            //printf("firtempty i %d   %d\n",firstempty,truetube); debugging
        for (int i = 0; i < numberOftubes; i++)// check all tubes for  best fit
        { //printf("TS type %d \n",tubes[i].tubeTS); debugging
            int testtube=-1;// resert testtube variable, 
            int moleculetype=-1;// reset molecule type
            // if the element can be fit into the tube, testtube and molecule type is changed 
            if(atomt==1){//carbon check
                if(tubes[i].Moleculetype==12){
                testtube=i;
                moleculetype=2;
                }

            }
            else if(atomt==2){//oxygen check
                //printf("true tube oksijen %d \n",testtube);debugging
                if((tubes[i].Moleculetype==12)&&(tubes[i].atoms[1]==1))
                {testtube=i;
                moleculetype=12;
                }
                else if ((tubes[i].Moleculetype==14)&&(tubes[i].atoms[3]<3))
                {testtube=i;
                moleculetype=1;}
                else if(tubes[i].Moleculetype==13){
                testtube=i;
                moleculetype=3;
                }
                else if(tubes[i].Moleculetype==2)
                {testtube=i;
                moleculetype=2;}
                else if(tubes[i].Moleculetype==3){
                testtube=i;
                moleculetype=3;
                }
            }                
            else if(atomt==3){//nitrogen check
                if(tubes[i].Moleculetype==12){
                testtube=i;
                moleculetype=3;}
                else if(tubes[i].Moleculetype==14){
                    testtube=i;
                    moleculetype=4;
                    
                }
            }
            else if(atomt==4){//hydrogen check
                if((tubes[i].Moleculetype==12||tubes[i].Moleculetype==1)&&tubes[i].atoms[1]==1){
                    testtube=i;
                    moleculetype=1;}
                else if(tubes[i].Moleculetype==13){
                testtube=i;
                moleculetype=4;
                }
                else if((tubes[i].Moleculetype==14)&&(tubes[i].atoms[3]<3)){
                testtube=i;
                moleculetype=14;
                }
                else if((tubes[i].Moleculetype==4)){
                testtube=i;
                moleculetype=4;
                }
    

            }
            //if this is the first correct fit then update truetube and truemolecule
            if((truetube==-1)&&(testtube!=-1)){
                truetube=testtube;
                testts=tubes[i].tubeTS;
                truemoleculetype=moleculetype;

            }// if the new fit tubes has smaller time stamp than the previous one,make the true tube this tube
            else if((testtube!=-1)&&(tubes[i].tubeTS<testts)){
                truetube=testtube;
                testts=tubes[i].tubeTS;
                truemoleculetype=moleculetype;
            }

        }

        if(truetube!=-1){// if there are no fit tube, it will be emptied to firstempty tube
        firstempty=truetube;
        }
        if(firstempty!=-1)// if there is a fit, update molecule type
        tubes[firstempty].Moleculetype=truemoleculetype;

        //unlock tubes
        for (int i = 0; i < numberOftubes; i++){
            pthread_mutex_unlock(&tubemutexes[i]);
            
        }
        if (firstempty != -1){// if there is a fit, add it into tube
                pthread_mutex_lock(&tubemutexes[firstempty]);// lock the correc tube
                pthread_mutex_lock(&DoneMutex);// lock donemutex
                Doneatoms++;// update done
                pthread_mutex_unlock(&DoneMutex);// unlock done
                addAtom(&tubes[firstempty],atomt,createAtoms);// add the atom to tube
                pthread_cond_signal(&tubeConds[firstempty]);
                pthread_mutex_unlock(&tubemutexes[firstempty]);// unlock mutex
        }
        else
        {// if there is no crrect fit, discard
            pthread_mutex_lock(&DoneMutex);
            printf("Atom %d discarded.\n", createAtoms);
            Doneatoms++;
            
            pthread_mutex_unlock(&DoneMutex);
        }
        //main thread sleep
        usleep(mainThreadSleepTime);
    }

    //wait until every client leaves
    while(Doneatoms != Num_atoms);
    usleep(mainThreadSleepTime);// wait until all atoms are done
    //for(int i=0;i<numberOftubes;i++){//debugging
     //printf("%d %d %d %d \n",tubes[i].atoms[0],tubes[i].atoms[1],tubes[i].atoms[2],tubes[i].atoms[3]);} 
   
    //delete threads
    pthread_cancel(SupervisrThread);//cancel threads
    for (int i = 0; i < numberOftubes; i++)
        pthread_cancel(tubeThreads[i]);

    //destroy the mutexe cond
    pthread_mutex_destroy(&DoneMutex);
    pthread_mutex_destroy(&UpdateMutex);
    for (int i = 0; i < numberOftubes; i++)
        pthread_mutex_destroy(&tubemutexes[i]);

    pthread_cond_destroy(&SupervisorCond);
    for (int i = 0; i < numberOftubes; i++)
        pthread_cond_destroy(&tubeConds[i]);  

    //free dynamic memories
    destroytube(tubes, numberOftubes);//destroy tube
    free(tubeThreads);
}