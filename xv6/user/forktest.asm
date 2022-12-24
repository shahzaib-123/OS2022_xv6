
user/_forktest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print>:

#define N  1000

void
print(const char *s)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	84aa                	mv	s1,a0
  write(1, s, strlen(s));
   c:	00000097          	auipc	ra,0x0
  10:	17c080e7          	jalr	380(ra) # 188 <strlen>
  14:	0005061b          	sext.w	a2,a0
  18:	85a6                	mv	a1,s1
  1a:	4505                	li	a0,1
  1c:	00000097          	auipc	ra,0x0
  20:	3cc080e7          	jalr	972(ra) # 3e8 <write>
}
  24:	60e2                	ld	ra,24(sp)
  26:	6442                	ld	s0,16(sp)
  28:	64a2                	ld	s1,8(sp)
  2a:	6105                	addi	sp,sp,32
  2c:	8082                	ret

000000000000002e <forktest>:

void
forktest(void)
{
  2e:	1101                	addi	sp,sp,-32
  30:	ec06                	sd	ra,24(sp)
  32:	e822                	sd	s0,16(sp)
  34:	e426                	sd	s1,8(sp)
  36:	e04a                	sd	s2,0(sp)
  38:	1000                	addi	s0,sp,32
  int n, pid;

  print("fork test\n");
  3a:	00000517          	auipc	a0,0x0
  3e:	42e50513          	addi	a0,a0,1070 # 468 <uptime+0x8>
  42:	00000097          	auipc	ra,0x0
  46:	fbe080e7          	jalr	-66(ra) # 0 <print>

  for(n=0; n<N; n++){
  4a:	4481                	li	s1,0
  4c:	3e800913          	li	s2,1000
    pid = fork();
  50:	00000097          	auipc	ra,0x0
  54:	370080e7          	jalr	880(ra) # 3c0 <fork>
    if(pid < 0)
  58:	02054763          	bltz	a0,86 <forktest+0x58>
      break;
    if(pid == 0)
  5c:	c10d                	beqz	a0,7e <forktest+0x50>
  for(n=0; n<N; n++){
  5e:	2485                	addiw	s1,s1,1
  60:	ff2498e3          	bne	s1,s2,50 <forktest+0x22>
      exit(0);
  }

  if(n == N){
    print("fork claimed to work N times!\n");
  64:	00000517          	auipc	a0,0x0
  68:	41450513          	addi	a0,a0,1044 # 478 <uptime+0x18>
  6c:	00000097          	auipc	ra,0x0
  70:	f94080e7          	jalr	-108(ra) # 0 <print>
    exit(1);
  74:	4505                	li	a0,1
  76:	00000097          	auipc	ra,0x0
  7a:	352080e7          	jalr	850(ra) # 3c8 <exit>
      exit(0);
  7e:	00000097          	auipc	ra,0x0
  82:	34a080e7          	jalr	842(ra) # 3c8 <exit>
  if(n == N){
  86:	3e800793          	li	a5,1000
  8a:	fcf48de3          	beq	s1,a5,64 <forktest+0x36>
  }

  for(; n > 0; n--){
  8e:	00905b63          	blez	s1,a4 <forktest+0x76>
    if(wait(0) < 0){
  92:	4501                	li	a0,0
  94:	00000097          	auipc	ra,0x0
  98:	33c080e7          	jalr	828(ra) # 3d0 <wait>
  9c:	02054a63          	bltz	a0,d0 <forktest+0xa2>
  for(; n > 0; n--){
  a0:	34fd                	addiw	s1,s1,-1
  a2:	f8e5                	bnez	s1,92 <forktest+0x64>
      print("wait stopped early\n");
      exit(1);
    }
  }

  if(wait(0) != -1){
  a4:	4501                	li	a0,0
  a6:	00000097          	auipc	ra,0x0
  aa:	32a080e7          	jalr	810(ra) # 3d0 <wait>
  ae:	57fd                	li	a5,-1
  b0:	02f51d63          	bne	a0,a5,ea <forktest+0xbc>
    print("wait got too many\n");
    exit(1);
  }

  print("fork test OK\n");
  b4:	00000517          	auipc	a0,0x0
  b8:	41450513          	addi	a0,a0,1044 # 4c8 <uptime+0x68>
  bc:	00000097          	auipc	ra,0x0
  c0:	f44080e7          	jalr	-188(ra) # 0 <print>
}
  c4:	60e2                	ld	ra,24(sp)
  c6:	6442                	ld	s0,16(sp)
  c8:	64a2                	ld	s1,8(sp)
  ca:	6902                	ld	s2,0(sp)
  cc:	6105                	addi	sp,sp,32
  ce:	8082                	ret
      print("wait stopped early\n");
  d0:	00000517          	auipc	a0,0x0
  d4:	3c850513          	addi	a0,a0,968 # 498 <uptime+0x38>
  d8:	00000097          	auipc	ra,0x0
  dc:	f28080e7          	jalr	-216(ra) # 0 <print>
      exit(1);
  e0:	4505                	li	a0,1
  e2:	00000097          	auipc	ra,0x0
  e6:	2e6080e7          	jalr	742(ra) # 3c8 <exit>
    print("wait got too many\n");
  ea:	00000517          	auipc	a0,0x0
  ee:	3c650513          	addi	a0,a0,966 # 4b0 <uptime+0x50>
  f2:	00000097          	auipc	ra,0x0
  f6:	f0e080e7          	jalr	-242(ra) # 0 <print>
    exit(1);
  fa:	4505                	li	a0,1
  fc:	00000097          	auipc	ra,0x0
 100:	2cc080e7          	jalr	716(ra) # 3c8 <exit>

0000000000000104 <main>:

int
main(void)
{
 104:	1141                	addi	sp,sp,-16
 106:	e406                	sd	ra,8(sp)
 108:	e022                	sd	s0,0(sp)
 10a:	0800                	addi	s0,sp,16
  forktest();
 10c:	00000097          	auipc	ra,0x0
 110:	f22080e7          	jalr	-222(ra) # 2e <forktest>
  exit(0);
 114:	4501                	li	a0,0
 116:	00000097          	auipc	ra,0x0
 11a:	2b2080e7          	jalr	690(ra) # 3c8 <exit>

000000000000011e <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 11e:	1141                	addi	sp,sp,-16
 120:	e406                	sd	ra,8(sp)
 122:	e022                	sd	s0,0(sp)
 124:	0800                	addi	s0,sp,16
  extern int main();
  main();
 126:	00000097          	auipc	ra,0x0
 12a:	fde080e7          	jalr	-34(ra) # 104 <main>
  exit(0);
 12e:	4501                	li	a0,0
 130:	00000097          	auipc	ra,0x0
 134:	298080e7          	jalr	664(ra) # 3c8 <exit>

0000000000000138 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 138:	1141                	addi	sp,sp,-16
 13a:	e422                	sd	s0,8(sp)
 13c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 13e:	87aa                	mv	a5,a0
 140:	0585                	addi	a1,a1,1
 142:	0785                	addi	a5,a5,1
 144:	fff5c703          	lbu	a4,-1(a1)
 148:	fee78fa3          	sb	a4,-1(a5)
 14c:	fb75                	bnez	a4,140 <strcpy+0x8>
    ;
  return os;
}
 14e:	6422                	ld	s0,8(sp)
 150:	0141                	addi	sp,sp,16
 152:	8082                	ret

0000000000000154 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 154:	1141                	addi	sp,sp,-16
 156:	e422                	sd	s0,8(sp)
 158:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 15a:	00054783          	lbu	a5,0(a0)
 15e:	cf91                	beqz	a5,17a <strcmp+0x26>
 160:	0005c703          	lbu	a4,0(a1)
 164:	00f71b63          	bne	a4,a5,17a <strcmp+0x26>
    p++, q++;
 168:	0505                	addi	a0,a0,1
 16a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 16c:	00054783          	lbu	a5,0(a0)
 170:	c789                	beqz	a5,17a <strcmp+0x26>
 172:	0005c703          	lbu	a4,0(a1)
 176:	fef709e3          	beq	a4,a5,168 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 17a:	0005c503          	lbu	a0,0(a1)
}
 17e:	40a7853b          	subw	a0,a5,a0
 182:	6422                	ld	s0,8(sp)
 184:	0141                	addi	sp,sp,16
 186:	8082                	ret

0000000000000188 <strlen>:

uint
strlen(const char *s)
{
 188:	1141                	addi	sp,sp,-16
 18a:	e422                	sd	s0,8(sp)
 18c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 18e:	00054783          	lbu	a5,0(a0)
 192:	cf91                	beqz	a5,1ae <strlen+0x26>
 194:	0505                	addi	a0,a0,1
 196:	87aa                	mv	a5,a0
 198:	4685                	li	a3,1
 19a:	9e89                	subw	a3,a3,a0
 19c:	00f6853b          	addw	a0,a3,a5
 1a0:	0785                	addi	a5,a5,1
 1a2:	fff7c703          	lbu	a4,-1(a5)
 1a6:	fb7d                	bnez	a4,19c <strlen+0x14>
    ;
  return n;
}
 1a8:	6422                	ld	s0,8(sp)
 1aa:	0141                	addi	sp,sp,16
 1ac:	8082                	ret
  for(n = 0; s[n]; n++)
 1ae:	4501                	li	a0,0
 1b0:	bfe5                	j	1a8 <strlen+0x20>

00000000000001b2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1b2:	1141                	addi	sp,sp,-16
 1b4:	e422                	sd	s0,8(sp)
 1b6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1b8:	ce09                	beqz	a2,1d2 <memset+0x20>
 1ba:	87aa                	mv	a5,a0
 1bc:	fff6071b          	addiw	a4,a2,-1
 1c0:	1702                	slli	a4,a4,0x20
 1c2:	9301                	srli	a4,a4,0x20
 1c4:	0705                	addi	a4,a4,1
 1c6:	972a                	add	a4,a4,a0
    cdst[i] = c;
 1c8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1cc:	0785                	addi	a5,a5,1
 1ce:	fee79de3          	bne	a5,a4,1c8 <memset+0x16>
  }
  return dst;
}
 1d2:	6422                	ld	s0,8(sp)
 1d4:	0141                	addi	sp,sp,16
 1d6:	8082                	ret

