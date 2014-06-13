#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
  char name[100];
  int n;

  if((n = readlink("/1",name,100)) < 0)
    printf(2, "readlink failed: link does not exist\n");
  else
    printf(2, "Name is: %s | Name size %d\n", name, n);

  exit();
}
