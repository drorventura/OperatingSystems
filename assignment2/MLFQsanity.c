#include "types.h"
#include "stat.h"
#include "user.h"

#define N  500

int Fibonacci(int n);

    void
mlfqSanity()
{
    struct childData
    {
        int pid;
        int wTime;
        int rTime;
        int ioTime;
        int turnArroundTime;
    };

    struct childData childPid[20];

    int i,j,l,t=0;

    int AVGwTime = 0;
    int AVGrTime = 0;
    int AVGturnAroungTime = 0;

    int AVGwTimeG0 = 0;
    int AVGrTimeG0 = 0;
    int AVGturnAroungTimeG0 = 0;

    int AVGwTimeG1 = 0;
    int AVGrTimeG1 = 0;
    int AVGturnAroungTimeG1 = 0;


    for(i = 0 ; i < 20 ; i++)
    {
        if(!fork())
        {
            if (getpid() % 2 == 0){         // time-consuming
                Fibonacci(20);}

            else {if (getpid() % 2 == 1)    // I/O system call
                printf(2,"Calling I/O system call...\n");
            }

            // 500 printing for each child
            for(j = 0 ; j < N ; j++){
                printf(2, "child <%d> prints for the <%d> time\n", getpid(), j);
            }
            exit();
        }
    }

    // update to all children thire data
    while((childPid[t].pid = wait2( &(childPid[t].wTime),
                    &(childPid[t].rTime),
                    &(childPid[t].ioTime))) > 0)
    {
        // updating turnArroundTime for a child
        childPid[t].turnArroundTime =   childPid[t].wTime + 
            childPid[t].rTime + 
            childPid[t].ioTime;

        // updating Averege data to all Childrens
        AVGwTime            += childPid[t].wTime;
        AVGrTime            += childPid[t].rTime;
        AVGturnAroungTime   += childPid[t].turnArroundTime;

        // updating Averege data per % Group
        if(childPid[t].pid % 2 == 0)
        {
            AVGwTimeG0            += childPid[t].wTime;
            AVGrTimeG0            += childPid[t].rTime;
            AVGturnAroungTimeG0   += childPid[t].turnArroundTime;
        }
        else if (childPid[t].pid % 2 == 1)
        {
            AVGwTimeG1            += childPid[t].wTime;
            AVGrTimeG1            += childPid[t].rTime;
            AVGturnAroungTimeG1   += childPid[t].turnArroundTime;
        }
        t++;
    }


    printf(2,"____________________________________________________\n");
    printf(2, "\n *** Averege Time Of All My Childrens ***\n ");
    printf(2, " wTime: %d , rTime: %d , turnArroundTime: %d \n",
            AVGwTime/20,
            AVGrTime/20,
            AVGturnAroungTime/20);
    printf(2,"____________________________________________________\n");

    printf(2, "\n *** Averege Time By \% Group  *** \n");

    printf(2, "   ***   Group cid % 2 == 0      *** \n");
    printf(2, " wTime: %d , rTime: %d , turnArroundTime: %d \n",
            AVGwTimeG0/20, 
            AVGrTimeG0/20, 
            AVGturnAroungTimeG0/20);

    printf(2, "\n ***   Group cid % 2 == 1      *** \n");
    printf(2,"  wTime: %d , Averege rTime: %d , Averege turnArroundTime: %d.\n",
            AVGwTimeG1/20,
            AVGrTimeG1/20,
            (AVGturnAroungTime - AVGturnAroungTimeG0)/20);

    printf(2,"____________________________________________________\n");

    printf(2, "\n *** My childrens Data  ***\n ");
    for(l = 0 ; l < 20 ; l++)
    {
        printf(2,"%d) chlidPid: %d - waitTime: %d , runTime: %d , turnArroundTime: %d\n",
                l,
                childPid[l].pid,
                childPid[l].wTime,
                childPid[l].rTime,
                childPid[l].turnArroundTime);
    }
}

int Fibonacci(int n)
{
    if ( n == 0 )
        return 0;
    else if ( n == 1 )
        return 1;
    else
        return ( Fibonacci(n-1) + Fibonacci(n-2) );
} 

    int
main(void)
{
    mlfqSanity();
    exit();
} 
