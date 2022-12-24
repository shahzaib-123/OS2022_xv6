
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <compare>:
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

int compare(char*temp1, char*temp2){
  if (!*temp2) 
   0:	0005c783          	lbu	a5,0(a1)
   4:	cba9                	beqz	a5,56 <compare+0x56>
int compare(char*temp1, char*temp2){
   6:	1101                	addi	sp,sp,-32
   8:	ec06                	sd	ra,24(sp)
   a:	e822                	sd	s0,16(sp)
   c:	e426                	sd	s1,8(sp)
   e:	e04a                	sd	s2,0(sp)
  10:	1000                	addi	s0,sp,32
  12:	84ae                	mv	s1,a1
  14:	892a                	mv	s2,a0
    return !*temp1;
  if (*(temp2+1)!='*') 
  16:	0015c683          	lbu	a3,1(a1)
  1a:	02a00713          	li	a4,42
  1e:	04e68263          	beq	a3,a4,62 <compare+0x62>
    if (*temp1==*temp2||(*temp2=='.'&&*temp1!='\0'))
  22:	00054683          	lbu	a3,0(a0)
  26:	00d78863          	beq	a5,a3,36 <compare+0x36>
  2a:	02e00613          	li	a2,46
      return compare(temp1+1,temp2+1);
    else 
      return 0; 
  2e:	4701                	li	a4,0
    if (*temp1==*temp2||(*temp2=='.'&&*temp1!='\0'))
  30:	00c79c63          	bne	a5,a2,48 <compare+0x48>
  34:	ca91                	beqz	a3,48 <compare+0x48>
      return compare(temp1+1,temp2+1);
  36:	00148593          	addi	a1,s1,1
  3a:	00190513          	addi	a0,s2,1
  3e:	00000097          	auipc	ra,0x0
  42:	fc2080e7          	jalr	-62(ra) # 0 <compare>
  46:	872a                	mv	a4,a0
  else 
    if (*temp1==*temp2||(*temp2=='.'&&*temp1!='\0'))
      return compare(temp1,temp2+2)||compare(temp1+1,temp2);
    else 
      return compare(temp1,temp2+2); }
  48:	853a                	mv	a0,a4
  4a:	60e2                	ld	ra,24(sp)
  4c:	6442                	ld	s0,16(sp)
  4e:	64a2                	ld	s1,8(sp)
  50:	6902                	ld	s2,0(sp)
  52:	6105                	addi	sp,sp,32
  54:	8082                	ret
    return !*temp1;
  56:	00054703          	lbu	a4,0(a0)
  5a:	00173713          	seqz	a4,a4
      return compare(temp1,temp2+2); }
  5e:	853a                	mv	a0,a4
  60:	8082                	ret
    if (*temp1==*temp2||(*temp2=='.'&&*temp1!='\0'))
  62:	00054703          	lbu	a4,0(a0)
  66:	00e78763          	beq	a5,a4,74 <compare+0x74>
  6a:	02e00693          	li	a3,46
  6e:	02d79663          	bne	a5,a3,9a <compare+0x9a>
  72:	c705                	beqz	a4,9a <compare+0x9a>
      return compare(temp1,temp2+2)||compare(temp1+1,temp2);
  74:	00248593          	addi	a1,s1,2
  78:	854a                	mv	a0,s2
  7a:	00000097          	auipc	ra,0x0
  7e:	f86080e7          	jalr	-122(ra) # 0 <compare>
  82:	4705                	li	a4,1
  84:	f171                	bnez	a0,48 <compare+0x48>
  86:	85a6                	mv	a1,s1
  88:	00190513          	addi	a0,s2,1
  8c:	00000097          	auipc	ra,0x0
  90:	f74080e7          	jalr	-140(ra) # 0 <compare>
    return !*temp1;
  94:	00a03733          	snez	a4,a0
  98:	bf45                	j	48 <compare+0x48>
      return compare(temp1,temp2+2); }
  9a:	00248593          	addi	a1,s1,2
  9e:	854a                	mv	a0,s2
  a0:	00000097          	auipc	ra,0x0
  a4:	f60080e7          	jalr	-160(ra) # 0 <compare>
  a8:	872a                	mv	a4,a0
  aa:	bf79                	j	48 <compare+0x48>

00000000000000ac <find>:

