
user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <ncat>:
char buf[512];


void
ncat(int fd)
{
   0:	711d                	addi	sp,sp,-96
   2:	ec86                	sd	ra,88(sp)
   4:	e8a2                	sd	s0,80(sp)
   6:	e4a6                	sd	s1,72(sp)
   8:	e0ca                	sd	s2,64(sp)
   a:	fc4e                	sd	s3,56(sp)
   c:	f852                	sd	s4,48(sp)
   e:	f456                	sd	s5,40(sp)
  10:	f05a                	sd	s6,32(sp)
  12:	ec5e                	sd	s7,24(sp)
  14:	e862                	sd	s8,16(sp)
  16:	e466                	sd	s9,8(sp)
  18:	e06a                	sd	s10,0(sp)
  1a:	1080                	addi	s0,sp,96
  1c:	8caa                	mv	s9,a0
  int n;
  int counter=1;
  1e:	4b05                	li	s6,1
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  20:	00001b97          	auipc	s7,0x1
  24:	ff0b8b93          	addi	s7,s7,-16 # 1010 <buf>
    printf("%d\t",counter);
  28:	00001c17          	auipc	s8,0x1
  2c:	9b8c0c13          	addi	s8,s8,-1608 # 9e0 <malloc+0xec>
  30:	00001d17          	auipc	s10,0x1
  34:	fe1d0d13          	addi	s10,s10,-31 # 1011 <buf+0x1>
    for (int i=0;i<n;i++)
    { 
      printf("%c",buf[i]);
  38:	00001a17          	auipc	s4,0x1
  3c:	9b0a0a13          	addi	s4,s4,-1616 # 9e8 <malloc+0xf4>
      if(buf[i]=='\n')
  40:	49a9                	li	s3,10
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  42:	20000613          	li	a2,512
  46:	85de                	mv	a1,s7
  48:	8566                	mv	a0,s9
  4a:	00000097          	auipc	ra,0x0
  4e:	48a080e7          	jalr	1162(ra) # 4d4 <read>
  52:	8aaa                	mv	s5,a0
  54:	04a05b63          	blez	a0,aa <ncat+0xaa>
    printf("%d\t",counter);
  58:	85da                	mv	a1,s6
  5a:	8562                	mv	a0,s8
  5c:	00000097          	auipc	ra,0x0
  60:	7d8080e7          	jalr	2008(ra) # 834 <printf>
    for (int i=0;i<n;i++)
  64:	fffa891b          	addiw	s2,s5,-1
  68:	1902                	slli	s2,s2,0x20
  6a:	02095913          	srli	s2,s2,0x20
  6e:	996a                	add	s2,s2,s10
    printf("%d\t",counter);
  70:	84de                	mv	s1,s7
      {
        counter+=1;
        if(i<n-1)
  72:	3afd                	addiw	s5,s5,-1
  74:	a811                	j	88 <ncat+0x88>
        {
        printf("%d\t",counter);
  76:	85da                	mv	a1,s6
  78:	8562                	mv	a0,s8
  7a:	00000097          	auipc	ra,0x0
  7e:	7ba080e7          	jalr	1978(ra) # 834 <printf>
    for (int i=0;i<n;i++)
  82:	0485                	addi	s1,s1,1
  84:	fb248fe3          	beq	s1,s2,42 <ncat+0x42>
      printf("%c",buf[i]);
  88:	0004c583          	lbu	a1,0(s1)
  8c:	8552                	mv	a0,s4
  8e:	00000097          	auipc	ra,0x0
  92:	7a6080e7          	jalr	1958(ra) # 834 <printf>
      if(buf[i]=='\n')
  96:	0004c783          	lbu	a5,0(s1)
  9a:	ff3794e3          	bne	a5,s3,82 <ncat+0x82>
        counter+=1;
  9e:	2b05                	addiw	s6,s6,1
        if(i<n-1)
  a0:	417487bb          	subw	a5,s1,s7
  a4:	fd57dfe3          	bge	a5,s5,82 <ncat+0x82>
  a8:	b7f9                	j	76 <ncat+0x76>
        }
      }
    }
}
}
  aa:	60e6                	ld	ra,88(sp)
  ac:	6446                	ld	s0,80(sp)
  ae:	64a6                	ld	s1,72(sp)
  b0:	6906                	ld	s2,64(sp)
  b2:	79e2                	ld	s3,56(sp)
  b4:	7a42                	ld	s4,48(sp)
  b6:	7aa2                	ld	s5,40(sp)
  b8:	7b02                	ld	s6,32(sp)
  ba:	6be2                	ld	s7,24(sp)
  bc:	6c42                	ld	s8,16(sp)
  be:	6ca2                	ld	s9,8(sp)
  c0:	6d02                	ld	s10,0(sp)
  c2:	6125                	addi	sp,sp,96
  c4:	8082                	ret

00000000000000c6 <cat>:

void
cat(int fd)
{
  c6:	7179                	addi	sp,sp,-48
  c8:	f406                	sd	ra,40(sp)
  ca:	f022                	sd	s0,32(sp)
  cc:	ec26                	sd	s1,24(sp)
  ce:	e84a                	sd	s2,16(sp)
  d0:	e44e                	sd	s3,8(sp)
  d2:	1800                	addi	s0,sp,48
  d4:	89aa                	mv	s3,a0
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  d6:	00001917          	auipc	s2,0x1
  da:	f3a90913          	addi	s2,s2,-198 # 1010 <buf>
  de:	20000613          	li	a2,512
  e2:	85ca                	mv	a1,s2
  e4:	854e                	mv	a0,s3
  e6:	00000097          	auipc	ra,0x0
  ea:	3ee080e7          	jalr	1006(ra) # 4d4 <read>
  ee:	84aa                	mv	s1,a0
  f0:	02a05963          	blez	a0,122 <cat+0x5c>
    
    if (write(1, buf, n) != n) {
  f4:	8626                	mv	a2,s1
  f6:	85ca                	mv	a1,s2
  f8:	4505                	li	a0,1
  fa:	00000097          	auipc	ra,0x0
  fe:	3e2080e7          	jalr	994(ra) # 4dc <write>
 102:	fc950ee3          	beq	a0,s1,de <cat+0x18>
      fprintf(2, "cat: write error\n");
 106:	00001597          	auipc	a1,0x1
 10a:	8ea58593          	addi	a1,a1,-1814 # 9f0 <malloc+0xfc>
 10e:	4509                	li	a0,2
 110:	00000097          	auipc	ra,0x0
 114:	6f6080e7          	jalr	1782(ra) # 806 <fprintf>
      exit(1);
 118:	4505                	li	a0,1
 11a:	00000097          	auipc	ra,0x0
 11e:	3a2080e7          	jalr	930(ra) # 4bc <exit>
    }
  }
  if(n < 0){
 122:	00054963          	bltz	a0,134 <cat+0x6e>
    fprintf(2, "cat: read error\n");
    exit(1);
  }
}
 126:	70a2                	ld	ra,40(sp)
 128:	7402                	ld	s0,32(sp)
 12a:	64e2                	ld	s1,24(sp)
 12c:	6942                	ld	s2,16(sp)
 12e:	69a2                	ld	s3,8(sp)
 130:	6145                	addi	sp,sp,48
 132:	8082                	ret
    fprintf(2, "cat: read error\n");
 134:	00001597          	auipc	a1,0x1
 138:	8d458593          	addi	a1,a1,-1836 # a08 <malloc+0x114>
 13c:	4509                	li	a0,2
 13e:	00000097          	auipc	ra,0x0
 142:	6c8080e7          	jalr	1736(ra) # 806 <fprintf>
    exit(1);
 146:	4505                	li	a0,1
 148:	00000097          	auipc	ra,0x0
 14c:	374080e7          	jalr	884(ra) # 4bc <exit>

