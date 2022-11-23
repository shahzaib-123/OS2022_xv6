
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
 int counter=1;


char*
fmtname(char *path)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  10:	00000097          	auipc	ra,0x0
  14:	3b6080e7          	jalr	950(ra) # 3c6 <strlen>
  18:	02051793          	slli	a5,a0,0x20
  1c:	9381                	srli	a5,a5,0x20
  1e:	97a6                	add	a5,a5,s1
  20:	02f00693          	li	a3,47
  24:	0097e963          	bltu	a5,s1,36 <fmtname+0x36>
  28:	0007c703          	lbu	a4,0(a5)
  2c:	00d70563          	beq	a4,a3,36 <fmtname+0x36>
  30:	17fd                	addi	a5,a5,-1
  32:	fe97fbe3          	bgeu	a5,s1,28 <fmtname+0x28>
    ;
  p++;
  36:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  3a:	8526                	mv	a0,s1
  3c:	00000097          	auipc	ra,0x0
  40:	38a080e7          	jalr	906(ra) # 3c6 <strlen>
  44:	2501                	sext.w	a0,a0
  46:	47b5                	li	a5,13
  48:	00a7fa63          	bgeu	a5,a0,5c <fmtname+0x5c>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  4c:	8526                	mv	a0,s1
  4e:	70a2                	ld	ra,40(sp)
  50:	7402                	ld	s0,32(sp)
  52:	64e2                	ld	s1,24(sp)
  54:	6942                	ld	s2,16(sp)
  56:	69a2                	ld	s3,8(sp)
  58:	6145                	addi	sp,sp,48
  5a:	8082                	ret
  memmove(buf, p, strlen(p));
  5c:	8526                	mv	a0,s1
  5e:	00000097          	auipc	ra,0x0
  62:	368080e7          	jalr	872(ra) # 3c6 <strlen>
  66:	00001997          	auipc	s3,0x1
  6a:	fba98993          	addi	s3,s3,-70 # 1020 <buf.0>
  6e:	0005061b          	sext.w	a2,a0
  72:	85a6                	mv	a1,s1
  74:	854e                	mv	a0,s3
  76:	00000097          	auipc	ra,0x0
  7a:	4c2080e7          	jalr	1218(ra) # 538 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  7e:	8526                	mv	a0,s1
  80:	00000097          	auipc	ra,0x0
  84:	346080e7          	jalr	838(ra) # 3c6 <strlen>
  88:	0005091b          	sext.w	s2,a0
  8c:	8526                	mv	a0,s1
  8e:	00000097          	auipc	ra,0x0
  92:	338080e7          	jalr	824(ra) # 3c6 <strlen>
  96:	1902                	slli	s2,s2,0x20
  98:	02095913          	srli	s2,s2,0x20
  9c:	4639                	li	a2,14
  9e:	9e09                	subw	a2,a2,a0
  a0:	02000593          	li	a1,32
  a4:	01298533          	add	a0,s3,s2
  a8:	00000097          	auipc	ra,0x0
  ac:	348080e7          	jalr	840(ra) # 3f0 <memset>
  return buf;
  b0:	84ce                	mv	s1,s3
  b2:	bf69                	j	4c <fmtname+0x4c>

00000000000000b4 <ls>:

