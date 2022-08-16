//ALPEREN KOYUN 2305001 EE442 HW2


#include <unistd.h> //sleep
#include <time.h>
#include <limits.h>
#include <ucontext.h>
#include <signal.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>//For error
#define STACK_SIZE 8192
// if P&WF      => PWF = 1
// else if SRTF => PWF = 0
#define PWF 0// change this to get SRTF scheduler
#define empty 1//emptystate
#define ready 2//ready state
#define running 3//running state
#define finished 5//finished state
#define IO 4//IO state

int finishedthread=0;
int rtime=2;
int nocontext=0;
int maincheck=0;

typedef struct ThreadInfo
{
    int ThreadIndex;       //thread number, from 0 to TotalThreads]
    int ArrayIndex;         //index of this thread in thread array
    int duration;           //time required to execute this thread
    int state;          //thread status
    int ioduration;
    ucontext_t context;     //thread context
    
} ThreadInfo;

void initializeThread();
int createThread();
void exitThread(int ThreadIndex);
void runThread(int ThreadIndex, int totalDuration);
void PWF_Scheduler();
void SRTF_Scheduler();
void lotteryFunction();
void ShortestFunction();
void SelectNextThread();
void printstate();
int gcd(int a, int b);
int findGCD(int arr[], int n);

ThreadInfo **AllThreads;            //all of the threads

ThreadInfo **ThreadArray;           //this is the thread array of size 6.
int ShareArray[5];                  //stores the shares of the threads in the array
int DoneThreadNumber = 0;           //number of finished thread

int TotalShare = 0;                 //sum of all the shares of the threads in the array
int DoneFlag = 0;                   //it will be set if a thread is exited from the array
int TotalThreads = 0;               //number of threads including main thread
int CurrentThreadNumber = 1;        // currently executing thread number         
int NextThreadNumber = 1;           // next thread number that will be executed  ]
int lastExitedThreadNumber = 1;     //the last exited thread number                
int CumulativeLottery[5];           //this array is used in pwf scheduling. It is used to find the winner thread.

//this function is used to print states
//this prin line is taken from efe berkay yitim github, currently unavailable Thus, I can not give reference
void printstate()
{   if(ThreadArray[NextThreadNumber-1]->state==running)//dont print if it nos not on running state, it maybe io
    printf("running->T%d\tready->", ThreadArray[NextThreadNumber-1]->ThreadIndex);
    else printf("running->\tready->");
    int i = 0;
    int deletecomma = 0;// for deleting the (,) char
    int count = 0;
    for (i = 0; i < 4; i++)
    {
        if (ThreadArray[i] != NULL)
        {
            if (ThreadArray[i]->state == ready)
            {
                printf("T%d,",ThreadArray[i]->ThreadIndex);
                deletecomma = 1;
                count++;
            }
        }
    }
    if (ThreadArray[i] != NULL)
    {
        if (ThreadArray[i]->state == ready)
        {
            printf("T%d",ThreadArray[i]->ThreadIndex);
            deletecomma = 0;
            count++;
        }
    }
    if (deletecomma)
        printf("\b ");
    
    if  (count > 1)
        count = 2 + (count - 1) * 3;
    else
        count = count * 2;
    for (i = count; i < 12; i++)
        printf(" ");
    
    printf("\tfinished->");
    deletecomma = 0;
    for (i = 1; i < TotalThreads - 1; i++)
    {
        if (AllThreads[i]->state == finished)
        {
            printf("T%d,",AllThreads[i]->ThreadIndex);
            deletecomma = 1;
        }
    }
    if (AllThreads[i]->state == finished)
    {
        printf("T%d",AllThreads[i]->ThreadIndex);
        deletecomma = 0;
    }
    if (deletecomma)
        printf("\b ");
    ///IO
    printf("\tIO->");
    deletecomma = 0; 
    for (i = 1; i < TotalThreads - 1; i++)
    {
    //printf(" io sırası  %d : \n",AllThreads[i]->state );
     
        if (AllThreads[i]->state == IO)
        {

            printf("T%d,",AllThreads[i]->ThreadIndex);
            deletecomma = 1;
        }
    }
    if (AllThreads[i]->state == IO)
    {
        printf("T%d",AllThreads[i]->ThreadIndex);
        deletecomma = 0;
    }
    if (deletecomma)
        printf("\b ");

    printf("\n");
}