void find(int a,char *first,char *name) {
  ac:	d7010113          	addi	sp,sp,-656
  b0:	28113423          	sd	ra,648(sp)
  b4:	28813023          	sd	s0,640(sp)
  b8:	26913c23          	sd	s1,632(sp)
  bc:	27213823          	sd	s2,624(sp)
  c0:	27313423          	sd	s3,616(sp)
  c4:	27413023          	sd	s4,608(sp)
  c8:	25513c23          	sd	s5,600(sp)
  cc:	25613823          	sd	s6,592(sp)
  d0:	25713423          	sd	s7,584(sp)
  d4:	25813023          	sd	s8,576(sp)
  d8:	23913c23          	sd	s9,568(sp)
  dc:	23a13823          	sd	s10,560(sp)
  e0:	0d00                	addi	s0,sp,656
  e2:	892a                	mv	s2,a0
  e4:	8b2e                	mv	s6,a1
  e6:	8d32                	mv	s10,a2
  int x;
  struct dirent flag; //contains character pointer which points to a string that gives the name of a file in the directory. ends in NULL
  struct stat b; //system struct that is defined to store information about files. used in system calls like fstat,istat and stat
  
  while(read(a,&flag,sizeof(flag))==sizeof(flag)){// read func reads data previously written to a file. if any portion prior to eof has not been written read will return bytes with value 0
    if (strcmp(flag.name,".")==0||strcmp(flag.name,"..")== 0)
  e8:	00001a17          	auipc	s4,0x1
  ec:	a18a0a13          	addi	s4,s4,-1512 # b00 <malloc+0xf4>
  f0:	d9240993          	addi	s3,s0,-622
  f4:	84ce                	mv	s1,s3
      continue;
// In below 6 lines basically concatenation is happening. WE have a pointer that we are moving. For example at first our pointer is at 0
//and we have an array, in which we add first of size 5 we increment pointer to +5 and then add / then again increment pointer. After 
//this we add buff2 and then again increment counter depending on size of buff2. end result we get separated by /. Thus we are traversing
//in directories within directories and files within files. whole tree will be printed in end and all those containing our find . (value)
    memcpy(buff2,first,strlen(first)); 
  f6:	da040c13          	addi	s8,s0,-608
    if (strcmp(flag.name,".")==0||strcmp(flag.name,"..")== 0)
  fa:	00001b97          	auipc	s7,0x1
  fe:	a0eb8b93          	addi	s7,s7,-1522 # b08 <malloc+0xfc>
    char *counter=buff2+strlen(first);
    *counter++='/';
 102:	02f00c93          	li	s9,47
  while(read(a,&flag,sizeof(flag))==sizeof(flag)){// read func reads data previously written to a file. if any portion prior to eof has not been written read will return bytes with value 0
 106:	4641                	li	a2,16
 108:	d9040593          	addi	a1,s0,-624
 10c:	854a                	mv	a0,s2
 10e:	00000097          	auipc	ra,0x0
 112:	4de080e7          	jalr	1246(ra) # 5ec <read>
 116:	47c1                	li	a5,16
 118:	10f51d63          	bne	a0,a5,232 <find+0x186>
    if (strcmp(flag.name,".")==0||strcmp(flag.name,"..")== 0)
 11c:	85d2                	mv	a1,s4
 11e:	8526                	mv	a0,s1
 120:	00000097          	auipc	ra,0x0
 124:	240080e7          	jalr	576(ra) # 360 <strcmp>
 128:	dd79                	beqz	a0,106 <find+0x5a>
 12a:	85de                	mv	a1,s7
 12c:	8526                	mv	a0,s1
 12e:	00000097          	auipc	ra,0x0
 132:	232080e7          	jalr	562(ra) # 360 <strcmp>
 136:	d961                	beqz	a0,106 <find+0x5a>
    memcpy(buff2,first,strlen(first)); 
 138:	855a                	mv	a0,s6
 13a:	00000097          	auipc	ra,0x0
 13e:	25a080e7          	jalr	602(ra) # 394 <strlen>
 142:	0005061b          	sext.w	a2,a0
 146:	85da                	mv	a1,s6
 148:	8562                	mv	a0,s8
 14a:	00000097          	auipc	ra,0x0
 14e:	46a080e7          	jalr	1130(ra) # 5b4 <memcpy>
    char *counter=buff2+strlen(first);
 152:	855a                	mv	a0,s6
 154:	00000097          	auipc	ra,0x0
 158:	240080e7          	jalr	576(ra) # 394 <strlen>
 15c:	1502                	slli	a0,a0,0x20
 15e:	9101                	srli	a0,a0,0x20
 160:	da040793          	addi	a5,s0,-608
 164:	953e                	add	a0,a0,a5
    *counter++='/';
 166:	00150a93          	addi	s5,a0,1
 16a:	01950023          	sb	s9,0(a0)
    memcpy(counter,flag.name,strlen(flag.name));
 16e:	854e                	mv	a0,s3
 170:	00000097          	auipc	ra,0x0
 174:	224080e7          	jalr	548(ra) # 394 <strlen>
 178:	0005061b          	sext.w	a2,a0
 17c:	85ce                	mv	a1,s3
 17e:	8556                	mv	a0,s5
 180:	00000097          	auipc	ra,0x0
 184:	434080e7          	jalr	1076(ra) # 5b4 <memcpy>
    counter=counter+strlen(flag.name);
 188:	854e                	mv	a0,s3
 18a:	00000097          	auipc	ra,0x0
 18e:	20a080e7          	jalr	522(ra) # 394 <strlen>
 192:	1502                	slli	a0,a0,0x20
 194:	9101                	srli	a0,a0,0x20
    *counter++=0;
 196:	9aaa                	add	s5,s5,a0
 198:	000a8023          	sb	zero,0(s5)
  
    if(flag.inum==0)
 19c:	d9045783          	lhu	a5,-624(s0)
 1a0:	d3bd                	beqz	a5,106 <find+0x5a>
        continue;
//system struct that is defined to store information about files. used in system calls like fstat,istat and stat
//stat function gets status information about a specifies file and places it in area of memory pointed to by buf argument.
//Also returns information about the resulting file.
    if(stat(buff2,&b)<0){
 1a2:	d7840593          	addi	a1,s0,-648
 1a6:	8562                	mv	a0,s8
 1a8:	00000097          	auipc	ra,0x0
 1ac:	2da080e7          	jalr	730(ra) # 482 <stat>
 1b0:	02054c63          	bltz	a0,1e8 <find+0x13c>
        printf("Cannot find required data.. try again\n");
        continue;}
    if (b.type==T_FILE&&compare(flag.name,name)){
 1b4:	d8041783          	lh	a5,-640(s0)
 1b8:	0007869b          	sext.w	a3,a5
 1bc:	4709                	li	a4,2
 1be:	02e68e63          	beq	a3,a4,1fa <find+0x14e>
      printf("%s\n",buff2);
    } 
    else if (b.type == T_DIR) {
 1c2:	2781                	sext.w	a5,a5
 1c4:	4705                	li	a4,1
 1c6:	f2e79ae3          	bne	a5,a4,fa <find+0x4e>
      if((x=open(buff2,0))<0){
 1ca:	4581                	li	a1,0
 1cc:	8562                	mv	a0,s8
 1ce:	00000097          	auipc	ra,0x0
 1d2:	446080e7          	jalr	1094(ra) # 614 <open>
 1d6:	04054563          	bltz	a0,220 <find+0x174>
        printf("cannot open required directory.. try again\n"); // buff2%s
        continue;
      }
      find(x,buff2,name); //calls recursively that is function within a function
 1da:	866a                	mv	a2,s10
 1dc:	85e2                	mv	a1,s8
 1de:	00000097          	auipc	ra,0x0
 1e2:	ece080e7          	jalr	-306(ra) # ac <find>
 1e6:	bf11                	j	fa <find+0x4e>
        printf("Cannot find required data.. try again\n");
 1e8:	00001517          	auipc	a0,0x1
 1ec:	92850513          	addi	a0,a0,-1752 # b10 <malloc+0x104>
 1f0:	00000097          	auipc	ra,0x0
 1f4:	75c080e7          	jalr	1884(ra) # 94c <printf>
        continue;}
 1f8:	b709                	j	fa <find+0x4e>
    if (b.type==T_FILE&&compare(flag.name,name)){
 1fa:	85ea                	mv	a1,s10
 1fc:	d9240513          	addi	a0,s0,-622
 200:	00000097          	auipc	ra,0x0
 204:	e00080e7          	jalr	-512(ra) # 0 <compare>
 208:	ee0509e3          	beqz	a0,fa <find+0x4e>
      printf("%s\n",buff2);
 20c:	85e2                	mv	a1,s8
 20e:	00001517          	auipc	a0,0x1
 212:	92a50513          	addi	a0,a0,-1750 # b38 <malloc+0x12c>
 216:	00000097          	auipc	ra,0x0
 21a:	736080e7          	jalr	1846(ra) # 94c <printf>
 21e:	bdf1                	j	fa <find+0x4e>
        printf("cannot open required directory.. try again\n"); // buff2%s
 220:	00001517          	auipc	a0,0x1
 224:	92050513          	addi	a0,a0,-1760 # b40 <malloc+0x134>
 228:	00000097          	auipc	ra,0x0
 22c:	724080e7          	jalr	1828(ra) # 94c <printf>
        continue;
 230:	b5e9                	j	fa <find+0x4e>
    }}}
 232:	28813083          	ld	ra,648(sp)
 236:	28013403          	ld	s0,640(sp)
 23a:	27813483          	ld	s1,632(sp)
 23e:	27013903          	ld	s2,624(sp)
 242:	26813983          	ld	s3,616(sp)
 246:	26013a03          	ld	s4,608(sp)
 24a:	25813a83          	ld	s5,600(sp)
 24e:	25013b03          	ld	s6,592(sp)
 252:	24813b83          	ld	s7,584(sp)
 256:	24013c03          	ld	s8,576(sp)
 25a:	23813c83          	ld	s9,568(sp)
 25e:	23013d03          	ld	s10,560(sp)
 262:	29010113          	addi	sp,sp,656
 266:	8082                	ret

0000000000000268 <main>:
    
int main(int argc, char *argv[]){
 268:	711d                	addi	sp,sp,-96
 26a:	ec86                	sd	ra,88(sp)
 26c:	e8a2                	sd	s0,80(sp)
 26e:	e4a6                	sd	s1,72(sp)
 270:	e0ca                	sd	s2,64(sp)
 272:	1080                	addi	s0,sp,96
 274:	84ae                	mv	s1,a1
  int a;
  struct stat b;//system struct that is defined to store information about files. used in system calls like fstat,istat and stat
  char directory[DIRSIZ+1],name[DIRSIZ+1];
  
  memcpy(name, argv[2], strlen(argv[2]));
 276:	0105b903          	ld	s2,16(a1)
 27a:	854a                	mv	a0,s2
 27c:	00000097          	auipc	ra,0x0
 280:	118080e7          	jalr	280(ra) # 394 <strlen>
 284:	0005061b          	sext.w	a2,a0
 288:	85ca                	mv	a1,s2
 28a:	fa840513          	addi	a0,s0,-88
 28e:	00000097          	auipc	ra,0x0
 292:	326080e7          	jalr	806(ra) # 5b4 <memcpy>
  memcpy(directory, argv[1], strlen(argv[1]));
 296:	6484                	ld	s1,8(s1)
 298:	8526                	mv	a0,s1
 29a:	00000097          	auipc	ra,0x0
 29e:	0fa080e7          	jalr	250(ra) # 394 <strlen>
 2a2:	0005061b          	sext.w	a2,a0
 2a6:	85a6                	mv	a1,s1
 2a8:	fb840513          	addi	a0,s0,-72
 2ac:	00000097          	auipc	ra,0x0
 2b0:	308080e7          	jalr	776(ra) # 5b4 <memcpy>
// fstat function gets status information about the object specified by open descriptor and stores information in area of memory indicated 
//by buffer argument. It is basically a system call that is used to determine information about a file based on its descriptor.
//in stat it is based on file name instead of file descriptor.
  if((a=open(directory,0))<0 || (fstat(a,&b) < 0)){
 2b4:	4581                	li	a1,0
 2b6:	fb840513          	addi	a0,s0,-72
 2ba:	00000097          	auipc	ra,0x0
 2be:	35a080e7          	jalr	858(ra) # 614 <open>
 2c2:	02054d63          	bltz	a0,2fc <main+0x94>
 2c6:	84aa                	mv	s1,a0
 2c8:	fc840593          	addi	a1,s0,-56
 2cc:	00000097          	auipc	ra,0x0
 2d0:	360080e7          	jalr	864(ra) # 62c <fstat>
 2d4:	02054463          	bltz	a0,2fc <main+0x94>
    printf("cannot open required directory.. try again\n");
    exit(1);
  }
  if (b.type!=T_DIR){
 2d8:	fd041703          	lh	a4,-48(s0)
 2dc:	4785                	li	a5,1
 2de:	02f70c63          	beq	a4,a5,316 <main+0xae>
    printf("Error this is not a directory.. try again\n");
 2e2:	00001517          	auipc	a0,0x1
 2e6:	88e50513          	addi	a0,a0,-1906 # b70 <malloc+0x164>
 2ea:	00000097          	auipc	ra,0x0
 2ee:	662080e7          	jalr	1634(ra) # 94c <printf>
  } else{
    find(a, directory, name);
  }
  exit(0);}
 2f2:	4501                	li	a0,0
 2f4:	00000097          	auipc	ra,0x0
 2f8:	2e0080e7          	jalr	736(ra) # 5d4 <exit>
    printf("cannot open required directory.. try again\n");
 2fc:	00001517          	auipc	a0,0x1
 300:	84450513          	addi	a0,a0,-1980 # b40 <malloc+0x134>
 304:	00000097          	auipc	ra,0x0
 308:	648080e7          	jalr	1608(ra) # 94c <printf>
    exit(1);
 30c:	4505                	li	a0,1
 30e:	00000097          	auipc	ra,0x0
 312:	2c6080e7          	jalr	710(ra) # 5d4 <exit>
    find(a, directory, name);
 316:	fa840613          	addi	a2,s0,-88
 31a:	fb840593          	addi	a1,s0,-72
 31e:	8526                	mv	a0,s1
 320:	00000097          	auipc	ra,0x0
 324:	d8c080e7          	jalr	-628(ra) # ac <find>
 328:	b7e9                	j	2f2 <main+0x8a>

000000000000032a <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 32a:	1141                	addi	sp,sp,-16
 32c:	e406                	sd	ra,8(sp)
 32e:	e022                	sd	s0,0(sp)
 330:	0800                	addi	s0,sp,16
  extern int main();
  main();
 332:	00000097          	auipc	ra,0x0
 336:	f36080e7          	jalr	-202(ra) # 268 <main>
  exit(0);
 33a:	4501                	li	a0,0
 33c:	00000097          	auipc	ra,0x0
 340:	298080e7          	jalr	664(ra) # 5d4 <exit>

0000000000000344 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 344:	1141                	addi	sp,sp,-16
 346:	e422                	sd	s0,8(sp)
 348:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 34a:	87aa                	mv	a5,a0
 34c:	0585                	addi	a1,a1,1
 34e:	0785                	addi	a5,a5,1
 350:	fff5c703          	lbu	a4,-1(a1)
 354:	fee78fa3          	sb	a4,-1(a5)
 358:	fb75                	bnez	a4,34c <strcpy+0x8>
    ;
  return os;
}
 35a:	6422                	ld	s0,8(sp)
 35c:	0141                	addi	sp,sp,16
 35e:	8082                	ret

