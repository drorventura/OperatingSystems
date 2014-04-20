#include "types.h"
#include "stat.h"
#include "user.h"

void
foo()
{
    printf(2, "child is running \n");
    sleep(40);
    printf(2, "child is done!! \n");
}

void
sigtest(void)
{
  printf(1, "signal test\n");

    int pid = fork();
//    sigsend(getpid(),14);
    alarm(50);
    if(pid == 0)
    {
      foo();
//      sleep(100);
      exit();
    }
    wait();
    sleep(20);
    printf(1, "quiting... \n");

}
int
main(void)
{
  sigtest();
  exit();
}