//initialize all the threads and array
void initializeThread()
{
    //make space for     threads
    AllThreads = malloc(sizeof(ThreadInfo*) * (TotalThreads));
    for (int i = 0; i < TotalThreads; i++)
        AllThreads[i] = malloc(sizeof(ThreadInfo));
    //make space of size 5
    ThreadArray = malloc(sizeof(ThreadInfo*) * 5);
    for (int i = 0; i < 5; i++)
        ThreadArray[i] = malloc(sizeof(ThreadInfo));
    //make space for thread shares




    //initialize all threads
    for (int i = 0; i < TotalThreads; i++)
    {
        //first one is main
        AllThreads[i]->ThreadIndex = i;
        AllThreads[i]->state = empty;
        AllThreads[i]->ArrayIndex = -1;
        AllThreads[i]->duration = -1;
        AllThreads[i]->ioduration = -1;
        
    }
    //initialize thread array
    for (int i = 0; i < 5; i++)
        ThreadArray[i] = NULL;
}

//this function is used at the very end of the main. It frees all the dynamic memory
void freeAll()
{
    //free Thread Array
    for (int i = 0; i < 5; i++)
        free(ThreadArray[i]);
    free(ThreadArray);



    //free All Threads
    for (int i = 0; i < TotalThreads; i++)
        free(AllThreads[i]);
    free(AllThreads);
}

void exitThread(int ThreadIndex)
{   //printf("current number : %d",1);//for debug
    //free the stack and  change the state to finished
    free(AllThreads[ThreadIndex]->context.uc_stack.ss_sp);
    AllThreads[ThreadIndex]->state = finished;
    //edit the last exited thread number, increment number of finished threads, set the doneflag 
    lastExitedThreadNumber = ThreadIndex;
    DoneThreadNumber++;
    
    DoneFlag = 2;
    
    //make the corresponding index of the array null which means removing the thread
    ThreadArray[AllThreads[ThreadIndex]->ArrayIndex] = NULL;
    //assign zero to the corresponding share index
    ShareArray[AllThreads[ThreadIndex]->ArrayIndex] = 0;
    //update the lottery array and totalshare
    //printf("\n exit functionn %d \n",CurrentThreadNumber);
    int temp = 0;
    for (int k = 0; k < 5; k++)
    {
        temp += ShareArray[k];
        CumulativeLottery[k] = temp;
    }
    TotalShare = temp;
    
    //go back to corresponding scheduler
    
    #if PWF
    PWF_Scheduler();
    #else
    SRTF_Scheduler();
    #endif
    
   
   
   //getcontext(&AllThreads[CurrentThreadNumber]->context);
   /*
   if(nocontext==1){
       nocontext=0;
   return;
   }
   else 
   */
   //swapcontext(&AllThreads[CurrentThreadNumber]->context, &AllThreads[0]->context);
}

//this thread is like a simple counter. 
void runThread(int ThreadIndex, int totalDuration)
{   
    for (int i = 1; i <= totalDuration; i++)
    {
        //if this is the last second, disable the alarm
        
        if (i == totalDuration)
            alarm(0);

        if(AllThreads[ThreadIndex]->state==running){
        for (int j = 1; j < ThreadIndex; j++)
            printf("\t");
        printf("%d\n", i);
        AllThreads[ThreadIndex]->duration--;
        }

        for (int j = 0; j < 5; j++){
            if(ThreadArray[j]!=NULL){
                if(ThreadArray[j]->state==IO){
                    if(ThreadArray[j]->ioduration==0){
                    finishedthread=ThreadArray[j]->ThreadIndex;
                    //printf("\n exit %d\n ",finishedthread);
                    /*
                    #if PWF
                    PWF_Scheduler();
                    #else
                    SRTF_Scheduler();
                    #endif
                    */
                    }
                    else
                    //printf("\n iodur %d \n",ThreadArray[j]->ioduration);
                    ThreadArray[j]->ioduration--;
                }
            }

        }
        
        sleep(1);
    }
    //printf("\n io önce \n");
    
    AllThreads[ThreadIndex]->state=IO;
    //printf(" aha bu state %d %d  :",AllThreads[ThreadIndex]->state,ThreadIndex);
    
    alarm(0);
    #if PWF
    PWF_Scheduler();
    #else
    SRTF_Scheduler();
    #endif
    int c=0;
    printf("running->\tready->\t\t\tfinished->");
    for (int c= 1; c < TotalThreads; c++)
        printf("T%d,",AllThreads[c]->ThreadIndex);
   
    printf("\nAll done!\n");
    
    return;
    //swapcontext(&AllThreads[CurrentThreadNumber]->context, &AllThreads[0]->context);
    //if the remaining time is 0, exit
    
}