0000000000000360 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 360:	1141                	addi	sp,sp,-16
 362:	e422                	sd	s0,8(sp)
 364:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 366:	00054783          	lbu	a5,0(a0)
 36a:	cf91                	beqz	a5,386 <strcmp+0x26>
 36c:	0005c703          	lbu	a4,0(a1)
 370:	00f71b63          	bne	a4,a5,386 <strcmp+0x26>
    p++, q++;
 374:	0505                	addi	a0,a0,1
 376:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 378:	00054783          	lbu	a5,0(a0)
 37c:	c789                	beqz	a5,386 <strcmp+0x26>
 37e:	0005c703          	lbu	a4,0(a1)
 382:	fef709e3          	beq	a4,a5,374 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 386:	0005c503          	lbu	a0,0(a1)
}
 38a:	40a7853b          	subw	a0,a5,a0
 38e:	6422                	ld	s0,8(sp)
 390:	0141                	addi	sp,sp,16
 392:	8082                	ret

0000000000000394 <strlen>:

uint
strlen(const char *s)
{
 394:	1141                	addi	sp,sp,-16
 396:	e422                	sd	s0,8(sp)
 398:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 39a:	00054783          	lbu	a5,0(a0)
 39e:	cf91                	beqz	a5,3ba <strlen+0x26>
 3a0:	0505                	addi	a0,a0,1
 3a2:	87aa                	mv	a5,a0
 3a4:	4685                	li	a3,1
 3a6:	9e89                	subw	a3,a3,a0
 3a8:	00f6853b          	addw	a0,a3,a5
 3ac:	0785                	addi	a5,a5,1
 3ae:	fff7c703          	lbu	a4,-1(a5)
 3b2:	fb7d                	bnez	a4,3a8 <strlen+0x14>
    ;
  return n;
}
 3b4:	6422                	ld	s0,8(sp)
 3b6:	0141                	addi	sp,sp,16
 3b8:	8082                	ret
  for(n = 0; s[n]; n++)
 3ba:	4501                	li	a0,0
 3bc:	bfe5                	j	3b4 <strlen+0x20>

00000000000003be <memset>:

void*
memset(void *dst, int c, uint n)
{
 3be:	1141                	addi	sp,sp,-16
 3c0:	e422                	sd	s0,8(sp)
 3c2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 3c4:	ce09                	beqz	a2,3de <memset+0x20>
 3c6:	87aa                	mv	a5,a0
 3c8:	fff6071b          	addiw	a4,a2,-1
 3cc:	1702                	slli	a4,a4,0x20
 3ce:	9301                	srli	a4,a4,0x20
 3d0:	0705                	addi	a4,a4,1
 3d2:	972a                	add	a4,a4,a0
    cdst[i] = c;
 3d4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 3d8:	0785                	addi	a5,a5,1
 3da:	fee79de3          	bne	a5,a4,3d4 <memset+0x16>
  }
  return dst;
}
 3de:	6422                	ld	s0,8(sp)
 3e0:	0141                	addi	sp,sp,16
 3e2:	8082                	ret

00000000000003e4 <strchr>:

char*
strchr(const char *s, char c)
{
 3e4:	1141                	addi	sp,sp,-16
 3e6:	e422                	sd	s0,8(sp)
 3e8:	0800                	addi	s0,sp,16
  for(; *s; s++)
 3ea:	00054783          	lbu	a5,0(a0)
 3ee:	cf91                	beqz	a5,40a <strchr+0x26>
    if(*s == c)
 3f0:	00f58a63          	beq	a1,a5,404 <strchr+0x20>
  for(; *s; s++)
 3f4:	0505                	addi	a0,a0,1
 3f6:	00054783          	lbu	a5,0(a0)
 3fa:	c781                	beqz	a5,402 <strchr+0x1e>
    if(*s == c)
 3fc:	feb79ce3          	bne	a5,a1,3f4 <strchr+0x10>
 400:	a011                	j	404 <strchr+0x20>
      return (char*)s;
  return 0;
 402:	4501                	li	a0,0
}
 404:	6422                	ld	s0,8(sp)
 406:	0141                	addi	sp,sp,16
 408:	8082                	ret
  return 0;
 40a:	4501                	li	a0,0
 40c:	bfe5                	j	404 <strchr+0x20>

000000000000040e <gets>:

char*
gets(char *buf, int max)
{
 40e:	711d                	addi	sp,sp,-96
 410:	ec86                	sd	ra,88(sp)
 412:	e8a2                	sd	s0,80(sp)
 414:	e4a6                	sd	s1,72(sp)
 416:	e0ca                	sd	s2,64(sp)
 418:	fc4e                	sd	s3,56(sp)
 41a:	f852                	sd	s4,48(sp)
 41c:	f456                	sd	s5,40(sp)
 41e:	f05a                	sd	s6,32(sp)
 420:	ec5e                	sd	s7,24(sp)
 422:	1080                	addi	s0,sp,96
 424:	8baa                	mv	s7,a0
 426:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 428:	892a                	mv	s2,a0
 42a:	4981                	li	s3,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 42c:	4aa9                	li	s5,10
 42e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 430:	0019849b          	addiw	s1,s3,1
 434:	0344d863          	bge	s1,s4,464 <gets+0x56>
    cc = read(0, &c, 1);
 438:	4605                	li	a2,1
 43a:	faf40593          	addi	a1,s0,-81
 43e:	4501                	li	a0,0
 440:	00000097          	auipc	ra,0x0
 444:	1ac080e7          	jalr	428(ra) # 5ec <read>
    if(cc < 1)
 448:	00a05e63          	blez	a0,464 <gets+0x56>
    buf[i++] = c;
 44c:	faf44783          	lbu	a5,-81(s0)
 450:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 454:	01578763          	beq	a5,s5,462 <gets+0x54>
 458:	0905                	addi	s2,s2,1
  for(i=0; i+1 < max; ){
 45a:	89a6                	mv	s3,s1
    if(c == '\n' || c == '\r')
 45c:	fd679ae3          	bne	a5,s6,430 <gets+0x22>
 460:	a011                	j	464 <gets+0x56>
  for(i=0; i+1 < max; ){
 462:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 464:	99de                	add	s3,s3,s7
 466:	00098023          	sb	zero,0(s3)
  return buf;
}
 46a:	855e                	mv	a0,s7
 46c:	60e6                	ld	ra,88(sp)
 46e:	6446                	ld	s0,80(sp)
 470:	64a6                	ld	s1,72(sp)
 472:	6906                	ld	s2,64(sp)
 474:	79e2                	ld	s3,56(sp)
 476:	7a42                	ld	s4,48(sp)
 478:	7aa2                	ld	s5,40(sp)
 47a:	7b02                	ld	s6,32(sp)
 47c:	6be2                	ld	s7,24(sp)
 47e:	6125                	addi	sp,sp,96
 480:	8082                	ret

0000000000000482 <stat>:

int
stat(const char *n, struct stat *st)
{
 482:	1101                	addi	sp,sp,-32
 484:	ec06                	sd	ra,24(sp)
 486:	e822                	sd	s0,16(sp)
 488:	e426                	sd	s1,8(sp)
 48a:	e04a                	sd	s2,0(sp)
 48c:	1000                	addi	s0,sp,32
 48e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 490:	4581                	li	a1,0
 492:	00000097          	auipc	ra,0x0
 496:	182080e7          	jalr	386(ra) # 614 <open>
  if(fd < 0)
 49a:	02054563          	bltz	a0,4c4 <stat+0x42>
 49e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 4a0:	85ca                	mv	a1,s2
 4a2:	00000097          	auipc	ra,0x0
 4a6:	18a080e7          	jalr	394(ra) # 62c <fstat>
 4aa:	892a                	mv	s2,a0
  close(fd);
 4ac:	8526                	mv	a0,s1
 4ae:	00000097          	auipc	ra,0x0
 4b2:	14e080e7          	jalr	334(ra) # 5fc <close>
  return r;
}
 4b6:	854a                	mv	a0,s2
 4b8:	60e2                	ld	ra,24(sp)
 4ba:	6442                	ld	s0,16(sp)
 4bc:	64a2                	ld	s1,8(sp)
 4be:	6902                	ld	s2,0(sp)
 4c0:	6105                	addi	sp,sp,32
 4c2:	8082                	ret
    return -1;
 4c4:	597d                	li	s2,-1
 4c6:	bfc5                	j	4b6 <stat+0x34>

00000000000004c8 <atoi>:

int
atoi(const char *s)
{
 4c8:	1141                	addi	sp,sp,-16
 4ca:	e422                	sd	s0,8(sp)
 4cc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4ce:	00054683          	lbu	a3,0(a0)
 4d2:	fd06879b          	addiw	a5,a3,-48
 4d6:	0ff7f793          	andi	a5,a5,255
 4da:	4725                	li	a4,9
 4dc:	02f76963          	bltu	a4,a5,50e <atoi+0x46>
 4e0:	862a                	mv	a2,a0
  n = 0;
 4e2:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 4e4:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 4e6:	0605                	addi	a2,a2,1
 4e8:	0025179b          	slliw	a5,a0,0x2
 4ec:	9fa9                	addw	a5,a5,a0
 4ee:	0017979b          	slliw	a5,a5,0x1
 4f2:	9fb5                	addw	a5,a5,a3
 4f4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 4f8:	00064683          	lbu	a3,0(a2)
 4fc:	fd06871b          	addiw	a4,a3,-48
 500:	0ff77713          	andi	a4,a4,255
 504:	fee5f1e3          	bgeu	a1,a4,4e6 <atoi+0x1e>
  return n;
}
 508:	6422                	ld	s0,8(sp)
 50a:	0141                	addi	sp,sp,16
 50c:	8082                	ret
  n = 0;
 50e:	4501                	li	a0,0
 510:	bfe5                	j	508 <atoi+0x40>

0000000000000512 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 512:	1141                	addi	sp,sp,-16
 514:	e422                	sd	s0,8(sp)
 516:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 518:	02b57663          	bgeu	a0,a1,544 <memmove+0x32>
    while(n-- > 0)
 51c:	02c05163          	blez	a2,53e <memmove+0x2c>
 520:	fff6079b          	addiw	a5,a2,-1
 524:	1782                	slli	a5,a5,0x20
 526:	9381                	srli	a5,a5,0x20
 528:	0785                	addi	a5,a5,1
 52a:	97aa                	add	a5,a5,a0
  dst = vdst;
 52c:	872a                	mv	a4,a0
      *dst++ = *src++;
 52e:	0585                	addi	a1,a1,1
 530:	0705                	addi	a4,a4,1
 532:	fff5c683          	lbu	a3,-1(a1)
 536:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 53a:	fee79ae3          	bne	a5,a4,52e <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 53e:	6422                	ld	s0,8(sp)
 540:	0141                	addi	sp,sp,16
 542:	8082                	ret
    dst += n;
 544:	00c50733          	add	a4,a0,a2
    src += n;
 548:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 54a:	fec05ae3          	blez	a2,53e <memmove+0x2c>
 54e:	fff6079b          	addiw	a5,a2,-1
 552:	1782                	slli	a5,a5,0x20
 554:	9381                	srli	a5,a5,0x20
 556:	fff7c793          	not	a5,a5
 55a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 55c:	15fd                	addi	a1,a1,-1
 55e:	177d                	addi	a4,a4,-1
 560:	0005c683          	lbu	a3,0(a1)
 564:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 568:	fef71ae3          	bne	a4,a5,55c <memmove+0x4a>
 56c:	bfc9                	j	53e <memmove+0x2c>

000000000000056e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 56e:	1141                	addi	sp,sp,-16
 570:	e422                	sd	s0,8(sp)
 572:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 574:	ce15                	beqz	a2,5b0 <memcmp+0x42>
 576:	fff6069b          	addiw	a3,a2,-1
    if (*p1 != *p2) {
 57a:	00054783          	lbu	a5,0(a0)
 57e:	0005c703          	lbu	a4,0(a1)
 582:	02e79063          	bne	a5,a4,5a2 <memcmp+0x34>
 586:	1682                	slli	a3,a3,0x20
 588:	9281                	srli	a3,a3,0x20
 58a:	0685                	addi	a3,a3,1
 58c:	96aa                	add	a3,a3,a0
      return *p1 - *p2;
    }
    p1++;
 58e:	0505                	addi	a0,a0,1
    p2++;
 590:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 592:	00d50d63          	beq	a0,a3,5ac <memcmp+0x3e>
    if (*p1 != *p2) {
 596:	00054783          	lbu	a5,0(a0)
 59a:	0005c703          	lbu	a4,0(a1)
 59e:	fee788e3          	beq	a5,a4,58e <memcmp+0x20>
      return *p1 - *p2;
 5a2:	40e7853b          	subw	a0,a5,a4
  }
  return 0;
}
 5a6:	6422                	ld	s0,8(sp)
 5a8:	0141                	addi	sp,sp,16
 5aa:	8082                	ret
  return 0;
 5ac:	4501                	li	a0,0
 5ae:	bfe5                	j	5a6 <memcmp+0x38>
 5b0:	4501                	li	a0,0
 5b2:	bfd5                	j	5a6 <memcmp+0x38>

00000000000005b4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 5b4:	1141                	addi	sp,sp,-16
 5b6:	e406                	sd	ra,8(sp)
 5b8:	e022                	sd	s0,0(sp)
 5ba:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 5bc:	00000097          	auipc	ra,0x0
 5c0:	f56080e7          	jalr	-170(ra) # 512 <memmove>
}
 5c4:	60a2                	ld	ra,8(sp)
 5c6:	6402                	ld	s0,0(sp)
 5c8:	0141                	addi	sp,sp,16
 5ca:	8082                	ret

