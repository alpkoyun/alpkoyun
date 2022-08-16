#include <math.h>
#include <stdlib.h>
#include <stdio.h>
 int* DeskIDs;
 int* Tubeids; 
 int numberOftubes=3;


struct Information
{
    int tubeID;
    struct tube* mytube;
    int Molocule;
};

struct tube* createTubes();
void *destroytube(struct tube* tubes, int numberOftubes);// to destroy tube
void emptytube(struct tube* mtube);// to empty out the tube
void addAtom(struct tube* mtube, int atomtype,int atomid);// add atom to tube
double exponential(double lambda);

struct tube
{   int *atoms;
    int tubeID;
    int tubeTS;
    int Moleculetype;

};

struct Atom
{
    int AtomID;
    char AtomTYPE;
};