int createThread()
{
    //iterate through all the thread array
    for (int i = 0; i < 5; i++)
    {
        //if there is an empty spot
        if (ThreadArray[i] == NULL)
        {
            //iterate through all the existing threads
            for (int j = 1; j < TotalThreads; j++)
            {
                //if a thread is not inserted to the system yet, insert it
                if (AllThreads[j]->state == empty)
                {
                    //assign the array index and make its state ready
                    AllThreads[j]->ArrayIndex = i;
                    AllThreads[j]->state = ready;
                    //insert to the array
                    ThreadArray[i] = AllThreads[j];
                    //add the new threads share
                    ShareArray[i] = TotalThreads-j;
                    //update the lottery array and totalshare
                    int temp = 0;
                    for (int k = 0; k < 5; k++)
                    {
                        temp += ShareArray[k];
                        CumulativeLottery[k] = temp;
                    }
                    TotalShare = temp;
                    //allocate stack and make context
                    getcontext(&AllThreads[j]->context);
                    AllThreads[j]->context.uc_stack.ss_sp = malloc(STACK_SIZE);
                    AllThreads[j]->context.uc_stack.ss_size = STACK_SIZE;
                    makecontext(&AllThreads[j]->context, (void*)runThread, 3, AllThreads[j]->ThreadIndex, AllThreads[j]->duration);
                    //return succesfully
                    return 1;
                }
            }
        }
    }
    //if a thread is not inserted to the array, return error
    return -1;
}

void PWF_Scheduler()
{   //int countnull
    int returncheck=0;
    int iocounter=0;
    int looper=1;
    int a=1;
    //printf("sheduler");
    if (DoneFlag==2)
    {   //printf("maingirdi %d\n",CurrentThreadNumber);
        DoneFlag = 1;
        if((nocontext==1)&&(maincheck==1)){nocontext=0;return;}
        else
        swapcontext(&ThreadArray[CurrentThreadNumber-1]->context, &AllThreads[0]->context);
        return;
    }

   
    for (int i = 0; i < 5; i++)
    {
        if (ThreadArray[i] != NULL)
        {   a=ThreadArray[i]->ioduration;
            //printf("\n chec öncesi %d %d \n",i,nocontext);
            
            if (a <1)
            {   returncheck=1;
                //printf("checkde");
                exitThread(ThreadArray[i]->ThreadIndex);
                return;
                
            }
            //printf("deneme %d ",ThreadArray[i]->ioduration );
            if((ThreadArray[i]->state) != IO){
            iocounter=1;
            }
        }

    }
    
    if(iocounter==0){
        //printf("print önce");
        printstate();
        while(looper){
            printf("\n");
        for (int j = 0; j < 5; j++){
            if(ThreadArray[j]!=NULL){
                if(ThreadArray[j]->state==IO){
                    if(ThreadArray[j]->ioduration==0){
                        //printf("\n exit %d\n ",ThreadArray[j]->ThreadIndex);
                        looper=0;
                        nocontext=1;
                        return;
                        #if PWF//never goes into here , just for testing
                        PWF_Scheduler();
                        #else
                        SRTF_Scheduler();
                        #endif
                        return;
                    
                    
                    }
                    else
                    //printf("\n iodur %d \n",ThreadArray[j]->ioduration);
                    ThreadArray[j]->ioduration--;
                }
            }

        }
        
        sleep(1);




        }
        


    }


    
    //select the next thread to be runs
    SelectNextThread();
}
void lotteryFunction()
{  
    int lottery = (rand() % TotalShare) + 1;
    NextThreadNumber = 1;

    for (int i = 0; i < 5; i++)
    {
        if (lottery <= CumulativeLottery[i] && ThreadArray[i] != NULL)
        {   if(ThreadArray[i]->state==running || ThreadArray[i]->state==ready){
                NextThreadNumber = i + 1;
                break;
        }   }
    }
}

