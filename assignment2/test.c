#include "uthread.h"
#include "types.h"
#include "stat.h"
#include "user.h"

void test(void *t);

int main(int argc,char** argv)
{
        uthread_init();

        printf(2,"test address: %p\n", test);
        int tid = uthread_create(test, (void *) 4);
        if (!tid)
                goto out_err;
        tid = uthread_create(test, (void *) 2);
        if (!tid)
                goto out_err;
   
    while (1)
    {
          printf(1,"thread father\n");
          sleep(60);
    }
        exit();
        out_err:
        printf(1,"Faild to create thread, we go bye bye\n");
        exit();
}

void test(void *t)
{
  int i = 0;
        while (i < 10)
        {
                printf(1,"thread child %p\n", t);
                i++;
                sleep(60);
        }

}