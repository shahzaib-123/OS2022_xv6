
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
  14:	3cc080e7          	jalr	972(ra) # 3dc <strlen>
  18:	1502                	slli	a0,a0,0x20
  1a:	9101                	srli	a0,a0,0x20
  1c:	9526                	add	a0,a0,s1
  1e:	02956163          	bltu	a0,s1,40 <fmtname+0x40>
  22:	00054703          	lbu	a4,0(a0)
  26:	02f00793          	li	a5,47
  2a:	00f70b63          	beq	a4,a5,40 <fmtname+0x40>
  2e:	02f00713          	li	a4,47
  32:	157d                	addi	a0,a0,-1
  34:	00956663          	bltu	a0,s1,40 <fmtname+0x40>
  38:	00054783          	lbu	a5,0(a0)
  3c:	fee79be3          	bne	a5,a4,32 <fmtname+0x32>
    ;
  p++;
  40:	00150493          	addi	s1,a0,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  44:	8526                	mv	a0,s1
  46:	00000097          	auipc	ra,0x0
  4a:	396080e7          	jalr	918(ra) # 3dc <strlen>
  4e:	2501                	sext.w	a0,a0
  50:	47b5                	li	a5,13
  52:	00a7fa63          	bgeu	a5,a0,66 <fmtname+0x66>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  56:	8526                	mv	a0,s1
  58:	70a2                	ld	ra,40(sp)
  5a:	7402                	ld	s0,32(sp)
  5c:	64e2                	ld	s1,24(sp)
  5e:	6942                	ld	s2,16(sp)
  60:	69a2                	ld	s3,8(sp)
  62:	6145                	addi	sp,sp,48
  64:	8082                	ret
  memmove(buf, p, strlen(p));
  66:	8526                	mv	a0,s1
  68:	00000097          	auipc	ra,0x0
  6c:	374080e7          	jalr	884(ra) # 3dc <strlen>
  70:	00001917          	auipc	s2,0x1
  74:	fb090913          	addi	s2,s2,-80 # 1020 <buf.1127>
  78:	0005061b          	sext.w	a2,a0
  7c:	85a6                	mv	a1,s1
  7e:	854a                	mv	a0,s2
  80:	00000097          	auipc	ra,0x0
  84:	4da080e7          	jalr	1242(ra) # 55a <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  88:	8526                	mv	a0,s1
  8a:	00000097          	auipc	ra,0x0
  8e:	352080e7          	jalr	850(ra) # 3dc <strlen>
  92:	0005099b          	sext.w	s3,a0
  96:	8526                	mv	a0,s1
  98:	00000097          	auipc	ra,0x0
  9c:	344080e7          	jalr	836(ra) # 3dc <strlen>
  a0:	1982                	slli	s3,s3,0x20
  a2:	0209d993          	srli	s3,s3,0x20
  a6:	4639                	li	a2,14
  a8:	9e09                	subw	a2,a2,a0
  aa:	02000593          	li	a1,32
  ae:	01390533          	add	a0,s2,s3
  b2:	00000097          	auipc	ra,0x0
  b6:	354080e7          	jalr	852(ra) # 406 <memset>
  return buf;
  ba:	84ca                	mv	s1,s2
  bc:	bf69                	j	56 <fmtname+0x56>

00000000000000be <ls>:

void
ls(char *path,int flag)
{
  be:	d8010113          	addi	sp,sp,-640
  c2:	26113c23          	sd	ra,632(sp)
  c6:	26813823          	sd	s0,624(sp)
  ca:	26913423          	sd	s1,616(sp)
  ce:	27213023          	sd	s2,608(sp)
  d2:	25313c23          	sd	s3,600(sp)
  d6:	25413823          	sd	s4,592(sp)
  da:	25513423          	sd	s5,584(sp)
  de:	25613023          	sd	s6,576(sp)
  e2:	23713c23          	sd	s7,568(sp)
  e6:	23813823          	sd	s8,560(sp)
  ea:	0500                	addi	s0,sp,640
  ec:	892a                	mv	s2,a0
  ee:	89ae                	mv	s3,a1
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;
  if((fd = open(path, 0)) < 0){
  f0:	4581                	li	a1,0
  f2:	00000097          	auipc	ra,0x0
  f6:	56a080e7          	jalr	1386(ra) # 65c <open>
  fa:	08054963          	bltz	a0,18c <ls+0xce>
  fe:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
 100:	d8840593          	addi	a1,s0,-632
 104:	00000097          	auipc	ra,0x0
 108:	570080e7          	jalr	1392(ra) # 674 <fstat>
 10c:	08054b63          	bltz	a0,1a2 <ls+0xe4>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
 110:	d9041783          	lh	a5,-624(s0)
 114:	0007869b          	sext.w	a3,a5
 118:	4705                	li	a4,1
 11a:	0ce68863          	beq	a3,a4,1ea <ls+0x12c>
 11e:	02d05b63          	blez	a3,154 <ls+0x96>
 122:	470d                	li	a4,3
 124:	02d74863          	blt	a4,a3,154 <ls+0x96>
  case T_DEVICE:
  case T_FILE:
    if(flag>=1){
 128:	09304d63          	bgtz	s3,1c2 <ls+0x104>
        printf("%d\t",counter);
        counter+=1;
        }
    printf("%s %d %d %l\n", fmtname(path), st.type, st.ino, st.size);
 12c:	854a                	mv	a0,s2
 12e:	00000097          	auipc	ra,0x0
 132:	ed2080e7          	jalr	-302(ra) # 0 <fmtname>
 136:	d9843703          	ld	a4,-616(s0)
 13a:	d8c42683          	lw	a3,-628(s0)
 13e:	d9041603          	lh	a2,-624(s0)
 142:	85aa                	mv	a1,a0
 144:	00001517          	auipc	a0,0x1
 148:	a3450513          	addi	a0,a0,-1484 # b78 <malloc+0x124>
 14c:	00001097          	auipc	ra,0x1
 150:	848080e7          	jalr	-1976(ra) # 994 <printf>
        }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
 154:	8526                	mv	a0,s1
 156:	00000097          	auipc	ra,0x0
 15a:	4ee080e7          	jalr	1262(ra) # 644 <close>
}
 15e:	27813083          	ld	ra,632(sp)
 162:	27013403          	ld	s0,624(sp)
 166:	26813483          	ld	s1,616(sp)
 16a:	26013903          	ld	s2,608(sp)
 16e:	25813983          	ld	s3,600(sp)
 172:	25013a03          	ld	s4,592(sp)
 176:	24813a83          	ld	s5,584(sp)
 17a:	24013b03          	ld	s6,576(sp)
 17e:	23813b83          	ld	s7,568(sp)
 182:	23013c03          	ld	s8,560(sp)
 186:	28010113          	addi	sp,sp,640
 18a:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 18c:	864a                	mv	a2,s2
 18e:	00001597          	auipc	a1,0x1
 192:	9b258593          	addi	a1,a1,-1614 # b40 <malloc+0xec>
 196:	4509                	li	a0,2
 198:	00000097          	auipc	ra,0x0
 19c:	7ce080e7          	jalr	1998(ra) # 966 <fprintf>
    return;
 1a0:	bf7d                	j	15e <ls+0xa0>
    fprintf(2, "ls: cannot stat %s\n", path);
 1a2:	864a                	mv	a2,s2
 1a4:	00001597          	auipc	a1,0x1
 1a8:	9b458593          	addi	a1,a1,-1612 # b58 <malloc+0x104>
 1ac:	4509                	li	a0,2
 1ae:	00000097          	auipc	ra,0x0
 1b2:	7b8080e7          	jalr	1976(ra) # 966 <fprintf>
    close(fd);
 1b6:	8526                	mv	a0,s1
 1b8:	00000097          	auipc	ra,0x0
 1bc:	48c080e7          	jalr	1164(ra) # 644 <close>
    return;
 1c0:	bf79                	j	15e <ls+0xa0>
        printf("%d\t",counter);
 1c2:	00001997          	auipc	s3,0x1
 1c6:	e3e98993          	addi	s3,s3,-450 # 1000 <counter>
 1ca:	0009a583          	lw	a1,0(s3)
 1ce:	00001517          	auipc	a0,0x1
 1d2:	9a250513          	addi	a0,a0,-1630 # b70 <malloc+0x11c>
 1d6:	00000097          	auipc	ra,0x0
 1da:	7be080e7          	jalr	1982(ra) # 994 <printf>
        counter+=1;
 1de:	0009a783          	lw	a5,0(s3)
 1e2:	2785                	addiw	a5,a5,1
 1e4:	00f9a023          	sw	a5,0(s3)
 1e8:	b791                	j	12c <ls+0x6e>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 1ea:	854a                	mv	a0,s2
 1ec:	00000097          	auipc	ra,0x0
 1f0:	1f0080e7          	jalr	496(ra) # 3dc <strlen>
 1f4:	2541                	addiw	a0,a0,16
 1f6:	20000793          	li	a5,512
 1fa:	00a7fb63          	bgeu	a5,a0,210 <ls+0x152>
      printf("ls: path too long\n");
 1fe:	00001517          	auipc	a0,0x1
 202:	98a50513          	addi	a0,a0,-1654 # b88 <malloc+0x134>
 206:	00000097          	auipc	ra,0x0
 20a:	78e080e7          	jalr	1934(ra) # 994 <printf>
      break;
 20e:	b799                	j	154 <ls+0x96>
    strcpy(buf, path);
 210:	85ca                	mv	a1,s2
 212:	db040513          	addi	a0,s0,-592
 216:	00000097          	auipc	ra,0x0
 21a:	176080e7          	jalr	374(ra) # 38c <strcpy>
    p = buf+strlen(buf);
 21e:	db040513          	addi	a0,s0,-592
 222:	00000097          	auipc	ra,0x0
 226:	1ba080e7          	jalr	442(ra) # 3dc <strlen>
 22a:	1502                	slli	a0,a0,0x20
 22c:	9101                	srli	a0,a0,0x20
 22e:	db040793          	addi	a5,s0,-592
 232:	00a78933          	add	s2,a5,a0
    *p++ = '/';
 236:	00190a93          	addi	s5,s2,1
 23a:	02f00793          	li	a5,47
 23e:	00f90023          	sb	a5,0(s2)
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 242:	00001b17          	auipc	s6,0x1
 246:	95eb0b13          	addi	s6,s6,-1698 # ba0 <malloc+0x14c>
        printf("%d\t",counter);
 24a:	00001a17          	auipc	s4,0x1
 24e:	db6a0a13          	addi	s4,s4,-586 # 1000 <counter>
 252:	00001b97          	auipc	s7,0x1
 256:	91eb8b93          	addi	s7,s7,-1762 # b70 <malloc+0x11c>
        printf("ls: cannot stat %s\n", buf);
 25a:	00001c17          	auipc	s8,0x1
 25e:	8fec0c13          	addi	s8,s8,-1794 # b58 <malloc+0x104>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 262:	a81d                	j	298 <ls+0x1da>
        printf("ls: cannot stat %s\n", buf);
 264:	db040593          	addi	a1,s0,-592
 268:	8562                	mv	a0,s8
 26a:	00000097          	auipc	ra,0x0
 26e:	72a080e7          	jalr	1834(ra) # 994 <printf>
        continue;
 272:	a01d                	j	298 <ls+0x1da>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 274:	db040513          	addi	a0,s0,-592
 278:	00000097          	auipc	ra,0x0
 27c:	d88080e7          	jalr	-632(ra) # 0 <fmtname>
 280:	d9843703          	ld	a4,-616(s0)
 284:	d8c42683          	lw	a3,-628(s0)
 288:	d9041603          	lh	a2,-624(s0)
 28c:	85aa                	mv	a1,a0
 28e:	855a                	mv	a0,s6
 290:	00000097          	auipc	ra,0x0
 294:	704080e7          	jalr	1796(ra) # 994 <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 298:	4641                	li	a2,16
 29a:	da040593          	addi	a1,s0,-608
 29e:	8526                	mv	a0,s1
 2a0:	00000097          	auipc	ra,0x0
 2a4:	394080e7          	jalr	916(ra) # 634 <read>
 2a8:	47c1                	li	a5,16
 2aa:	eaf515e3          	bne	a0,a5,154 <ls+0x96>
      if(de.inum == 0)
 2ae:	da045783          	lhu	a5,-608(s0)
 2b2:	d3fd                	beqz	a5,298 <ls+0x1da>
      memmove(p, de.name, DIRSIZ);
 2b4:	4639                	li	a2,14
 2b6:	da240593          	addi	a1,s0,-606
 2ba:	8556                	mv	a0,s5
 2bc:	00000097          	auipc	ra,0x0
 2c0:	29e080e7          	jalr	670(ra) # 55a <memmove>
      p[DIRSIZ] = 0;
 2c4:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){
 2c8:	d8840593          	addi	a1,s0,-632
 2cc:	db040513          	addi	a0,s0,-592
 2d0:	00000097          	auipc	ra,0x0
 2d4:	1fa080e7          	jalr	506(ra) # 4ca <stat>
 2d8:	f80546e3          	bltz	a0,264 <ls+0x1a6>
      if(flag>=1){
 2dc:	f9305ce3          	blez	s3,274 <ls+0x1b6>
        printf("%d\t",counter);
 2e0:	000a2583          	lw	a1,0(s4)
 2e4:	855e                	mv	a0,s7
 2e6:	00000097          	auipc	ra,0x0
 2ea:	6ae080e7          	jalr	1710(ra) # 994 <printf>
        counter+=1;
 2ee:	000a2783          	lw	a5,0(s4)
 2f2:	2785                	addiw	a5,a5,1
 2f4:	00fa2023          	sw	a5,0(s4)
 2f8:	bfb5                	j	274 <ls+0x1b6>

00000000000002fa <main>:

int
main(int argc, char *argv[])
{
 2fa:	7179                	addi	sp,sp,-48
 2fc:	f406                	sd	ra,40(sp)
 2fe:	f022                	sd	s0,32(sp)
 300:	ec26                	sd	s1,24(sp)
 302:	e84a                	sd	s2,16(sp)
 304:	e44e                	sd	s3,8(sp)
 306:	1800                	addi	s0,sp,48
 308:	89aa                	mv	s3,a0
 30a:	892e                	mv	s2,a1
  int flag=0;
  int i;
  if(strcmp(argv[1],"-n")==0)
 30c:	00001597          	auipc	a1,0x1
 310:	8a458593          	addi	a1,a1,-1884 # bb0 <malloc+0x15c>
 314:	00893503          	ld	a0,8(s2)
 318:	00000097          	auipc	ra,0x0
 31c:	090080e7          	jalr	144(ra) # 3a8 <strcmp>
 320:	00153513          	seqz	a0,a0
  int flag=0;
 324:	0005059b          	sext.w	a1,a0
  {
    flag+=1;
  }
  if(argc < 2+flag){
 328:	2505                	addiw	a0,a0,1
 32a:	0005049b          	sext.w	s1,a0
 32e:	00349793          	slli	a5,s1,0x3
 332:	993e                	add	s2,s2,a5
 334:	0334d263          	bge	s1,s3,358 <main+0x5e>
    ls(".",flag);
    exit(0);
  }
  for(i=flag+1; i<argc; i++)
    ls(argv[i],i);
 338:	85a6                	mv	a1,s1
 33a:	00093503          	ld	a0,0(s2)
 33e:	00000097          	auipc	ra,0x0
 342:	d80080e7          	jalr	-640(ra) # be <ls>
  for(i=flag+1; i<argc; i++)
 346:	2485                	addiw	s1,s1,1
 348:	0921                	addi	s2,s2,8
 34a:	fe9997e3          	bne	s3,s1,338 <main+0x3e>
  exit(0);
 34e:	4501                	li	a0,0
 350:	00000097          	auipc	ra,0x0
 354:	2cc080e7          	jalr	716(ra) # 61c <exit>
    ls(".",flag);
 358:	00001517          	auipc	a0,0x1
 35c:	86050513          	addi	a0,a0,-1952 # bb8 <malloc+0x164>
 360:	00000097          	auipc	ra,0x0
 364:	d5e080e7          	jalr	-674(ra) # be <ls>
    exit(0);
 368:	4501                	li	a0,0
 36a:	00000097          	auipc	ra,0x0
 36e:	2b2080e7          	jalr	690(ra) # 61c <exit>

0000000000000372 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 372:	1141                	addi	sp,sp,-16
 374:	e406                	sd	ra,8(sp)
 376:	e022                	sd	s0,0(sp)
 378:	0800                	addi	s0,sp,16
  extern int main();
  main();
 37a:	00000097          	auipc	ra,0x0
 37e:	f80080e7          	jalr	-128(ra) # 2fa <main>
  exit(0);
 382:	4501                	li	a0,0
 384:	00000097          	auipc	ra,0x0
 388:	298080e7          	jalr	664(ra) # 61c <exit>

000000000000038c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 38c:	1141                	addi	sp,sp,-16
 38e:	e422                	sd	s0,8(sp)
 390:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 392:	87aa                	mv	a5,a0
 394:	0585                	addi	a1,a1,1
 396:	0785                	addi	a5,a5,1
 398:	fff5c703          	lbu	a4,-1(a1)
 39c:	fee78fa3          	sb	a4,-1(a5)
 3a0:	fb75                	bnez	a4,394 <strcpy+0x8>
    ;
  return os;
}
 3a2:	6422                	ld	s0,8(sp)
 3a4:	0141                	addi	sp,sp,16
 3a6:	8082                	ret

00000000000003a8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3a8:	1141                	addi	sp,sp,-16
 3aa:	e422                	sd	s0,8(sp)
 3ac:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 3ae:	00054783          	lbu	a5,0(a0)
 3b2:	cf91                	beqz	a5,3ce <strcmp+0x26>
 3b4:	0005c703          	lbu	a4,0(a1)
 3b8:	00f71b63          	bne	a4,a5,3ce <strcmp+0x26>
    p++, q++;
 3bc:	0505                	addi	a0,a0,1
 3be:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 3c0:	00054783          	lbu	a5,0(a0)
 3c4:	c789                	beqz	a5,3ce <strcmp+0x26>
 3c6:	0005c703          	lbu	a4,0(a1)
 3ca:	fef709e3          	beq	a4,a5,3bc <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 3ce:	0005c503          	lbu	a0,0(a1)
}
 3d2:	40a7853b          	subw	a0,a5,a0
 3d6:	6422                	ld	s0,8(sp)
 3d8:	0141                	addi	sp,sp,16
 3da:	8082                	ret

00000000000003dc <strlen>:

uint
strlen(const char *s)
{
 3dc:	1141                	addi	sp,sp,-16
 3de:	e422                	sd	s0,8(sp)
 3e0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 3e2:	00054783          	lbu	a5,0(a0)
 3e6:	cf91                	beqz	a5,402 <strlen+0x26>
 3e8:	0505                	addi	a0,a0,1
 3ea:	87aa                	mv	a5,a0
 3ec:	4685                	li	a3,1
 3ee:	9e89                	subw	a3,a3,a0
 3f0:	00f6853b          	addw	a0,a3,a5
 3f4:	0785                	addi	a5,a5,1
 3f6:	fff7c703          	lbu	a4,-1(a5)
 3fa:	fb7d                	bnez	a4,3f0 <strlen+0x14>
    ;
  return n;
}
 3fc:	6422                	ld	s0,8(sp)
 3fe:	0141                	addi	sp,sp,16
 400:	8082                	ret
  for(n = 0; s[n]; n++)
 402:	4501                	li	a0,0
 404:	bfe5                	j	3fc <strlen+0x20>

0000000000000406 <memset>:

void*
memset(void *dst, int c, uint n)
{
 406:	1141                	addi	sp,sp,-16
 408:	e422                	sd	s0,8(sp)
 40a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 40c:	ce09                	beqz	a2,426 <memset+0x20>
 40e:	87aa                	mv	a5,a0
 410:	fff6071b          	addiw	a4,a2,-1
 414:	1702                	slli	a4,a4,0x20
 416:	9301                	srli	a4,a4,0x20
 418:	0705                	addi	a4,a4,1
 41a:	972a                	add	a4,a4,a0
    cdst[i] = c;
 41c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 420:	0785                	addi	a5,a5,1
 422:	fee79de3          	bne	a5,a4,41c <memset+0x16>
  }
  return dst;
}
 426:	6422                	ld	s0,8(sp)
 428:	0141                	addi	sp,sp,16
 42a:	8082                	ret

