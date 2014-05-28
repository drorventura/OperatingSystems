#include "types.h"
#include "stat.h"
#include "param.h"
#include "uthread.h"
#include "user.h"

void testFunction(){
   printf(1, "printFunc\n");
}

int main (int argc, char** argv){
  testFunction();
  fork();
  wait();
  printf(1, "writing to text section started\n");
  *((int*)testFunction) = 15;
  printf(1, "writing to text section finished\n");
  testFunction();
  exit();
}
