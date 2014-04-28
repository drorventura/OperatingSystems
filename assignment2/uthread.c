#include "types.h"
#include "user.h"
#include "uthread.h"
//#include "spinlock.h"
#include "signal.h"

static uthread_t tTable[MAX_THREAD];
static uthread_p currThread;

int nextTid = 1;

struct binary_semaphore
{
    int lock;
    int value;
    int firstInLine, LastInLine;
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

    for(i = 1 ; i < MAX_THREAD ; i++)
    {
        if(tTable[i].state == T_RUNNABLE)
        {
            break;
        }
    }

    currThread->state = T_RUNNABLE;

    LOAD_ESP(currThread->esp);
    LOAD_EBP(currThread->ebp);
    
    currThread = &(tTable[i]);


    if(currThread->firstYield)
    {
        printf(2,"in first yield of: %d\n", currThread->tid);
//      printf(2,"esp = %p\n",*(void**)currThread->esp);
        
        signal(SIGALRM, uthread_yield);
        alarm(THREAD_QUANTA);
    
        STORE_ESP(currThread->esp);
        STORE_EBP(currThread->ebp);

        currThread->firstYield = 0;

        RET;

        /*CALL(*(void**)currThread->esp);*/
    }
    else
    {
        printf(2,"not first yield of: %d\n", currThread->tid);

        STORE_ESP(currThread->esp);
        STORE_EBP(currThread->ebp);
        CALL(*(void**)currThread->esp);
        /*POP_ALL;*/
        /*RET;*/
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

// part 3 - semaphore impelmentaion
void
binary_semaphore_init(struct binary_semaphore* semaphore, int value)
{
   int i;
   semaphore->value = value;
   semaphore->lock  = 1;
   semaphore->firstInLine = 0;
   semaphore->LastInLine  = 0;
   semaphore->numberOfThreads  = 0;
   
    for(i=0 ; i < MAX_THREAD ; i++)
        semaphore->tQueue[i] = 0;
}

void
binary_semaphore_down(struct binary_semaphore* semaphore)
{
    while(xchg(&semaphore->lock, 1) != 0)
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
    
    return; 

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