000000000000042c <strchr>:

char*
strchr(const char *s, char c)
{
 42c:	1141                	addi	sp,sp,-16
 42e:	e422                	sd	s0,8(sp)
 430:	0800                	addi	s0,sp,16
  for(; *s; s++)
 432:	00054783          	lbu	a5,0(a0)
 436:	cf91                	beqz	a5,452 <strchr+0x26>
    if(*s == c)
 438:	00f58a63          	beq	a1,a5,44c <strchr+0x20>
  for(; *s; s++)
 43c:	0505                	addi	a0,a0,1
 43e:	00054783          	lbu	a5,0(a0)
 442:	c781                	beqz	a5,44a <strchr+0x1e>
    if(*s == c)
 444:	feb79ce3          	bne	a5,a1,43c <strchr+0x10>
 448:	a011                	j	44c <strchr+0x20>
      return (char*)s;
  return 0;
 44a:	4501                	li	a0,0
}
 44c:	6422                	ld	s0,8(sp)
 44e:	0141                	addi	sp,sp,16
 450:	8082                	ret
  return 0;
 452:	4501                	li	a0,0
 454:	bfe5                	j	44c <strchr+0x20>

0000000000000456 <gets>:

char*
gets(char *buf, int max)
{
 456:	711d                	addi	sp,sp,-96
 458:	ec86                	sd	ra,88(sp)
 45a:	e8a2                	sd	s0,80(sp)
 45c:	e4a6                	sd	s1,72(sp)
 45e:	e0ca                	sd	s2,64(sp)
 460:	fc4e                	sd	s3,56(sp)
 462:	f852                	sd	s4,48(sp)
 464:	f456                	sd	s5,40(sp)
 466:	f05a                	sd	s6,32(sp)
 468:	ec5e                	sd	s7,24(sp)
 46a:	1080                	addi	s0,sp,96
 46c:	8baa                	mv	s7,a0
 46e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 470:	892a                	mv	s2,a0
 472:	4981                	li	s3,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 474:	4aa9                	li	s5,10
 476:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 478:	0019849b          	addiw	s1,s3,1
 47c:	0344d863          	bge	s1,s4,4ac <gets+0x56>
    cc = read(0, &c, 1);
 480:	4605                	li	a2,1
 482:	faf40593          	addi	a1,s0,-81
 486:	4501                	li	a0,0
 488:	00000097          	auipc	ra,0x0
 48c:	1ac080e7          	jalr	428(ra) # 634 <read>
    if(cc < 1)
 490:	00a05e63          	blez	a0,4ac <gets+0x56>
    buf[i++] = c;
 494:	faf44783          	lbu	a5,-81(s0)
 498:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 49c:	01578763          	beq	a5,s5,4aa <gets+0x54>
 4a0:	0905                	addi	s2,s2,1
  for(i=0; i+1 < max; ){
 4a2:	89a6                	mv	s3,s1
    if(c == '\n' || c == '\r')
 4a4:	fd679ae3          	bne	a5,s6,478 <gets+0x22>
 4a8:	a011                	j	4ac <gets+0x56>
  for(i=0; i+1 < max; ){
 4aa:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 4ac:	99de                	add	s3,s3,s7
 4ae:	00098023          	sb	zero,0(s3)
  return buf;
}
 4b2:	855e                	mv	a0,s7
 4b4:	60e6                	ld	ra,88(sp)
 4b6:	6446                	ld	s0,80(sp)
 4b8:	64a6                	ld	s1,72(sp)
 4ba:	6906                	ld	s2,64(sp)
 4bc:	79e2                	ld	s3,56(sp)
 4be:	7a42                	ld	s4,48(sp)
 4c0:	7aa2                	ld	s5,40(sp)
 4c2:	7b02                	ld	s6,32(sp)
 4c4:	6be2                	ld	s7,24(sp)
 4c6:	6125                	addi	sp,sp,96
 4c8:	8082                	ret

00000000000004ca <stat>:

int
stat(const char *n, struct stat *st)
{
 4ca:	1101                	addi	sp,sp,-32
 4cc:	ec06                	sd	ra,24(sp)
 4ce:	e822                	sd	s0,16(sp)
 4d0:	e426                	sd	s1,8(sp)
 4d2:	e04a                	sd	s2,0(sp)
 4d4:	1000                	addi	s0,sp,32
 4d6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4d8:	4581                	li	a1,0
 4da:	00000097          	auipc	ra,0x0
 4de:	182080e7          	jalr	386(ra) # 65c <open>
  if(fd < 0)
 4e2:	02054563          	bltz	a0,50c <stat+0x42>
 4e6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 4e8:	85ca                	mv	a1,s2
 4ea:	00000097          	auipc	ra,0x0
 4ee:	18a080e7          	jalr	394(ra) # 674 <fstat>
 4f2:	892a                	mv	s2,a0
  close(fd);
 4f4:	8526                	mv	a0,s1
 4f6:	00000097          	auipc	ra,0x0
 4fa:	14e080e7          	jalr	334(ra) # 644 <close>
  return r;
}
 4fe:	854a                	mv	a0,s2
 500:	60e2                	ld	ra,24(sp)
 502:	6442                	ld	s0,16(sp)
 504:	64a2                	ld	s1,8(sp)
 506:	6902                	ld	s2,0(sp)
 508:	6105                	addi	sp,sp,32
 50a:	8082                	ret
    return -1;
 50c:	597d                	li	s2,-1
 50e:	bfc5                	j	4fe <stat+0x34>

0000000000000510 <atoi>:

int
atoi(const char *s)
{
 510:	1141                	addi	sp,sp,-16
 512:	e422                	sd	s0,8(sp)
 514:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 516:	00054683          	lbu	a3,0(a0)
 51a:	fd06879b          	addiw	a5,a3,-48
 51e:	0ff7f793          	andi	a5,a5,255
 522:	4725                	li	a4,9
 524:	02f76963          	bltu	a4,a5,556 <atoi+0x46>
 528:	862a                	mv	a2,a0
  n = 0;
 52a:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 52c:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 52e:	0605                	addi	a2,a2,1
 530:	0025179b          	slliw	a5,a0,0x2
 534:	9fa9                	addw	a5,a5,a0
 536:	0017979b          	slliw	a5,a5,0x1
 53a:	9fb5                	addw	a5,a5,a3
 53c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 540:	00064683          	lbu	a3,0(a2)
 544:	fd06871b          	addiw	a4,a3,-48
 548:	0ff77713          	andi	a4,a4,255
 54c:	fee5f1e3          	bgeu	a1,a4,52e <atoi+0x1e>
  return n;
}
 550:	6422                	ld	s0,8(sp)
 552:	0141                	addi	sp,sp,16
 554:	8082                	ret
  n = 0;
 556:	4501                	li	a0,0
 558:	bfe5                	j	550 <atoi+0x40>

000000000000055a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 55a:	1141                	addi	sp,sp,-16
 55c:	e422                	sd	s0,8(sp)
 55e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 560:	02b57663          	bgeu	a0,a1,58c <memmove+0x32>
    while(n-- > 0)
 564:	02c05163          	blez	a2,586 <memmove+0x2c>
 568:	fff6079b          	addiw	a5,a2,-1
 56c:	1782                	slli	a5,a5,0x20
 56e:	9381                	srli	a5,a5,0x20
 570:	0785                	addi	a5,a5,1
 572:	97aa                	add	a5,a5,a0
  dst = vdst;
 574:	872a                	mv	a4,a0
      *dst++ = *src++;
 576:	0585                	addi	a1,a1,1
 578:	0705                	addi	a4,a4,1
 57a:	fff5c683          	lbu	a3,-1(a1)
 57e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 582:	fee79ae3          	bne	a5,a4,576 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 586:	6422                	ld	s0,8(sp)
 588:	0141                	addi	sp,sp,16
 58a:	8082                	ret
    dst += n;
 58c:	00c50733          	add	a4,a0,a2
    src += n;
 590:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 592:	fec05ae3          	blez	a2,586 <memmove+0x2c>
 596:	fff6079b          	addiw	a5,a2,-1
 59a:	1782                	slli	a5,a5,0x20
 59c:	9381                	srli	a5,a5,0x20
 59e:	fff7c793          	not	a5,a5
 5a2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 5a4:	15fd                	addi	a1,a1,-1
 5a6:	177d                	addi	a4,a4,-1
 5a8:	0005c683          	lbu	a3,0(a1)
 5ac:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 5b0:	fef71ae3          	bne	a4,a5,5a4 <memmove+0x4a>
 5b4:	bfc9                	j	586 <memmove+0x2c>

00000000000005b6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 5b6:	1141                	addi	sp,sp,-16
 5b8:	e422                	sd	s0,8(sp)
 5ba:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 5bc:	ce15                	beqz	a2,5f8 <memcmp+0x42>
 5be:	fff6069b          	addiw	a3,a2,-1
    if (*p1 != *p2) {
 5c2:	00054783          	lbu	a5,0(a0)
 5c6:	0005c703          	lbu	a4,0(a1)
 5ca:	02e79063          	bne	a5,a4,5ea <memcmp+0x34>
 5ce:	1682                	slli	a3,a3,0x20
 5d0:	9281                	srli	a3,a3,0x20
 5d2:	0685                	addi	a3,a3,1
 5d4:	96aa                	add	a3,a3,a0
      return *p1 - *p2;
    }
    p1++;
 5d6:	0505                	addi	a0,a0,1
    p2++;
 5d8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 5da:	00d50d63          	beq	a0,a3,5f4 <memcmp+0x3e>
    if (*p1 != *p2) {
 5de:	00054783          	lbu	a5,0(a0)
 5e2:	0005c703          	lbu	a4,0(a1)
 5e6:	fee788e3          	beq	a5,a4,5d6 <memcmp+0x20>
      return *p1 - *p2;
 5ea:	40e7853b          	subw	a0,a5,a4
  }
  return 0;
}
 5ee:	6422                	ld	s0,8(sp)
 5f0:	0141                	addi	sp,sp,16
 5f2:	8082                	ret
  return 0;
 5f4:	4501                	li	a0,0
 5f6:	bfe5                	j	5ee <memcmp+0x38>
 5f8:	4501                	li	a0,0
 5fa:	bfd5                	j	5ee <memcmp+0x38>

00000000000005fc <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 5fc:	1141                	addi	sp,sp,-16
 5fe:	e406                	sd	ra,8(sp)
 600:	e022                	sd	s0,0(sp)
 602:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 604:	00000097          	auipc	ra,0x0
 608:	f56080e7          	jalr	-170(ra) # 55a <memmove>
}
 60c:	60a2                	ld	ra,8(sp)
 60e:	6402                	ld	s0,0(sp)
 610:	0141                	addi	sp,sp,16
 612:	8082                	ret