00000000000001d8 <strchr>:

char*
strchr(const char *s, char c)
{
 1d8:	1141                	addi	sp,sp,-16
 1da:	e422                	sd	s0,8(sp)
 1dc:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1de:	00054783          	lbu	a5,0(a0)
 1e2:	cf91                	beqz	a5,1fe <strchr+0x26>
    if(*s == c)
 1e4:	00f58a63          	beq	a1,a5,1f8 <strchr+0x20>
  for(; *s; s++)
 1e8:	0505                	addi	a0,a0,1
 1ea:	00054783          	lbu	a5,0(a0)
 1ee:	c781                	beqz	a5,1f6 <strchr+0x1e>
    if(*s == c)
 1f0:	feb79ce3          	bne	a5,a1,1e8 <strchr+0x10>
 1f4:	a011                	j	1f8 <strchr+0x20>
      return (char*)s;
  return 0;
 1f6:	4501                	li	a0,0
}
 1f8:	6422                	ld	s0,8(sp)
 1fa:	0141                	addi	sp,sp,16
 1fc:	8082                	ret
  return 0;
 1fe:	4501                	li	a0,0
 200:	bfe5                	j	1f8 <strchr+0x20>

0000000000000202 <gets>:

char*
gets(char *buf, int max)
{
 202:	711d                	addi	sp,sp,-96
 204:	ec86                	sd	ra,88(sp)
 206:	e8a2                	sd	s0,80(sp)
 208:	e4a6                	sd	s1,72(sp)
 20a:	e0ca                	sd	s2,64(sp)
 20c:	fc4e                	sd	s3,56(sp)
 20e:	f852                	sd	s4,48(sp)
 210:	f456                	sd	s5,40(sp)
 212:	f05a                	sd	s6,32(sp)
 214:	ec5e                	sd	s7,24(sp)
 216:	1080                	addi	s0,sp,96
 218:	8baa                	mv	s7,a0
 21a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 21c:	892a                	mv	s2,a0
 21e:	4981                	li	s3,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 220:	4aa9                	li	s5,10
 222:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 224:	0019849b          	addiw	s1,s3,1
 228:	0344d863          	bge	s1,s4,258 <gets+0x56>
    cc = read(0, &c, 1);
 22c:	4605                	li	a2,1
 22e:	faf40593          	addi	a1,s0,-81
 232:	4501                	li	a0,0
 234:	00000097          	auipc	ra,0x0
 238:	1ac080e7          	jalr	428(ra) # 3e0 <read>
    if(cc < 1)
 23c:	00a05e63          	blez	a0,258 <gets+0x56>
    buf[i++] = c;
 240:	faf44783          	lbu	a5,-81(s0)
 244:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 248:	01578763          	beq	a5,s5,256 <gets+0x54>
 24c:	0905                	addi	s2,s2,1
  for(i=0; i+1 < max; ){
 24e:	89a6                	mv	s3,s1
    if(c == '\n' || c == '\r')
 250:	fd679ae3          	bne	a5,s6,224 <gets+0x22>
 254:	a011                	j	258 <gets+0x56>
  for(i=0; i+1 < max; ){
 256:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 258:	99de                	add	s3,s3,s7
 25a:	00098023          	sb	zero,0(s3)
  return buf;
}
 25e:	855e                	mv	a0,s7
 260:	60e6                	ld	ra,88(sp)
 262:	6446                	ld	s0,80(sp)
 264:	64a6                	ld	s1,72(sp)
 266:	6906                	ld	s2,64(sp)
 268:	79e2                	ld	s3,56(sp)
 26a:	7a42                	ld	s4,48(sp)
 26c:	7aa2                	ld	s5,40(sp)
 26e:	7b02                	ld	s6,32(sp)
 270:	6be2                	ld	s7,24(sp)
 272:	6125                	addi	sp,sp,96
 274:	8082                	ret

0000000000000276 <stat>:

int
stat(const char *n, struct stat *st)
{
 276:	1101                	addi	sp,sp,-32
 278:	ec06                	sd	ra,24(sp)
 27a:	e822                	sd	s0,16(sp)
 27c:	e426                	sd	s1,8(sp)
 27e:	e04a                	sd	s2,0(sp)
 280:	1000                	addi	s0,sp,32
 282:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 284:	4581                	li	a1,0
 286:	00000097          	auipc	ra,0x0
 28a:	182080e7          	jalr	386(ra) # 408 <open>
  if(fd < 0)
 28e:	02054563          	bltz	a0,2b8 <stat+0x42>
 292:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 294:	85ca                	mv	a1,s2
 296:	00000097          	auipc	ra,0x0
 29a:	18a080e7          	jalr	394(ra) # 420 <fstat>
 29e:	892a                	mv	s2,a0
  close(fd);
 2a0:	8526                	mv	a0,s1
 2a2:	00000097          	auipc	ra,0x0
 2a6:	14e080e7          	jalr	334(ra) # 3f0 <close>
  return r;
}
 2aa:	854a                	mv	a0,s2
 2ac:	60e2                	ld	ra,24(sp)
 2ae:	6442                	ld	s0,16(sp)
 2b0:	64a2                	ld	s1,8(sp)
 2b2:	6902                	ld	s2,0(sp)
 2b4:	6105                	addi	sp,sp,32
 2b6:	8082                	ret
    return -1;
 2b8:	597d                	li	s2,-1
 2ba:	bfc5                	j	2aa <stat+0x34>

00000000000002bc <atoi>:

int
atoi(const char *s)
{
 2bc:	1141                	addi	sp,sp,-16
 2be:	e422                	sd	s0,8(sp)
 2c0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2c2:	00054683          	lbu	a3,0(a0)
 2c6:	fd06879b          	addiw	a5,a3,-48
 2ca:	0ff7f793          	andi	a5,a5,255
 2ce:	4725                	li	a4,9
 2d0:	02f76963          	bltu	a4,a5,302 <atoi+0x46>
 2d4:	862a                	mv	a2,a0
  n = 0;
 2d6:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 2d8:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 2da:	0605                	addi	a2,a2,1
 2dc:	0025179b          	slliw	a5,a0,0x2
 2e0:	9fa9                	addw	a5,a5,a0
 2e2:	0017979b          	slliw	a5,a5,0x1
 2e6:	9fb5                	addw	a5,a5,a3
 2e8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2ec:	00064683          	lbu	a3,0(a2)
 2f0:	fd06871b          	addiw	a4,a3,-48
 2f4:	0ff77713          	andi	a4,a4,255
 2f8:	fee5f1e3          	bgeu	a1,a4,2da <atoi+0x1e>
  return n;
}
 2fc:	6422                	ld	s0,8(sp)
 2fe:	0141                	addi	sp,sp,16
 300:	8082                	ret
  n = 0;
 302:	4501                	li	a0,0
 304:	bfe5                	j	2fc <atoi+0x40>

0000000000000306 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 306:	1141                	addi	sp,sp,-16
 308:	e422                	sd	s0,8(sp)
 30a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 30c:	02b57663          	bgeu	a0,a1,338 <memmove+0x32>
    while(n-- > 0)
 310:	02c05163          	blez	a2,332 <memmove+0x2c>
 314:	fff6079b          	addiw	a5,a2,-1
 318:	1782                	slli	a5,a5,0x20
 31a:	9381                	srli	a5,a5,0x20
 31c:	0785                	addi	a5,a5,1
 31e:	97aa                	add	a5,a5,a0
  dst = vdst;
 320:	872a                	mv	a4,a0
      *dst++ = *src++;
 322:	0585                	addi	a1,a1,1
 324:	0705                	addi	a4,a4,1
 326:	fff5c683          	lbu	a3,-1(a1)
 32a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 32e:	fee79ae3          	bne	a5,a4,322 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 332:	6422                	ld	s0,8(sp)
 334:	0141                	addi	sp,sp,16
 336:	8082                	ret
    dst += n;
 338:	00c50733          	add	a4,a0,a2
    src += n;
 33c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 33e:	fec05ae3          	blez	a2,332 <memmove+0x2c>
 342:	fff6079b          	addiw	a5,a2,-1
 346:	1782                	slli	a5,a5,0x20
 348:	9381                	srli	a5,a5,0x20
 34a:	fff7c793          	not	a5,a5
 34e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 350:	15fd                	addi	a1,a1,-1
 352:	177d                	addi	a4,a4,-1
 354:	0005c683          	lbu	a3,0(a1)
 358:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 35c:	fef71ae3          	bne	a4,a5,350 <memmove+0x4a>
 360:	bfc9                	j	332 <memmove+0x2c>

0000000000000362 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 362:	1141                	addi	sp,sp,-16
 364:	e422                	sd	s0,8(sp)
 366:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 368:	ce15                	beqz	a2,3a4 <memcmp+0x42>
 36a:	fff6069b          	addiw	a3,a2,-1
    if (*p1 != *p2) {
 36e:	00054783          	lbu	a5,0(a0)
 372:	0005c703          	lbu	a4,0(a1)
 376:	02e79063          	bne	a5,a4,396 <memcmp+0x34>
 37a:	1682                	slli	a3,a3,0x20
 37c:	9281                	srli	a3,a3,0x20
 37e:	0685                	addi	a3,a3,1
 380:	96aa                	add	a3,a3,a0
      return *p1 - *p2;
    }
    p1++;
 382:	0505                	addi	a0,a0,1
    p2++;
 384:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 386:	00d50d63          	beq	a0,a3,3a0 <memcmp+0x3e>
    if (*p1 != *p2) {
 38a:	00054783          	lbu	a5,0(a0)
 38e:	0005c703          	lbu	a4,0(a1)
 392:	fee788e3          	beq	a5,a4,382 <memcmp+0x20>
      return *p1 - *p2;
 396:	40e7853b          	subw	a0,a5,a4
  }
  return 0;
}
 39a:	6422                	ld	s0,8(sp)
 39c:	0141                	addi	sp,sp,16
 39e:	8082                	ret
  return 0;
 3a0:	4501                	li	a0,0
 3a2:	bfe5                	j	39a <memcmp+0x38>
 3a4:	4501                	li	a0,0
 3a6:	bfd5                	j	39a <memcmp+0x38>

00000000000003a8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3a8:	1141                	addi	sp,sp,-16
 3aa:	e406                	sd	ra,8(sp)
 3ac:	e022                	sd	s0,0(sp)
 3ae:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3b0:	00000097          	auipc	ra,0x0
 3b4:	f56080e7          	jalr	-170(ra) # 306 <memmove>
}
 3b8:	60a2                	ld	ra,8(sp)
 3ba:	6402                	ld	s0,0(sp)
 3bc:	0141                	addi	sp,sp,16
 3be:	8082                	ret

