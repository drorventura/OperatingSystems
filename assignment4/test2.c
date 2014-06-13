#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

void
printError(int error) {
    switch(error) {
        case -1:
            printf(1,"faild: not enough arguments\n");
            break;
        case -2:
            printf(1,"faild: password is too long\n");
            break;
        case -3:
            printf(1,"faild: file does not exist\n");
            break;
        case -4:
            printf(1,"faild: file is in use by others\n");
            break;
        case -5:
            printf(1,"faild: password already has been set\n");
            break;
        case -6:
            printf(1,"faild: incorrect password\n");
            break;
    }
}

void
fprotTest(void) {
  int fd;
  int error;

  fd = open("test2.f", O_CREATE | O_WRONLY);

  if(fd < 0) {
    printf(2, "cannot open test2.file for writing\n");
    exit();
  }

  if(fork() == 0) {
    sleep(1000);
  } else {
      if( (error = fprot("test2.f", "1234")) < 0)
        printError(error);
      else


        printf(1,"Done, goodbye\n");
  }
}
void
funprotTest(void) {
//  int fd;
  int error;

  if( (error = fprot("ls", "1234")) < 0)
    printError(error);
  else {
//    if( (error = open("ls", O_WRONLY)) < 0)
//        printf(1,"error - %d\n",error);

    if( (error = funprot("ls", "1234")) < 0)
        printError(error);
  }
}

void
sanityTest(char * path, char * password) {
  int fd, error;
  char c;

  if( (error = fprot(path, password)) < 0)
      printError(error);

  if(fork() == 0) {
    // child unlock file
    if( (error = funlock(path, password)) < 0)
        printError(error);

    if( (fd = open(path, O_CREATE | O_RDONLY)) < 0)
        printf(1,"child faild to open file\n");

    printf(1, "************* FILE **************\n");
    while(1) {
        int bytesRead = read(fd,&c,1);
        if(bytesRead <= 0)
            break;
        printf(2, "%c",c);
    }

  } else {
    wait();

    printf(1,"In parent - After wait()\n");

    if( (fd = open(path, O_RDONLY)) < 0)
        printf(1,"parent faild to open file\n");

    if( (error = funprot(path, password)) < 0){
        printf(1,"parent faild to unprotect the file\n");
        printError(error);
    }
  }
}

int
main(int argc, char *argv[]) {
//  fprotTest();
//  funprotTest();

  if(argc != 3) {
    printf(1,"not enough params\n");
    exit();
  }

  char path[100];
  char password[10];

  strcpy(path, argv[1]);
  strcpy(password, argv[2]);

  sanityTest(path,password);

  printf(1,"After SanityTest\n");
  exit();
}