void
ls(char *path,int flag)
{
  b4:	d8010113          	addi	sp,sp,-640
  b8:	26113c23          	sd	ra,632(sp)
  bc:	26813823          	sd	s0,624(sp)
  c0:	26913423          	sd	s1,616(sp)
  c4:	27213023          	sd	s2,608(sp)
  c8:	25313c23          	sd	s3,600(sp)
  cc:	25413823          	sd	s4,592(sp)
  d0:	25513423          	sd	s5,584(sp)
  d4:	25613023          	sd	s6,576(sp)
  d8:	23713c23          	sd	s7,568(sp)
  dc:	23813823          	sd	s8,560(sp)
  e0:	0500                	addi	s0,sp,640
  e2:	89aa                	mv	s3,a0
  e4:	892e                	mv	s2,a1
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;
  if((fd = open(path, 0)) < 0){
  e6:	4581                	li	a1,0
  e8:	00000097          	auipc	ra,0x0
  ec:	542080e7          	jalr	1346(ra) # 62a <open>
  f0:	08054963          	bltz	a0,182 <ls+0xce>
  f4:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  f6:	d8840593          	addi	a1,s0,-632
  fa:	00000097          	auipc	ra,0x0
  fe:	548080e7          	jalr	1352(ra) # 642 <fstat>
 102:	08054b63          	bltz	a0,198 <ls+0xe4>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
 106:	d9041783          	lh	a5,-624(s0)
 10a:	0007869b          	sext.w	a3,a5
 10e:	4705                	li	a4,1
 110:	0ce68863          	beq	a3,a4,1e0 <ls+0x12c>
 114:	37f9                	addiw	a5,a5,-2
 116:	17c2                	slli	a5,a5,0x30
 118:	93c1                	srli	a5,a5,0x30
 11a:	02f76863          	bltu	a4,a5,14a <ls+0x96>
  case T_DEVICE:
  case T_FILE:
    if(flag>=1){
 11e:	09204d63          	bgtz	s2,1b8 <ls+0x104>
        printf("%d\t",counter);
        counter+=1;
        }
    printf("%s %d %d %l\n", fmtname(path), st.type, st.ino, st.size);
 122:	854e                	mv	a0,s3
 124:	00000097          	auipc	ra,0x0
 128:	edc080e7          	jalr	-292(ra) # 0 <fmtname>
 12c:	85aa                	mv	a1,a0
 12e:	d9843703          	ld	a4,-616(s0)
 132:	d8c42683          	lw	a3,-628(s0)
 136:	d9041603          	lh	a2,-624(s0)
 13a:	00001517          	auipc	a0,0x1
 13e:	a0e50513          	addi	a0,a0,-1522 # b48 <malloc+0x12c>
 142:	00001097          	auipc	ra,0x1
 146:	822080e7          	jalr	-2014(ra) # 964 <printf>
        }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
 14a:	8526                	mv	a0,s1
 14c:	00000097          	auipc	ra,0x0
 150:	4c6080e7          	jalr	1222(ra) # 612 <close>
}
 154:	27813083          	ld	ra,632(sp)
 158:	27013403          	ld	s0,624(sp)
 15c:	26813483          	ld	s1,616(sp)
 160:	26013903          	ld	s2,608(sp)
 164:	25813983          	ld	s3,600(sp)
 168:	25013a03          	ld	s4,592(sp)
 16c:	24813a83          	ld	s5,584(sp)
 170:	24013b03          	ld	s6,576(sp)
 174:	23813b83          	ld	s7,568(sp)
 178:	23013c03          	ld	s8,560(sp)
 17c:	28010113          	addi	sp,sp,640
 180:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 182:	864e                	mv	a2,s3
 184:	00001597          	auipc	a1,0x1
 188:	98c58593          	addi	a1,a1,-1652 # b10 <malloc+0xf4>
 18c:	4509                	li	a0,2
 18e:	00000097          	auipc	ra,0x0
 192:	7a8080e7          	jalr	1960(ra) # 936 <fprintf>
    return;
 196:	bf7d                	j	154 <ls+0xa0>
    fprintf(2, "ls: cannot stat %s\n", path);
 198:	864e                	mv	a2,s3
 19a:	00001597          	auipc	a1,0x1
 19e:	98e58593          	addi	a1,a1,-1650 # b28 <malloc+0x10c>
 1a2:	4509                	li	a0,2
 1a4:	00000097          	auipc	ra,0x0
 1a8:	792080e7          	jalr	1938(ra) # 936 <fprintf>
    close(fd);
 1ac:	8526                	mv	a0,s1
 1ae:	00000097          	auipc	ra,0x0
 1b2:	464080e7          	jalr	1124(ra) # 612 <close>
    return;
 1b6:	bf79                	j	154 <ls+0xa0>
        printf("%d\t",counter);
 1b8:	00001917          	auipc	s2,0x1
 1bc:	e4890913          	addi	s2,s2,-440 # 1000 <counter>
 1c0:	00092583          	lw	a1,0(s2)
 1c4:	00001517          	auipc	a0,0x1
 1c8:	97c50513          	addi	a0,a0,-1668 # b40 <malloc+0x124>
 1cc:	00000097          	auipc	ra,0x0
 1d0:	798080e7          	jalr	1944(ra) # 964 <printf>
        counter+=1;
 1d4:	00092783          	lw	a5,0(s2)
 1d8:	2785                	addiw	a5,a5,1
 1da:	00f92023          	sw	a5,0(s2)
 1de:	b791                	j	122 <ls+0x6e>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 1e0:	854e                	mv	a0,s3
 1e2:	00000097          	auipc	ra,0x0
 1e6:	1e4080e7          	jalr	484(ra) # 3c6 <strlen>
 1ea:	2541                	addiw	a0,a0,16
 1ec:	20000793          	li	a5,512
 1f0:	00a7fb63          	bgeu	a5,a0,206 <ls+0x152>
      printf("ls: path too long\n");
 1f4:	00001517          	auipc	a0,0x1
 1f8:	96450513          	addi	a0,a0,-1692 # b58 <malloc+0x13c>
 1fc:	00000097          	auipc	ra,0x0
 200:	768080e7          	jalr	1896(ra) # 964 <printf>
      break;
 204:	b799                	j	14a <ls+0x96>
    strcpy(buf, path);
 206:	85ce                	mv	a1,s3
 208:	db040513          	addi	a0,s0,-592
 20c:	00000097          	auipc	ra,0x0
 210:	172080e7          	jalr	370(ra) # 37e <strcpy>
    p = buf+strlen(buf);
 214:	db040513          	addi	a0,s0,-592
 218:	00000097          	auipc	ra,0x0
 21c:	1ae080e7          	jalr	430(ra) # 3c6 <strlen>
 220:	1502                	slli	a0,a0,0x20
 222:	9101                	srli	a0,a0,0x20
 224:	db040793          	addi	a5,s0,-592
 228:	00a789b3          	add	s3,a5,a0
    *p++ = '/';
 22c:	00198a93          	addi	s5,s3,1
 230:	02f00793          	li	a5,47
 234:	00f98023          	sb	a5,0(s3)
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 238:	00001b17          	auipc	s6,0x1
 23c:	938b0b13          	addi	s6,s6,-1736 # b70 <malloc+0x154>
        printf("%d\t",counter);
 240:	00001a17          	auipc	s4,0x1
 244:	dc0a0a13          	addi	s4,s4,-576 # 1000 <counter>
 248:	00001b97          	auipc	s7,0x1
 24c:	8f8b8b93          	addi	s7,s7,-1800 # b40 <malloc+0x124>
        printf("ls: cannot stat %s\n", buf);
 250:	00001c17          	auipc	s8,0x1
 254:	8d8c0c13          	addi	s8,s8,-1832 # b28 <malloc+0x10c>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 258:	a81d                	j	28e <ls+0x1da>
        printf("ls: cannot stat %s\n", buf);
 25a:	db040593          	addi	a1,s0,-592
 25e:	8562                	mv	a0,s8
 260:	00000097          	auipc	ra,0x0
 264:	704080e7          	jalr	1796(ra) # 964 <printf>
        continue;
 268:	a01d                	j	28e <ls+0x1da>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 26a:	db040513          	addi	a0,s0,-592
 26e:	00000097          	auipc	ra,0x0
 272:	d92080e7          	jalr	-622(ra) # 0 <fmtname>
 276:	85aa                	mv	a1,a0
 278:	d9843703          	ld	a4,-616(s0)
 27c:	d8c42683          	lw	a3,-628(s0)
 280:	d9041603          	lh	a2,-624(s0)
 284:	855a                	mv	a0,s6
 286:	00000097          	auipc	ra,0x0
 28a:	6de080e7          	jalr	1758(ra) # 964 <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 28e:	4641                	li	a2,16
 290:	da040593          	addi	a1,s0,-608
 294:	8526                	mv	a0,s1
 296:	00000097          	auipc	ra,0x0
 29a:	36c080e7          	jalr	876(ra) # 602 <read>
 29e:	47c1                	li	a5,16
 2a0:	eaf515e3          	bne	a0,a5,14a <ls+0x96>
      if(de.inum == 0)
 2a4:	da045783          	lhu	a5,-608(s0)
 2a8:	d3fd                	beqz	a5,28e <ls+0x1da>
      memmove(p, de.name, DIRSIZ);
 2aa:	4639                	li	a2,14
 2ac:	da240593          	addi	a1,s0,-606
 2b0:	8556                	mv	a0,s5
 2b2:	00000097          	auipc	ra,0x0
 2b6:	286080e7          	jalr	646(ra) # 538 <memmove>
      p[DIRSIZ] = 0;
 2ba:	000987a3          	sb	zero,15(s3)
      if(stat(buf, &st) < 0){
 2be:	d8840593          	addi	a1,s0,-632
 2c2:	db040513          	addi	a0,s0,-592
 2c6:	00000097          	auipc	ra,0x0
 2ca:	1e4080e7          	jalr	484(ra) # 4aa <stat>
 2ce:	f80546e3          	bltz	a0,25a <ls+0x1a6>
      if(flag>=1){
 2d2:	f9205ce3          	blez	s2,26a <ls+0x1b6>
        printf("%d\t",counter);
 2d6:	000a2583          	lw	a1,0(s4)
 2da:	855e                	mv	a0,s7
 2dc:	00000097          	auipc	ra,0x0
 2e0:	688080e7          	jalr	1672(ra) # 964 <printf>
        counter+=1;
 2e4:	000a2783          	lw	a5,0(s4)
 2e8:	2785                	addiw	a5,a5,1
 2ea:	00fa2023          	sw	a5,0(s4)
 2ee:	bfb5                	j	26a <ls+0x1b6>

00000000000002f0 <main>:

int
main(int argc, char *argv[])
{
 2f0:	7179                	addi	sp,sp,-48
 2f2:	f406                	sd	ra,40(sp)
 2f4:	f022                	sd	s0,32(sp)
 2f6:	ec26                	sd	s1,24(sp)
 2f8:	e84a                	sd	s2,16(sp)
 2fa:	e44e                	sd	s3,8(sp)
 2fc:	1800                	addi	s0,sp,48
 2fe:	89aa                	mv	s3,a0
 300:	892e                	mv	s2,a1
  int flag=0;
  int i;

  if(strcmp(argv[1],"-n")==0)
 302:	00001597          	auipc	a1,0x1
 306:	87e58593          	addi	a1,a1,-1922 # b80 <malloc+0x164>
 30a:	00893503          	ld	a0,8(s2)
 30e:	00000097          	auipc	ra,0x0
 312:	08c080e7          	jalr	140(ra) # 39a <strcmp>
 316:	00153493          	seqz	s1,a0
  {
    flag+=1;
  }
  if(argc < 2+flag){
 31a:	2485                	addiw	s1,s1,1
 31c:	0334d563          	bge	s1,s3,346 <main+0x56>
    ls(".",flag);
    exit(0);
  }
  for(i=flag+1; i<argc; i++)
 320:	00349793          	slli	a5,s1,0x3
 324:	993e                	add	s2,s2,a5
    ls(argv[i],i);
 326:	85a6                	mv	a1,s1
 328:	00093503          	ld	a0,0(s2)
 32c:	00000097          	auipc	ra,0x0
 330:	d88080e7          	jalr	-632(ra) # b4 <ls>
  for(i=flag+1; i<argc; i++)
 334:	2485                	addiw	s1,s1,1
 336:	0921                	addi	s2,s2,8
 338:	fe9997e3          	bne	s3,s1,326 <main+0x36>
  exit(0);
 33c:	4501                	li	a0,0
 33e:	00000097          	auipc	ra,0x0
 342:	2ac080e7          	jalr	684(ra) # 5ea <exit>
 346:	00153593          	seqz	a1,a0
    ls(".",flag);
 34a:	00001517          	auipc	a0,0x1
 34e:	83e50513          	addi	a0,a0,-1986 # b88 <malloc+0x16c>
 352:	00000097          	auipc	ra,0x0
 356:	d62080e7          	jalr	-670(ra) # b4 <ls>
    exit(0);
 35a:	4501                	li	a0,0
 35c:	00000097          	auipc	ra,0x0
 360:	28e080e7          	jalr	654(ra) # 5ea <exit>

0000000000000364 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 364:	1141                	addi	sp,sp,-16
 366:	e406                	sd	ra,8(sp)
 368:	e022                	sd	s0,0(sp)
 36a:	0800                	addi	s0,sp,16
  extern int main();
  main();
 36c:	00000097          	auipc	ra,0x0
 370:	f84080e7          	jalr	-124(ra) # 2f0 <main>
  exit(0);
 374:	4501                	li	a0,0
 376:	00000097          	auipc	ra,0x0
 37a:	274080e7          	jalr	628(ra) # 5ea <exit>

000000000000037e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 37e:	1141                	addi	sp,sp,-16
 380:	e422                	sd	s0,8(sp)
 382:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 384:	87aa                	mv	a5,a0
 386:	0585                	addi	a1,a1,1
 388:	0785                	addi	a5,a5,1
 38a:	fff5c703          	lbu	a4,-1(a1)
 38e:	fee78fa3          	sb	a4,-1(a5)
 392:	fb75                	bnez	a4,386 <strcpy+0x8>
    ;
  return os;
}
 394:	6422                	ld	s0,8(sp)
 396:	0141                	addi	sp,sp,16
 398:	8082                	ret

000000000000039a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 39a:	1141                	addi	sp,sp,-16
 39c:	e422                	sd	s0,8(sp)
 39e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 3a0:	00054783          	lbu	a5,0(a0)
 3a4:	cb91                	beqz	a5,3b8 <strcmp+0x1e>
 3a6:	0005c703          	lbu	a4,0(a1)
 3aa:	00f71763          	bne	a4,a5,3b8 <strcmp+0x1e>
    p++, q++;
 3ae:	0505                	addi	a0,a0,1
 3b0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 3b2:	00054783          	lbu	a5,0(a0)
 3b6:	fbe5                	bnez	a5,3a6 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 3b8:	0005c503          	lbu	a0,0(a1)
}
 3bc:	40a7853b          	subw	a0,a5,a0
 3c0:	6422                	ld	s0,8(sp)
 3c2:	0141                	addi	sp,sp,16
 3c4:	8082                	ret

00000000000003c6 <strlen>:

uint
strlen(const char *s)
{
 3c6:	1141                	addi	sp,sp,-16
 3c8:	e422                	sd	s0,8(sp)
 3ca:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 3cc:	00054783          	lbu	a5,0(a0)
 3d0:	cf91                	beqz	a5,3ec <strlen+0x26>
 3d2:	0505                	addi	a0,a0,1
 3d4:	87aa                	mv	a5,a0
 3d6:	4685                	li	a3,1
 3d8:	9e89                	subw	a3,a3,a0
 3da:	00f6853b          	addw	a0,a3,a5
 3de:	0785                	addi	a5,a5,1
 3e0:	fff7c703          	lbu	a4,-1(a5)
 3e4:	fb7d                	bnez	a4,3da <strlen+0x14>
    ;
  return n;
}
 3e6:	6422                	ld	s0,8(sp)
 3e8:	0141                	addi	sp,sp,16
 3ea:	8082                	ret
  for(n = 0; s[n]; n++)
 3ec:	4501                	li	a0,0
 3ee:	bfe5                	j	3e6 <strlen+0x20>

00000000000003f0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3f0:	1141                	addi	sp,sp,-16
 3f2:	e422                	sd	s0,8(sp)
 3f4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 3f6:	ca19                	beqz	a2,40c <memset+0x1c>
 3f8:	87aa                	mv	a5,a0
 3fa:	1602                	slli	a2,a2,0x20
 3fc:	9201                	srli	a2,a2,0x20
 3fe:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 402:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 406:	0785                	addi	a5,a5,1
 408:	fee79de3          	bne	a5,a4,402 <memset+0x12>
  }
  return dst;
}
 40c:	6422                	ld	s0,8(sp)
 40e:	0141                	addi	sp,sp,16
 410:	8082                	ret