00000000000003c0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3c0:	4885                	li	a7,1
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3c8:	4889                	li	a7,2
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3d0:	488d                	li	a7,3
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3d8:	4891                	li	a7,4
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <read>:
.global read
read:
 li a7, SYS_read
 3e0:	4895                	li	a7,5
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <write>:
.global write
write:
 li a7, SYS_write
 3e8:	48c1                	li	a7,16
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <close>:
.global close
close:
 li a7, SYS_close
 3f0:	48d5                	li	a7,21
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3f8:	4899                	li	a7,6
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <exec>:
.global exec
exec:
 li a7, SYS_exec
 400:	489d                	li	a7,7
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <open>:
.global open
open:
 li a7, SYS_open
 408:	48bd                	li	a7,15
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 410:	48c5                	li	a7,17
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 418:	48c9                	li	a7,18
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 420:	48a1                	li	a7,8
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <link>:
.global link
link:
 li a7, SYS_link
 428:	48cd                	li	a7,19
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 430:	48d1                	li	a7,20
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 438:	48a5                	li	a7,9
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <dup>:
.global dup
dup:
 li a7, SYS_dup
 440:	48a9                	li	a7,10
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 448:	48ad                	li	a7,11
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 450:	48b1                	li	a7,12
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 458:	48b5                	li	a7,13
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 460:	48b9                	li	a7,14
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret
