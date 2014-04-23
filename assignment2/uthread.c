#include "types.h"
#include "user.h"
#include "uthread.h"
//#include "spinlock.h"
#include "signal.h"

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
        tTable[i].state = T_FREE;
        tTable[i].firstYield = 0;
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
//    printf(2, "tid is: %d - in create \n",currThread->tid);
    int i;
//    uthread_p t = 0;

    for(i = 0 ; i < MAX_THREAD ; i++)
    {
//        printf(2,"return value of if cond : %d\n", tTable[i]->state == T_FREE);
//        printf(2,"state is: %d \n",tTable[i].state);
        if(tTable[i].state == T_FREE)
        {
//            t = tTable[i];
            if( !(tTable[i].stack = malloc(STACK_SIZE)) )
                return 0;

            tTable[i].tid = nextTid++;

            printf(2,"new thread: %d was allocate | with stack addr: %p | func addr: %p  \n",
                                                    tTable[i].tid,
                                                    tTable[i].stack,
                                                    func);

            tTable[i].esp = (int)tTable[i].stack + STACK_SIZE - 4;
            *(void**)tTable[i].esp = arg;

            tTable[i].esp -= 4;
            *(void**)tTable[i].esp = &uthread_exit;

            tTable[i].esp -= 4;
            *(void**)tTable[i].esp = func;

            tTable[i].ebp = (int)tTable[i].stack + STACK_SIZE;
            tTable[i].state = T_RUNNABLE;

            tTable[i].firstYield = 1;

            return tTable[i].tid;
        }
    }
    return 0;
}

void uthread_yield(void)
{
    printf(2, "tid is: %d - in yield \n",currThread->tid);
    int i;
//    uthread_p t;

    for(i = 0 ; i < MAX_THREAD ; i++)
    {
        if(tTable[i].state == T_RUNNABLE)
            break;
    }

    currThread->state = T_RUNNABLE;
//    PUSH_ALL;

    LOAD_ESP(currThread->esp);
    LOAD_EBP(currThread->ebp);

    currThread = &tTable[i];
    STORE_ESP(currThread->esp);
    STORE_EBP(currThread->ebp);


    if(currThread->firstYield)
    {
        printf(2,"in first yield of: %d\n", currThread->tid);
//        printf(2,"esp = %p\n",*(void**)currThread->esp);

//        signal(SIGALRM, uthreadSTORE_ESP(currThread->esp);_yield);
//        alarm(THREAD_QUANTA);


        currThread->firstYield = 0;
//        PUSH(*(void**)currThread->esp);
        RET;
    }
    else
    {
        printf(2,"not first yield of: %d\n", currThread->tid);
        POP_ALL;
    }
}

void
uthread_exit(void)
{
    int i;
    for(i = 0 ; i < MAX_THREAD ; i++)
    {
        if(tTable[i].tid == currThread->tid)
        {
            tTable[i].tid = 0;
            tTable[i].esp = 0;
            tTable[i].ebp = 0;
            tTable[i].stack = 0;
            tTable[i].state = T_FREE;
            tTable[i].firstYield = 0;
        }
    }
}

int uthread_self()
{
    return currThread->tid;
}