//tfind shortest function
void ShortestFunction()
{
    int ShortestTime = INT_MAX;
    int ShortestThreadIndex = -1;
    for (int i = 0; i < 5; i++)
    {
        if (ThreadArray[i] != NULL)//check only running or ready states, dont check IO
        {   if(ThreadArray[i]->state==running || ThreadArray[i]->state==ready){
            if (ShortestTime > ThreadArray[i]->duration)
            {
                ShortestTime = ThreadArray[i]->duration;
                ShortestThreadIndex = i + 1;
            }
            }
        }
    }
    NextThreadNumber = ShortestThreadIndex;
}

void SelectNextThread()
{
    #if PWF
    lotteryFunction();
    #else
    ShortestFunction();
    #endif
    //("select\n");
    maincheck=0;
    //if the next thread is the same as prev., do not switch context
    if(DoneFlag==1){
        //printf("\n done1 \n");
        DoneFlag=0;
        //if the next selected thread to be run is the same as the previous
        if (NextThreadNumber == CurrentThreadNumber)
        {
            ThreadArray[NextThreadNumber-1]->state = running;
            //printf("\n print1 \n");
            printstate();
            alarm(2);
            //printf("threadnumber :%d \n",NextThreadNumber-1);
            //getcontext(&ThreadArray[NextThreadNumber-1]->context);
            swapcontext(&AllThreads[0]->context, &ThreadArray[NextThreadNumber-1]->context);
        }

        //if the prev. thread and the next thread are different
        else
        {
            if (ThreadArray[CurrentThreadNumber-1] != NULL)
                if(ThreadArray[CurrentThreadNumber-1]->state ==running)
                    ThreadArray[CurrentThreadNumber-1]->state = ready;
            ThreadArray[NextThreadNumber-1]->state = running;
            ("\n print2 \n");
            printstate();
            alarm(2);
            int TempThreadNumber = CurrentThreadNumber;
            CurrentThreadNumber = NextThreadNumber;
            //getcontext(&ThreadArray[NextThreadNumber-1]->context);
            swapcontext(&AllThreads[0]->context, &ThreadArray[NextThreadNumber-1]->context);
        }


    }
    else{
    if (NextThreadNumber == CurrentThreadNumber)
    {   //printf("\n print3 %d \n",NextThreadNumber-1);
        printstate();
        alarm(2);
    }
    
    //if the next thread is different then prev., switch context and update current thread number and next thread state
    else
    {
        if (ThreadArray[CurrentThreadNumber-1] != NULL)
            if(ThreadArray[CurrentThreadNumber-1]->state ==running)
            ThreadArray[CurrentThreadNumber-1]->state = ready;
        ThreadArray[NextThreadNumber-1]->state = running;
        //printf("\n print4 \n");
        printstate();
        alarm(2);
        int TempThreadNumber = CurrentThreadNumber;
        CurrentThreadNumber = NextThreadNumber;
        //getcontext(&ThreadArray[NextThreadNumber-1]->context);
        swapcontext(&ThreadArray[TempThreadNumber-1]->context, &ThreadArray[NextThreadNumber-1]->context);
    }
    }
}