00000000000005cc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 5cc:	4885                	li	a7,1
 ecall
 5ce:	00000073          	ecall
 ret
 5d2:	8082                	ret

00000000000005d4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 5d4:	4889                	li	a7,2
 ecall
 5d6:	00000073          	ecall
 ret
 5da:	8082                	ret

00000000000005dc <wait>:
.global wait
wait:
 li a7, SYS_wait
 5dc:	488d                	li	a7,3
 ecall
 5de:	00000073          	ecall
 ret
 5e2:	8082                	ret

00000000000005e4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 5e4:	4891                	li	a7,4
 ecall
 5e6:	00000073          	ecall
 ret
 5ea:	8082                	ret

00000000000005ec <read>:
.global read
read:
 li a7, SYS_read
 5ec:	4895                	li	a7,5
 ecall
 5ee:	00000073          	ecall
 ret
 5f2:	8082                	ret

00000000000005f4 <write>:
.global write
write:
 li a7, SYS_write
 5f4:	48c1                	li	a7,16
 ecall
 5f6:	00000073          	ecall
 ret
 5fa:	8082                	ret

00000000000005fc <close>:
.global close
close:
 li a7, SYS_close
 5fc:	48d5                	li	a7,21
 ecall
 5fe:	00000073          	ecall
 ret
 602:	8082                	ret

0000000000000604 <kill>:
.global kill
kill:
 li a7, SYS_kill
 604:	4899                	li	a7,6
 ecall
 606:	00000073          	ecall
 ret
 60a:	8082                	ret

000000000000060c <exec>:
.global exec
exec:
 li a7, SYS_exec
 60c:	489d                	li	a7,7
 ecall
 60e:	00000073          	ecall
 ret
 612:	8082                	ret

0000000000000614 <open>:
.global open
open:
 li a7, SYS_open
 614:	48bd                	li	a7,15
 ecall
 616:	00000073          	ecall
 ret
 61a:	8082                	ret

000000000000061c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 61c:	48c5                	li	a7,17
 ecall
 61e:	00000073          	ecall
 ret
 622:	8082                	ret

0000000000000624 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 624:	48c9                	li	a7,18
 ecall
 626:	00000073          	ecall
 ret
 62a:	8082                	ret

000000000000062c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 62c:	48a1                	li	a7,8
 ecall
 62e:	00000073          	ecall
 ret
 632:	8082                	ret

0000000000000634 <link>:
.global link
link:
 li a7, SYS_link
 634:	48cd                	li	a7,19
 ecall
 636:	00000073          	ecall
 ret
 63a:	8082                	ret

000000000000063c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 63c:	48d1                	li	a7,20
 ecall
 63e:	00000073          	ecall
 ret
 642:	8082                	ret

0000000000000644 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 644:	48a5                	li	a7,9
 ecall
 646:	00000073          	ecall
 ret
 64a:	8082                	ret

000000000000064c <dup>:
.global dup
dup:
 li a7, SYS_dup
 64c:	48a9                	li	a7,10
 ecall
 64e:	00000073          	ecall
 ret
 652:	8082                	ret

0000000000000654 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 654:	48ad                	li	a7,11
 ecall
 656:	00000073          	ecall
 ret
 65a:	8082                	ret

000000000000065c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 65c:	48b1                	li	a7,12
 ecall
 65e:	00000073          	ecall
 ret
 662:	8082                	ret

0000000000000664 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 664:	48b5                	li	a7,13
 ecall
 666:	00000073          	ecall
 ret
 66a:	8082                	ret

000000000000066c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 66c:	48b9                	li	a7,14
 ecall
 66e:	00000073          	ecall
 ret
 672:	8082                	ret

0000000000000674 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 674:	1101                	addi	sp,sp,-32
 676:	ec06                	sd	ra,24(sp)
 678:	e822                	sd	s0,16(sp)
 67a:	1000                	addi	s0,sp,32
 67c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 680:	4605                	li	a2,1
 682:	fef40593          	addi	a1,s0,-17
 686:	00000097          	auipc	ra,0x0
 68a:	f6e080e7          	jalr	-146(ra) # 5f4 <write>
}
 68e:	60e2                	ld	ra,24(sp)
 690:	6442                	ld	s0,16(sp)
 692:	6105                	addi	sp,sp,32
 694:	8082                	ret