0000000000000614 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 614:	4885                	li	a7,1
 ecall
 616:	00000073          	ecall
 ret
 61a:	8082                	ret

000000000000061c <exit>:
.global exit
exit:
 li a7, SYS_exit
 61c:	4889                	li	a7,2
 ecall
 61e:	00000073          	ecall
 ret
 622:	8082                	ret

0000000000000624 <wait>:
.global wait
wait:
 li a7, SYS_wait
 624:	488d                	li	a7,3
 ecall
 626:	00000073          	ecall
 ret
 62a:	8082                	ret

000000000000062c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 62c:	4891                	li	a7,4
 ecall
 62e:	00000073          	ecall
 ret
 632:	8082                	ret

0000000000000634 <read>:
.global read
read:
 li a7, SYS_read
 634:	4895                	li	a7,5
 ecall
 636:	00000073          	ecall
 ret
 63a:	8082                	ret

000000000000063c <write>:
.global write
write:
 li a7, SYS_write
 63c:	48c1                	li	a7,16
 ecall
 63e:	00000073          	ecall
 ret
 642:	8082                	ret

0000000000000644 <close>:
.global close
close:
 li a7, SYS_close
 644:	48d5                	li	a7,21
 ecall
 646:	00000073          	ecall
 ret
 64a:	8082                	ret

