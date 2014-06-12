#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int
main()
{
  char buf[512];
  int fd, /*i,*/ totalBytesWritten, done;

  fd = open("test1.file", O_CREATE | O_WRONLY);
  if(fd < 0){
    printf(2, "cannot open test1.file for writing\n");
    exit();
  }

  totalBytesWritten = 0;
  done = 0;
  //2048 sectors should be written

  while(!done){
    *(int*)buf = '#';
    int bytesWritten = write(fd, buf, sizeof(buf));
    if(bytesWritten <= 0)
      break;

//    printf(1, "\n Bytes Written: %d\n", bytesWritten);
    totalBytesWritten += bytesWritten;

	if (totalBytesWritten == 6144)
		printf(2, "Finished writing 6KB (direct)\n");

    if (totalBytesWritten == 71680)
		printf(2, "Finished writing 70KB (single indirect)\n");

    if (totalBytesWritten == 1048576){
		printf(2, "Finished writing 1MB\n");
		done = 1;
    }

    if (totalBytesWritten > 1048576) {
        printf(2, "Somthing went wrong! Quiting..");
        break;
    }
  }

  exit();
}
