#include "types.h"
#include "user.h"
#include "uthread.h"
#include "signal.h"
#include "x86.h"

static uthread_t tTable[MAX_THREAD];
static uthread_p currThread;

int nextTid = 1;

struct binary_semaphore
{
    int lock;
    int value;
    int firstInLine, LastInLine;
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
//    return;
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

int  uthread_join(int tid)
{
    return 0;
    //TODO
}