000000000000064c <kill>:
.global kill
kill:
 li a7, SYS_kill
 64c:	4899                	li	a7,6
 ecall
 64e:	00000073          	ecall
 ret
 652:	8082                	ret

0000000000000654 <exec>:
.global exec
exec:
 li a7, SYS_exec
 654:	489d                	li	a7,7
 ecall
 656:	00000073          	ecall
 ret
 65a:	8082                	ret

000000000000065c <open>:
.global open
open:
 li a7, SYS_open
 65c:	48bd                	li	a7,15
 ecall
 65e:	00000073          	ecall
 ret
 662:	8082                	ret

0000000000000664 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 664:	48c5                	li	a7,17
 ecall
 666:	00000073          	ecall
 ret
 66a:	8082                	ret

000000000000066c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 66c:	48c9                	li	a7,18
 ecall
 66e:	00000073          	ecall
 ret
 672:	8082                	ret

0000000000000674 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 674:	48a1                	li	a7,8
 ecall
 676:	00000073          	ecall
 ret
 67a:	8082                	ret

000000000000067c <link>:
.global link
link:
 li a7, SYS_link
 67c:	48cd                	li	a7,19
 ecall
 67e:	00000073          	ecall
 ret
 682:	8082                	ret

0000000000000684 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 684:	48d1                	li	a7,20
 ecall
 686:	00000073          	ecall
 ret
 68a:	8082                	ret

000000000000068c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 68c:	48a5                	li	a7,9
 ecall
 68e:	00000073          	ecall
 ret
 692:	8082                	ret

0000000000000694 <dup>:
.global dup
dup:
 li a7, SYS_dup
 694:	48a9                	li	a7,10
 ecall
 696:	00000073          	ecall
 ret
 69a:	8082                	ret

000000000000069c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 69c:	48ad                	li	a7,11
 ecall
 69e:	00000073          	ecall
 ret
 6a2:	8082                	ret

00000000000006a4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 6a4:	48b1                	li	a7,12
 ecall
 6a6:	00000073          	ecall
 ret
 6aa:	8082                	ret

00000000000006ac <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 6ac:	48b5                	li	a7,13
 ecall
 6ae:	00000073          	ecall
 ret
 6b2:	8082                	ret

00000000000006b4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 6b4:	48b9                	li	a7,14
 ecall
 6b6:	00000073          	ecall
 ret
 6ba:	8082                	ret

00000000000006bc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 6bc:	1101                	addi	sp,sp,-32
 6be:	ec06                	sd	ra,24(sp)
 6c0:	e822                	sd	s0,16(sp)
 6c2:	1000                	addi	s0,sp,32
 6c4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 6c8:	4605                	li	a2,1
 6ca:	fef40593          	addi	a1,s0,-17
 6ce:	00000097          	auipc	ra,0x0
 6d2:	f6e080e7          	jalr	-146(ra) # 63c <write>
}
 6d6:	60e2                	ld	ra,24(sp)
 6d8:	6442                	ld	s0,16(sp)
 6da:	6105                	addi	sp,sp,32
 6dc:	8082                	ret

