#include "types.h"
#include "user.h"

#define WNOHANG 1

int main(int argc, char *argv[])
{

    int exitWait(void);
    int waitPid(void);

    printf(1, "\n This program tests the correctness of your lab#1\n");
	exitWait();
    if (atoi(argv[1]) == 1)
        exitWait();
    else
        printf(1, "\ntype \"lab1 1\" to test exit and wait, \"lab1 2\" to test waitpid and \"lab1 3\" to test the extra credit WNOHANG option \n");
exitS(0);
return 0;
}

int exitWait(void)
{
    int pid, ret_pid, exit_status;
    int i;
 printf(1, "\n  Parts a & b) testing exit(int status) and wait(int* status):\n");

    for (i = 0; i < 2; i++)
    {
        pid = fork();
        if (pid == 0)
        {
 if (i == 0)
            {
                printf(1, "\nThis is child with PID# %d and I will exit with status %d\n", getpid(), 0);
                exitS(0);
            }
            else
            {
                printf(1, "\nThis is child with PID# %d and I will exit with status %d\n", getpid(), -1);
                exitS(-1);
            }
        }
        else if (pid > 0)
        {
 ret_pid = wait(&exit_status);
            printf(1, "\n This is the parent: child with PID# %d has exited with status %d\n", ret_pid, exit_status);
        }
        else
 {
            printf(2, "\nError using fork\n");
            exitS(-1);
        }
    }
    return 0;
}

