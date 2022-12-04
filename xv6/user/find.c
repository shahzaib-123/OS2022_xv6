#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

int compare(char*temp1, char*temp2){
  if (!*temp2) 
    return !*temp1;
  if (*(temp2+1)!='*') 
    if (*temp1==*temp2||(*temp2=='.'&&*temp1!='\0'))
      return compare(temp1+1,temp2+1);
    else 
      return 0; 
  else 
    if (*temp1==*temp2||(*temp2=='.'&&*temp1!='\0'))
      return compare(temp1,temp2+2)||compare(temp1+1,temp2);
    else 
      return compare(temp1,temp2+2); }

void find(int a,char *first,char *name) {
  char buff2[512];
  int x;
  struct dirent flag; //contains character pointer which points to a string that gives the name of a file in the directory. ends in NULL
  struct stat b; //system struct that is defined to store information about files. used in system calls like fstat,istat and stat
  
  while(read(a,&flag,sizeof(flag))==sizeof(flag)){// read func reads data previously written to a file. if any portion prior to eof has not been written read will return bytes with value 0
    if (strcmp(flag.name,".")==0||strcmp(flag.name,"..")== 0)
      continue;
// In below 6 lines basically concatenation is happening. WE have a pointer that we are moving. For example at first our pointer is at 0
//and we have an array, in which we add first of size 5 we increment pointer to +5 and then add / then again increment pointer. After 
//this we add buff2 and then again increment counter depending on size of buff2. end result we get separated by /. Thus we are traversing
//in directories within directories and files within files. whole tree will be printed in end and all those containing our find . (value)
    memcpy(buff2,first,strlen(first)); 
    char *counter=buff2+strlen(first);
    *counter++='/';
    memcpy(counter,flag.name,strlen(flag.name));
    counter=counter+strlen(flag.name);
    *counter++=0;
  
    if(flag.inum==0)
        continue;
//system struct that is defined to store information about files. used in system calls like fstat,istat and stat
//stat function gets status information about a specifies file and places it in area of memory pointed to by buf argument.
//Also returns information about the resulting file.
    if(stat(buff2,&b)<0){
        printf("Cannot find required data.. try again\n");
        continue;}
    if (b.type==T_FILE&&compare(flag.name,name)){
      printf("%s\n",buff2);
    } 
    else if (b.type == T_DIR) {
      if((x=open(buff2,0))<0){
        printf("cannot open required directory.. try again\n"); // buff2%s
        continue;
      }
      find(x,buff2,name); //calls recursively that is function within a function
    }}}
    
int main(int argc, char *argv[]){
  int a;
  struct stat b;//system struct that is defined to store information about files. used in system calls like fstat,istat and stat
  char directory[DIRSIZ+1],name[DIRSIZ+1];
  
  memcpy(name, argv[2], strlen(argv[2]));
  memcpy(directory, argv[1], strlen(argv[1]));
// fstat function gets status information about the object specified by open descriptor and stores information in area of memory indicated 
//by buffer argument. It is basically a system call that is used to determine information about a file based on its descriptor.
//in stat it is based on file name instead of file descriptor.
  if((a=open(directory,0))<0 || (fstat(a,&b) < 0)){
    printf("cannot open required directory.. try again\n");
    exit(1);
  }
  if (b.type!=T_DIR){
    printf("Error this is not a directory.. try again\n");
  } else{
    find(a, directory, name);
  }
  exit(0);}