00000000000006de <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6de:	7139                	addi	sp,sp,-64
 6e0:	fc06                	sd	ra,56(sp)
 6e2:	f822                	sd	s0,48(sp)
 6e4:	f426                	sd	s1,40(sp)
 6e6:	f04a                	sd	s2,32(sp)
 6e8:	ec4e                	sd	s3,24(sp)
 6ea:	0080                	addi	s0,sp,64
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 6ec:	c299                	beqz	a3,6f2 <printint+0x14>
 6ee:	0005cd63          	bltz	a1,708 <printint+0x2a>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 6f2:	2581                	sext.w	a1,a1
  neg = 0;
 6f4:	4301                	li	t1,0
 6f6:	fc040713          	addi	a4,s0,-64
  }

  i = 0;
 6fa:	4801                	li	a6,0
  do{
    buf[i++] = digits[x % base];
 6fc:	2601                	sext.w	a2,a2
 6fe:	00000897          	auipc	a7,0x0
 702:	4c288893          	addi	a7,a7,1218 # bc0 <digits>
 706:	a801                	j	716 <printint+0x38>
    x = -xx;
 708:	40b005bb          	negw	a1,a1
 70c:	2581                	sext.w	a1,a1
    neg = 1;
 70e:	4305                	li	t1,1
    x = -xx;
 710:	b7dd                	j	6f6 <printint+0x18>
  }while((x /= base) != 0);
 712:	85be                	mv	a1,a5
    buf[i++] = digits[x % base];
 714:	8836                	mv	a6,a3
 716:	0018069b          	addiw	a3,a6,1
 71a:	02c5f7bb          	remuw	a5,a1,a2
 71e:	1782                	slli	a5,a5,0x20
 720:	9381                	srli	a5,a5,0x20
 722:	97c6                	add	a5,a5,a7
 724:	0007c783          	lbu	a5,0(a5)
 728:	00f70023          	sb	a5,0(a4)
  }while((x /= base) != 0);
 72c:	0705                	addi	a4,a4,1
 72e:	02c5d7bb          	divuw	a5,a1,a2
 732:	fec5f0e3          	bgeu	a1,a2,712 <printint+0x34>
  if(neg)
 736:	00030b63          	beqz	t1,74c <printint+0x6e>
    buf[i++] = '-';
 73a:	fd040793          	addi	a5,s0,-48
 73e:	96be                	add	a3,a3,a5
 740:	02d00793          	li	a5,45
 744:	fef68823          	sb	a5,-16(a3)
 748:	0028069b          	addiw	a3,a6,2

  while(--i >= 0)
 74c:	02d05963          	blez	a3,77e <printint+0xa0>
 750:	89aa                	mv	s3,a0
 752:	fc040793          	addi	a5,s0,-64
 756:	00d784b3          	add	s1,a5,a3
 75a:	fff78913          	addi	s2,a5,-1
 75e:	9936                	add	s2,s2,a3
 760:	36fd                	addiw	a3,a3,-1
 762:	1682                	slli	a3,a3,0x20
 764:	9281                	srli	a3,a3,0x20
 766:	40d90933          	sub	s2,s2,a3
    putc(fd, buf[i]);
 76a:	fff4c583          	lbu	a1,-1(s1)
 76e:	854e                	mv	a0,s3
 770:	00000097          	auipc	ra,0x0
 774:	f4c080e7          	jalr	-180(ra) # 6bc <putc>
  while(--i >= 0)
 778:	14fd                	addi	s1,s1,-1
 77a:	ff2498e3          	bne	s1,s2,76a <printint+0x8c>
}
 77e:	70e2                	ld	ra,56(sp)
 780:	7442                	ld	s0,48(sp)
 782:	74a2                	ld	s1,40(sp)
 784:	7902                	ld	s2,32(sp)
 786:	69e2                	ld	s3,24(sp)
 788:	6121                	addi	sp,sp,64
 78a:	8082                	ret

000000000000078c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 78c:	7119                	addi	sp,sp,-128
 78e:	fc86                	sd	ra,120(sp)
 790:	f8a2                	sd	s0,112(sp)
 792:	f4a6                	sd	s1,104(sp)
 794:	f0ca                	sd	s2,96(sp)
 796:	ecce                	sd	s3,88(sp)
 798:	e8d2                	sd	s4,80(sp)
 79a:	e4d6                	sd	s5,72(sp)
 79c:	e0da                	sd	s6,64(sp)
 79e:	fc5e                	sd	s7,56(sp)
 7a0:	f862                	sd	s8,48(sp)
 7a2:	f466                	sd	s9,40(sp)
 7a4:	f06a                	sd	s10,32(sp)
 7a6:	ec6e                	sd	s11,24(sp)
 7a8:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 7aa:	0005c483          	lbu	s1,0(a1)
 7ae:	18048d63          	beqz	s1,948 <vprintf+0x1bc>
 7b2:	8aaa                	mv	s5,a0
 7b4:	8b32                	mv	s6,a2
 7b6:	00158913          	addi	s2,a1,1
  state = 0;
 7ba:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 7bc:	02500a13          	li	s4,37
      if(c == 'd'){
 7c0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 7c4:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 7c8:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 7cc:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7d0:	00000b97          	auipc	s7,0x0
 7d4:	3f0b8b93          	addi	s7,s7,1008 # bc0 <digits>
 7d8:	a839                	j	7f6 <vprintf+0x6a>
        putc(fd, c);
 7da:	85a6                	mv	a1,s1
 7dc:	8556                	mv	a0,s5
 7de:	00000097          	auipc	ra,0x0
 7e2:	ede080e7          	jalr	-290(ra) # 6bc <putc>
 7e6:	a019                	j	7ec <vprintf+0x60>
    } else if(state == '%'){
 7e8:	01498f63          	beq	s3,s4,806 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 7ec:	0905                	addi	s2,s2,1
 7ee:	fff94483          	lbu	s1,-1(s2)
 7f2:	14048b63          	beqz	s1,948 <vprintf+0x1bc>
    c = fmt[i] & 0xff;
 7f6:	0004879b          	sext.w	a5,s1
    if(state == 0){
 7fa:	fe0997e3          	bnez	s3,7e8 <vprintf+0x5c>
      if(c == '%'){
 7fe:	fd479ee3          	bne	a5,s4,7da <vprintf+0x4e>
        state = '%';
 802:	89be                	mv	s3,a5
 804:	b7e5                	j	7ec <vprintf+0x60>
      if(c == 'd'){
 806:	05878063          	beq	a5,s8,846 <vprintf+0xba>
      } else if(c == 'l') {
 80a:	05978c63          	beq	a5,s9,862 <vprintf+0xd6>
      } else if(c == 'x') {
 80e:	07a78863          	beq	a5,s10,87e <vprintf+0xf2>
      } else if(c == 'p') {
 812:	09b78463          	beq	a5,s11,89a <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 816:	07300713          	li	a4,115
 81a:	0ce78563          	beq	a5,a4,8e4 <vprintf+0x158>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 81e:	06300713          	li	a4,99
 822:	0ee78c63          	beq	a5,a4,91a <vprintf+0x18e>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 826:	11478663          	beq	a5,s4,932 <vprintf+0x1a6>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 82a:	85d2                	mv	a1,s4
 82c:	8556                	mv	a0,s5
 82e:	00000097          	auipc	ra,0x0
 832:	e8e080e7          	jalr	-370(ra) # 6bc <putc>
        putc(fd, c);
 836:	85a6                	mv	a1,s1
 838:	8556                	mv	a0,s5
 83a:	00000097          	auipc	ra,0x0
 83e:	e82080e7          	jalr	-382(ra) # 6bc <putc>
      }
      state = 0;
 842:	4981                	li	s3,0
 844:	b765                	j	7ec <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 846:	008b0493          	addi	s1,s6,8
 84a:	4685                	li	a3,1
 84c:	4629                	li	a2,10
 84e:	000b2583          	lw	a1,0(s6)
 852:	8556                	mv	a0,s5
 854:	00000097          	auipc	ra,0x0
 858:	e8a080e7          	jalr	-374(ra) # 6de <printint>
 85c:	8b26                	mv	s6,s1
      state = 0;
 85e:	4981                	li	s3,0
 860:	b771                	j	7ec <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 862:	008b0493          	addi	s1,s6,8
 866:	4681                	li	a3,0
 868:	4629                	li	a2,10
 86a:	000b2583          	lw	a1,0(s6)
 86e:	8556                	mv	a0,s5
 870:	00000097          	auipc	ra,0x0
 874:	e6e080e7          	jalr	-402(ra) # 6de <printint>
 878:	8b26                	mv	s6,s1
      state = 0;
 87a:	4981                	li	s3,0
 87c:	bf85                	j	7ec <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 87e:	008b0493          	addi	s1,s6,8
 882:	4681                	li	a3,0
 884:	4641                	li	a2,16
 886:	000b2583          	lw	a1,0(s6)
 88a:	8556                	mv	a0,s5
 88c:	00000097          	auipc	ra,0x0
 890:	e52080e7          	jalr	-430(ra) # 6de <printint>
 894:	8b26                	mv	s6,s1
      state = 0;
 896:	4981                	li	s3,0
 898:	bf91                	j	7ec <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 89a:	008b0793          	addi	a5,s6,8
 89e:	f8f43423          	sd	a5,-120(s0)
 8a2:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 8a6:	03000593          	li	a1,48
 8aa:	8556                	mv	a0,s5
 8ac:	00000097          	auipc	ra,0x0
 8b0:	e10080e7          	jalr	-496(ra) # 6bc <putc>
  putc(fd, 'x');
 8b4:	85ea                	mv	a1,s10
 8b6:	8556                	mv	a0,s5
 8b8:	00000097          	auipc	ra,0x0
 8bc:	e04080e7          	jalr	-508(ra) # 6bc <putc>
 8c0:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8c2:	03c9d793          	srli	a5,s3,0x3c
 8c6:	97de                	add	a5,a5,s7
 8c8:	0007c583          	lbu	a1,0(a5)
 8cc:	8556                	mv	a0,s5
 8ce:	00000097          	auipc	ra,0x0
 8d2:	dee080e7          	jalr	-530(ra) # 6bc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8d6:	0992                	slli	s3,s3,0x4
 8d8:	34fd                	addiw	s1,s1,-1
 8da:	f4e5                	bnez	s1,8c2 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 8dc:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 8e0:	4981                	li	s3,0
 8e2:	b729                	j	7ec <vprintf+0x60>
        s = va_arg(ap, char*);
 8e4:	008b0993          	addi	s3,s6,8
 8e8:	000b3483          	ld	s1,0(s6)
        if(s == 0)
 8ec:	c085                	beqz	s1,90c <vprintf+0x180>
        while(*s != 0){
 8ee:	0004c583          	lbu	a1,0(s1)
 8f2:	c9a1                	beqz	a1,942 <vprintf+0x1b6>
          putc(fd, *s);
 8f4:	8556                	mv	a0,s5
 8f6:	00000097          	auipc	ra,0x0
 8fa:	dc6080e7          	jalr	-570(ra) # 6bc <putc>
          s++;
 8fe:	0485                	addi	s1,s1,1
        while(*s != 0){
 900:	0004c583          	lbu	a1,0(s1)
 904:	f9e5                	bnez	a1,8f4 <vprintf+0x168>
        s = va_arg(ap, char*);
 906:	8b4e                	mv	s6,s3
      state = 0;
 908:	4981                	li	s3,0
 90a:	b5cd                	j	7ec <vprintf+0x60>
          s = "(null)";
 90c:	00000497          	auipc	s1,0x0
 910:	2cc48493          	addi	s1,s1,716 # bd8 <digits+0x18>
        while(*s != 0){
 914:	02800593          	li	a1,40
 918:	bff1                	j	8f4 <vprintf+0x168>
        putc(fd, va_arg(ap, uint));
 91a:	008b0493          	addi	s1,s6,8
 91e:	000b4583          	lbu	a1,0(s6)
 922:	8556                	mv	a0,s5
 924:	00000097          	auipc	ra,0x0
 928:	d98080e7          	jalr	-616(ra) # 6bc <putc>
 92c:	8b26                	mv	s6,s1
      state = 0;
 92e:	4981                	li	s3,0
 930:	bd75                	j	7ec <vprintf+0x60>
        putc(fd, c);
 932:	85d2                	mv	a1,s4
 934:	8556                	mv	a0,s5
 936:	00000097          	auipc	ra,0x0
 93a:	d86080e7          	jalr	-634(ra) # 6bc <putc>
      state = 0;
 93e:	4981                	li	s3,0
 940:	b575                	j	7ec <vprintf+0x60>
        s = va_arg(ap, char*);
 942:	8b4e                	mv	s6,s3
      state = 0;
 944:	4981                	li	s3,0
 946:	b55d                	j	7ec <vprintf+0x60>
    }
  }
}
 948:	70e6                	ld	ra,120(sp)
 94a:	7446                	ld	s0,112(sp)
 94c:	74a6                	ld	s1,104(sp)
 94e:	7906                	ld	s2,96(sp)
 950:	69e6                	ld	s3,88(sp)
 952:	6a46                	ld	s4,80(sp)
 954:	6aa6                	ld	s5,72(sp)
 956:	6b06                	ld	s6,64(sp)
 958:	7be2                	ld	s7,56(sp)
 95a:	7c42                	ld	s8,48(sp)
 95c:	7ca2                	ld	s9,40(sp)
 95e:	7d02                	ld	s10,32(sp)
 960:	6de2                	ld	s11,24(sp)
 962:	6109                	addi	sp,sp,128
 964:	8082                	ret

0000000000000966 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 966:	715d                	addi	sp,sp,-80
 968:	ec06                	sd	ra,24(sp)
 96a:	e822                	sd	s0,16(sp)
 96c:	1000                	addi	s0,sp,32
 96e:	e010                	sd	a2,0(s0)
 970:	e414                	sd	a3,8(s0)
 972:	e818                	sd	a4,16(s0)
 974:	ec1c                	sd	a5,24(s0)
 976:	03043023          	sd	a6,32(s0)
 97a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 97e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 982:	8622                	mv	a2,s0
 984:	00000097          	auipc	ra,0x0
 988:	e08080e7          	jalr	-504(ra) # 78c <vprintf>
}
 98c:	60e2                	ld	ra,24(sp)
 98e:	6442                	ld	s0,16(sp)
 990:	6161                	addi	sp,sp,80
 992:	8082                	ret

0000000000000994 <printf>:

void
printf(const char *fmt, ...)
{
 994:	711d                	addi	sp,sp,-96
 996:	ec06                	sd	ra,24(sp)
 998:	e822                	sd	s0,16(sp)
 99a:	1000                	addi	s0,sp,32
 99c:	e40c                	sd	a1,8(s0)
 99e:	e810                	sd	a2,16(s0)
 9a0:	ec14                	sd	a3,24(s0)
 9a2:	f018                	sd	a4,32(s0)
 9a4:	f41c                	sd	a5,40(s0)
 9a6:	03043823          	sd	a6,48(s0)
 9aa:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 9ae:	00840613          	addi	a2,s0,8
 9b2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 9b6:	85aa                	mv	a1,a0
 9b8:	4505                	li	a0,1
 9ba:	00000097          	auipc	ra,0x0
 9be:	dd2080e7          	jalr	-558(ra) # 78c <vprintf>
}
 9c2:	60e2                	ld	ra,24(sp)
 9c4:	6442                	ld	s0,16(sp)
 9c6:	6125                	addi	sp,sp,96
 9c8:	8082                	ret

00000000000009ca <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9ca:	1141                	addi	sp,sp,-16
 9cc:	e422                	sd	s0,8(sp)
 9ce:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9d0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9d4:	00000797          	auipc	a5,0x0
 9d8:	63c78793          	addi	a5,a5,1596 # 1010 <freep>
 9dc:	639c                	ld	a5,0(a5)
 9de:	a805                	j	a0e <free+0x44>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 9e0:	4618                	lw	a4,8(a2)
 9e2:	9db9                	addw	a1,a1,a4
 9e4:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 9e8:	6398                	ld	a4,0(a5)
 9ea:	6318                	ld	a4,0(a4)
 9ec:	fee53823          	sd	a4,-16(a0)
 9f0:	a091                	j	a34 <free+0x6a>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 9f2:	ff852703          	lw	a4,-8(a0)
 9f6:	9e39                	addw	a2,a2,a4
 9f8:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 9fa:	ff053703          	ld	a4,-16(a0)
 9fe:	e398                	sd	a4,0(a5)
 a00:	a099                	j	a46 <free+0x7c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a02:	6398                	ld	a4,0(a5)
 a04:	00e7e463          	bltu	a5,a4,a0c <free+0x42>
 a08:	00e6ea63          	bltu	a3,a4,a1c <free+0x52>
{
 a0c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a0e:	fed7fae3          	bgeu	a5,a3,a02 <free+0x38>
 a12:	6398                	ld	a4,0(a5)
 a14:	00e6e463          	bltu	a3,a4,a1c <free+0x52>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a18:	fee7eae3          	bltu	a5,a4,a0c <free+0x42>
  if(bp + bp->s.size == p->s.ptr){
 a1c:	ff852583          	lw	a1,-8(a0)
 a20:	6390                	ld	a2,0(a5)
 a22:	02059713          	slli	a4,a1,0x20
 a26:	9301                	srli	a4,a4,0x20
 a28:	0712                	slli	a4,a4,0x4
 a2a:	9736                	add	a4,a4,a3
 a2c:	fae60ae3          	beq	a2,a4,9e0 <free+0x16>
    bp->s.ptr = p->s.ptr;
 a30:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a34:	4790                	lw	a2,8(a5)
 a36:	02061713          	slli	a4,a2,0x20
 a3a:	9301                	srli	a4,a4,0x20
 a3c:	0712                	slli	a4,a4,0x4
 a3e:	973e                	add	a4,a4,a5
 a40:	fae689e3          	beq	a3,a4,9f2 <free+0x28>
  } else
    p->s.ptr = bp;
 a44:	e394                	sd	a3,0(a5)
  freep = p;
 a46:	00000717          	auipc	a4,0x0
 a4a:	5cf73523          	sd	a5,1482(a4) # 1010 <freep>
}
 a4e:	6422                	ld	s0,8(sp)
 a50:	0141                	addi	sp,sp,16
 a52:	8082                	ret

0000000000000a54 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a54:	7139                	addi	sp,sp,-64
 a56:	fc06                	sd	ra,56(sp)
 a58:	f822                	sd	s0,48(sp)
 a5a:	f426                	sd	s1,40(sp)
 a5c:	f04a                	sd	s2,32(sp)
 a5e:	ec4e                	sd	s3,24(sp)
 a60:	e852                	sd	s4,16(sp)
 a62:	e456                	sd	s5,8(sp)
 a64:	e05a                	sd	s6,0(sp)
 a66:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a68:	02051993          	slli	s3,a0,0x20
 a6c:	0209d993          	srli	s3,s3,0x20
 a70:	09bd                	addi	s3,s3,15
 a72:	0049d993          	srli	s3,s3,0x4
 a76:	2985                	addiw	s3,s3,1
 a78:	0009891b          	sext.w	s2,s3
  if((prevp = freep) == 0){
 a7c:	00000797          	auipc	a5,0x0
 a80:	59478793          	addi	a5,a5,1428 # 1010 <freep>
 a84:	6388                	ld	a0,0(a5)
 a86:	c515                	beqz	a0,ab2 <malloc+0x5e>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a88:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a8a:	4798                	lw	a4,8(a5)
 a8c:	03277f63          	bgeu	a4,s2,aca <malloc+0x76>
 a90:	8a4e                	mv	s4,s3
 a92:	0009871b          	sext.w	a4,s3
 a96:	6685                	lui	a3,0x1
 a98:	00d77363          	bgeu	a4,a3,a9e <malloc+0x4a>
 a9c:	6a05                	lui	s4,0x1
 a9e:	000a0a9b          	sext.w	s5,s4
  p = sbrk(nu * sizeof(Header));
 aa2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 aa6:	00000497          	auipc	s1,0x0
 aaa:	56a48493          	addi	s1,s1,1386 # 1010 <freep>
  if(p == (char*)-1)
 aae:	5b7d                	li	s6,-1
 ab0:	a885                	j	b20 <malloc+0xcc>
    base.s.ptr = freep = prevp = &base;
 ab2:	00000797          	auipc	a5,0x0
 ab6:	57e78793          	addi	a5,a5,1406 # 1030 <base>
 aba:	00000717          	auipc	a4,0x0
 abe:	54f73b23          	sd	a5,1366(a4) # 1010 <freep>
 ac2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 ac4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 ac8:	b7e1                	j	a90 <malloc+0x3c>
      if(p->s.size == nunits)
 aca:	02e90b63          	beq	s2,a4,b00 <malloc+0xac>
        p->s.size -= nunits;
 ace:	4137073b          	subw	a4,a4,s3
 ad2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 ad4:	1702                	slli	a4,a4,0x20
 ad6:	9301                	srli	a4,a4,0x20
 ad8:	0712                	slli	a4,a4,0x4
 ada:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 adc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 ae0:	00000717          	auipc	a4,0x0
 ae4:	52a73823          	sd	a0,1328(a4) # 1010 <freep>
      return (void*)(p + 1);
 ae8:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 aec:	70e2                	ld	ra,56(sp)
 aee:	7442                	ld	s0,48(sp)
 af0:	74a2                	ld	s1,40(sp)
 af2:	7902                	ld	s2,32(sp)
 af4:	69e2                	ld	s3,24(sp)
 af6:	6a42                	ld	s4,16(sp)
 af8:	6aa2                	ld	s5,8(sp)
 afa:	6b02                	ld	s6,0(sp)
 afc:	6121                	addi	sp,sp,64
 afe:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 b00:	6398                	ld	a4,0(a5)
 b02:	e118                	sd	a4,0(a0)
 b04:	bff1                	j	ae0 <malloc+0x8c>
  hp->s.size = nu;
 b06:	01552423          	sw	s5,8(a0)
  free((void*)(hp + 1));
 b0a:	0541                	addi	a0,a0,16
 b0c:	00000097          	auipc	ra,0x0
 b10:	ebe080e7          	jalr	-322(ra) # 9ca <free>
  return freep;
 b14:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 b16:	d979                	beqz	a0,aec <malloc+0x98>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b18:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b1a:	4798                	lw	a4,8(a5)
 b1c:	fb2777e3          	bgeu	a4,s2,aca <malloc+0x76>
    if(p == freep)
 b20:	6098                	ld	a4,0(s1)
 b22:	853e                	mv	a0,a5
 b24:	fef71ae3          	bne	a4,a5,b18 <malloc+0xc4>
  p = sbrk(nu * sizeof(Header));
 b28:	8552                	mv	a0,s4
 b2a:	00000097          	auipc	ra,0x0
 b2e:	b7a080e7          	jalr	-1158(ra) # 6a4 <sbrk>
  if(p == (char*)-1)
 b32:	fd651ae3          	bne	a0,s6,b06 <malloc+0xb2>
        return 0;
 b36:	4501                	li	a0,0
 b38:	bf55                	j	aec <malloc+0x98>
