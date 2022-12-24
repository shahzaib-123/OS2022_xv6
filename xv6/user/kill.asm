
user/_kill:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char **argv)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
   c:	4785                	li	a5,1
   e:	02a7dd63          	bge	a5,a0,48 <main+0x48>
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	1902                	slli	s2,s2,0x20
  1c:	02095913          	srli	s2,s2,0x20
  20:	090e                	slli	s2,s2,0x3
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "usage: kill pid...\n");
    exit(1);
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
  26:	6088                	ld	a0,0(s1)
  28:	00000097          	auipc	ra,0x0
  2c:	1da080e7          	jalr	474(ra) # 202 <atoi>
  30:	00000097          	auipc	ra,0x0
  34:	30e080e7          	jalr	782(ra) # 33e <kill>
  for(i=1; i<argc; i++)
  38:	04a1                	addi	s1,s1,8
  3a:	ff2496e3          	bne	s1,s2,26 <main+0x26>
  exit(0);
  3e:	4501                	li	a0,0
  40:	00000097          	auipc	ra,0x0
  44:	2ce080e7          	jalr	718(ra) # 30e <exit>
    fprintf(2, "usage: kill pid...\n");
  48:	00000597          	auipc	a1,0x0
  4c:	7e858593          	addi	a1,a1,2024 # 830 <malloc+0xea>
  50:	4509                	li	a0,2
  52:	00000097          	auipc	ra,0x0
  56:	606080e7          	jalr	1542(ra) # 658 <fprintf>
    exit(1);
  5a:	4505                	li	a0,1
  5c:	00000097          	auipc	ra,0x0
  60:	2b2080e7          	jalr	690(ra) # 30e <exit>

0000000000000064 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  64:	1141                	addi	sp,sp,-16
  66:	e406                	sd	ra,8(sp)
  68:	e022                	sd	s0,0(sp)
  6a:	0800                	addi	s0,sp,16
  extern int main();
  main();
  6c:	00000097          	auipc	ra,0x0
  70:	f94080e7          	jalr	-108(ra) # 0 <main>
  exit(0);
  74:	4501                	li	a0,0
  76:	00000097          	auipc	ra,0x0
  7a:	298080e7          	jalr	664(ra) # 30e <exit>

000000000000007e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  7e:	1141                	addi	sp,sp,-16
  80:	e422                	sd	s0,8(sp)
  82:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  84:	87aa                	mv	a5,a0
  86:	0585                	addi	a1,a1,1
  88:	0785                	addi	a5,a5,1
  8a:	fff5c703          	lbu	a4,-1(a1)
  8e:	fee78fa3          	sb	a4,-1(a5)
  92:	fb75                	bnez	a4,86 <strcpy+0x8>
    ;
  return os;
}
  94:	6422                	ld	s0,8(sp)
  96:	0141                	addi	sp,sp,16
  98:	8082                	ret

000000000000009a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  9a:	1141                	addi	sp,sp,-16
  9c:	e422                	sd	s0,8(sp)
  9e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  a0:	00054783          	lbu	a5,0(a0)
  a4:	cf91                	beqz	a5,c0 <strcmp+0x26>
  a6:	0005c703          	lbu	a4,0(a1)
  aa:	00f71b63          	bne	a4,a5,c0 <strcmp+0x26>
    p++, q++;
  ae:	0505                	addi	a0,a0,1
  b0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  b2:	00054783          	lbu	a5,0(a0)
  b6:	c789                	beqz	a5,c0 <strcmp+0x26>
  b8:	0005c703          	lbu	a4,0(a1)
  bc:	fef709e3          	beq	a4,a5,ae <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
  c0:	0005c503          	lbu	a0,0(a1)
}
  c4:	40a7853b          	subw	a0,a5,a0
  c8:	6422                	ld	s0,8(sp)
  ca:	0141                	addi	sp,sp,16
  cc:	8082                	ret

00000000000000ce <strlen>:

uint
strlen(const char *s)
{
  ce:	1141                	addi	sp,sp,-16
  d0:	e422                	sd	s0,8(sp)
  d2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  d4:	00054783          	lbu	a5,0(a0)
  d8:	cf91                	beqz	a5,f4 <strlen+0x26>
  da:	0505                	addi	a0,a0,1
  dc:	87aa                	mv	a5,a0
  de:	4685                	li	a3,1
  e0:	9e89                	subw	a3,a3,a0
  e2:	00f6853b          	addw	a0,a3,a5
  e6:	0785                	addi	a5,a5,1
  e8:	fff7c703          	lbu	a4,-1(a5)
  ec:	fb7d                	bnez	a4,e2 <strlen+0x14>
    ;
  return n;
}
  ee:	6422                	ld	s0,8(sp)
  f0:	0141                	addi	sp,sp,16
  f2:	8082                	ret
  for(n = 0; s[n]; n++)
  f4:	4501                	li	a0,0
  f6:	bfe5                	j	ee <strlen+0x20>

