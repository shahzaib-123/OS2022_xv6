#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int a = 1;

void test1()
{
    printf("%d free pages before forking\n",getNumFreePages());
    printf("Parent and Child share the global variable a \n");
    int pid = fork();
    if(pid==0)
    {
        printf("Child: a = %d\n",a);
        printf("%d free pages before any changes\n",getNumFreePages());
        a = 2;
        printf("Child: a = %d\n",a);
        printf("%d free pages after changing a\n",getNumFreePages());
        exit(1);
    }
    printf("Parent: a = %d\n",a);
    wait();
    printf("Parent: a = %d\n",a);
    printf("%d free pages after wait\n",getNumFreePages());
    return ;
}

void test2()
{
    printf("%d free pages before fork-1\n",getNumFreePages());
    if(fork()==0)
    {
        exit(1);
    }
    else
    {
        printf("%d free pages before fork-2\n",getNumFreePages());
        if(fork()==0)
        {
            printf("%d free pages before changes in Child-2\n",getNumFreePages());
            a = 5;
            printf("%d free pages after changes in Child-2\n",getNumFreePages());
            exit();
        }
        wait();
        printf("%d free pages after reaping Child-1\n",getNumFreePages());
    }
    wait();
    printf("%d free pages after reaping Child-2\n",getNumFreePages());
    return ;
}

void test3()
{
    printf("%d free pages before fork\n",getNumFreePages());
    int pid = fork();
    if(pid==0)
    {
        sleep(4);
        printf("%d free pages before changes in Child\n",getNumFreePages());
        a = 5;
        printf("%d free pages after changes in Child\n",getNumFreePages());
        exit(1);
    }
    printf("%d free pages before Parent exits\n",getNumFreePages());
    exit(1);
    return ;
}


int main(void)
{
    printf("Test1 running....\n");
    test1();
    printf("Test1 finished\n");
    printf("--------------------\n");
    printf("Test2 running....\n");
    test2();
    printf("Test2 finished\n");
    printf("--------------------\n");
    printf("Test3 running....\n");
    test3();
    printf("Test3 finished\n");
    exit();
}