0000000000000696 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 696:	7139                	addi	sp,sp,-64
 698:	fc06                	sd	ra,56(sp)
 69a:	f822                	sd	s0,48(sp)
 69c:	f426                	sd	s1,40(sp)
 69e:	f04a                	sd	s2,32(sp)
 6a0:	ec4e                	sd	s3,24(sp)
 6a2:	0080                	addi	s0,sp,64
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 6a4:	c299                	beqz	a3,6aa <printint+0x14>
 6a6:	0005cd63          	bltz	a1,6c0 <printint+0x2a>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 6aa:	2581                	sext.w	a1,a1
  neg = 0;
 6ac:	4301                	li	t1,0
 6ae:	fc040713          	addi	a4,s0,-64
  }

  i = 0;
 6b2:	4801                	li	a6,0
  do{
    buf[i++] = digits[x % base];
 6b4:	2601                	sext.w	a2,a2
 6b6:	00000897          	auipc	a7,0x0
 6ba:	4ea88893          	addi	a7,a7,1258 # ba0 <digits>
 6be:	a801                	j	6ce <printint+0x38>
    x = -xx;
 6c0:	40b005bb          	negw	a1,a1
 6c4:	2581                	sext.w	a1,a1
    neg = 1;
 6c6:	4305                	li	t1,1
    x = -xx;
 6c8:	b7dd                	j	6ae <printint+0x18>
  }while((x /= base) != 0);
 6ca:	85be                	mv	a1,a5
    buf[i++] = digits[x % base];
 6cc:	8836                	mv	a6,a3
 6ce:	0018069b          	addiw	a3,a6,1
 6d2:	02c5f7bb          	remuw	a5,a1,a2
 6d6:	1782                	slli	a5,a5,0x20
 6d8:	9381                	srli	a5,a5,0x20
 6da:	97c6                	add	a5,a5,a7
 6dc:	0007c783          	lbu	a5,0(a5)
 6e0:	00f70023          	sb	a5,0(a4)
  }while((x /= base) != 0);
 6e4:	0705                	addi	a4,a4,1
 6e6:	02c5d7bb          	divuw	a5,a1,a2
 6ea:	fec5f0e3          	bgeu	a1,a2,6ca <printint+0x34>
  if(neg)
 6ee:	00030b63          	beqz	t1,704 <printint+0x6e>
    buf[i++] = '-';
 6f2:	fd040793          	addi	a5,s0,-48
 6f6:	96be                	add	a3,a3,a5
 6f8:	02d00793          	li	a5,45
 6fc:	fef68823          	sb	a5,-16(a3)
 700:	0028069b          	addiw	a3,a6,2

  while(--i >= 0)
 704:	02d05963          	blez	a3,736 <printint+0xa0>
 708:	89aa                	mv	s3,a0
 70a:	fc040793          	addi	a5,s0,-64
 70e:	00d784b3          	add	s1,a5,a3
 712:	fff78913          	addi	s2,a5,-1
 716:	9936                	add	s2,s2,a3
 718:	36fd                	addiw	a3,a3,-1
 71a:	1682                	slli	a3,a3,0x20
 71c:	9281                	srli	a3,a3,0x20
 71e:	40d90933          	sub	s2,s2,a3
    putc(fd, buf[i]);
 722:	fff4c583          	lbu	a1,-1(s1)
 726:	854e                	mv	a0,s3
 728:	00000097          	auipc	ra,0x0
 72c:	f4c080e7          	jalr	-180(ra) # 674 <putc>
  while(--i >= 0)
 730:	14fd                	addi	s1,s1,-1
 732:	ff2498e3          	bne	s1,s2,722 <printint+0x8c>
}
 736:	70e2                	ld	ra,56(sp)
 738:	7442                	ld	s0,48(sp)
 73a:	74a2                	ld	s1,40(sp)
 73c:	7902                	ld	s2,32(sp)
 73e:	69e2                	ld	s3,24(sp)
 740:	6121                	addi	sp,sp,64
 742:	8082                	ret