00000000000000f8 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f8:	1141                	addi	sp,sp,-16
  fa:	e422                	sd	s0,8(sp)
  fc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  fe:	ce09                	beqz	a2,118 <memset+0x20>
 100:	87aa                	mv	a5,a0
 102:	fff6071b          	addiw	a4,a2,-1
 106:	1702                	slli	a4,a4,0x20
 108:	9301                	srli	a4,a4,0x20
 10a:	0705                	addi	a4,a4,1
 10c:	972a                	add	a4,a4,a0
    cdst[i] = c;
 10e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 112:	0785                	addi	a5,a5,1
 114:	fee79de3          	bne	a5,a4,10e <memset+0x16>
  }
  return dst;
}
 118:	6422                	ld	s0,8(sp)
 11a:	0141                	addi	sp,sp,16
 11c:	8082                	ret

000000000000011e <strchr>:

char*
strchr(const char *s, char c)
{
 11e:	1141                	addi	sp,sp,-16
 120:	e422                	sd	s0,8(sp)
 122:	0800                	addi	s0,sp,16
  for(; *s; s++)
 124:	00054783          	lbu	a5,0(a0)
 128:	cf91                	beqz	a5,144 <strchr+0x26>
    if(*s == c)
 12a:	00f58a63          	beq	a1,a5,13e <strchr+0x20>
  for(; *s; s++)
 12e:	0505                	addi	a0,a0,1
 130:	00054783          	lbu	a5,0(a0)
 134:	c781                	beqz	a5,13c <strchr+0x1e>
    if(*s == c)
 136:	feb79ce3          	bne	a5,a1,12e <strchr+0x10>
 13a:	a011                	j	13e <strchr+0x20>
      return (char*)s;
  return 0;
 13c:	4501                	li	a0,0
}
 13e:	6422                	ld	s0,8(sp)
 140:	0141                	addi	sp,sp,16
 142:	8082                	ret
  return 0;
 144:	4501                	li	a0,0
 146:	bfe5                	j	13e <strchr+0x20>

0000000000000148 <gets>:

char*
gets(char *buf, int max)
{
 148:	711d                	addi	sp,sp,-96
 14a:	ec86                	sd	ra,88(sp)
 14c:	e8a2                	sd	s0,80(sp)
 14e:	e4a6                	sd	s1,72(sp)
 150:	e0ca                	sd	s2,64(sp)
 152:	fc4e                	sd	s3,56(sp)
 154:	f852                	sd	s4,48(sp)
 156:	f456                	sd	s5,40(sp)
 158:	f05a                	sd	s6,32(sp)
 15a:	ec5e                	sd	s7,24(sp)
 15c:	1080                	addi	s0,sp,96
 15e:	8baa                	mv	s7,a0
 160:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 162:	892a                	mv	s2,a0
 164:	4981                	li	s3,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 166:	4aa9                	li	s5,10
 168:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 16a:	0019849b          	addiw	s1,s3,1
 16e:	0344d863          	bge	s1,s4,19e <gets+0x56>
    cc = read(0, &c, 1);
 172:	4605                	li	a2,1
 174:	faf40593          	addi	a1,s0,-81
 178:	4501                	li	a0,0
 17a:	00000097          	auipc	ra,0x0
 17e:	1ac080e7          	jalr	428(ra) # 326 <read>
    if(cc < 1)
 182:	00a05e63          	blez	a0,19e <gets+0x56>
    buf[i++] = c;
 186:	faf44783          	lbu	a5,-81(s0)
 18a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 18e:	01578763          	beq	a5,s5,19c <gets+0x54>
 192:	0905                	addi	s2,s2,1
  for(i=0; i+1 < max; ){
 194:	89a6                	mv	s3,s1
    if(c == '\n' || c == '\r')
 196:	fd679ae3          	bne	a5,s6,16a <gets+0x22>
 19a:	a011                	j	19e <gets+0x56>
  for(i=0; i+1 < max; ){
 19c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 19e:	99de                	add	s3,s3,s7
 1a0:	00098023          	sb	zero,0(s3)
  return buf;
}
 1a4:	855e                	mv	a0,s7
 1a6:	60e6                	ld	ra,88(sp)
 1a8:	6446                	ld	s0,80(sp)
 1aa:	64a6                	ld	s1,72(sp)
 1ac:	6906                	ld	s2,64(sp)
 1ae:	79e2                	ld	s3,56(sp)
 1b0:	7a42                	ld	s4,48(sp)
 1b2:	7aa2                	ld	s5,40(sp)
 1b4:	7b02                	ld	s6,32(sp)
 1b6:	6be2                	ld	s7,24(sp)
 1b8:	6125                	addi	sp,sp,96
 1ba:	8082                	ret

00000000000001bc <stat>:

int
stat(const char *n, struct stat *st)
{
 1bc:	1101                	addi	sp,sp,-32
 1be:	ec06                	sd	ra,24(sp)
 1c0:	e822                	sd	s0,16(sp)
 1c2:	e426                	sd	s1,8(sp)
 1c4:	e04a                	sd	s2,0(sp)
 1c6:	1000                	addi	s0,sp,32
 1c8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ca:	4581                	li	a1,0
 1cc:	00000097          	auipc	ra,0x0
 1d0:	182080e7          	jalr	386(ra) # 34e <open>
  if(fd < 0)
 1d4:	02054563          	bltz	a0,1fe <stat+0x42>
 1d8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1da:	85ca                	mv	a1,s2
 1dc:	00000097          	auipc	ra,0x0
 1e0:	18a080e7          	jalr	394(ra) # 366 <fstat>
 1e4:	892a                	mv	s2,a0
  close(fd);
 1e6:	8526                	mv	a0,s1
 1e8:	00000097          	auipc	ra,0x0
 1ec:	14e080e7          	jalr	334(ra) # 336 <close>
  return r;
}
 1f0:	854a                	mv	a0,s2
 1f2:	60e2                	ld	ra,24(sp)
 1f4:	6442                	ld	s0,16(sp)
 1f6:	64a2                	ld	s1,8(sp)
 1f8:	6902                	ld	s2,0(sp)
 1fa:	6105                	addi	sp,sp,32
 1fc:	8082                	ret
    return -1;
 1fe:	597d                	li	s2,-1
 200:	bfc5                	j	1f0 <stat+0x34>

0000000000000202 <atoi>:

int
atoi(const char *s)
{
 202:	1141                	addi	sp,sp,-16
 204:	e422                	sd	s0,8(sp)
 206:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 208:	00054683          	lbu	a3,0(a0)
 20c:	fd06879b          	addiw	a5,a3,-48
 210:	0ff7f793          	andi	a5,a5,255
 214:	4725                	li	a4,9
 216:	02f76963          	bltu	a4,a5,248 <atoi+0x46>
 21a:	862a                	mv	a2,a0
  n = 0;
 21c:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 21e:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 220:	0605                	addi	a2,a2,1
 222:	0025179b          	slliw	a5,a0,0x2
 226:	9fa9                	addw	a5,a5,a0
 228:	0017979b          	slliw	a5,a5,0x1
 22c:	9fb5                	addw	a5,a5,a3
 22e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 232:	00064683          	lbu	a3,0(a2)
 236:	fd06871b          	addiw	a4,a3,-48
 23a:	0ff77713          	andi	a4,a4,255
 23e:	fee5f1e3          	bgeu	a1,a4,220 <atoi+0x1e>
  return n;
}
 242:	6422                	ld	s0,8(sp)
 244:	0141                	addi	sp,sp,16
 246:	8082                	ret
  n = 0;
 248:	4501                	li	a0,0
 24a:	bfe5                	j	242 <atoi+0x40>

000000000000024c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 24c:	1141                	addi	sp,sp,-16
 24e:	e422                	sd	s0,8(sp)
 250:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 252:	02b57663          	bgeu	a0,a1,27e <memmove+0x32>
    while(n-- > 0)
 256:	02c05163          	blez	a2,278 <memmove+0x2c>
 25a:	fff6079b          	addiw	a5,a2,-1
 25e:	1782                	slli	a5,a5,0x20
 260:	9381                	srli	a5,a5,0x20
 262:	0785                	addi	a5,a5,1
 264:	97aa                	add	a5,a5,a0
  dst = vdst;
 266:	872a                	mv	a4,a0
      *dst++ = *src++;
 268:	0585                	addi	a1,a1,1
 26a:	0705                	addi	a4,a4,1
 26c:	fff5c683          	lbu	a3,-1(a1)
 270:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 274:	fee79ae3          	bne	a5,a4,268 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 278:	6422                	ld	s0,8(sp)
 27a:	0141                	addi	sp,sp,16
 27c:	8082                	ret
    dst += n;
 27e:	00c50733          	add	a4,a0,a2
    src += n;
 282:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 284:	fec05ae3          	blez	a2,278 <memmove+0x2c>
 288:	fff6079b          	addiw	a5,a2,-1
 28c:	1782                	slli	a5,a5,0x20
 28e:	9381                	srli	a5,a5,0x20
 290:	fff7c793          	not	a5,a5
 294:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 296:	15fd                	addi	a1,a1,-1
 298:	177d                	addi	a4,a4,-1
 29a:	0005c683          	lbu	a3,0(a1)
 29e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2a2:	fef71ae3          	bne	a4,a5,296 <memmove+0x4a>
 2a6:	bfc9                	j	278 <memmove+0x2c>

00000000000002a8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2a8:	1141                	addi	sp,sp,-16
 2aa:	e422                	sd	s0,8(sp)
 2ac:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2ae:	ce15                	beqz	a2,2ea <memcmp+0x42>
 2b0:	fff6069b          	addiw	a3,a2,-1
    if (*p1 != *p2) {
 2b4:	00054783          	lbu	a5,0(a0)
 2b8:	0005c703          	lbu	a4,0(a1)
 2bc:	02e79063          	bne	a5,a4,2dc <memcmp+0x34>
 2c0:	1682                	slli	a3,a3,0x20
 2c2:	9281                	srli	a3,a3,0x20
 2c4:	0685                	addi	a3,a3,1
 2c6:	96aa                	add	a3,a3,a0
      return *p1 - *p2;
    }
    p1++;
 2c8:	0505                	addi	a0,a0,1
    p2++;
 2ca:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2cc:	00d50d63          	beq	a0,a3,2e6 <memcmp+0x3e>
    if (*p1 != *p2) {
 2d0:	00054783          	lbu	a5,0(a0)
 2d4:	0005c703          	lbu	a4,0(a1)
 2d8:	fee788e3          	beq	a5,a4,2c8 <memcmp+0x20>
      return *p1 - *p2;
 2dc:	40e7853b          	subw	a0,a5,a4
  }
  return 0;
}
 2e0:	6422                	ld	s0,8(sp)
 2e2:	0141                	addi	sp,sp,16
 2e4:	8082                	ret
  return 0;
 2e6:	4501                	li	a0,0
 2e8:	bfe5                	j	2e0 <memcmp+0x38>
 2ea:	4501                	li	a0,0
 2ec:	bfd5                	j	2e0 <memcmp+0x38>

00000000000002ee <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2ee:	1141                	addi	sp,sp,-16
 2f0:	e406                	sd	ra,8(sp)
 2f2:	e022                	sd	s0,0(sp)
 2f4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2f6:	00000097          	auipc	ra,0x0
 2fa:	f56080e7          	jalr	-170(ra) # 24c <memmove>
}
 2fe:	60a2                	ld	ra,8(sp)
 300:	6402                	ld	s0,0(sp)
 302:	0141                	addi	sp,sp,16
 304:	8082                	ret