0000000000000412 <strchr>:

char*
strchr(const char *s, char c)
{
 412:	1141                	addi	sp,sp,-16
 414:	e422                	sd	s0,8(sp)
 416:	0800                	addi	s0,sp,16
  for(; *s; s++)
 418:	00054783          	lbu	a5,0(a0)
 41c:	cb99                	beqz	a5,432 <strchr+0x20>
    if(*s == c)
 41e:	00f58763          	beq	a1,a5,42c <strchr+0x1a>
  for(; *s; s++)
 422:	0505                	addi	a0,a0,1
 424:	00054783          	lbu	a5,0(a0)
 428:	fbfd                	bnez	a5,41e <strchr+0xc>
      return (char*)s;
  return 0;
 42a:	4501                	li	a0,0
}
 42c:	6422                	ld	s0,8(sp)
 42e:	0141                	addi	sp,sp,16
 430:	8082                	ret
  return 0;
 432:	4501                	li	a0,0
 434:	bfe5                	j	42c <strchr+0x1a>

0000000000000436 <gets>:

char*
gets(char *buf, int max)
{
 436:	711d                	addi	sp,sp,-96
 438:	ec86                	sd	ra,88(sp)
 43a:	e8a2                	sd	s0,80(sp)
 43c:	e4a6                	sd	s1,72(sp)
 43e:	e0ca                	sd	s2,64(sp)
 440:	fc4e                	sd	s3,56(sp)
 442:	f852                	sd	s4,48(sp)
 444:	f456                	sd	s5,40(sp)
 446:	f05a                	sd	s6,32(sp)
 448:	ec5e                	sd	s7,24(sp)
 44a:	1080                	addi	s0,sp,96
 44c:	8baa                	mv	s7,a0
 44e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 450:	892a                	mv	s2,a0
 452:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 454:	4aa9                	li	s5,10
 456:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 458:	89a6                	mv	s3,s1
 45a:	2485                	addiw	s1,s1,1
 45c:	0344d863          	bge	s1,s4,48c <gets+0x56>
    cc = read(0, &c, 1);
 460:	4605                	li	a2,1
 462:	faf40593          	addi	a1,s0,-81
 466:	4501                	li	a0,0
 468:	00000097          	auipc	ra,0x0
 46c:	19a080e7          	jalr	410(ra) # 602 <read>
    if(cc < 1)
 470:	00a05e63          	blez	a0,48c <gets+0x56>
    buf[i++] = c;
 474:	faf44783          	lbu	a5,-81(s0)
 478:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 47c:	01578763          	beq	a5,s5,48a <gets+0x54>
 480:	0905                	addi	s2,s2,1
 482:	fd679be3          	bne	a5,s6,458 <gets+0x22>
  for(i=0; i+1 < max; ){
 486:	89a6                	mv	s3,s1
 488:	a011                	j	48c <gets+0x56>
 48a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 48c:	99de                	add	s3,s3,s7
 48e:	00098023          	sb	zero,0(s3)
  return buf;
}
 492:	855e                	mv	a0,s7
 494:	60e6                	ld	ra,88(sp)
 496:	6446                	ld	s0,80(sp)
 498:	64a6                	ld	s1,72(sp)
 49a:	6906                	ld	s2,64(sp)
 49c:	79e2                	ld	s3,56(sp)
 49e:	7a42                	ld	s4,48(sp)
 4a0:	7aa2                	ld	s5,40(sp)
 4a2:	7b02                	ld	s6,32(sp)
 4a4:	6be2                	ld	s7,24(sp)
 4a6:	6125                	addi	sp,sp,96
 4a8:	8082                	ret

00000000000004aa <stat>:

int
stat(const char *n, struct stat *st)
{
 4aa:	1101                	addi	sp,sp,-32
 4ac:	ec06                	sd	ra,24(sp)
 4ae:	e822                	sd	s0,16(sp)
 4b0:	e426                	sd	s1,8(sp)
 4b2:	e04a                	sd	s2,0(sp)
 4b4:	1000                	addi	s0,sp,32
 4b6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4b8:	4581                	li	a1,0
 4ba:	00000097          	auipc	ra,0x0
 4be:	170080e7          	jalr	368(ra) # 62a <open>
  if(fd < 0)
 4c2:	02054563          	bltz	a0,4ec <stat+0x42>
 4c6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 4c8:	85ca                	mv	a1,s2
 4ca:	00000097          	auipc	ra,0x0
 4ce:	178080e7          	jalr	376(ra) # 642 <fstat>
 4d2:	892a                	mv	s2,a0
  close(fd);
 4d4:	8526                	mv	a0,s1
 4d6:	00000097          	auipc	ra,0x0
 4da:	13c080e7          	jalr	316(ra) # 612 <close>
  return r;
}
 4de:	854a                	mv	a0,s2
 4e0:	60e2                	ld	ra,24(sp)
 4e2:	6442                	ld	s0,16(sp)
 4e4:	64a2                	ld	s1,8(sp)
 4e6:	6902                	ld	s2,0(sp)
 4e8:	6105                	addi	sp,sp,32
 4ea:	8082                	ret
    return -1;
 4ec:	597d                	li	s2,-1
 4ee:	bfc5                	j	4de <stat+0x34>

00000000000004f0 <atoi>:

int
atoi(const char *s)
{
 4f0:	1141                	addi	sp,sp,-16
 4f2:	e422                	sd	s0,8(sp)
 4f4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4f6:	00054683          	lbu	a3,0(a0)
 4fa:	fd06879b          	addiw	a5,a3,-48
 4fe:	0ff7f793          	zext.b	a5,a5
 502:	4625                	li	a2,9
 504:	02f66863          	bltu	a2,a5,534 <atoi+0x44>
 508:	872a                	mv	a4,a0
  n = 0;
 50a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 50c:	0705                	addi	a4,a4,1
 50e:	0025179b          	slliw	a5,a0,0x2
 512:	9fa9                	addw	a5,a5,a0
 514:	0017979b          	slliw	a5,a5,0x1
 518:	9fb5                	addw	a5,a5,a3
 51a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 51e:	00074683          	lbu	a3,0(a4)
 522:	fd06879b          	addiw	a5,a3,-48
 526:	0ff7f793          	zext.b	a5,a5
 52a:	fef671e3          	bgeu	a2,a5,50c <atoi+0x1c>
  return n;
}
 52e:	6422                	ld	s0,8(sp)
 530:	0141                	addi	sp,sp,16
 532:	8082                	ret
  n = 0;
 534:	4501                	li	a0,0
 536:	bfe5                	j	52e <atoi+0x3e>

0000000000000538 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 538:	1141                	addi	sp,sp,-16
 53a:	e422                	sd	s0,8(sp)
 53c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 53e:	02b57463          	bgeu	a0,a1,566 <memmove+0x2e>
    while(n-- > 0)
 542:	00c05f63          	blez	a2,560 <memmove+0x28>
 546:	1602                	slli	a2,a2,0x20
 548:	9201                	srli	a2,a2,0x20
 54a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 54e:	872a                	mv	a4,a0
      *dst++ = *src++;
 550:	0585                	addi	a1,a1,1
 552:	0705                	addi	a4,a4,1
 554:	fff5c683          	lbu	a3,-1(a1)
 558:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 55c:	fee79ae3          	bne	a5,a4,550 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 560:	6422                	ld	s0,8(sp)
 562:	0141                	addi	sp,sp,16
 564:	8082                	ret
    dst += n;
 566:	00c50733          	add	a4,a0,a2
    src += n;
 56a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 56c:	fec05ae3          	blez	a2,560 <memmove+0x28>
 570:	fff6079b          	addiw	a5,a2,-1
 574:	1782                	slli	a5,a5,0x20
 576:	9381                	srli	a5,a5,0x20
 578:	fff7c793          	not	a5,a5
 57c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 57e:	15fd                	addi	a1,a1,-1
 580:	177d                	addi	a4,a4,-1
 582:	0005c683          	lbu	a3,0(a1)
 586:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 58a:	fee79ae3          	bne	a5,a4,57e <memmove+0x46>
 58e:	bfc9                	j	560 <memmove+0x28>

0000000000000590 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 590:	1141                	addi	sp,sp,-16
 592:	e422                	sd	s0,8(sp)
 594:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 596:	ca05                	beqz	a2,5c6 <memcmp+0x36>
 598:	fff6069b          	addiw	a3,a2,-1
 59c:	1682                	slli	a3,a3,0x20
 59e:	9281                	srli	a3,a3,0x20
 5a0:	0685                	addi	a3,a3,1
 5a2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 5a4:	00054783          	lbu	a5,0(a0)
 5a8:	0005c703          	lbu	a4,0(a1)
 5ac:	00e79863          	bne	a5,a4,5bc <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 5b0:	0505                	addi	a0,a0,1
    p2++;
 5b2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 5b4:	fed518e3          	bne	a0,a3,5a4 <memcmp+0x14>
  }
  return 0;
 5b8:	4501                	li	a0,0
 5ba:	a019                	j	5c0 <memcmp+0x30>
      return *p1 - *p2;
 5bc:	40e7853b          	subw	a0,a5,a4
}
 5c0:	6422                	ld	s0,8(sp)
 5c2:	0141                	addi	sp,sp,16
 5c4:	8082                	ret
  return 0;
 5c6:	4501                	li	a0,0
 5c8:	bfe5                	j	5c0 <memcmp+0x30>

00000000000005ca <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 5ca:	1141                	addi	sp,sp,-16
 5cc:	e406                	sd	ra,8(sp)
 5ce:	e022                	sd	s0,0(sp)
 5d0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 5d2:	00000097          	auipc	ra,0x0
 5d6:	f66080e7          	jalr	-154(ra) # 538 <memmove>
}
 5da:	60a2                	ld	ra,8(sp)
 5dc:	6402                	ld	s0,0(sp)
 5de:	0141                	addi	sp,sp,16
 5e0:	8082                	ret

00000000000005e2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 5e2:	4885                	li	a7,1
 ecall
 5e4:	00000073          	ecall
 ret
 5e8:	8082                	ret

00000000000005ea <exit>:
.global exit
exit:
 li a7, SYS_exit
 5ea:	4889                	li	a7,2
 ecall
 5ec:	00000073          	ecall
 ret
 5f0:	8082                	ret

00000000000005f2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 5f2:	488d                	li	a7,3
 ecall
 5f4:	00000073          	ecall
 ret
 5f8:	8082                	ret

00000000000005fa <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 5fa:	4891                	li	a7,4
 ecall
 5fc:	00000073          	ecall
 ret
 600:	8082                	ret

0000000000000602 <read>:
.global read
read:
 li a7, SYS_read
 602:	4895                	li	a7,5
 ecall
 604:	00000073          	ecall
 ret
 608:	8082                	ret

000000000000060a <write>:
.global write
write:
 li a7, SYS_write
 60a:	48c1                	li	a7,16
 ecall
 60c:	00000073          	ecall
 ret
 610:	8082                	ret

0000000000000612 <close>:
.global close
close:
 li a7, SYS_close
 612:	48d5                	li	a7,21
 ecall
 614:	00000073          	ecall
 ret
 618:	8082                	ret

000000000000061a <kill>:
.global kill
kill:
 li a7, SYS_kill
 61a:	4899                	li	a7,6
 ecall
 61c:	00000073          	ecall
 ret
 620:	8082                	ret

0000000000000622 <exec>:
.global exec
exec:
 li a7, SYS_exec
 622:	489d                	li	a7,7
 ecall
 624:	00000073          	ecall
 ret
 628:	8082                	ret

000000000000062a <open>:
.global open
open:
 li a7, SYS_open
 62a:	48bd                	li	a7,15
 ecall
 62c:	00000073          	ecall
 ret
 630:	8082                	ret

0000000000000632 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 632:	48c5                	li	a7,17
 ecall
 634:	00000073          	ecall
 ret
 638:	8082                	ret

000000000000063a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 63a:	48c9                	li	a7,18
 ecall
 63c:	00000073          	ecall
 ret
 640:	8082                	ret

0000000000000642 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 642:	48a1                	li	a7,8
 ecall
 644:	00000073          	ecall
 ret
 648:	8082                	ret

000000000000064a <link>:
.global link
link:
 li a7, SYS_link
 64a:	48cd                	li	a7,19
 ecall
 64c:	00000073          	ecall
 ret
 650:	8082                	ret

0000000000000652 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 652:	48d1                	li	a7,20
 ecall
 654:	00000073          	ecall
 ret
 658:	8082                	ret

000000000000065a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 65a:	48a5                	li	a7,9
 ecall
 65c:	00000073          	ecall
 ret
 660:	8082                	ret

0000000000000662 <dup>:
.global dup
dup:
 li a7, SYS_dup
 662:	48a9                	li	a7,10
 ecall
 664:	00000073          	ecall
 ret
 668:	8082                	ret

000000000000066a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 66a:	48ad                	li	a7,11
 ecall
 66c:	00000073          	ecall
 ret
 670:	8082                	ret

0000000000000672 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 672:	48b1                	li	a7,12
 ecall
 674:	00000073          	ecall
 ret
 678:	8082                	ret

000000000000067a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 67a:	48b5                	li	a7,13
 ecall
 67c:	00000073          	ecall
 ret
 680:	8082                	ret

0000000000000682 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 682:	48b9                	li	a7,14
 ecall
 684:	00000073          	ecall
 ret
 688:	8082                	ret

000000000000068a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 68a:	1101                	addi	sp,sp,-32
 68c:	ec06                	sd	ra,24(sp)
 68e:	e822                	sd	s0,16(sp)
 690:	1000                	addi	s0,sp,32
 692:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 696:	4605                	li	a2,1
 698:	fef40593          	addi	a1,s0,-17
 69c:	00000097          	auipc	ra,0x0
 6a0:	f6e080e7          	jalr	-146(ra) # 60a <write>
}
 6a4:	60e2                	ld	ra,24(sp)
 6a6:	6442                	ld	s0,16(sp)
 6a8:	6105                	addi	sp,sp,32
 6aa:	8082                	ret