0000000000000744 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 744:	7119                	addi	sp,sp,-128
 746:	fc86                	sd	ra,120(sp)
 748:	f8a2                	sd	s0,112(sp)
 74a:	f4a6                	sd	s1,104(sp)
 74c:	f0ca                	sd	s2,96(sp)
 74e:	ecce                	sd	s3,88(sp)
 750:	e8d2                	sd	s4,80(sp)
 752:	e4d6                	sd	s5,72(sp)
 754:	e0da                	sd	s6,64(sp)
 756:	fc5e                	sd	s7,56(sp)
 758:	f862                	sd	s8,48(sp)
 75a:	f466                	sd	s9,40(sp)
 75c:	f06a                	sd	s10,32(sp)
 75e:	ec6e                	sd	s11,24(sp)
 760:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 762:	0005c483          	lbu	s1,0(a1)
 766:	18048d63          	beqz	s1,900 <vprintf+0x1bc>
 76a:	8aaa                	mv	s5,a0
 76c:	8b32                	mv	s6,a2
 76e:	00158913          	addi	s2,a1,1
  state = 0;
 772:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 774:	02500a13          	li	s4,37
      if(c == 'd'){
 778:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 77c:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 780:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 784:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 788:	00000b97          	auipc	s7,0x0
 78c:	418b8b93          	addi	s7,s7,1048 # ba0 <digits>
 790:	a839                	j	7ae <vprintf+0x6a>
        putc(fd, c);
 792:	85a6                	mv	a1,s1
 794:	8556                	mv	a0,s5
 796:	00000097          	auipc	ra,0x0
 79a:	ede080e7          	jalr	-290(ra) # 674 <putc>
 79e:	a019                	j	7a4 <vprintf+0x60>
    } else if(state == '%'){
 7a0:	01498f63          	beq	s3,s4,7be <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 7a4:	0905                	addi	s2,s2,1
 7a6:	fff94483          	lbu	s1,-1(s2)
 7aa:	14048b63          	beqz	s1,900 <vprintf+0x1bc>
    c = fmt[i] & 0xff;
 7ae:	0004879b          	sext.w	a5,s1
    if(state == 0){
 7b2:	fe0997e3          	bnez	s3,7a0 <vprintf+0x5c>
      if(c == '%'){
 7b6:	fd479ee3          	bne	a5,s4,792 <vprintf+0x4e>
        state = '%';
 7ba:	89be                	mv	s3,a5
 7bc:	b7e5                	j	7a4 <vprintf+0x60>
      if(c == 'd'){
 7be:	05878063          	beq	a5,s8,7fe <vprintf+0xba>
      } else if(c == 'l') {
 7c2:	05978c63          	beq	a5,s9,81a <vprintf+0xd6>
      } else if(c == 'x') {
 7c6:	07a78863          	beq	a5,s10,836 <vprintf+0xf2>
      } else if(c == 'p') {
 7ca:	09b78463          	beq	a5,s11,852 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 7ce:	07300713          	li	a4,115
 7d2:	0ce78563          	beq	a5,a4,89c <vprintf+0x158>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7d6:	06300713          	li	a4,99
 7da:	0ee78c63          	beq	a5,a4,8d2 <vprintf+0x18e>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 7de:	11478663          	beq	a5,s4,8ea <vprintf+0x1a6>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7e2:	85d2                	mv	a1,s4
 7e4:	8556                	mv	a0,s5
 7e6:	00000097          	auipc	ra,0x0
 7ea:	e8e080e7          	jalr	-370(ra) # 674 <putc>
        putc(fd, c);
 7ee:	85a6                	mv	a1,s1
 7f0:	8556                	mv	a0,s5
 7f2:	00000097          	auipc	ra,0x0
 7f6:	e82080e7          	jalr	-382(ra) # 674 <putc>
      }
      state = 0;
 7fa:	4981                	li	s3,0
 7fc:	b765                	j	7a4 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 7fe:	008b0493          	addi	s1,s6,8
 802:	4685                	li	a3,1
 804:	4629                	li	a2,10
 806:	000b2583          	lw	a1,0(s6)
 80a:	8556                	mv	a0,s5
 80c:	00000097          	auipc	ra,0x0
 810:	e8a080e7          	jalr	-374(ra) # 696 <printint>
 814:	8b26                	mv	s6,s1
      state = 0;
 816:	4981                	li	s3,0
 818:	b771                	j	7a4 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 81a:	008b0493          	addi	s1,s6,8
 81e:	4681                	li	a3,0
 820:	4629                	li	a2,10
 822:	000b2583          	lw	a1,0(s6)
 826:	8556                	mv	a0,s5
 828:	00000097          	auipc	ra,0x0
 82c:	e6e080e7          	jalr	-402(ra) # 696 <printint>
 830:	8b26                	mv	s6,s1
      state = 0;
 832:	4981                	li	s3,0
 834:	bf85                	j	7a4 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 836:	008b0493          	addi	s1,s6,8
 83a:	4681                	li	a3,0
 83c:	4641                	li	a2,16
 83e:	000b2583          	lw	a1,0(s6)
 842:	8556                	mv	a0,s5
 844:	00000097          	auipc	ra,0x0
 848:	e52080e7          	jalr	-430(ra) # 696 <printint>
 84c:	8b26                	mv	s6,s1
      state = 0;
 84e:	4981                	li	s3,0
 850:	bf91                	j	7a4 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 852:	008b0793          	addi	a5,s6,8
 856:	f8f43423          	sd	a5,-120(s0)
 85a:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 85e:	03000593          	li	a1,48
 862:	8556                	mv	a0,s5
 864:	00000097          	auipc	ra,0x0
 868:	e10080e7          	jalr	-496(ra) # 674 <putc>
  putc(fd, 'x');
 86c:	85ea                	mv	a1,s10
 86e:	8556                	mv	a0,s5
 870:	00000097          	auipc	ra,0x0
 874:	e04080e7          	jalr	-508(ra) # 674 <putc>
 878:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 87a:	03c9d793          	srli	a5,s3,0x3c
 87e:	97de                	add	a5,a5,s7
 880:	0007c583          	lbu	a1,0(a5)
 884:	8556                	mv	a0,s5
 886:	00000097          	auipc	ra,0x0
 88a:	dee080e7          	jalr	-530(ra) # 674 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 88e:	0992                	slli	s3,s3,0x4
 890:	34fd                	addiw	s1,s1,-1
 892:	f4e5                	bnez	s1,87a <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 894:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 898:	4981                	li	s3,0
 89a:	b729                	j	7a4 <vprintf+0x60>
        s = va_arg(ap, char*);
 89c:	008b0993          	addi	s3,s6,8
 8a0:	000b3483          	ld	s1,0(s6)
        if(s == 0)
 8a4:	c085                	beqz	s1,8c4 <vprintf+0x180>
        while(*s != 0){
 8a6:	0004c583          	lbu	a1,0(s1)
 8aa:	c9a1                	beqz	a1,8fa <vprintf+0x1b6>
          putc(fd, *s);
 8ac:	8556                	mv	a0,s5
 8ae:	00000097          	auipc	ra,0x0
 8b2:	dc6080e7          	jalr	-570(ra) # 674 <putc>
          s++;
 8b6:	0485                	addi	s1,s1,1
        while(*s != 0){
 8b8:	0004c583          	lbu	a1,0(s1)
 8bc:	f9e5                	bnez	a1,8ac <vprintf+0x168>
        s = va_arg(ap, char*);
 8be:	8b4e                	mv	s6,s3
      state = 0;
 8c0:	4981                	li	s3,0
 8c2:	b5cd                	j	7a4 <vprintf+0x60>
          s = "(null)";
 8c4:	00000497          	auipc	s1,0x0
 8c8:	2f448493          	addi	s1,s1,756 # bb8 <digits+0x18>
        while(*s != 0){
 8cc:	02800593          	li	a1,40
 8d0:	bff1                	j	8ac <vprintf+0x168>
        putc(fd, va_arg(ap, uint));
 8d2:	008b0493          	addi	s1,s6,8
 8d6:	000b4583          	lbu	a1,0(s6)
 8da:	8556                	mv	a0,s5
 8dc:	00000097          	auipc	ra,0x0
 8e0:	d98080e7          	jalr	-616(ra) # 674 <putc>
 8e4:	8b26                	mv	s6,s1
      state = 0;
 8e6:	4981                	li	s3,0
 8e8:	bd75                	j	7a4 <vprintf+0x60>
        putc(fd, c);
 8ea:	85d2                	mv	a1,s4
 8ec:	8556                	mv	a0,s5
 8ee:	00000097          	auipc	ra,0x0
 8f2:	d86080e7          	jalr	-634(ra) # 674 <putc>
      state = 0;
 8f6:	4981                	li	s3,0
 8f8:	b575                	j	7a4 <vprintf+0x60>
        s = va_arg(ap, char*);
 8fa:	8b4e                	mv	s6,s3
      state = 0;
 8fc:	4981                	li	s3,0
 8fe:	b55d                	j	7a4 <vprintf+0x60>
    }
  }
}
 900:	70e6                	ld	ra,120(sp)
 902:	7446                	ld	s0,112(sp)
 904:	74a6                	ld	s1,104(sp)
 906:	7906                	ld	s2,96(sp)
 908:	69e6                	ld	s3,88(sp)
 90a:	6a46                	ld	s4,80(sp)
 90c:	6aa6                	ld	s5,72(sp)
 90e:	6b06                	ld	s6,64(sp)
 910:	7be2                	ld	s7,56(sp)
 912:	7c42                	ld	s8,48(sp)
 914:	7ca2                	ld	s9,40(sp)
 916:	7d02                	ld	s10,32(sp)
 918:	6de2                	ld	s11,24(sp)
 91a:	6109                	addi	sp,sp,128
 91c:	8082                	ret

000000000000091e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 91e:	715d                	addi	sp,sp,-80
 920:	ec06                	sd	ra,24(sp)
 922:	e822                	sd	s0,16(sp)
 924:	1000                	addi	s0,sp,32
 926:	e010                	sd	a2,0(s0)
 928:	e414                	sd	a3,8(s0)
 92a:	e818                	sd	a4,16(s0)
 92c:	ec1c                	sd	a5,24(s0)
 92e:	03043023          	sd	a6,32(s0)
 932:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 936:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 93a:	8622                	mv	a2,s0
 93c:	00000097          	auipc	ra,0x0
 940:	e08080e7          	jalr	-504(ra) # 744 <vprintf>
}
 944:	60e2                	ld	ra,24(sp)
 946:	6442                	ld	s0,16(sp)
 948:	6161                	addi	sp,sp,80
 94a:	8082                	ret

000000000000094c <printf>:

void
printf(const char *fmt, ...)
{
 94c:	711d                	addi	sp,sp,-96
 94e:	ec06                	sd	ra,24(sp)
 950:	e822                	sd	s0,16(sp)
 952:	1000                	addi	s0,sp,32
 954:	e40c                	sd	a1,8(s0)
 956:	e810                	sd	a2,16(s0)
 958:	ec14                	sd	a3,24(s0)
 95a:	f018                	sd	a4,32(s0)
 95c:	f41c                	sd	a5,40(s0)
 95e:	03043823          	sd	a6,48(s0)
 962:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 966:	00840613          	addi	a2,s0,8
 96a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 96e:	85aa                	mv	a1,a0
 970:	4505                	li	a0,1
 972:	00000097          	auipc	ra,0x0
 976:	dd2080e7          	jalr	-558(ra) # 744 <vprintf>
}
 97a:	60e2                	ld	ra,24(sp)
 97c:	6442                	ld	s0,16(sp)
 97e:	6125                	addi	sp,sp,96
 980:	8082                	ret

0000000000000982 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 982:	1141                	addi	sp,sp,-16
 984:	e422                	sd	s0,8(sp)
 986:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 988:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 98c:	00000797          	auipc	a5,0x0
 990:	67478793          	addi	a5,a5,1652 # 1000 <freep>
 994:	639c                	ld	a5,0(a5)
 996:	a805                	j	9c6 <free+0x44>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 998:	4618                	lw	a4,8(a2)
 99a:	9db9                	addw	a1,a1,a4
 99c:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 9a0:	6398                	ld	a4,0(a5)
 9a2:	6318                	ld	a4,0(a4)
 9a4:	fee53823          	sd	a4,-16(a0)
 9a8:	a091                	j	9ec <free+0x6a>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 9aa:	ff852703          	lw	a4,-8(a0)
 9ae:	9e39                	addw	a2,a2,a4
 9b0:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 9b2:	ff053703          	ld	a4,-16(a0)
 9b6:	e398                	sd	a4,0(a5)
 9b8:	a099                	j	9fe <free+0x7c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9ba:	6398                	ld	a4,0(a5)
 9bc:	00e7e463          	bltu	a5,a4,9c4 <free+0x42>
 9c0:	00e6ea63          	bltu	a3,a4,9d4 <free+0x52>
{
 9c4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9c6:	fed7fae3          	bgeu	a5,a3,9ba <free+0x38>
 9ca:	6398                	ld	a4,0(a5)
 9cc:	00e6e463          	bltu	a3,a4,9d4 <free+0x52>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9d0:	fee7eae3          	bltu	a5,a4,9c4 <free+0x42>
  if(bp + bp->s.size == p->s.ptr){
 9d4:	ff852583          	lw	a1,-8(a0)
 9d8:	6390                	ld	a2,0(a5)
 9da:	02059713          	slli	a4,a1,0x20
 9de:	9301                	srli	a4,a4,0x20
 9e0:	0712                	slli	a4,a4,0x4
 9e2:	9736                	add	a4,a4,a3
 9e4:	fae60ae3          	beq	a2,a4,998 <free+0x16>
    bp->s.ptr = p->s.ptr;
 9e8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9ec:	4790                	lw	a2,8(a5)
 9ee:	02061713          	slli	a4,a2,0x20
 9f2:	9301                	srli	a4,a4,0x20
 9f4:	0712                	slli	a4,a4,0x4
 9f6:	973e                	add	a4,a4,a5
 9f8:	fae689e3          	beq	a3,a4,9aa <free+0x28>
  } else
    p->s.ptr = bp;
 9fc:	e394                	sd	a3,0(a5)
  freep = p;
 9fe:	00000717          	auipc	a4,0x0
 a02:	60f73123          	sd	a5,1538(a4) # 1000 <freep>
}
 a06:	6422                	ld	s0,8(sp)
 a08:	0141                	addi	sp,sp,16
 a0a:	8082                	ret

0000000000000a0c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a0c:	7139                	addi	sp,sp,-64
 a0e:	fc06                	sd	ra,56(sp)
 a10:	f822                	sd	s0,48(sp)
 a12:	f426                	sd	s1,40(sp)
 a14:	f04a                	sd	s2,32(sp)
 a16:	ec4e                	sd	s3,24(sp)
 a18:	e852                	sd	s4,16(sp)
 a1a:	e456                	sd	s5,8(sp)
 a1c:	e05a                	sd	s6,0(sp)
 a1e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a20:	02051993          	slli	s3,a0,0x20
 a24:	0209d993          	srli	s3,s3,0x20
 a28:	09bd                	addi	s3,s3,15
 a2a:	0049d993          	srli	s3,s3,0x4
 a2e:	2985                	addiw	s3,s3,1
 a30:	0009891b          	sext.w	s2,s3
  if((prevp = freep) == 0){
 a34:	00000797          	auipc	a5,0x0
 a38:	5cc78793          	addi	a5,a5,1484 # 1000 <freep>
 a3c:	6388                	ld	a0,0(a5)
 a3e:	c515                	beqz	a0,a6a <malloc+0x5e>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a40:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a42:	4798                	lw	a4,8(a5)
 a44:	03277f63          	bgeu	a4,s2,a82 <malloc+0x76>
 a48:	8a4e                	mv	s4,s3
 a4a:	0009871b          	sext.w	a4,s3
 a4e:	6685                	lui	a3,0x1
 a50:	00d77363          	bgeu	a4,a3,a56 <malloc+0x4a>
 a54:	6a05                	lui	s4,0x1
 a56:	000a0a9b          	sext.w	s5,s4
  p = sbrk(nu * sizeof(Header));
 a5a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a5e:	00000497          	auipc	s1,0x0
 a62:	5a248493          	addi	s1,s1,1442 # 1000 <freep>
  if(p == (char*)-1)
 a66:	5b7d                	li	s6,-1
 a68:	a885                	j	ad8 <malloc+0xcc>
    base.s.ptr = freep = prevp = &base;
 a6a:	00000797          	auipc	a5,0x0
 a6e:	5a678793          	addi	a5,a5,1446 # 1010 <base>
 a72:	00000717          	auipc	a4,0x0
 a76:	58f73723          	sd	a5,1422(a4) # 1000 <freep>
 a7a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a7c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a80:	b7e1                	j	a48 <malloc+0x3c>
      if(p->s.size == nunits)
 a82:	02e90b63          	beq	s2,a4,ab8 <malloc+0xac>
        p->s.size -= nunits;
 a86:	4137073b          	subw	a4,a4,s3
 a8a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a8c:	1702                	slli	a4,a4,0x20
 a8e:	9301                	srli	a4,a4,0x20
 a90:	0712                	slli	a4,a4,0x4
 a92:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a94:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a98:	00000717          	auipc	a4,0x0
 a9c:	56a73423          	sd	a0,1384(a4) # 1000 <freep>
      return (void*)(p + 1);
 aa0:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 aa4:	70e2                	ld	ra,56(sp)
 aa6:	7442                	ld	s0,48(sp)
 aa8:	74a2                	ld	s1,40(sp)
 aaa:	7902                	ld	s2,32(sp)
 aac:	69e2                	ld	s3,24(sp)
 aae:	6a42                	ld	s4,16(sp)
 ab0:	6aa2                	ld	s5,8(sp)
 ab2:	6b02                	ld	s6,0(sp)
 ab4:	6121                	addi	sp,sp,64
 ab6:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 ab8:	6398                	ld	a4,0(a5)
 aba:	e118                	sd	a4,0(a0)
 abc:	bff1                	j	a98 <malloc+0x8c>
  hp->s.size = nu;
 abe:	01552423          	sw	s5,8(a0)
  free((void*)(hp + 1));
 ac2:	0541                	addi	a0,a0,16
 ac4:	00000097          	auipc	ra,0x0
 ac8:	ebe080e7          	jalr	-322(ra) # 982 <free>
  return freep;
 acc:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 ace:	d979                	beqz	a0,aa4 <malloc+0x98>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ad0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 ad2:	4798                	lw	a4,8(a5)
 ad4:	fb2777e3          	bgeu	a4,s2,a82 <malloc+0x76>
    if(p == freep)
 ad8:	6098                	ld	a4,0(s1)
 ada:	853e                	mv	a0,a5
 adc:	fef71ae3          	bne	a4,a5,ad0 <malloc+0xc4>
  p = sbrk(nu * sizeof(Header));
 ae0:	8552                	mv	a0,s4
 ae2:	00000097          	auipc	ra,0x0
 ae6:	b7a080e7          	jalr	-1158(ra) # 65c <sbrk>
  if(p == (char*)-1)
 aea:	fd651ae3          	bne	a0,s6,abe <malloc+0xb2>
        return 0;
 aee:	4501                	li	a0,0
 af0:	bf55                	j	aa4 <malloc+0x98>