void SRTF_Scheduler()
{   
    //int countnull
    int returncheck=0;
    int iocounter=0;
    int looper=1;
    int a=1;
    //printf("sheduler");
    if (DoneFlag==2)
    {   //printf("maingirdi %d\n",CurrentThreadNumber);
            DoneFlag = 1;
        if((nocontext==1)&&(maincheck==1)){nocontext=0;return;}
        else
            swapcontext(&ThreadArray[CurrentThreadNumber-1]->context, &AllThreads[0]->context);
        return;
    }

   
    for (int i = 0; i < 5; i++)
    {
        if (ThreadArray[i] != NULL)
        {   a=ThreadArray[i]->ioduration;
            //printf("\n chec öncesi %d %d \n",i,nocontext);
            
            if (a <1)
            {   returncheck=1;
                //printf("checkde");
                exitThread(ThreadArray[i]->ThreadIndex);
                return;
                
            }
            //printf("deneme %d ",ThreadArray[i]->ioduration );
            if((ThreadArray[i]->state) != IO){
            iocounter=1;
            }
        }

    }
    
    if(iocounter==0){
        //printf("print önce");
        printstate();
        while(looper){
            printf("\n");
        for (int j = 0; j < 5; j++){
            if(ThreadArray[j]!=NULL){
                if(ThreadArray[j]->state==IO){
                    if(ThreadArray[j]->ioduration==0){
                    //printf("\n exit %d\n ",ThreadArray[j]->ThreadIndex);
                        looper=0;
                        nocontext=1;
                        return;
                        #if PWF
                        PWF_Scheduler();
                        #else
                        SRTF_Scheduler();
                    #endif
                    return;
                    
                    
                    }
                    else
                    //printf("\n iodur %d \n",ThreadArray[j]->ioduration);
                    ThreadArray[j]->ioduration--;
                }
            }

        }
        
        sleep(1);




        }
        


    }


    
    //select the next thread to be runs
    SelectNextThread();
}

//https://www.geeksforgeeks.org/gcd-two-array-numbers/
// Function to return gcd of a and b


int main(int argc, char *argv[])
{
    //in order to get different runs
    srand((unsigned)time(NULL));
    TotalThreads = (argc-1)/2+1;

    if (TotalThreads == 1)
    {
        printf("Please give at least 1 thread.\n");
        return -1;
    }

    //check if the arguments are all integer
    for (int i = 1; i < argc; i++)
    {
        int len = strlen(argv[i]);
        for (int j = 0; j < len; j++)
        {
            if (argv[i][j] < '0' || argv[i][j] > '9')
            {
                printf("Please give arguments 0-9!\n");
                return -1;
            }
        }
    }

    errno = 0;
    int checkArg[argc];
    for (int i = 0; i < argc; i++)
    {
        checkArg[i] = strtol(argv[i], NULL, 10);
        if (errno != 0)
        {
            printf("Error related to arguments!\n");
            return -1;
        }
    }

    initializeThread();
    printf("TotalThreads :%d",TotalThreads);
    for (int i = 1; i < TotalThreads; i++){
        AllThreads[i]->duration = checkArg[i];
        AllThreads[i]->ioduration = checkArg[i+TotalThreads-1];
    }

    

    #if PWF
    signal(SIGALRM, PWF_Scheduler);
    #else
    signal(SIGALRM, SRTF_Scheduler);
    #endif
    
    //create 5 threads
    for (int i = 0; (i < 5) && (i<(TotalThreads-1)); i++)
    {
        int error = createThread();
        if (error == -1)
            printf("createThread error!\n");
    }

    

    printf("\n\nThreads:\n");
    for (int i = 1; i < TotalThreads; i++)
        printf("Thread%d\t",AllThreads[i]->ThreadIndex);
    printf("\n");

    int i;

    
    DoneFlag=1;
    #if PWF
    PWF_Scheduler();
    #else
    SRTF_Scheduler();
    #endif

    //this while loop will iterate until all of the threads are executed
    while(DoneThreadNumber != TotalThreads - 1)
    {  
        int error = createThread();
        //if (error == -1)
        //  printf("There is no waiting threads!\n");

        //find the next thread number
        //printf("\n mainde \n");
        maincheck=1;
        #if PWF
        PWF_Scheduler();
        #else
        SRTF_Scheduler();
        #endif
        
        
        
        
    }

    printf("running->\tready->\t\t\tfinished->");
    for (i = 1; i < TotalThreads-1; i++)
        printf("T%d,",AllThreads[i]->ThreadIndex);
    printf("T%d\n",AllThreads[i]->ThreadIndex);
    printf("All done!\n");
    freeAll();
    return 0;
}
