#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
    int pid;

	printf(1,"allocationg a value in parent\n",getpid());
	int* value = malloc(sizeof(int));
	*value = 99999;
	printf(1,"value's address: %p\n", value);
	printf(1,"value = %d\n",*value);

	printf(1,"Parent %d is forking a child using fork()\n",getpid());
	if (fork() == 0) {
		printf(1, "child %d value's address is: %p\n", getpid(), value);
		printf(1, "child %d is only sleeping, press ^p\n", getpid());
		sleep(500);
		/*goto done;*/
        exit();
	} 

    pid = wait();
    printf(1,"\nchild %d is dead, let's continue\n\n",pid);
    sleep(100);

    printf(1,"Parent %d is forking another child using cowfork()\n",getpid());
    if (cowfork() == 0) {
        printf(1, "child %d value's address is: %p\n", getpid(), value);
        printf(1, "child %d is only sleeping, press ^p\n", getpid());
        sleep(500);
        /*goto done;*/
        exit();
    }

    pid = wait();
    printf(1,"\nchild %d is dead, let's continue\n\n",pid);
    sleep(100);

    printf(1,"Parent %d is forking another child using cowfork()\n",getpid());
    if (cowfork() == 0) {
        printf(1, "child %d value's address is: %p\n", getpid(), value);
        *value = 11111;
        printf(1, "child %d changed the value, now value = %d\n", getpid(),*value);
        printf(1, "child %d value's address is: %p\n", getpid(), value);
        printf(1, "child %d is now sleeping, press ^p\n", getpid());
        sleep(500);
        /*goto done;*/
        exit();
    }

    pid = wait();

    printf(1,"\nchild %d is dead, let's continue\n",pid);
    printf(1,"******Parent %d is forking 2 childs using cowfork()******\n",getpid());

    if ((pid = cowfork()) == 0) {
        printf(1, "child %d value's address is: %p\n", getpid(), value);
        *value = 22222;
        printf(1, "child %d changed the value, now value = %d\n", getpid(),*value);
        printf(1, "child %d value's address is: %p\n", getpid(), value);
        while(1)
        {}
        exit();
    }
    if (cowfork() == 0) {

        printf(1, "child %d is now sleeping, press ^p\n", getpid());
        sleep(500);
        kill(pid);
        exit();
    } 
    printf(1,"\nparent %d is wating for nothing\n",pid);
    wait();
    wait();

    printf(1,"\nchild %d is dead, let's finish\n",pid);
    printf(1,"all kids are dead");
    sleep(200);

    exit();
}
