#include "types.h"
#include "stat.h"
#include "user.h"

#define N  1000

void
frrSanity()
{
    int childPid[10];
    int wTime[10];
    int rTime[10];
    int ioTime[10];
    int i,j,k = 0;

    for(i = 0 ; i < 10 ; i++)
    {
        if(!fork())
        {
            for(j = 0 ; j < N ; j++)
            {
                printf(1, "child <%d> prints for the <%d> time\n", getpid(), j);
            }
            exit();
        }
    }
    while((childPid[k] = wait2(&wTime[k],&rTime[k],&ioTime[k])) > 0)
    {
        k++;
    }

    for(i = 0 ; i < 10 ; i++)
    {
        int turnArroundTime =  wTime[i] + rTime[i] + ioTime[i];
        printf(2, "chlidPid: %d - waitTime: %d , runTime: %d , turnArroundTime: %d\n",  childPid[i],
                                                                                        wTime[i],
                                                                                        rTime[i],
                                                                                        turnArroundTime);
    }
}

int
main(void)
{
  frrSanity();
  exit();
} 