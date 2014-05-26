#include "types.h"
#include "stat.h"
#include "user.h"
#include "uthread.h"

#define Q 1
#define Z 2
#define P 3
#define M 4
#define R 5
#define F 6

void setCommand(void*);
void switchState(int index,int state, int left , int right);
void updateFiringSquad(void);
void printSquad(int squad);

int numberOfSoldiers;
struct binary_semaphore arrival;
struct binary_semaphore departure;
int *firingSquad;
int *tempFiringSquad;
int counter;


int main(int argc, char **argv)
{
    int i;
    numberOfSoldiers = atoi(argv[1]);

    uthread_init();
    binary_semaphore_init(&arrival  ,1);
    binary_semaphore_init(&departure,0);
    counter = 0;

    int mallocSize = numberOfSoldiers * sizeof(int);
    firingSquad     = malloc(mallocSize);
    tempFiringSquad = malloc(mallocSize);

    int soldierTid[numberOfSoldiers]; // join

    /* init firing Squad */
    firingSquad[0] = P;
    tempFiringSquad[0] = P;
    for (i=1 ; i < numberOfSoldiers ; i++) {
        firingSquad[i] = Q;
        tempFiringSquad[i] = Q;
    }

    printSquad(0);

    /* thread init */
    for (i = 0; i < numberOfSoldiers ; i++)
        soldierTid[i] = uthread_create(setCommand, (void*) i);

    /* join */
    for (i=0 ; i < numberOfSoldiers ; i++)
        uthread_join(soldierTid[i]);

    printf(1," after join for all \n");

    free(firingSquad);
    free(tempFiringSquad);
    exit(); // satisfy gcc
}

void setCommand(void* arg)
{
    int index = (int)arg;
    int left,right,state;

    while ( (state = firingSquad[index]) != F) {

//        state = firingSquad[index];

        binary_semaphore_down(&arrival);

        counter++;
//        printf(1,"tnumber = %d in \n",index);

        if (index == 0) {
           left = -1;
        } else{
            left = firingSquad[index-1];
        }

        if (index == numberOfSoldiers-1) {
            right = -1;
        } else {
            right = firingSquad[index+1];
        }

        switchState(index, state, left, right);

        if(counter < numberOfSoldiers) {
            binary_semaphore_up(&arrival);
        } else {
            updateFiringSquad();
            printSquad(1);
            binary_semaphore_up(&departure);
        }

        binary_semaphore_down(&departure);

//        printf(1,"tnumber = %d - AFTER \n",index);
        counter--;

        if (counter > 0) {
            binary_semaphore_up(&departure);
        } else {
            binary_semaphore_up(&arrival);
        }
    }
}

void 
switchState(int index,int state, int left , int right)
{
  switch (state) {
    case Q:
        if (left == Q && right == P)
            tempFiringSquad[index] = P;
        else if (left == P)
            tempFiringSquad[index] = P;
        else if (left == -1  && right == P)
            tempFiringSquad[index] = P;
    break;

    case Z:
        if (left == Q && (right == R || right == M))
            tempFiringSquad[index] = Q;
        else if (left == Q && right == Z)
            tempFiringSquad[index] = P;
        else if (left == R)
            tempFiringSquad[index] = Q;
        else if (left == Z && right == Q)
            tempFiringSquad[index] = P;
        else if (left == Z && (right == R || right == M))
            tempFiringSquad[index] = Q;
        else if (left == Z && (right == Z || right == -1))
            tempFiringSquad[index] = F;
        else if (left == M)
            tempFiringSquad[index] = Q;
        else if (left == -1 && (right == R || right == M))
            tempFiringSquad[index] = Q;
        else if (left == -1 && right == Z)
            tempFiringSquad[index] = F;
    break;

    case P:
        if (left == Q && (right == Q || right == P))
            tempFiringSquad[index] = Z;
        else if (left == Q && (right == R || right == Z))
            tempFiringSquad[index] = R;
        else if (left == P)
            tempFiringSquad[index] = Z;
        else if (left == R && right == Q)
            tempFiringSquad[index] = R;
        else if (left == R && (right == P || right == R || right == -1))
            tempFiringSquad[index] = Z;
        else if (left == Z && right == Q)
            tempFiringSquad[index] = R;
        else if (left == Z && (right == P || right == Z || right == -1))
            tempFiringSquad[index] = Z;
        else if (left == -1)
            tempFiringSquad[index] = Z;
    break;

    case M:
        if (left == R && right == R)
            tempFiringSquad[index] = R;
        else if (left == R && right == Z)
            tempFiringSquad[index] = Z;
        else if (left == Z && right == R)
            tempFiringSquad[index] = Z;
    break;

    case R:
        if (left == Q && right == Z)
            tempFiringSquad[index] = P;
        else if (left == Q && right == M)
            tempFiringSquad[index] = Z;
        else if (left == P && (right == R || right == M))
            tempFiringSquad[index] = M;
        else if (left == R && (right == P || right == M))
            tempFiringSquad[index] = M;
        else if (left == Z && right == Q)
            tempFiringSquad[index] = P;
        else if (left == Z && (right == P || right == M))
            tempFiringSquad[index] = R;
        else if (left == M && right == Q)
            tempFiringSquad[index] = Z;
        else if (left == M && right == Z)
            tempFiringSquad[index] = R;
        else if (left == M && (right == P || right == R || right == M))
            tempFiringSquad[index] = M;
    break;

    case F:
        break;

    default:
        printf(1,"bad case \n");
        break;
  }
}

void
updateFiringSquad(void)
{
    int i;
    for (i = 0 ; i < numberOfSoldiers ; i++)
        firingSquad[i] = tempFiringSquad[i];
}

void
printSquad(int squad)
{
//    alarm(0);
    int i;
    for (i = 0 ; i < numberOfSoldiers ; i++)
       printf(1,"%d ", squad ? tempFiringSquad[i] : firingSquad[i]);

    printf(1,"\n");
//    alarm(1);
}