0000000000000150 <main>:

int
main(int argc, char *argv[])
{
 150:	715d                	addi	sp,sp,-80
 152:	e486                	sd	ra,72(sp)
 154:	e0a2                	sd	s0,64(sp)
 156:	fc26                	sd	s1,56(sp)
 158:	f84a                	sd	s2,48(sp)
 15a:	f44e                	sd	s3,40(sp)
 15c:	f052                	sd	s4,32(sp)
 15e:	ec56                	sd	s5,24(sp)
 160:	e85a                	sd	s6,16(sp)
 162:	e45e                	sd	s7,8(sp)
 164:	0880                	addi	s0,sp,80
  int flag=1;
  int fd, i;

  if(argc <= 1){
 166:	4785                	li	a5,1
 168:	02a7d363          	bge	a5,a0,18e <main+0x3e>
 16c:	8a2a                	mv	s4,a0
 16e:	84ae                	mv	s1,a1
    cat(0);
    exit(0);
  }
  if(strcmp(argv[1],"-n")==0){
 170:	00001597          	auipc	a1,0x1
 174:	8b058593          	addi	a1,a1,-1872 # a20 <malloc+0x12c>
 178:	6488                	ld	a0,8(s1)
 17a:	00000097          	auipc	ra,0x0
 17e:	0ce080e7          	jalr	206(ra) # 248 <strcmp>
 182:	e105                	bnez	a0,1a2 <main+0x52>
    flag+=1;
  }

  for(i = flag; i < argc; i++){
 184:	4789                	li	a5,2
 186:	0947d163          	bge	a5,s4,208 <main+0xb8>
    flag+=1;
 18a:	4a89                	li	s5,2
 18c:	a821                	j	1a4 <main+0x54>
    cat(0);
 18e:	4501                	li	a0,0
 190:	00000097          	auipc	ra,0x0
 194:	f36080e7          	jalr	-202(ra) # c6 <cat>
    exit(0);
 198:	4501                	li	a0,0
 19a:	00000097          	auipc	ra,0x0
 19e:	322080e7          	jalr	802(ra) # 4bc <exit>
  int flag=1;
 1a2:	4a85                	li	s5,1
 1a4:	003a9793          	slli	a5,s5,0x3
 1a8:	94be                	add	s1,s1,a5
    flag+=1;
 1aa:	89d6                	mv	s3,s5
    if((fd = open(argv[i], 0)) < 0){
      fprintf(2, "cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    if(flag==2)
 1ac:	4b89                	li	s7,2
 1ae:	a82d                	j	1e8 <main+0x98>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
 1b0:	6090                	ld	a2,0(s1)
 1b2:	00001597          	auipc	a1,0x1
 1b6:	87658593          	addi	a1,a1,-1930 # a28 <malloc+0x134>
 1ba:	4509                	li	a0,2
 1bc:	00000097          	auipc	ra,0x0
 1c0:	64a080e7          	jalr	1610(ra) # 806 <fprintf>
      exit(1);
 1c4:	4505                	li	a0,1
 1c6:	00000097          	auipc	ra,0x0
 1ca:	2f6080e7          	jalr	758(ra) # 4bc <exit>
    {
      ncat(fd);
    }
    else
    {
      cat(fd);
 1ce:	00000097          	auipc	ra,0x0
 1d2:	ef8080e7          	jalr	-264(ra) # c6 <cat>
    }
    close(fd);
 1d6:	854a                	mv	a0,s2
 1d8:	00000097          	auipc	ra,0x0
 1dc:	30c080e7          	jalr	780(ra) # 4e4 <close>
  for(i = flag; i < argc; i++){
 1e0:	2985                	addiw	s3,s3,1
 1e2:	04a1                	addi	s1,s1,8
 1e4:	0349d263          	bge	s3,s4,208 <main+0xb8>
    if((fd = open(argv[i], 0)) < 0){
 1e8:	4581                	li	a1,0
 1ea:	6088                	ld	a0,0(s1)
 1ec:	00000097          	auipc	ra,0x0
 1f0:	310080e7          	jalr	784(ra) # 4fc <open>
 1f4:	892a                	mv	s2,a0
 1f6:	fa054de3          	bltz	a0,1b0 <main+0x60>
    if(flag==2)
 1fa:	fd7a9ae3          	bne	s5,s7,1ce <main+0x7e>
      ncat(fd);
 1fe:	00000097          	auipc	ra,0x0
 202:	e02080e7          	jalr	-510(ra) # 0 <ncat>
 206:	bfc1                	j	1d6 <main+0x86>
  }
  exit(0);
 208:	4501                	li	a0,0
 20a:	00000097          	auipc	ra,0x0
 20e:	2b2080e7          	jalr	690(ra) # 4bc <exit>

0000000000000212 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 212:	1141                	addi	sp,sp,-16
 214:	e406                	sd	ra,8(sp)
 216:	e022                	sd	s0,0(sp)
 218:	0800                	addi	s0,sp,16
  extern int main();
  main();
 21a:	00000097          	auipc	ra,0x0
 21e:	f36080e7          	jalr	-202(ra) # 150 <main>
  exit(0);
 222:	4501                	li	a0,0
 224:	00000097          	auipc	ra,0x0
 228:	298080e7          	jalr	664(ra) # 4bc <exit>

000000000000022c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 22c:	1141                	addi	sp,sp,-16
 22e:	e422                	sd	s0,8(sp)
 230:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 232:	87aa                	mv	a5,a0
 234:	0585                	addi	a1,a1,1
 236:	0785                	addi	a5,a5,1
 238:	fff5c703          	lbu	a4,-1(a1)
 23c:	fee78fa3          	sb	a4,-1(a5)
 240:	fb75                	bnez	a4,234 <strcpy+0x8>
    ;
  return os;
}
 242:	6422                	ld	s0,8(sp)
 244:	0141                	addi	sp,sp,16
 246:	8082                	ret

0000000000000248 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 248:	1141                	addi	sp,sp,-16
 24a:	e422                	sd	s0,8(sp)
 24c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 24e:	00054783          	lbu	a5,0(a0)
 252:	cf91                	beqz	a5,26e <strcmp+0x26>
 254:	0005c703          	lbu	a4,0(a1)
 258:	00f71b63          	bne	a4,a5,26e <strcmp+0x26>
    p++, q++;
 25c:	0505                	addi	a0,a0,1
 25e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 260:	00054783          	lbu	a5,0(a0)
 264:	c789                	beqz	a5,26e <strcmp+0x26>
 266:	0005c703          	lbu	a4,0(a1)
 26a:	fef709e3          	beq	a4,a5,25c <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 26e:	0005c503          	lbu	a0,0(a1)
}
 272:	40a7853b          	subw	a0,a5,a0
 276:	6422                	ld	s0,8(sp)
 278:	0141                	addi	sp,sp,16
 27a:	8082                	ret

000000000000027c <strlen>:

uint
strlen(const char *s)
{
 27c:	1141                	addi	sp,sp,-16
 27e:	e422                	sd	s0,8(sp)
 280:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 282:	00054783          	lbu	a5,0(a0)
 286:	cf91                	beqz	a5,2a2 <strlen+0x26>
 288:	0505                	addi	a0,a0,1
 28a:	87aa                	mv	a5,a0
 28c:	4685                	li	a3,1
 28e:	9e89                	subw	a3,a3,a0
 290:	00f6853b          	addw	a0,a3,a5
 294:	0785                	addi	a5,a5,1
 296:	fff7c703          	lbu	a4,-1(a5)
 29a:	fb7d                	bnez	a4,290 <strlen+0x14>
    ;
  return n;
}
 29c:	6422                	ld	s0,8(sp)
 29e:	0141                	addi	sp,sp,16
 2a0:	8082                	ret
  for(n = 0; s[n]; n++)
 2a2:	4501                	li	a0,0
 2a4:	bfe5                	j	29c <strlen+0x20>

00000000000002a6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2a6:	1141                	addi	sp,sp,-16
 2a8:	e422                	sd	s0,8(sp)
 2aa:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2ac:	ce09                	beqz	a2,2c6 <memset+0x20>
 2ae:	87aa                	mv	a5,a0
 2b0:	fff6071b          	addiw	a4,a2,-1
 2b4:	1702                	slli	a4,a4,0x20
 2b6:	9301                	srli	a4,a4,0x20
 2b8:	0705                	addi	a4,a4,1
 2ba:	972a                	add	a4,a4,a0
    cdst[i] = c;
 2bc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2c0:	0785                	addi	a5,a5,1
 2c2:	fee79de3          	bne	a5,a4,2bc <memset+0x16>
  }
  return dst;
}
 2c6:	6422                	ld	s0,8(sp)
 2c8:	0141                	addi	sp,sp,16
 2ca:	8082                	ret

00000000000002cc <strchr>:

char*
strchr(const char *s, char c)
{
 2cc:	1141                	addi	sp,sp,-16
 2ce:	e422                	sd	s0,8(sp)
 2d0:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2d2:	00054783          	lbu	a5,0(a0)
 2d6:	cf91                	beqz	a5,2f2 <strchr+0x26>
    if(*s == c)
 2d8:	00f58a63          	beq	a1,a5,2ec <strchr+0x20>
  for(; *s; s++)
 2dc:	0505                	addi	a0,a0,1
 2de:	00054783          	lbu	a5,0(a0)
 2e2:	c781                	beqz	a5,2ea <strchr+0x1e>
    if(*s == c)
 2e4:	feb79ce3          	bne	a5,a1,2dc <strchr+0x10>
 2e8:	a011                	j	2ec <strchr+0x20>
      return (char*)s;
  return 0;
 2ea:	4501                	li	a0,0
}
 2ec:	6422                	ld	s0,8(sp)
 2ee:	0141                	addi	sp,sp,16
 2f0:	8082                	ret
  return 0;
 2f2:	4501                	li	a0,0
 2f4:	bfe5                	j	2ec <strchr+0x20>

00000000000002f6 <gets>:

char*
gets(char *buf, int max)
{
 2f6:	711d                	addi	sp,sp,-96
 2f8:	ec86                	sd	ra,88(sp)
 2fa:	e8a2                	sd	s0,80(sp)
 2fc:	e4a6                	sd	s1,72(sp)
 2fe:	e0ca                	sd	s2,64(sp)
 300:	fc4e                	sd	s3,56(sp)
 302:	f852                	sd	s4,48(sp)
 304:	f456                	sd	s5,40(sp)
 306:	f05a                	sd	s6,32(sp)
 308:	ec5e                	sd	s7,24(sp)
 30a:	1080                	addi	s0,sp,96
 30c:	8baa                	mv	s7,a0
 30e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 310:	892a                	mv	s2,a0
 312:	4981                	li	s3,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 314:	4aa9                	li	s5,10
 316:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 318:	0019849b          	addiw	s1,s3,1
 31c:	0344d863          	bge	s1,s4,34c <gets+0x56>
    cc = read(0, &c, 1);
 320:	4605                	li	a2,1
 322:	faf40593          	addi	a1,s0,-81
 326:	4501                	li	a0,0
 328:	00000097          	auipc	ra,0x0
 32c:	1ac080e7          	jalr	428(ra) # 4d4 <read>
    if(cc < 1)
 330:	00a05e63          	blez	a0,34c <gets+0x56>
    buf[i++] = c;
 334:	faf44783          	lbu	a5,-81(s0)
 338:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 33c:	01578763          	beq	a5,s5,34a <gets+0x54>
 340:	0905                	addi	s2,s2,1
  for(i=0; i+1 < max; ){
 342:	89a6                	mv	s3,s1
    if(c == '\n' || c == '\r')
 344:	fd679ae3          	bne	a5,s6,318 <gets+0x22>
 348:	a011                	j	34c <gets+0x56>
  for(i=0; i+1 < max; ){
 34a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 34c:	99de                	add	s3,s3,s7
 34e:	00098023          	sb	zero,0(s3)
  return buf;
}
 352:	855e                	mv	a0,s7
 354:	60e6                	ld	ra,88(sp)
 356:	6446                	ld	s0,80(sp)
 358:	64a6                	ld	s1,72(sp)
 35a:	6906                	ld	s2,64(sp)
 35c:	79e2                	ld	s3,56(sp)
 35e:	7a42                	ld	s4,48(sp)
 360:	7aa2                	ld	s5,40(sp)
 362:	7b02                	ld	s6,32(sp)
 364:	6be2                	ld	s7,24(sp)
 366:	6125                	addi	sp,sp,96
 368:	8082                	ret

000000000000036a <stat>:

int
stat(const char *n, struct stat *st)
{
 36a:	1101                	addi	sp,sp,-32
 36c:	ec06                	sd	ra,24(sp)
 36e:	e822                	sd	s0,16(sp)
 370:	e426                	sd	s1,8(sp)
 372:	e04a                	sd	s2,0(sp)
 374:	1000                	addi	s0,sp,32
 376:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 378:	4581                	li	a1,0
 37a:	00000097          	auipc	ra,0x0
 37e:	182080e7          	jalr	386(ra) # 4fc <open>
  if(fd < 0)
 382:	02054563          	bltz	a0,3ac <stat+0x42>
 386:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 388:	85ca                	mv	a1,s2
 38a:	00000097          	auipc	ra,0x0
 38e:	18a080e7          	jalr	394(ra) # 514 <fstat>
 392:	892a                	mv	s2,a0
  close(fd);
 394:	8526                	mv	a0,s1
 396:	00000097          	auipc	ra,0x0
 39a:	14e080e7          	jalr	334(ra) # 4e4 <close>
  return r;
}
 39e:	854a                	mv	a0,s2
 3a0:	60e2                	ld	ra,24(sp)
 3a2:	6442                	ld	s0,16(sp)
 3a4:	64a2                	ld	s1,8(sp)
 3a6:	6902                	ld	s2,0(sp)
 3a8:	6105                	addi	sp,sp,32
 3aa:	8082                	ret
    return -1;
 3ac:	597d                	li	s2,-1
 3ae:	bfc5                	j	39e <stat+0x34>

00000000000003b0 <atoi>:

int
atoi(const char *s)
{
 3b0:	1141                	addi	sp,sp,-16
 3b2:	e422                	sd	s0,8(sp)
 3b4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3b6:	00054683          	lbu	a3,0(a0)
 3ba:	fd06879b          	addiw	a5,a3,-48
 3be:	0ff7f793          	andi	a5,a5,255
 3c2:	4725                	li	a4,9
 3c4:	02f76963          	bltu	a4,a5,3f6 <atoi+0x46>
 3c8:	862a                	mv	a2,a0
  n = 0;
 3ca:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 3cc:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 3ce:	0605                	addi	a2,a2,1
 3d0:	0025179b          	slliw	a5,a0,0x2
 3d4:	9fa9                	addw	a5,a5,a0
 3d6:	0017979b          	slliw	a5,a5,0x1
 3da:	9fb5                	addw	a5,a5,a3
 3dc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3e0:	00064683          	lbu	a3,0(a2)
 3e4:	fd06871b          	addiw	a4,a3,-48
 3e8:	0ff77713          	andi	a4,a4,255
 3ec:	fee5f1e3          	bgeu	a1,a4,3ce <atoi+0x1e>
  return n;
}
 3f0:	6422                	ld	s0,8(sp)
 3f2:	0141                	addi	sp,sp,16
 3f4:	8082                	ret
  n = 0;
 3f6:	4501                	li	a0,0
 3f8:	bfe5                	j	3f0 <atoi+0x40>

00000000000003fa <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3fa:	1141                	addi	sp,sp,-16
 3fc:	e422                	sd	s0,8(sp)
 3fe:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 400:	02b57663          	bgeu	a0,a1,42c <memmove+0x32>
    while(n-- > 0)
 404:	02c05163          	blez	a2,426 <memmove+0x2c>
 408:	fff6079b          	addiw	a5,a2,-1
 40c:	1782                	slli	a5,a5,0x20
 40e:	9381                	srli	a5,a5,0x20
 410:	0785                	addi	a5,a5,1
 412:	97aa                	add	a5,a5,a0
  dst = vdst;
 414:	872a                	mv	a4,a0
      *dst++ = *src++;
 416:	0585                	addi	a1,a1,1
 418:	0705                	addi	a4,a4,1
 41a:	fff5c683          	lbu	a3,-1(a1)
 41e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 422:	fee79ae3          	bne	a5,a4,416 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 426:	6422                	ld	s0,8(sp)
 428:	0141                	addi	sp,sp,16
 42a:	8082                	ret
    dst += n;
 42c:	00c50733          	add	a4,a0,a2
    src += n;
 430:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 432:	fec05ae3          	blez	a2,426 <memmove+0x2c>
 436:	fff6079b          	addiw	a5,a2,-1
 43a:	1782                	slli	a5,a5,0x20
 43c:	9381                	srli	a5,a5,0x20
 43e:	fff7c793          	not	a5,a5
 442:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 444:	15fd                	addi	a1,a1,-1
 446:	177d                	addi	a4,a4,-1
 448:	0005c683          	lbu	a3,0(a1)
 44c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 450:	fef71ae3          	bne	a4,a5,444 <memmove+0x4a>
 454:	bfc9                	j	426 <memmove+0x2c>

0000000000000456 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 456:	1141                	addi	sp,sp,-16
 458:	e422                	sd	s0,8(sp)
 45a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 45c:	ce15                	beqz	a2,498 <memcmp+0x42>
 45e:	fff6069b          	addiw	a3,a2,-1
    if (*p1 != *p2) {
 462:	00054783          	lbu	a5,0(a0)
 466:	0005c703          	lbu	a4,0(a1)
 46a:	02e79063          	bne	a5,a4,48a <memcmp+0x34>
 46e:	1682                	slli	a3,a3,0x20
 470:	9281                	srli	a3,a3,0x20
 472:	0685                	addi	a3,a3,1
 474:	96aa                	add	a3,a3,a0
      return *p1 - *p2;
    }
    p1++;
 476:	0505                	addi	a0,a0,1
    p2++;
 478:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 47a:	00d50d63          	beq	a0,a3,494 <memcmp+0x3e>
    if (*p1 != *p2) {
 47e:	00054783          	lbu	a5,0(a0)
 482:	0005c703          	lbu	a4,0(a1)
 486:	fee788e3          	beq	a5,a4,476 <memcmp+0x20>
      return *p1 - *p2;
 48a:	40e7853b          	subw	a0,a5,a4
  }
  return 0;
}
 48e:	6422                	ld	s0,8(sp)
 490:	0141                	addi	sp,sp,16
 492:	8082                	ret
  return 0;
 494:	4501                	li	a0,0
 496:	bfe5                	j	48e <memcmp+0x38>
 498:	4501                	li	a0,0
 49a:	bfd5                	j	48e <memcmp+0x38>

000000000000049c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 49c:	1141                	addi	sp,sp,-16
 49e:	e406                	sd	ra,8(sp)
 4a0:	e022                	sd	s0,0(sp)
 4a2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4a4:	00000097          	auipc	ra,0x0
 4a8:	f56080e7          	jalr	-170(ra) # 3fa <memmove>
}
 4ac:	60a2                	ld	ra,8(sp)
 4ae:	6402                	ld	s0,0(sp)
 4b0:	0141                	addi	sp,sp,16
 4b2:	8082                	ret

00000000000004b4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4b4:	4885                	li	a7,1
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <exit>:
.global exit
exit:
 li a7, SYS_exit
 4bc:	4889                	li	a7,2
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4c4:	488d                	li	a7,3
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4cc:	4891                	li	a7,4
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <read>:
.global read
read:
 li a7, SYS_read
 4d4:	4895                	li	a7,5
 ecall
 4d6:	00000073          	ecall
 ret
 4da:	8082                	ret

00000000000004dc <write>:
.global write
write:
 li a7, SYS_write
 4dc:	48c1                	li	a7,16
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <close>:
.global close
close:
 li a7, SYS_close
 4e4:	48d5                	li	a7,21
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <kill>:
.global kill
kill:
 li a7, SYS_kill
 4ec:	4899                	li	a7,6
 ecall
 4ee:	00000073          	ecall
 ret
 4f2:	8082                	ret

00000000000004f4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4f4:	489d                	li	a7,7
 ecall
 4f6:	00000073          	ecall
 ret
 4fa:	8082                	ret

00000000000004fc <open>:
.global open
open:
 li a7, SYS_open
 4fc:	48bd                	li	a7,15
 ecall
 4fe:	00000073          	ecall
 ret
 502:	8082                	ret

0000000000000504 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 504:	48c5                	li	a7,17
 ecall
 506:	00000073          	ecall
 ret
 50a:	8082                	ret

000000000000050c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 50c:	48c9                	li	a7,18
 ecall
 50e:	00000073          	ecall
 ret
 512:	8082                	ret

0000000000000514 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 514:	48a1                	li	a7,8
 ecall
 516:	00000073          	ecall
 ret
 51a:	8082                	ret

000000000000051c <link>:
.global link
link:
 li a7, SYS_link
 51c:	48cd                	li	a7,19
 ecall
 51e:	00000073          	ecall
 ret
 522:	8082                	ret

0000000000000524 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 524:	48d1                	li	a7,20
 ecall
 526:	00000073          	ecall
 ret
 52a:	8082                	ret

000000000000052c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 52c:	48a5                	li	a7,9
 ecall
 52e:	00000073          	ecall
 ret
 532:	8082                	ret

0000000000000534 <dup>:
.global dup
dup:
 li a7, SYS_dup
 534:	48a9                	li	a7,10
 ecall
 536:	00000073          	ecall
 ret
 53a:	8082                	ret

000000000000053c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 53c:	48ad                	li	a7,11
 ecall
 53e:	00000073          	ecall
 ret
 542:	8082                	ret

0000000000000544 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 544:	48b1                	li	a7,12
 ecall
 546:	00000073          	ecall
 ret
 54a:	8082                	ret

000000000000054c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 54c:	48b5                	li	a7,13
 ecall
 54e:	00000073          	ecall
 ret
 552:	8082                	ret

0000000000000554 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 554:	48b9                	li	a7,14
 ecall
 556:	00000073          	ecall
 ret
 55a:	8082                	ret

000000000000055c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 55c:	1101                	addi	sp,sp,-32
 55e:	ec06                	sd	ra,24(sp)
 560:	e822                	sd	s0,16(sp)
 562:	1000                	addi	s0,sp,32
 564:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 568:	4605                	li	a2,1
 56a:	fef40593          	addi	a1,s0,-17
 56e:	00000097          	auipc	ra,0x0
 572:	f6e080e7          	jalr	-146(ra) # 4dc <write>
}
 576:	60e2                	ld	ra,24(sp)
 578:	6442                	ld	s0,16(sp)
 57a:	6105                	addi	sp,sp,32
 57c:	8082                	ret

