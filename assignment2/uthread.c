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

struct binary_semaphore
{
    int lock;
    int firstInLine, lastInLine;
    int numberOfThreads;
    uthread_p tQueue[MAX_THREAD];

} binary_semaphore;

void initTable(void)
{
    int i;
    for(i = 0 ; i < MAX_THREAD ; i++)
    {
        tTable[i].tid = 0;
        tTable[i].esp = 0;
        tTable[i].ebp = 0;
        tTable[i].stack = 0;
        tTable[i].state = T_FREE;
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

    return 0;   // TODO check what do be need to return
}

int uthread_create(void (*func)(void *), void* arg)
{
    int i;
//    uthread_p t = 0;

    for(i = 0 ; i < MAX_THREAD ; i++)
    {
        if(tTable[i].state == T_FREE)
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
    int i;

    while(tTable[lastThreadIndex].state != T_RUNNABLE)
    {
        lastThreadIndex = (lastThreadIndex+1) % MAX_THREAD;
    }

    i = lastThreadIndex;

    currThread->state = T_RUNNABLE;

    PUSH_ALL;
    LOAD_EBP(currThread->ebp);
    LOAD_ESP(currThread->esp);

    /********* switch thread *********/
    currThread = &tTable[i];
    /*********************************/

    currThread->state = T_RUNNING;

    if(currThread->firstYield)
    {
        currThread->firstYield = 0;

        signal(SIGALRM, uthread_yield);
        alarm(THREAD_QUANTA);

        STORE_ESP(currThread->esp);
        RET;
    }
    else
    {
        POP_ALL;
        STORE_EBP(currThread->ebp);
        STORE_ESP(currThread->esp);

        signal(SIGALRM, uthread_yield);
        alarm(THREAD_QUANTA);
    }
}

void
uthread_exit(void)
{
    free(currThread->stack);
    currThread->state = T_FREE;

    sleep(100);
    RET;
}

int uthread_self()
{
    return currThread->tid;
}

// part 3 - semaphore impelmentaion
void
binary_semaphore_init(struct binary_semaphore* semaphore, int value)
{
   int i;
   semaphore->lock  = value;
   semaphore->firstInLine = 0;
   semaphore->LastInLine  = 0;
   semaphore->numberOfThreads  = 0;
   
    for(i=0 ; i < MAX_THREAD ; i++)
        semaphore->tQueue[i] = 0;
}

void
binary_semaphore_down(struct binary_semaphore* semaphore)
{

    /*if lock == 1 do lock == 0
      else thread.status == sleeping, alarm(0) , move to end of Queue.*/

    if (semaphore->lock == 0) {
        semaphore->lock = 1;
        return;
    } else {
        alarm(0);
        currThread->state = T_SLEEPING;
        semaphore->tQueue[semaphore->lastInLine] = currThread;
        semaphore->numberOfThreads++;
    }



    /*while(xchg(&semaphore->lock, 1) != 0)
    {
        if(!currThread->semaphoreFlag)
        {
            currThread->semaphoreFlag = 1;
            semaphore->tQueue[semaphore->LastInLine] = currThread;                  // add to queue
            semaphore->numberOfThreads++;
            semaphore->LastInLine = semaphore->LastInLine++ % MAX_THREAD;           // update index
            sigsend(currThread->tid, uthread_yield);  // call to yield
        }
    }
    
    return; */

    /*semaphore->lock--;
    uthread_p t = semaphore->tQueue[semaphore->firstInLine];

    if (t->tid == currThread->tid)
    {
        currThread->state = T_RUNNABLE;
        sigsend(t->tid, uthread_yield);
        semaphore->firstInLine = semaphore->firstInLine++ % MAX_THREAD;
        return;
    }
    else 
    {
        t->state = T_RUNNABLE;
        semaphore->lock++;
        sigsend(t->tid, uthread_yield);
        binary_semaphore_down(semaphore);
    }*/
}


void
binary_semaphore_up(struct binary_semaphore* semaphore)
{

        /*release lock, lock = 1 
        if Queue is not empty ->  wake up the next thread in Queue.
            exit.*/




    if (semaphore->numberOfThreads == 0)
    {
        semaphore->lock = 1;
        return;
    }
    else
    {
        uthread_p t = semaphore->tQueue[semaphore->firstInLine];

        t->state= T_RUNNABLE;
        sigsend(currThread->tid, uthread_yield);
    }
}


int 
addToQueue(struct binary_semaphore* semaphore, uthread_p thread)
{
    if (semaphore->numberOfThreads == MAX_THREAD) {
        return false;
    } else {
        semaphore->tQueue[semaphore->lastInLine] = thread;
        semaphore->numberOfThreads++;
        semaphore->lastInLine++;
        semaphore->lastInLine = semaphore->lastInLine % MAX_THREAD;
        return true;
    }
}

uthread_p 
removeFromQueue(struct binary_semaphore* semaphore, uthread_p thread)
{
    if (semaphore->numberOfThreads == 0) {
        return false;
    } else {
        uthread_p t;
        semaphore->numberOfThreads--;
        t = semaphore->tQueue[semaphore->firstInLine];
        semaphore->firstInLine++;
        semaphore->firstInLine = semaphore->firstInLine % MAX_THREAD;
        return t;
    }
}
