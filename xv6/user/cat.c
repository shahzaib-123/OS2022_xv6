#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

char buf[512];


void
ncat(int fd)
{
  int n;
  int counter=1;
  while((n = read(fd, buf, sizeof(buf))) > 0) {
    printf("%d\t",counter);
    for (int i=0;i<n;i++)
    { 
      printf("%c",buf[i]);
      if(buf[i]=='\n')
      {
        counter+=1;
        if(i<n-1)
        {
        printf("%d\t",counter);
        }
      }
    }
}
}

void
cat(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
    
    if (write(1, buf, n) != n) {
      fprintf(2, "cat: write error\n");
      exit(1);
    }
  }
  if(n < 0){
    fprintf(2, "cat: read error\n");
    exit(1);
  }
}

int
main(int argc, char *argv[])
{
  int flag=1;
  int fd, i;

  if(argc <= 1){
    cat(0);
    exit(0);
  }
  if(strcmp(argv[1],"-n")==0){
    flag+=1;
  }

  for(i = flag; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
      fprintf(2, "cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    if(flag==2)
    {
      ncat(fd);
    }
    else
    {
      cat(fd);
    }
    close(fd);
  }
  exit(0);
}