000000000000057e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 57e:	7139                	addi	sp,sp,-64
 580:	fc06                	sd	ra,56(sp)
 582:	f822                	sd	s0,48(sp)
 584:	f426                	sd	s1,40(sp)
 586:	f04a                	sd	s2,32(sp)
 588:	ec4e                	sd	s3,24(sp)
 58a:	0080                	addi	s0,sp,64
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 58c:	c299                	beqz	a3,592 <printint+0x14>
 58e:	0005cd63          	bltz	a1,5a8 <printint+0x2a>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 592:	2581                	sext.w	a1,a1
  neg = 0;
 594:	4301                	li	t1,0
 596:	fc040713          	addi	a4,s0,-64
  }

  i = 0;
 59a:	4801                	li	a6,0
  do{
    buf[i++] = digits[x % base];
 59c:	2601                	sext.w	a2,a2
 59e:	00000897          	auipc	a7,0x0
 5a2:	4a288893          	addi	a7,a7,1186 # a40 <digits>
 5a6:	a801                	j	5b6 <printint+0x38>
    x = -xx;
 5a8:	40b005bb          	negw	a1,a1
 5ac:	2581                	sext.w	a1,a1
    neg = 1;
 5ae:	4305                	li	t1,1
    x = -xx;
 5b0:	b7dd                	j	596 <printint+0x18>
  }while((x /= base) != 0);
 5b2:	85be                	mv	a1,a5
    buf[i++] = digits[x % base];
 5b4:	8836                	mv	a6,a3
 5b6:	0018069b          	addiw	a3,a6,1
 5ba:	02c5f7bb          	remuw	a5,a1,a2
 5be:	1782                	slli	a5,a5,0x20
 5c0:	9381                	srli	a5,a5,0x20
 5c2:	97c6                	add	a5,a5,a7
 5c4:	0007c783          	lbu	a5,0(a5)
 5c8:	00f70023          	sb	a5,0(a4)
  }while((x /= base) != 0);
 5cc:	0705                	addi	a4,a4,1
 5ce:	02c5d7bb          	divuw	a5,a1,a2
 5d2:	fec5f0e3          	bgeu	a1,a2,5b2 <printint+0x34>
  if(neg)
 5d6:	00030b63          	beqz	t1,5ec <printint+0x6e>
    buf[i++] = '-';
 5da:	fd040793          	addi	a5,s0,-48
 5de:	96be                	add	a3,a3,a5
 5e0:	02d00793          	li	a5,45
 5e4:	fef68823          	sb	a5,-16(a3)
 5e8:	0028069b          	addiw	a3,a6,2

  while(--i >= 0)
 5ec:	02d05963          	blez	a3,61e <printint+0xa0>
 5f0:	89aa                	mv	s3,a0
 5f2:	fc040793          	addi	a5,s0,-64
 5f6:	00d784b3          	add	s1,a5,a3
 5fa:	fff78913          	addi	s2,a5,-1
 5fe:	9936                	add	s2,s2,a3
 600:	36fd                	addiw	a3,a3,-1
 602:	1682                	slli	a3,a3,0x20
 604:	9281                	srli	a3,a3,0x20
 606:	40d90933          	sub	s2,s2,a3
    putc(fd, buf[i]);
 60a:	fff4c583          	lbu	a1,-1(s1)
 60e:	854e                	mv	a0,s3
 610:	00000097          	auipc	ra,0x0
 614:	f4c080e7          	jalr	-180(ra) # 55c <putc>
  while(--i >= 0)
 618:	14fd                	addi	s1,s1,-1
 61a:	ff2498e3          	bne	s1,s2,60a <printint+0x8c>
}
 61e:	70e2                	ld	ra,56(sp)
 620:	7442                	ld	s0,48(sp)
 622:	74a2                	ld	s1,40(sp)
 624:	7902                	ld	s2,32(sp)
 626:	69e2                	ld	s3,24(sp)
 628:	6121                	addi	sp,sp,64
 62a:	8082                	ret