0000000000000306 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 306:	4885                	li	a7,1
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <exit>:
.global exit
exit:
 li a7, SYS_exit
 30e:	4889                	li	a7,2
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <wait>:
.global wait
wait:
 li a7, SYS_wait
 316:	488d                	li	a7,3
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 31e:	4891                	li	a7,4
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <read>:
.global read
read:
 li a7, SYS_read
 326:	4895                	li	a7,5
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <write>:
.global write
write:
 li a7, SYS_write
 32e:	48c1                	li	a7,16
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <close>:
.global close
close:
 li a7, SYS_close
 336:	48d5                	li	a7,21
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <kill>:
.global kill
kill:
 li a7, SYS_kill
 33e:	4899                	li	a7,6
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <exec>:
.global exec
exec:
 li a7, SYS_exec
 346:	489d                	li	a7,7
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <open>:
.global open
open:
 li a7, SYS_open
 34e:	48bd                	li	a7,15
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 356:	48c5                	li	a7,17
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 35e:	48c9                	li	a7,18
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 366:	48a1                	li	a7,8
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <link>:
.global link
link:
 li a7, SYS_link
 36e:	48cd                	li	a7,19
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 376:	48d1                	li	a7,20
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 37e:	48a5                	li	a7,9
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <dup>:
.global dup
dup:
 li a7, SYS_dup
 386:	48a9                	li	a7,10
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 38e:	48ad                	li	a7,11
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 396:	48b1                	li	a7,12
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 39e:	48b5                	li	a7,13
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3a6:	48b9                	li	a7,14
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3ae:	1101                	addi	sp,sp,-32
 3b0:	ec06                	sd	ra,24(sp)
 3b2:	e822                	sd	s0,16(sp)
 3b4:	1000                	addi	s0,sp,32
 3b6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3ba:	4605                	li	a2,1
 3bc:	fef40593          	addi	a1,s0,-17
 3c0:	00000097          	auipc	ra,0x0
 3c4:	f6e080e7          	jalr	-146(ra) # 32e <write>
}
 3c8:	60e2                	ld	ra,24(sp)
 3ca:	6442                	ld	s0,16(sp)
 3cc:	6105                	addi	sp,sp,32
 3ce:	8082                	ret

00000000000003d0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3d0:	7139                	addi	sp,sp,-64
 3d2:	fc06                	sd	ra,56(sp)
 3d4:	f822                	sd	s0,48(sp)
 3d6:	f426                	sd	s1,40(sp)
 3d8:	f04a                	sd	s2,32(sp)
 3da:	ec4e                	sd	s3,24(sp)
 3dc:	0080                	addi	s0,sp,64
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3de:	c299                	beqz	a3,3e4 <printint+0x14>
 3e0:	0005cd63          	bltz	a1,3fa <printint+0x2a>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3e4:	2581                	sext.w	a1,a1
  neg = 0;
 3e6:	4301                	li	t1,0
 3e8:	fc040713          	addi	a4,s0,-64
  }

  i = 0;
 3ec:	4801                	li	a6,0
  do{
    buf[i++] = digits[x % base];
 3ee:	2601                	sext.w	a2,a2
 3f0:	00000897          	auipc	a7,0x0
 3f4:	45888893          	addi	a7,a7,1112 # 848 <digits>
 3f8:	a801                	j	408 <printint+0x38>
    x = -xx;
 3fa:	40b005bb          	negw	a1,a1
 3fe:	2581                	sext.w	a1,a1
    neg = 1;
 400:	4305                	li	t1,1
    x = -xx;
 402:	b7dd                	j	3e8 <printint+0x18>
  }while((x /= base) != 0);
 404:	85be                	mv	a1,a5
    buf[i++] = digits[x % base];
 406:	8836                	mv	a6,a3
 408:	0018069b          	addiw	a3,a6,1
 40c:	02c5f7bb          	remuw	a5,a1,a2
 410:	1782                	slli	a5,a5,0x20
 412:	9381                	srli	a5,a5,0x20
 414:	97c6                	add	a5,a5,a7
 416:	0007c783          	lbu	a5,0(a5)
 41a:	00f70023          	sb	a5,0(a4)
  }while((x /= base) != 0);
 41e:	0705                	addi	a4,a4,1
 420:	02c5d7bb          	divuw	a5,a1,a2
 424:	fec5f0e3          	bgeu	a1,a2,404 <printint+0x34>
  if(neg)
 428:	00030b63          	beqz	t1,43e <printint+0x6e>
    buf[i++] = '-';
 42c:	fd040793          	addi	a5,s0,-48
 430:	96be                	add	a3,a3,a5
 432:	02d00793          	li	a5,45
 436:	fef68823          	sb	a5,-16(a3)
 43a:	0028069b          	addiw	a3,a6,2

  while(--i >= 0)
 43e:	02d05963          	blez	a3,470 <printint+0xa0>
 442:	89aa                	mv	s3,a0
 444:	fc040793          	addi	a5,s0,-64
 448:	00d784b3          	add	s1,a5,a3
 44c:	fff78913          	addi	s2,a5,-1
 450:	9936                	add	s2,s2,a3
 452:	36fd                	addiw	a3,a3,-1
 454:	1682                	slli	a3,a3,0x20
 456:	9281                	srli	a3,a3,0x20
 458:	40d90933          	sub	s2,s2,a3
    putc(fd, buf[i]);
 45c:	fff4c583          	lbu	a1,-1(s1)
 460:	854e                	mv	a0,s3
 462:	00000097          	auipc	ra,0x0
 466:	f4c080e7          	jalr	-180(ra) # 3ae <putc>
  while(--i >= 0)
 46a:	14fd                	addi	s1,s1,-1
 46c:	ff2498e3          	bne	s1,s2,45c <printint+0x8c>
}
 470:	70e2                	ld	ra,56(sp)
 472:	7442                	ld	s0,48(sp)
 474:	74a2                	ld	s1,40(sp)
 476:	7902                	ld	s2,32(sp)
 478:	69e2                	ld	s3,24(sp)
 47a:	6121                	addi	sp,sp,64
 47c:	8082                	ret