00000000000006ac <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6ac:	7139                	addi	sp,sp,-64
 6ae:	fc06                	sd	ra,56(sp)
 6b0:	f822                	sd	s0,48(sp)
 6b2:	f426                	sd	s1,40(sp)
 6b4:	f04a                	sd	s2,32(sp)
 6b6:	ec4e                	sd	s3,24(sp)
 6b8:	0080                	addi	s0,sp,64
 6ba:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 6bc:	c299                	beqz	a3,6c2 <printint+0x16>
 6be:	0805c963          	bltz	a1,750 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 6c2:	2581                	sext.w	a1,a1
  neg = 0;
 6c4:	4881                	li	a7,0
 6c6:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 6ca:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 6cc:	2601                	sext.w	a2,a2
 6ce:	00000517          	auipc	a0,0x0
 6d2:	52250513          	addi	a0,a0,1314 # bf0 <digits>
 6d6:	883a                	mv	a6,a4
 6d8:	2705                	addiw	a4,a4,1
 6da:	02c5f7bb          	remuw	a5,a1,a2
 6de:	1782                	slli	a5,a5,0x20
 6e0:	9381                	srli	a5,a5,0x20
 6e2:	97aa                	add	a5,a5,a0
 6e4:	0007c783          	lbu	a5,0(a5)
 6e8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 6ec:	0005879b          	sext.w	a5,a1
 6f0:	02c5d5bb          	divuw	a1,a1,a2
 6f4:	0685                	addi	a3,a3,1
 6f6:	fec7f0e3          	bgeu	a5,a2,6d6 <printint+0x2a>
  if(neg)
 6fa:	00088c63          	beqz	a7,712 <printint+0x66>
    buf[i++] = '-';
 6fe:	fd070793          	addi	a5,a4,-48
 702:	00878733          	add	a4,a5,s0
 706:	02d00793          	li	a5,45
 70a:	fef70823          	sb	a5,-16(a4)
 70e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 712:	02e05863          	blez	a4,742 <printint+0x96>
 716:	fc040793          	addi	a5,s0,-64
 71a:	00e78933          	add	s2,a5,a4
 71e:	fff78993          	addi	s3,a5,-1
 722:	99ba                	add	s3,s3,a4
 724:	377d                	addiw	a4,a4,-1
 726:	1702                	slli	a4,a4,0x20
 728:	9301                	srli	a4,a4,0x20
 72a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 72e:	fff94583          	lbu	a1,-1(s2)
 732:	8526                	mv	a0,s1
 734:	00000097          	auipc	ra,0x0
 738:	f56080e7          	jalr	-170(ra) # 68a <putc>
  while(--i >= 0)
 73c:	197d                	addi	s2,s2,-1
 73e:	ff3918e3          	bne	s2,s3,72e <printint+0x82>
}
 742:	70e2                	ld	ra,56(sp)
 744:	7442                	ld	s0,48(sp)
 746:	74a2                	ld	s1,40(sp)
 748:	7902                	ld	s2,32(sp)
 74a:	69e2                	ld	s3,24(sp)
 74c:	6121                	addi	sp,sp,64
 74e:	8082                	ret
    x = -xx;
 750:	40b005bb          	negw	a1,a1
    neg = 1;
 754:	4885                	li	a7,1
    x = -xx;
 756:	bf85                	j	6c6 <printint+0x1a>

