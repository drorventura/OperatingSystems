#include "types.h"
#include "user.h"
#include "uthread.h"
#include "signal.h"
#include "x86.h"

#define true 1
#define false 0

static uthread_t tTable[MAX_THREAD];
static uthread_p currThread;

int nextTid = 1;

void initTable(void)
{
    int i;
    for(i = 0 ; i < MAX_THREAD ; i++)
    {
        tTable[i].tid = 0;
        tTable[i].esp = 0;
        tTable[i].ebp = 0;
        tTable[i].stack = 0;
        tTable[i].state = 0;
        tTable[i].firstYield = 0;
        tTable[i].semaphoreFlag = 0;
    }
}

int
uthread_init()
{
    initTable();

    tTable[0].tid = nextTid++;
    LOAD_ESP(tTable[0].esp);
    tTable[0].ebp = tTable[0].esp;
    tTable[0].stack = (void*)tTable[0].ebp;
    tTable[0].state = T_RUNNING;

    currThread = &tTable[0];

    signal(SIGALRM, uthread_yield);
    alarm(THREAD_QUANTA);

    return 0;
}

int uthread_create(void (*func)(void *), void* arg)
{
    int i;

    for(i = 0 ; i < MAX_THREAD ; i++)
    {
        if(tTable[i].state == 0 || T_FREE )
        {
            if( !(tTable[i].stack = malloc(STACK_SIZE)) )
                return 0;

            tTable[i].tid = nextTid++;

            tTable[i].ebp = (int)tTable[i].stack + STACK_SIZE;
            tTable[i].esp = tTable[i].ebp - 4;
            *(void**)tTable[i].esp = arg;

            tTable[i].esp -= 4;
            *(void**)tTable[i].esp = &uthread_exit;

            tTable[i].esp -= 4;
            *(void**)tTable[i].esp = func;

            tTable[i].state = T_RUNNABLE;

            signal(SIGALRM, uthread_yield);
            tTable[i].firstYield = 1;

            return tTable[i].tid;
        }
    }
    return 0;
}

int lastThreadIndex = 0;

// yield is unable to return to second round
void uthread_yield(void)
{
    int i = lastThreadIndex;

    if(returnToMainProgram())
        return;

    while(tTable[i].state != T_RUNNABLE)
    {
        i++;
        i = i % MAX_THREAD;
    }

    lastThreadIndex = i;
    currThread->state = T_RUNNABLE;

//    PUSH_ALL;
    LOAD_EBP(currThread->ebp);
    LOAD_ESP(currThread->esp);

    /********* switch thread *********/
    currThread = &tTable[i];
    /*********************************/

    currThread->state = T_RUNNING;

    if(currThread->firstYield)
    {
        currThread->firstYield = 0;

        alarm(THREAD_QUANTA);

        STORE_ESP(currThread->esp);
        RET;
    }
    else
    {
//       POP_ALL;
       switchContent();
    }
}

void
switchContent(void)
{
    STORE_EBP(currThread->ebp);
    STORE_ESP(currThread->esp);
    alarm(THREAD_QUANTA);
}

/**
 * a routine that determines rather there are no
 * more thread's to run
 */
int
returnToMainProgram(void)
{
    int i;

    for (i = 1 ; i < MAX_THREAD ; i++)
    {
        if(tTable[i].state != T_FREE || 0)
            return false;
    }

    return true;
}

void
uthread_exit(void)
{
    alarm(0);

    free(currThread->stack);
    currThread->state = T_FREE;
    currThread->tid = 0;

    currThread = &tTable[0];
    currThread->state = T_RUNNING;

    switchContent();
}

int uthread_self()
{
    return currThread->tid;
}

int uthread_join(int tid)
{
    int i;

    for (i=0 ; i < MAX_THREAD ; i++) {
     if (tTable[i].tid == tid)
         break;
    }

    if (i == MAX_THREAD)
     return true;

    alarm(0);
    while (tTable[i].state != T_FREE) {
        currThread->state = T_SLEEPING;
        alarm(1);
        sleep(2);
    }
    return true;
}

//  ***** Part 3 - semaphore impelmentaion ******* //
void
binary_semaphore_init(struct binary_semaphore* semaphore, int value)
{
   int i;
   semaphore->lock  = value;
   semaphore->firstInLine = 0;
   semaphore->lastInLine  = 0;
   semaphore->numberOfThreads  = 0;
   
    for(i=0 ; i < MAX_THREAD ; i++)
        semaphore->tQueue[i] = 0;
}

void
binary_semaphore_down(struct binary_semaphore* semaphore)
{
    /*if lock == 1 do lock == 0
      else thread.status == sleeping, alarm(0) , move to end of Queue.*/
    alarm(0);

    if (semaphore->lock == 1)
    {
        semaphore->lock--;
    }
    else
    {
        currThread->state = T_SLEEPING;
        if(!addToQueue(semaphore, currThread))
        {
            printf(1, "Thread %d wasn't inserted \n", currThread->tid);
        }
    }

    alarm(1);
    sleep(2);
}

void
binary_semaphore_up(struct binary_semaphore* semaphore)
{
    /*  release lock, lock = 1
        if Queue is not empty ->  wake up the next thread in Queue.
        exit.*/
    alarm(0);

    if (semaphore->numberOfThreads > 0)
    {
        uthread_p thread;

        if ((thread = removeFromQueue(semaphore)))
        {
            thread->state = T_RUNNABLE;
        }
        else
        {
            printf(2,"in Up() - unable to pull thread, reach MAX_THREAD limiti\n");
        }
    }
    else
    {
        semaphore->lock = 1;
    }

    alarm(1);
    sleep(2);
}

int 
addToQueue(struct binary_semaphore* semaphore, uthread_p thread)
{
    if (semaphore->numberOfThreads == MAX_THREAD)
    {
        return false;
    }
    else
    {
        int last = semaphore->lastInLine;
        semaphore->tQueue[last] = thread;
        semaphore->numberOfThreads++;
        last++;
        semaphore->lastInLine = last % MAX_THREAD;
        return true;
    }
}

uthread_p 
removeFromQueue(struct binary_semaphore* semaphore)
{
    if (semaphore->numberOfThreads < 0)
    {
        return false;
    }
    else
    {
        uthread_p t;
        int first = semaphore->firstInLine;
        t = semaphore->tQueue[first];

        semaphore->tQueue[first] = 0;
        semaphore->numberOfThreads--;

        first++;
        semaphore->firstInLine = first % MAX_THREAD;
        return t;
    }
}

//void
//printQueue(struct binary_semaphore* semaphore)
//{
//    int i = semaphore->numberOfThreads;
//    int j = 0;
//    int first = semaphore->firstInLine;
//
//    printf(1,"[");
//
//    for ( ; j < i ; j++)
//    {
//        printf(1,"%d, ",semaphore->tQueue[first]->tid);
//        first++;
//        first = first % MAX_THREAD;
//    }
//
//    printf(1,"] first = %d, last = %d \n",semaphore->firstInLine,semaphore->lastInLine);
//}