000000000000047e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 47e:	7119                	addi	sp,sp,-128
 480:	fc86                	sd	ra,120(sp)
 482:	f8a2                	sd	s0,112(sp)
 484:	f4a6                	sd	s1,104(sp)
 486:	f0ca                	sd	s2,96(sp)
 488:	ecce                	sd	s3,88(sp)
 48a:	e8d2                	sd	s4,80(sp)
 48c:	e4d6                	sd	s5,72(sp)
 48e:	e0da                	sd	s6,64(sp)
 490:	fc5e                	sd	s7,56(sp)
 492:	f862                	sd	s8,48(sp)
 494:	f466                	sd	s9,40(sp)
 496:	f06a                	sd	s10,32(sp)
 498:	ec6e                	sd	s11,24(sp)
 49a:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 49c:	0005c483          	lbu	s1,0(a1)
 4a0:	18048d63          	beqz	s1,63a <vprintf+0x1bc>
 4a4:	8aaa                	mv	s5,a0
 4a6:	8b32                	mv	s6,a2
 4a8:	00158913          	addi	s2,a1,1
  state = 0;
 4ac:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4ae:	02500a13          	li	s4,37
      if(c == 'd'){
 4b2:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 4b6:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 4ba:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 4be:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4c2:	00000b97          	auipc	s7,0x0
 4c6:	386b8b93          	addi	s7,s7,902 # 848 <digits>
 4ca:	a839                	j	4e8 <vprintf+0x6a>
        putc(fd, c);
 4cc:	85a6                	mv	a1,s1
 4ce:	8556                	mv	a0,s5
 4d0:	00000097          	auipc	ra,0x0
 4d4:	ede080e7          	jalr	-290(ra) # 3ae <putc>
 4d8:	a019                	j	4de <vprintf+0x60>
    } else if(state == '%'){
 4da:	01498f63          	beq	s3,s4,4f8 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 4de:	0905                	addi	s2,s2,1
 4e0:	fff94483          	lbu	s1,-1(s2)
 4e4:	14048b63          	beqz	s1,63a <vprintf+0x1bc>
    c = fmt[i] & 0xff;
 4e8:	0004879b          	sext.w	a5,s1
    if(state == 0){
 4ec:	fe0997e3          	bnez	s3,4da <vprintf+0x5c>
      if(c == '%'){
 4f0:	fd479ee3          	bne	a5,s4,4cc <vprintf+0x4e>
        state = '%';
 4f4:	89be                	mv	s3,a5
 4f6:	b7e5                	j	4de <vprintf+0x60>
      if(c == 'd'){
 4f8:	05878063          	beq	a5,s8,538 <vprintf+0xba>
      } else if(c == 'l') {
 4fc:	05978c63          	beq	a5,s9,554 <vprintf+0xd6>
      } else if(c == 'x') {
 500:	07a78863          	beq	a5,s10,570 <vprintf+0xf2>
      } else if(c == 'p') {
 504:	09b78463          	beq	a5,s11,58c <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 508:	07300713          	li	a4,115
 50c:	0ce78563          	beq	a5,a4,5d6 <vprintf+0x158>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 510:	06300713          	li	a4,99
 514:	0ee78c63          	beq	a5,a4,60c <vprintf+0x18e>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 518:	11478663          	beq	a5,s4,624 <vprintf+0x1a6>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 51c:	85d2                	mv	a1,s4
 51e:	8556                	mv	a0,s5
 520:	00000097          	auipc	ra,0x0
 524:	e8e080e7          	jalr	-370(ra) # 3ae <putc>
        putc(fd, c);
 528:	85a6                	mv	a1,s1
 52a:	8556                	mv	a0,s5
 52c:	00000097          	auipc	ra,0x0
 530:	e82080e7          	jalr	-382(ra) # 3ae <putc>
      }
      state = 0;
 534:	4981                	li	s3,0
 536:	b765                	j	4de <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 538:	008b0493          	addi	s1,s6,8
 53c:	4685                	li	a3,1
 53e:	4629                	li	a2,10
 540:	000b2583          	lw	a1,0(s6)
 544:	8556                	mv	a0,s5
 546:	00000097          	auipc	ra,0x0
 54a:	e8a080e7          	jalr	-374(ra) # 3d0 <printint>
 54e:	8b26                	mv	s6,s1
      state = 0;
 550:	4981                	li	s3,0
 552:	b771                	j	4de <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 554:	008b0493          	addi	s1,s6,8
 558:	4681                	li	a3,0
 55a:	4629                	li	a2,10
 55c:	000b2583          	lw	a1,0(s6)
 560:	8556                	mv	a0,s5
 562:	00000097          	auipc	ra,0x0
 566:	e6e080e7          	jalr	-402(ra) # 3d0 <printint>
 56a:	8b26                	mv	s6,s1
      state = 0;
 56c:	4981                	li	s3,0
 56e:	bf85                	j	4de <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 570:	008b0493          	addi	s1,s6,8
 574:	4681                	li	a3,0
 576:	4641                	li	a2,16
 578:	000b2583          	lw	a1,0(s6)
 57c:	8556                	mv	a0,s5
 57e:	00000097          	auipc	ra,0x0
 582:	e52080e7          	jalr	-430(ra) # 3d0 <printint>
 586:	8b26                	mv	s6,s1
      state = 0;
 588:	4981                	li	s3,0
 58a:	bf91                	j	4de <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 58c:	008b0793          	addi	a5,s6,8
 590:	f8f43423          	sd	a5,-120(s0)
 594:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 598:	03000593          	li	a1,48
 59c:	8556                	mv	a0,s5
 59e:	00000097          	auipc	ra,0x0
 5a2:	e10080e7          	jalr	-496(ra) # 3ae <putc>
  putc(fd, 'x');
 5a6:	85ea                	mv	a1,s10
 5a8:	8556                	mv	a0,s5
 5aa:	00000097          	auipc	ra,0x0
 5ae:	e04080e7          	jalr	-508(ra) # 3ae <putc>
 5b2:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5b4:	03c9d793          	srli	a5,s3,0x3c
 5b8:	97de                	add	a5,a5,s7
 5ba:	0007c583          	lbu	a1,0(a5)
 5be:	8556                	mv	a0,s5
 5c0:	00000097          	auipc	ra,0x0
 5c4:	dee080e7          	jalr	-530(ra) # 3ae <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5c8:	0992                	slli	s3,s3,0x4
 5ca:	34fd                	addiw	s1,s1,-1
 5cc:	f4e5                	bnez	s1,5b4 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 5ce:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5d2:	4981                	li	s3,0
 5d4:	b729                	j	4de <vprintf+0x60>
        s = va_arg(ap, char*);
 5d6:	008b0993          	addi	s3,s6,8
 5da:	000b3483          	ld	s1,0(s6)
        if(s == 0)
 5de:	c085                	beqz	s1,5fe <vprintf+0x180>
        while(*s != 0){
 5e0:	0004c583          	lbu	a1,0(s1)
 5e4:	c9a1                	beqz	a1,634 <vprintf+0x1b6>
          putc(fd, *s);
 5e6:	8556                	mv	a0,s5
 5e8:	00000097          	auipc	ra,0x0
 5ec:	dc6080e7          	jalr	-570(ra) # 3ae <putc>
          s++;
 5f0:	0485                	addi	s1,s1,1
        while(*s != 0){
 5f2:	0004c583          	lbu	a1,0(s1)
 5f6:	f9e5                	bnez	a1,5e6 <vprintf+0x168>
        s = va_arg(ap, char*);
 5f8:	8b4e                	mv	s6,s3
      state = 0;
 5fa:	4981                	li	s3,0
 5fc:	b5cd                	j	4de <vprintf+0x60>
          s = "(null)";
 5fe:	00000497          	auipc	s1,0x0
 602:	26248493          	addi	s1,s1,610 # 860 <digits+0x18>
        while(*s != 0){
 606:	02800593          	li	a1,40
 60a:	bff1                	j	5e6 <vprintf+0x168>
        putc(fd, va_arg(ap, uint));
 60c:	008b0493          	addi	s1,s6,8
 610:	000b4583          	lbu	a1,0(s6)
 614:	8556                	mv	a0,s5
 616:	00000097          	auipc	ra,0x0
 61a:	d98080e7          	jalr	-616(ra) # 3ae <putc>
 61e:	8b26                	mv	s6,s1
      state = 0;
 620:	4981                	li	s3,0
 622:	bd75                	j	4de <vprintf+0x60>
        putc(fd, c);
 624:	85d2                	mv	a1,s4
 626:	8556                	mv	a0,s5
 628:	00000097          	auipc	ra,0x0
 62c:	d86080e7          	jalr	-634(ra) # 3ae <putc>
      state = 0;
 630:	4981                	li	s3,0
 632:	b575                	j	4de <vprintf+0x60>
        s = va_arg(ap, char*);
 634:	8b4e                	mv	s6,s3
      state = 0;
 636:	4981                	li	s3,0
 638:	b55d                	j	4de <vprintf+0x60>
    }
  }
}
 63a:	70e6                	ld	ra,120(sp)
 63c:	7446                	ld	s0,112(sp)
 63e:	74a6                	ld	s1,104(sp)
 640:	7906                	ld	s2,96(sp)
 642:	69e6                	ld	s3,88(sp)
 644:	6a46                	ld	s4,80(sp)
 646:	6aa6                	ld	s5,72(sp)
 648:	6b06                	ld	s6,64(sp)
 64a:	7be2                	ld	s7,56(sp)
 64c:	7c42                	ld	s8,48(sp)
 64e:	7ca2                	ld	s9,40(sp)
 650:	7d02                	ld	s10,32(sp)
 652:	6de2                	ld	s11,24(sp)
 654:	6109                	addi	sp,sp,128
 656:	8082                	ret

0000000000000658 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 658:	715d                	addi	sp,sp,-80
 65a:	ec06                	sd	ra,24(sp)
 65c:	e822                	sd	s0,16(sp)
 65e:	1000                	addi	s0,sp,32
 660:	e010                	sd	a2,0(s0)
 662:	e414                	sd	a3,8(s0)
 664:	e818                	sd	a4,16(s0)
 666:	ec1c                	sd	a5,24(s0)
 668:	03043023          	sd	a6,32(s0)
 66c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 670:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 674:	8622                	mv	a2,s0
 676:	00000097          	auipc	ra,0x0
 67a:	e08080e7          	jalr	-504(ra) # 47e <vprintf>
}
 67e:	60e2                	ld	ra,24(sp)
 680:	6442                	ld	s0,16(sp)
 682:	6161                	addi	sp,sp,80
 684:	8082                	ret

0000000000000686 <printf>:

void
printf(const char *fmt, ...)
{
 686:	711d                	addi	sp,sp,-96
 688:	ec06                	sd	ra,24(sp)
 68a:	e822                	sd	s0,16(sp)
 68c:	1000                	addi	s0,sp,32
 68e:	e40c                	sd	a1,8(s0)
 690:	e810                	sd	a2,16(s0)
 692:	ec14                	sd	a3,24(s0)
 694:	f018                	sd	a4,32(s0)
 696:	f41c                	sd	a5,40(s0)
 698:	03043823          	sd	a6,48(s0)
 69c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6a0:	00840613          	addi	a2,s0,8
 6a4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6a8:	85aa                	mv	a1,a0
 6aa:	4505                	li	a0,1
 6ac:	00000097          	auipc	ra,0x0
 6b0:	dd2080e7          	jalr	-558(ra) # 47e <vprintf>
}
 6b4:	60e2                	ld	ra,24(sp)
 6b6:	6442                	ld	s0,16(sp)
 6b8:	6125                	addi	sp,sp,96
 6ba:	8082                	ret

00000000000006bc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6bc:	1141                	addi	sp,sp,-16
 6be:	e422                	sd	s0,8(sp)
 6c0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6c2:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c6:	00001797          	auipc	a5,0x1
 6ca:	93a78793          	addi	a5,a5,-1734 # 1000 <freep>
 6ce:	639c                	ld	a5,0(a5)
 6d0:	a805                	j	700 <free+0x44>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6d2:	4618                	lw	a4,8(a2)
 6d4:	9db9                	addw	a1,a1,a4
 6d6:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6da:	6398                	ld	a4,0(a5)
 6dc:	6318                	ld	a4,0(a4)
 6de:	fee53823          	sd	a4,-16(a0)
 6e2:	a091                	j	726 <free+0x6a>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6e4:	ff852703          	lw	a4,-8(a0)
 6e8:	9e39                	addw	a2,a2,a4
 6ea:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 6ec:	ff053703          	ld	a4,-16(a0)
 6f0:	e398                	sd	a4,0(a5)
 6f2:	a099                	j	738 <free+0x7c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6f4:	6398                	ld	a4,0(a5)
 6f6:	00e7e463          	bltu	a5,a4,6fe <free+0x42>
 6fa:	00e6ea63          	bltu	a3,a4,70e <free+0x52>
{
 6fe:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 700:	fed7fae3          	bgeu	a5,a3,6f4 <free+0x38>
 704:	6398                	ld	a4,0(a5)
 706:	00e6e463          	bltu	a3,a4,70e <free+0x52>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 70a:	fee7eae3          	bltu	a5,a4,6fe <free+0x42>
  if(bp + bp->s.size == p->s.ptr){
 70e:	ff852583          	lw	a1,-8(a0)
 712:	6390                	ld	a2,0(a5)
 714:	02059713          	slli	a4,a1,0x20
 718:	9301                	srli	a4,a4,0x20
 71a:	0712                	slli	a4,a4,0x4
 71c:	9736                	add	a4,a4,a3
 71e:	fae60ae3          	beq	a2,a4,6d2 <free+0x16>
    bp->s.ptr = p->s.ptr;
 722:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 726:	4790                	lw	a2,8(a5)
 728:	02061713          	slli	a4,a2,0x20
 72c:	9301                	srli	a4,a4,0x20
 72e:	0712                	slli	a4,a4,0x4
 730:	973e                	add	a4,a4,a5
 732:	fae689e3          	beq	a3,a4,6e4 <free+0x28>
  } else
    p->s.ptr = bp;
 736:	e394                	sd	a3,0(a5)
  freep = p;
 738:	00001717          	auipc	a4,0x1
 73c:	8cf73423          	sd	a5,-1848(a4) # 1000 <freep>
}
 740:	6422                	ld	s0,8(sp)
 742:	0141                	addi	sp,sp,16
 744:	8082                	ret

0000000000000746 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 746:	7139                	addi	sp,sp,-64
 748:	fc06                	sd	ra,56(sp)
 74a:	f822                	sd	s0,48(sp)
 74c:	f426                	sd	s1,40(sp)
 74e:	f04a                	sd	s2,32(sp)
 750:	ec4e                	sd	s3,24(sp)
 752:	e852                	sd	s4,16(sp)
 754:	e456                	sd	s5,8(sp)
 756:	e05a                	sd	s6,0(sp)
 758:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 75a:	02051993          	slli	s3,a0,0x20
 75e:	0209d993          	srli	s3,s3,0x20
 762:	09bd                	addi	s3,s3,15
 764:	0049d993          	srli	s3,s3,0x4
 768:	2985                	addiw	s3,s3,1
 76a:	0009891b          	sext.w	s2,s3
  if((prevp = freep) == 0){
 76e:	00001797          	auipc	a5,0x1
 772:	89278793          	addi	a5,a5,-1902 # 1000 <freep>
 776:	6388                	ld	a0,0(a5)
 778:	c515                	beqz	a0,7a4 <malloc+0x5e>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 77a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 77c:	4798                	lw	a4,8(a5)
 77e:	03277f63          	bgeu	a4,s2,7bc <malloc+0x76>
 782:	8a4e                	mv	s4,s3
 784:	0009871b          	sext.w	a4,s3
 788:	6685                	lui	a3,0x1
 78a:	00d77363          	bgeu	a4,a3,790 <malloc+0x4a>
 78e:	6a05                	lui	s4,0x1
 790:	000a0a9b          	sext.w	s5,s4
  p = sbrk(nu * sizeof(Header));
 794:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 798:	00001497          	auipc	s1,0x1
 79c:	86848493          	addi	s1,s1,-1944 # 1000 <freep>
  if(p == (char*)-1)
 7a0:	5b7d                	li	s6,-1
 7a2:	a885                	j	812 <malloc+0xcc>
    base.s.ptr = freep = prevp = &base;
 7a4:	00001797          	auipc	a5,0x1
 7a8:	86c78793          	addi	a5,a5,-1940 # 1010 <base>
 7ac:	00001717          	auipc	a4,0x1
 7b0:	84f73a23          	sd	a5,-1964(a4) # 1000 <freep>
 7b4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7b6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7ba:	b7e1                	j	782 <malloc+0x3c>
      if(p->s.size == nunits)
 7bc:	02e90b63          	beq	s2,a4,7f2 <malloc+0xac>
        p->s.size -= nunits;
 7c0:	4137073b          	subw	a4,a4,s3
 7c4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7c6:	1702                	slli	a4,a4,0x20
 7c8:	9301                	srli	a4,a4,0x20
 7ca:	0712                	slli	a4,a4,0x4
 7cc:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7ce:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7d2:	00001717          	auipc	a4,0x1
 7d6:	82a73723          	sd	a0,-2002(a4) # 1000 <freep>
      return (void*)(p + 1);
 7da:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7de:	70e2                	ld	ra,56(sp)
 7e0:	7442                	ld	s0,48(sp)
 7e2:	74a2                	ld	s1,40(sp)
 7e4:	7902                	ld	s2,32(sp)
 7e6:	69e2                	ld	s3,24(sp)
 7e8:	6a42                	ld	s4,16(sp)
 7ea:	6aa2                	ld	s5,8(sp)
 7ec:	6b02                	ld	s6,0(sp)
 7ee:	6121                	addi	sp,sp,64
 7f0:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7f2:	6398                	ld	a4,0(a5)
 7f4:	e118                	sd	a4,0(a0)
 7f6:	bff1                	j	7d2 <malloc+0x8c>
  hp->s.size = nu;
 7f8:	01552423          	sw	s5,8(a0)
  free((void*)(hp + 1));
 7fc:	0541                	addi	a0,a0,16
 7fe:	00000097          	auipc	ra,0x0
 802:	ebe080e7          	jalr	-322(ra) # 6bc <free>
  return freep;
 806:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 808:	d979                	beqz	a0,7de <malloc+0x98>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 80a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 80c:	4798                	lw	a4,8(a5)
 80e:	fb2777e3          	bgeu	a4,s2,7bc <malloc+0x76>
    if(p == freep)
 812:	6098                	ld	a4,0(s1)
 814:	853e                	mv	a0,a5
 816:	fef71ae3          	bne	a4,a5,80a <malloc+0xc4>
  p = sbrk(nu * sizeof(Header));
 81a:	8552                	mv	a0,s4
 81c:	00000097          	auipc	ra,0x0
 820:	b7a080e7          	jalr	-1158(ra) # 396 <sbrk>
  if(p == (char*)-1)
 824:	fd651ae3          	bne	a0,s6,7f8 <malloc+0xb2>
        return 0;
 828:	4501                	li	a0,0
 82a:	bf55                	j	7de <malloc+0x98>
