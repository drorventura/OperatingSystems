#define THREAD_QUANTA 5

/* Possible states of a thread; */
typedef enum  {T_FREE, T_RUNNING, T_RUNNABLE, T_SLEEPING} uthread_state;

#define STACK_SIZE  4096
#define MAX_THREAD  64

typedef struct uthread uthread_t, *uthread_p;

struct uthread {
	int				tid;
	int 	       	esp;        /* current stack pointer */
	int 	       	ebp;        /* current base pointer */
	void		   *stack;	    /* the thread's stack */
	uthread_state   state;     	/* running, runnable, sleeping */
	int             firstYield; /* a flag that notify if thread hasn't been switched before */
    int             semaphoreFlag; /* xchg while loop */
};

struct binary_semaphore
{
    int lock;
    int firstInLine, lastInLine;
    int numberOfThreads;
    uthread_p tQueue[MAX_THREAD];
};
 
int uthread_init(void);
int  uthread_create(void (*func)(void *), void* arg);
void uthread_exit(void);
void uthread_yield(void);
int  uthread_self(void);
int  uthread_join(int tid);

// ** Part 3 ** //
void binary_semaphore_init(struct binary_semaphore* semaphore, int value);
void binary_semaphore_down(struct binary_semaphore* semaphore);
void binary_semaphore_up(struct binary_semaphore* semaphore);
int addToQueue(struct binary_semaphore* semaphore, uthread_p thread);
uthread_p removeFromQueue(struct binary_semaphore* semaphore);

/* Macros of Extended Assembly */
#define LOAD_ESP(val)   asm ("movl %%esp, %0;" : "=r" ( val ))
#define LOAD_EBP(val)   asm ("movl %%ebp, %0;" : "=r" ( val ))
#define STORE_ESP(val)  asm ("movl %0, %%esp;" : : "r" ( val ))
#define STORE_EBP(val)  asm ("movl %0, %%ebp;" : : "r" ( val ))
#define PUSH_ALL        asm ("pushal;")
#define POP_ALL         asm ("popal;")
#define PUSH(val)       asm ("movl %0, %%edi; push %%edi;" : : "r" ( val ))
#define RET             asm ("ret;")
#define CALL(addr)      asm("call *%0;" : : "r" ( addr ))