0000000000000758 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 758:	7119                	addi	sp,sp,-128
 75a:	fc86                	sd	ra,120(sp)
 75c:	f8a2                	sd	s0,112(sp)
 75e:	f4a6                	sd	s1,104(sp)
 760:	f0ca                	sd	s2,96(sp)
 762:	ecce                	sd	s3,88(sp)
 764:	e8d2                	sd	s4,80(sp)
 766:	e4d6                	sd	s5,72(sp)
 768:	e0da                	sd	s6,64(sp)
 76a:	fc5e                	sd	s7,56(sp)
 76c:	f862                	sd	s8,48(sp)
 76e:	f466                	sd	s9,40(sp)
 770:	f06a                	sd	s10,32(sp)
 772:	ec6e                	sd	s11,24(sp)
 774:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 776:	0005c903          	lbu	s2,0(a1)
 77a:	18090f63          	beqz	s2,918 <vprintf+0x1c0>
 77e:	8aaa                	mv	s5,a0
 780:	8b32                	mv	s6,a2
 782:	00158493          	addi	s1,a1,1
  state = 0;
 786:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 788:	02500a13          	li	s4,37
 78c:	4c55                	li	s8,21
 78e:	00000c97          	auipc	s9,0x0
 792:	40ac8c93          	addi	s9,s9,1034 # b98 <malloc+0x17c>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 796:	02800d93          	li	s11,40
  putc(fd, 'x');
 79a:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 79c:	00000b97          	auipc	s7,0x0
 7a0:	454b8b93          	addi	s7,s7,1108 # bf0 <digits>
 7a4:	a839                	j	7c2 <vprintf+0x6a>
        putc(fd, c);
 7a6:	85ca                	mv	a1,s2
 7a8:	8556                	mv	a0,s5
 7aa:	00000097          	auipc	ra,0x0
 7ae:	ee0080e7          	jalr	-288(ra) # 68a <putc>
 7b2:	a019                	j	7b8 <vprintf+0x60>
    } else if(state == '%'){
 7b4:	01498d63          	beq	s3,s4,7ce <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 7b8:	0485                	addi	s1,s1,1
 7ba:	fff4c903          	lbu	s2,-1(s1)
 7be:	14090d63          	beqz	s2,918 <vprintf+0x1c0>
    if(state == 0){
 7c2:	fe0999e3          	bnez	s3,7b4 <vprintf+0x5c>
      if(c == '%'){
 7c6:	ff4910e3          	bne	s2,s4,7a6 <vprintf+0x4e>
        state = '%';
 7ca:	89d2                	mv	s3,s4
 7cc:	b7f5                	j	7b8 <vprintf+0x60>
      if(c == 'd'){
 7ce:	11490c63          	beq	s2,s4,8e6 <vprintf+0x18e>
 7d2:	f9d9079b          	addiw	a5,s2,-99
 7d6:	0ff7f793          	zext.b	a5,a5
 7da:	10fc6e63          	bltu	s8,a5,8f6 <vprintf+0x19e>
 7de:	f9d9079b          	addiw	a5,s2,-99
 7e2:	0ff7f713          	zext.b	a4,a5
 7e6:	10ec6863          	bltu	s8,a4,8f6 <vprintf+0x19e>
 7ea:	00271793          	slli	a5,a4,0x2
 7ee:	97e6                	add	a5,a5,s9
 7f0:	439c                	lw	a5,0(a5)
 7f2:	97e6                	add	a5,a5,s9
 7f4:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 7f6:	008b0913          	addi	s2,s6,8
 7fa:	4685                	li	a3,1
 7fc:	4629                	li	a2,10
 7fe:	000b2583          	lw	a1,0(s6)
 802:	8556                	mv	a0,s5
 804:	00000097          	auipc	ra,0x0
 808:	ea8080e7          	jalr	-344(ra) # 6ac <printint>
 80c:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 80e:	4981                	li	s3,0
 810:	b765                	j	7b8 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 812:	008b0913          	addi	s2,s6,8
 816:	4681                	li	a3,0
 818:	4629                	li	a2,10
 81a:	000b2583          	lw	a1,0(s6)
 81e:	8556                	mv	a0,s5
 820:	00000097          	auipc	ra,0x0
 824:	e8c080e7          	jalr	-372(ra) # 6ac <printint>
 828:	8b4a                	mv	s6,s2
      state = 0;
 82a:	4981                	li	s3,0
 82c:	b771                	j	7b8 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 82e:	008b0913          	addi	s2,s6,8
 832:	4681                	li	a3,0
 834:	866a                	mv	a2,s10
 836:	000b2583          	lw	a1,0(s6)
 83a:	8556                	mv	a0,s5
 83c:	00000097          	auipc	ra,0x0
 840:	e70080e7          	jalr	-400(ra) # 6ac <printint>
 844:	8b4a                	mv	s6,s2
      state = 0;
 846:	4981                	li	s3,0
 848:	bf85                	j	7b8 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 84a:	008b0793          	addi	a5,s6,8
 84e:	f8f43423          	sd	a5,-120(s0)
 852:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 856:	03000593          	li	a1,48
 85a:	8556                	mv	a0,s5
 85c:	00000097          	auipc	ra,0x0
 860:	e2e080e7          	jalr	-466(ra) # 68a <putc>
  putc(fd, 'x');
 864:	07800593          	li	a1,120
 868:	8556                	mv	a0,s5
 86a:	00000097          	auipc	ra,0x0
 86e:	e20080e7          	jalr	-480(ra) # 68a <putc>
 872:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 874:	03c9d793          	srli	a5,s3,0x3c
 878:	97de                	add	a5,a5,s7
 87a:	0007c583          	lbu	a1,0(a5)
 87e:	8556                	mv	a0,s5
 880:	00000097          	auipc	ra,0x0
 884:	e0a080e7          	jalr	-502(ra) # 68a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 888:	0992                	slli	s3,s3,0x4
 88a:	397d                	addiw	s2,s2,-1
 88c:	fe0914e3          	bnez	s2,874 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 890:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 894:	4981                	li	s3,0
 896:	b70d                	j	7b8 <vprintf+0x60>
        s = va_arg(ap, char*);
 898:	008b0913          	addi	s2,s6,8
 89c:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 8a0:	02098163          	beqz	s3,8c2 <vprintf+0x16a>
        while(*s != 0){
 8a4:	0009c583          	lbu	a1,0(s3)
 8a8:	c5ad                	beqz	a1,912 <vprintf+0x1ba>
          putc(fd, *s);
 8aa:	8556                	mv	a0,s5
 8ac:	00000097          	auipc	ra,0x0
 8b0:	dde080e7          	jalr	-546(ra) # 68a <putc>
          s++;
 8b4:	0985                	addi	s3,s3,1
        while(*s != 0){
 8b6:	0009c583          	lbu	a1,0(s3)
 8ba:	f9e5                	bnez	a1,8aa <vprintf+0x152>
        s = va_arg(ap, char*);
 8bc:	8b4a                	mv	s6,s2
      state = 0;
 8be:	4981                	li	s3,0
 8c0:	bde5                	j	7b8 <vprintf+0x60>
          s = "(null)";
 8c2:	00000997          	auipc	s3,0x0
 8c6:	2ce98993          	addi	s3,s3,718 # b90 <malloc+0x174>
        while(*s != 0){
 8ca:	85ee                	mv	a1,s11
 8cc:	bff9                	j	8aa <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 8ce:	008b0913          	addi	s2,s6,8
 8d2:	000b4583          	lbu	a1,0(s6)
 8d6:	8556                	mv	a0,s5
 8d8:	00000097          	auipc	ra,0x0
 8dc:	db2080e7          	jalr	-590(ra) # 68a <putc>
 8e0:	8b4a                	mv	s6,s2
      state = 0;
 8e2:	4981                	li	s3,0
 8e4:	bdd1                	j	7b8 <vprintf+0x60>
        putc(fd, c);
 8e6:	85d2                	mv	a1,s4
 8e8:	8556                	mv	a0,s5
 8ea:	00000097          	auipc	ra,0x0
 8ee:	da0080e7          	jalr	-608(ra) # 68a <putc>
      state = 0;
 8f2:	4981                	li	s3,0
 8f4:	b5d1                	j	7b8 <vprintf+0x60>
        putc(fd, '%');
 8f6:	85d2                	mv	a1,s4
 8f8:	8556                	mv	a0,s5
 8fa:	00000097          	auipc	ra,0x0
 8fe:	d90080e7          	jalr	-624(ra) # 68a <putc>
        putc(fd, c);
 902:	85ca                	mv	a1,s2
 904:	8556                	mv	a0,s5
 906:	00000097          	auipc	ra,0x0
 90a:	d84080e7          	jalr	-636(ra) # 68a <putc>
      state = 0;
 90e:	4981                	li	s3,0
 910:	b565                	j	7b8 <vprintf+0x60>
        s = va_arg(ap, char*);
 912:	8b4a                	mv	s6,s2
      state = 0;
 914:	4981                	li	s3,0
 916:	b54d                	j	7b8 <vprintf+0x60>
    }
  }
}
 918:	70e6                	ld	ra,120(sp)
 91a:	7446                	ld	s0,112(sp)
 91c:	74a6                	ld	s1,104(sp)
 91e:	7906                	ld	s2,96(sp)
 920:	69e6                	ld	s3,88(sp)
 922:	6a46                	ld	s4,80(sp)
 924:	6aa6                	ld	s5,72(sp)
 926:	6b06                	ld	s6,64(sp)
 928:	7be2                	ld	s7,56(sp)
 92a:	7c42                	ld	s8,48(sp)
 92c:	7ca2                	ld	s9,40(sp)
 92e:	7d02                	ld	s10,32(sp)
 930:	6de2                	ld	s11,24(sp)
 932:	6109                	addi	sp,sp,128
 934:	8082                	ret

0000000000000936 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 936:	715d                	addi	sp,sp,-80
 938:	ec06                	sd	ra,24(sp)
 93a:	e822                	sd	s0,16(sp)
 93c:	1000                	addi	s0,sp,32
 93e:	e010                	sd	a2,0(s0)
 940:	e414                	sd	a3,8(s0)
 942:	e818                	sd	a4,16(s0)
 944:	ec1c                	sd	a5,24(s0)
 946:	03043023          	sd	a6,32(s0)
 94a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 94e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 952:	8622                	mv	a2,s0
 954:	00000097          	auipc	ra,0x0
 958:	e04080e7          	jalr	-508(ra) # 758 <vprintf>
}
 95c:	60e2                	ld	ra,24(sp)
 95e:	6442                	ld	s0,16(sp)
 960:	6161                	addi	sp,sp,80
 962:	8082                	ret

0000000000000964 <printf>:

void
printf(const char *fmt, ...)
{
 964:	711d                	addi	sp,sp,-96
 966:	ec06                	sd	ra,24(sp)
 968:	e822                	sd	s0,16(sp)
 96a:	1000                	addi	s0,sp,32
 96c:	e40c                	sd	a1,8(s0)
 96e:	e810                	sd	a2,16(s0)
 970:	ec14                	sd	a3,24(s0)
 972:	f018                	sd	a4,32(s0)
 974:	f41c                	sd	a5,40(s0)
 976:	03043823          	sd	a6,48(s0)
 97a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 97e:	00840613          	addi	a2,s0,8
 982:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 986:	85aa                	mv	a1,a0
 988:	4505                	li	a0,1
 98a:	00000097          	auipc	ra,0x0
 98e:	dce080e7          	jalr	-562(ra) # 758 <vprintf>
}
 992:	60e2                	ld	ra,24(sp)
 994:	6442                	ld	s0,16(sp)
 996:	6125                	addi	sp,sp,96
 998:	8082                	ret

000000000000099a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 99a:	1141                	addi	sp,sp,-16
 99c:	e422                	sd	s0,8(sp)
 99e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9a0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9a4:	00000797          	auipc	a5,0x0
 9a8:	66c7b783          	ld	a5,1644(a5) # 1010 <freep>
 9ac:	a02d                	j	9d6 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 9ae:	4618                	lw	a4,8(a2)
 9b0:	9f2d                	addw	a4,a4,a1
 9b2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 9b6:	6398                	ld	a4,0(a5)
 9b8:	6310                	ld	a2,0(a4)
 9ba:	a83d                	j	9f8 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 9bc:	ff852703          	lw	a4,-8(a0)
 9c0:	9f31                	addw	a4,a4,a2
 9c2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 9c4:	ff053683          	ld	a3,-16(a0)
 9c8:	a091                	j	a0c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9ca:	6398                	ld	a4,0(a5)
 9cc:	00e7e463          	bltu	a5,a4,9d4 <free+0x3a>
 9d0:	00e6ea63          	bltu	a3,a4,9e4 <free+0x4a>
{
 9d4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9d6:	fed7fae3          	bgeu	a5,a3,9ca <free+0x30>
 9da:	6398                	ld	a4,0(a5)
 9dc:	00e6e463          	bltu	a3,a4,9e4 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9e0:	fee7eae3          	bltu	a5,a4,9d4 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 9e4:	ff852583          	lw	a1,-8(a0)
 9e8:	6390                	ld	a2,0(a5)
 9ea:	02059813          	slli	a6,a1,0x20
 9ee:	01c85713          	srli	a4,a6,0x1c
 9f2:	9736                	add	a4,a4,a3
 9f4:	fae60de3          	beq	a2,a4,9ae <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 9f8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9fc:	4790                	lw	a2,8(a5)
 9fe:	02061593          	slli	a1,a2,0x20
 a02:	01c5d713          	srli	a4,a1,0x1c
 a06:	973e                	add	a4,a4,a5
 a08:	fae68ae3          	beq	a3,a4,9bc <free+0x22>
    p->s.ptr = bp->s.ptr;
 a0c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a0e:	00000717          	auipc	a4,0x0
 a12:	60f73123          	sd	a5,1538(a4) # 1010 <freep>
}
 a16:	6422                	ld	s0,8(sp)
 a18:	0141                	addi	sp,sp,16
 a1a:	8082                	ret

0000000000000a1c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a1c:	7139                	addi	sp,sp,-64
 a1e:	fc06                	sd	ra,56(sp)
 a20:	f822                	sd	s0,48(sp)
 a22:	f426                	sd	s1,40(sp)
 a24:	f04a                	sd	s2,32(sp)
 a26:	ec4e                	sd	s3,24(sp)
 a28:	e852                	sd	s4,16(sp)
 a2a:	e456                	sd	s5,8(sp)
 a2c:	e05a                	sd	s6,0(sp)
 a2e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a30:	02051493          	slli	s1,a0,0x20
 a34:	9081                	srli	s1,s1,0x20
 a36:	04bd                	addi	s1,s1,15
 a38:	8091                	srli	s1,s1,0x4
 a3a:	0014899b          	addiw	s3,s1,1
 a3e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 a40:	00000517          	auipc	a0,0x0
 a44:	5d053503          	ld	a0,1488(a0) # 1010 <freep>
 a48:	c515                	beqz	a0,a74 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a4a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a4c:	4798                	lw	a4,8(a5)
 a4e:	02977f63          	bgeu	a4,s1,a8c <malloc+0x70>
 a52:	8a4e                	mv	s4,s3
 a54:	0009871b          	sext.w	a4,s3
 a58:	6685                	lui	a3,0x1
 a5a:	00d77363          	bgeu	a4,a3,a60 <malloc+0x44>
 a5e:	6a05                	lui	s4,0x1
 a60:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a64:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a68:	00000917          	auipc	s2,0x0
 a6c:	5a890913          	addi	s2,s2,1448 # 1010 <freep>
  if(p == (char*)-1)
 a70:	5afd                	li	s5,-1
 a72:	a895                	j	ae6 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 a74:	00000797          	auipc	a5,0x0
 a78:	5bc78793          	addi	a5,a5,1468 # 1030 <base>
 a7c:	00000717          	auipc	a4,0x0
 a80:	58f73a23          	sd	a5,1428(a4) # 1010 <freep>
 a84:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a86:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a8a:	b7e1                	j	a52 <malloc+0x36>
      if(p->s.size == nunits)
 a8c:	02e48c63          	beq	s1,a4,ac4 <malloc+0xa8>
        p->s.size -= nunits;
 a90:	4137073b          	subw	a4,a4,s3
 a94:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a96:	02071693          	slli	a3,a4,0x20
 a9a:	01c6d713          	srli	a4,a3,0x1c
 a9e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 aa0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 aa4:	00000717          	auipc	a4,0x0
 aa8:	56a73623          	sd	a0,1388(a4) # 1010 <freep>
      return (void*)(p + 1);
 aac:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 ab0:	70e2                	ld	ra,56(sp)
 ab2:	7442                	ld	s0,48(sp)
 ab4:	74a2                	ld	s1,40(sp)
 ab6:	7902                	ld	s2,32(sp)
 ab8:	69e2                	ld	s3,24(sp)
 aba:	6a42                	ld	s4,16(sp)
 abc:	6aa2                	ld	s5,8(sp)
 abe:	6b02                	ld	s6,0(sp)
 ac0:	6121                	addi	sp,sp,64
 ac2:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 ac4:	6398                	ld	a4,0(a5)
 ac6:	e118                	sd	a4,0(a0)
 ac8:	bff1                	j	aa4 <malloc+0x88>
  hp->s.size = nu;
 aca:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 ace:	0541                	addi	a0,a0,16
 ad0:	00000097          	auipc	ra,0x0
 ad4:	eca080e7          	jalr	-310(ra) # 99a <free>
  return freep;
 ad8:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 adc:	d971                	beqz	a0,ab0 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ade:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 ae0:	4798                	lw	a4,8(a5)
 ae2:	fa9775e3          	bgeu	a4,s1,a8c <malloc+0x70>
    if(p == freep)
 ae6:	00093703          	ld	a4,0(s2)
 aea:	853e                	mv	a0,a5
 aec:	fef719e3          	bne	a4,a5,ade <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 af0:	8552                	mv	a0,s4
 af2:	00000097          	auipc	ra,0x0
 af6:	b80080e7          	jalr	-1152(ra) # 672 <sbrk>
  if(p == (char*)-1)
 afa:	fd5518e3          	bne	a0,s5,aca <malloc+0xae>
        return 0;
 afe:	4501                	li	a0,0
 b00:	bf45                	j	ab0 <malloc+0x94>
