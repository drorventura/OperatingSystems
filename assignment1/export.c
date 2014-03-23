#include "types.h"
#include "user.h"

#define NULL   0

int
main(int argc, char* argv[])
{
    if(argc < 2)
    {
        printf(1, "export: not enough arguments where given\n");
        exit();
    }
    char *path;
    int error = 0;

    path = strtok(argv[1], ':');

    error = add_path(path);
    if(error)
    {
        printf(1, "export: PATH evironment varialbe is full\n");
        exit();
    }

    while(path != NULL)
    {
        path = strtok(NULL, ':');
        if(path)
            error = add_path(path);
        if(error)
        {
        printf(1,"export: PATH evironment varialbe is full\n PATH = %s and the rest paths not included! \n",path);
            break;
        }
    }

    exit();
}