000000000000062c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 62c:	7119                	addi	sp,sp,-128
 62e:	fc86                	sd	ra,120(sp)
 630:	f8a2                	sd	s0,112(sp)
 632:	f4a6                	sd	s1,104(sp)
 634:	f0ca                	sd	s2,96(sp)
 636:	ecce                	sd	s3,88(sp)
 638:	e8d2                	sd	s4,80(sp)
 63a:	e4d6                	sd	s5,72(sp)
 63c:	e0da                	sd	s6,64(sp)
 63e:	fc5e                	sd	s7,56(sp)
 640:	f862                	sd	s8,48(sp)
 642:	f466                	sd	s9,40(sp)
 644:	f06a                	sd	s10,32(sp)
 646:	ec6e                	sd	s11,24(sp)
 648:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 64a:	0005c483          	lbu	s1,0(a1)
 64e:	18048d63          	beqz	s1,7e8 <vprintf+0x1bc>
 652:	8aaa                	mv	s5,a0
 654:	8b32                	mv	s6,a2
 656:	00158913          	addi	s2,a1,1
  state = 0;
 65a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 65c:	02500a13          	li	s4,37
      if(c == 'd'){
 660:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 664:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 668:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 66c:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 670:	00000b97          	auipc	s7,0x0
 674:	3d0b8b93          	addi	s7,s7,976 # a40 <digits>
 678:	a839                	j	696 <vprintf+0x6a>
        putc(fd, c);
 67a:	85a6                	mv	a1,s1
 67c:	8556                	mv	a0,s5
 67e:	00000097          	auipc	ra,0x0
 682:	ede080e7          	jalr	-290(ra) # 55c <putc>
 686:	a019                	j	68c <vprintf+0x60>
    } else if(state == '%'){
 688:	01498f63          	beq	s3,s4,6a6 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 68c:	0905                	addi	s2,s2,1
 68e:	fff94483          	lbu	s1,-1(s2)
 692:	14048b63          	beqz	s1,7e8 <vprintf+0x1bc>
    c = fmt[i] & 0xff;
 696:	0004879b          	sext.w	a5,s1
    if(state == 0){
 69a:	fe0997e3          	bnez	s3,688 <vprintf+0x5c>
      if(c == '%'){
 69e:	fd479ee3          	bne	a5,s4,67a <vprintf+0x4e>
        state = '%';
 6a2:	89be                	mv	s3,a5
 6a4:	b7e5                	j	68c <vprintf+0x60>
      if(c == 'd'){
 6a6:	05878063          	beq	a5,s8,6e6 <vprintf+0xba>
      } else if(c == 'l') {
 6aa:	05978c63          	beq	a5,s9,702 <vprintf+0xd6>
      } else if(c == 'x') {
 6ae:	07a78863          	beq	a5,s10,71e <vprintf+0xf2>
      } else if(c == 'p') {
 6b2:	09b78463          	beq	a5,s11,73a <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 6b6:	07300713          	li	a4,115
 6ba:	0ce78563          	beq	a5,a4,784 <vprintf+0x158>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6be:	06300713          	li	a4,99
 6c2:	0ee78c63          	beq	a5,a4,7ba <vprintf+0x18e>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 6c6:	11478663          	beq	a5,s4,7d2 <vprintf+0x1a6>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6ca:	85d2                	mv	a1,s4
 6cc:	8556                	mv	a0,s5
 6ce:	00000097          	auipc	ra,0x0
 6d2:	e8e080e7          	jalr	-370(ra) # 55c <putc>
        putc(fd, c);
 6d6:	85a6                	mv	a1,s1
 6d8:	8556                	mv	a0,s5
 6da:	00000097          	auipc	ra,0x0
 6de:	e82080e7          	jalr	-382(ra) # 55c <putc>
      }
      state = 0;
 6e2:	4981                	li	s3,0
 6e4:	b765                	j	68c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 6e6:	008b0493          	addi	s1,s6,8
 6ea:	4685                	li	a3,1
 6ec:	4629                	li	a2,10
 6ee:	000b2583          	lw	a1,0(s6)
 6f2:	8556                	mv	a0,s5
 6f4:	00000097          	auipc	ra,0x0
 6f8:	e8a080e7          	jalr	-374(ra) # 57e <printint>
 6fc:	8b26                	mv	s6,s1
      state = 0;
 6fe:	4981                	li	s3,0
 700:	b771                	j	68c <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 702:	008b0493          	addi	s1,s6,8
 706:	4681                	li	a3,0
 708:	4629                	li	a2,10
 70a:	000b2583          	lw	a1,0(s6)
 70e:	8556                	mv	a0,s5
 710:	00000097          	auipc	ra,0x0
 714:	e6e080e7          	jalr	-402(ra) # 57e <printint>
 718:	8b26                	mv	s6,s1
      state = 0;
 71a:	4981                	li	s3,0
 71c:	bf85                	j	68c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 71e:	008b0493          	addi	s1,s6,8
 722:	4681                	li	a3,0
 724:	4641                	li	a2,16
 726:	000b2583          	lw	a1,0(s6)
 72a:	8556                	mv	a0,s5
 72c:	00000097          	auipc	ra,0x0
 730:	e52080e7          	jalr	-430(ra) # 57e <printint>
 734:	8b26                	mv	s6,s1
      state = 0;
 736:	4981                	li	s3,0
 738:	bf91                	j	68c <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 73a:	008b0793          	addi	a5,s6,8
 73e:	f8f43423          	sd	a5,-120(s0)
 742:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 746:	03000593          	li	a1,48
 74a:	8556                	mv	a0,s5
 74c:	00000097          	auipc	ra,0x0
 750:	e10080e7          	jalr	-496(ra) # 55c <putc>
  putc(fd, 'x');
 754:	85ea                	mv	a1,s10
 756:	8556                	mv	a0,s5
 758:	00000097          	auipc	ra,0x0
 75c:	e04080e7          	jalr	-508(ra) # 55c <putc>
 760:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 762:	03c9d793          	srli	a5,s3,0x3c
 766:	97de                	add	a5,a5,s7
 768:	0007c583          	lbu	a1,0(a5)
 76c:	8556                	mv	a0,s5
 76e:	00000097          	auipc	ra,0x0
 772:	dee080e7          	jalr	-530(ra) # 55c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 776:	0992                	slli	s3,s3,0x4
 778:	34fd                	addiw	s1,s1,-1
 77a:	f4e5                	bnez	s1,762 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 77c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 780:	4981                	li	s3,0
 782:	b729                	j	68c <vprintf+0x60>
        s = va_arg(ap, char*);
 784:	008b0993          	addi	s3,s6,8
 788:	000b3483          	ld	s1,0(s6)
        if(s == 0)
 78c:	c085                	beqz	s1,7ac <vprintf+0x180>
        while(*s != 0){
 78e:	0004c583          	lbu	a1,0(s1)
 792:	c9a1                	beqz	a1,7e2 <vprintf+0x1b6>
          putc(fd, *s);
 794:	8556                	mv	a0,s5
 796:	00000097          	auipc	ra,0x0
 79a:	dc6080e7          	jalr	-570(ra) # 55c <putc>
          s++;
 79e:	0485                	addi	s1,s1,1
        while(*s != 0){
 7a0:	0004c583          	lbu	a1,0(s1)
 7a4:	f9e5                	bnez	a1,794 <vprintf+0x168>
        s = va_arg(ap, char*);
 7a6:	8b4e                	mv	s6,s3
      state = 0;
 7a8:	4981                	li	s3,0
 7aa:	b5cd                	j	68c <vprintf+0x60>
          s = "(null)";
 7ac:	00000497          	auipc	s1,0x0
 7b0:	2ac48493          	addi	s1,s1,684 # a58 <digits+0x18>
        while(*s != 0){
 7b4:	02800593          	li	a1,40
 7b8:	bff1                	j	794 <vprintf+0x168>
        putc(fd, va_arg(ap, uint));
 7ba:	008b0493          	addi	s1,s6,8
 7be:	000b4583          	lbu	a1,0(s6)
 7c2:	8556                	mv	a0,s5
 7c4:	00000097          	auipc	ra,0x0
 7c8:	d98080e7          	jalr	-616(ra) # 55c <putc>
 7cc:	8b26                	mv	s6,s1
      state = 0;
 7ce:	4981                	li	s3,0
 7d0:	bd75                	j	68c <vprintf+0x60>
        putc(fd, c);
 7d2:	85d2                	mv	a1,s4
 7d4:	8556                	mv	a0,s5
 7d6:	00000097          	auipc	ra,0x0
 7da:	d86080e7          	jalr	-634(ra) # 55c <putc>
      state = 0;
 7de:	4981                	li	s3,0
 7e0:	b575                	j	68c <vprintf+0x60>
        s = va_arg(ap, char*);
 7e2:	8b4e                	mv	s6,s3
      state = 0;
 7e4:	4981                	li	s3,0
 7e6:	b55d                	j	68c <vprintf+0x60>
    }
  }
}
 7e8:	70e6                	ld	ra,120(sp)
 7ea:	7446                	ld	s0,112(sp)
 7ec:	74a6                	ld	s1,104(sp)
 7ee:	7906                	ld	s2,96(sp)
 7f0:	69e6                	ld	s3,88(sp)
 7f2:	6a46                	ld	s4,80(sp)
 7f4:	6aa6                	ld	s5,72(sp)
 7f6:	6b06                	ld	s6,64(sp)
 7f8:	7be2                	ld	s7,56(sp)
 7fa:	7c42                	ld	s8,48(sp)
 7fc:	7ca2                	ld	s9,40(sp)
 7fe:	7d02                	ld	s10,32(sp)
 800:	6de2                	ld	s11,24(sp)
 802:	6109                	addi	sp,sp,128
 804:	8082                	ret

0000000000000806 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 806:	715d                	addi	sp,sp,-80
 808:	ec06                	sd	ra,24(sp)
 80a:	e822                	sd	s0,16(sp)
 80c:	1000                	addi	s0,sp,32
 80e:	e010                	sd	a2,0(s0)
 810:	e414                	sd	a3,8(s0)
 812:	e818                	sd	a4,16(s0)
 814:	ec1c                	sd	a5,24(s0)
 816:	03043023          	sd	a6,32(s0)
 81a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 81e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 822:	8622                	mv	a2,s0
 824:	00000097          	auipc	ra,0x0
 828:	e08080e7          	jalr	-504(ra) # 62c <vprintf>
}
 82c:	60e2                	ld	ra,24(sp)
 82e:	6442                	ld	s0,16(sp)
 830:	6161                	addi	sp,sp,80
 832:	8082                	ret

0000000000000834 <printf>:

void
printf(const char *fmt, ...)
{
 834:	711d                	addi	sp,sp,-96
 836:	ec06                	sd	ra,24(sp)
 838:	e822                	sd	s0,16(sp)
 83a:	1000                	addi	s0,sp,32
 83c:	e40c                	sd	a1,8(s0)
 83e:	e810                	sd	a2,16(s0)
 840:	ec14                	sd	a3,24(s0)
 842:	f018                	sd	a4,32(s0)
 844:	f41c                	sd	a5,40(s0)
 846:	03043823          	sd	a6,48(s0)
 84a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 84e:	00840613          	addi	a2,s0,8
 852:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 856:	85aa                	mv	a1,a0
 858:	4505                	li	a0,1
 85a:	00000097          	auipc	ra,0x0
 85e:	dd2080e7          	jalr	-558(ra) # 62c <vprintf>
}
 862:	60e2                	ld	ra,24(sp)
 864:	6442                	ld	s0,16(sp)
 866:	6125                	addi	sp,sp,96
 868:	8082                	ret

000000000000086a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 86a:	1141                	addi	sp,sp,-16
 86c:	e422                	sd	s0,8(sp)
 86e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 870:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 874:	00000797          	auipc	a5,0x0
 878:	78c78793          	addi	a5,a5,1932 # 1000 <freep>
 87c:	639c                	ld	a5,0(a5)
 87e:	a805                	j	8ae <free+0x44>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 880:	4618                	lw	a4,8(a2)
 882:	9db9                	addw	a1,a1,a4
 884:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 888:	6398                	ld	a4,0(a5)
 88a:	6318                	ld	a4,0(a4)
 88c:	fee53823          	sd	a4,-16(a0)
 890:	a091                	j	8d4 <free+0x6a>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 892:	ff852703          	lw	a4,-8(a0)
 896:	9e39                	addw	a2,a2,a4
 898:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 89a:	ff053703          	ld	a4,-16(a0)
 89e:	e398                	sd	a4,0(a5)
 8a0:	a099                	j	8e6 <free+0x7c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a2:	6398                	ld	a4,0(a5)
 8a4:	00e7e463          	bltu	a5,a4,8ac <free+0x42>
 8a8:	00e6ea63          	bltu	a3,a4,8bc <free+0x52>
{
 8ac:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ae:	fed7fae3          	bgeu	a5,a3,8a2 <free+0x38>
 8b2:	6398                	ld	a4,0(a5)
 8b4:	00e6e463          	bltu	a3,a4,8bc <free+0x52>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8b8:	fee7eae3          	bltu	a5,a4,8ac <free+0x42>
  if(bp + bp->s.size == p->s.ptr){
 8bc:	ff852583          	lw	a1,-8(a0)
 8c0:	6390                	ld	a2,0(a5)
 8c2:	02059713          	slli	a4,a1,0x20
 8c6:	9301                	srli	a4,a4,0x20
 8c8:	0712                	slli	a4,a4,0x4
 8ca:	9736                	add	a4,a4,a3
 8cc:	fae60ae3          	beq	a2,a4,880 <free+0x16>
    bp->s.ptr = p->s.ptr;
 8d0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8d4:	4790                	lw	a2,8(a5)
 8d6:	02061713          	slli	a4,a2,0x20
 8da:	9301                	srli	a4,a4,0x20
 8dc:	0712                	slli	a4,a4,0x4
 8de:	973e                	add	a4,a4,a5
 8e0:	fae689e3          	beq	a3,a4,892 <free+0x28>
  } else
    p->s.ptr = bp;
 8e4:	e394                	sd	a3,0(a5)
  freep = p;
 8e6:	00000717          	auipc	a4,0x0
 8ea:	70f73d23          	sd	a5,1818(a4) # 1000 <freep>
}
 8ee:	6422                	ld	s0,8(sp)
 8f0:	0141                	addi	sp,sp,16
 8f2:	8082                	ret

00000000000008f4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8f4:	7139                	addi	sp,sp,-64
 8f6:	fc06                	sd	ra,56(sp)
 8f8:	f822                	sd	s0,48(sp)
 8fa:	f426                	sd	s1,40(sp)
 8fc:	f04a                	sd	s2,32(sp)
 8fe:	ec4e                	sd	s3,24(sp)
 900:	e852                	sd	s4,16(sp)
 902:	e456                	sd	s5,8(sp)
 904:	e05a                	sd	s6,0(sp)
 906:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 908:	02051993          	slli	s3,a0,0x20
 90c:	0209d993          	srli	s3,s3,0x20
 910:	09bd                	addi	s3,s3,15
 912:	0049d993          	srli	s3,s3,0x4
 916:	2985                	addiw	s3,s3,1
 918:	0009891b          	sext.w	s2,s3
  if((prevp = freep) == 0){
 91c:	00000797          	auipc	a5,0x0
 920:	6e478793          	addi	a5,a5,1764 # 1000 <freep>
 924:	6388                	ld	a0,0(a5)
 926:	c515                	beqz	a0,952 <malloc+0x5e>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 928:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 92a:	4798                	lw	a4,8(a5)
 92c:	03277f63          	bgeu	a4,s2,96a <malloc+0x76>
 930:	8a4e                	mv	s4,s3
 932:	0009871b          	sext.w	a4,s3
 936:	6685                	lui	a3,0x1
 938:	00d77363          	bgeu	a4,a3,93e <malloc+0x4a>
 93c:	6a05                	lui	s4,0x1
 93e:	000a0a9b          	sext.w	s5,s4
  p = sbrk(nu * sizeof(Header));
 942:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 946:	00000497          	auipc	s1,0x0
 94a:	6ba48493          	addi	s1,s1,1722 # 1000 <freep>
  if(p == (char*)-1)
 94e:	5b7d                	li	s6,-1
 950:	a885                	j	9c0 <malloc+0xcc>
    base.s.ptr = freep = prevp = &base;
 952:	00001797          	auipc	a5,0x1
 956:	8be78793          	addi	a5,a5,-1858 # 1210 <base>
 95a:	00000717          	auipc	a4,0x0
 95e:	6af73323          	sd	a5,1702(a4) # 1000 <freep>
 962:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 964:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 968:	b7e1                	j	930 <malloc+0x3c>
      if(p->s.size == nunits)
 96a:	02e90b63          	beq	s2,a4,9a0 <malloc+0xac>
        p->s.size -= nunits;
 96e:	4137073b          	subw	a4,a4,s3
 972:	c798                	sw	a4,8(a5)
        p += p->s.size;
 974:	1702                	slli	a4,a4,0x20
 976:	9301                	srli	a4,a4,0x20
 978:	0712                	slli	a4,a4,0x4
 97a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 97c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 980:	00000717          	auipc	a4,0x0
 984:	68a73023          	sd	a0,1664(a4) # 1000 <freep>
      return (void*)(p + 1);
 988:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 98c:	70e2                	ld	ra,56(sp)
 98e:	7442                	ld	s0,48(sp)
 990:	74a2                	ld	s1,40(sp)
 992:	7902                	ld	s2,32(sp)
 994:	69e2                	ld	s3,24(sp)
 996:	6a42                	ld	s4,16(sp)
 998:	6aa2                	ld	s5,8(sp)
 99a:	6b02                	ld	s6,0(sp)
 99c:	6121                	addi	sp,sp,64
 99e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9a0:	6398                	ld	a4,0(a5)
 9a2:	e118                	sd	a4,0(a0)
 9a4:	bff1                	j	980 <malloc+0x8c>
  hp->s.size = nu;
 9a6:	01552423          	sw	s5,8(a0)
  free((void*)(hp + 1));
 9aa:	0541                	addi	a0,a0,16
 9ac:	00000097          	auipc	ra,0x0
 9b0:	ebe080e7          	jalr	-322(ra) # 86a <free>
  return freep;
 9b4:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 9b6:	d979                	beqz	a0,98c <malloc+0x98>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9b8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9ba:	4798                	lw	a4,8(a5)
 9bc:	fb2777e3          	bgeu	a4,s2,96a <malloc+0x76>
    if(p == freep)
 9c0:	6098                	ld	a4,0(s1)
 9c2:	853e                	mv	a0,a5
 9c4:	fef71ae3          	bne	a4,a5,9b8 <malloc+0xc4>
  p = sbrk(nu * sizeof(Header));
 9c8:	8552                	mv	a0,s4
 9ca:	00000097          	auipc	ra,0x0
 9ce:	b7a080e7          	jalr	-1158(ra) # 544 <sbrk>
  if(p == (char*)-1)
 9d2:	fd651ae3          	bne	a0,s6,9a6 <malloc+0xb2>
        return 0;
 9d6:	4501                	li	a0,0
 9d8:	bf55                	j	98c <malloc+0x98>
