
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };

  for(int ai = 0; ai < 2; ai++){
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
       8:	20100593          	li	a1,513
       c:	4505                	li	a0,1
       e:	057e                	slli	a0,a0,0x1f
      10:	00006097          	auipc	ra,0x6
      14:	c42080e7          	jalr	-958(ra) # 5c52 <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00006097          	auipc	ra,0x6
      26:	c30080e7          	jalr	-976(ra) # 5c52 <open>
    uint64 addr = addrs[ai];
      2a:	55fd                	li	a1,-1
    if(fd >= 0){
      2c:	00055863          	bgez	a0,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", addr, fd);
      exit(1);
    }
  }
}
      30:	60a2                	ld	ra,8(sp)
      32:	6402                	ld	s0,0(sp)
      34:	0141                	addi	sp,sp,16
      36:	8082                	ret
    uint64 addr = addrs[ai];
      38:	4585                	li	a1,1
      3a:	05fe                	slli	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      3c:	862a                	mv	a2,a0
      3e:	00006517          	auipc	a0,0x6
      42:	11250513          	addi	a0,a0,274 # 6150 <malloc+0x106>
      46:	00006097          	auipc	ra,0x6
      4a:	f44080e7          	jalr	-188(ra) # 5f8a <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00006097          	auipc	ra,0x6
      54:	bc2080e7          	jalr	-1086(ra) # 5c12 <exit>

0000000000000058 <bsstest>:
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
    if(uninit[i] != '\0'){
      58:	0000a797          	auipc	a5,0xa
      5c:	5107c783          	lbu	a5,1296(a5) # a568 <uninit>
      60:	e385                	bnez	a5,80 <bsstest+0x28>
      62:	0000a797          	auipc	a5,0xa
      66:	50778793          	addi	a5,a5,1287 # a569 <uninit+0x1>
      6a:	0000d697          	auipc	a3,0xd
      6e:	c0e68693          	addi	a3,a3,-1010 # cc78 <buf>
      72:	0007c703          	lbu	a4,0(a5)
      76:	e709                	bnez	a4,80 <bsstest+0x28>
  for(i = 0; i < sizeof(uninit); i++){
      78:	0785                	addi	a5,a5,1
      7a:	fed79ce3          	bne	a5,a3,72 <bsstest+0x1a>
      7e:	8082                	ret
{
      80:	1141                	addi	sp,sp,-16
      82:	e406                	sd	ra,8(sp)
      84:	e022                	sd	s0,0(sp)
      86:	0800                	addi	s0,sp,16
      88:	85aa                	mv	a1,a0
      printf("%s: bss test failed\n", s);
      8a:	00006517          	auipc	a0,0x6
      8e:	0e650513          	addi	a0,a0,230 # 6170 <malloc+0x126>
      92:	00006097          	auipc	ra,0x6
      96:	ef8080e7          	jalr	-264(ra) # 5f8a <printf>
      exit(1);
      9a:	4505                	li	a0,1
      9c:	00006097          	auipc	ra,0x6
      a0:	b76080e7          	jalr	-1162(ra) # 5c12 <exit>

00000000000000a4 <opentest>:
{
      a4:	1101                	addi	sp,sp,-32
      a6:	ec06                	sd	ra,24(sp)
      a8:	e822                	sd	s0,16(sp)
      aa:	e426                	sd	s1,8(sp)
      ac:	1000                	addi	s0,sp,32
      ae:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      b0:	4581                	li	a1,0
      b2:	00006517          	auipc	a0,0x6
      b6:	0d650513          	addi	a0,a0,214 # 6188 <malloc+0x13e>
      ba:	00006097          	auipc	ra,0x6
      be:	b98080e7          	jalr	-1128(ra) # 5c52 <open>
  if(fd < 0){
      c2:	02054663          	bltz	a0,ee <opentest+0x4a>
  close(fd);
      c6:	00006097          	auipc	ra,0x6
      ca:	b74080e7          	jalr	-1164(ra) # 5c3a <close>
  fd = open("doesnotexist", 0);
      ce:	4581                	li	a1,0
      d0:	00006517          	auipc	a0,0x6
      d4:	0d850513          	addi	a0,a0,216 # 61a8 <malloc+0x15e>
      d8:	00006097          	auipc	ra,0x6
      dc:	b7a080e7          	jalr	-1158(ra) # 5c52 <open>
  if(fd >= 0){
      e0:	02055563          	bgez	a0,10a <opentest+0x66>
}
      e4:	60e2                	ld	ra,24(sp)
      e6:	6442                	ld	s0,16(sp)
      e8:	64a2                	ld	s1,8(sp)
      ea:	6105                	addi	sp,sp,32
      ec:	8082                	ret
    printf("%s: open echo failed!\n", s);
      ee:	85a6                	mv	a1,s1
      f0:	00006517          	auipc	a0,0x6
      f4:	0a050513          	addi	a0,a0,160 # 6190 <malloc+0x146>
      f8:	00006097          	auipc	ra,0x6
      fc:	e92080e7          	jalr	-366(ra) # 5f8a <printf>
    exit(1);
     100:	4505                	li	a0,1
     102:	00006097          	auipc	ra,0x6
     106:	b10080e7          	jalr	-1264(ra) # 5c12 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     10a:	85a6                	mv	a1,s1
     10c:	00006517          	auipc	a0,0x6
     110:	0ac50513          	addi	a0,a0,172 # 61b8 <malloc+0x16e>
     114:	00006097          	auipc	ra,0x6
     118:	e76080e7          	jalr	-394(ra) # 5f8a <printf>
    exit(1);
     11c:	4505                	li	a0,1
     11e:	00006097          	auipc	ra,0x6
     122:	af4080e7          	jalr	-1292(ra) # 5c12 <exit>

0000000000000126 <truncate2>:
{
     126:	7179                	addi	sp,sp,-48
     128:	f406                	sd	ra,40(sp)
     12a:	f022                	sd	s0,32(sp)
     12c:	ec26                	sd	s1,24(sp)
     12e:	e84a                	sd	s2,16(sp)
     130:	e44e                	sd	s3,8(sp)
     132:	1800                	addi	s0,sp,48
     134:	89aa                	mv	s3,a0
  unlink("truncfile");
     136:	00006517          	auipc	a0,0x6
     13a:	0aa50513          	addi	a0,a0,170 # 61e0 <malloc+0x196>
     13e:	00006097          	auipc	ra,0x6
     142:	b24080e7          	jalr	-1244(ra) # 5c62 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     146:	60100593          	li	a1,1537
     14a:	00006517          	auipc	a0,0x6
     14e:	09650513          	addi	a0,a0,150 # 61e0 <malloc+0x196>
     152:	00006097          	auipc	ra,0x6
     156:	b00080e7          	jalr	-1280(ra) # 5c52 <open>
     15a:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     15c:	4611                	li	a2,4
     15e:	00006597          	auipc	a1,0x6
     162:	09258593          	addi	a1,a1,146 # 61f0 <malloc+0x1a6>
     166:	00006097          	auipc	ra,0x6
     16a:	acc080e7          	jalr	-1332(ra) # 5c32 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     16e:	40100593          	li	a1,1025
     172:	00006517          	auipc	a0,0x6
     176:	06e50513          	addi	a0,a0,110 # 61e0 <malloc+0x196>
     17a:	00006097          	auipc	ra,0x6
     17e:	ad8080e7          	jalr	-1320(ra) # 5c52 <open>
     182:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     184:	4605                	li	a2,1
     186:	00006597          	auipc	a1,0x6
     18a:	07258593          	addi	a1,a1,114 # 61f8 <malloc+0x1ae>
     18e:	8526                	mv	a0,s1
     190:	00006097          	auipc	ra,0x6
     194:	aa2080e7          	jalr	-1374(ra) # 5c32 <write>
  if(n != -1){
     198:	57fd                	li	a5,-1
     19a:	02f51b63          	bne	a0,a5,1d0 <truncate2+0xaa>
  unlink("truncfile");
     19e:	00006517          	auipc	a0,0x6
     1a2:	04250513          	addi	a0,a0,66 # 61e0 <malloc+0x196>
     1a6:	00006097          	auipc	ra,0x6
     1aa:	abc080e7          	jalr	-1348(ra) # 5c62 <unlink>
  close(fd1);
     1ae:	8526                	mv	a0,s1
     1b0:	00006097          	auipc	ra,0x6
     1b4:	a8a080e7          	jalr	-1398(ra) # 5c3a <close>
  close(fd2);
     1b8:	854a                	mv	a0,s2
     1ba:	00006097          	auipc	ra,0x6
     1be:	a80080e7          	jalr	-1408(ra) # 5c3a <close>
}
     1c2:	70a2                	ld	ra,40(sp)
     1c4:	7402                	ld	s0,32(sp)
     1c6:	64e2                	ld	s1,24(sp)
     1c8:	6942                	ld	s2,16(sp)
     1ca:	69a2                	ld	s3,8(sp)
     1cc:	6145                	addi	sp,sp,48
     1ce:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1d0:	862a                	mv	a2,a0
     1d2:	85ce                	mv	a1,s3
     1d4:	00006517          	auipc	a0,0x6
     1d8:	02c50513          	addi	a0,a0,44 # 6200 <malloc+0x1b6>
     1dc:	00006097          	auipc	ra,0x6
     1e0:	dae080e7          	jalr	-594(ra) # 5f8a <printf>
    exit(1);
     1e4:	4505                	li	a0,1
     1e6:	00006097          	auipc	ra,0x6
     1ea:	a2c080e7          	jalr	-1492(ra) # 5c12 <exit>

00000000000001ee <createtest>:
{
     1ee:	7179                	addi	sp,sp,-48
     1f0:	f406                	sd	ra,40(sp)
     1f2:	f022                	sd	s0,32(sp)
     1f4:	ec26                	sd	s1,24(sp)
     1f6:	e84a                	sd	s2,16(sp)
     1f8:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1fa:	06100793          	li	a5,97
     1fe:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     202:	fc040d23          	sb	zero,-38(s0)
     206:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     20a:	06400913          	li	s2,100
    name[1] = '0' + i;
     20e:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     212:	20200593          	li	a1,514
     216:	fd840513          	addi	a0,s0,-40
     21a:	00006097          	auipc	ra,0x6
     21e:	a38080e7          	jalr	-1480(ra) # 5c52 <open>
    close(fd);
     222:	00006097          	auipc	ra,0x6
     226:	a18080e7          	jalr	-1512(ra) # 5c3a <close>
  for(i = 0; i < N; i++){
     22a:	2485                	addiw	s1,s1,1
     22c:	0ff4f493          	andi	s1,s1,255
     230:	fd249fe3          	bne	s1,s2,20e <createtest+0x20>
  name[0] = 'a';
     234:	06100793          	li	a5,97
     238:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     23c:	fc040d23          	sb	zero,-38(s0)
     240:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     244:	06400913          	li	s2,100
    name[1] = '0' + i;
     248:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     24c:	fd840513          	addi	a0,s0,-40
     250:	00006097          	auipc	ra,0x6
     254:	a12080e7          	jalr	-1518(ra) # 5c62 <unlink>
  for(i = 0; i < N; i++){
     258:	2485                	addiw	s1,s1,1
     25a:	0ff4f493          	andi	s1,s1,255
     25e:	ff2495e3          	bne	s1,s2,248 <createtest+0x5a>
}
     262:	70a2                	ld	ra,40(sp)
     264:	7402                	ld	s0,32(sp)
     266:	64e2                	ld	s1,24(sp)
     268:	6942                	ld	s2,16(sp)
     26a:	6145                	addi	sp,sp,48
     26c:	8082                	ret

000000000000026e <bigwrite>:
{
     26e:	715d                	addi	sp,sp,-80
     270:	e486                	sd	ra,72(sp)
     272:	e0a2                	sd	s0,64(sp)
     274:	fc26                	sd	s1,56(sp)
     276:	f84a                	sd	s2,48(sp)
     278:	f44e                	sd	s3,40(sp)
     27a:	f052                	sd	s4,32(sp)
     27c:	ec56                	sd	s5,24(sp)
     27e:	e85a                	sd	s6,16(sp)
     280:	e45e                	sd	s7,8(sp)
     282:	0880                	addi	s0,sp,80
     284:	8baa                	mv	s7,a0
  unlink("bigwrite");
     286:	00006517          	auipc	a0,0x6
     28a:	fa250513          	addi	a0,a0,-94 # 6228 <malloc+0x1de>
     28e:	00006097          	auipc	ra,0x6
     292:	9d4080e7          	jalr	-1580(ra) # 5c62 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     296:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     29a:	00006a17          	auipc	s4,0x6
     29e:	f8ea0a13          	addi	s4,s4,-114 # 6228 <malloc+0x1de>
      int cc = write(fd, buf, sz);
     2a2:	0000d997          	auipc	s3,0xd
     2a6:	9d698993          	addi	s3,s3,-1578 # cc78 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2aa:	6b0d                	lui	s6,0x3
     2ac:	1c9b0b13          	addi	s6,s6,457 # 31c9 <fourteen+0x177>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2b0:	20200593          	li	a1,514
     2b4:	8552                	mv	a0,s4
     2b6:	00006097          	auipc	ra,0x6
     2ba:	99c080e7          	jalr	-1636(ra) # 5c52 <open>
     2be:	892a                	mv	s2,a0
    if(fd < 0){
     2c0:	04054d63          	bltz	a0,31a <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2c4:	8626                	mv	a2,s1
     2c6:	85ce                	mv	a1,s3
     2c8:	00006097          	auipc	ra,0x6
     2cc:	96a080e7          	jalr	-1686(ra) # 5c32 <write>
     2d0:	8aaa                	mv	s5,a0
      if(cc != sz){
     2d2:	06a49463          	bne	s1,a0,33a <bigwrite+0xcc>
      int cc = write(fd, buf, sz);
     2d6:	8626                	mv	a2,s1
     2d8:	85ce                	mv	a1,s3
     2da:	854a                	mv	a0,s2
     2dc:	00006097          	auipc	ra,0x6
     2e0:	956080e7          	jalr	-1706(ra) # 5c32 <write>
      if(cc != sz){
     2e4:	04951963          	bne	a0,s1,336 <bigwrite+0xc8>
    close(fd);
     2e8:	854a                	mv	a0,s2
     2ea:	00006097          	auipc	ra,0x6
     2ee:	950080e7          	jalr	-1712(ra) # 5c3a <close>
    unlink("bigwrite");
     2f2:	8552                	mv	a0,s4
     2f4:	00006097          	auipc	ra,0x6
     2f8:	96e080e7          	jalr	-1682(ra) # 5c62 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2fc:	1d74849b          	addiw	s1,s1,471
     300:	fb6498e3          	bne	s1,s6,2b0 <bigwrite+0x42>
}
     304:	60a6                	ld	ra,72(sp)
     306:	6406                	ld	s0,64(sp)
     308:	74e2                	ld	s1,56(sp)
     30a:	7942                	ld	s2,48(sp)
     30c:	79a2                	ld	s3,40(sp)
     30e:	7a02                	ld	s4,32(sp)
     310:	6ae2                	ld	s5,24(sp)
     312:	6b42                	ld	s6,16(sp)
     314:	6ba2                	ld	s7,8(sp)
     316:	6161                	addi	sp,sp,80
     318:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     31a:	85de                	mv	a1,s7
     31c:	00006517          	auipc	a0,0x6
     320:	f1c50513          	addi	a0,a0,-228 # 6238 <malloc+0x1ee>
     324:	00006097          	auipc	ra,0x6
     328:	c66080e7          	jalr	-922(ra) # 5f8a <printf>
      exit(1);
     32c:	4505                	li	a0,1
     32e:	00006097          	auipc	ra,0x6
     332:	8e4080e7          	jalr	-1820(ra) # 5c12 <exit>
     336:	84d6                	mv	s1,s5
      int cc = write(fd, buf, sz);
     338:	8aaa                	mv	s5,a0
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     33a:	86d6                	mv	a3,s5
     33c:	8626                	mv	a2,s1
     33e:	85de                	mv	a1,s7
     340:	00006517          	auipc	a0,0x6
     344:	f1850513          	addi	a0,a0,-232 # 6258 <malloc+0x20e>
     348:	00006097          	auipc	ra,0x6
     34c:	c42080e7          	jalr	-958(ra) # 5f8a <printf>
        exit(1);
     350:	4505                	li	a0,1
     352:	00006097          	auipc	ra,0x6
     356:	8c0080e7          	jalr	-1856(ra) # 5c12 <exit>

000000000000035a <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     35a:	7179                	addi	sp,sp,-48
     35c:	f406                	sd	ra,40(sp)
     35e:	f022                	sd	s0,32(sp)
     360:	ec26                	sd	s1,24(sp)
     362:	e84a                	sd	s2,16(sp)
     364:	e44e                	sd	s3,8(sp)
     366:	e052                	sd	s4,0(sp)
     368:	1800                	addi	s0,sp,48
  int assumed_free = 600;
  
  unlink("junk");
     36a:	00006517          	auipc	a0,0x6
     36e:	f0650513          	addi	a0,a0,-250 # 6270 <malloc+0x226>
     372:	00006097          	auipc	ra,0x6
     376:	8f0080e7          	jalr	-1808(ra) # 5c62 <unlink>
     37a:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     37e:	00006997          	auipc	s3,0x6
     382:	ef298993          	addi	s3,s3,-270 # 6270 <malloc+0x226>
    if(fd < 0){
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char*)0xffffffffffL, 1);
     386:	5a7d                	li	s4,-1
     388:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
     38c:	20100593          	li	a1,513
     390:	854e                	mv	a0,s3
     392:	00006097          	auipc	ra,0x6
     396:	8c0080e7          	jalr	-1856(ra) # 5c52 <open>
     39a:	84aa                	mv	s1,a0
    if(fd < 0){
     39c:	06054b63          	bltz	a0,412 <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
     3a0:	4605                	li	a2,1
     3a2:	85d2                	mv	a1,s4
     3a4:	00006097          	auipc	ra,0x6
     3a8:	88e080e7          	jalr	-1906(ra) # 5c32 <write>
    close(fd);
     3ac:	8526                	mv	a0,s1
     3ae:	00006097          	auipc	ra,0x6
     3b2:	88c080e7          	jalr	-1908(ra) # 5c3a <close>
    unlink("junk");
     3b6:	854e                	mv	a0,s3
     3b8:	00006097          	auipc	ra,0x6
     3bc:	8aa080e7          	jalr	-1878(ra) # 5c62 <unlink>
  for(int i = 0; i < assumed_free; i++){
     3c0:	397d                	addiw	s2,s2,-1
     3c2:	fc0915e3          	bnez	s2,38c <badwrite+0x32>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     3c6:	20100593          	li	a1,513
     3ca:	00006517          	auipc	a0,0x6
     3ce:	ea650513          	addi	a0,a0,-346 # 6270 <malloc+0x226>
     3d2:	00006097          	auipc	ra,0x6
     3d6:	880080e7          	jalr	-1920(ra) # 5c52 <open>
     3da:	84aa                	mv	s1,a0
  if(fd < 0){
     3dc:	04054863          	bltz	a0,42c <badwrite+0xd2>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
     3e0:	4605                	li	a2,1
     3e2:	00006597          	auipc	a1,0x6
     3e6:	e1658593          	addi	a1,a1,-490 # 61f8 <malloc+0x1ae>
     3ea:	00006097          	auipc	ra,0x6
     3ee:	848080e7          	jalr	-1976(ra) # 5c32 <write>
     3f2:	4785                	li	a5,1
     3f4:	04f50963          	beq	a0,a5,446 <badwrite+0xec>
    printf("write failed\n");
     3f8:	00006517          	auipc	a0,0x6
     3fc:	e9850513          	addi	a0,a0,-360 # 6290 <malloc+0x246>
     400:	00006097          	auipc	ra,0x6
     404:	b8a080e7          	jalr	-1142(ra) # 5f8a <printf>
    exit(1);
     408:	4505                	li	a0,1
     40a:	00006097          	auipc	ra,0x6
     40e:	808080e7          	jalr	-2040(ra) # 5c12 <exit>
      printf("open junk failed\n");
     412:	00006517          	auipc	a0,0x6
     416:	e6650513          	addi	a0,a0,-410 # 6278 <malloc+0x22e>
     41a:	00006097          	auipc	ra,0x6
     41e:	b70080e7          	jalr	-1168(ra) # 5f8a <printf>
      exit(1);
     422:	4505                	li	a0,1
     424:	00005097          	auipc	ra,0x5
     428:	7ee080e7          	jalr	2030(ra) # 5c12 <exit>
    printf("open junk failed\n");
     42c:	00006517          	auipc	a0,0x6
     430:	e4c50513          	addi	a0,a0,-436 # 6278 <malloc+0x22e>
     434:	00006097          	auipc	ra,0x6
     438:	b56080e7          	jalr	-1194(ra) # 5f8a <printf>
    exit(1);
     43c:	4505                	li	a0,1
     43e:	00005097          	auipc	ra,0x5
     442:	7d4080e7          	jalr	2004(ra) # 5c12 <exit>
  }
  close(fd);
     446:	8526                	mv	a0,s1
     448:	00005097          	auipc	ra,0x5
     44c:	7f2080e7          	jalr	2034(ra) # 5c3a <close>
  unlink("junk");
     450:	00006517          	auipc	a0,0x6
     454:	e2050513          	addi	a0,a0,-480 # 6270 <malloc+0x226>
     458:	00006097          	auipc	ra,0x6
     45c:	80a080e7          	jalr	-2038(ra) # 5c62 <unlink>

  exit(0);
     460:	4501                	li	a0,0
     462:	00005097          	auipc	ra,0x5
     466:	7b0080e7          	jalr	1968(ra) # 5c12 <exit>

000000000000046a <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     46a:	715d                	addi	sp,sp,-80
     46c:	e486                	sd	ra,72(sp)
     46e:	e0a2                	sd	s0,64(sp)
     470:	fc26                	sd	s1,56(sp)
     472:	f84a                	sd	s2,48(sp)
     474:	f44e                	sd	s3,40(sp)
     476:	0880                	addi	s0,sp,80
  int nzz = 32*32;
  for(int i = 0; i < nzz; i++){
     478:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     47a:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     47e:	40000993          	li	s3,1024
    name[0] = 'z';
     482:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     486:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     48a:	41f4d79b          	sraiw	a5,s1,0x1f
     48e:	01b7d71b          	srliw	a4,a5,0x1b
     492:	009707bb          	addw	a5,a4,s1
     496:	4057d69b          	sraiw	a3,a5,0x5
     49a:	0306869b          	addiw	a3,a3,48
     49e:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     4a2:	8bfd                	andi	a5,a5,31
     4a4:	9f99                	subw	a5,a5,a4
     4a6:	0307879b          	addiw	a5,a5,48
     4aa:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     4ae:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     4b2:	fb040513          	addi	a0,s0,-80
     4b6:	00005097          	auipc	ra,0x5
     4ba:	7ac080e7          	jalr	1964(ra) # 5c62 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     4be:	60200593          	li	a1,1538
     4c2:	fb040513          	addi	a0,s0,-80
     4c6:	00005097          	auipc	ra,0x5
     4ca:	78c080e7          	jalr	1932(ra) # 5c52 <open>
    if(fd < 0){
     4ce:	00054963          	bltz	a0,4e0 <outofinodes+0x76>
      // failure is eventually expected.
      break;
    }
    close(fd);
     4d2:	00005097          	auipc	ra,0x5
     4d6:	768080e7          	jalr	1896(ra) # 5c3a <close>
  for(int i = 0; i < nzz; i++){
     4da:	2485                	addiw	s1,s1,1
     4dc:	fb3493e3          	bne	s1,s3,482 <outofinodes+0x18>
     4e0:	4481                	li	s1,0
  }

  for(int i = 0; i < nzz; i++){
    char name[32];
    name[0] = 'z';
     4e2:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     4e6:	40000993          	li	s3,1024
    name[0] = 'z';
     4ea:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     4ee:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     4f2:	41f4d79b          	sraiw	a5,s1,0x1f
     4f6:	01b7d71b          	srliw	a4,a5,0x1b
     4fa:	009707bb          	addw	a5,a4,s1
     4fe:	4057d69b          	sraiw	a3,a5,0x5
     502:	0306869b          	addiw	a3,a3,48
     506:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     50a:	8bfd                	andi	a5,a5,31
     50c:	9f99                	subw	a5,a5,a4
     50e:	0307879b          	addiw	a5,a5,48
     512:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     516:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     51a:	fb040513          	addi	a0,s0,-80
     51e:	00005097          	auipc	ra,0x5
     522:	744080e7          	jalr	1860(ra) # 5c62 <unlink>
  for(int i = 0; i < nzz; i++){
     526:	2485                	addiw	s1,s1,1
     528:	fd3491e3          	bne	s1,s3,4ea <outofinodes+0x80>
  }
}
     52c:	60a6                	ld	ra,72(sp)
     52e:	6406                	ld	s0,64(sp)
     530:	74e2                	ld	s1,56(sp)
     532:	7942                	ld	s2,48(sp)
     534:	79a2                	ld	s3,40(sp)
     536:	6161                	addi	sp,sp,80
     538:	8082                	ret

000000000000053a <copyin>:
{
     53a:	711d                	addi	sp,sp,-96
     53c:	ec86                	sd	ra,88(sp)
     53e:	e8a2                	sd	s0,80(sp)
     540:	e4a6                	sd	s1,72(sp)
     542:	e0ca                	sd	s2,64(sp)
     544:	fc4e                	sd	s3,56(sp)
     546:	f852                	sd	s4,48(sp)
     548:	f456                	sd	s5,40(sp)
     54a:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     54c:	4785                	li	a5,1
     54e:	07fe                	slli	a5,a5,0x1f
     550:	faf43823          	sd	a5,-80(s0)
     554:	57fd                	li	a5,-1
     556:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     55a:	fb040493          	addi	s1,s0,-80
     55e:	fc040a93          	addi	s5,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     562:	00006a17          	auipc	s4,0x6
     566:	d3ea0a13          	addi	s4,s4,-706 # 62a0 <malloc+0x256>
    uint64 addr = addrs[ai];
     56a:	0004b903          	ld	s2,0(s1)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     56e:	20100593          	li	a1,513
     572:	8552                	mv	a0,s4
     574:	00005097          	auipc	ra,0x5
     578:	6de080e7          	jalr	1758(ra) # 5c52 <open>
     57c:	89aa                	mv	s3,a0
    if(fd < 0){
     57e:	08054763          	bltz	a0,60c <copyin+0xd2>
    int n = write(fd, (void*)addr, 8192);
     582:	6609                	lui	a2,0x2
     584:	85ca                	mv	a1,s2
     586:	00005097          	auipc	ra,0x5
     58a:	6ac080e7          	jalr	1708(ra) # 5c32 <write>
    if(n >= 0){
     58e:	08055c63          	bgez	a0,626 <copyin+0xec>
    close(fd);
     592:	854e                	mv	a0,s3
     594:	00005097          	auipc	ra,0x5
     598:	6a6080e7          	jalr	1702(ra) # 5c3a <close>
    unlink("copyin1");
     59c:	8552                	mv	a0,s4
     59e:	00005097          	auipc	ra,0x5
     5a2:	6c4080e7          	jalr	1732(ra) # 5c62 <unlink>
    n = write(1, (char*)addr, 8192);
     5a6:	6609                	lui	a2,0x2
     5a8:	85ca                	mv	a1,s2
     5aa:	4505                	li	a0,1
     5ac:	00005097          	auipc	ra,0x5
     5b0:	686080e7          	jalr	1670(ra) # 5c32 <write>
    if(n > 0){
     5b4:	08a04863          	bgtz	a0,644 <copyin+0x10a>
    if(pipe(fds) < 0){
     5b8:	fa840513          	addi	a0,s0,-88
     5bc:	00005097          	auipc	ra,0x5
     5c0:	666080e7          	jalr	1638(ra) # 5c22 <pipe>
     5c4:	08054f63          	bltz	a0,662 <copyin+0x128>
    n = write(fds[1], (char*)addr, 8192);
     5c8:	6609                	lui	a2,0x2
     5ca:	85ca                	mv	a1,s2
     5cc:	fac42503          	lw	a0,-84(s0)
     5d0:	00005097          	auipc	ra,0x5
     5d4:	662080e7          	jalr	1634(ra) # 5c32 <write>
    if(n > 0){
     5d8:	0aa04263          	bgtz	a0,67c <copyin+0x142>
    close(fds[0]);
     5dc:	fa842503          	lw	a0,-88(s0)
     5e0:	00005097          	auipc	ra,0x5
     5e4:	65a080e7          	jalr	1626(ra) # 5c3a <close>
    close(fds[1]);
     5e8:	fac42503          	lw	a0,-84(s0)
     5ec:	00005097          	auipc	ra,0x5
     5f0:	64e080e7          	jalr	1614(ra) # 5c3a <close>
  for(int ai = 0; ai < 2; ai++){
     5f4:	04a1                	addi	s1,s1,8
     5f6:	f7549ae3          	bne	s1,s5,56a <copyin+0x30>
}
     5fa:	60e6                	ld	ra,88(sp)
     5fc:	6446                	ld	s0,80(sp)
     5fe:	64a6                	ld	s1,72(sp)
     600:	6906                	ld	s2,64(sp)
     602:	79e2                	ld	s3,56(sp)
     604:	7a42                	ld	s4,48(sp)
     606:	7aa2                	ld	s5,40(sp)
     608:	6125                	addi	sp,sp,96
     60a:	8082                	ret
      printf("open(copyin1) failed\n");
     60c:	00006517          	auipc	a0,0x6
     610:	c9c50513          	addi	a0,a0,-868 # 62a8 <malloc+0x25e>
     614:	00006097          	auipc	ra,0x6
     618:	976080e7          	jalr	-1674(ra) # 5f8a <printf>
      exit(1);
     61c:	4505                	li	a0,1
     61e:	00005097          	auipc	ra,0x5
     622:	5f4080e7          	jalr	1524(ra) # 5c12 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     626:	862a                	mv	a2,a0
     628:	85ca                	mv	a1,s2
     62a:	00006517          	auipc	a0,0x6
     62e:	c9650513          	addi	a0,a0,-874 # 62c0 <malloc+0x276>
     632:	00006097          	auipc	ra,0x6
     636:	958080e7          	jalr	-1704(ra) # 5f8a <printf>
      exit(1);
     63a:	4505                	li	a0,1
     63c:	00005097          	auipc	ra,0x5
     640:	5d6080e7          	jalr	1494(ra) # 5c12 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     644:	862a                	mv	a2,a0
     646:	85ca                	mv	a1,s2
     648:	00006517          	auipc	a0,0x6
     64c:	ca850513          	addi	a0,a0,-856 # 62f0 <malloc+0x2a6>
     650:	00006097          	auipc	ra,0x6
     654:	93a080e7          	jalr	-1734(ra) # 5f8a <printf>
      exit(1);
     658:	4505                	li	a0,1
     65a:	00005097          	auipc	ra,0x5
     65e:	5b8080e7          	jalr	1464(ra) # 5c12 <exit>
      printf("pipe() failed\n");
     662:	00006517          	auipc	a0,0x6
     666:	cbe50513          	addi	a0,a0,-834 # 6320 <malloc+0x2d6>
     66a:	00006097          	auipc	ra,0x6
     66e:	920080e7          	jalr	-1760(ra) # 5f8a <printf>
      exit(1);
     672:	4505                	li	a0,1
     674:	00005097          	auipc	ra,0x5
     678:	59e080e7          	jalr	1438(ra) # 5c12 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     67c:	862a                	mv	a2,a0
     67e:	85ca                	mv	a1,s2
     680:	00006517          	auipc	a0,0x6
     684:	cb050513          	addi	a0,a0,-848 # 6330 <malloc+0x2e6>
     688:	00006097          	auipc	ra,0x6
     68c:	902080e7          	jalr	-1790(ra) # 5f8a <printf>
      exit(1);
     690:	4505                	li	a0,1
     692:	00005097          	auipc	ra,0x5
     696:	580080e7          	jalr	1408(ra) # 5c12 <exit>

000000000000069a <copyout>:
{
     69a:	711d                	addi	sp,sp,-96
     69c:	ec86                	sd	ra,88(sp)
     69e:	e8a2                	sd	s0,80(sp)
     6a0:	e4a6                	sd	s1,72(sp)
     6a2:	e0ca                	sd	s2,64(sp)
     6a4:	fc4e                	sd	s3,56(sp)
     6a6:	f852                	sd	s4,48(sp)
     6a8:	f456                	sd	s5,40(sp)
     6aa:	f05a                	sd	s6,32(sp)
     6ac:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     6ae:	4785                	li	a5,1
     6b0:	07fe                	slli	a5,a5,0x1f
     6b2:	faf43823          	sd	a5,-80(s0)
     6b6:	57fd                	li	a5,-1
     6b8:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     6bc:	fb040493          	addi	s1,s0,-80
     6c0:	fc040b13          	addi	s6,s0,-64
    int fd = open("README", 0);
     6c4:	00006a17          	auipc	s4,0x6
     6c8:	c9ca0a13          	addi	s4,s4,-868 # 6360 <malloc+0x316>
    n = write(fds[1], "x", 1);
     6cc:	00006a97          	auipc	s5,0x6
     6d0:	b2ca8a93          	addi	s5,s5,-1236 # 61f8 <malloc+0x1ae>
    uint64 addr = addrs[ai];
     6d4:	0004b983          	ld	s3,0(s1)
    int fd = open("README", 0);
     6d8:	4581                	li	a1,0
     6da:	8552                	mv	a0,s4
     6dc:	00005097          	auipc	ra,0x5
     6e0:	576080e7          	jalr	1398(ra) # 5c52 <open>
     6e4:	892a                	mv	s2,a0
    if(fd < 0){
     6e6:	08054563          	bltz	a0,770 <copyout+0xd6>
    int n = read(fd, (void*)addr, 8192);
     6ea:	6609                	lui	a2,0x2
     6ec:	85ce                	mv	a1,s3
     6ee:	00005097          	auipc	ra,0x5
     6f2:	53c080e7          	jalr	1340(ra) # 5c2a <read>
    if(n > 0){
     6f6:	08a04a63          	bgtz	a0,78a <copyout+0xf0>
    close(fd);
     6fa:	854a                	mv	a0,s2
     6fc:	00005097          	auipc	ra,0x5
     700:	53e080e7          	jalr	1342(ra) # 5c3a <close>
    if(pipe(fds) < 0){
     704:	fa840513          	addi	a0,s0,-88
     708:	00005097          	auipc	ra,0x5
     70c:	51a080e7          	jalr	1306(ra) # 5c22 <pipe>
     710:	08054c63          	bltz	a0,7a8 <copyout+0x10e>
    n = write(fds[1], "x", 1);
     714:	4605                	li	a2,1
     716:	85d6                	mv	a1,s5
     718:	fac42503          	lw	a0,-84(s0)
     71c:	00005097          	auipc	ra,0x5
     720:	516080e7          	jalr	1302(ra) # 5c32 <write>
    if(n != 1){
     724:	4785                	li	a5,1
     726:	08f51e63          	bne	a0,a5,7c2 <copyout+0x128>
    n = read(fds[0], (void*)addr, 8192);
     72a:	6609                	lui	a2,0x2
     72c:	85ce                	mv	a1,s3
     72e:	fa842503          	lw	a0,-88(s0)
     732:	00005097          	auipc	ra,0x5
     736:	4f8080e7          	jalr	1272(ra) # 5c2a <read>
    if(n > 0){
     73a:	0aa04163          	bgtz	a0,7dc <copyout+0x142>
    close(fds[0]);
     73e:	fa842503          	lw	a0,-88(s0)
     742:	00005097          	auipc	ra,0x5
     746:	4f8080e7          	jalr	1272(ra) # 5c3a <close>
    close(fds[1]);
     74a:	fac42503          	lw	a0,-84(s0)
     74e:	00005097          	auipc	ra,0x5
     752:	4ec080e7          	jalr	1260(ra) # 5c3a <close>
  for(int ai = 0; ai < 2; ai++){
     756:	04a1                	addi	s1,s1,8
     758:	f7649ee3          	bne	s1,s6,6d4 <copyout+0x3a>
}
     75c:	60e6                	ld	ra,88(sp)
     75e:	6446                	ld	s0,80(sp)
     760:	64a6                	ld	s1,72(sp)
     762:	6906                	ld	s2,64(sp)
     764:	79e2                	ld	s3,56(sp)
     766:	7a42                	ld	s4,48(sp)
     768:	7aa2                	ld	s5,40(sp)
     76a:	7b02                	ld	s6,32(sp)
     76c:	6125                	addi	sp,sp,96
     76e:	8082                	ret
      printf("open(README) failed\n");
     770:	00006517          	auipc	a0,0x6
     774:	bf850513          	addi	a0,a0,-1032 # 6368 <malloc+0x31e>
     778:	00006097          	auipc	ra,0x6
     77c:	812080e7          	jalr	-2030(ra) # 5f8a <printf>
      exit(1);
     780:	4505                	li	a0,1
     782:	00005097          	auipc	ra,0x5
     786:	490080e7          	jalr	1168(ra) # 5c12 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     78a:	862a                	mv	a2,a0
     78c:	85ce                	mv	a1,s3
     78e:	00006517          	auipc	a0,0x6
     792:	bf250513          	addi	a0,a0,-1038 # 6380 <malloc+0x336>
     796:	00005097          	auipc	ra,0x5
     79a:	7f4080e7          	jalr	2036(ra) # 5f8a <printf>
      exit(1);
     79e:	4505                	li	a0,1
     7a0:	00005097          	auipc	ra,0x5
     7a4:	472080e7          	jalr	1138(ra) # 5c12 <exit>
      printf("pipe() failed\n");
     7a8:	00006517          	auipc	a0,0x6
     7ac:	b7850513          	addi	a0,a0,-1160 # 6320 <malloc+0x2d6>
     7b0:	00005097          	auipc	ra,0x5
     7b4:	7da080e7          	jalr	2010(ra) # 5f8a <printf>
      exit(1);
     7b8:	4505                	li	a0,1
     7ba:	00005097          	auipc	ra,0x5
     7be:	458080e7          	jalr	1112(ra) # 5c12 <exit>
      printf("pipe write failed\n");
     7c2:	00006517          	auipc	a0,0x6
     7c6:	bee50513          	addi	a0,a0,-1042 # 63b0 <malloc+0x366>
     7ca:	00005097          	auipc	ra,0x5
     7ce:	7c0080e7          	jalr	1984(ra) # 5f8a <printf>
      exit(1);
     7d2:	4505                	li	a0,1
     7d4:	00005097          	auipc	ra,0x5
     7d8:	43e080e7          	jalr	1086(ra) # 5c12 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     7dc:	862a                	mv	a2,a0
     7de:	85ce                	mv	a1,s3
     7e0:	00006517          	auipc	a0,0x6
     7e4:	be850513          	addi	a0,a0,-1048 # 63c8 <malloc+0x37e>
     7e8:	00005097          	auipc	ra,0x5
     7ec:	7a2080e7          	jalr	1954(ra) # 5f8a <printf>
      exit(1);
     7f0:	4505                	li	a0,1
     7f2:	00005097          	auipc	ra,0x5
     7f6:	420080e7          	jalr	1056(ra) # 5c12 <exit>

00000000000007fa <truncate1>:
{
     7fa:	711d                	addi	sp,sp,-96
     7fc:	ec86                	sd	ra,88(sp)
     7fe:	e8a2                	sd	s0,80(sp)
     800:	e4a6                	sd	s1,72(sp)
     802:	e0ca                	sd	s2,64(sp)
     804:	fc4e                	sd	s3,56(sp)
     806:	f852                	sd	s4,48(sp)
     808:	f456                	sd	s5,40(sp)
     80a:	1080                	addi	s0,sp,96
     80c:	8aaa                	mv	s5,a0
  unlink("truncfile");
     80e:	00006517          	auipc	a0,0x6
     812:	9d250513          	addi	a0,a0,-1582 # 61e0 <malloc+0x196>
     816:	00005097          	auipc	ra,0x5
     81a:	44c080e7          	jalr	1100(ra) # 5c62 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     81e:	60100593          	li	a1,1537
     822:	00006517          	auipc	a0,0x6
     826:	9be50513          	addi	a0,a0,-1602 # 61e0 <malloc+0x196>
     82a:	00005097          	auipc	ra,0x5
     82e:	428080e7          	jalr	1064(ra) # 5c52 <open>
     832:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     834:	4611                	li	a2,4
     836:	00006597          	auipc	a1,0x6
     83a:	9ba58593          	addi	a1,a1,-1606 # 61f0 <malloc+0x1a6>
     83e:	00005097          	auipc	ra,0x5
     842:	3f4080e7          	jalr	1012(ra) # 5c32 <write>
  close(fd1);
     846:	8526                	mv	a0,s1
     848:	00005097          	auipc	ra,0x5
     84c:	3f2080e7          	jalr	1010(ra) # 5c3a <close>
  int fd2 = open("truncfile", O_RDONLY);
     850:	4581                	li	a1,0
     852:	00006517          	auipc	a0,0x6
     856:	98e50513          	addi	a0,a0,-1650 # 61e0 <malloc+0x196>
     85a:	00005097          	auipc	ra,0x5
     85e:	3f8080e7          	jalr	1016(ra) # 5c52 <open>
     862:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     864:	02000613          	li	a2,32
     868:	fa040593          	addi	a1,s0,-96
     86c:	00005097          	auipc	ra,0x5
     870:	3be080e7          	jalr	958(ra) # 5c2a <read>
  if(n != 4){
     874:	4791                	li	a5,4
     876:	0cf51e63          	bne	a0,a5,952 <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     87a:	40100593          	li	a1,1025
     87e:	00006517          	auipc	a0,0x6
     882:	96250513          	addi	a0,a0,-1694 # 61e0 <malloc+0x196>
     886:	00005097          	auipc	ra,0x5
     88a:	3cc080e7          	jalr	972(ra) # 5c52 <open>
     88e:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     890:	4581                	li	a1,0
     892:	00006517          	auipc	a0,0x6
     896:	94e50513          	addi	a0,a0,-1714 # 61e0 <malloc+0x196>
     89a:	00005097          	auipc	ra,0x5
     89e:	3b8080e7          	jalr	952(ra) # 5c52 <open>
     8a2:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     8a4:	02000613          	li	a2,32
     8a8:	fa040593          	addi	a1,s0,-96
     8ac:	00005097          	auipc	ra,0x5
     8b0:	37e080e7          	jalr	894(ra) # 5c2a <read>
     8b4:	8a2a                	mv	s4,a0
  if(n != 0){
     8b6:	ed4d                	bnez	a0,970 <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     8b8:	02000613          	li	a2,32
     8bc:	fa040593          	addi	a1,s0,-96
     8c0:	8526                	mv	a0,s1
     8c2:	00005097          	auipc	ra,0x5
     8c6:	368080e7          	jalr	872(ra) # 5c2a <read>
     8ca:	8a2a                	mv	s4,a0
  if(n != 0){
     8cc:	e971                	bnez	a0,9a0 <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     8ce:	4619                	li	a2,6
     8d0:	00006597          	auipc	a1,0x6
     8d4:	b8858593          	addi	a1,a1,-1144 # 6458 <malloc+0x40e>
     8d8:	854e                	mv	a0,s3
     8da:	00005097          	auipc	ra,0x5
     8de:	358080e7          	jalr	856(ra) # 5c32 <write>
  n = read(fd3, buf, sizeof(buf));
     8e2:	02000613          	li	a2,32
     8e6:	fa040593          	addi	a1,s0,-96
     8ea:	854a                	mv	a0,s2
     8ec:	00005097          	auipc	ra,0x5
     8f0:	33e080e7          	jalr	830(ra) # 5c2a <read>
  if(n != 6){
     8f4:	4799                	li	a5,6
     8f6:	0cf51d63          	bne	a0,a5,9d0 <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     8fa:	02000613          	li	a2,32
     8fe:	fa040593          	addi	a1,s0,-96
     902:	8526                	mv	a0,s1
     904:	00005097          	auipc	ra,0x5
     908:	326080e7          	jalr	806(ra) # 5c2a <read>
  if(n != 2){
     90c:	4789                	li	a5,2
     90e:	0ef51063          	bne	a0,a5,9ee <truncate1+0x1f4>
  unlink("truncfile");
     912:	00006517          	auipc	a0,0x6
     916:	8ce50513          	addi	a0,a0,-1842 # 61e0 <malloc+0x196>
     91a:	00005097          	auipc	ra,0x5
     91e:	348080e7          	jalr	840(ra) # 5c62 <unlink>
  close(fd1);
     922:	854e                	mv	a0,s3
     924:	00005097          	auipc	ra,0x5
     928:	316080e7          	jalr	790(ra) # 5c3a <close>
  close(fd2);
     92c:	8526                	mv	a0,s1
     92e:	00005097          	auipc	ra,0x5
     932:	30c080e7          	jalr	780(ra) # 5c3a <close>
  close(fd3);
     936:	854a                	mv	a0,s2
     938:	00005097          	auipc	ra,0x5
     93c:	302080e7          	jalr	770(ra) # 5c3a <close>
}
     940:	60e6                	ld	ra,88(sp)
     942:	6446                	ld	s0,80(sp)
     944:	64a6                	ld	s1,72(sp)
     946:	6906                	ld	s2,64(sp)
     948:	79e2                	ld	s3,56(sp)
     94a:	7a42                	ld	s4,48(sp)
     94c:	7aa2                	ld	s5,40(sp)
     94e:	6125                	addi	sp,sp,96
     950:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     952:	862a                	mv	a2,a0
     954:	85d6                	mv	a1,s5
     956:	00006517          	auipc	a0,0x6
     95a:	aa250513          	addi	a0,a0,-1374 # 63f8 <malloc+0x3ae>
     95e:	00005097          	auipc	ra,0x5
     962:	62c080e7          	jalr	1580(ra) # 5f8a <printf>
    exit(1);
     966:	4505                	li	a0,1
     968:	00005097          	auipc	ra,0x5
     96c:	2aa080e7          	jalr	682(ra) # 5c12 <exit>
    printf("aaa fd3=%d\n", fd3);
     970:	85ca                	mv	a1,s2
     972:	00006517          	auipc	a0,0x6
     976:	aa650513          	addi	a0,a0,-1370 # 6418 <malloc+0x3ce>
     97a:	00005097          	auipc	ra,0x5
     97e:	610080e7          	jalr	1552(ra) # 5f8a <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     982:	8652                	mv	a2,s4
     984:	85d6                	mv	a1,s5
     986:	00006517          	auipc	a0,0x6
     98a:	aa250513          	addi	a0,a0,-1374 # 6428 <malloc+0x3de>
     98e:	00005097          	auipc	ra,0x5
     992:	5fc080e7          	jalr	1532(ra) # 5f8a <printf>
    exit(1);
     996:	4505                	li	a0,1
     998:	00005097          	auipc	ra,0x5
     99c:	27a080e7          	jalr	634(ra) # 5c12 <exit>
    printf("bbb fd2=%d\n", fd2);
     9a0:	85a6                	mv	a1,s1
     9a2:	00006517          	auipc	a0,0x6
     9a6:	aa650513          	addi	a0,a0,-1370 # 6448 <malloc+0x3fe>
     9aa:	00005097          	auipc	ra,0x5
     9ae:	5e0080e7          	jalr	1504(ra) # 5f8a <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     9b2:	8652                	mv	a2,s4
     9b4:	85d6                	mv	a1,s5
     9b6:	00006517          	auipc	a0,0x6
     9ba:	a7250513          	addi	a0,a0,-1422 # 6428 <malloc+0x3de>
     9be:	00005097          	auipc	ra,0x5
     9c2:	5cc080e7          	jalr	1484(ra) # 5f8a <printf>
    exit(1);
     9c6:	4505                	li	a0,1
     9c8:	00005097          	auipc	ra,0x5
     9cc:	24a080e7          	jalr	586(ra) # 5c12 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     9d0:	862a                	mv	a2,a0
     9d2:	85d6                	mv	a1,s5
     9d4:	00006517          	auipc	a0,0x6
     9d8:	a8c50513          	addi	a0,a0,-1396 # 6460 <malloc+0x416>
     9dc:	00005097          	auipc	ra,0x5
     9e0:	5ae080e7          	jalr	1454(ra) # 5f8a <printf>
    exit(1);
     9e4:	4505                	li	a0,1
     9e6:	00005097          	auipc	ra,0x5
     9ea:	22c080e7          	jalr	556(ra) # 5c12 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     9ee:	862a                	mv	a2,a0
     9f0:	85d6                	mv	a1,s5
     9f2:	00006517          	auipc	a0,0x6
     9f6:	a8e50513          	addi	a0,a0,-1394 # 6480 <malloc+0x436>
     9fa:	00005097          	auipc	ra,0x5
     9fe:	590080e7          	jalr	1424(ra) # 5f8a <printf>
    exit(1);
     a02:	4505                	li	a0,1
     a04:	00005097          	auipc	ra,0x5
     a08:	20e080e7          	jalr	526(ra) # 5c12 <exit>

0000000000000a0c <writetest>:
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
     a20:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     a22:	20200593          	li	a1,514
     a26:	00006517          	auipc	a0,0x6
     a2a:	a7a50513          	addi	a0,a0,-1414 # 64a0 <malloc+0x456>
     a2e:	00005097          	auipc	ra,0x5
     a32:	224080e7          	jalr	548(ra) # 5c52 <open>
  if(fd < 0){
     a36:	0a054d63          	bltz	a0,af0 <writetest+0xe4>
     a3a:	892a                	mv	s2,a0
     a3c:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     a3e:	00006997          	auipc	s3,0x6
     a42:	a8a98993          	addi	s3,s3,-1398 # 64c8 <malloc+0x47e>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     a46:	00006a97          	auipc	s5,0x6
     a4a:	abaa8a93          	addi	s5,s5,-1350 # 6500 <malloc+0x4b6>
  for(i = 0; i < N; i++){
     a4e:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     a52:	4629                	li	a2,10
     a54:	85ce                	mv	a1,s3
     a56:	854a                	mv	a0,s2
     a58:	00005097          	auipc	ra,0x5
     a5c:	1da080e7          	jalr	474(ra) # 5c32 <write>
     a60:	47a9                	li	a5,10
     a62:	0af51563          	bne	a0,a5,b0c <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     a66:	4629                	li	a2,10
     a68:	85d6                	mv	a1,s5
     a6a:	854a                	mv	a0,s2
     a6c:	00005097          	auipc	ra,0x5
     a70:	1c6080e7          	jalr	454(ra) # 5c32 <write>
     a74:	47a9                	li	a5,10
     a76:	0af51a63          	bne	a0,a5,b2a <writetest+0x11e>
  for(i = 0; i < N; i++){
     a7a:	2485                	addiw	s1,s1,1
     a7c:	fd449be3          	bne	s1,s4,a52 <writetest+0x46>
  close(fd);
     a80:	854a                	mv	a0,s2
     a82:	00005097          	auipc	ra,0x5
     a86:	1b8080e7          	jalr	440(ra) # 5c3a <close>
  fd = open("small", O_RDONLY);
     a8a:	4581                	li	a1,0
     a8c:	00006517          	auipc	a0,0x6
     a90:	a1450513          	addi	a0,a0,-1516 # 64a0 <malloc+0x456>
     a94:	00005097          	auipc	ra,0x5
     a98:	1be080e7          	jalr	446(ra) # 5c52 <open>
     a9c:	84aa                	mv	s1,a0
  if(fd < 0){
     a9e:	0a054563          	bltz	a0,b48 <writetest+0x13c>
  i = read(fd, buf, N*SZ*2);
     aa2:	7d000613          	li	a2,2000
     aa6:	0000c597          	auipc	a1,0xc
     aaa:	1d258593          	addi	a1,a1,466 # cc78 <buf>
     aae:	00005097          	auipc	ra,0x5
     ab2:	17c080e7          	jalr	380(ra) # 5c2a <read>
  if(i != N*SZ*2){
     ab6:	7d000793          	li	a5,2000
     aba:	0af51563          	bne	a0,a5,b64 <writetest+0x158>
  close(fd);
     abe:	8526                	mv	a0,s1
     ac0:	00005097          	auipc	ra,0x5
     ac4:	17a080e7          	jalr	378(ra) # 5c3a <close>
  if(unlink("small") < 0){
     ac8:	00006517          	auipc	a0,0x6
     acc:	9d850513          	addi	a0,a0,-1576 # 64a0 <malloc+0x456>
     ad0:	00005097          	auipc	ra,0x5
     ad4:	192080e7          	jalr	402(ra) # 5c62 <unlink>
     ad8:	0a054463          	bltz	a0,b80 <writetest+0x174>
}
     adc:	70e2                	ld	ra,56(sp)
     ade:	7442                	ld	s0,48(sp)
     ae0:	74a2                	ld	s1,40(sp)
     ae2:	7902                	ld	s2,32(sp)
     ae4:	69e2                	ld	s3,24(sp)
     ae6:	6a42                	ld	s4,16(sp)
     ae8:	6aa2                	ld	s5,8(sp)
     aea:	6b02                	ld	s6,0(sp)
     aec:	6121                	addi	sp,sp,64
     aee:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     af0:	85da                	mv	a1,s6
     af2:	00006517          	auipc	a0,0x6
     af6:	9b650513          	addi	a0,a0,-1610 # 64a8 <malloc+0x45e>
     afa:	00005097          	auipc	ra,0x5
     afe:	490080e7          	jalr	1168(ra) # 5f8a <printf>
    exit(1);
     b02:	4505                	li	a0,1
     b04:	00005097          	auipc	ra,0x5
     b08:	10e080e7          	jalr	270(ra) # 5c12 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     b0c:	8626                	mv	a2,s1
     b0e:	85da                	mv	a1,s6
     b10:	00006517          	auipc	a0,0x6
     b14:	9c850513          	addi	a0,a0,-1592 # 64d8 <malloc+0x48e>
     b18:	00005097          	auipc	ra,0x5
     b1c:	472080e7          	jalr	1138(ra) # 5f8a <printf>
      exit(1);
     b20:	4505                	li	a0,1
     b22:	00005097          	auipc	ra,0x5
     b26:	0f0080e7          	jalr	240(ra) # 5c12 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     b2a:	8626                	mv	a2,s1
     b2c:	85da                	mv	a1,s6
     b2e:	00006517          	auipc	a0,0x6
     b32:	9e250513          	addi	a0,a0,-1566 # 6510 <malloc+0x4c6>
     b36:	00005097          	auipc	ra,0x5
     b3a:	454080e7          	jalr	1108(ra) # 5f8a <printf>
      exit(1);
     b3e:	4505                	li	a0,1
     b40:	00005097          	auipc	ra,0x5
     b44:	0d2080e7          	jalr	210(ra) # 5c12 <exit>
    printf("%s: error: open small failed!\n", s);
     b48:	85da                	mv	a1,s6
     b4a:	00006517          	auipc	a0,0x6
     b4e:	9ee50513          	addi	a0,a0,-1554 # 6538 <malloc+0x4ee>
     b52:	00005097          	auipc	ra,0x5
     b56:	438080e7          	jalr	1080(ra) # 5f8a <printf>
    exit(1);
     b5a:	4505                	li	a0,1
     b5c:	00005097          	auipc	ra,0x5
     b60:	0b6080e7          	jalr	182(ra) # 5c12 <exit>
    printf("%s: read failed\n", s);
     b64:	85da                	mv	a1,s6
     b66:	00006517          	auipc	a0,0x6
     b6a:	9f250513          	addi	a0,a0,-1550 # 6558 <malloc+0x50e>
     b6e:	00005097          	auipc	ra,0x5
     b72:	41c080e7          	jalr	1052(ra) # 5f8a <printf>
    exit(1);
     b76:	4505                	li	a0,1
     b78:	00005097          	auipc	ra,0x5
     b7c:	09a080e7          	jalr	154(ra) # 5c12 <exit>
    printf("%s: unlink small failed\n", s);
     b80:	85da                	mv	a1,s6
     b82:	00006517          	auipc	a0,0x6
     b86:	9ee50513          	addi	a0,a0,-1554 # 6570 <malloc+0x526>
     b8a:	00005097          	auipc	ra,0x5
     b8e:	400080e7          	jalr	1024(ra) # 5f8a <printf>
    exit(1);
     b92:	4505                	li	a0,1
     b94:	00005097          	auipc	ra,0x5
     b98:	07e080e7          	jalr	126(ra) # 5c12 <exit>

0000000000000b9c <writebig>:
{
     b9c:	7139                	addi	sp,sp,-64
     b9e:	fc06                	sd	ra,56(sp)
     ba0:	f822                	sd	s0,48(sp)
     ba2:	f426                	sd	s1,40(sp)
     ba4:	f04a                	sd	s2,32(sp)
     ba6:	ec4e                	sd	s3,24(sp)
     ba8:	e852                	sd	s4,16(sp)
     baa:	e456                	sd	s5,8(sp)
     bac:	0080                	addi	s0,sp,64
     bae:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     bb0:	20200593          	li	a1,514
     bb4:	00006517          	auipc	a0,0x6
     bb8:	9dc50513          	addi	a0,a0,-1572 # 6590 <malloc+0x546>
     bbc:	00005097          	auipc	ra,0x5
     bc0:	096080e7          	jalr	150(ra) # 5c52 <open>
     bc4:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     bc6:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     bc8:	0000c917          	auipc	s2,0xc
     bcc:	0b090913          	addi	s2,s2,176 # cc78 <buf>
  for(i = 0; i < MAXFILE; i++){
     bd0:	10c00a13          	li	s4,268
  if(fd < 0){
     bd4:	06054c63          	bltz	a0,c4c <writebig+0xb0>
    ((int*)buf)[0] = i;
     bd8:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     bdc:	40000613          	li	a2,1024
     be0:	85ca                	mv	a1,s2
     be2:	854e                	mv	a0,s3
     be4:	00005097          	auipc	ra,0x5
     be8:	04e080e7          	jalr	78(ra) # 5c32 <write>
     bec:	40000793          	li	a5,1024
     bf0:	06f51c63          	bne	a0,a5,c68 <writebig+0xcc>
  for(i = 0; i < MAXFILE; i++){
     bf4:	2485                	addiw	s1,s1,1
     bf6:	ff4491e3          	bne	s1,s4,bd8 <writebig+0x3c>
  close(fd);
     bfa:	854e                	mv	a0,s3
     bfc:	00005097          	auipc	ra,0x5
     c00:	03e080e7          	jalr	62(ra) # 5c3a <close>
  fd = open("big", O_RDONLY);
     c04:	4581                	li	a1,0
     c06:	00006517          	auipc	a0,0x6
     c0a:	98a50513          	addi	a0,a0,-1654 # 6590 <malloc+0x546>
     c0e:	00005097          	auipc	ra,0x5
     c12:	044080e7          	jalr	68(ra) # 5c52 <open>
     c16:	89aa                	mv	s3,a0
  n = 0;
     c18:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     c1a:	0000c917          	auipc	s2,0xc
     c1e:	05e90913          	addi	s2,s2,94 # cc78 <buf>
  if(fd < 0){
     c22:	06054263          	bltz	a0,c86 <writebig+0xea>
    i = read(fd, buf, BSIZE);
     c26:	40000613          	li	a2,1024
     c2a:	85ca                	mv	a1,s2
     c2c:	854e                	mv	a0,s3
     c2e:	00005097          	auipc	ra,0x5
     c32:	ffc080e7          	jalr	-4(ra) # 5c2a <read>
    if(i == 0){
     c36:	c535                	beqz	a0,ca2 <writebig+0x106>
    } else if(i != BSIZE){
     c38:	40000793          	li	a5,1024
     c3c:	0af51f63          	bne	a0,a5,cfa <writebig+0x15e>
    if(((int*)buf)[0] != n){
     c40:	00092683          	lw	a3,0(s2)
     c44:	0c969a63          	bne	a3,s1,d18 <writebig+0x17c>
    n++;
     c48:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     c4a:	bff1                	j	c26 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
     c4c:	85d6                	mv	a1,s5
     c4e:	00006517          	auipc	a0,0x6
     c52:	94a50513          	addi	a0,a0,-1718 # 6598 <malloc+0x54e>
     c56:	00005097          	auipc	ra,0x5
     c5a:	334080e7          	jalr	820(ra) # 5f8a <printf>
    exit(1);
     c5e:	4505                	li	a0,1
     c60:	00005097          	auipc	ra,0x5
     c64:	fb2080e7          	jalr	-78(ra) # 5c12 <exit>
      printf("%s: error: write big file failed\n", s, i);
     c68:	8626                	mv	a2,s1
     c6a:	85d6                	mv	a1,s5
     c6c:	00006517          	auipc	a0,0x6
     c70:	94c50513          	addi	a0,a0,-1716 # 65b8 <malloc+0x56e>
     c74:	00005097          	auipc	ra,0x5
     c78:	316080e7          	jalr	790(ra) # 5f8a <printf>
      exit(1);
     c7c:	4505                	li	a0,1
     c7e:	00005097          	auipc	ra,0x5
     c82:	f94080e7          	jalr	-108(ra) # 5c12 <exit>
    printf("%s: error: open big failed!\n", s);
     c86:	85d6                	mv	a1,s5
     c88:	00006517          	auipc	a0,0x6
     c8c:	95850513          	addi	a0,a0,-1704 # 65e0 <malloc+0x596>
     c90:	00005097          	auipc	ra,0x5
     c94:	2fa080e7          	jalr	762(ra) # 5f8a <printf>
    exit(1);
     c98:	4505                	li	a0,1
     c9a:	00005097          	auipc	ra,0x5
     c9e:	f78080e7          	jalr	-136(ra) # 5c12 <exit>
      if(n == MAXFILE - 1){
     ca2:	10b00793          	li	a5,267
     ca6:	02f48a63          	beq	s1,a5,cda <writebig+0x13e>
  close(fd);
     caa:	854e                	mv	a0,s3
     cac:	00005097          	auipc	ra,0x5
     cb0:	f8e080e7          	jalr	-114(ra) # 5c3a <close>
  if(unlink("big") < 0){
     cb4:	00006517          	auipc	a0,0x6
     cb8:	8dc50513          	addi	a0,a0,-1828 # 6590 <malloc+0x546>
     cbc:	00005097          	auipc	ra,0x5
     cc0:	fa6080e7          	jalr	-90(ra) # 5c62 <unlink>
     cc4:	06054963          	bltz	a0,d36 <writebig+0x19a>
}
     cc8:	70e2                	ld	ra,56(sp)
     cca:	7442                	ld	s0,48(sp)
     ccc:	74a2                	ld	s1,40(sp)
     cce:	7902                	ld	s2,32(sp)
     cd0:	69e2                	ld	s3,24(sp)
     cd2:	6a42                	ld	s4,16(sp)
     cd4:	6aa2                	ld	s5,8(sp)
     cd6:	6121                	addi	sp,sp,64
     cd8:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     cda:	10b00613          	li	a2,267
     cde:	85d6                	mv	a1,s5
     ce0:	00006517          	auipc	a0,0x6
     ce4:	92050513          	addi	a0,a0,-1760 # 6600 <malloc+0x5b6>
     ce8:	00005097          	auipc	ra,0x5
     cec:	2a2080e7          	jalr	674(ra) # 5f8a <printf>
        exit(1);
     cf0:	4505                	li	a0,1
     cf2:	00005097          	auipc	ra,0x5
     cf6:	f20080e7          	jalr	-224(ra) # 5c12 <exit>
      printf("%s: read failed %d\n", s, i);
     cfa:	862a                	mv	a2,a0
     cfc:	85d6                	mv	a1,s5
     cfe:	00006517          	auipc	a0,0x6
     d02:	92a50513          	addi	a0,a0,-1750 # 6628 <malloc+0x5de>
     d06:	00005097          	auipc	ra,0x5
     d0a:	284080e7          	jalr	644(ra) # 5f8a <printf>
      exit(1);
     d0e:	4505                	li	a0,1
     d10:	00005097          	auipc	ra,0x5
     d14:	f02080e7          	jalr	-254(ra) # 5c12 <exit>
      printf("%s: read content of block %d is %d\n", s,
     d18:	8626                	mv	a2,s1
     d1a:	85d6                	mv	a1,s5
     d1c:	00006517          	auipc	a0,0x6
     d20:	92450513          	addi	a0,a0,-1756 # 6640 <malloc+0x5f6>
     d24:	00005097          	auipc	ra,0x5
     d28:	266080e7          	jalr	614(ra) # 5f8a <printf>
      exit(1);
     d2c:	4505                	li	a0,1
     d2e:	00005097          	auipc	ra,0x5
     d32:	ee4080e7          	jalr	-284(ra) # 5c12 <exit>
    printf("%s: unlink big failed\n", s);
     d36:	85d6                	mv	a1,s5
     d38:	00006517          	auipc	a0,0x6
     d3c:	93050513          	addi	a0,a0,-1744 # 6668 <malloc+0x61e>
     d40:	00005097          	auipc	ra,0x5
     d44:	24a080e7          	jalr	586(ra) # 5f8a <printf>
    exit(1);
     d48:	4505                	li	a0,1
     d4a:	00005097          	auipc	ra,0x5
     d4e:	ec8080e7          	jalr	-312(ra) # 5c12 <exit>

0000000000000d52 <unlinkread>:
{
     d52:	7179                	addi	sp,sp,-48
     d54:	f406                	sd	ra,40(sp)
     d56:	f022                	sd	s0,32(sp)
     d58:	ec26                	sd	s1,24(sp)
     d5a:	e84a                	sd	s2,16(sp)
     d5c:	e44e                	sd	s3,8(sp)
     d5e:	1800                	addi	s0,sp,48
     d60:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     d62:	20200593          	li	a1,514
     d66:	00006517          	auipc	a0,0x6
     d6a:	91a50513          	addi	a0,a0,-1766 # 6680 <malloc+0x636>
     d6e:	00005097          	auipc	ra,0x5
     d72:	ee4080e7          	jalr	-284(ra) # 5c52 <open>
  if(fd < 0){
     d76:	0e054563          	bltz	a0,e60 <unlinkread+0x10e>
     d7a:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     d7c:	4615                	li	a2,5
     d7e:	00006597          	auipc	a1,0x6
     d82:	93258593          	addi	a1,a1,-1742 # 66b0 <malloc+0x666>
     d86:	00005097          	auipc	ra,0x5
     d8a:	eac080e7          	jalr	-340(ra) # 5c32 <write>
  close(fd);
     d8e:	8526                	mv	a0,s1
     d90:	00005097          	auipc	ra,0x5
     d94:	eaa080e7          	jalr	-342(ra) # 5c3a <close>
  fd = open("unlinkread", O_RDWR);
     d98:	4589                	li	a1,2
     d9a:	00006517          	auipc	a0,0x6
     d9e:	8e650513          	addi	a0,a0,-1818 # 6680 <malloc+0x636>
     da2:	00005097          	auipc	ra,0x5
     da6:	eb0080e7          	jalr	-336(ra) # 5c52 <open>
     daa:	84aa                	mv	s1,a0
  if(fd < 0){
     dac:	0c054863          	bltz	a0,e7c <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     db0:	00006517          	auipc	a0,0x6
     db4:	8d050513          	addi	a0,a0,-1840 # 6680 <malloc+0x636>
     db8:	00005097          	auipc	ra,0x5
     dbc:	eaa080e7          	jalr	-342(ra) # 5c62 <unlink>
     dc0:	ed61                	bnez	a0,e98 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     dc2:	20200593          	li	a1,514
     dc6:	00006517          	auipc	a0,0x6
     dca:	8ba50513          	addi	a0,a0,-1862 # 6680 <malloc+0x636>
     dce:	00005097          	auipc	ra,0x5
     dd2:	e84080e7          	jalr	-380(ra) # 5c52 <open>
     dd6:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     dd8:	460d                	li	a2,3
     dda:	00006597          	auipc	a1,0x6
     dde:	91e58593          	addi	a1,a1,-1762 # 66f8 <malloc+0x6ae>
     de2:	00005097          	auipc	ra,0x5
     de6:	e50080e7          	jalr	-432(ra) # 5c32 <write>
  close(fd1);
     dea:	854a                	mv	a0,s2
     dec:	00005097          	auipc	ra,0x5
     df0:	e4e080e7          	jalr	-434(ra) # 5c3a <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     df4:	660d                	lui	a2,0x3
     df6:	0000c597          	auipc	a1,0xc
     dfa:	e8258593          	addi	a1,a1,-382 # cc78 <buf>
     dfe:	8526                	mv	a0,s1
     e00:	00005097          	auipc	ra,0x5
     e04:	e2a080e7          	jalr	-470(ra) # 5c2a <read>
     e08:	4795                	li	a5,5
     e0a:	0af51563          	bne	a0,a5,eb4 <unlinkread+0x162>
  if(buf[0] != 'h'){
     e0e:	0000c717          	auipc	a4,0xc
     e12:	e6a74703          	lbu	a4,-406(a4) # cc78 <buf>
     e16:	06800793          	li	a5,104
     e1a:	0af71b63          	bne	a4,a5,ed0 <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     e1e:	4629                	li	a2,10
     e20:	0000c597          	auipc	a1,0xc
     e24:	e5858593          	addi	a1,a1,-424 # cc78 <buf>
     e28:	8526                	mv	a0,s1
     e2a:	00005097          	auipc	ra,0x5
     e2e:	e08080e7          	jalr	-504(ra) # 5c32 <write>
     e32:	47a9                	li	a5,10
     e34:	0af51c63          	bne	a0,a5,eec <unlinkread+0x19a>
  close(fd);
     e38:	8526                	mv	a0,s1
     e3a:	00005097          	auipc	ra,0x5
     e3e:	e00080e7          	jalr	-512(ra) # 5c3a <close>
  unlink("unlinkread");
     e42:	00006517          	auipc	a0,0x6
     e46:	83e50513          	addi	a0,a0,-1986 # 6680 <malloc+0x636>
     e4a:	00005097          	auipc	ra,0x5
     e4e:	e18080e7          	jalr	-488(ra) # 5c62 <unlink>
}
     e52:	70a2                	ld	ra,40(sp)
     e54:	7402                	ld	s0,32(sp)
     e56:	64e2                	ld	s1,24(sp)
     e58:	6942                	ld	s2,16(sp)
     e5a:	69a2                	ld	s3,8(sp)
     e5c:	6145                	addi	sp,sp,48
     e5e:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     e60:	85ce                	mv	a1,s3
     e62:	00006517          	auipc	a0,0x6
     e66:	82e50513          	addi	a0,a0,-2002 # 6690 <malloc+0x646>
     e6a:	00005097          	auipc	ra,0x5
     e6e:	120080e7          	jalr	288(ra) # 5f8a <printf>
    exit(1);
     e72:	4505                	li	a0,1
     e74:	00005097          	auipc	ra,0x5
     e78:	d9e080e7          	jalr	-610(ra) # 5c12 <exit>
    printf("%s: open unlinkread failed\n", s);
     e7c:	85ce                	mv	a1,s3
     e7e:	00006517          	auipc	a0,0x6
     e82:	83a50513          	addi	a0,a0,-1990 # 66b8 <malloc+0x66e>
     e86:	00005097          	auipc	ra,0x5
     e8a:	104080e7          	jalr	260(ra) # 5f8a <printf>
    exit(1);
     e8e:	4505                	li	a0,1
     e90:	00005097          	auipc	ra,0x5
     e94:	d82080e7          	jalr	-638(ra) # 5c12 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     e98:	85ce                	mv	a1,s3
     e9a:	00006517          	auipc	a0,0x6
     e9e:	83e50513          	addi	a0,a0,-1986 # 66d8 <malloc+0x68e>
     ea2:	00005097          	auipc	ra,0x5
     ea6:	0e8080e7          	jalr	232(ra) # 5f8a <printf>
    exit(1);
     eaa:	4505                	li	a0,1
     eac:	00005097          	auipc	ra,0x5
     eb0:	d66080e7          	jalr	-666(ra) # 5c12 <exit>
    printf("%s: unlinkread read failed", s);
     eb4:	85ce                	mv	a1,s3
     eb6:	00006517          	auipc	a0,0x6
     eba:	84a50513          	addi	a0,a0,-1974 # 6700 <malloc+0x6b6>
     ebe:	00005097          	auipc	ra,0x5
     ec2:	0cc080e7          	jalr	204(ra) # 5f8a <printf>
    exit(1);
     ec6:	4505                	li	a0,1
     ec8:	00005097          	auipc	ra,0x5
     ecc:	d4a080e7          	jalr	-694(ra) # 5c12 <exit>
    printf("%s: unlinkread wrong data\n", s);
     ed0:	85ce                	mv	a1,s3
     ed2:	00006517          	auipc	a0,0x6
     ed6:	84e50513          	addi	a0,a0,-1970 # 6720 <malloc+0x6d6>
     eda:	00005097          	auipc	ra,0x5
     ede:	0b0080e7          	jalr	176(ra) # 5f8a <printf>
    exit(1);
     ee2:	4505                	li	a0,1
     ee4:	00005097          	auipc	ra,0x5
     ee8:	d2e080e7          	jalr	-722(ra) # 5c12 <exit>
    printf("%s: unlinkread write failed\n", s);
     eec:	85ce                	mv	a1,s3
     eee:	00006517          	auipc	a0,0x6
     ef2:	85250513          	addi	a0,a0,-1966 # 6740 <malloc+0x6f6>
     ef6:	00005097          	auipc	ra,0x5
     efa:	094080e7          	jalr	148(ra) # 5f8a <printf>
    exit(1);
     efe:	4505                	li	a0,1
     f00:	00005097          	auipc	ra,0x5
     f04:	d12080e7          	jalr	-750(ra) # 5c12 <exit>

0000000000000f08 <linktest>:
{
     f08:	1101                	addi	sp,sp,-32
     f0a:	ec06                	sd	ra,24(sp)
     f0c:	e822                	sd	s0,16(sp)
     f0e:	e426                	sd	s1,8(sp)
     f10:	e04a                	sd	s2,0(sp)
     f12:	1000                	addi	s0,sp,32
     f14:	892a                	mv	s2,a0
  unlink("lf1");
     f16:	00006517          	auipc	a0,0x6
     f1a:	84a50513          	addi	a0,a0,-1974 # 6760 <malloc+0x716>
     f1e:	00005097          	auipc	ra,0x5
     f22:	d44080e7          	jalr	-700(ra) # 5c62 <unlink>
  unlink("lf2");
     f26:	00006517          	auipc	a0,0x6
     f2a:	84250513          	addi	a0,a0,-1982 # 6768 <malloc+0x71e>
     f2e:	00005097          	auipc	ra,0x5
     f32:	d34080e7          	jalr	-716(ra) # 5c62 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     f36:	20200593          	li	a1,514
     f3a:	00006517          	auipc	a0,0x6
     f3e:	82650513          	addi	a0,a0,-2010 # 6760 <malloc+0x716>
     f42:	00005097          	auipc	ra,0x5
     f46:	d10080e7          	jalr	-752(ra) # 5c52 <open>
  if(fd < 0){
     f4a:	10054763          	bltz	a0,1058 <linktest+0x150>
     f4e:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     f50:	4615                	li	a2,5
     f52:	00005597          	auipc	a1,0x5
     f56:	75e58593          	addi	a1,a1,1886 # 66b0 <malloc+0x666>
     f5a:	00005097          	auipc	ra,0x5
     f5e:	cd8080e7          	jalr	-808(ra) # 5c32 <write>
     f62:	4795                	li	a5,5
     f64:	10f51863          	bne	a0,a5,1074 <linktest+0x16c>
  close(fd);
     f68:	8526                	mv	a0,s1
     f6a:	00005097          	auipc	ra,0x5
     f6e:	cd0080e7          	jalr	-816(ra) # 5c3a <close>
  if(link("lf1", "lf2") < 0){
     f72:	00005597          	auipc	a1,0x5
     f76:	7f658593          	addi	a1,a1,2038 # 6768 <malloc+0x71e>
     f7a:	00005517          	auipc	a0,0x5
     f7e:	7e650513          	addi	a0,a0,2022 # 6760 <malloc+0x716>
     f82:	00005097          	auipc	ra,0x5
     f86:	cf0080e7          	jalr	-784(ra) # 5c72 <link>
     f8a:	10054363          	bltz	a0,1090 <linktest+0x188>
  unlink("lf1");
     f8e:	00005517          	auipc	a0,0x5
     f92:	7d250513          	addi	a0,a0,2002 # 6760 <malloc+0x716>
     f96:	00005097          	auipc	ra,0x5
     f9a:	ccc080e7          	jalr	-820(ra) # 5c62 <unlink>
  if(open("lf1", 0) >= 0){
     f9e:	4581                	li	a1,0
     fa0:	00005517          	auipc	a0,0x5
     fa4:	7c050513          	addi	a0,a0,1984 # 6760 <malloc+0x716>
     fa8:	00005097          	auipc	ra,0x5
     fac:	caa080e7          	jalr	-854(ra) # 5c52 <open>
     fb0:	0e055e63          	bgez	a0,10ac <linktest+0x1a4>
  fd = open("lf2", 0);
     fb4:	4581                	li	a1,0
     fb6:	00005517          	auipc	a0,0x5
     fba:	7b250513          	addi	a0,a0,1970 # 6768 <malloc+0x71e>
     fbe:	00005097          	auipc	ra,0x5
     fc2:	c94080e7          	jalr	-876(ra) # 5c52 <open>
     fc6:	84aa                	mv	s1,a0
  if(fd < 0){
     fc8:	10054063          	bltz	a0,10c8 <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     fcc:	660d                	lui	a2,0x3
     fce:	0000c597          	auipc	a1,0xc
     fd2:	caa58593          	addi	a1,a1,-854 # cc78 <buf>
     fd6:	00005097          	auipc	ra,0x5
     fda:	c54080e7          	jalr	-940(ra) # 5c2a <read>
     fde:	4795                	li	a5,5
     fe0:	10f51263          	bne	a0,a5,10e4 <linktest+0x1dc>
  close(fd);
     fe4:	8526                	mv	a0,s1
     fe6:	00005097          	auipc	ra,0x5
     fea:	c54080e7          	jalr	-940(ra) # 5c3a <close>
  if(link("lf2", "lf2") >= 0){
     fee:	00005597          	auipc	a1,0x5
     ff2:	77a58593          	addi	a1,a1,1914 # 6768 <malloc+0x71e>
     ff6:	852e                	mv	a0,a1
     ff8:	00005097          	auipc	ra,0x5
     ffc:	c7a080e7          	jalr	-902(ra) # 5c72 <link>
    1000:	10055063          	bgez	a0,1100 <linktest+0x1f8>
  unlink("lf2");
    1004:	00005517          	auipc	a0,0x5
    1008:	76450513          	addi	a0,a0,1892 # 6768 <malloc+0x71e>
    100c:	00005097          	auipc	ra,0x5
    1010:	c56080e7          	jalr	-938(ra) # 5c62 <unlink>
  if(link("lf2", "lf1") >= 0){
    1014:	00005597          	auipc	a1,0x5
    1018:	74c58593          	addi	a1,a1,1868 # 6760 <malloc+0x716>
    101c:	00005517          	auipc	a0,0x5
    1020:	74c50513          	addi	a0,a0,1868 # 6768 <malloc+0x71e>
    1024:	00005097          	auipc	ra,0x5
    1028:	c4e080e7          	jalr	-946(ra) # 5c72 <link>
    102c:	0e055863          	bgez	a0,111c <linktest+0x214>
  if(link(".", "lf1") >= 0){
    1030:	00005597          	auipc	a1,0x5
    1034:	73058593          	addi	a1,a1,1840 # 6760 <malloc+0x716>
    1038:	00006517          	auipc	a0,0x6
    103c:	83850513          	addi	a0,a0,-1992 # 6870 <malloc+0x826>
    1040:	00005097          	auipc	ra,0x5
    1044:	c32080e7          	jalr	-974(ra) # 5c72 <link>
    1048:	0e055863          	bgez	a0,1138 <linktest+0x230>
}
    104c:	60e2                	ld	ra,24(sp)
    104e:	6442                	ld	s0,16(sp)
    1050:	64a2                	ld	s1,8(sp)
    1052:	6902                	ld	s2,0(sp)
    1054:	6105                	addi	sp,sp,32
    1056:	8082                	ret
    printf("%s: create lf1 failed\n", s);
    1058:	85ca                	mv	a1,s2
    105a:	00005517          	auipc	a0,0x5
    105e:	71650513          	addi	a0,a0,1814 # 6770 <malloc+0x726>
    1062:	00005097          	auipc	ra,0x5
    1066:	f28080e7          	jalr	-216(ra) # 5f8a <printf>
    exit(1);
    106a:	4505                	li	a0,1
    106c:	00005097          	auipc	ra,0x5
    1070:	ba6080e7          	jalr	-1114(ra) # 5c12 <exit>
    printf("%s: write lf1 failed\n", s);
    1074:	85ca                	mv	a1,s2
    1076:	00005517          	auipc	a0,0x5
    107a:	71250513          	addi	a0,a0,1810 # 6788 <malloc+0x73e>
    107e:	00005097          	auipc	ra,0x5
    1082:	f0c080e7          	jalr	-244(ra) # 5f8a <printf>
    exit(1);
    1086:	4505                	li	a0,1
    1088:	00005097          	auipc	ra,0x5
    108c:	b8a080e7          	jalr	-1142(ra) # 5c12 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
    1090:	85ca                	mv	a1,s2
    1092:	00005517          	auipc	a0,0x5
    1096:	70e50513          	addi	a0,a0,1806 # 67a0 <malloc+0x756>
    109a:	00005097          	auipc	ra,0x5
    109e:	ef0080e7          	jalr	-272(ra) # 5f8a <printf>
    exit(1);
    10a2:	4505                	li	a0,1
    10a4:	00005097          	auipc	ra,0x5
    10a8:	b6e080e7          	jalr	-1170(ra) # 5c12 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
    10ac:	85ca                	mv	a1,s2
    10ae:	00005517          	auipc	a0,0x5
    10b2:	71250513          	addi	a0,a0,1810 # 67c0 <malloc+0x776>
    10b6:	00005097          	auipc	ra,0x5
    10ba:	ed4080e7          	jalr	-300(ra) # 5f8a <printf>
    exit(1);
    10be:	4505                	li	a0,1
    10c0:	00005097          	auipc	ra,0x5
    10c4:	b52080e7          	jalr	-1198(ra) # 5c12 <exit>
    printf("%s: open lf2 failed\n", s);
    10c8:	85ca                	mv	a1,s2
    10ca:	00005517          	auipc	a0,0x5
    10ce:	72650513          	addi	a0,a0,1830 # 67f0 <malloc+0x7a6>
    10d2:	00005097          	auipc	ra,0x5
    10d6:	eb8080e7          	jalr	-328(ra) # 5f8a <printf>
    exit(1);
    10da:	4505                	li	a0,1
    10dc:	00005097          	auipc	ra,0x5
    10e0:	b36080e7          	jalr	-1226(ra) # 5c12 <exit>
    printf("%s: read lf2 failed\n", s);
    10e4:	85ca                	mv	a1,s2
    10e6:	00005517          	auipc	a0,0x5
    10ea:	72250513          	addi	a0,a0,1826 # 6808 <malloc+0x7be>
    10ee:	00005097          	auipc	ra,0x5
    10f2:	e9c080e7          	jalr	-356(ra) # 5f8a <printf>
    exit(1);
    10f6:	4505                	li	a0,1
    10f8:	00005097          	auipc	ra,0x5
    10fc:	b1a080e7          	jalr	-1254(ra) # 5c12 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
    1100:	85ca                	mv	a1,s2
    1102:	00005517          	auipc	a0,0x5
    1106:	71e50513          	addi	a0,a0,1822 # 6820 <malloc+0x7d6>
    110a:	00005097          	auipc	ra,0x5
    110e:	e80080e7          	jalr	-384(ra) # 5f8a <printf>
    exit(1);
    1112:	4505                	li	a0,1
    1114:	00005097          	auipc	ra,0x5
    1118:	afe080e7          	jalr	-1282(ra) # 5c12 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
    111c:	85ca                	mv	a1,s2
    111e:	00005517          	auipc	a0,0x5
    1122:	72a50513          	addi	a0,a0,1834 # 6848 <malloc+0x7fe>
    1126:	00005097          	auipc	ra,0x5
    112a:	e64080e7          	jalr	-412(ra) # 5f8a <printf>
    exit(1);
    112e:	4505                	li	a0,1
    1130:	00005097          	auipc	ra,0x5
    1134:	ae2080e7          	jalr	-1310(ra) # 5c12 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
    1138:	85ca                	mv	a1,s2
    113a:	00005517          	auipc	a0,0x5
    113e:	73e50513          	addi	a0,a0,1854 # 6878 <malloc+0x82e>
    1142:	00005097          	auipc	ra,0x5
    1146:	e48080e7          	jalr	-440(ra) # 5f8a <printf>
    exit(1);
    114a:	4505                	li	a0,1
    114c:	00005097          	auipc	ra,0x5
    1150:	ac6080e7          	jalr	-1338(ra) # 5c12 <exit>

0000000000001154 <validatetest>:
{
    1154:	7139                	addi	sp,sp,-64
    1156:	fc06                	sd	ra,56(sp)
    1158:	f822                	sd	s0,48(sp)
    115a:	f426                	sd	s1,40(sp)
    115c:	f04a                	sd	s2,32(sp)
    115e:	ec4e                	sd	s3,24(sp)
    1160:	e852                	sd	s4,16(sp)
    1162:	e456                	sd	s5,8(sp)
    1164:	e05a                	sd	s6,0(sp)
    1166:	0080                	addi	s0,sp,64
    1168:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    116a:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    116c:	00005997          	auipc	s3,0x5
    1170:	72c98993          	addi	s3,s3,1836 # 6898 <malloc+0x84e>
    1174:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1176:	6a85                	lui	s5,0x1
    1178:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    117c:	85a6                	mv	a1,s1
    117e:	854e                	mv	a0,s3
    1180:	00005097          	auipc	ra,0x5
    1184:	af2080e7          	jalr	-1294(ra) # 5c72 <link>
    1188:	01251f63          	bne	a0,s2,11a6 <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    118c:	94d6                	add	s1,s1,s5
    118e:	ff4497e3          	bne	s1,s4,117c <validatetest+0x28>
}
    1192:	70e2                	ld	ra,56(sp)
    1194:	7442                	ld	s0,48(sp)
    1196:	74a2                	ld	s1,40(sp)
    1198:	7902                	ld	s2,32(sp)
    119a:	69e2                	ld	s3,24(sp)
    119c:	6a42                	ld	s4,16(sp)
    119e:	6aa2                	ld	s5,8(sp)
    11a0:	6b02                	ld	s6,0(sp)
    11a2:	6121                	addi	sp,sp,64
    11a4:	8082                	ret
      printf("%s: link should not succeed\n", s);
    11a6:	85da                	mv	a1,s6
    11a8:	00005517          	auipc	a0,0x5
    11ac:	70050513          	addi	a0,a0,1792 # 68a8 <malloc+0x85e>
    11b0:	00005097          	auipc	ra,0x5
    11b4:	dda080e7          	jalr	-550(ra) # 5f8a <printf>
      exit(1);
    11b8:	4505                	li	a0,1
    11ba:	00005097          	auipc	ra,0x5
    11be:	a58080e7          	jalr	-1448(ra) # 5c12 <exit>

00000000000011c2 <bigdir>:
{
    11c2:	715d                	addi	sp,sp,-80
    11c4:	e486                	sd	ra,72(sp)
    11c6:	e0a2                	sd	s0,64(sp)
    11c8:	fc26                	sd	s1,56(sp)
    11ca:	f84a                	sd	s2,48(sp)
    11cc:	f44e                	sd	s3,40(sp)
    11ce:	f052                	sd	s4,32(sp)
    11d0:	ec56                	sd	s5,24(sp)
    11d2:	e85a                	sd	s6,16(sp)
    11d4:	0880                	addi	s0,sp,80
    11d6:	89aa                	mv	s3,a0
  unlink("bd");
    11d8:	00005517          	auipc	a0,0x5
    11dc:	6f050513          	addi	a0,a0,1776 # 68c8 <malloc+0x87e>
    11e0:	00005097          	auipc	ra,0x5
    11e4:	a82080e7          	jalr	-1406(ra) # 5c62 <unlink>
  fd = open("bd", O_CREATE);
    11e8:	20000593          	li	a1,512
    11ec:	00005517          	auipc	a0,0x5
    11f0:	6dc50513          	addi	a0,a0,1756 # 68c8 <malloc+0x87e>
    11f4:	00005097          	auipc	ra,0x5
    11f8:	a5e080e7          	jalr	-1442(ra) # 5c52 <open>
  if(fd < 0){
    11fc:	0c054963          	bltz	a0,12ce <bigdir+0x10c>
  close(fd);
    1200:	00005097          	auipc	ra,0x5
    1204:	a3a080e7          	jalr	-1478(ra) # 5c3a <close>
  for(i = 0; i < N; i++){
    1208:	4901                	li	s2,0
    name[0] = 'x';
    120a:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
    120e:	00005a17          	auipc	s4,0x5
    1212:	6baa0a13          	addi	s4,s4,1722 # 68c8 <malloc+0x87e>
  for(i = 0; i < N; i++){
    1216:	1f400b13          	li	s6,500
    name[0] = 'x';
    121a:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
    121e:	41f9579b          	sraiw	a5,s2,0x1f
    1222:	01a7d71b          	srliw	a4,a5,0x1a
    1226:	012707bb          	addw	a5,a4,s2
    122a:	4067d69b          	sraiw	a3,a5,0x6
    122e:	0306869b          	addiw	a3,a3,48
    1232:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1236:	03f7f793          	andi	a5,a5,63
    123a:	9f99                	subw	a5,a5,a4
    123c:	0307879b          	addiw	a5,a5,48
    1240:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1244:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
    1248:	fb040593          	addi	a1,s0,-80
    124c:	8552                	mv	a0,s4
    124e:	00005097          	auipc	ra,0x5
    1252:	a24080e7          	jalr	-1500(ra) # 5c72 <link>
    1256:	84aa                	mv	s1,a0
    1258:	e949                	bnez	a0,12ea <bigdir+0x128>
  for(i = 0; i < N; i++){
    125a:	2905                	addiw	s2,s2,1
    125c:	fb691fe3          	bne	s2,s6,121a <bigdir+0x58>
  unlink("bd");
    1260:	00005517          	auipc	a0,0x5
    1264:	66850513          	addi	a0,a0,1640 # 68c8 <malloc+0x87e>
    1268:	00005097          	auipc	ra,0x5
    126c:	9fa080e7          	jalr	-1542(ra) # 5c62 <unlink>
    name[0] = 'x';
    1270:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    1274:	1f400a13          	li	s4,500
    name[0] = 'x';
    1278:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    127c:	41f4d79b          	sraiw	a5,s1,0x1f
    1280:	01a7d71b          	srliw	a4,a5,0x1a
    1284:	009707bb          	addw	a5,a4,s1
    1288:	4067d69b          	sraiw	a3,a5,0x6
    128c:	0306869b          	addiw	a3,a3,48
    1290:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1294:	03f7f793          	andi	a5,a5,63
    1298:	9f99                	subw	a5,a5,a4
    129a:	0307879b          	addiw	a5,a5,48
    129e:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    12a2:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    12a6:	fb040513          	addi	a0,s0,-80
    12aa:	00005097          	auipc	ra,0x5
    12ae:	9b8080e7          	jalr	-1608(ra) # 5c62 <unlink>
    12b2:	ed21                	bnez	a0,130a <bigdir+0x148>
  for(i = 0; i < N; i++){
    12b4:	2485                	addiw	s1,s1,1
    12b6:	fd4491e3          	bne	s1,s4,1278 <bigdir+0xb6>
}
    12ba:	60a6                	ld	ra,72(sp)
    12bc:	6406                	ld	s0,64(sp)
    12be:	74e2                	ld	s1,56(sp)
    12c0:	7942                	ld	s2,48(sp)
    12c2:	79a2                	ld	s3,40(sp)
    12c4:	7a02                	ld	s4,32(sp)
    12c6:	6ae2                	ld	s5,24(sp)
    12c8:	6b42                	ld	s6,16(sp)
    12ca:	6161                	addi	sp,sp,80
    12cc:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    12ce:	85ce                	mv	a1,s3
    12d0:	00005517          	auipc	a0,0x5
    12d4:	60050513          	addi	a0,a0,1536 # 68d0 <malloc+0x886>
    12d8:	00005097          	auipc	ra,0x5
    12dc:	cb2080e7          	jalr	-846(ra) # 5f8a <printf>
    exit(1);
    12e0:	4505                	li	a0,1
    12e2:	00005097          	auipc	ra,0x5
    12e6:	930080e7          	jalr	-1744(ra) # 5c12 <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    12ea:	fb040613          	addi	a2,s0,-80
    12ee:	85ce                	mv	a1,s3
    12f0:	00005517          	auipc	a0,0x5
    12f4:	60050513          	addi	a0,a0,1536 # 68f0 <malloc+0x8a6>
    12f8:	00005097          	auipc	ra,0x5
    12fc:	c92080e7          	jalr	-878(ra) # 5f8a <printf>
      exit(1);
    1300:	4505                	li	a0,1
    1302:	00005097          	auipc	ra,0x5
    1306:	910080e7          	jalr	-1776(ra) # 5c12 <exit>
      printf("%s: bigdir unlink failed", s);
    130a:	85ce                	mv	a1,s3
    130c:	00005517          	auipc	a0,0x5
    1310:	60450513          	addi	a0,a0,1540 # 6910 <malloc+0x8c6>
    1314:	00005097          	auipc	ra,0x5
    1318:	c76080e7          	jalr	-906(ra) # 5f8a <printf>
      exit(1);
    131c:	4505                	li	a0,1
    131e:	00005097          	auipc	ra,0x5
    1322:	8f4080e7          	jalr	-1804(ra) # 5c12 <exit>

0000000000001326 <pgbug>:
{
    1326:	7179                	addi	sp,sp,-48
    1328:	f406                	sd	ra,40(sp)
    132a:	f022                	sd	s0,32(sp)
    132c:	ec26                	sd	s1,24(sp)
    132e:	1800                	addi	s0,sp,48
  argv[0] = 0;
    1330:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
    1334:	00008497          	auipc	s1,0x8
    1338:	ccc48493          	addi	s1,s1,-820 # 9000 <big>
    133c:	fd840593          	addi	a1,s0,-40
    1340:	6088                	ld	a0,0(s1)
    1342:	00005097          	auipc	ra,0x5
    1346:	908080e7          	jalr	-1784(ra) # 5c4a <exec>
  pipe(big);
    134a:	6088                	ld	a0,0(s1)
    134c:	00005097          	auipc	ra,0x5
    1350:	8d6080e7          	jalr	-1834(ra) # 5c22 <pipe>
  exit(0);
    1354:	4501                	li	a0,0
    1356:	00005097          	auipc	ra,0x5
    135a:	8bc080e7          	jalr	-1860(ra) # 5c12 <exit>

000000000000135e <badarg>:
{
    135e:	7139                	addi	sp,sp,-64
    1360:	fc06                	sd	ra,56(sp)
    1362:	f822                	sd	s0,48(sp)
    1364:	f426                	sd	s1,40(sp)
    1366:	f04a                	sd	s2,32(sp)
    1368:	ec4e                	sd	s3,24(sp)
    136a:	0080                	addi	s0,sp,64
    136c:	64b1                	lui	s1,0xc
    136e:	35048493          	addi	s1,s1,848 # c350 <uninit+0x1de8>
    argv[0] = (char*)0xffffffff;
    1372:	597d                	li	s2,-1
    1374:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    1378:	00005997          	auipc	s3,0x5
    137c:	e1098993          	addi	s3,s3,-496 # 6188 <malloc+0x13e>
    argv[0] = (char*)0xffffffff;
    1380:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1384:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    1388:	fc040593          	addi	a1,s0,-64
    138c:	854e                	mv	a0,s3
    138e:	00005097          	auipc	ra,0x5
    1392:	8bc080e7          	jalr	-1860(ra) # 5c4a <exec>
  for(int i = 0; i < 50000; i++){
    1396:	34fd                	addiw	s1,s1,-1
    1398:	f4e5                	bnez	s1,1380 <badarg+0x22>
  exit(0);
    139a:	4501                	li	a0,0
    139c:	00005097          	auipc	ra,0x5
    13a0:	876080e7          	jalr	-1930(ra) # 5c12 <exit>

00000000000013a4 <copyinstr2>:
{
    13a4:	7155                	addi	sp,sp,-208
    13a6:	e586                	sd	ra,200(sp)
    13a8:	e1a2                	sd	s0,192(sp)
    13aa:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    13ac:	f6840793          	addi	a5,s0,-152
    13b0:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    13b4:	07800713          	li	a4,120
    13b8:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    13bc:	0785                	addi	a5,a5,1
    13be:	fed79de3          	bne	a5,a3,13b8 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    13c2:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    13c6:	f6840513          	addi	a0,s0,-152
    13ca:	00005097          	auipc	ra,0x5
    13ce:	898080e7          	jalr	-1896(ra) # 5c62 <unlink>
  if(ret != -1){
    13d2:	57fd                	li	a5,-1
    13d4:	0ef51063          	bne	a0,a5,14b4 <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    13d8:	20100593          	li	a1,513
    13dc:	f6840513          	addi	a0,s0,-152
    13e0:	00005097          	auipc	ra,0x5
    13e4:	872080e7          	jalr	-1934(ra) # 5c52 <open>
  if(fd != -1){
    13e8:	57fd                	li	a5,-1
    13ea:	0ef51563          	bne	a0,a5,14d4 <copyinstr2+0x130>
  ret = link(b, b);
    13ee:	f6840593          	addi	a1,s0,-152
    13f2:	852e                	mv	a0,a1
    13f4:	00005097          	auipc	ra,0x5
    13f8:	87e080e7          	jalr	-1922(ra) # 5c72 <link>
  if(ret != -1){
    13fc:	57fd                	li	a5,-1
    13fe:	0ef51b63          	bne	a0,a5,14f4 <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    1402:	00006797          	auipc	a5,0x6
    1406:	76678793          	addi	a5,a5,1894 # 7b68 <malloc+0x1b1e>
    140a:	f4f43c23          	sd	a5,-168(s0)
    140e:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1412:	f5840593          	addi	a1,s0,-168
    1416:	f6840513          	addi	a0,s0,-152
    141a:	00005097          	auipc	ra,0x5
    141e:	830080e7          	jalr	-2000(ra) # 5c4a <exec>
  if(ret != -1){
    1422:	57fd                	li	a5,-1
    1424:	0ef51963          	bne	a0,a5,1516 <copyinstr2+0x172>
  int pid = fork();
    1428:	00004097          	auipc	ra,0x4
    142c:	7e2080e7          	jalr	2018(ra) # 5c0a <fork>
  if(pid < 0){
    1430:	10054363          	bltz	a0,1536 <copyinstr2+0x192>
  if(pid == 0){
    1434:	12051463          	bnez	a0,155c <copyinstr2+0x1b8>
    1438:	00008797          	auipc	a5,0x8
    143c:	12878793          	addi	a5,a5,296 # 9560 <big.1286>
    1440:	00009697          	auipc	a3,0x9
    1444:	12068693          	addi	a3,a3,288 # a560 <big.1286+0x1000>
      big[i] = 'x';
    1448:	07800713          	li	a4,120
    144c:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    1450:	0785                	addi	a5,a5,1
    1452:	fed79de3          	bne	a5,a3,144c <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    1456:	00009797          	auipc	a5,0x9
    145a:	10078523          	sb	zero,266(a5) # a560 <big.1286+0x1000>
    char *args2[] = { big, big, big, 0 };
    145e:	00005797          	auipc	a5,0x5
    1462:	cd278793          	addi	a5,a5,-814 # 6130 <malloc+0xe6>
    1466:	6390                	ld	a2,0(a5)
    1468:	6794                	ld	a3,8(a5)
    146a:	6b98                	ld	a4,16(a5)
    146c:	6f9c                	ld	a5,24(a5)
    146e:	f2c43823          	sd	a2,-208(s0)
    1472:	f2d43c23          	sd	a3,-200(s0)
    1476:	f4e43023          	sd	a4,-192(s0)
    147a:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    147e:	f3040593          	addi	a1,s0,-208
    1482:	00005517          	auipc	a0,0x5
    1486:	d0650513          	addi	a0,a0,-762 # 6188 <malloc+0x13e>
    148a:	00004097          	auipc	ra,0x4
    148e:	7c0080e7          	jalr	1984(ra) # 5c4a <exec>
    if(ret != -1){
    1492:	57fd                	li	a5,-1
    1494:	0af50e63          	beq	a0,a5,1550 <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    1498:	55fd                	li	a1,-1
    149a:	00005517          	auipc	a0,0x5
    149e:	51e50513          	addi	a0,a0,1310 # 69b8 <malloc+0x96e>
    14a2:	00005097          	auipc	ra,0x5
    14a6:	ae8080e7          	jalr	-1304(ra) # 5f8a <printf>
      exit(1);
    14aa:	4505                	li	a0,1
    14ac:	00004097          	auipc	ra,0x4
    14b0:	766080e7          	jalr	1894(ra) # 5c12 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    14b4:	862a                	mv	a2,a0
    14b6:	f6840593          	addi	a1,s0,-152
    14ba:	00005517          	auipc	a0,0x5
    14be:	47650513          	addi	a0,a0,1142 # 6930 <malloc+0x8e6>
    14c2:	00005097          	auipc	ra,0x5
    14c6:	ac8080e7          	jalr	-1336(ra) # 5f8a <printf>
    exit(1);
    14ca:	4505                	li	a0,1
    14cc:	00004097          	auipc	ra,0x4
    14d0:	746080e7          	jalr	1862(ra) # 5c12 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    14d4:	862a                	mv	a2,a0
    14d6:	f6840593          	addi	a1,s0,-152
    14da:	00005517          	auipc	a0,0x5
    14de:	47650513          	addi	a0,a0,1142 # 6950 <malloc+0x906>
    14e2:	00005097          	auipc	ra,0x5
    14e6:	aa8080e7          	jalr	-1368(ra) # 5f8a <printf>
    exit(1);
    14ea:	4505                	li	a0,1
    14ec:	00004097          	auipc	ra,0x4
    14f0:	726080e7          	jalr	1830(ra) # 5c12 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    14f4:	86aa                	mv	a3,a0
    14f6:	f6840613          	addi	a2,s0,-152
    14fa:	85b2                	mv	a1,a2
    14fc:	00005517          	auipc	a0,0x5
    1500:	47450513          	addi	a0,a0,1140 # 6970 <malloc+0x926>
    1504:	00005097          	auipc	ra,0x5
    1508:	a86080e7          	jalr	-1402(ra) # 5f8a <printf>
    exit(1);
    150c:	4505                	li	a0,1
    150e:	00004097          	auipc	ra,0x4
    1512:	704080e7          	jalr	1796(ra) # 5c12 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1516:	567d                	li	a2,-1
    1518:	f6840593          	addi	a1,s0,-152
    151c:	00005517          	auipc	a0,0x5
    1520:	47c50513          	addi	a0,a0,1148 # 6998 <malloc+0x94e>
    1524:	00005097          	auipc	ra,0x5
    1528:	a66080e7          	jalr	-1434(ra) # 5f8a <printf>
    exit(1);
    152c:	4505                	li	a0,1
    152e:	00004097          	auipc	ra,0x4
    1532:	6e4080e7          	jalr	1764(ra) # 5c12 <exit>
    printf("fork failed\n");
    1536:	00006517          	auipc	a0,0x6
    153a:	8e250513          	addi	a0,a0,-1822 # 6e18 <malloc+0xdce>
    153e:	00005097          	auipc	ra,0x5
    1542:	a4c080e7          	jalr	-1460(ra) # 5f8a <printf>
    exit(1);
    1546:	4505                	li	a0,1
    1548:	00004097          	auipc	ra,0x4
    154c:	6ca080e7          	jalr	1738(ra) # 5c12 <exit>
    exit(747); // OK
    1550:	2eb00513          	li	a0,747
    1554:	00004097          	auipc	ra,0x4
    1558:	6be080e7          	jalr	1726(ra) # 5c12 <exit>
  int st = 0;
    155c:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    1560:	f5440513          	addi	a0,s0,-172
    1564:	00004097          	auipc	ra,0x4
    1568:	6b6080e7          	jalr	1718(ra) # 5c1a <wait>
  if(st != 747){
    156c:	f5442703          	lw	a4,-172(s0)
    1570:	2eb00793          	li	a5,747
    1574:	00f71663          	bne	a4,a5,1580 <copyinstr2+0x1dc>
}
    1578:	60ae                	ld	ra,200(sp)
    157a:	640e                	ld	s0,192(sp)
    157c:	6169                	addi	sp,sp,208
    157e:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    1580:	00005517          	auipc	a0,0x5
    1584:	46050513          	addi	a0,a0,1120 # 69e0 <malloc+0x996>
    1588:	00005097          	auipc	ra,0x5
    158c:	a02080e7          	jalr	-1534(ra) # 5f8a <printf>
    exit(1);
    1590:	4505                	li	a0,1
    1592:	00004097          	auipc	ra,0x4
    1596:	680080e7          	jalr	1664(ra) # 5c12 <exit>

000000000000159a <truncate3>:
{
    159a:	7159                	addi	sp,sp,-112
    159c:	f486                	sd	ra,104(sp)
    159e:	f0a2                	sd	s0,96(sp)
    15a0:	eca6                	sd	s1,88(sp)
    15a2:	e8ca                	sd	s2,80(sp)
    15a4:	e4ce                	sd	s3,72(sp)
    15a6:	e0d2                	sd	s4,64(sp)
    15a8:	fc56                	sd	s5,56(sp)
    15aa:	1880                	addi	s0,sp,112
    15ac:	8a2a                	mv	s4,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    15ae:	60100593          	li	a1,1537
    15b2:	00005517          	auipc	a0,0x5
    15b6:	c2e50513          	addi	a0,a0,-978 # 61e0 <malloc+0x196>
    15ba:	00004097          	auipc	ra,0x4
    15be:	698080e7          	jalr	1688(ra) # 5c52 <open>
    15c2:	00004097          	auipc	ra,0x4
    15c6:	678080e7          	jalr	1656(ra) # 5c3a <close>
  pid = fork();
    15ca:	00004097          	auipc	ra,0x4
    15ce:	640080e7          	jalr	1600(ra) # 5c0a <fork>
  if(pid < 0){
    15d2:	08054063          	bltz	a0,1652 <truncate3+0xb8>
  if(pid == 0){
    15d6:	e969                	bnez	a0,16a8 <truncate3+0x10e>
    15d8:	06400913          	li	s2,100
      int fd = open("truncfile", O_WRONLY);
    15dc:	00005997          	auipc	s3,0x5
    15e0:	c0498993          	addi	s3,s3,-1020 # 61e0 <malloc+0x196>
      int n = write(fd, "1234567890", 10);
    15e4:	00005a97          	auipc	s5,0x5
    15e8:	45ca8a93          	addi	s5,s5,1116 # 6a40 <malloc+0x9f6>
      int fd = open("truncfile", O_WRONLY);
    15ec:	4585                	li	a1,1
    15ee:	854e                	mv	a0,s3
    15f0:	00004097          	auipc	ra,0x4
    15f4:	662080e7          	jalr	1634(ra) # 5c52 <open>
    15f8:	84aa                	mv	s1,a0
      if(fd < 0){
    15fa:	06054a63          	bltz	a0,166e <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    15fe:	4629                	li	a2,10
    1600:	85d6                	mv	a1,s5
    1602:	00004097          	auipc	ra,0x4
    1606:	630080e7          	jalr	1584(ra) # 5c32 <write>
      if(n != 10){
    160a:	47a9                	li	a5,10
    160c:	06f51f63          	bne	a0,a5,168a <truncate3+0xf0>
      close(fd);
    1610:	8526                	mv	a0,s1
    1612:	00004097          	auipc	ra,0x4
    1616:	628080e7          	jalr	1576(ra) # 5c3a <close>
      fd = open("truncfile", O_RDONLY);
    161a:	4581                	li	a1,0
    161c:	854e                	mv	a0,s3
    161e:	00004097          	auipc	ra,0x4
    1622:	634080e7          	jalr	1588(ra) # 5c52 <open>
    1626:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1628:	02000613          	li	a2,32
    162c:	f9840593          	addi	a1,s0,-104
    1630:	00004097          	auipc	ra,0x4
    1634:	5fa080e7          	jalr	1530(ra) # 5c2a <read>
      close(fd);
    1638:	8526                	mv	a0,s1
    163a:	00004097          	auipc	ra,0x4
    163e:	600080e7          	jalr	1536(ra) # 5c3a <close>
    for(int i = 0; i < 100; i++){
    1642:	397d                	addiw	s2,s2,-1
    1644:	fa0914e3          	bnez	s2,15ec <truncate3+0x52>
    exit(0);
    1648:	4501                	li	a0,0
    164a:	00004097          	auipc	ra,0x4
    164e:	5c8080e7          	jalr	1480(ra) # 5c12 <exit>
    printf("%s: fork failed\n", s);
    1652:	85d2                	mv	a1,s4
    1654:	00005517          	auipc	a0,0x5
    1658:	3bc50513          	addi	a0,a0,956 # 6a10 <malloc+0x9c6>
    165c:	00005097          	auipc	ra,0x5
    1660:	92e080e7          	jalr	-1746(ra) # 5f8a <printf>
    exit(1);
    1664:	4505                	li	a0,1
    1666:	00004097          	auipc	ra,0x4
    166a:	5ac080e7          	jalr	1452(ra) # 5c12 <exit>
        printf("%s: open failed\n", s);
    166e:	85d2                	mv	a1,s4
    1670:	00005517          	auipc	a0,0x5
    1674:	3b850513          	addi	a0,a0,952 # 6a28 <malloc+0x9de>
    1678:	00005097          	auipc	ra,0x5
    167c:	912080e7          	jalr	-1774(ra) # 5f8a <printf>
        exit(1);
    1680:	4505                	li	a0,1
    1682:	00004097          	auipc	ra,0x4
    1686:	590080e7          	jalr	1424(ra) # 5c12 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    168a:	862a                	mv	a2,a0
    168c:	85d2                	mv	a1,s4
    168e:	00005517          	auipc	a0,0x5
    1692:	3c250513          	addi	a0,a0,962 # 6a50 <malloc+0xa06>
    1696:	00005097          	auipc	ra,0x5
    169a:	8f4080e7          	jalr	-1804(ra) # 5f8a <printf>
        exit(1);
    169e:	4505                	li	a0,1
    16a0:	00004097          	auipc	ra,0x4
    16a4:	572080e7          	jalr	1394(ra) # 5c12 <exit>
    16a8:	09600913          	li	s2,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    16ac:	00005997          	auipc	s3,0x5
    16b0:	b3498993          	addi	s3,s3,-1228 # 61e0 <malloc+0x196>
    int n = write(fd, "xxx", 3);
    16b4:	00005a97          	auipc	s5,0x5
    16b8:	3bca8a93          	addi	s5,s5,956 # 6a70 <malloc+0xa26>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    16bc:	60100593          	li	a1,1537
    16c0:	854e                	mv	a0,s3
    16c2:	00004097          	auipc	ra,0x4
    16c6:	590080e7          	jalr	1424(ra) # 5c52 <open>
    16ca:	84aa                	mv	s1,a0
    if(fd < 0){
    16cc:	04054763          	bltz	a0,171a <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    16d0:	460d                	li	a2,3
    16d2:	85d6                	mv	a1,s5
    16d4:	00004097          	auipc	ra,0x4
    16d8:	55e080e7          	jalr	1374(ra) # 5c32 <write>
    if(n != 3){
    16dc:	478d                	li	a5,3
    16de:	04f51c63          	bne	a0,a5,1736 <truncate3+0x19c>
    close(fd);
    16e2:	8526                	mv	a0,s1
    16e4:	00004097          	auipc	ra,0x4
    16e8:	556080e7          	jalr	1366(ra) # 5c3a <close>
  for(int i = 0; i < 150; i++){
    16ec:	397d                	addiw	s2,s2,-1
    16ee:	fc0917e3          	bnez	s2,16bc <truncate3+0x122>
  wait(&xstatus);
    16f2:	fbc40513          	addi	a0,s0,-68
    16f6:	00004097          	auipc	ra,0x4
    16fa:	524080e7          	jalr	1316(ra) # 5c1a <wait>
  unlink("truncfile");
    16fe:	00005517          	auipc	a0,0x5
    1702:	ae250513          	addi	a0,a0,-1310 # 61e0 <malloc+0x196>
    1706:	00004097          	auipc	ra,0x4
    170a:	55c080e7          	jalr	1372(ra) # 5c62 <unlink>
  exit(xstatus);
    170e:	fbc42503          	lw	a0,-68(s0)
    1712:	00004097          	auipc	ra,0x4
    1716:	500080e7          	jalr	1280(ra) # 5c12 <exit>
      printf("%s: open failed\n", s);
    171a:	85d2                	mv	a1,s4
    171c:	00005517          	auipc	a0,0x5
    1720:	30c50513          	addi	a0,a0,780 # 6a28 <malloc+0x9de>
    1724:	00005097          	auipc	ra,0x5
    1728:	866080e7          	jalr	-1946(ra) # 5f8a <printf>
      exit(1);
    172c:	4505                	li	a0,1
    172e:	00004097          	auipc	ra,0x4
    1732:	4e4080e7          	jalr	1252(ra) # 5c12 <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    1736:	862a                	mv	a2,a0
    1738:	85d2                	mv	a1,s4
    173a:	00005517          	auipc	a0,0x5
    173e:	33e50513          	addi	a0,a0,830 # 6a78 <malloc+0xa2e>
    1742:	00005097          	auipc	ra,0x5
    1746:	848080e7          	jalr	-1976(ra) # 5f8a <printf>
      exit(1);
    174a:	4505                	li	a0,1
    174c:	00004097          	auipc	ra,0x4
    1750:	4c6080e7          	jalr	1222(ra) # 5c12 <exit>

0000000000001754 <exectest>:
{
    1754:	715d                	addi	sp,sp,-80
    1756:	e486                	sd	ra,72(sp)
    1758:	e0a2                	sd	s0,64(sp)
    175a:	fc26                	sd	s1,56(sp)
    175c:	f84a                	sd	s2,48(sp)
    175e:	0880                	addi	s0,sp,80
    1760:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    1762:	00005797          	auipc	a5,0x5
    1766:	a2678793          	addi	a5,a5,-1498 # 6188 <malloc+0x13e>
    176a:	fcf43023          	sd	a5,-64(s0)
    176e:	00005797          	auipc	a5,0x5
    1772:	32a78793          	addi	a5,a5,810 # 6a98 <malloc+0xa4e>
    1776:	fcf43423          	sd	a5,-56(s0)
    177a:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    177e:	00005517          	auipc	a0,0x5
    1782:	32250513          	addi	a0,a0,802 # 6aa0 <malloc+0xa56>
    1786:	00004097          	auipc	ra,0x4
    178a:	4dc080e7          	jalr	1244(ra) # 5c62 <unlink>
  pid = fork();
    178e:	00004097          	auipc	ra,0x4
    1792:	47c080e7          	jalr	1148(ra) # 5c0a <fork>
  if(pid < 0) {
    1796:	04054663          	bltz	a0,17e2 <exectest+0x8e>
    179a:	84aa                	mv	s1,a0
  if(pid == 0) {
    179c:	e959                	bnez	a0,1832 <exectest+0xde>
    close(1);
    179e:	4505                	li	a0,1
    17a0:	00004097          	auipc	ra,0x4
    17a4:	49a080e7          	jalr	1178(ra) # 5c3a <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    17a8:	20100593          	li	a1,513
    17ac:	00005517          	auipc	a0,0x5
    17b0:	2f450513          	addi	a0,a0,756 # 6aa0 <malloc+0xa56>
    17b4:	00004097          	auipc	ra,0x4
    17b8:	49e080e7          	jalr	1182(ra) # 5c52 <open>
    if(fd < 0) {
    17bc:	04054163          	bltz	a0,17fe <exectest+0xaa>
    if(fd != 1) {
    17c0:	4785                	li	a5,1
    17c2:	04f50c63          	beq	a0,a5,181a <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    17c6:	85ca                	mv	a1,s2
    17c8:	00005517          	auipc	a0,0x5
    17cc:	2f850513          	addi	a0,a0,760 # 6ac0 <malloc+0xa76>
    17d0:	00004097          	auipc	ra,0x4
    17d4:	7ba080e7          	jalr	1978(ra) # 5f8a <printf>
      exit(1);
    17d8:	4505                	li	a0,1
    17da:	00004097          	auipc	ra,0x4
    17de:	438080e7          	jalr	1080(ra) # 5c12 <exit>
     printf("%s: fork failed\n", s);
    17e2:	85ca                	mv	a1,s2
    17e4:	00005517          	auipc	a0,0x5
    17e8:	22c50513          	addi	a0,a0,556 # 6a10 <malloc+0x9c6>
    17ec:	00004097          	auipc	ra,0x4
    17f0:	79e080e7          	jalr	1950(ra) # 5f8a <printf>
     exit(1);
    17f4:	4505                	li	a0,1
    17f6:	00004097          	auipc	ra,0x4
    17fa:	41c080e7          	jalr	1052(ra) # 5c12 <exit>
      printf("%s: create failed\n", s);
    17fe:	85ca                	mv	a1,s2
    1800:	00005517          	auipc	a0,0x5
    1804:	2a850513          	addi	a0,a0,680 # 6aa8 <malloc+0xa5e>
    1808:	00004097          	auipc	ra,0x4
    180c:	782080e7          	jalr	1922(ra) # 5f8a <printf>
      exit(1);
    1810:	4505                	li	a0,1
    1812:	00004097          	auipc	ra,0x4
    1816:	400080e7          	jalr	1024(ra) # 5c12 <exit>
    if(exec("echo", echoargv) < 0){
    181a:	fc040593          	addi	a1,s0,-64
    181e:	00005517          	auipc	a0,0x5
    1822:	96a50513          	addi	a0,a0,-1686 # 6188 <malloc+0x13e>
    1826:	00004097          	auipc	ra,0x4
    182a:	424080e7          	jalr	1060(ra) # 5c4a <exec>
    182e:	02054163          	bltz	a0,1850 <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    1832:	fdc40513          	addi	a0,s0,-36
    1836:	00004097          	auipc	ra,0x4
    183a:	3e4080e7          	jalr	996(ra) # 5c1a <wait>
    183e:	02951763          	bne	a0,s1,186c <exectest+0x118>
  if(xstatus != 0)
    1842:	fdc42503          	lw	a0,-36(s0)
    1846:	cd0d                	beqz	a0,1880 <exectest+0x12c>
    exit(xstatus);
    1848:	00004097          	auipc	ra,0x4
    184c:	3ca080e7          	jalr	970(ra) # 5c12 <exit>
      printf("%s: exec echo failed\n", s);
    1850:	85ca                	mv	a1,s2
    1852:	00005517          	auipc	a0,0x5
    1856:	27e50513          	addi	a0,a0,638 # 6ad0 <malloc+0xa86>
    185a:	00004097          	auipc	ra,0x4
    185e:	730080e7          	jalr	1840(ra) # 5f8a <printf>
      exit(1);
    1862:	4505                	li	a0,1
    1864:	00004097          	auipc	ra,0x4
    1868:	3ae080e7          	jalr	942(ra) # 5c12 <exit>
    printf("%s: wait failed!\n", s);
    186c:	85ca                	mv	a1,s2
    186e:	00005517          	auipc	a0,0x5
    1872:	27a50513          	addi	a0,a0,634 # 6ae8 <malloc+0xa9e>
    1876:	00004097          	auipc	ra,0x4
    187a:	714080e7          	jalr	1812(ra) # 5f8a <printf>
    187e:	b7d1                	j	1842 <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    1880:	4581                	li	a1,0
    1882:	00005517          	auipc	a0,0x5
    1886:	21e50513          	addi	a0,a0,542 # 6aa0 <malloc+0xa56>
    188a:	00004097          	auipc	ra,0x4
    188e:	3c8080e7          	jalr	968(ra) # 5c52 <open>
  if(fd < 0) {
    1892:	02054a63          	bltz	a0,18c6 <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    1896:	4609                	li	a2,2
    1898:	fb840593          	addi	a1,s0,-72
    189c:	00004097          	auipc	ra,0x4
    18a0:	38e080e7          	jalr	910(ra) # 5c2a <read>
    18a4:	4789                	li	a5,2
    18a6:	02f50e63          	beq	a0,a5,18e2 <exectest+0x18e>
    printf("%s: read failed\n", s);
    18aa:	85ca                	mv	a1,s2
    18ac:	00005517          	auipc	a0,0x5
    18b0:	cac50513          	addi	a0,a0,-852 # 6558 <malloc+0x50e>
    18b4:	00004097          	auipc	ra,0x4
    18b8:	6d6080e7          	jalr	1750(ra) # 5f8a <printf>
    exit(1);
    18bc:	4505                	li	a0,1
    18be:	00004097          	auipc	ra,0x4
    18c2:	354080e7          	jalr	852(ra) # 5c12 <exit>
    printf("%s: open failed\n", s);
    18c6:	85ca                	mv	a1,s2
    18c8:	00005517          	auipc	a0,0x5
    18cc:	16050513          	addi	a0,a0,352 # 6a28 <malloc+0x9de>
    18d0:	00004097          	auipc	ra,0x4
    18d4:	6ba080e7          	jalr	1722(ra) # 5f8a <printf>
    exit(1);
    18d8:	4505                	li	a0,1
    18da:	00004097          	auipc	ra,0x4
    18de:	338080e7          	jalr	824(ra) # 5c12 <exit>
  unlink("echo-ok");
    18e2:	00005517          	auipc	a0,0x5
    18e6:	1be50513          	addi	a0,a0,446 # 6aa0 <malloc+0xa56>
    18ea:	00004097          	auipc	ra,0x4
    18ee:	378080e7          	jalr	888(ra) # 5c62 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    18f2:	fb844703          	lbu	a4,-72(s0)
    18f6:	04f00793          	li	a5,79
    18fa:	00f71863          	bne	a4,a5,190a <exectest+0x1b6>
    18fe:	fb944703          	lbu	a4,-71(s0)
    1902:	04b00793          	li	a5,75
    1906:	02f70063          	beq	a4,a5,1926 <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    190a:	85ca                	mv	a1,s2
    190c:	00005517          	auipc	a0,0x5
    1910:	1f450513          	addi	a0,a0,500 # 6b00 <malloc+0xab6>
    1914:	00004097          	auipc	ra,0x4
    1918:	676080e7          	jalr	1654(ra) # 5f8a <printf>
    exit(1);
    191c:	4505                	li	a0,1
    191e:	00004097          	auipc	ra,0x4
    1922:	2f4080e7          	jalr	756(ra) # 5c12 <exit>
    exit(0);
    1926:	4501                	li	a0,0
    1928:	00004097          	auipc	ra,0x4
    192c:	2ea080e7          	jalr	746(ra) # 5c12 <exit>

0000000000001930 <pipe1>:
{
    1930:	715d                	addi	sp,sp,-80
    1932:	e486                	sd	ra,72(sp)
    1934:	e0a2                	sd	s0,64(sp)
    1936:	fc26                	sd	s1,56(sp)
    1938:	f84a                	sd	s2,48(sp)
    193a:	f44e                	sd	s3,40(sp)
    193c:	f052                	sd	s4,32(sp)
    193e:	ec56                	sd	s5,24(sp)
    1940:	e85a                	sd	s6,16(sp)
    1942:	0880                	addi	s0,sp,80
    1944:	89aa                	mv	s3,a0
  if(pipe(fds) != 0){
    1946:	fb840513          	addi	a0,s0,-72
    194a:	00004097          	auipc	ra,0x4
    194e:	2d8080e7          	jalr	728(ra) # 5c22 <pipe>
    1952:	e935                	bnez	a0,19c6 <pipe1+0x96>
    1954:	84aa                	mv	s1,a0
  pid = fork();
    1956:	00004097          	auipc	ra,0x4
    195a:	2b4080e7          	jalr	692(ra) # 5c0a <fork>
  if(pid == 0){
    195e:	c151                	beqz	a0,19e2 <pipe1+0xb2>
  } else if(pid > 0){
    1960:	18a05963          	blez	a0,1af2 <pipe1+0x1c2>
    close(fds[1]);
    1964:	fbc42503          	lw	a0,-68(s0)
    1968:	00004097          	auipc	ra,0x4
    196c:	2d2080e7          	jalr	722(ra) # 5c3a <close>
    total = 0;
    1970:	8aa6                	mv	s5,s1
    cc = 1;
    1972:	4a05                	li	s4,1
    while((n = read(fds[0], buf, cc)) > 0){
    1974:	0000b917          	auipc	s2,0xb
    1978:	30490913          	addi	s2,s2,772 # cc78 <buf>
      if(cc > sizeof(buf))
    197c:	6b0d                	lui	s6,0x3
    while((n = read(fds[0], buf, cc)) > 0){
    197e:	8652                	mv	a2,s4
    1980:	85ca                	mv	a1,s2
    1982:	fb842503          	lw	a0,-72(s0)
    1986:	00004097          	auipc	ra,0x4
    198a:	2a4080e7          	jalr	676(ra) # 5c2a <read>
    198e:	10a05d63          	blez	a0,1aa8 <pipe1+0x178>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    1992:	0014879b          	addiw	a5,s1,1
    1996:	00094683          	lbu	a3,0(s2)
    199a:	0ff4f713          	andi	a4,s1,255
    199e:	0ce69863          	bne	a3,a4,1a6e <pipe1+0x13e>
    19a2:	0000b717          	auipc	a4,0xb
    19a6:	2d770713          	addi	a4,a4,727 # cc79 <buf+0x1>
    19aa:	9ca9                	addw	s1,s1,a0
      for(i = 0; i < n; i++){
    19ac:	0e978463          	beq	a5,s1,1a94 <pipe1+0x164>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    19b0:	00074683          	lbu	a3,0(a4)
    19b4:	0017861b          	addiw	a2,a5,1
    19b8:	0705                	addi	a4,a4,1
    19ba:	0ff7f793          	andi	a5,a5,255
    19be:	0af69863          	bne	a3,a5,1a6e <pipe1+0x13e>
    19c2:	87b2                	mv	a5,a2
    19c4:	b7e5                	j	19ac <pipe1+0x7c>
    printf("%s: pipe() failed\n", s);
    19c6:	85ce                	mv	a1,s3
    19c8:	00005517          	auipc	a0,0x5
    19cc:	15050513          	addi	a0,a0,336 # 6b18 <malloc+0xace>
    19d0:	00004097          	auipc	ra,0x4
    19d4:	5ba080e7          	jalr	1466(ra) # 5f8a <printf>
    exit(1);
    19d8:	4505                	li	a0,1
    19da:	00004097          	auipc	ra,0x4
    19de:	238080e7          	jalr	568(ra) # 5c12 <exit>
    close(fds[0]);
    19e2:	fb842503          	lw	a0,-72(s0)
    19e6:	00004097          	auipc	ra,0x4
    19ea:	254080e7          	jalr	596(ra) # 5c3a <close>
    for(n = 0; n < N; n++){
    19ee:	0000ba97          	auipc	s5,0xb
    19f2:	28aa8a93          	addi	s5,s5,650 # cc78 <buf>
    19f6:	0ffaf793          	andi	a5,s5,255
    19fa:	40f004b3          	neg	s1,a5
    19fe:	0ff4f493          	andi	s1,s1,255
    1a02:	02d00a13          	li	s4,45
    1a06:	40fa0a3b          	subw	s4,s4,a5
    1a0a:	0ffa7a13          	andi	s4,s4,255
    1a0e:	409a8913          	addi	s2,s5,1033
      if(write(fds[1], buf, SZ) != SZ){
    1a12:	8b56                	mv	s6,s5
{
    1a14:	87d6                	mv	a5,s5
        buf[i] = seq++;
    1a16:	0097873b          	addw	a4,a5,s1
    1a1a:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1a1e:	0785                	addi	a5,a5,1
    1a20:	fef91be3          	bne	s2,a5,1a16 <pipe1+0xe6>
      if(write(fds[1], buf, SZ) != SZ){
    1a24:	40900613          	li	a2,1033
    1a28:	85da                	mv	a1,s6
    1a2a:	fbc42503          	lw	a0,-68(s0)
    1a2e:	00004097          	auipc	ra,0x4
    1a32:	204080e7          	jalr	516(ra) # 5c32 <write>
    1a36:	40900793          	li	a5,1033
    1a3a:	00f51c63          	bne	a0,a5,1a52 <pipe1+0x122>
    for(n = 0; n < N; n++){
    1a3e:	24a5                	addiw	s1,s1,9
    1a40:	0ff4f493          	andi	s1,s1,255
    1a44:	fd4498e3          	bne	s1,s4,1a14 <pipe1+0xe4>
    exit(0);
    1a48:	4501                	li	a0,0
    1a4a:	00004097          	auipc	ra,0x4
    1a4e:	1c8080e7          	jalr	456(ra) # 5c12 <exit>
        printf("%s: pipe1 oops 1\n", s);
    1a52:	85ce                	mv	a1,s3
    1a54:	00005517          	auipc	a0,0x5
    1a58:	0dc50513          	addi	a0,a0,220 # 6b30 <malloc+0xae6>
    1a5c:	00004097          	auipc	ra,0x4
    1a60:	52e080e7          	jalr	1326(ra) # 5f8a <printf>
        exit(1);
    1a64:	4505                	li	a0,1
    1a66:	00004097          	auipc	ra,0x4
    1a6a:	1ac080e7          	jalr	428(ra) # 5c12 <exit>
          printf("%s: pipe1 oops 2\n", s);
    1a6e:	85ce                	mv	a1,s3
    1a70:	00005517          	auipc	a0,0x5
    1a74:	0d850513          	addi	a0,a0,216 # 6b48 <malloc+0xafe>
    1a78:	00004097          	auipc	ra,0x4
    1a7c:	512080e7          	jalr	1298(ra) # 5f8a <printf>
}
    1a80:	60a6                	ld	ra,72(sp)
    1a82:	6406                	ld	s0,64(sp)
    1a84:	74e2                	ld	s1,56(sp)
    1a86:	7942                	ld	s2,48(sp)
    1a88:	79a2                	ld	s3,40(sp)
    1a8a:	7a02                	ld	s4,32(sp)
    1a8c:	6ae2                	ld	s5,24(sp)
    1a8e:	6b42                	ld	s6,16(sp)
    1a90:	6161                	addi	sp,sp,80
    1a92:	8082                	ret
      total += n;
    1a94:	00aa8abb          	addw	s5,s5,a0
      cc = cc * 2;
    1a98:	001a179b          	slliw	a5,s4,0x1
    1a9c:	00078a1b          	sext.w	s4,a5
      if(cc > sizeof(buf))
    1aa0:	ed4b7fe3          	bgeu	s6,s4,197e <pipe1+0x4e>
        cc = sizeof(buf);
    1aa4:	8a5a                	mv	s4,s6
    1aa6:	bde1                	j	197e <pipe1+0x4e>
    if(total != N * SZ){
    1aa8:	6785                	lui	a5,0x1
    1aaa:	42d78793          	addi	a5,a5,1069 # 142d <copyinstr2+0x89>
    1aae:	02fa8063          	beq	s5,a5,1ace <pipe1+0x19e>
      printf("%s: pipe1 oops 3 total %d\n", total);
    1ab2:	85d6                	mv	a1,s5
    1ab4:	00005517          	auipc	a0,0x5
    1ab8:	0ac50513          	addi	a0,a0,172 # 6b60 <malloc+0xb16>
    1abc:	00004097          	auipc	ra,0x4
    1ac0:	4ce080e7          	jalr	1230(ra) # 5f8a <printf>
      exit(1);
    1ac4:	4505                	li	a0,1
    1ac6:	00004097          	auipc	ra,0x4
    1aca:	14c080e7          	jalr	332(ra) # 5c12 <exit>
    close(fds[0]);
    1ace:	fb842503          	lw	a0,-72(s0)
    1ad2:	00004097          	auipc	ra,0x4
    1ad6:	168080e7          	jalr	360(ra) # 5c3a <close>
    wait(&xstatus);
    1ada:	fb440513          	addi	a0,s0,-76
    1ade:	00004097          	auipc	ra,0x4
    1ae2:	13c080e7          	jalr	316(ra) # 5c1a <wait>
    exit(xstatus);
    1ae6:	fb442503          	lw	a0,-76(s0)
    1aea:	00004097          	auipc	ra,0x4
    1aee:	128080e7          	jalr	296(ra) # 5c12 <exit>
    printf("%s: fork() failed\n", s);
    1af2:	85ce                	mv	a1,s3
    1af4:	00005517          	auipc	a0,0x5
    1af8:	08c50513          	addi	a0,a0,140 # 6b80 <malloc+0xb36>
    1afc:	00004097          	auipc	ra,0x4
    1b00:	48e080e7          	jalr	1166(ra) # 5f8a <printf>
    exit(1);
    1b04:	4505                	li	a0,1
    1b06:	00004097          	auipc	ra,0x4
    1b0a:	10c080e7          	jalr	268(ra) # 5c12 <exit>

0000000000001b0e <exitwait>:
{
    1b0e:	7139                	addi	sp,sp,-64
    1b10:	fc06                	sd	ra,56(sp)
    1b12:	f822                	sd	s0,48(sp)
    1b14:	f426                	sd	s1,40(sp)
    1b16:	f04a                	sd	s2,32(sp)
    1b18:	ec4e                	sd	s3,24(sp)
    1b1a:	e852                	sd	s4,16(sp)
    1b1c:	0080                	addi	s0,sp,64
    1b1e:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1b20:	4481                	li	s1,0
    1b22:	06400993          	li	s3,100
    pid = fork();
    1b26:	00004097          	auipc	ra,0x4
    1b2a:	0e4080e7          	jalr	228(ra) # 5c0a <fork>
    1b2e:	892a                	mv	s2,a0
    if(pid < 0){
    1b30:	02054a63          	bltz	a0,1b64 <exitwait+0x56>
    if(pid){
    1b34:	c151                	beqz	a0,1bb8 <exitwait+0xaa>
      if(wait(&xstate) != pid){
    1b36:	fcc40513          	addi	a0,s0,-52
    1b3a:	00004097          	auipc	ra,0x4
    1b3e:	0e0080e7          	jalr	224(ra) # 5c1a <wait>
    1b42:	03251f63          	bne	a0,s2,1b80 <exitwait+0x72>
      if(i != xstate) {
    1b46:	fcc42783          	lw	a5,-52(s0)
    1b4a:	04979963          	bne	a5,s1,1b9c <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    1b4e:	2485                	addiw	s1,s1,1
    1b50:	fd349be3          	bne	s1,s3,1b26 <exitwait+0x18>
}
    1b54:	70e2                	ld	ra,56(sp)
    1b56:	7442                	ld	s0,48(sp)
    1b58:	74a2                	ld	s1,40(sp)
    1b5a:	7902                	ld	s2,32(sp)
    1b5c:	69e2                	ld	s3,24(sp)
    1b5e:	6a42                	ld	s4,16(sp)
    1b60:	6121                	addi	sp,sp,64
    1b62:	8082                	ret
      printf("%s: fork failed\n", s);
    1b64:	85d2                	mv	a1,s4
    1b66:	00005517          	auipc	a0,0x5
    1b6a:	eaa50513          	addi	a0,a0,-342 # 6a10 <malloc+0x9c6>
    1b6e:	00004097          	auipc	ra,0x4
    1b72:	41c080e7          	jalr	1052(ra) # 5f8a <printf>
      exit(1);
    1b76:	4505                	li	a0,1
    1b78:	00004097          	auipc	ra,0x4
    1b7c:	09a080e7          	jalr	154(ra) # 5c12 <exit>
        printf("%s: wait wrong pid\n", s);
    1b80:	85d2                	mv	a1,s4
    1b82:	00005517          	auipc	a0,0x5
    1b86:	01650513          	addi	a0,a0,22 # 6b98 <malloc+0xb4e>
    1b8a:	00004097          	auipc	ra,0x4
    1b8e:	400080e7          	jalr	1024(ra) # 5f8a <printf>
        exit(1);
    1b92:	4505                	li	a0,1
    1b94:	00004097          	auipc	ra,0x4
    1b98:	07e080e7          	jalr	126(ra) # 5c12 <exit>
        printf("%s: wait wrong exit status\n", s);
    1b9c:	85d2                	mv	a1,s4
    1b9e:	00005517          	auipc	a0,0x5
    1ba2:	01250513          	addi	a0,a0,18 # 6bb0 <malloc+0xb66>
    1ba6:	00004097          	auipc	ra,0x4
    1baa:	3e4080e7          	jalr	996(ra) # 5f8a <printf>
        exit(1);
    1bae:	4505                	li	a0,1
    1bb0:	00004097          	auipc	ra,0x4
    1bb4:	062080e7          	jalr	98(ra) # 5c12 <exit>
      exit(i);
    1bb8:	8526                	mv	a0,s1
    1bba:	00004097          	auipc	ra,0x4
    1bbe:	058080e7          	jalr	88(ra) # 5c12 <exit>

0000000000001bc2 <twochildren>:
{
    1bc2:	1101                	addi	sp,sp,-32
    1bc4:	ec06                	sd	ra,24(sp)
    1bc6:	e822                	sd	s0,16(sp)
    1bc8:	e426                	sd	s1,8(sp)
    1bca:	e04a                	sd	s2,0(sp)
    1bcc:	1000                	addi	s0,sp,32
    1bce:	892a                	mv	s2,a0
    1bd0:	3e800493          	li	s1,1000
    int pid1 = fork();
    1bd4:	00004097          	auipc	ra,0x4
    1bd8:	036080e7          	jalr	54(ra) # 5c0a <fork>
    if(pid1 < 0){
    1bdc:	02054c63          	bltz	a0,1c14 <twochildren+0x52>
    if(pid1 == 0){
    1be0:	c921                	beqz	a0,1c30 <twochildren+0x6e>
      int pid2 = fork();
    1be2:	00004097          	auipc	ra,0x4
    1be6:	028080e7          	jalr	40(ra) # 5c0a <fork>
      if(pid2 < 0){
    1bea:	04054763          	bltz	a0,1c38 <twochildren+0x76>
      if(pid2 == 0){
    1bee:	c13d                	beqz	a0,1c54 <twochildren+0x92>
        wait(0);
    1bf0:	4501                	li	a0,0
    1bf2:	00004097          	auipc	ra,0x4
    1bf6:	028080e7          	jalr	40(ra) # 5c1a <wait>
        wait(0);
    1bfa:	4501                	li	a0,0
    1bfc:	00004097          	auipc	ra,0x4
    1c00:	01e080e7          	jalr	30(ra) # 5c1a <wait>
  for(int i = 0; i < 1000; i++){
    1c04:	34fd                	addiw	s1,s1,-1
    1c06:	f4f9                	bnez	s1,1bd4 <twochildren+0x12>
}
    1c08:	60e2                	ld	ra,24(sp)
    1c0a:	6442                	ld	s0,16(sp)
    1c0c:	64a2                	ld	s1,8(sp)
    1c0e:	6902                	ld	s2,0(sp)
    1c10:	6105                	addi	sp,sp,32
    1c12:	8082                	ret
      printf("%s: fork failed\n", s);
    1c14:	85ca                	mv	a1,s2
    1c16:	00005517          	auipc	a0,0x5
    1c1a:	dfa50513          	addi	a0,a0,-518 # 6a10 <malloc+0x9c6>
    1c1e:	00004097          	auipc	ra,0x4
    1c22:	36c080e7          	jalr	876(ra) # 5f8a <printf>
      exit(1);
    1c26:	4505                	li	a0,1
    1c28:	00004097          	auipc	ra,0x4
    1c2c:	fea080e7          	jalr	-22(ra) # 5c12 <exit>
      exit(0);
    1c30:	00004097          	auipc	ra,0x4
    1c34:	fe2080e7          	jalr	-30(ra) # 5c12 <exit>
        printf("%s: fork failed\n", s);
    1c38:	85ca                	mv	a1,s2
    1c3a:	00005517          	auipc	a0,0x5
    1c3e:	dd650513          	addi	a0,a0,-554 # 6a10 <malloc+0x9c6>
    1c42:	00004097          	auipc	ra,0x4
    1c46:	348080e7          	jalr	840(ra) # 5f8a <printf>
        exit(1);
    1c4a:	4505                	li	a0,1
    1c4c:	00004097          	auipc	ra,0x4
    1c50:	fc6080e7          	jalr	-58(ra) # 5c12 <exit>
        exit(0);
    1c54:	00004097          	auipc	ra,0x4
    1c58:	fbe080e7          	jalr	-66(ra) # 5c12 <exit>

0000000000001c5c <forkfork>:
{
    1c5c:	7179                	addi	sp,sp,-48
    1c5e:	f406                	sd	ra,40(sp)
    1c60:	f022                	sd	s0,32(sp)
    1c62:	ec26                	sd	s1,24(sp)
    1c64:	1800                	addi	s0,sp,48
    1c66:	84aa                	mv	s1,a0
    int pid = fork();
    1c68:	00004097          	auipc	ra,0x4
    1c6c:	fa2080e7          	jalr	-94(ra) # 5c0a <fork>
    if(pid < 0){
    1c70:	04054163          	bltz	a0,1cb2 <forkfork+0x56>
    if(pid == 0){
    1c74:	cd29                	beqz	a0,1cce <forkfork+0x72>
    int pid = fork();
    1c76:	00004097          	auipc	ra,0x4
    1c7a:	f94080e7          	jalr	-108(ra) # 5c0a <fork>
    if(pid < 0){
    1c7e:	02054a63          	bltz	a0,1cb2 <forkfork+0x56>
    if(pid == 0){
    1c82:	c531                	beqz	a0,1cce <forkfork+0x72>
    wait(&xstatus);
    1c84:	fdc40513          	addi	a0,s0,-36
    1c88:	00004097          	auipc	ra,0x4
    1c8c:	f92080e7          	jalr	-110(ra) # 5c1a <wait>
    if(xstatus != 0) {
    1c90:	fdc42783          	lw	a5,-36(s0)
    1c94:	ebbd                	bnez	a5,1d0a <forkfork+0xae>
    wait(&xstatus);
    1c96:	fdc40513          	addi	a0,s0,-36
    1c9a:	00004097          	auipc	ra,0x4
    1c9e:	f80080e7          	jalr	-128(ra) # 5c1a <wait>
    if(xstatus != 0) {
    1ca2:	fdc42783          	lw	a5,-36(s0)
    1ca6:	e3b5                	bnez	a5,1d0a <forkfork+0xae>
}
    1ca8:	70a2                	ld	ra,40(sp)
    1caa:	7402                	ld	s0,32(sp)
    1cac:	64e2                	ld	s1,24(sp)
    1cae:	6145                	addi	sp,sp,48
    1cb0:	8082                	ret
      printf("%s: fork failed", s);
    1cb2:	85a6                	mv	a1,s1
    1cb4:	00005517          	auipc	a0,0x5
    1cb8:	f1c50513          	addi	a0,a0,-228 # 6bd0 <malloc+0xb86>
    1cbc:	00004097          	auipc	ra,0x4
    1cc0:	2ce080e7          	jalr	718(ra) # 5f8a <printf>
      exit(1);
    1cc4:	4505                	li	a0,1
    1cc6:	00004097          	auipc	ra,0x4
    1cca:	f4c080e7          	jalr	-180(ra) # 5c12 <exit>
{
    1cce:	0c800493          	li	s1,200
        int pid1 = fork();
    1cd2:	00004097          	auipc	ra,0x4
    1cd6:	f38080e7          	jalr	-200(ra) # 5c0a <fork>
        if(pid1 < 0){
    1cda:	00054f63          	bltz	a0,1cf8 <forkfork+0x9c>
        if(pid1 == 0){
    1cde:	c115                	beqz	a0,1d02 <forkfork+0xa6>
        wait(0);
    1ce0:	4501                	li	a0,0
    1ce2:	00004097          	auipc	ra,0x4
    1ce6:	f38080e7          	jalr	-200(ra) # 5c1a <wait>
      for(int j = 0; j < 200; j++){
    1cea:	34fd                	addiw	s1,s1,-1
    1cec:	f0fd                	bnez	s1,1cd2 <forkfork+0x76>
      exit(0);
    1cee:	4501                	li	a0,0
    1cf0:	00004097          	auipc	ra,0x4
    1cf4:	f22080e7          	jalr	-222(ra) # 5c12 <exit>
          exit(1);
    1cf8:	4505                	li	a0,1
    1cfa:	00004097          	auipc	ra,0x4
    1cfe:	f18080e7          	jalr	-232(ra) # 5c12 <exit>
          exit(0);
    1d02:	00004097          	auipc	ra,0x4
    1d06:	f10080e7          	jalr	-240(ra) # 5c12 <exit>
      printf("%s: fork in child failed", s);
    1d0a:	85a6                	mv	a1,s1
    1d0c:	00005517          	auipc	a0,0x5
    1d10:	ed450513          	addi	a0,a0,-300 # 6be0 <malloc+0xb96>
    1d14:	00004097          	auipc	ra,0x4
    1d18:	276080e7          	jalr	630(ra) # 5f8a <printf>
      exit(1);
    1d1c:	4505                	li	a0,1
    1d1e:	00004097          	auipc	ra,0x4
    1d22:	ef4080e7          	jalr	-268(ra) # 5c12 <exit>

0000000000001d26 <reparent2>:
{
    1d26:	1101                	addi	sp,sp,-32
    1d28:	ec06                	sd	ra,24(sp)
    1d2a:	e822                	sd	s0,16(sp)
    1d2c:	e426                	sd	s1,8(sp)
    1d2e:	1000                	addi	s0,sp,32
    1d30:	32000493          	li	s1,800
    int pid1 = fork();
    1d34:	00004097          	auipc	ra,0x4
    1d38:	ed6080e7          	jalr	-298(ra) # 5c0a <fork>
    if(pid1 < 0){
    1d3c:	00054f63          	bltz	a0,1d5a <reparent2+0x34>
    if(pid1 == 0){
    1d40:	c915                	beqz	a0,1d74 <reparent2+0x4e>
    wait(0);
    1d42:	4501                	li	a0,0
    1d44:	00004097          	auipc	ra,0x4
    1d48:	ed6080e7          	jalr	-298(ra) # 5c1a <wait>
  for(int i = 0; i < 800; i++){
    1d4c:	34fd                	addiw	s1,s1,-1
    1d4e:	f0fd                	bnez	s1,1d34 <reparent2+0xe>
  exit(0);
    1d50:	4501                	li	a0,0
    1d52:	00004097          	auipc	ra,0x4
    1d56:	ec0080e7          	jalr	-320(ra) # 5c12 <exit>
      printf("fork failed\n");
    1d5a:	00005517          	auipc	a0,0x5
    1d5e:	0be50513          	addi	a0,a0,190 # 6e18 <malloc+0xdce>
    1d62:	00004097          	auipc	ra,0x4
    1d66:	228080e7          	jalr	552(ra) # 5f8a <printf>
      exit(1);
    1d6a:	4505                	li	a0,1
    1d6c:	00004097          	auipc	ra,0x4
    1d70:	ea6080e7          	jalr	-346(ra) # 5c12 <exit>
      fork();
    1d74:	00004097          	auipc	ra,0x4
    1d78:	e96080e7          	jalr	-362(ra) # 5c0a <fork>
      fork();
    1d7c:	00004097          	auipc	ra,0x4
    1d80:	e8e080e7          	jalr	-370(ra) # 5c0a <fork>
      exit(0);
    1d84:	4501                	li	a0,0
    1d86:	00004097          	auipc	ra,0x4
    1d8a:	e8c080e7          	jalr	-372(ra) # 5c12 <exit>

0000000000001d8e <createdelete>:
{
    1d8e:	7175                	addi	sp,sp,-144
    1d90:	e506                	sd	ra,136(sp)
    1d92:	e122                	sd	s0,128(sp)
    1d94:	fca6                	sd	s1,120(sp)
    1d96:	f8ca                	sd	s2,112(sp)
    1d98:	f4ce                	sd	s3,104(sp)
    1d9a:	f0d2                	sd	s4,96(sp)
    1d9c:	ecd6                	sd	s5,88(sp)
    1d9e:	e8da                	sd	s6,80(sp)
    1da0:	e4de                	sd	s7,72(sp)
    1da2:	e0e2                	sd	s8,64(sp)
    1da4:	fc66                	sd	s9,56(sp)
    1da6:	0900                	addi	s0,sp,144
    1da8:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1daa:	4901                	li	s2,0
    1dac:	4991                	li	s3,4
    pid = fork();
    1dae:	00004097          	auipc	ra,0x4
    1db2:	e5c080e7          	jalr	-420(ra) # 5c0a <fork>
    1db6:	84aa                	mv	s1,a0
    if(pid < 0){
    1db8:	02054f63          	bltz	a0,1df6 <createdelete+0x68>
    if(pid == 0){
    1dbc:	c939                	beqz	a0,1e12 <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1dbe:	2905                	addiw	s2,s2,1
    1dc0:	ff3917e3          	bne	s2,s3,1dae <createdelete+0x20>
    1dc4:	4491                	li	s1,4
    wait(&xstatus);
    1dc6:	f7c40513          	addi	a0,s0,-132
    1dca:	00004097          	auipc	ra,0x4
    1dce:	e50080e7          	jalr	-432(ra) # 5c1a <wait>
    if(xstatus != 0)
    1dd2:	f7c42903          	lw	s2,-132(s0)
    1dd6:	0e091263          	bnez	s2,1eba <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1dda:	34fd                	addiw	s1,s1,-1
    1ddc:	f4ed                	bnez	s1,1dc6 <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1dde:	f8040123          	sb	zero,-126(s0)
    1de2:	03000993          	li	s3,48
    1de6:	5a7d                	li	s4,-1
    1de8:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1dec:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    1dee:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    1df0:	07400a93          	li	s5,116
    1df4:	a29d                	j	1f5a <createdelete+0x1cc>
      printf("fork failed\n", s);
    1df6:	85e6                	mv	a1,s9
    1df8:	00005517          	auipc	a0,0x5
    1dfc:	02050513          	addi	a0,a0,32 # 6e18 <malloc+0xdce>
    1e00:	00004097          	auipc	ra,0x4
    1e04:	18a080e7          	jalr	394(ra) # 5f8a <printf>
      exit(1);
    1e08:	4505                	li	a0,1
    1e0a:	00004097          	auipc	ra,0x4
    1e0e:	e08080e7          	jalr	-504(ra) # 5c12 <exit>
      name[0] = 'p' + pi;
    1e12:	0709091b          	addiw	s2,s2,112
    1e16:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1e1a:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1e1e:	4951                	li	s2,20
    1e20:	a015                	j	1e44 <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1e22:	85e6                	mv	a1,s9
    1e24:	00005517          	auipc	a0,0x5
    1e28:	c8450513          	addi	a0,a0,-892 # 6aa8 <malloc+0xa5e>
    1e2c:	00004097          	auipc	ra,0x4
    1e30:	15e080e7          	jalr	350(ra) # 5f8a <printf>
          exit(1);
    1e34:	4505                	li	a0,1
    1e36:	00004097          	auipc	ra,0x4
    1e3a:	ddc080e7          	jalr	-548(ra) # 5c12 <exit>
      for(i = 0; i < N; i++){
    1e3e:	2485                	addiw	s1,s1,1
    1e40:	07248863          	beq	s1,s2,1eb0 <createdelete+0x122>
        name[1] = '0' + i;
    1e44:	0304879b          	addiw	a5,s1,48
    1e48:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1e4c:	20200593          	li	a1,514
    1e50:	f8040513          	addi	a0,s0,-128
    1e54:	00004097          	auipc	ra,0x4
    1e58:	dfe080e7          	jalr	-514(ra) # 5c52 <open>
        if(fd < 0){
    1e5c:	fc0543e3          	bltz	a0,1e22 <createdelete+0x94>
        close(fd);
    1e60:	00004097          	auipc	ra,0x4
    1e64:	dda080e7          	jalr	-550(ra) # 5c3a <close>
        if(i > 0 && (i % 2 ) == 0){
    1e68:	fc905be3          	blez	s1,1e3e <createdelete+0xb0>
    1e6c:	0014f793          	andi	a5,s1,1
    1e70:	f7f9                	bnez	a5,1e3e <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1e72:	01f4d79b          	srliw	a5,s1,0x1f
    1e76:	9fa5                	addw	a5,a5,s1
    1e78:	4017d79b          	sraiw	a5,a5,0x1
    1e7c:	0307879b          	addiw	a5,a5,48
    1e80:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1e84:	f8040513          	addi	a0,s0,-128
    1e88:	00004097          	auipc	ra,0x4
    1e8c:	dda080e7          	jalr	-550(ra) # 5c62 <unlink>
    1e90:	fa0557e3          	bgez	a0,1e3e <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1e94:	85e6                	mv	a1,s9
    1e96:	00005517          	auipc	a0,0x5
    1e9a:	d6a50513          	addi	a0,a0,-662 # 6c00 <malloc+0xbb6>
    1e9e:	00004097          	auipc	ra,0x4
    1ea2:	0ec080e7          	jalr	236(ra) # 5f8a <printf>
            exit(1);
    1ea6:	4505                	li	a0,1
    1ea8:	00004097          	auipc	ra,0x4
    1eac:	d6a080e7          	jalr	-662(ra) # 5c12 <exit>
      exit(0);
    1eb0:	4501                	li	a0,0
    1eb2:	00004097          	auipc	ra,0x4
    1eb6:	d60080e7          	jalr	-672(ra) # 5c12 <exit>
      exit(1);
    1eba:	4505                	li	a0,1
    1ebc:	00004097          	auipc	ra,0x4
    1ec0:	d56080e7          	jalr	-682(ra) # 5c12 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1ec4:	f8040613          	addi	a2,s0,-128
    1ec8:	85e6                	mv	a1,s9
    1eca:	00005517          	auipc	a0,0x5
    1ece:	d4e50513          	addi	a0,a0,-690 # 6c18 <malloc+0xbce>
    1ed2:	00004097          	auipc	ra,0x4
    1ed6:	0b8080e7          	jalr	184(ra) # 5f8a <printf>
        exit(1);
    1eda:	4505                	li	a0,1
    1edc:	00004097          	auipc	ra,0x4
    1ee0:	d36080e7          	jalr	-714(ra) # 5c12 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1ee4:	054b7163          	bgeu	s6,s4,1f26 <createdelete+0x198>
      if(fd >= 0)
    1ee8:	02055a63          	bgez	a0,1f1c <createdelete+0x18e>
    for(pi = 0; pi < NCHILD; pi++){
    1eec:	2485                	addiw	s1,s1,1
    1eee:	0ff4f493          	andi	s1,s1,255
    1ef2:	05548c63          	beq	s1,s5,1f4a <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1ef6:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1efa:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1efe:	4581                	li	a1,0
    1f00:	f8040513          	addi	a0,s0,-128
    1f04:	00004097          	auipc	ra,0x4
    1f08:	d4e080e7          	jalr	-690(ra) # 5c52 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1f0c:	00090463          	beqz	s2,1f14 <createdelete+0x186>
    1f10:	fd2bdae3          	bge	s7,s2,1ee4 <createdelete+0x156>
    1f14:	fa0548e3          	bltz	a0,1ec4 <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1f18:	014b7963          	bgeu	s6,s4,1f2a <createdelete+0x19c>
        close(fd);
    1f1c:	00004097          	auipc	ra,0x4
    1f20:	d1e080e7          	jalr	-738(ra) # 5c3a <close>
    1f24:	b7e1                	j	1eec <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1f26:	fc0543e3          	bltz	a0,1eec <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1f2a:	f8040613          	addi	a2,s0,-128
    1f2e:	85e6                	mv	a1,s9
    1f30:	00005517          	auipc	a0,0x5
    1f34:	d1050513          	addi	a0,a0,-752 # 6c40 <malloc+0xbf6>
    1f38:	00004097          	auipc	ra,0x4
    1f3c:	052080e7          	jalr	82(ra) # 5f8a <printf>
        exit(1);
    1f40:	4505                	li	a0,1
    1f42:	00004097          	auipc	ra,0x4
    1f46:	cd0080e7          	jalr	-816(ra) # 5c12 <exit>
  for(i = 0; i < N; i++){
    1f4a:	2905                	addiw	s2,s2,1
    1f4c:	2a05                	addiw	s4,s4,1
    1f4e:	2985                	addiw	s3,s3,1
    1f50:	0ff9f993          	andi	s3,s3,255
    1f54:	47d1                	li	a5,20
    1f56:	02f90a63          	beq	s2,a5,1f8a <createdelete+0x1fc>
    for(pi = 0; pi < NCHILD; pi++){
    1f5a:	84e2                	mv	s1,s8
    1f5c:	bf69                	j	1ef6 <createdelete+0x168>
  for(i = 0; i < N; i++){
    1f5e:	2905                	addiw	s2,s2,1
    1f60:	0ff97913          	andi	s2,s2,255
    1f64:	2985                	addiw	s3,s3,1
    1f66:	0ff9f993          	andi	s3,s3,255
    1f6a:	03490863          	beq	s2,s4,1f9a <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1f6e:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1f70:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1f74:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1f78:	f8040513          	addi	a0,s0,-128
    1f7c:	00004097          	auipc	ra,0x4
    1f80:	ce6080e7          	jalr	-794(ra) # 5c62 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1f84:	34fd                	addiw	s1,s1,-1
    1f86:	f4ed                	bnez	s1,1f70 <createdelete+0x1e2>
    1f88:	bfd9                	j	1f5e <createdelete+0x1d0>
    1f8a:	03000993          	li	s3,48
    1f8e:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1f92:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1f94:	08400a13          	li	s4,132
    1f98:	bfd9                	j	1f6e <createdelete+0x1e0>
}
    1f9a:	60aa                	ld	ra,136(sp)
    1f9c:	640a                	ld	s0,128(sp)
    1f9e:	74e6                	ld	s1,120(sp)
    1fa0:	7946                	ld	s2,112(sp)
    1fa2:	79a6                	ld	s3,104(sp)
    1fa4:	7a06                	ld	s4,96(sp)
    1fa6:	6ae6                	ld	s5,88(sp)
    1fa8:	6b46                	ld	s6,80(sp)
    1faa:	6ba6                	ld	s7,72(sp)
    1fac:	6c06                	ld	s8,64(sp)
    1fae:	7ce2                	ld	s9,56(sp)
    1fb0:	6149                	addi	sp,sp,144
    1fb2:	8082                	ret

0000000000001fb4 <linkunlink>:
{
    1fb4:	711d                	addi	sp,sp,-96
    1fb6:	ec86                	sd	ra,88(sp)
    1fb8:	e8a2                	sd	s0,80(sp)
    1fba:	e4a6                	sd	s1,72(sp)
    1fbc:	e0ca                	sd	s2,64(sp)
    1fbe:	fc4e                	sd	s3,56(sp)
    1fc0:	f852                	sd	s4,48(sp)
    1fc2:	f456                	sd	s5,40(sp)
    1fc4:	f05a                	sd	s6,32(sp)
    1fc6:	ec5e                	sd	s7,24(sp)
    1fc8:	e862                	sd	s8,16(sp)
    1fca:	e466                	sd	s9,8(sp)
    1fcc:	1080                	addi	s0,sp,96
    1fce:	84aa                	mv	s1,a0
  unlink("x");
    1fd0:	00004517          	auipc	a0,0x4
    1fd4:	22850513          	addi	a0,a0,552 # 61f8 <malloc+0x1ae>
    1fd8:	00004097          	auipc	ra,0x4
    1fdc:	c8a080e7          	jalr	-886(ra) # 5c62 <unlink>
  pid = fork();
    1fe0:	00004097          	auipc	ra,0x4
    1fe4:	c2a080e7          	jalr	-982(ra) # 5c0a <fork>
  if(pid < 0){
    1fe8:	02054b63          	bltz	a0,201e <linkunlink+0x6a>
    1fec:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1fee:	4c85                	li	s9,1
    1ff0:	e119                	bnez	a0,1ff6 <linkunlink+0x42>
    1ff2:	06100c93          	li	s9,97
    1ff6:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1ffa:	41c659b7          	lui	s3,0x41c65
    1ffe:	e6d9899b          	addiw	s3,s3,-403
    2002:	690d                	lui	s2,0x3
    2004:	0399091b          	addiw	s2,s2,57
    if((x % 3) == 0){
    2008:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    200a:	4b05                	li	s6,1
      unlink("x");
    200c:	00004a97          	auipc	s5,0x4
    2010:	1eca8a93          	addi	s5,s5,492 # 61f8 <malloc+0x1ae>
      link("cat", "x");
    2014:	00005b97          	auipc	s7,0x5
    2018:	c54b8b93          	addi	s7,s7,-940 # 6c68 <malloc+0xc1e>
    201c:	a091                	j	2060 <linkunlink+0xac>
    printf("%s: fork failed\n", s);
    201e:	85a6                	mv	a1,s1
    2020:	00005517          	auipc	a0,0x5
    2024:	9f050513          	addi	a0,a0,-1552 # 6a10 <malloc+0x9c6>
    2028:	00004097          	auipc	ra,0x4
    202c:	f62080e7          	jalr	-158(ra) # 5f8a <printf>
    exit(1);
    2030:	4505                	li	a0,1
    2032:	00004097          	auipc	ra,0x4
    2036:	be0080e7          	jalr	-1056(ra) # 5c12 <exit>
      close(open("x", O_RDWR | O_CREATE));
    203a:	20200593          	li	a1,514
    203e:	8556                	mv	a0,s5
    2040:	00004097          	auipc	ra,0x4
    2044:	c12080e7          	jalr	-1006(ra) # 5c52 <open>
    2048:	00004097          	auipc	ra,0x4
    204c:	bf2080e7          	jalr	-1038(ra) # 5c3a <close>
    2050:	a031                	j	205c <linkunlink+0xa8>
      unlink("x");
    2052:	8556                	mv	a0,s5
    2054:	00004097          	auipc	ra,0x4
    2058:	c0e080e7          	jalr	-1010(ra) # 5c62 <unlink>
  for(i = 0; i < 100; i++){
    205c:	34fd                	addiw	s1,s1,-1
    205e:	c09d                	beqz	s1,2084 <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    2060:	033c87bb          	mulw	a5,s9,s3
    2064:	012787bb          	addw	a5,a5,s2
    2068:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    206c:	0347f7bb          	remuw	a5,a5,s4
    2070:	d7e9                	beqz	a5,203a <linkunlink+0x86>
    } else if((x % 3) == 1){
    2072:	ff6790e3          	bne	a5,s6,2052 <linkunlink+0x9e>
      link("cat", "x");
    2076:	85d6                	mv	a1,s5
    2078:	855e                	mv	a0,s7
    207a:	00004097          	auipc	ra,0x4
    207e:	bf8080e7          	jalr	-1032(ra) # 5c72 <link>
    2082:	bfe9                	j	205c <linkunlink+0xa8>
  if(pid)
    2084:	020c0463          	beqz	s8,20ac <linkunlink+0xf8>
    wait(0);
    2088:	4501                	li	a0,0
    208a:	00004097          	auipc	ra,0x4
    208e:	b90080e7          	jalr	-1136(ra) # 5c1a <wait>
}
    2092:	60e6                	ld	ra,88(sp)
    2094:	6446                	ld	s0,80(sp)
    2096:	64a6                	ld	s1,72(sp)
    2098:	6906                	ld	s2,64(sp)
    209a:	79e2                	ld	s3,56(sp)
    209c:	7a42                	ld	s4,48(sp)
    209e:	7aa2                	ld	s5,40(sp)
    20a0:	7b02                	ld	s6,32(sp)
    20a2:	6be2                	ld	s7,24(sp)
    20a4:	6c42                	ld	s8,16(sp)
    20a6:	6ca2                	ld	s9,8(sp)
    20a8:	6125                	addi	sp,sp,96
    20aa:	8082                	ret
    exit(0);
    20ac:	4501                	li	a0,0
    20ae:	00004097          	auipc	ra,0x4
    20b2:	b64080e7          	jalr	-1180(ra) # 5c12 <exit>

00000000000020b6 <forktest>:
{
    20b6:	7179                	addi	sp,sp,-48
    20b8:	f406                	sd	ra,40(sp)
    20ba:	f022                	sd	s0,32(sp)
    20bc:	ec26                	sd	s1,24(sp)
    20be:	e84a                	sd	s2,16(sp)
    20c0:	e44e                	sd	s3,8(sp)
    20c2:	1800                	addi	s0,sp,48
    20c4:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    20c6:	4481                	li	s1,0
    20c8:	3e800913          	li	s2,1000
    pid = fork();
    20cc:	00004097          	auipc	ra,0x4
    20d0:	b3e080e7          	jalr	-1218(ra) # 5c0a <fork>
    if(pid < 0)
    20d4:	02054863          	bltz	a0,2104 <forktest+0x4e>
    if(pid == 0)
    20d8:	c115                	beqz	a0,20fc <forktest+0x46>
  for(n=0; n<N; n++){
    20da:	2485                	addiw	s1,s1,1
    20dc:	ff2498e3          	bne	s1,s2,20cc <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    20e0:	85ce                	mv	a1,s3
    20e2:	00005517          	auipc	a0,0x5
    20e6:	ba650513          	addi	a0,a0,-1114 # 6c88 <malloc+0xc3e>
    20ea:	00004097          	auipc	ra,0x4
    20ee:	ea0080e7          	jalr	-352(ra) # 5f8a <printf>
    exit(1);
    20f2:	4505                	li	a0,1
    20f4:	00004097          	auipc	ra,0x4
    20f8:	b1e080e7          	jalr	-1250(ra) # 5c12 <exit>
      exit(0);
    20fc:	00004097          	auipc	ra,0x4
    2100:	b16080e7          	jalr	-1258(ra) # 5c12 <exit>
  if (n == 0) {
    2104:	cc9d                	beqz	s1,2142 <forktest+0x8c>
  if(n == N){
    2106:	3e800793          	li	a5,1000
    210a:	fcf48be3          	beq	s1,a5,20e0 <forktest+0x2a>
  for(; n > 0; n--){
    210e:	00905b63          	blez	s1,2124 <forktest+0x6e>
    if(wait(0) < 0){
    2112:	4501                	li	a0,0
    2114:	00004097          	auipc	ra,0x4
    2118:	b06080e7          	jalr	-1274(ra) # 5c1a <wait>
    211c:	04054163          	bltz	a0,215e <forktest+0xa8>
  for(; n > 0; n--){
    2120:	34fd                	addiw	s1,s1,-1
    2122:	f8e5                	bnez	s1,2112 <forktest+0x5c>
  if(wait(0) != -1){
    2124:	4501                	li	a0,0
    2126:	00004097          	auipc	ra,0x4
    212a:	af4080e7          	jalr	-1292(ra) # 5c1a <wait>
    212e:	57fd                	li	a5,-1
    2130:	04f51563          	bne	a0,a5,217a <forktest+0xc4>
}
    2134:	70a2                	ld	ra,40(sp)
    2136:	7402                	ld	s0,32(sp)
    2138:	64e2                	ld	s1,24(sp)
    213a:	6942                	ld	s2,16(sp)
    213c:	69a2                	ld	s3,8(sp)
    213e:	6145                	addi	sp,sp,48
    2140:	8082                	ret
    printf("%s: no fork at all!\n", s);
    2142:	85ce                	mv	a1,s3
    2144:	00005517          	auipc	a0,0x5
    2148:	b2c50513          	addi	a0,a0,-1236 # 6c70 <malloc+0xc26>
    214c:	00004097          	auipc	ra,0x4
    2150:	e3e080e7          	jalr	-450(ra) # 5f8a <printf>
    exit(1);
    2154:	4505                	li	a0,1
    2156:	00004097          	auipc	ra,0x4
    215a:	abc080e7          	jalr	-1348(ra) # 5c12 <exit>
      printf("%s: wait stopped early\n", s);
    215e:	85ce                	mv	a1,s3
    2160:	00005517          	auipc	a0,0x5
    2164:	b5050513          	addi	a0,a0,-1200 # 6cb0 <malloc+0xc66>
    2168:	00004097          	auipc	ra,0x4
    216c:	e22080e7          	jalr	-478(ra) # 5f8a <printf>
      exit(1);
    2170:	4505                	li	a0,1
    2172:	00004097          	auipc	ra,0x4
    2176:	aa0080e7          	jalr	-1376(ra) # 5c12 <exit>
    printf("%s: wait got too many\n", s);
    217a:	85ce                	mv	a1,s3
    217c:	00005517          	auipc	a0,0x5
    2180:	b4c50513          	addi	a0,a0,-1204 # 6cc8 <malloc+0xc7e>
    2184:	00004097          	auipc	ra,0x4
    2188:	e06080e7          	jalr	-506(ra) # 5f8a <printf>
    exit(1);
    218c:	4505                	li	a0,1
    218e:	00004097          	auipc	ra,0x4
    2192:	a84080e7          	jalr	-1404(ra) # 5c12 <exit>

0000000000002196 <kernmem>:
{
    2196:	715d                	addi	sp,sp,-80
    2198:	e486                	sd	ra,72(sp)
    219a:	e0a2                	sd	s0,64(sp)
    219c:	fc26                	sd	s1,56(sp)
    219e:	f84a                	sd	s2,48(sp)
    21a0:	f44e                	sd	s3,40(sp)
    21a2:	f052                	sd	s4,32(sp)
    21a4:	ec56                	sd	s5,24(sp)
    21a6:	0880                	addi	s0,sp,80
    21a8:	8aaa                	mv	s5,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    21aa:	4485                	li	s1,1
    21ac:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    21ae:	5a7d                	li	s4,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    21b0:	69b1                	lui	s3,0xc
    21b2:	35098993          	addi	s3,s3,848 # c350 <uninit+0x1de8>
    21b6:	1003d937          	lui	s2,0x1003d
    21ba:	090e                	slli	s2,s2,0x3
    21bc:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002d808>
    pid = fork();
    21c0:	00004097          	auipc	ra,0x4
    21c4:	a4a080e7          	jalr	-1462(ra) # 5c0a <fork>
    if(pid < 0){
    21c8:	02054963          	bltz	a0,21fa <kernmem+0x64>
    if(pid == 0){
    21cc:	c529                	beqz	a0,2216 <kernmem+0x80>
    wait(&xstatus);
    21ce:	fbc40513          	addi	a0,s0,-68
    21d2:	00004097          	auipc	ra,0x4
    21d6:	a48080e7          	jalr	-1464(ra) # 5c1a <wait>
    if(xstatus != -1)  // did kernel kill child?
    21da:	fbc42783          	lw	a5,-68(s0)
    21de:	05479d63          	bne	a5,s4,2238 <kernmem+0xa2>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    21e2:	94ce                	add	s1,s1,s3
    21e4:	fd249ee3          	bne	s1,s2,21c0 <kernmem+0x2a>
}
    21e8:	60a6                	ld	ra,72(sp)
    21ea:	6406                	ld	s0,64(sp)
    21ec:	74e2                	ld	s1,56(sp)
    21ee:	7942                	ld	s2,48(sp)
    21f0:	79a2                	ld	s3,40(sp)
    21f2:	7a02                	ld	s4,32(sp)
    21f4:	6ae2                	ld	s5,24(sp)
    21f6:	6161                	addi	sp,sp,80
    21f8:	8082                	ret
      printf("%s: fork failed\n", s);
    21fa:	85d6                	mv	a1,s5
    21fc:	00005517          	auipc	a0,0x5
    2200:	81450513          	addi	a0,a0,-2028 # 6a10 <malloc+0x9c6>
    2204:	00004097          	auipc	ra,0x4
    2208:	d86080e7          	jalr	-634(ra) # 5f8a <printf>
      exit(1);
    220c:	4505                	li	a0,1
    220e:	00004097          	auipc	ra,0x4
    2212:	a04080e7          	jalr	-1532(ra) # 5c12 <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    2216:	0004c683          	lbu	a3,0(s1)
    221a:	8626                	mv	a2,s1
    221c:	85d6                	mv	a1,s5
    221e:	00005517          	auipc	a0,0x5
    2222:	ac250513          	addi	a0,a0,-1342 # 6ce0 <malloc+0xc96>
    2226:	00004097          	auipc	ra,0x4
    222a:	d64080e7          	jalr	-668(ra) # 5f8a <printf>
      exit(1);
    222e:	4505                	li	a0,1
    2230:	00004097          	auipc	ra,0x4
    2234:	9e2080e7          	jalr	-1566(ra) # 5c12 <exit>
      exit(1);
    2238:	4505                	li	a0,1
    223a:	00004097          	auipc	ra,0x4
    223e:	9d8080e7          	jalr	-1576(ra) # 5c12 <exit>

0000000000002242 <MAXVAplus>:
{
    2242:	7179                	addi	sp,sp,-48
    2244:	f406                	sd	ra,40(sp)
    2246:	f022                	sd	s0,32(sp)
    2248:	ec26                	sd	s1,24(sp)
    224a:	e84a                	sd	s2,16(sp)
    224c:	1800                	addi	s0,sp,48
  volatile uint64 a = MAXVA;
    224e:	4785                	li	a5,1
    2250:	179a                	slli	a5,a5,0x26
    2252:	fcf43c23          	sd	a5,-40(s0)
  for( ; a != 0; a <<= 1){
    2256:	fd843783          	ld	a5,-40(s0)
    225a:	cf85                	beqz	a5,2292 <MAXVAplus+0x50>
    225c:	892a                	mv	s2,a0
    if(xstatus != -1)  // did kernel kill child?
    225e:	54fd                	li	s1,-1
    pid = fork();
    2260:	00004097          	auipc	ra,0x4
    2264:	9aa080e7          	jalr	-1622(ra) # 5c0a <fork>
    if(pid < 0){
    2268:	02054b63          	bltz	a0,229e <MAXVAplus+0x5c>
    if(pid == 0){
    226c:	c539                	beqz	a0,22ba <MAXVAplus+0x78>
    wait(&xstatus);
    226e:	fd440513          	addi	a0,s0,-44
    2272:	00004097          	auipc	ra,0x4
    2276:	9a8080e7          	jalr	-1624(ra) # 5c1a <wait>
    if(xstatus != -1)  // did kernel kill child?
    227a:	fd442783          	lw	a5,-44(s0)
    227e:	06979463          	bne	a5,s1,22e6 <MAXVAplus+0xa4>
  for( ; a != 0; a <<= 1){
    2282:	fd843783          	ld	a5,-40(s0)
    2286:	0786                	slli	a5,a5,0x1
    2288:	fcf43c23          	sd	a5,-40(s0)
    228c:	fd843783          	ld	a5,-40(s0)
    2290:	fbe1                	bnez	a5,2260 <MAXVAplus+0x1e>
}
    2292:	70a2                	ld	ra,40(sp)
    2294:	7402                	ld	s0,32(sp)
    2296:	64e2                	ld	s1,24(sp)
    2298:	6942                	ld	s2,16(sp)
    229a:	6145                	addi	sp,sp,48
    229c:	8082                	ret
      printf("%s: fork failed\n", s);
    229e:	85ca                	mv	a1,s2
    22a0:	00004517          	auipc	a0,0x4
    22a4:	77050513          	addi	a0,a0,1904 # 6a10 <malloc+0x9c6>
    22a8:	00004097          	auipc	ra,0x4
    22ac:	ce2080e7          	jalr	-798(ra) # 5f8a <printf>
      exit(1);
    22b0:	4505                	li	a0,1
    22b2:	00004097          	auipc	ra,0x4
    22b6:	960080e7          	jalr	-1696(ra) # 5c12 <exit>
      *(char*)a = 99;
    22ba:	fd843783          	ld	a5,-40(s0)
    22be:	06300713          	li	a4,99
    22c2:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %x\n", s, a);
    22c6:	fd843603          	ld	a2,-40(s0)
    22ca:	85ca                	mv	a1,s2
    22cc:	00005517          	auipc	a0,0x5
    22d0:	a3450513          	addi	a0,a0,-1484 # 6d00 <malloc+0xcb6>
    22d4:	00004097          	auipc	ra,0x4
    22d8:	cb6080e7          	jalr	-842(ra) # 5f8a <printf>
      exit(1);
    22dc:	4505                	li	a0,1
    22de:	00004097          	auipc	ra,0x4
    22e2:	934080e7          	jalr	-1740(ra) # 5c12 <exit>
      exit(1);
    22e6:	4505                	li	a0,1
    22e8:	00004097          	auipc	ra,0x4
    22ec:	92a080e7          	jalr	-1750(ra) # 5c12 <exit>

00000000000022f0 <bigargtest>:
{
    22f0:	7179                	addi	sp,sp,-48
    22f2:	f406                	sd	ra,40(sp)
    22f4:	f022                	sd	s0,32(sp)
    22f6:	ec26                	sd	s1,24(sp)
    22f8:	1800                	addi	s0,sp,48
    22fa:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    22fc:	00005517          	auipc	a0,0x5
    2300:	a1c50513          	addi	a0,a0,-1508 # 6d18 <malloc+0xcce>
    2304:	00004097          	auipc	ra,0x4
    2308:	95e080e7          	jalr	-1698(ra) # 5c62 <unlink>
  pid = fork();
    230c:	00004097          	auipc	ra,0x4
    2310:	8fe080e7          	jalr	-1794(ra) # 5c0a <fork>
  if(pid == 0){
    2314:	c121                	beqz	a0,2354 <bigargtest+0x64>
  } else if(pid < 0){
    2316:	0a054063          	bltz	a0,23b6 <bigargtest+0xc6>
  wait(&xstatus);
    231a:	fdc40513          	addi	a0,s0,-36
    231e:	00004097          	auipc	ra,0x4
    2322:	8fc080e7          	jalr	-1796(ra) # 5c1a <wait>
  if(xstatus != 0)
    2326:	fdc42503          	lw	a0,-36(s0)
    232a:	e545                	bnez	a0,23d2 <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    232c:	4581                	li	a1,0
    232e:	00005517          	auipc	a0,0x5
    2332:	9ea50513          	addi	a0,a0,-1558 # 6d18 <malloc+0xcce>
    2336:	00004097          	auipc	ra,0x4
    233a:	91c080e7          	jalr	-1764(ra) # 5c52 <open>
  if(fd < 0){
    233e:	08054e63          	bltz	a0,23da <bigargtest+0xea>
  close(fd);
    2342:	00004097          	auipc	ra,0x4
    2346:	8f8080e7          	jalr	-1800(ra) # 5c3a <close>
}
    234a:	70a2                	ld	ra,40(sp)
    234c:	7402                	ld	s0,32(sp)
    234e:	64e2                	ld	s1,24(sp)
    2350:	6145                	addi	sp,sp,48
    2352:	8082                	ret
    2354:	00007797          	auipc	a5,0x7
    2358:	10c78793          	addi	a5,a5,268 # 9460 <args.1834>
    235c:	00007697          	auipc	a3,0x7
    2360:	1fc68693          	addi	a3,a3,508 # 9558 <args.1834+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    2364:	00005717          	auipc	a4,0x5
    2368:	9c470713          	addi	a4,a4,-1596 # 6d28 <malloc+0xcde>
    236c:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    236e:	07a1                	addi	a5,a5,8
    2370:	fed79ee3          	bne	a5,a3,236c <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    2374:	00007597          	auipc	a1,0x7
    2378:	0ec58593          	addi	a1,a1,236 # 9460 <args.1834>
    237c:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    2380:	00004517          	auipc	a0,0x4
    2384:	e0850513          	addi	a0,a0,-504 # 6188 <malloc+0x13e>
    2388:	00004097          	auipc	ra,0x4
    238c:	8c2080e7          	jalr	-1854(ra) # 5c4a <exec>
    fd = open("bigarg-ok", O_CREATE);
    2390:	20000593          	li	a1,512
    2394:	00005517          	auipc	a0,0x5
    2398:	98450513          	addi	a0,a0,-1660 # 6d18 <malloc+0xcce>
    239c:	00004097          	auipc	ra,0x4
    23a0:	8b6080e7          	jalr	-1866(ra) # 5c52 <open>
    close(fd);
    23a4:	00004097          	auipc	ra,0x4
    23a8:	896080e7          	jalr	-1898(ra) # 5c3a <close>
    exit(0);
    23ac:	4501                	li	a0,0
    23ae:	00004097          	auipc	ra,0x4
    23b2:	864080e7          	jalr	-1948(ra) # 5c12 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    23b6:	85a6                	mv	a1,s1
    23b8:	00005517          	auipc	a0,0x5
    23bc:	a5050513          	addi	a0,a0,-1456 # 6e08 <malloc+0xdbe>
    23c0:	00004097          	auipc	ra,0x4
    23c4:	bca080e7          	jalr	-1078(ra) # 5f8a <printf>
    exit(1);
    23c8:	4505                	li	a0,1
    23ca:	00004097          	auipc	ra,0x4
    23ce:	848080e7          	jalr	-1976(ra) # 5c12 <exit>
    exit(xstatus);
    23d2:	00004097          	auipc	ra,0x4
    23d6:	840080e7          	jalr	-1984(ra) # 5c12 <exit>
    printf("%s: bigarg test failed!\n", s);
    23da:	85a6                	mv	a1,s1
    23dc:	00005517          	auipc	a0,0x5
    23e0:	a4c50513          	addi	a0,a0,-1460 # 6e28 <malloc+0xdde>
    23e4:	00004097          	auipc	ra,0x4
    23e8:	ba6080e7          	jalr	-1114(ra) # 5f8a <printf>
    exit(1);
    23ec:	4505                	li	a0,1
    23ee:	00004097          	auipc	ra,0x4
    23f2:	824080e7          	jalr	-2012(ra) # 5c12 <exit>

00000000000023f6 <stacktest>:
{
    23f6:	7179                	addi	sp,sp,-48
    23f8:	f406                	sd	ra,40(sp)
    23fa:	f022                	sd	s0,32(sp)
    23fc:	ec26                	sd	s1,24(sp)
    23fe:	1800                	addi	s0,sp,48
    2400:	84aa                	mv	s1,a0
  pid = fork();
    2402:	00004097          	auipc	ra,0x4
    2406:	808080e7          	jalr	-2040(ra) # 5c0a <fork>
  if(pid == 0) {
    240a:	c115                	beqz	a0,242e <stacktest+0x38>
  } else if(pid < 0){
    240c:	04054463          	bltz	a0,2454 <stacktest+0x5e>
  wait(&xstatus);
    2410:	fdc40513          	addi	a0,s0,-36
    2414:	00004097          	auipc	ra,0x4
    2418:	806080e7          	jalr	-2042(ra) # 5c1a <wait>
  if(xstatus == -1)  // kernel killed child?
    241c:	fdc42503          	lw	a0,-36(s0)
    2420:	57fd                	li	a5,-1
    2422:	04f50763          	beq	a0,a5,2470 <stacktest+0x7a>
    exit(xstatus);
    2426:	00003097          	auipc	ra,0x3
    242a:	7ec080e7          	jalr	2028(ra) # 5c12 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    242e:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    2430:	77fd                	lui	a5,0xfffff
    2432:	97ba                	add	a5,a5,a4
    2434:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xfffffffffffef388>
    2438:	85a6                	mv	a1,s1
    243a:	00005517          	auipc	a0,0x5
    243e:	a0e50513          	addi	a0,a0,-1522 # 6e48 <malloc+0xdfe>
    2442:	00004097          	auipc	ra,0x4
    2446:	b48080e7          	jalr	-1208(ra) # 5f8a <printf>
    exit(1);
    244a:	4505                	li	a0,1
    244c:	00003097          	auipc	ra,0x3
    2450:	7c6080e7          	jalr	1990(ra) # 5c12 <exit>
    printf("%s: fork failed\n", s);
    2454:	85a6                	mv	a1,s1
    2456:	00004517          	auipc	a0,0x4
    245a:	5ba50513          	addi	a0,a0,1466 # 6a10 <malloc+0x9c6>
    245e:	00004097          	auipc	ra,0x4
    2462:	b2c080e7          	jalr	-1236(ra) # 5f8a <printf>
    exit(1);
    2466:	4505                	li	a0,1
    2468:	00003097          	auipc	ra,0x3
    246c:	7aa080e7          	jalr	1962(ra) # 5c12 <exit>
    exit(0);
    2470:	4501                	li	a0,0
    2472:	00003097          	auipc	ra,0x3
    2476:	7a0080e7          	jalr	1952(ra) # 5c12 <exit>

000000000000247a <textwrite>:
{
    247a:	7179                	addi	sp,sp,-48
    247c:	f406                	sd	ra,40(sp)
    247e:	f022                	sd	s0,32(sp)
    2480:	ec26                	sd	s1,24(sp)
    2482:	1800                	addi	s0,sp,48
    2484:	84aa                	mv	s1,a0
  pid = fork();
    2486:	00003097          	auipc	ra,0x3
    248a:	784080e7          	jalr	1924(ra) # 5c0a <fork>
  if(pid == 0) {
    248e:	c115                	beqz	a0,24b2 <textwrite+0x38>
  } else if(pid < 0){
    2490:	02054963          	bltz	a0,24c2 <textwrite+0x48>
  wait(&xstatus);
    2494:	fdc40513          	addi	a0,s0,-36
    2498:	00003097          	auipc	ra,0x3
    249c:	782080e7          	jalr	1922(ra) # 5c1a <wait>
  if(xstatus == -1)  // kernel killed child?
    24a0:	fdc42503          	lw	a0,-36(s0)
    24a4:	57fd                	li	a5,-1
    24a6:	02f50c63          	beq	a0,a5,24de <textwrite+0x64>
    exit(xstatus);
    24aa:	00003097          	auipc	ra,0x3
    24ae:	768080e7          	jalr	1896(ra) # 5c12 <exit>
    *addr = 10;
    24b2:	47a9                	li	a5,10
    24b4:	00f02023          	sw	a5,0(zero) # 0 <copyinstr1>
    exit(1);
    24b8:	4505                	li	a0,1
    24ba:	00003097          	auipc	ra,0x3
    24be:	758080e7          	jalr	1880(ra) # 5c12 <exit>
    printf("%s: fork failed\n", s);
    24c2:	85a6                	mv	a1,s1
    24c4:	00004517          	auipc	a0,0x4
    24c8:	54c50513          	addi	a0,a0,1356 # 6a10 <malloc+0x9c6>
    24cc:	00004097          	auipc	ra,0x4
    24d0:	abe080e7          	jalr	-1346(ra) # 5f8a <printf>
    exit(1);
    24d4:	4505                	li	a0,1
    24d6:	00003097          	auipc	ra,0x3
    24da:	73c080e7          	jalr	1852(ra) # 5c12 <exit>
    exit(0);
    24de:	4501                	li	a0,0
    24e0:	00003097          	auipc	ra,0x3
    24e4:	732080e7          	jalr	1842(ra) # 5c12 <exit>

00000000000024e8 <manywrites>:
{
    24e8:	711d                	addi	sp,sp,-96
    24ea:	ec86                	sd	ra,88(sp)
    24ec:	e8a2                	sd	s0,80(sp)
    24ee:	e4a6                	sd	s1,72(sp)
    24f0:	e0ca                	sd	s2,64(sp)
    24f2:	fc4e                	sd	s3,56(sp)
    24f4:	f852                	sd	s4,48(sp)
    24f6:	f456                	sd	s5,40(sp)
    24f8:	f05a                	sd	s6,32(sp)
    24fa:	ec5e                	sd	s7,24(sp)
    24fc:	1080                	addi	s0,sp,96
    24fe:	8b2a                	mv	s6,a0
  for(int ci = 0; ci < nchildren; ci++){
    2500:	4481                	li	s1,0
    2502:	4991                	li	s3,4
    int pid = fork();
    2504:	00003097          	auipc	ra,0x3
    2508:	706080e7          	jalr	1798(ra) # 5c0a <fork>
    250c:	892a                	mv	s2,a0
    if(pid < 0){
    250e:	02054963          	bltz	a0,2540 <manywrites+0x58>
    if(pid == 0){
    2512:	c521                	beqz	a0,255a <manywrites+0x72>
  for(int ci = 0; ci < nchildren; ci++){
    2514:	2485                	addiw	s1,s1,1
    2516:	ff3497e3          	bne	s1,s3,2504 <manywrites+0x1c>
    251a:	4491                	li	s1,4
    int st = 0;
    251c:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    2520:	fa840513          	addi	a0,s0,-88
    2524:	00003097          	auipc	ra,0x3
    2528:	6f6080e7          	jalr	1782(ra) # 5c1a <wait>
    if(st != 0)
    252c:	fa842503          	lw	a0,-88(s0)
    2530:	ed6d                	bnez	a0,262a <manywrites+0x142>
  for(int ci = 0; ci < nchildren; ci++){
    2532:	34fd                	addiw	s1,s1,-1
    2534:	f4e5                	bnez	s1,251c <manywrites+0x34>
  exit(0);
    2536:	4501                	li	a0,0
    2538:	00003097          	auipc	ra,0x3
    253c:	6da080e7          	jalr	1754(ra) # 5c12 <exit>
      printf("fork failed\n");
    2540:	00005517          	auipc	a0,0x5
    2544:	8d850513          	addi	a0,a0,-1832 # 6e18 <malloc+0xdce>
    2548:	00004097          	auipc	ra,0x4
    254c:	a42080e7          	jalr	-1470(ra) # 5f8a <printf>
      exit(1);
    2550:	4505                	li	a0,1
    2552:	00003097          	auipc	ra,0x3
    2556:	6c0080e7          	jalr	1728(ra) # 5c12 <exit>
      name[0] = 'b';
    255a:	06200793          	li	a5,98
    255e:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    2562:	0614879b          	addiw	a5,s1,97
    2566:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    256a:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    256e:	fa840513          	addi	a0,s0,-88
    2572:	00003097          	auipc	ra,0x3
    2576:	6f0080e7          	jalr	1776(ra) # 5c62 <unlink>
    257a:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    257c:	0000aa97          	auipc	s5,0xa
    2580:	6fca8a93          	addi	s5,s5,1788 # cc78 <buf>
        for(int i = 0; i < ci+1; i++){
    2584:	8a4a                	mv	s4,s2
    2586:	0204ce63          	bltz	s1,25c2 <manywrites+0xda>
          int fd = open(name, O_CREATE | O_RDWR);
    258a:	20200593          	li	a1,514
    258e:	fa840513          	addi	a0,s0,-88
    2592:	00003097          	auipc	ra,0x3
    2596:	6c0080e7          	jalr	1728(ra) # 5c52 <open>
    259a:	89aa                	mv	s3,a0
          if(fd < 0){
    259c:	04054763          	bltz	a0,25ea <manywrites+0x102>
          int cc = write(fd, buf, sz);
    25a0:	660d                	lui	a2,0x3
    25a2:	85d6                	mv	a1,s5
    25a4:	00003097          	auipc	ra,0x3
    25a8:	68e080e7          	jalr	1678(ra) # 5c32 <write>
          if(cc != sz){
    25ac:	678d                	lui	a5,0x3
    25ae:	04f51e63          	bne	a0,a5,260a <manywrites+0x122>
          close(fd);
    25b2:	854e                	mv	a0,s3
    25b4:	00003097          	auipc	ra,0x3
    25b8:	686080e7          	jalr	1670(ra) # 5c3a <close>
        for(int i = 0; i < ci+1; i++){
    25bc:	2a05                	addiw	s4,s4,1
    25be:	fd44d6e3          	bge	s1,s4,258a <manywrites+0xa2>
        unlink(name);
    25c2:	fa840513          	addi	a0,s0,-88
    25c6:	00003097          	auipc	ra,0x3
    25ca:	69c080e7          	jalr	1692(ra) # 5c62 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    25ce:	3bfd                	addiw	s7,s7,-1
    25d0:	fa0b9ae3          	bnez	s7,2584 <manywrites+0x9c>
      unlink(name);
    25d4:	fa840513          	addi	a0,s0,-88
    25d8:	00003097          	auipc	ra,0x3
    25dc:	68a080e7          	jalr	1674(ra) # 5c62 <unlink>
      exit(0);
    25e0:	4501                	li	a0,0
    25e2:	00003097          	auipc	ra,0x3
    25e6:	630080e7          	jalr	1584(ra) # 5c12 <exit>
            printf("%s: cannot create %s\n", s, name);
    25ea:	fa840613          	addi	a2,s0,-88
    25ee:	85da                	mv	a1,s6
    25f0:	00005517          	auipc	a0,0x5
    25f4:	88050513          	addi	a0,a0,-1920 # 6e70 <malloc+0xe26>
    25f8:	00004097          	auipc	ra,0x4
    25fc:	992080e7          	jalr	-1646(ra) # 5f8a <printf>
            exit(1);
    2600:	4505                	li	a0,1
    2602:	00003097          	auipc	ra,0x3
    2606:	610080e7          	jalr	1552(ra) # 5c12 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    260a:	86aa                	mv	a3,a0
    260c:	660d                	lui	a2,0x3
    260e:	85da                	mv	a1,s6
    2610:	00004517          	auipc	a0,0x4
    2614:	c4850513          	addi	a0,a0,-952 # 6258 <malloc+0x20e>
    2618:	00004097          	auipc	ra,0x4
    261c:	972080e7          	jalr	-1678(ra) # 5f8a <printf>
            exit(1);
    2620:	4505                	li	a0,1
    2622:	00003097          	auipc	ra,0x3
    2626:	5f0080e7          	jalr	1520(ra) # 5c12 <exit>
      exit(st);
    262a:	00003097          	auipc	ra,0x3
    262e:	5e8080e7          	jalr	1512(ra) # 5c12 <exit>

0000000000002632 <copyinstr3>:
{
    2632:	7179                	addi	sp,sp,-48
    2634:	f406                	sd	ra,40(sp)
    2636:	f022                	sd	s0,32(sp)
    2638:	ec26                	sd	s1,24(sp)
    263a:	1800                	addi	s0,sp,48
  sbrk(8192);
    263c:	6509                	lui	a0,0x2
    263e:	00003097          	auipc	ra,0x3
    2642:	65c080e7          	jalr	1628(ra) # 5c9a <sbrk>
  uint64 top = (uint64) sbrk(0);
    2646:	4501                	li	a0,0
    2648:	00003097          	auipc	ra,0x3
    264c:	652080e7          	jalr	1618(ra) # 5c9a <sbrk>
  if((top % PGSIZE) != 0){
    2650:	6785                	lui	a5,0x1
    2652:	17fd                	addi	a5,a5,-1
    2654:	8fe9                	and	a5,a5,a0
    2656:	e3d1                	bnez	a5,26da <copyinstr3+0xa8>
  top = (uint64) sbrk(0);
    2658:	4501                	li	a0,0
    265a:	00003097          	auipc	ra,0x3
    265e:	640080e7          	jalr	1600(ra) # 5c9a <sbrk>
  if(top % PGSIZE){
    2662:	6785                	lui	a5,0x1
    2664:	17fd                	addi	a5,a5,-1
    2666:	8fe9                	and	a5,a5,a0
    2668:	e7c1                	bnez	a5,26f0 <copyinstr3+0xbe>
  char *b = (char *) (top - 1);
    266a:	fff50493          	addi	s1,a0,-1 # 1fff <linkunlink+0x4b>
  *b = 'x';
    266e:	07800793          	li	a5,120
    2672:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    2676:	8526                	mv	a0,s1
    2678:	00003097          	auipc	ra,0x3
    267c:	5ea080e7          	jalr	1514(ra) # 5c62 <unlink>
  if(ret != -1){
    2680:	57fd                	li	a5,-1
    2682:	08f51463          	bne	a0,a5,270a <copyinstr3+0xd8>
  int fd = open(b, O_CREATE | O_WRONLY);
    2686:	20100593          	li	a1,513
    268a:	8526                	mv	a0,s1
    268c:	00003097          	auipc	ra,0x3
    2690:	5c6080e7          	jalr	1478(ra) # 5c52 <open>
  if(fd != -1){
    2694:	57fd                	li	a5,-1
    2696:	08f51963          	bne	a0,a5,2728 <copyinstr3+0xf6>
  ret = link(b, b);
    269a:	85a6                	mv	a1,s1
    269c:	8526                	mv	a0,s1
    269e:	00003097          	auipc	ra,0x3
    26a2:	5d4080e7          	jalr	1492(ra) # 5c72 <link>
  if(ret != -1){
    26a6:	57fd                	li	a5,-1
    26a8:	08f51f63          	bne	a0,a5,2746 <copyinstr3+0x114>
  char *args[] = { "xx", 0 };
    26ac:	00005797          	auipc	a5,0x5
    26b0:	4bc78793          	addi	a5,a5,1212 # 7b68 <malloc+0x1b1e>
    26b4:	fcf43823          	sd	a5,-48(s0)
    26b8:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    26bc:	fd040593          	addi	a1,s0,-48
    26c0:	8526                	mv	a0,s1
    26c2:	00003097          	auipc	ra,0x3
    26c6:	588080e7          	jalr	1416(ra) # 5c4a <exec>
  if(ret != -1){
    26ca:	57fd                	li	a5,-1
    26cc:	08f51d63          	bne	a0,a5,2766 <copyinstr3+0x134>
}
    26d0:	70a2                	ld	ra,40(sp)
    26d2:	7402                	ld	s0,32(sp)
    26d4:	64e2                	ld	s1,24(sp)
    26d6:	6145                	addi	sp,sp,48
    26d8:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    26da:	6785                	lui	a5,0x1
    26dc:	17fd                	addi	a5,a5,-1
    26de:	8d7d                	and	a0,a0,a5
    26e0:	6785                	lui	a5,0x1
    26e2:	40a7853b          	subw	a0,a5,a0
    26e6:	00003097          	auipc	ra,0x3
    26ea:	5b4080e7          	jalr	1460(ra) # 5c9a <sbrk>
    26ee:	b7ad                	j	2658 <copyinstr3+0x26>
    printf("oops\n");
    26f0:	00004517          	auipc	a0,0x4
    26f4:	79850513          	addi	a0,a0,1944 # 6e88 <malloc+0xe3e>
    26f8:	00004097          	auipc	ra,0x4
    26fc:	892080e7          	jalr	-1902(ra) # 5f8a <printf>
    exit(1);
    2700:	4505                	li	a0,1
    2702:	00003097          	auipc	ra,0x3
    2706:	510080e7          	jalr	1296(ra) # 5c12 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    270a:	862a                	mv	a2,a0
    270c:	85a6                	mv	a1,s1
    270e:	00004517          	auipc	a0,0x4
    2712:	22250513          	addi	a0,a0,546 # 6930 <malloc+0x8e6>
    2716:	00004097          	auipc	ra,0x4
    271a:	874080e7          	jalr	-1932(ra) # 5f8a <printf>
    exit(1);
    271e:	4505                	li	a0,1
    2720:	00003097          	auipc	ra,0x3
    2724:	4f2080e7          	jalr	1266(ra) # 5c12 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    2728:	862a                	mv	a2,a0
    272a:	85a6                	mv	a1,s1
    272c:	00004517          	auipc	a0,0x4
    2730:	22450513          	addi	a0,a0,548 # 6950 <malloc+0x906>
    2734:	00004097          	auipc	ra,0x4
    2738:	856080e7          	jalr	-1962(ra) # 5f8a <printf>
    exit(1);
    273c:	4505                	li	a0,1
    273e:	00003097          	auipc	ra,0x3
    2742:	4d4080e7          	jalr	1236(ra) # 5c12 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    2746:	86aa                	mv	a3,a0
    2748:	8626                	mv	a2,s1
    274a:	85a6                	mv	a1,s1
    274c:	00004517          	auipc	a0,0x4
    2750:	22450513          	addi	a0,a0,548 # 6970 <malloc+0x926>
    2754:	00004097          	auipc	ra,0x4
    2758:	836080e7          	jalr	-1994(ra) # 5f8a <printf>
    exit(1);
    275c:	4505                	li	a0,1
    275e:	00003097          	auipc	ra,0x3
    2762:	4b4080e7          	jalr	1204(ra) # 5c12 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    2766:	567d                	li	a2,-1
    2768:	85a6                	mv	a1,s1
    276a:	00004517          	auipc	a0,0x4
    276e:	22e50513          	addi	a0,a0,558 # 6998 <malloc+0x94e>
    2772:	00004097          	auipc	ra,0x4
    2776:	818080e7          	jalr	-2024(ra) # 5f8a <printf>
    exit(1);
    277a:	4505                	li	a0,1
    277c:	00003097          	auipc	ra,0x3
    2780:	496080e7          	jalr	1174(ra) # 5c12 <exit>

0000000000002784 <rwsbrk>:
{
    2784:	1101                	addi	sp,sp,-32
    2786:	ec06                	sd	ra,24(sp)
    2788:	e822                	sd	s0,16(sp)
    278a:	e426                	sd	s1,8(sp)
    278c:	e04a                	sd	s2,0(sp)
    278e:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    2790:	6509                	lui	a0,0x2
    2792:	00003097          	auipc	ra,0x3
    2796:	508080e7          	jalr	1288(ra) # 5c9a <sbrk>
  if(a == 0xffffffffffffffffLL) {
    279a:	57fd                	li	a5,-1
    279c:	06f50263          	beq	a0,a5,2800 <rwsbrk+0x7c>
    27a0:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    27a2:	7579                	lui	a0,0xffffe
    27a4:	00003097          	auipc	ra,0x3
    27a8:	4f6080e7          	jalr	1270(ra) # 5c9a <sbrk>
    27ac:	57fd                	li	a5,-1
    27ae:	06f50663          	beq	a0,a5,281a <rwsbrk+0x96>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    27b2:	20100593          	li	a1,513
    27b6:	00004517          	auipc	a0,0x4
    27ba:	71250513          	addi	a0,a0,1810 # 6ec8 <malloc+0xe7e>
    27be:	00003097          	auipc	ra,0x3
    27c2:	494080e7          	jalr	1172(ra) # 5c52 <open>
    27c6:	892a                	mv	s2,a0
  if(fd < 0){
    27c8:	06054663          	bltz	a0,2834 <rwsbrk+0xb0>
  n = write(fd, (void*)(a+4096), 1024);
    27cc:	6785                	lui	a5,0x1
    27ce:	94be                	add	s1,s1,a5
    27d0:	40000613          	li	a2,1024
    27d4:	85a6                	mv	a1,s1
    27d6:	00003097          	auipc	ra,0x3
    27da:	45c080e7          	jalr	1116(ra) # 5c32 <write>
  if(n >= 0){
    27de:	06054863          	bltz	a0,284e <rwsbrk+0xca>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    27e2:	862a                	mv	a2,a0
    27e4:	85a6                	mv	a1,s1
    27e6:	00004517          	auipc	a0,0x4
    27ea:	70250513          	addi	a0,a0,1794 # 6ee8 <malloc+0xe9e>
    27ee:	00003097          	auipc	ra,0x3
    27f2:	79c080e7          	jalr	1948(ra) # 5f8a <printf>
    exit(1);
    27f6:	4505                	li	a0,1
    27f8:	00003097          	auipc	ra,0x3
    27fc:	41a080e7          	jalr	1050(ra) # 5c12 <exit>
    printf("sbrk(rwsbrk) failed\n");
    2800:	00004517          	auipc	a0,0x4
    2804:	69050513          	addi	a0,a0,1680 # 6e90 <malloc+0xe46>
    2808:	00003097          	auipc	ra,0x3
    280c:	782080e7          	jalr	1922(ra) # 5f8a <printf>
    exit(1);
    2810:	4505                	li	a0,1
    2812:	00003097          	auipc	ra,0x3
    2816:	400080e7          	jalr	1024(ra) # 5c12 <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    281a:	00004517          	auipc	a0,0x4
    281e:	68e50513          	addi	a0,a0,1678 # 6ea8 <malloc+0xe5e>
    2822:	00003097          	auipc	ra,0x3
    2826:	768080e7          	jalr	1896(ra) # 5f8a <printf>
    exit(1);
    282a:	4505                	li	a0,1
    282c:	00003097          	auipc	ra,0x3
    2830:	3e6080e7          	jalr	998(ra) # 5c12 <exit>
    printf("open(rwsbrk) failed\n");
    2834:	00004517          	auipc	a0,0x4
    2838:	69c50513          	addi	a0,a0,1692 # 6ed0 <malloc+0xe86>
    283c:	00003097          	auipc	ra,0x3
    2840:	74e080e7          	jalr	1870(ra) # 5f8a <printf>
    exit(1);
    2844:	4505                	li	a0,1
    2846:	00003097          	auipc	ra,0x3
    284a:	3cc080e7          	jalr	972(ra) # 5c12 <exit>
  close(fd);
    284e:	854a                	mv	a0,s2
    2850:	00003097          	auipc	ra,0x3
    2854:	3ea080e7          	jalr	1002(ra) # 5c3a <close>
  unlink("rwsbrk");
    2858:	00004517          	auipc	a0,0x4
    285c:	67050513          	addi	a0,a0,1648 # 6ec8 <malloc+0xe7e>
    2860:	00003097          	auipc	ra,0x3
    2864:	402080e7          	jalr	1026(ra) # 5c62 <unlink>
  fd = open("README", O_RDONLY);
    2868:	4581                	li	a1,0
    286a:	00004517          	auipc	a0,0x4
    286e:	af650513          	addi	a0,a0,-1290 # 6360 <malloc+0x316>
    2872:	00003097          	auipc	ra,0x3
    2876:	3e0080e7          	jalr	992(ra) # 5c52 <open>
    287a:	892a                	mv	s2,a0
  if(fd < 0){
    287c:	02054963          	bltz	a0,28ae <rwsbrk+0x12a>
  n = read(fd, (void*)(a+4096), 10);
    2880:	4629                	li	a2,10
    2882:	85a6                	mv	a1,s1
    2884:	00003097          	auipc	ra,0x3
    2888:	3a6080e7          	jalr	934(ra) # 5c2a <read>
  if(n >= 0){
    288c:	02054e63          	bltz	a0,28c8 <rwsbrk+0x144>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    2890:	862a                	mv	a2,a0
    2892:	85a6                	mv	a1,s1
    2894:	00004517          	auipc	a0,0x4
    2898:	68450513          	addi	a0,a0,1668 # 6f18 <malloc+0xece>
    289c:	00003097          	auipc	ra,0x3
    28a0:	6ee080e7          	jalr	1774(ra) # 5f8a <printf>
    exit(1);
    28a4:	4505                	li	a0,1
    28a6:	00003097          	auipc	ra,0x3
    28aa:	36c080e7          	jalr	876(ra) # 5c12 <exit>
    printf("open(rwsbrk) failed\n");
    28ae:	00004517          	auipc	a0,0x4
    28b2:	62250513          	addi	a0,a0,1570 # 6ed0 <malloc+0xe86>
    28b6:	00003097          	auipc	ra,0x3
    28ba:	6d4080e7          	jalr	1748(ra) # 5f8a <printf>
    exit(1);
    28be:	4505                	li	a0,1
    28c0:	00003097          	auipc	ra,0x3
    28c4:	352080e7          	jalr	850(ra) # 5c12 <exit>
  close(fd);
    28c8:	854a                	mv	a0,s2
    28ca:	00003097          	auipc	ra,0x3
    28ce:	370080e7          	jalr	880(ra) # 5c3a <close>
  exit(0);
    28d2:	4501                	li	a0,0
    28d4:	00003097          	auipc	ra,0x3
    28d8:	33e080e7          	jalr	830(ra) # 5c12 <exit>

00000000000028dc <sbrkbasic>:
{
    28dc:	715d                	addi	sp,sp,-80
    28de:	e486                	sd	ra,72(sp)
    28e0:	e0a2                	sd	s0,64(sp)
    28e2:	fc26                	sd	s1,56(sp)
    28e4:	f84a                	sd	s2,48(sp)
    28e6:	f44e                	sd	s3,40(sp)
    28e8:	f052                	sd	s4,32(sp)
    28ea:	ec56                	sd	s5,24(sp)
    28ec:	0880                	addi	s0,sp,80
    28ee:	8aaa                	mv	s5,a0
  pid = fork();
    28f0:	00003097          	auipc	ra,0x3
    28f4:	31a080e7          	jalr	794(ra) # 5c0a <fork>
  if(pid < 0){
    28f8:	02054c63          	bltz	a0,2930 <sbrkbasic+0x54>
  if(pid == 0){
    28fc:	ed21                	bnez	a0,2954 <sbrkbasic+0x78>
    a = sbrk(TOOMUCH);
    28fe:	40000537          	lui	a0,0x40000
    2902:	00003097          	auipc	ra,0x3
    2906:	398080e7          	jalr	920(ra) # 5c9a <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    290a:	57fd                	li	a5,-1
    290c:	02f50f63          	beq	a0,a5,294a <sbrkbasic+0x6e>
    for(b = a; b < a+TOOMUCH; b += 4096){
    2910:	400007b7          	lui	a5,0x40000
    2914:	97aa                	add	a5,a5,a0
      *b = 99;
    2916:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    291a:	6705                	lui	a4,0x1
      *b = 99;
    291c:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fff0388>
    for(b = a; b < a+TOOMUCH; b += 4096){
    2920:	953a                	add	a0,a0,a4
    2922:	fef51de3          	bne	a0,a5,291c <sbrkbasic+0x40>
    exit(1);
    2926:	4505                	li	a0,1
    2928:	00003097          	auipc	ra,0x3
    292c:	2ea080e7          	jalr	746(ra) # 5c12 <exit>
    printf("fork failed in sbrkbasic\n");
    2930:	00004517          	auipc	a0,0x4
    2934:	61050513          	addi	a0,a0,1552 # 6f40 <malloc+0xef6>
    2938:	00003097          	auipc	ra,0x3
    293c:	652080e7          	jalr	1618(ra) # 5f8a <printf>
    exit(1);
    2940:	4505                	li	a0,1
    2942:	00003097          	auipc	ra,0x3
    2946:	2d0080e7          	jalr	720(ra) # 5c12 <exit>
      exit(0);
    294a:	4501                	li	a0,0
    294c:	00003097          	auipc	ra,0x3
    2950:	2c6080e7          	jalr	710(ra) # 5c12 <exit>
  wait(&xstatus);
    2954:	fbc40513          	addi	a0,s0,-68
    2958:	00003097          	auipc	ra,0x3
    295c:	2c2080e7          	jalr	706(ra) # 5c1a <wait>
  if(xstatus == 1){
    2960:	fbc42703          	lw	a4,-68(s0)
    2964:	4785                	li	a5,1
    2966:	00f70e63          	beq	a4,a5,2982 <sbrkbasic+0xa6>
  a = sbrk(0);
    296a:	4501                	li	a0,0
    296c:	00003097          	auipc	ra,0x3
    2970:	32e080e7          	jalr	814(ra) # 5c9a <sbrk>
    2974:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    2976:	4901                	li	s2,0
    *b = 1;
    2978:	4a05                	li	s4,1
  for(i = 0; i < 5000; i++){
    297a:	6985                	lui	s3,0x1
    297c:	38898993          	addi	s3,s3,904 # 1388 <badarg+0x2a>
    2980:	a005                	j	29a0 <sbrkbasic+0xc4>
    printf("%s: too much memory allocated!\n", s);
    2982:	85d6                	mv	a1,s5
    2984:	00004517          	auipc	a0,0x4
    2988:	5dc50513          	addi	a0,a0,1500 # 6f60 <malloc+0xf16>
    298c:	00003097          	auipc	ra,0x3
    2990:	5fe080e7          	jalr	1534(ra) # 5f8a <printf>
    exit(1);
    2994:	4505                	li	a0,1
    2996:	00003097          	auipc	ra,0x3
    299a:	27c080e7          	jalr	636(ra) # 5c12 <exit>
    a = b + 1;
    299e:	84be                	mv	s1,a5
    b = sbrk(1);
    29a0:	4505                	li	a0,1
    29a2:	00003097          	auipc	ra,0x3
    29a6:	2f8080e7          	jalr	760(ra) # 5c9a <sbrk>
    if(b != a){
    29aa:	04951b63          	bne	a0,s1,2a00 <sbrkbasic+0x124>
    *b = 1;
    29ae:	01448023          	sb	s4,0(s1)
    a = b + 1;
    29b2:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    29b6:	2905                	addiw	s2,s2,1
    29b8:	ff3913e3          	bne	s2,s3,299e <sbrkbasic+0xc2>
  pid = fork();
    29bc:	00003097          	auipc	ra,0x3
    29c0:	24e080e7          	jalr	590(ra) # 5c0a <fork>
    29c4:	892a                	mv	s2,a0
  if(pid < 0){
    29c6:	04054e63          	bltz	a0,2a22 <sbrkbasic+0x146>
  c = sbrk(1);
    29ca:	4505                	li	a0,1
    29cc:	00003097          	auipc	ra,0x3
    29d0:	2ce080e7          	jalr	718(ra) # 5c9a <sbrk>
  c = sbrk(1);
    29d4:	4505                	li	a0,1
    29d6:	00003097          	auipc	ra,0x3
    29da:	2c4080e7          	jalr	708(ra) # 5c9a <sbrk>
  if(c != a + 1){
    29de:	0489                	addi	s1,s1,2
    29e0:	04a48f63          	beq	s1,a0,2a3e <sbrkbasic+0x162>
    printf("%s: sbrk test failed post-fork\n", s);
    29e4:	85d6                	mv	a1,s5
    29e6:	00004517          	auipc	a0,0x4
    29ea:	5da50513          	addi	a0,a0,1498 # 6fc0 <malloc+0xf76>
    29ee:	00003097          	auipc	ra,0x3
    29f2:	59c080e7          	jalr	1436(ra) # 5f8a <printf>
    exit(1);
    29f6:	4505                	li	a0,1
    29f8:	00003097          	auipc	ra,0x3
    29fc:	21a080e7          	jalr	538(ra) # 5c12 <exit>
      printf("%s: sbrk test failed %d %x %x\n", s, i, a, b);
    2a00:	872a                	mv	a4,a0
    2a02:	86a6                	mv	a3,s1
    2a04:	864a                	mv	a2,s2
    2a06:	85d6                	mv	a1,s5
    2a08:	00004517          	auipc	a0,0x4
    2a0c:	57850513          	addi	a0,a0,1400 # 6f80 <malloc+0xf36>
    2a10:	00003097          	auipc	ra,0x3
    2a14:	57a080e7          	jalr	1402(ra) # 5f8a <printf>
      exit(1);
    2a18:	4505                	li	a0,1
    2a1a:	00003097          	auipc	ra,0x3
    2a1e:	1f8080e7          	jalr	504(ra) # 5c12 <exit>
    printf("%s: sbrk test fork failed\n", s);
    2a22:	85d6                	mv	a1,s5
    2a24:	00004517          	auipc	a0,0x4
    2a28:	57c50513          	addi	a0,a0,1404 # 6fa0 <malloc+0xf56>
    2a2c:	00003097          	auipc	ra,0x3
    2a30:	55e080e7          	jalr	1374(ra) # 5f8a <printf>
    exit(1);
    2a34:	4505                	li	a0,1
    2a36:	00003097          	auipc	ra,0x3
    2a3a:	1dc080e7          	jalr	476(ra) # 5c12 <exit>
  if(pid == 0)
    2a3e:	00091763          	bnez	s2,2a4c <sbrkbasic+0x170>
    exit(0);
    2a42:	4501                	li	a0,0
    2a44:	00003097          	auipc	ra,0x3
    2a48:	1ce080e7          	jalr	462(ra) # 5c12 <exit>
  wait(&xstatus);
    2a4c:	fbc40513          	addi	a0,s0,-68
    2a50:	00003097          	auipc	ra,0x3
    2a54:	1ca080e7          	jalr	458(ra) # 5c1a <wait>
  exit(xstatus);
    2a58:	fbc42503          	lw	a0,-68(s0)
    2a5c:	00003097          	auipc	ra,0x3
    2a60:	1b6080e7          	jalr	438(ra) # 5c12 <exit>

0000000000002a64 <sbrkmuch>:
{
    2a64:	7179                	addi	sp,sp,-48
    2a66:	f406                	sd	ra,40(sp)
    2a68:	f022                	sd	s0,32(sp)
    2a6a:	ec26                	sd	s1,24(sp)
    2a6c:	e84a                	sd	s2,16(sp)
    2a6e:	e44e                	sd	s3,8(sp)
    2a70:	e052                	sd	s4,0(sp)
    2a72:	1800                	addi	s0,sp,48
    2a74:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2a76:	4501                	li	a0,0
    2a78:	00003097          	auipc	ra,0x3
    2a7c:	222080e7          	jalr	546(ra) # 5c9a <sbrk>
    2a80:	892a                	mv	s2,a0
  a = sbrk(0);
    2a82:	4501                	li	a0,0
    2a84:	00003097          	auipc	ra,0x3
    2a88:	216080e7          	jalr	534(ra) # 5c9a <sbrk>
    2a8c:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2a8e:	06400537          	lui	a0,0x6400
    2a92:	9d05                	subw	a0,a0,s1
    2a94:	00003097          	auipc	ra,0x3
    2a98:	206080e7          	jalr	518(ra) # 5c9a <sbrk>
  if (p != a) {
    2a9c:	0ca49763          	bne	s1,a0,2b6a <sbrkmuch+0x106>
  char *eee = sbrk(0);
    2aa0:	4501                	li	a0,0
    2aa2:	00003097          	auipc	ra,0x3
    2aa6:	1f8080e7          	jalr	504(ra) # 5c9a <sbrk>
  for(char *pp = a; pp < eee; pp += 4096)
    2aaa:	00a4f963          	bgeu	s1,a0,2abc <sbrkmuch+0x58>
    *pp = 1;
    2aae:	4705                	li	a4,1
  for(char *pp = a; pp < eee; pp += 4096)
    2ab0:	6785                	lui	a5,0x1
    *pp = 1;
    2ab2:	00e48023          	sb	a4,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    2ab6:	94be                	add	s1,s1,a5
    2ab8:	fea4ede3          	bltu	s1,a0,2ab2 <sbrkmuch+0x4e>
  *lastaddr = 99;
    2abc:	064007b7          	lui	a5,0x6400
    2ac0:	06300713          	li	a4,99
    2ac4:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63f0387>
  a = sbrk(0);
    2ac8:	4501                	li	a0,0
    2aca:	00003097          	auipc	ra,0x3
    2ace:	1d0080e7          	jalr	464(ra) # 5c9a <sbrk>
    2ad2:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    2ad4:	757d                	lui	a0,0xfffff
    2ad6:	00003097          	auipc	ra,0x3
    2ada:	1c4080e7          	jalr	452(ra) # 5c9a <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    2ade:	57fd                	li	a5,-1
    2ae0:	0af50363          	beq	a0,a5,2b86 <sbrkmuch+0x122>
  c = sbrk(0);
    2ae4:	4501                	li	a0,0
    2ae6:	00003097          	auipc	ra,0x3
    2aea:	1b4080e7          	jalr	436(ra) # 5c9a <sbrk>
  if(c != a - PGSIZE){
    2aee:	77fd                	lui	a5,0xfffff
    2af0:	97a6                	add	a5,a5,s1
    2af2:	0af51863          	bne	a0,a5,2ba2 <sbrkmuch+0x13e>
  a = sbrk(0);
    2af6:	4501                	li	a0,0
    2af8:	00003097          	auipc	ra,0x3
    2afc:	1a2080e7          	jalr	418(ra) # 5c9a <sbrk>
    2b00:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2b02:	6505                	lui	a0,0x1
    2b04:	00003097          	auipc	ra,0x3
    2b08:	196080e7          	jalr	406(ra) # 5c9a <sbrk>
    2b0c:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    2b0e:	0aa49a63          	bne	s1,a0,2bc2 <sbrkmuch+0x15e>
    2b12:	4501                	li	a0,0
    2b14:	00003097          	auipc	ra,0x3
    2b18:	186080e7          	jalr	390(ra) # 5c9a <sbrk>
    2b1c:	6785                	lui	a5,0x1
    2b1e:	97a6                	add	a5,a5,s1
    2b20:	0af51163          	bne	a0,a5,2bc2 <sbrkmuch+0x15e>
  if(*lastaddr == 99){
    2b24:	064007b7          	lui	a5,0x6400
    2b28:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63f0387>
    2b2c:	06300793          	li	a5,99
    2b30:	0af70963          	beq	a4,a5,2be2 <sbrkmuch+0x17e>
  a = sbrk(0);
    2b34:	4501                	li	a0,0
    2b36:	00003097          	auipc	ra,0x3
    2b3a:	164080e7          	jalr	356(ra) # 5c9a <sbrk>
    2b3e:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2b40:	4501                	li	a0,0
    2b42:	00003097          	auipc	ra,0x3
    2b46:	158080e7          	jalr	344(ra) # 5c9a <sbrk>
    2b4a:	40a9053b          	subw	a0,s2,a0
    2b4e:	00003097          	auipc	ra,0x3
    2b52:	14c080e7          	jalr	332(ra) # 5c9a <sbrk>
  if(c != a){
    2b56:	0aa49463          	bne	s1,a0,2bfe <sbrkmuch+0x19a>
}
    2b5a:	70a2                	ld	ra,40(sp)
    2b5c:	7402                	ld	s0,32(sp)
    2b5e:	64e2                	ld	s1,24(sp)
    2b60:	6942                	ld	s2,16(sp)
    2b62:	69a2                	ld	s3,8(sp)
    2b64:	6a02                	ld	s4,0(sp)
    2b66:	6145                	addi	sp,sp,48
    2b68:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    2b6a:	85ce                	mv	a1,s3
    2b6c:	00004517          	auipc	a0,0x4
    2b70:	47450513          	addi	a0,a0,1140 # 6fe0 <malloc+0xf96>
    2b74:	00003097          	auipc	ra,0x3
    2b78:	416080e7          	jalr	1046(ra) # 5f8a <printf>
    exit(1);
    2b7c:	4505                	li	a0,1
    2b7e:	00003097          	auipc	ra,0x3
    2b82:	094080e7          	jalr	148(ra) # 5c12 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    2b86:	85ce                	mv	a1,s3
    2b88:	00004517          	auipc	a0,0x4
    2b8c:	4a050513          	addi	a0,a0,1184 # 7028 <malloc+0xfde>
    2b90:	00003097          	auipc	ra,0x3
    2b94:	3fa080e7          	jalr	1018(ra) # 5f8a <printf>
    exit(1);
    2b98:	4505                	li	a0,1
    2b9a:	00003097          	auipc	ra,0x3
    2b9e:	078080e7          	jalr	120(ra) # 5c12 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    2ba2:	86aa                	mv	a3,a0
    2ba4:	8626                	mv	a2,s1
    2ba6:	85ce                	mv	a1,s3
    2ba8:	00004517          	auipc	a0,0x4
    2bac:	4a050513          	addi	a0,a0,1184 # 7048 <malloc+0xffe>
    2bb0:	00003097          	auipc	ra,0x3
    2bb4:	3da080e7          	jalr	986(ra) # 5f8a <printf>
    exit(1);
    2bb8:	4505                	li	a0,1
    2bba:	00003097          	auipc	ra,0x3
    2bbe:	058080e7          	jalr	88(ra) # 5c12 <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    2bc2:	86d2                	mv	a3,s4
    2bc4:	8626                	mv	a2,s1
    2bc6:	85ce                	mv	a1,s3
    2bc8:	00004517          	auipc	a0,0x4
    2bcc:	4c050513          	addi	a0,a0,1216 # 7088 <malloc+0x103e>
    2bd0:	00003097          	auipc	ra,0x3
    2bd4:	3ba080e7          	jalr	954(ra) # 5f8a <printf>
    exit(1);
    2bd8:	4505                	li	a0,1
    2bda:	00003097          	auipc	ra,0x3
    2bde:	038080e7          	jalr	56(ra) # 5c12 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2be2:	85ce                	mv	a1,s3
    2be4:	00004517          	auipc	a0,0x4
    2be8:	4d450513          	addi	a0,a0,1236 # 70b8 <malloc+0x106e>
    2bec:	00003097          	auipc	ra,0x3
    2bf0:	39e080e7          	jalr	926(ra) # 5f8a <printf>
    exit(1);
    2bf4:	4505                	li	a0,1
    2bf6:	00003097          	auipc	ra,0x3
    2bfa:	01c080e7          	jalr	28(ra) # 5c12 <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    2bfe:	86aa                	mv	a3,a0
    2c00:	8626                	mv	a2,s1
    2c02:	85ce                	mv	a1,s3
    2c04:	00004517          	auipc	a0,0x4
    2c08:	4ec50513          	addi	a0,a0,1260 # 70f0 <malloc+0x10a6>
    2c0c:	00003097          	auipc	ra,0x3
    2c10:	37e080e7          	jalr	894(ra) # 5f8a <printf>
    exit(1);
    2c14:	4505                	li	a0,1
    2c16:	00003097          	auipc	ra,0x3
    2c1a:	ffc080e7          	jalr	-4(ra) # 5c12 <exit>

0000000000002c1e <sbrkarg>:
{
    2c1e:	7179                	addi	sp,sp,-48
    2c20:	f406                	sd	ra,40(sp)
    2c22:	f022                	sd	s0,32(sp)
    2c24:	ec26                	sd	s1,24(sp)
    2c26:	e84a                	sd	s2,16(sp)
    2c28:	e44e                	sd	s3,8(sp)
    2c2a:	1800                	addi	s0,sp,48
    2c2c:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2c2e:	6505                	lui	a0,0x1
    2c30:	00003097          	auipc	ra,0x3
    2c34:	06a080e7          	jalr	106(ra) # 5c9a <sbrk>
    2c38:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2c3a:	20100593          	li	a1,513
    2c3e:	00004517          	auipc	a0,0x4
    2c42:	4da50513          	addi	a0,a0,1242 # 7118 <malloc+0x10ce>
    2c46:	00003097          	auipc	ra,0x3
    2c4a:	00c080e7          	jalr	12(ra) # 5c52 <open>
    2c4e:	84aa                	mv	s1,a0
  unlink("sbrk");
    2c50:	00004517          	auipc	a0,0x4
    2c54:	4c850513          	addi	a0,a0,1224 # 7118 <malloc+0x10ce>
    2c58:	00003097          	auipc	ra,0x3
    2c5c:	00a080e7          	jalr	10(ra) # 5c62 <unlink>
  if(fd < 0)  {
    2c60:	0404c163          	bltz	s1,2ca2 <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2c64:	6605                	lui	a2,0x1
    2c66:	85ca                	mv	a1,s2
    2c68:	8526                	mv	a0,s1
    2c6a:	00003097          	auipc	ra,0x3
    2c6e:	fc8080e7          	jalr	-56(ra) # 5c32 <write>
    2c72:	04054663          	bltz	a0,2cbe <sbrkarg+0xa0>
  close(fd);
    2c76:	8526                	mv	a0,s1
    2c78:	00003097          	auipc	ra,0x3
    2c7c:	fc2080e7          	jalr	-62(ra) # 5c3a <close>
  a = sbrk(PGSIZE);
    2c80:	6505                	lui	a0,0x1
    2c82:	00003097          	auipc	ra,0x3
    2c86:	018080e7          	jalr	24(ra) # 5c9a <sbrk>
  if(pipe((int *) a) != 0){
    2c8a:	00003097          	auipc	ra,0x3
    2c8e:	f98080e7          	jalr	-104(ra) # 5c22 <pipe>
    2c92:	e521                	bnez	a0,2cda <sbrkarg+0xbc>
}
    2c94:	70a2                	ld	ra,40(sp)
    2c96:	7402                	ld	s0,32(sp)
    2c98:	64e2                	ld	s1,24(sp)
    2c9a:	6942                	ld	s2,16(sp)
    2c9c:	69a2                	ld	s3,8(sp)
    2c9e:	6145                	addi	sp,sp,48
    2ca0:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2ca2:	85ce                	mv	a1,s3
    2ca4:	00004517          	auipc	a0,0x4
    2ca8:	47c50513          	addi	a0,a0,1148 # 7120 <malloc+0x10d6>
    2cac:	00003097          	auipc	ra,0x3
    2cb0:	2de080e7          	jalr	734(ra) # 5f8a <printf>
    exit(1);
    2cb4:	4505                	li	a0,1
    2cb6:	00003097          	auipc	ra,0x3
    2cba:	f5c080e7          	jalr	-164(ra) # 5c12 <exit>
    printf("%s: write sbrk failed\n", s);
    2cbe:	85ce                	mv	a1,s3
    2cc0:	00004517          	auipc	a0,0x4
    2cc4:	47850513          	addi	a0,a0,1144 # 7138 <malloc+0x10ee>
    2cc8:	00003097          	auipc	ra,0x3
    2ccc:	2c2080e7          	jalr	706(ra) # 5f8a <printf>
    exit(1);
    2cd0:	4505                	li	a0,1
    2cd2:	00003097          	auipc	ra,0x3
    2cd6:	f40080e7          	jalr	-192(ra) # 5c12 <exit>
    printf("%s: pipe() failed\n", s);
    2cda:	85ce                	mv	a1,s3
    2cdc:	00004517          	auipc	a0,0x4
    2ce0:	e3c50513          	addi	a0,a0,-452 # 6b18 <malloc+0xace>
    2ce4:	00003097          	auipc	ra,0x3
    2ce8:	2a6080e7          	jalr	678(ra) # 5f8a <printf>
    exit(1);
    2cec:	4505                	li	a0,1
    2cee:	00003097          	auipc	ra,0x3
    2cf2:	f24080e7          	jalr	-220(ra) # 5c12 <exit>

0000000000002cf6 <argptest>:
{
    2cf6:	1101                	addi	sp,sp,-32
    2cf8:	ec06                	sd	ra,24(sp)
    2cfa:	e822                	sd	s0,16(sp)
    2cfc:	e426                	sd	s1,8(sp)
    2cfe:	e04a                	sd	s2,0(sp)
    2d00:	1000                	addi	s0,sp,32
    2d02:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2d04:	4581                	li	a1,0
    2d06:	00004517          	auipc	a0,0x4
    2d0a:	44a50513          	addi	a0,a0,1098 # 7150 <malloc+0x1106>
    2d0e:	00003097          	auipc	ra,0x3
    2d12:	f44080e7          	jalr	-188(ra) # 5c52 <open>
  if (fd < 0) {
    2d16:	02054b63          	bltz	a0,2d4c <argptest+0x56>
    2d1a:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2d1c:	4501                	li	a0,0
    2d1e:	00003097          	auipc	ra,0x3
    2d22:	f7c080e7          	jalr	-132(ra) # 5c9a <sbrk>
    2d26:	567d                	li	a2,-1
    2d28:	fff50593          	addi	a1,a0,-1
    2d2c:	8526                	mv	a0,s1
    2d2e:	00003097          	auipc	ra,0x3
    2d32:	efc080e7          	jalr	-260(ra) # 5c2a <read>
  close(fd);
    2d36:	8526                	mv	a0,s1
    2d38:	00003097          	auipc	ra,0x3
    2d3c:	f02080e7          	jalr	-254(ra) # 5c3a <close>
}
    2d40:	60e2                	ld	ra,24(sp)
    2d42:	6442                	ld	s0,16(sp)
    2d44:	64a2                	ld	s1,8(sp)
    2d46:	6902                	ld	s2,0(sp)
    2d48:	6105                	addi	sp,sp,32
    2d4a:	8082                	ret
    printf("%s: open failed\n", s);
    2d4c:	85ca                	mv	a1,s2
    2d4e:	00004517          	auipc	a0,0x4
    2d52:	cda50513          	addi	a0,a0,-806 # 6a28 <malloc+0x9de>
    2d56:	00003097          	auipc	ra,0x3
    2d5a:	234080e7          	jalr	564(ra) # 5f8a <printf>
    exit(1);
    2d5e:	4505                	li	a0,1
    2d60:	00003097          	auipc	ra,0x3
    2d64:	eb2080e7          	jalr	-334(ra) # 5c12 <exit>

0000000000002d68 <sbrkbugs>:
{
    2d68:	1141                	addi	sp,sp,-16
    2d6a:	e406                	sd	ra,8(sp)
    2d6c:	e022                	sd	s0,0(sp)
    2d6e:	0800                	addi	s0,sp,16
  int pid = fork();
    2d70:	00003097          	auipc	ra,0x3
    2d74:	e9a080e7          	jalr	-358(ra) # 5c0a <fork>
  if(pid < 0){
    2d78:	02054363          	bltz	a0,2d9e <sbrkbugs+0x36>
  if(pid == 0){
    2d7c:	ed15                	bnez	a0,2db8 <sbrkbugs+0x50>
    int sz = (uint64) sbrk(0);
    2d7e:	00003097          	auipc	ra,0x3
    2d82:	f1c080e7          	jalr	-228(ra) # 5c9a <sbrk>
    sbrk(-sz);
    2d86:	40a0053b          	negw	a0,a0
    2d8a:	2501                	sext.w	a0,a0
    2d8c:	00003097          	auipc	ra,0x3
    2d90:	f0e080e7          	jalr	-242(ra) # 5c9a <sbrk>
    exit(0);
    2d94:	4501                	li	a0,0
    2d96:	00003097          	auipc	ra,0x3
    2d9a:	e7c080e7          	jalr	-388(ra) # 5c12 <exit>
    printf("fork failed\n");
    2d9e:	00004517          	auipc	a0,0x4
    2da2:	07a50513          	addi	a0,a0,122 # 6e18 <malloc+0xdce>
    2da6:	00003097          	auipc	ra,0x3
    2daa:	1e4080e7          	jalr	484(ra) # 5f8a <printf>
    exit(1);
    2dae:	4505                	li	a0,1
    2db0:	00003097          	auipc	ra,0x3
    2db4:	e62080e7          	jalr	-414(ra) # 5c12 <exit>
  wait(0);
    2db8:	4501                	li	a0,0
    2dba:	00003097          	auipc	ra,0x3
    2dbe:	e60080e7          	jalr	-416(ra) # 5c1a <wait>
  pid = fork();
    2dc2:	00003097          	auipc	ra,0x3
    2dc6:	e48080e7          	jalr	-440(ra) # 5c0a <fork>
  if(pid < 0){
    2dca:	02054563          	bltz	a0,2df4 <sbrkbugs+0x8c>
  if(pid == 0){
    2dce:	e121                	bnez	a0,2e0e <sbrkbugs+0xa6>
    int sz = (uint64) sbrk(0);
    2dd0:	00003097          	auipc	ra,0x3
    2dd4:	eca080e7          	jalr	-310(ra) # 5c9a <sbrk>
    sbrk(-(sz - 3500));
    2dd8:	6785                	lui	a5,0x1
    2dda:	dac7879b          	addiw	a5,a5,-596
    2dde:	40a7853b          	subw	a0,a5,a0
    2de2:	00003097          	auipc	ra,0x3
    2de6:	eb8080e7          	jalr	-328(ra) # 5c9a <sbrk>
    exit(0);
    2dea:	4501                	li	a0,0
    2dec:	00003097          	auipc	ra,0x3
    2df0:	e26080e7          	jalr	-474(ra) # 5c12 <exit>
    printf("fork failed\n");
    2df4:	00004517          	auipc	a0,0x4
    2df8:	02450513          	addi	a0,a0,36 # 6e18 <malloc+0xdce>
    2dfc:	00003097          	auipc	ra,0x3
    2e00:	18e080e7          	jalr	398(ra) # 5f8a <printf>
    exit(1);
    2e04:	4505                	li	a0,1
    2e06:	00003097          	auipc	ra,0x3
    2e0a:	e0c080e7          	jalr	-500(ra) # 5c12 <exit>
  wait(0);
    2e0e:	4501                	li	a0,0
    2e10:	00003097          	auipc	ra,0x3
    2e14:	e0a080e7          	jalr	-502(ra) # 5c1a <wait>
  pid = fork();
    2e18:	00003097          	auipc	ra,0x3
    2e1c:	df2080e7          	jalr	-526(ra) # 5c0a <fork>
  if(pid < 0){
    2e20:	02054a63          	bltz	a0,2e54 <sbrkbugs+0xec>
  if(pid == 0){
    2e24:	e529                	bnez	a0,2e6e <sbrkbugs+0x106>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2e26:	00003097          	auipc	ra,0x3
    2e2a:	e74080e7          	jalr	-396(ra) # 5c9a <sbrk>
    2e2e:	67ad                	lui	a5,0xb
    2e30:	8007879b          	addiw	a5,a5,-2048
    2e34:	40a7853b          	subw	a0,a5,a0
    2e38:	00003097          	auipc	ra,0x3
    2e3c:	e62080e7          	jalr	-414(ra) # 5c9a <sbrk>
    sbrk(-10);
    2e40:	5559                	li	a0,-10
    2e42:	00003097          	auipc	ra,0x3
    2e46:	e58080e7          	jalr	-424(ra) # 5c9a <sbrk>
    exit(0);
    2e4a:	4501                	li	a0,0
    2e4c:	00003097          	auipc	ra,0x3
    2e50:	dc6080e7          	jalr	-570(ra) # 5c12 <exit>
    printf("fork failed\n");
    2e54:	00004517          	auipc	a0,0x4
    2e58:	fc450513          	addi	a0,a0,-60 # 6e18 <malloc+0xdce>
    2e5c:	00003097          	auipc	ra,0x3
    2e60:	12e080e7          	jalr	302(ra) # 5f8a <printf>
    exit(1);
    2e64:	4505                	li	a0,1
    2e66:	00003097          	auipc	ra,0x3
    2e6a:	dac080e7          	jalr	-596(ra) # 5c12 <exit>
  wait(0);
    2e6e:	4501                	li	a0,0
    2e70:	00003097          	auipc	ra,0x3
    2e74:	daa080e7          	jalr	-598(ra) # 5c1a <wait>
  exit(0);
    2e78:	4501                	li	a0,0
    2e7a:	00003097          	auipc	ra,0x3
    2e7e:	d98080e7          	jalr	-616(ra) # 5c12 <exit>

0000000000002e82 <sbrklast>:
{
    2e82:	7179                	addi	sp,sp,-48
    2e84:	f406                	sd	ra,40(sp)
    2e86:	f022                	sd	s0,32(sp)
    2e88:	ec26                	sd	s1,24(sp)
    2e8a:	e84a                	sd	s2,16(sp)
    2e8c:	e44e                	sd	s3,8(sp)
    2e8e:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    2e90:	4501                	li	a0,0
    2e92:	00003097          	auipc	ra,0x3
    2e96:	e08080e7          	jalr	-504(ra) # 5c9a <sbrk>
  if((top % 4096) != 0)
    2e9a:	6785                	lui	a5,0x1
    2e9c:	17fd                	addi	a5,a5,-1
    2e9e:	8fe9                	and	a5,a5,a0
    2ea0:	efc1                	bnez	a5,2f38 <sbrklast+0xb6>
  sbrk(4096);
    2ea2:	6505                	lui	a0,0x1
    2ea4:	00003097          	auipc	ra,0x3
    2ea8:	df6080e7          	jalr	-522(ra) # 5c9a <sbrk>
  sbrk(10);
    2eac:	4529                	li	a0,10
    2eae:	00003097          	auipc	ra,0x3
    2eb2:	dec080e7          	jalr	-532(ra) # 5c9a <sbrk>
  sbrk(-20);
    2eb6:	5531                	li	a0,-20
    2eb8:	00003097          	auipc	ra,0x3
    2ebc:	de2080e7          	jalr	-542(ra) # 5c9a <sbrk>
  top = (uint64) sbrk(0);
    2ec0:	4501                	li	a0,0
    2ec2:	00003097          	auipc	ra,0x3
    2ec6:	dd8080e7          	jalr	-552(ra) # 5c9a <sbrk>
    2eca:	892a                	mv	s2,a0
  char *p = (char *) (top - 64);
    2ecc:	fc050493          	addi	s1,a0,-64 # fc0 <linktest+0xb8>
  p[0] = 'x';
    2ed0:	07800793          	li	a5,120
    2ed4:	fcf50023          	sb	a5,-64(a0)
  p[1] = '\0';
    2ed8:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    2edc:	20200593          	li	a1,514
    2ee0:	8526                	mv	a0,s1
    2ee2:	00003097          	auipc	ra,0x3
    2ee6:	d70080e7          	jalr	-656(ra) # 5c52 <open>
    2eea:	89aa                	mv	s3,a0
  write(fd, p, 1);
    2eec:	4605                	li	a2,1
    2eee:	85a6                	mv	a1,s1
    2ef0:	00003097          	auipc	ra,0x3
    2ef4:	d42080e7          	jalr	-702(ra) # 5c32 <write>
  close(fd);
    2ef8:	854e                	mv	a0,s3
    2efa:	00003097          	auipc	ra,0x3
    2efe:	d40080e7          	jalr	-704(ra) # 5c3a <close>
  fd = open(p, O_RDWR);
    2f02:	4589                	li	a1,2
    2f04:	8526                	mv	a0,s1
    2f06:	00003097          	auipc	ra,0x3
    2f0a:	d4c080e7          	jalr	-692(ra) # 5c52 <open>
  p[0] = '\0';
    2f0e:	fc090023          	sb	zero,-64(s2)
  read(fd, p, 1);
    2f12:	4605                	li	a2,1
    2f14:	85a6                	mv	a1,s1
    2f16:	00003097          	auipc	ra,0x3
    2f1a:	d14080e7          	jalr	-748(ra) # 5c2a <read>
  if(p[0] != 'x')
    2f1e:	fc094703          	lbu	a4,-64(s2)
    2f22:	07800793          	li	a5,120
    2f26:	02f71463          	bne	a4,a5,2f4e <sbrklast+0xcc>
}
    2f2a:	70a2                	ld	ra,40(sp)
    2f2c:	7402                	ld	s0,32(sp)
    2f2e:	64e2                	ld	s1,24(sp)
    2f30:	6942                	ld	s2,16(sp)
    2f32:	69a2                	ld	s3,8(sp)
    2f34:	6145                	addi	sp,sp,48
    2f36:	8082                	ret
    sbrk(4096 - (top % 4096));
    2f38:	6785                	lui	a5,0x1
    2f3a:	17fd                	addi	a5,a5,-1
    2f3c:	8d7d                	and	a0,a0,a5
    2f3e:	6785                	lui	a5,0x1
    2f40:	40a7853b          	subw	a0,a5,a0
    2f44:	00003097          	auipc	ra,0x3
    2f48:	d56080e7          	jalr	-682(ra) # 5c9a <sbrk>
    2f4c:	bf99                	j	2ea2 <sbrklast+0x20>
    exit(1);
    2f4e:	4505                	li	a0,1
    2f50:	00003097          	auipc	ra,0x3
    2f54:	cc2080e7          	jalr	-830(ra) # 5c12 <exit>

0000000000002f58 <sbrk8000>:
{
    2f58:	1141                	addi	sp,sp,-16
    2f5a:	e406                	sd	ra,8(sp)
    2f5c:	e022                	sd	s0,0(sp)
    2f5e:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    2f60:	80000537          	lui	a0,0x80000
    2f64:	0511                	addi	a0,a0,4
    2f66:	00003097          	auipc	ra,0x3
    2f6a:	d34080e7          	jalr	-716(ra) # 5c9a <sbrk>
  volatile char *top = sbrk(0);
    2f6e:	4501                	li	a0,0
    2f70:	00003097          	auipc	ra,0x3
    2f74:	d2a080e7          	jalr	-726(ra) # 5c9a <sbrk>
  *(top-1) = *(top-1) + 1;
    2f78:	fff54783          	lbu	a5,-1(a0) # ffffffff7fffffff <base+0xffffffff7fff0387>
    2f7c:	0785                	addi	a5,a5,1
    2f7e:	0ff7f793          	andi	a5,a5,255
    2f82:	fef50fa3          	sb	a5,-1(a0)
}
    2f86:	60a2                	ld	ra,8(sp)
    2f88:	6402                	ld	s0,0(sp)
    2f8a:	0141                	addi	sp,sp,16
    2f8c:	8082                	ret

0000000000002f8e <execout>:
{
    2f8e:	715d                	addi	sp,sp,-80
    2f90:	e486                	sd	ra,72(sp)
    2f92:	e0a2                	sd	s0,64(sp)
    2f94:	fc26                	sd	s1,56(sp)
    2f96:	f84a                	sd	s2,48(sp)
    2f98:	f44e                	sd	s3,40(sp)
    2f9a:	f052                	sd	s4,32(sp)
    2f9c:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    2f9e:	4901                	li	s2,0
    2fa0:	49bd                	li	s3,15
    int pid = fork();
    2fa2:	00003097          	auipc	ra,0x3
    2fa6:	c68080e7          	jalr	-920(ra) # 5c0a <fork>
    2faa:	84aa                	mv	s1,a0
    if(pid < 0){
    2fac:	02054063          	bltz	a0,2fcc <execout+0x3e>
    } else if(pid == 0){
    2fb0:	c91d                	beqz	a0,2fe6 <execout+0x58>
      wait((int*)0);
    2fb2:	4501                	li	a0,0
    2fb4:	00003097          	auipc	ra,0x3
    2fb8:	c66080e7          	jalr	-922(ra) # 5c1a <wait>
  for(int avail = 0; avail < 15; avail++){
    2fbc:	2905                	addiw	s2,s2,1
    2fbe:	ff3912e3          	bne	s2,s3,2fa2 <execout+0x14>
  exit(0);
    2fc2:	4501                	li	a0,0
    2fc4:	00003097          	auipc	ra,0x3
    2fc8:	c4e080e7          	jalr	-946(ra) # 5c12 <exit>
      printf("fork failed\n");
    2fcc:	00004517          	auipc	a0,0x4
    2fd0:	e4c50513          	addi	a0,a0,-436 # 6e18 <malloc+0xdce>
    2fd4:	00003097          	auipc	ra,0x3
    2fd8:	fb6080e7          	jalr	-74(ra) # 5f8a <printf>
      exit(1);
    2fdc:	4505                	li	a0,1
    2fde:	00003097          	auipc	ra,0x3
    2fe2:	c34080e7          	jalr	-972(ra) # 5c12 <exit>
        if(a == 0xffffffffffffffffLL)
    2fe6:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    2fe8:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    2fea:	6505                	lui	a0,0x1
    2fec:	00003097          	auipc	ra,0x3
    2ff0:	cae080e7          	jalr	-850(ra) # 5c9a <sbrk>
        if(a == 0xffffffffffffffffLL)
    2ff4:	01350763          	beq	a0,s3,3002 <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    2ff8:	6785                	lui	a5,0x1
    2ffa:	97aa                	add	a5,a5,a0
    2ffc:	ff478fa3          	sb	s4,-1(a5) # fff <linktest+0xf7>
      while(1){
    3000:	b7ed                	j	2fea <execout+0x5c>
      for(int i = 0; i < avail; i++)
    3002:	01205a63          	blez	s2,3016 <execout+0x88>
        sbrk(-4096);
    3006:	757d                	lui	a0,0xfffff
    3008:	00003097          	auipc	ra,0x3
    300c:	c92080e7          	jalr	-878(ra) # 5c9a <sbrk>
      for(int i = 0; i < avail; i++)
    3010:	2485                	addiw	s1,s1,1
    3012:	ff249ae3          	bne	s1,s2,3006 <execout+0x78>
      close(1);
    3016:	4505                	li	a0,1
    3018:	00003097          	auipc	ra,0x3
    301c:	c22080e7          	jalr	-990(ra) # 5c3a <close>
      char *args[] = { "echo", "x", 0 };
    3020:	00003517          	auipc	a0,0x3
    3024:	16850513          	addi	a0,a0,360 # 6188 <malloc+0x13e>
    3028:	faa43c23          	sd	a0,-72(s0)
    302c:	00003797          	auipc	a5,0x3
    3030:	1cc78793          	addi	a5,a5,460 # 61f8 <malloc+0x1ae>
    3034:	fcf43023          	sd	a5,-64(s0)
    3038:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    303c:	fb840593          	addi	a1,s0,-72
    3040:	00003097          	auipc	ra,0x3
    3044:	c0a080e7          	jalr	-1014(ra) # 5c4a <exec>
      exit(0);
    3048:	4501                	li	a0,0
    304a:	00003097          	auipc	ra,0x3
    304e:	bc8080e7          	jalr	-1080(ra) # 5c12 <exit>

0000000000003052 <fourteen>:
{
    3052:	1101                	addi	sp,sp,-32
    3054:	ec06                	sd	ra,24(sp)
    3056:	e822                	sd	s0,16(sp)
    3058:	e426                	sd	s1,8(sp)
    305a:	1000                	addi	s0,sp,32
    305c:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    305e:	00004517          	auipc	a0,0x4
    3062:	2ca50513          	addi	a0,a0,714 # 7328 <malloc+0x12de>
    3066:	00003097          	auipc	ra,0x3
    306a:	c14080e7          	jalr	-1004(ra) # 5c7a <mkdir>
    306e:	e165                	bnez	a0,314e <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    3070:	00004517          	auipc	a0,0x4
    3074:	11050513          	addi	a0,a0,272 # 7180 <malloc+0x1136>
    3078:	00003097          	auipc	ra,0x3
    307c:	c02080e7          	jalr	-1022(ra) # 5c7a <mkdir>
    3080:	e56d                	bnez	a0,316a <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    3082:	20000593          	li	a1,512
    3086:	00004517          	auipc	a0,0x4
    308a:	15250513          	addi	a0,a0,338 # 71d8 <malloc+0x118e>
    308e:	00003097          	auipc	ra,0x3
    3092:	bc4080e7          	jalr	-1084(ra) # 5c52 <open>
  if(fd < 0){
    3096:	0e054863          	bltz	a0,3186 <fourteen+0x134>
  close(fd);
    309a:	00003097          	auipc	ra,0x3
    309e:	ba0080e7          	jalr	-1120(ra) # 5c3a <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    30a2:	4581                	li	a1,0
    30a4:	00004517          	auipc	a0,0x4
    30a8:	1ac50513          	addi	a0,a0,428 # 7250 <malloc+0x1206>
    30ac:	00003097          	auipc	ra,0x3
    30b0:	ba6080e7          	jalr	-1114(ra) # 5c52 <open>
  if(fd < 0){
    30b4:	0e054763          	bltz	a0,31a2 <fourteen+0x150>
  close(fd);
    30b8:	00003097          	auipc	ra,0x3
    30bc:	b82080e7          	jalr	-1150(ra) # 5c3a <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    30c0:	00004517          	auipc	a0,0x4
    30c4:	20050513          	addi	a0,a0,512 # 72c0 <malloc+0x1276>
    30c8:	00003097          	auipc	ra,0x3
    30cc:	bb2080e7          	jalr	-1102(ra) # 5c7a <mkdir>
    30d0:	c57d                	beqz	a0,31be <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    30d2:	00004517          	auipc	a0,0x4
    30d6:	24650513          	addi	a0,a0,582 # 7318 <malloc+0x12ce>
    30da:	00003097          	auipc	ra,0x3
    30de:	ba0080e7          	jalr	-1120(ra) # 5c7a <mkdir>
    30e2:	cd65                	beqz	a0,31da <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    30e4:	00004517          	auipc	a0,0x4
    30e8:	23450513          	addi	a0,a0,564 # 7318 <malloc+0x12ce>
    30ec:	00003097          	auipc	ra,0x3
    30f0:	b76080e7          	jalr	-1162(ra) # 5c62 <unlink>
  unlink("12345678901234/12345678901234");
    30f4:	00004517          	auipc	a0,0x4
    30f8:	1cc50513          	addi	a0,a0,460 # 72c0 <malloc+0x1276>
    30fc:	00003097          	auipc	ra,0x3
    3100:	b66080e7          	jalr	-1178(ra) # 5c62 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    3104:	00004517          	auipc	a0,0x4
    3108:	14c50513          	addi	a0,a0,332 # 7250 <malloc+0x1206>
    310c:	00003097          	auipc	ra,0x3
    3110:	b56080e7          	jalr	-1194(ra) # 5c62 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    3114:	00004517          	auipc	a0,0x4
    3118:	0c450513          	addi	a0,a0,196 # 71d8 <malloc+0x118e>
    311c:	00003097          	auipc	ra,0x3
    3120:	b46080e7          	jalr	-1210(ra) # 5c62 <unlink>
  unlink("12345678901234/123456789012345");
    3124:	00004517          	auipc	a0,0x4
    3128:	05c50513          	addi	a0,a0,92 # 7180 <malloc+0x1136>
    312c:	00003097          	auipc	ra,0x3
    3130:	b36080e7          	jalr	-1226(ra) # 5c62 <unlink>
  unlink("12345678901234");
    3134:	00004517          	auipc	a0,0x4
    3138:	1f450513          	addi	a0,a0,500 # 7328 <malloc+0x12de>
    313c:	00003097          	auipc	ra,0x3
    3140:	b26080e7          	jalr	-1242(ra) # 5c62 <unlink>
}
    3144:	60e2                	ld	ra,24(sp)
    3146:	6442                	ld	s0,16(sp)
    3148:	64a2                	ld	s1,8(sp)
    314a:	6105                	addi	sp,sp,32
    314c:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    314e:	85a6                	mv	a1,s1
    3150:	00004517          	auipc	a0,0x4
    3154:	00850513          	addi	a0,a0,8 # 7158 <malloc+0x110e>
    3158:	00003097          	auipc	ra,0x3
    315c:	e32080e7          	jalr	-462(ra) # 5f8a <printf>
    exit(1);
    3160:	4505                	li	a0,1
    3162:	00003097          	auipc	ra,0x3
    3166:	ab0080e7          	jalr	-1360(ra) # 5c12 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    316a:	85a6                	mv	a1,s1
    316c:	00004517          	auipc	a0,0x4
    3170:	03450513          	addi	a0,a0,52 # 71a0 <malloc+0x1156>
    3174:	00003097          	auipc	ra,0x3
    3178:	e16080e7          	jalr	-490(ra) # 5f8a <printf>
    exit(1);
    317c:	4505                	li	a0,1
    317e:	00003097          	auipc	ra,0x3
    3182:	a94080e7          	jalr	-1388(ra) # 5c12 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    3186:	85a6                	mv	a1,s1
    3188:	00004517          	auipc	a0,0x4
    318c:	08050513          	addi	a0,a0,128 # 7208 <malloc+0x11be>
    3190:	00003097          	auipc	ra,0x3
    3194:	dfa080e7          	jalr	-518(ra) # 5f8a <printf>
    exit(1);
    3198:	4505                	li	a0,1
    319a:	00003097          	auipc	ra,0x3
    319e:	a78080e7          	jalr	-1416(ra) # 5c12 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    31a2:	85a6                	mv	a1,s1
    31a4:	00004517          	auipc	a0,0x4
    31a8:	0dc50513          	addi	a0,a0,220 # 7280 <malloc+0x1236>
    31ac:	00003097          	auipc	ra,0x3
    31b0:	dde080e7          	jalr	-546(ra) # 5f8a <printf>
    exit(1);
    31b4:	4505                	li	a0,1
    31b6:	00003097          	auipc	ra,0x3
    31ba:	a5c080e7          	jalr	-1444(ra) # 5c12 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    31be:	85a6                	mv	a1,s1
    31c0:	00004517          	auipc	a0,0x4
    31c4:	12050513          	addi	a0,a0,288 # 72e0 <malloc+0x1296>
    31c8:	00003097          	auipc	ra,0x3
    31cc:	dc2080e7          	jalr	-574(ra) # 5f8a <printf>
    exit(1);
    31d0:	4505                	li	a0,1
    31d2:	00003097          	auipc	ra,0x3
    31d6:	a40080e7          	jalr	-1472(ra) # 5c12 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    31da:	85a6                	mv	a1,s1
    31dc:	00004517          	auipc	a0,0x4
    31e0:	15c50513          	addi	a0,a0,348 # 7338 <malloc+0x12ee>
    31e4:	00003097          	auipc	ra,0x3
    31e8:	da6080e7          	jalr	-602(ra) # 5f8a <printf>
    exit(1);
    31ec:	4505                	li	a0,1
    31ee:	00003097          	auipc	ra,0x3
    31f2:	a24080e7          	jalr	-1500(ra) # 5c12 <exit>

00000000000031f6 <diskfull>:
{
    31f6:	b9010113          	addi	sp,sp,-1136
    31fa:	46113423          	sd	ra,1128(sp)
    31fe:	46813023          	sd	s0,1120(sp)
    3202:	44913c23          	sd	s1,1112(sp)
    3206:	45213823          	sd	s2,1104(sp)
    320a:	45313423          	sd	s3,1096(sp)
    320e:	45413023          	sd	s4,1088(sp)
    3212:	43513c23          	sd	s5,1080(sp)
    3216:	43613823          	sd	s6,1072(sp)
    321a:	43713423          	sd	s7,1064(sp)
    321e:	43813023          	sd	s8,1056(sp)
    3222:	47010413          	addi	s0,sp,1136
    3226:	8c2a                	mv	s8,a0
  unlink("diskfulldir");
    3228:	00004517          	auipc	a0,0x4
    322c:	14850513          	addi	a0,a0,328 # 7370 <malloc+0x1326>
    3230:	00003097          	auipc	ra,0x3
    3234:	a32080e7          	jalr	-1486(ra) # 5c62 <unlink>
  for(fi = 0; done == 0; fi++){
    3238:	4a01                	li	s4,0
    name[0] = 'b';
    323a:	06200b13          	li	s6,98
    name[1] = 'i';
    323e:	06900a93          	li	s5,105
    name[2] = 'g';
    3242:	06700993          	li	s3,103
    3246:	10c00b93          	li	s7,268
    324a:	aabd                	j	33c8 <diskfull+0x1d2>
      printf("%s: could not create file %s\n", s, name);
    324c:	b9040613          	addi	a2,s0,-1136
    3250:	85e2                	mv	a1,s8
    3252:	00004517          	auipc	a0,0x4
    3256:	12e50513          	addi	a0,a0,302 # 7380 <malloc+0x1336>
    325a:	00003097          	auipc	ra,0x3
    325e:	d30080e7          	jalr	-720(ra) # 5f8a <printf>
      break;
    3262:	a821                	j	327a <diskfull+0x84>
        close(fd);
    3264:	854a                	mv	a0,s2
    3266:	00003097          	auipc	ra,0x3
    326a:	9d4080e7          	jalr	-1580(ra) # 5c3a <close>
    close(fd);
    326e:	854a                	mv	a0,s2
    3270:	00003097          	auipc	ra,0x3
    3274:	9ca080e7          	jalr	-1590(ra) # 5c3a <close>
  for(fi = 0; done == 0; fi++){
    3278:	2a05                	addiw	s4,s4,1
  for(int i = 0; i < nzz; i++){
    327a:	4481                	li	s1,0
    name[0] = 'z';
    327c:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    3280:	08000993          	li	s3,128
    name[0] = 'z';
    3284:	bb240823          	sb	s2,-1104(s0)
    name[1] = 'z';
    3288:	bb2408a3          	sb	s2,-1103(s0)
    name[2] = '0' + (i / 32);
    328c:	41f4d79b          	sraiw	a5,s1,0x1f
    3290:	01b7d71b          	srliw	a4,a5,0x1b
    3294:	009707bb          	addw	a5,a4,s1
    3298:	4057d69b          	sraiw	a3,a5,0x5
    329c:	0306869b          	addiw	a3,a3,48
    32a0:	bad40923          	sb	a3,-1102(s0)
    name[3] = '0' + (i % 32);
    32a4:	8bfd                	andi	a5,a5,31
    32a6:	9f99                	subw	a5,a5,a4
    32a8:	0307879b          	addiw	a5,a5,48
    32ac:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    32b0:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    32b4:	bb040513          	addi	a0,s0,-1104
    32b8:	00003097          	auipc	ra,0x3
    32bc:	9aa080e7          	jalr	-1622(ra) # 5c62 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    32c0:	60200593          	li	a1,1538
    32c4:	bb040513          	addi	a0,s0,-1104
    32c8:	00003097          	auipc	ra,0x3
    32cc:	98a080e7          	jalr	-1654(ra) # 5c52 <open>
    if(fd < 0)
    32d0:	00054963          	bltz	a0,32e2 <diskfull+0xec>
    close(fd);
    32d4:	00003097          	auipc	ra,0x3
    32d8:	966080e7          	jalr	-1690(ra) # 5c3a <close>
  for(int i = 0; i < nzz; i++){
    32dc:	2485                	addiw	s1,s1,1
    32de:	fb3493e3          	bne	s1,s3,3284 <diskfull+0x8e>
  if(mkdir("diskfulldir") == 0)
    32e2:	00004517          	auipc	a0,0x4
    32e6:	08e50513          	addi	a0,a0,142 # 7370 <malloc+0x1326>
    32ea:	00003097          	auipc	ra,0x3
    32ee:	990080e7          	jalr	-1648(ra) # 5c7a <mkdir>
    32f2:	12050963          	beqz	a0,3424 <diskfull+0x22e>
  unlink("diskfulldir");
    32f6:	00004517          	auipc	a0,0x4
    32fa:	07a50513          	addi	a0,a0,122 # 7370 <malloc+0x1326>
    32fe:	00003097          	auipc	ra,0x3
    3302:	964080e7          	jalr	-1692(ra) # 5c62 <unlink>
  for(int i = 0; i < nzz; i++){
    3306:	4481                	li	s1,0
    name[0] = 'z';
    3308:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    330c:	08000993          	li	s3,128
    name[0] = 'z';
    3310:	bb240823          	sb	s2,-1104(s0)
    name[1] = 'z';
    3314:	bb2408a3          	sb	s2,-1103(s0)
    name[2] = '0' + (i / 32);
    3318:	41f4d79b          	sraiw	a5,s1,0x1f
    331c:	01b7d71b          	srliw	a4,a5,0x1b
    3320:	009707bb          	addw	a5,a4,s1
    3324:	4057d69b          	sraiw	a3,a5,0x5
    3328:	0306869b          	addiw	a3,a3,48
    332c:	bad40923          	sb	a3,-1102(s0)
    name[3] = '0' + (i % 32);
    3330:	8bfd                	andi	a5,a5,31
    3332:	9f99                	subw	a5,a5,a4
    3334:	0307879b          	addiw	a5,a5,48
    3338:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    333c:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    3340:	bb040513          	addi	a0,s0,-1104
    3344:	00003097          	auipc	ra,0x3
    3348:	91e080e7          	jalr	-1762(ra) # 5c62 <unlink>
  for(int i = 0; i < nzz; i++){
    334c:	2485                	addiw	s1,s1,1
    334e:	fd3491e3          	bne	s1,s3,3310 <diskfull+0x11a>
  for(int i = 0; i < fi; i++){
    3352:	03405e63          	blez	s4,338e <diskfull+0x198>
    3356:	4481                	li	s1,0
    name[0] = 'b';
    3358:	06200a93          	li	s5,98
    name[1] = 'i';
    335c:	06900993          	li	s3,105
    name[2] = 'g';
    3360:	06700913          	li	s2,103
    name[0] = 'b';
    3364:	bb540823          	sb	s5,-1104(s0)
    name[1] = 'i';
    3368:	bb3408a3          	sb	s3,-1103(s0)
    name[2] = 'g';
    336c:	bb240923          	sb	s2,-1102(s0)
    name[3] = '0' + i;
    3370:	0304879b          	addiw	a5,s1,48
    3374:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    3378:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    337c:	bb040513          	addi	a0,s0,-1104
    3380:	00003097          	auipc	ra,0x3
    3384:	8e2080e7          	jalr	-1822(ra) # 5c62 <unlink>
  for(int i = 0; i < fi; i++){
    3388:	2485                	addiw	s1,s1,1
    338a:	fd449de3          	bne	s1,s4,3364 <diskfull+0x16e>
}
    338e:	46813083          	ld	ra,1128(sp)
    3392:	46013403          	ld	s0,1120(sp)
    3396:	45813483          	ld	s1,1112(sp)
    339a:	45013903          	ld	s2,1104(sp)
    339e:	44813983          	ld	s3,1096(sp)
    33a2:	44013a03          	ld	s4,1088(sp)
    33a6:	43813a83          	ld	s5,1080(sp)
    33aa:	43013b03          	ld	s6,1072(sp)
    33ae:	42813b83          	ld	s7,1064(sp)
    33b2:	42013c03          	ld	s8,1056(sp)
    33b6:	47010113          	addi	sp,sp,1136
    33ba:	8082                	ret
    close(fd);
    33bc:	854a                	mv	a0,s2
    33be:	00003097          	auipc	ra,0x3
    33c2:	87c080e7          	jalr	-1924(ra) # 5c3a <close>
  for(fi = 0; done == 0; fi++){
    33c6:	2a05                	addiw	s4,s4,1
    name[0] = 'b';
    33c8:	b9640823          	sb	s6,-1136(s0)
    name[1] = 'i';
    33cc:	b95408a3          	sb	s5,-1135(s0)
    name[2] = 'g';
    33d0:	b9340923          	sb	s3,-1134(s0)
    name[3] = '0' + fi;
    33d4:	030a079b          	addiw	a5,s4,48
    33d8:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    33dc:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    33e0:	b9040513          	addi	a0,s0,-1136
    33e4:	00003097          	auipc	ra,0x3
    33e8:	87e080e7          	jalr	-1922(ra) # 5c62 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    33ec:	60200593          	li	a1,1538
    33f0:	b9040513          	addi	a0,s0,-1136
    33f4:	00003097          	auipc	ra,0x3
    33f8:	85e080e7          	jalr	-1954(ra) # 5c52 <open>
    33fc:	892a                	mv	s2,a0
    if(fd < 0){
    33fe:	e40547e3          	bltz	a0,324c <diskfull+0x56>
    3402:	84de                	mv	s1,s7
      if(write(fd, buf, BSIZE) != BSIZE){
    3404:	40000613          	li	a2,1024
    3408:	bb040593          	addi	a1,s0,-1104
    340c:	854a                	mv	a0,s2
    340e:	00003097          	auipc	ra,0x3
    3412:	824080e7          	jalr	-2012(ra) # 5c32 <write>
    3416:	40000793          	li	a5,1024
    341a:	e4f515e3          	bne	a0,a5,3264 <diskfull+0x6e>
    for(int i = 0; i < MAXFILE; i++){
    341e:	34fd                	addiw	s1,s1,-1
    3420:	f0f5                	bnez	s1,3404 <diskfull+0x20e>
    3422:	bf69                	j	33bc <diskfull+0x1c6>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n");
    3424:	00004517          	auipc	a0,0x4
    3428:	f7c50513          	addi	a0,a0,-132 # 73a0 <malloc+0x1356>
    342c:	00003097          	auipc	ra,0x3
    3430:	b5e080e7          	jalr	-1186(ra) # 5f8a <printf>
    3434:	b5c9                	j	32f6 <diskfull+0x100>

0000000000003436 <iputtest>:
{
    3436:	1101                	addi	sp,sp,-32
    3438:	ec06                	sd	ra,24(sp)
    343a:	e822                	sd	s0,16(sp)
    343c:	e426                	sd	s1,8(sp)
    343e:	1000                	addi	s0,sp,32
    3440:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    3442:	00004517          	auipc	a0,0x4
    3446:	f8e50513          	addi	a0,a0,-114 # 73d0 <malloc+0x1386>
    344a:	00003097          	auipc	ra,0x3
    344e:	830080e7          	jalr	-2000(ra) # 5c7a <mkdir>
    3452:	04054563          	bltz	a0,349c <iputtest+0x66>
  if(chdir("iputdir") < 0){
    3456:	00004517          	auipc	a0,0x4
    345a:	f7a50513          	addi	a0,a0,-134 # 73d0 <malloc+0x1386>
    345e:	00003097          	auipc	ra,0x3
    3462:	824080e7          	jalr	-2012(ra) # 5c82 <chdir>
    3466:	04054963          	bltz	a0,34b8 <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    346a:	00004517          	auipc	a0,0x4
    346e:	fa650513          	addi	a0,a0,-90 # 7410 <malloc+0x13c6>
    3472:	00002097          	auipc	ra,0x2
    3476:	7f0080e7          	jalr	2032(ra) # 5c62 <unlink>
    347a:	04054d63          	bltz	a0,34d4 <iputtest+0x9e>
  if(chdir("/") < 0){
    347e:	00004517          	auipc	a0,0x4
    3482:	fc250513          	addi	a0,a0,-62 # 7440 <malloc+0x13f6>
    3486:	00002097          	auipc	ra,0x2
    348a:	7fc080e7          	jalr	2044(ra) # 5c82 <chdir>
    348e:	06054163          	bltz	a0,34f0 <iputtest+0xba>
}
    3492:	60e2                	ld	ra,24(sp)
    3494:	6442                	ld	s0,16(sp)
    3496:	64a2                	ld	s1,8(sp)
    3498:	6105                	addi	sp,sp,32
    349a:	8082                	ret
    printf("%s: mkdir failed\n", s);
    349c:	85a6                	mv	a1,s1
    349e:	00004517          	auipc	a0,0x4
    34a2:	f3a50513          	addi	a0,a0,-198 # 73d8 <malloc+0x138e>
    34a6:	00003097          	auipc	ra,0x3
    34aa:	ae4080e7          	jalr	-1308(ra) # 5f8a <printf>
    exit(1);
    34ae:	4505                	li	a0,1
    34b0:	00002097          	auipc	ra,0x2
    34b4:	762080e7          	jalr	1890(ra) # 5c12 <exit>
    printf("%s: chdir iputdir failed\n", s);
    34b8:	85a6                	mv	a1,s1
    34ba:	00004517          	auipc	a0,0x4
    34be:	f3650513          	addi	a0,a0,-202 # 73f0 <malloc+0x13a6>
    34c2:	00003097          	auipc	ra,0x3
    34c6:	ac8080e7          	jalr	-1336(ra) # 5f8a <printf>
    exit(1);
    34ca:	4505                	li	a0,1
    34cc:	00002097          	auipc	ra,0x2
    34d0:	746080e7          	jalr	1862(ra) # 5c12 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    34d4:	85a6                	mv	a1,s1
    34d6:	00004517          	auipc	a0,0x4
    34da:	f4a50513          	addi	a0,a0,-182 # 7420 <malloc+0x13d6>
    34de:	00003097          	auipc	ra,0x3
    34e2:	aac080e7          	jalr	-1364(ra) # 5f8a <printf>
    exit(1);
    34e6:	4505                	li	a0,1
    34e8:	00002097          	auipc	ra,0x2
    34ec:	72a080e7          	jalr	1834(ra) # 5c12 <exit>
    printf("%s: chdir / failed\n", s);
    34f0:	85a6                	mv	a1,s1
    34f2:	00004517          	auipc	a0,0x4
    34f6:	f5650513          	addi	a0,a0,-170 # 7448 <malloc+0x13fe>
    34fa:	00003097          	auipc	ra,0x3
    34fe:	a90080e7          	jalr	-1392(ra) # 5f8a <printf>
    exit(1);
    3502:	4505                	li	a0,1
    3504:	00002097          	auipc	ra,0x2
    3508:	70e080e7          	jalr	1806(ra) # 5c12 <exit>

000000000000350c <exitiputtest>:
{
    350c:	7179                	addi	sp,sp,-48
    350e:	f406                	sd	ra,40(sp)
    3510:	f022                	sd	s0,32(sp)
    3512:	ec26                	sd	s1,24(sp)
    3514:	1800                	addi	s0,sp,48
    3516:	84aa                	mv	s1,a0
  pid = fork();
    3518:	00002097          	auipc	ra,0x2
    351c:	6f2080e7          	jalr	1778(ra) # 5c0a <fork>
  if(pid < 0){
    3520:	04054663          	bltz	a0,356c <exitiputtest+0x60>
  if(pid == 0){
    3524:	ed45                	bnez	a0,35dc <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    3526:	00004517          	auipc	a0,0x4
    352a:	eaa50513          	addi	a0,a0,-342 # 73d0 <malloc+0x1386>
    352e:	00002097          	auipc	ra,0x2
    3532:	74c080e7          	jalr	1868(ra) # 5c7a <mkdir>
    3536:	04054963          	bltz	a0,3588 <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    353a:	00004517          	auipc	a0,0x4
    353e:	e9650513          	addi	a0,a0,-362 # 73d0 <malloc+0x1386>
    3542:	00002097          	auipc	ra,0x2
    3546:	740080e7          	jalr	1856(ra) # 5c82 <chdir>
    354a:	04054d63          	bltz	a0,35a4 <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    354e:	00004517          	auipc	a0,0x4
    3552:	ec250513          	addi	a0,a0,-318 # 7410 <malloc+0x13c6>
    3556:	00002097          	auipc	ra,0x2
    355a:	70c080e7          	jalr	1804(ra) # 5c62 <unlink>
    355e:	06054163          	bltz	a0,35c0 <exitiputtest+0xb4>
    exit(0);
    3562:	4501                	li	a0,0
    3564:	00002097          	auipc	ra,0x2
    3568:	6ae080e7          	jalr	1710(ra) # 5c12 <exit>
    printf("%s: fork failed\n", s);
    356c:	85a6                	mv	a1,s1
    356e:	00003517          	auipc	a0,0x3
    3572:	4a250513          	addi	a0,a0,1186 # 6a10 <malloc+0x9c6>
    3576:	00003097          	auipc	ra,0x3
    357a:	a14080e7          	jalr	-1516(ra) # 5f8a <printf>
    exit(1);
    357e:	4505                	li	a0,1
    3580:	00002097          	auipc	ra,0x2
    3584:	692080e7          	jalr	1682(ra) # 5c12 <exit>
      printf("%s: mkdir failed\n", s);
    3588:	85a6                	mv	a1,s1
    358a:	00004517          	auipc	a0,0x4
    358e:	e4e50513          	addi	a0,a0,-434 # 73d8 <malloc+0x138e>
    3592:	00003097          	auipc	ra,0x3
    3596:	9f8080e7          	jalr	-1544(ra) # 5f8a <printf>
      exit(1);
    359a:	4505                	li	a0,1
    359c:	00002097          	auipc	ra,0x2
    35a0:	676080e7          	jalr	1654(ra) # 5c12 <exit>
      printf("%s: child chdir failed\n", s);
    35a4:	85a6                	mv	a1,s1
    35a6:	00004517          	auipc	a0,0x4
    35aa:	eba50513          	addi	a0,a0,-326 # 7460 <malloc+0x1416>
    35ae:	00003097          	auipc	ra,0x3
    35b2:	9dc080e7          	jalr	-1572(ra) # 5f8a <printf>
      exit(1);
    35b6:	4505                	li	a0,1
    35b8:	00002097          	auipc	ra,0x2
    35bc:	65a080e7          	jalr	1626(ra) # 5c12 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    35c0:	85a6                	mv	a1,s1
    35c2:	00004517          	auipc	a0,0x4
    35c6:	e5e50513          	addi	a0,a0,-418 # 7420 <malloc+0x13d6>
    35ca:	00003097          	auipc	ra,0x3
    35ce:	9c0080e7          	jalr	-1600(ra) # 5f8a <printf>
      exit(1);
    35d2:	4505                	li	a0,1
    35d4:	00002097          	auipc	ra,0x2
    35d8:	63e080e7          	jalr	1598(ra) # 5c12 <exit>
  wait(&xstatus);
    35dc:	fdc40513          	addi	a0,s0,-36
    35e0:	00002097          	auipc	ra,0x2
    35e4:	63a080e7          	jalr	1594(ra) # 5c1a <wait>
  exit(xstatus);
    35e8:	fdc42503          	lw	a0,-36(s0)
    35ec:	00002097          	auipc	ra,0x2
    35f0:	626080e7          	jalr	1574(ra) # 5c12 <exit>

00000000000035f4 <dirtest>:
{
    35f4:	1101                	addi	sp,sp,-32
    35f6:	ec06                	sd	ra,24(sp)
    35f8:	e822                	sd	s0,16(sp)
    35fa:	e426                	sd	s1,8(sp)
    35fc:	1000                	addi	s0,sp,32
    35fe:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    3600:	00004517          	auipc	a0,0x4
    3604:	e7850513          	addi	a0,a0,-392 # 7478 <malloc+0x142e>
    3608:	00002097          	auipc	ra,0x2
    360c:	672080e7          	jalr	1650(ra) # 5c7a <mkdir>
    3610:	04054563          	bltz	a0,365a <dirtest+0x66>
  if(chdir("dir0") < 0){
    3614:	00004517          	auipc	a0,0x4
    3618:	e6450513          	addi	a0,a0,-412 # 7478 <malloc+0x142e>
    361c:	00002097          	auipc	ra,0x2
    3620:	666080e7          	jalr	1638(ra) # 5c82 <chdir>
    3624:	04054963          	bltz	a0,3676 <dirtest+0x82>
  if(chdir("..") < 0){
    3628:	00004517          	auipc	a0,0x4
    362c:	e7050513          	addi	a0,a0,-400 # 7498 <malloc+0x144e>
    3630:	00002097          	auipc	ra,0x2
    3634:	652080e7          	jalr	1618(ra) # 5c82 <chdir>
    3638:	04054d63          	bltz	a0,3692 <dirtest+0x9e>
  if(unlink("dir0") < 0){
    363c:	00004517          	auipc	a0,0x4
    3640:	e3c50513          	addi	a0,a0,-452 # 7478 <malloc+0x142e>
    3644:	00002097          	auipc	ra,0x2
    3648:	61e080e7          	jalr	1566(ra) # 5c62 <unlink>
    364c:	06054163          	bltz	a0,36ae <dirtest+0xba>
}
    3650:	60e2                	ld	ra,24(sp)
    3652:	6442                	ld	s0,16(sp)
    3654:	64a2                	ld	s1,8(sp)
    3656:	6105                	addi	sp,sp,32
    3658:	8082                	ret
    printf("%s: mkdir failed\n", s);
    365a:	85a6                	mv	a1,s1
    365c:	00004517          	auipc	a0,0x4
    3660:	d7c50513          	addi	a0,a0,-644 # 73d8 <malloc+0x138e>
    3664:	00003097          	auipc	ra,0x3
    3668:	926080e7          	jalr	-1754(ra) # 5f8a <printf>
    exit(1);
    366c:	4505                	li	a0,1
    366e:	00002097          	auipc	ra,0x2
    3672:	5a4080e7          	jalr	1444(ra) # 5c12 <exit>
    printf("%s: chdir dir0 failed\n", s);
    3676:	85a6                	mv	a1,s1
    3678:	00004517          	auipc	a0,0x4
    367c:	e0850513          	addi	a0,a0,-504 # 7480 <malloc+0x1436>
    3680:	00003097          	auipc	ra,0x3
    3684:	90a080e7          	jalr	-1782(ra) # 5f8a <printf>
    exit(1);
    3688:	4505                	li	a0,1
    368a:	00002097          	auipc	ra,0x2
    368e:	588080e7          	jalr	1416(ra) # 5c12 <exit>
    printf("%s: chdir .. failed\n", s);
    3692:	85a6                	mv	a1,s1
    3694:	00004517          	auipc	a0,0x4
    3698:	e0c50513          	addi	a0,a0,-500 # 74a0 <malloc+0x1456>
    369c:	00003097          	auipc	ra,0x3
    36a0:	8ee080e7          	jalr	-1810(ra) # 5f8a <printf>
    exit(1);
    36a4:	4505                	li	a0,1
    36a6:	00002097          	auipc	ra,0x2
    36aa:	56c080e7          	jalr	1388(ra) # 5c12 <exit>
    printf("%s: unlink dir0 failed\n", s);
    36ae:	85a6                	mv	a1,s1
    36b0:	00004517          	auipc	a0,0x4
    36b4:	e0850513          	addi	a0,a0,-504 # 74b8 <malloc+0x146e>
    36b8:	00003097          	auipc	ra,0x3
    36bc:	8d2080e7          	jalr	-1838(ra) # 5f8a <printf>
    exit(1);
    36c0:	4505                	li	a0,1
    36c2:	00002097          	auipc	ra,0x2
    36c6:	550080e7          	jalr	1360(ra) # 5c12 <exit>

00000000000036ca <subdir>:
{
    36ca:	1101                	addi	sp,sp,-32
    36cc:	ec06                	sd	ra,24(sp)
    36ce:	e822                	sd	s0,16(sp)
    36d0:	e426                	sd	s1,8(sp)
    36d2:	e04a                	sd	s2,0(sp)
    36d4:	1000                	addi	s0,sp,32
    36d6:	892a                	mv	s2,a0
  unlink("ff");
    36d8:	00004517          	auipc	a0,0x4
    36dc:	f2850513          	addi	a0,a0,-216 # 7600 <malloc+0x15b6>
    36e0:	00002097          	auipc	ra,0x2
    36e4:	582080e7          	jalr	1410(ra) # 5c62 <unlink>
  if(mkdir("dd") != 0){
    36e8:	00004517          	auipc	a0,0x4
    36ec:	de850513          	addi	a0,a0,-536 # 74d0 <malloc+0x1486>
    36f0:	00002097          	auipc	ra,0x2
    36f4:	58a080e7          	jalr	1418(ra) # 5c7a <mkdir>
    36f8:	38051663          	bnez	a0,3a84 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    36fc:	20200593          	li	a1,514
    3700:	00004517          	auipc	a0,0x4
    3704:	df050513          	addi	a0,a0,-528 # 74f0 <malloc+0x14a6>
    3708:	00002097          	auipc	ra,0x2
    370c:	54a080e7          	jalr	1354(ra) # 5c52 <open>
    3710:	84aa                	mv	s1,a0
  if(fd < 0){
    3712:	38054763          	bltz	a0,3aa0 <subdir+0x3d6>
  write(fd, "ff", 2);
    3716:	4609                	li	a2,2
    3718:	00004597          	auipc	a1,0x4
    371c:	ee858593          	addi	a1,a1,-280 # 7600 <malloc+0x15b6>
    3720:	00002097          	auipc	ra,0x2
    3724:	512080e7          	jalr	1298(ra) # 5c32 <write>
  close(fd);
    3728:	8526                	mv	a0,s1
    372a:	00002097          	auipc	ra,0x2
    372e:	510080e7          	jalr	1296(ra) # 5c3a <close>
  if(unlink("dd") >= 0){
    3732:	00004517          	auipc	a0,0x4
    3736:	d9e50513          	addi	a0,a0,-610 # 74d0 <malloc+0x1486>
    373a:	00002097          	auipc	ra,0x2
    373e:	528080e7          	jalr	1320(ra) # 5c62 <unlink>
    3742:	36055d63          	bgez	a0,3abc <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    3746:	00004517          	auipc	a0,0x4
    374a:	e0250513          	addi	a0,a0,-510 # 7548 <malloc+0x14fe>
    374e:	00002097          	auipc	ra,0x2
    3752:	52c080e7          	jalr	1324(ra) # 5c7a <mkdir>
    3756:	38051163          	bnez	a0,3ad8 <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    375a:	20200593          	li	a1,514
    375e:	00004517          	auipc	a0,0x4
    3762:	e1250513          	addi	a0,a0,-494 # 7570 <malloc+0x1526>
    3766:	00002097          	auipc	ra,0x2
    376a:	4ec080e7          	jalr	1260(ra) # 5c52 <open>
    376e:	84aa                	mv	s1,a0
  if(fd < 0){
    3770:	38054263          	bltz	a0,3af4 <subdir+0x42a>
  write(fd, "FF", 2);
    3774:	4609                	li	a2,2
    3776:	00004597          	auipc	a1,0x4
    377a:	e2a58593          	addi	a1,a1,-470 # 75a0 <malloc+0x1556>
    377e:	00002097          	auipc	ra,0x2
    3782:	4b4080e7          	jalr	1204(ra) # 5c32 <write>
  close(fd);
    3786:	8526                	mv	a0,s1
    3788:	00002097          	auipc	ra,0x2
    378c:	4b2080e7          	jalr	1202(ra) # 5c3a <close>
  fd = open("dd/dd/../ff", 0);
    3790:	4581                	li	a1,0
    3792:	00004517          	auipc	a0,0x4
    3796:	e1650513          	addi	a0,a0,-490 # 75a8 <malloc+0x155e>
    379a:	00002097          	auipc	ra,0x2
    379e:	4b8080e7          	jalr	1208(ra) # 5c52 <open>
    37a2:	84aa                	mv	s1,a0
  if(fd < 0){
    37a4:	36054663          	bltz	a0,3b10 <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    37a8:	660d                	lui	a2,0x3
    37aa:	00009597          	auipc	a1,0x9
    37ae:	4ce58593          	addi	a1,a1,1230 # cc78 <buf>
    37b2:	00002097          	auipc	ra,0x2
    37b6:	478080e7          	jalr	1144(ra) # 5c2a <read>
  if(cc != 2 || buf[0] != 'f'){
    37ba:	4789                	li	a5,2
    37bc:	36f51863          	bne	a0,a5,3b2c <subdir+0x462>
    37c0:	00009717          	auipc	a4,0x9
    37c4:	4b874703          	lbu	a4,1208(a4) # cc78 <buf>
    37c8:	06600793          	li	a5,102
    37cc:	36f71063          	bne	a4,a5,3b2c <subdir+0x462>
  close(fd);
    37d0:	8526                	mv	a0,s1
    37d2:	00002097          	auipc	ra,0x2
    37d6:	468080e7          	jalr	1128(ra) # 5c3a <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    37da:	00004597          	auipc	a1,0x4
    37de:	e1e58593          	addi	a1,a1,-482 # 75f8 <malloc+0x15ae>
    37e2:	00004517          	auipc	a0,0x4
    37e6:	d8e50513          	addi	a0,a0,-626 # 7570 <malloc+0x1526>
    37ea:	00002097          	auipc	ra,0x2
    37ee:	488080e7          	jalr	1160(ra) # 5c72 <link>
    37f2:	34051b63          	bnez	a0,3b48 <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    37f6:	00004517          	auipc	a0,0x4
    37fa:	d7a50513          	addi	a0,a0,-646 # 7570 <malloc+0x1526>
    37fe:	00002097          	auipc	ra,0x2
    3802:	464080e7          	jalr	1124(ra) # 5c62 <unlink>
    3806:	34051f63          	bnez	a0,3b64 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    380a:	4581                	li	a1,0
    380c:	00004517          	auipc	a0,0x4
    3810:	d6450513          	addi	a0,a0,-668 # 7570 <malloc+0x1526>
    3814:	00002097          	auipc	ra,0x2
    3818:	43e080e7          	jalr	1086(ra) # 5c52 <open>
    381c:	36055263          	bgez	a0,3b80 <subdir+0x4b6>
  if(chdir("dd") != 0){
    3820:	00004517          	auipc	a0,0x4
    3824:	cb050513          	addi	a0,a0,-848 # 74d0 <malloc+0x1486>
    3828:	00002097          	auipc	ra,0x2
    382c:	45a080e7          	jalr	1114(ra) # 5c82 <chdir>
    3830:	36051663          	bnez	a0,3b9c <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    3834:	00004517          	auipc	a0,0x4
    3838:	e5c50513          	addi	a0,a0,-420 # 7690 <malloc+0x1646>
    383c:	00002097          	auipc	ra,0x2
    3840:	446080e7          	jalr	1094(ra) # 5c82 <chdir>
    3844:	36051a63          	bnez	a0,3bb8 <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    3848:	00004517          	auipc	a0,0x4
    384c:	e7850513          	addi	a0,a0,-392 # 76c0 <malloc+0x1676>
    3850:	00002097          	auipc	ra,0x2
    3854:	432080e7          	jalr	1074(ra) # 5c82 <chdir>
    3858:	36051e63          	bnez	a0,3bd4 <subdir+0x50a>
  if(chdir("./..") != 0){
    385c:	00004517          	auipc	a0,0x4
    3860:	e9450513          	addi	a0,a0,-364 # 76f0 <malloc+0x16a6>
    3864:	00002097          	auipc	ra,0x2
    3868:	41e080e7          	jalr	1054(ra) # 5c82 <chdir>
    386c:	38051263          	bnez	a0,3bf0 <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    3870:	4581                	li	a1,0
    3872:	00004517          	auipc	a0,0x4
    3876:	d8650513          	addi	a0,a0,-634 # 75f8 <malloc+0x15ae>
    387a:	00002097          	auipc	ra,0x2
    387e:	3d8080e7          	jalr	984(ra) # 5c52 <open>
    3882:	84aa                	mv	s1,a0
  if(fd < 0){
    3884:	38054463          	bltz	a0,3c0c <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    3888:	660d                	lui	a2,0x3
    388a:	00009597          	auipc	a1,0x9
    388e:	3ee58593          	addi	a1,a1,1006 # cc78 <buf>
    3892:	00002097          	auipc	ra,0x2
    3896:	398080e7          	jalr	920(ra) # 5c2a <read>
    389a:	4789                	li	a5,2
    389c:	38f51663          	bne	a0,a5,3c28 <subdir+0x55e>
  close(fd);
    38a0:	8526                	mv	a0,s1
    38a2:	00002097          	auipc	ra,0x2
    38a6:	398080e7          	jalr	920(ra) # 5c3a <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    38aa:	4581                	li	a1,0
    38ac:	00004517          	auipc	a0,0x4
    38b0:	cc450513          	addi	a0,a0,-828 # 7570 <malloc+0x1526>
    38b4:	00002097          	auipc	ra,0x2
    38b8:	39e080e7          	jalr	926(ra) # 5c52 <open>
    38bc:	38055463          	bgez	a0,3c44 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    38c0:	20200593          	li	a1,514
    38c4:	00004517          	auipc	a0,0x4
    38c8:	ebc50513          	addi	a0,a0,-324 # 7780 <malloc+0x1736>
    38cc:	00002097          	auipc	ra,0x2
    38d0:	386080e7          	jalr	902(ra) # 5c52 <open>
    38d4:	38055663          	bgez	a0,3c60 <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    38d8:	20200593          	li	a1,514
    38dc:	00004517          	auipc	a0,0x4
    38e0:	ed450513          	addi	a0,a0,-300 # 77b0 <malloc+0x1766>
    38e4:	00002097          	auipc	ra,0x2
    38e8:	36e080e7          	jalr	878(ra) # 5c52 <open>
    38ec:	38055863          	bgez	a0,3c7c <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    38f0:	20000593          	li	a1,512
    38f4:	00004517          	auipc	a0,0x4
    38f8:	bdc50513          	addi	a0,a0,-1060 # 74d0 <malloc+0x1486>
    38fc:	00002097          	auipc	ra,0x2
    3900:	356080e7          	jalr	854(ra) # 5c52 <open>
    3904:	38055a63          	bgez	a0,3c98 <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    3908:	4589                	li	a1,2
    390a:	00004517          	auipc	a0,0x4
    390e:	bc650513          	addi	a0,a0,-1082 # 74d0 <malloc+0x1486>
    3912:	00002097          	auipc	ra,0x2
    3916:	340080e7          	jalr	832(ra) # 5c52 <open>
    391a:	38055d63          	bgez	a0,3cb4 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    391e:	4585                	li	a1,1
    3920:	00004517          	auipc	a0,0x4
    3924:	bb050513          	addi	a0,a0,-1104 # 74d0 <malloc+0x1486>
    3928:	00002097          	auipc	ra,0x2
    392c:	32a080e7          	jalr	810(ra) # 5c52 <open>
    3930:	3a055063          	bgez	a0,3cd0 <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    3934:	00004597          	auipc	a1,0x4
    3938:	f0c58593          	addi	a1,a1,-244 # 7840 <malloc+0x17f6>
    393c:	00004517          	auipc	a0,0x4
    3940:	e4450513          	addi	a0,a0,-444 # 7780 <malloc+0x1736>
    3944:	00002097          	auipc	ra,0x2
    3948:	32e080e7          	jalr	814(ra) # 5c72 <link>
    394c:	3a050063          	beqz	a0,3cec <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    3950:	00004597          	auipc	a1,0x4
    3954:	ef058593          	addi	a1,a1,-272 # 7840 <malloc+0x17f6>
    3958:	00004517          	auipc	a0,0x4
    395c:	e5850513          	addi	a0,a0,-424 # 77b0 <malloc+0x1766>
    3960:	00002097          	auipc	ra,0x2
    3964:	312080e7          	jalr	786(ra) # 5c72 <link>
    3968:	3a050063          	beqz	a0,3d08 <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    396c:	00004597          	auipc	a1,0x4
    3970:	c8c58593          	addi	a1,a1,-884 # 75f8 <malloc+0x15ae>
    3974:	00004517          	auipc	a0,0x4
    3978:	b7c50513          	addi	a0,a0,-1156 # 74f0 <malloc+0x14a6>
    397c:	00002097          	auipc	ra,0x2
    3980:	2f6080e7          	jalr	758(ra) # 5c72 <link>
    3984:	3a050063          	beqz	a0,3d24 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    3988:	00004517          	auipc	a0,0x4
    398c:	df850513          	addi	a0,a0,-520 # 7780 <malloc+0x1736>
    3990:	00002097          	auipc	ra,0x2
    3994:	2ea080e7          	jalr	746(ra) # 5c7a <mkdir>
    3998:	3a050463          	beqz	a0,3d40 <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    399c:	00004517          	auipc	a0,0x4
    39a0:	e1450513          	addi	a0,a0,-492 # 77b0 <malloc+0x1766>
    39a4:	00002097          	auipc	ra,0x2
    39a8:	2d6080e7          	jalr	726(ra) # 5c7a <mkdir>
    39ac:	3a050863          	beqz	a0,3d5c <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    39b0:	00004517          	auipc	a0,0x4
    39b4:	c4850513          	addi	a0,a0,-952 # 75f8 <malloc+0x15ae>
    39b8:	00002097          	auipc	ra,0x2
    39bc:	2c2080e7          	jalr	706(ra) # 5c7a <mkdir>
    39c0:	3a050c63          	beqz	a0,3d78 <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    39c4:	00004517          	auipc	a0,0x4
    39c8:	dec50513          	addi	a0,a0,-532 # 77b0 <malloc+0x1766>
    39cc:	00002097          	auipc	ra,0x2
    39d0:	296080e7          	jalr	662(ra) # 5c62 <unlink>
    39d4:	3c050063          	beqz	a0,3d94 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    39d8:	00004517          	auipc	a0,0x4
    39dc:	da850513          	addi	a0,a0,-600 # 7780 <malloc+0x1736>
    39e0:	00002097          	auipc	ra,0x2
    39e4:	282080e7          	jalr	642(ra) # 5c62 <unlink>
    39e8:	3c050463          	beqz	a0,3db0 <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    39ec:	00004517          	auipc	a0,0x4
    39f0:	b0450513          	addi	a0,a0,-1276 # 74f0 <malloc+0x14a6>
    39f4:	00002097          	auipc	ra,0x2
    39f8:	28e080e7          	jalr	654(ra) # 5c82 <chdir>
    39fc:	3c050863          	beqz	a0,3dcc <subdir+0x702>
  if(chdir("dd/xx") == 0){
    3a00:	00004517          	auipc	a0,0x4
    3a04:	f9050513          	addi	a0,a0,-112 # 7990 <malloc+0x1946>
    3a08:	00002097          	auipc	ra,0x2
    3a0c:	27a080e7          	jalr	634(ra) # 5c82 <chdir>
    3a10:	3c050c63          	beqz	a0,3de8 <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    3a14:	00004517          	auipc	a0,0x4
    3a18:	be450513          	addi	a0,a0,-1052 # 75f8 <malloc+0x15ae>
    3a1c:	00002097          	auipc	ra,0x2
    3a20:	246080e7          	jalr	582(ra) # 5c62 <unlink>
    3a24:	3e051063          	bnez	a0,3e04 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    3a28:	00004517          	auipc	a0,0x4
    3a2c:	ac850513          	addi	a0,a0,-1336 # 74f0 <malloc+0x14a6>
    3a30:	00002097          	auipc	ra,0x2
    3a34:	232080e7          	jalr	562(ra) # 5c62 <unlink>
    3a38:	3e051463          	bnez	a0,3e20 <subdir+0x756>
  if(unlink("dd") == 0){
    3a3c:	00004517          	auipc	a0,0x4
    3a40:	a9450513          	addi	a0,a0,-1388 # 74d0 <malloc+0x1486>
    3a44:	00002097          	auipc	ra,0x2
    3a48:	21e080e7          	jalr	542(ra) # 5c62 <unlink>
    3a4c:	3e050863          	beqz	a0,3e3c <subdir+0x772>
  if(unlink("dd/dd") < 0){
    3a50:	00004517          	auipc	a0,0x4
    3a54:	fb050513          	addi	a0,a0,-80 # 7a00 <malloc+0x19b6>
    3a58:	00002097          	auipc	ra,0x2
    3a5c:	20a080e7          	jalr	522(ra) # 5c62 <unlink>
    3a60:	3e054c63          	bltz	a0,3e58 <subdir+0x78e>
  if(unlink("dd") < 0){
    3a64:	00004517          	auipc	a0,0x4
    3a68:	a6c50513          	addi	a0,a0,-1428 # 74d0 <malloc+0x1486>
    3a6c:	00002097          	auipc	ra,0x2
    3a70:	1f6080e7          	jalr	502(ra) # 5c62 <unlink>
    3a74:	40054063          	bltz	a0,3e74 <subdir+0x7aa>
}
    3a78:	60e2                	ld	ra,24(sp)
    3a7a:	6442                	ld	s0,16(sp)
    3a7c:	64a2                	ld	s1,8(sp)
    3a7e:	6902                	ld	s2,0(sp)
    3a80:	6105                	addi	sp,sp,32
    3a82:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    3a84:	85ca                	mv	a1,s2
    3a86:	00004517          	auipc	a0,0x4
    3a8a:	a5250513          	addi	a0,a0,-1454 # 74d8 <malloc+0x148e>
    3a8e:	00002097          	auipc	ra,0x2
    3a92:	4fc080e7          	jalr	1276(ra) # 5f8a <printf>
    exit(1);
    3a96:	4505                	li	a0,1
    3a98:	00002097          	auipc	ra,0x2
    3a9c:	17a080e7          	jalr	378(ra) # 5c12 <exit>
    printf("%s: create dd/ff failed\n", s);
    3aa0:	85ca                	mv	a1,s2
    3aa2:	00004517          	auipc	a0,0x4
    3aa6:	a5650513          	addi	a0,a0,-1450 # 74f8 <malloc+0x14ae>
    3aaa:	00002097          	auipc	ra,0x2
    3aae:	4e0080e7          	jalr	1248(ra) # 5f8a <printf>
    exit(1);
    3ab2:	4505                	li	a0,1
    3ab4:	00002097          	auipc	ra,0x2
    3ab8:	15e080e7          	jalr	350(ra) # 5c12 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3abc:	85ca                	mv	a1,s2
    3abe:	00004517          	auipc	a0,0x4
    3ac2:	a5a50513          	addi	a0,a0,-1446 # 7518 <malloc+0x14ce>
    3ac6:	00002097          	auipc	ra,0x2
    3aca:	4c4080e7          	jalr	1220(ra) # 5f8a <printf>
    exit(1);
    3ace:	4505                	li	a0,1
    3ad0:	00002097          	auipc	ra,0x2
    3ad4:	142080e7          	jalr	322(ra) # 5c12 <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    3ad8:	85ca                	mv	a1,s2
    3ada:	00004517          	auipc	a0,0x4
    3ade:	a7650513          	addi	a0,a0,-1418 # 7550 <malloc+0x1506>
    3ae2:	00002097          	auipc	ra,0x2
    3ae6:	4a8080e7          	jalr	1192(ra) # 5f8a <printf>
    exit(1);
    3aea:	4505                	li	a0,1
    3aec:	00002097          	auipc	ra,0x2
    3af0:	126080e7          	jalr	294(ra) # 5c12 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3af4:	85ca                	mv	a1,s2
    3af6:	00004517          	auipc	a0,0x4
    3afa:	a8a50513          	addi	a0,a0,-1398 # 7580 <malloc+0x1536>
    3afe:	00002097          	auipc	ra,0x2
    3b02:	48c080e7          	jalr	1164(ra) # 5f8a <printf>
    exit(1);
    3b06:	4505                	li	a0,1
    3b08:	00002097          	auipc	ra,0x2
    3b0c:	10a080e7          	jalr	266(ra) # 5c12 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    3b10:	85ca                	mv	a1,s2
    3b12:	00004517          	auipc	a0,0x4
    3b16:	aa650513          	addi	a0,a0,-1370 # 75b8 <malloc+0x156e>
    3b1a:	00002097          	auipc	ra,0x2
    3b1e:	470080e7          	jalr	1136(ra) # 5f8a <printf>
    exit(1);
    3b22:	4505                	li	a0,1
    3b24:	00002097          	auipc	ra,0x2
    3b28:	0ee080e7          	jalr	238(ra) # 5c12 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    3b2c:	85ca                	mv	a1,s2
    3b2e:	00004517          	auipc	a0,0x4
    3b32:	aaa50513          	addi	a0,a0,-1366 # 75d8 <malloc+0x158e>
    3b36:	00002097          	auipc	ra,0x2
    3b3a:	454080e7          	jalr	1108(ra) # 5f8a <printf>
    exit(1);
    3b3e:	4505                	li	a0,1
    3b40:	00002097          	auipc	ra,0x2
    3b44:	0d2080e7          	jalr	210(ra) # 5c12 <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    3b48:	85ca                	mv	a1,s2
    3b4a:	00004517          	auipc	a0,0x4
    3b4e:	abe50513          	addi	a0,a0,-1346 # 7608 <malloc+0x15be>
    3b52:	00002097          	auipc	ra,0x2
    3b56:	438080e7          	jalr	1080(ra) # 5f8a <printf>
    exit(1);
    3b5a:	4505                	li	a0,1
    3b5c:	00002097          	auipc	ra,0x2
    3b60:	0b6080e7          	jalr	182(ra) # 5c12 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3b64:	85ca                	mv	a1,s2
    3b66:	00004517          	auipc	a0,0x4
    3b6a:	aca50513          	addi	a0,a0,-1334 # 7630 <malloc+0x15e6>
    3b6e:	00002097          	auipc	ra,0x2
    3b72:	41c080e7          	jalr	1052(ra) # 5f8a <printf>
    exit(1);
    3b76:	4505                	li	a0,1
    3b78:	00002097          	auipc	ra,0x2
    3b7c:	09a080e7          	jalr	154(ra) # 5c12 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    3b80:	85ca                	mv	a1,s2
    3b82:	00004517          	auipc	a0,0x4
    3b86:	ace50513          	addi	a0,a0,-1330 # 7650 <malloc+0x1606>
    3b8a:	00002097          	auipc	ra,0x2
    3b8e:	400080e7          	jalr	1024(ra) # 5f8a <printf>
    exit(1);
    3b92:	4505                	li	a0,1
    3b94:	00002097          	auipc	ra,0x2
    3b98:	07e080e7          	jalr	126(ra) # 5c12 <exit>
    printf("%s: chdir dd failed\n", s);
    3b9c:	85ca                	mv	a1,s2
    3b9e:	00004517          	auipc	a0,0x4
    3ba2:	ada50513          	addi	a0,a0,-1318 # 7678 <malloc+0x162e>
    3ba6:	00002097          	auipc	ra,0x2
    3baa:	3e4080e7          	jalr	996(ra) # 5f8a <printf>
    exit(1);
    3bae:	4505                	li	a0,1
    3bb0:	00002097          	auipc	ra,0x2
    3bb4:	062080e7          	jalr	98(ra) # 5c12 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3bb8:	85ca                	mv	a1,s2
    3bba:	00004517          	auipc	a0,0x4
    3bbe:	ae650513          	addi	a0,a0,-1306 # 76a0 <malloc+0x1656>
    3bc2:	00002097          	auipc	ra,0x2
    3bc6:	3c8080e7          	jalr	968(ra) # 5f8a <printf>
    exit(1);
    3bca:	4505                	li	a0,1
    3bcc:	00002097          	auipc	ra,0x2
    3bd0:	046080e7          	jalr	70(ra) # 5c12 <exit>
    printf("chdir dd/../../dd failed\n", s);
    3bd4:	85ca                	mv	a1,s2
    3bd6:	00004517          	auipc	a0,0x4
    3bda:	afa50513          	addi	a0,a0,-1286 # 76d0 <malloc+0x1686>
    3bde:	00002097          	auipc	ra,0x2
    3be2:	3ac080e7          	jalr	940(ra) # 5f8a <printf>
    exit(1);
    3be6:	4505                	li	a0,1
    3be8:	00002097          	auipc	ra,0x2
    3bec:	02a080e7          	jalr	42(ra) # 5c12 <exit>
    printf("%s: chdir ./.. failed\n", s);
    3bf0:	85ca                	mv	a1,s2
    3bf2:	00004517          	auipc	a0,0x4
    3bf6:	b0650513          	addi	a0,a0,-1274 # 76f8 <malloc+0x16ae>
    3bfa:	00002097          	auipc	ra,0x2
    3bfe:	390080e7          	jalr	912(ra) # 5f8a <printf>
    exit(1);
    3c02:	4505                	li	a0,1
    3c04:	00002097          	auipc	ra,0x2
    3c08:	00e080e7          	jalr	14(ra) # 5c12 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3c0c:	85ca                	mv	a1,s2
    3c0e:	00004517          	auipc	a0,0x4
    3c12:	b0250513          	addi	a0,a0,-1278 # 7710 <malloc+0x16c6>
    3c16:	00002097          	auipc	ra,0x2
    3c1a:	374080e7          	jalr	884(ra) # 5f8a <printf>
    exit(1);
    3c1e:	4505                	li	a0,1
    3c20:	00002097          	auipc	ra,0x2
    3c24:	ff2080e7          	jalr	-14(ra) # 5c12 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3c28:	85ca                	mv	a1,s2
    3c2a:	00004517          	auipc	a0,0x4
    3c2e:	b0650513          	addi	a0,a0,-1274 # 7730 <malloc+0x16e6>
    3c32:	00002097          	auipc	ra,0x2
    3c36:	358080e7          	jalr	856(ra) # 5f8a <printf>
    exit(1);
    3c3a:	4505                	li	a0,1
    3c3c:	00002097          	auipc	ra,0x2
    3c40:	fd6080e7          	jalr	-42(ra) # 5c12 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    3c44:	85ca                	mv	a1,s2
    3c46:	00004517          	auipc	a0,0x4
    3c4a:	b0a50513          	addi	a0,a0,-1270 # 7750 <malloc+0x1706>
    3c4e:	00002097          	auipc	ra,0x2
    3c52:	33c080e7          	jalr	828(ra) # 5f8a <printf>
    exit(1);
    3c56:	4505                	li	a0,1
    3c58:	00002097          	auipc	ra,0x2
    3c5c:	fba080e7          	jalr	-70(ra) # 5c12 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    3c60:	85ca                	mv	a1,s2
    3c62:	00004517          	auipc	a0,0x4
    3c66:	b2e50513          	addi	a0,a0,-1234 # 7790 <malloc+0x1746>
    3c6a:	00002097          	auipc	ra,0x2
    3c6e:	320080e7          	jalr	800(ra) # 5f8a <printf>
    exit(1);
    3c72:	4505                	li	a0,1
    3c74:	00002097          	auipc	ra,0x2
    3c78:	f9e080e7          	jalr	-98(ra) # 5c12 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3c7c:	85ca                	mv	a1,s2
    3c7e:	00004517          	auipc	a0,0x4
    3c82:	b4250513          	addi	a0,a0,-1214 # 77c0 <malloc+0x1776>
    3c86:	00002097          	auipc	ra,0x2
    3c8a:	304080e7          	jalr	772(ra) # 5f8a <printf>
    exit(1);
    3c8e:	4505                	li	a0,1
    3c90:	00002097          	auipc	ra,0x2
    3c94:	f82080e7          	jalr	-126(ra) # 5c12 <exit>
    printf("%s: create dd succeeded!\n", s);
    3c98:	85ca                	mv	a1,s2
    3c9a:	00004517          	auipc	a0,0x4
    3c9e:	b4650513          	addi	a0,a0,-1210 # 77e0 <malloc+0x1796>
    3ca2:	00002097          	auipc	ra,0x2
    3ca6:	2e8080e7          	jalr	744(ra) # 5f8a <printf>
    exit(1);
    3caa:	4505                	li	a0,1
    3cac:	00002097          	auipc	ra,0x2
    3cb0:	f66080e7          	jalr	-154(ra) # 5c12 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3cb4:	85ca                	mv	a1,s2
    3cb6:	00004517          	auipc	a0,0x4
    3cba:	b4a50513          	addi	a0,a0,-1206 # 7800 <malloc+0x17b6>
    3cbe:	00002097          	auipc	ra,0x2
    3cc2:	2cc080e7          	jalr	716(ra) # 5f8a <printf>
    exit(1);
    3cc6:	4505                	li	a0,1
    3cc8:	00002097          	auipc	ra,0x2
    3ccc:	f4a080e7          	jalr	-182(ra) # 5c12 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3cd0:	85ca                	mv	a1,s2
    3cd2:	00004517          	auipc	a0,0x4
    3cd6:	b4e50513          	addi	a0,a0,-1202 # 7820 <malloc+0x17d6>
    3cda:	00002097          	auipc	ra,0x2
    3cde:	2b0080e7          	jalr	688(ra) # 5f8a <printf>
    exit(1);
    3ce2:	4505                	li	a0,1
    3ce4:	00002097          	auipc	ra,0x2
    3ce8:	f2e080e7          	jalr	-210(ra) # 5c12 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3cec:	85ca                	mv	a1,s2
    3cee:	00004517          	auipc	a0,0x4
    3cf2:	b6250513          	addi	a0,a0,-1182 # 7850 <malloc+0x1806>
    3cf6:	00002097          	auipc	ra,0x2
    3cfa:	294080e7          	jalr	660(ra) # 5f8a <printf>
    exit(1);
    3cfe:	4505                	li	a0,1
    3d00:	00002097          	auipc	ra,0x2
    3d04:	f12080e7          	jalr	-238(ra) # 5c12 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3d08:	85ca                	mv	a1,s2
    3d0a:	00004517          	auipc	a0,0x4
    3d0e:	b6e50513          	addi	a0,a0,-1170 # 7878 <malloc+0x182e>
    3d12:	00002097          	auipc	ra,0x2
    3d16:	278080e7          	jalr	632(ra) # 5f8a <printf>
    exit(1);
    3d1a:	4505                	li	a0,1
    3d1c:	00002097          	auipc	ra,0x2
    3d20:	ef6080e7          	jalr	-266(ra) # 5c12 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3d24:	85ca                	mv	a1,s2
    3d26:	00004517          	auipc	a0,0x4
    3d2a:	b7a50513          	addi	a0,a0,-1158 # 78a0 <malloc+0x1856>
    3d2e:	00002097          	auipc	ra,0x2
    3d32:	25c080e7          	jalr	604(ra) # 5f8a <printf>
    exit(1);
    3d36:	4505                	li	a0,1
    3d38:	00002097          	auipc	ra,0x2
    3d3c:	eda080e7          	jalr	-294(ra) # 5c12 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3d40:	85ca                	mv	a1,s2
    3d42:	00004517          	auipc	a0,0x4
    3d46:	b8650513          	addi	a0,a0,-1146 # 78c8 <malloc+0x187e>
    3d4a:	00002097          	auipc	ra,0x2
    3d4e:	240080e7          	jalr	576(ra) # 5f8a <printf>
    exit(1);
    3d52:	4505                	li	a0,1
    3d54:	00002097          	auipc	ra,0x2
    3d58:	ebe080e7          	jalr	-322(ra) # 5c12 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3d5c:	85ca                	mv	a1,s2
    3d5e:	00004517          	auipc	a0,0x4
    3d62:	b8a50513          	addi	a0,a0,-1142 # 78e8 <malloc+0x189e>
    3d66:	00002097          	auipc	ra,0x2
    3d6a:	224080e7          	jalr	548(ra) # 5f8a <printf>
    exit(1);
    3d6e:	4505                	li	a0,1
    3d70:	00002097          	auipc	ra,0x2
    3d74:	ea2080e7          	jalr	-350(ra) # 5c12 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3d78:	85ca                	mv	a1,s2
    3d7a:	00004517          	auipc	a0,0x4
    3d7e:	b8e50513          	addi	a0,a0,-1138 # 7908 <malloc+0x18be>
    3d82:	00002097          	auipc	ra,0x2
    3d86:	208080e7          	jalr	520(ra) # 5f8a <printf>
    exit(1);
    3d8a:	4505                	li	a0,1
    3d8c:	00002097          	auipc	ra,0x2
    3d90:	e86080e7          	jalr	-378(ra) # 5c12 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    3d94:	85ca                	mv	a1,s2
    3d96:	00004517          	auipc	a0,0x4
    3d9a:	b9a50513          	addi	a0,a0,-1126 # 7930 <malloc+0x18e6>
    3d9e:	00002097          	auipc	ra,0x2
    3da2:	1ec080e7          	jalr	492(ra) # 5f8a <printf>
    exit(1);
    3da6:	4505                	li	a0,1
    3da8:	00002097          	auipc	ra,0x2
    3dac:	e6a080e7          	jalr	-406(ra) # 5c12 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    3db0:	85ca                	mv	a1,s2
    3db2:	00004517          	auipc	a0,0x4
    3db6:	b9e50513          	addi	a0,a0,-1122 # 7950 <malloc+0x1906>
    3dba:	00002097          	auipc	ra,0x2
    3dbe:	1d0080e7          	jalr	464(ra) # 5f8a <printf>
    exit(1);
    3dc2:	4505                	li	a0,1
    3dc4:	00002097          	auipc	ra,0x2
    3dc8:	e4e080e7          	jalr	-434(ra) # 5c12 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3dcc:	85ca                	mv	a1,s2
    3dce:	00004517          	auipc	a0,0x4
    3dd2:	ba250513          	addi	a0,a0,-1118 # 7970 <malloc+0x1926>
    3dd6:	00002097          	auipc	ra,0x2
    3dda:	1b4080e7          	jalr	436(ra) # 5f8a <printf>
    exit(1);
    3dde:	4505                	li	a0,1
    3de0:	00002097          	auipc	ra,0x2
    3de4:	e32080e7          	jalr	-462(ra) # 5c12 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3de8:	85ca                	mv	a1,s2
    3dea:	00004517          	auipc	a0,0x4
    3dee:	bae50513          	addi	a0,a0,-1106 # 7998 <malloc+0x194e>
    3df2:	00002097          	auipc	ra,0x2
    3df6:	198080e7          	jalr	408(ra) # 5f8a <printf>
    exit(1);
    3dfa:	4505                	li	a0,1
    3dfc:	00002097          	auipc	ra,0x2
    3e00:	e16080e7          	jalr	-490(ra) # 5c12 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3e04:	85ca                	mv	a1,s2
    3e06:	00004517          	auipc	a0,0x4
    3e0a:	82a50513          	addi	a0,a0,-2006 # 7630 <malloc+0x15e6>
    3e0e:	00002097          	auipc	ra,0x2
    3e12:	17c080e7          	jalr	380(ra) # 5f8a <printf>
    exit(1);
    3e16:	4505                	li	a0,1
    3e18:	00002097          	auipc	ra,0x2
    3e1c:	dfa080e7          	jalr	-518(ra) # 5c12 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3e20:	85ca                	mv	a1,s2
    3e22:	00004517          	auipc	a0,0x4
    3e26:	b9650513          	addi	a0,a0,-1130 # 79b8 <malloc+0x196e>
    3e2a:	00002097          	auipc	ra,0x2
    3e2e:	160080e7          	jalr	352(ra) # 5f8a <printf>
    exit(1);
    3e32:	4505                	li	a0,1
    3e34:	00002097          	auipc	ra,0x2
    3e38:	dde080e7          	jalr	-546(ra) # 5c12 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    3e3c:	85ca                	mv	a1,s2
    3e3e:	00004517          	auipc	a0,0x4
    3e42:	b9a50513          	addi	a0,a0,-1126 # 79d8 <malloc+0x198e>
    3e46:	00002097          	auipc	ra,0x2
    3e4a:	144080e7          	jalr	324(ra) # 5f8a <printf>
    exit(1);
    3e4e:	4505                	li	a0,1
    3e50:	00002097          	auipc	ra,0x2
    3e54:	dc2080e7          	jalr	-574(ra) # 5c12 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3e58:	85ca                	mv	a1,s2
    3e5a:	00004517          	auipc	a0,0x4
    3e5e:	bae50513          	addi	a0,a0,-1106 # 7a08 <malloc+0x19be>
    3e62:	00002097          	auipc	ra,0x2
    3e66:	128080e7          	jalr	296(ra) # 5f8a <printf>
    exit(1);
    3e6a:	4505                	li	a0,1
    3e6c:	00002097          	auipc	ra,0x2
    3e70:	da6080e7          	jalr	-602(ra) # 5c12 <exit>
    printf("%s: unlink dd failed\n", s);
    3e74:	85ca                	mv	a1,s2
    3e76:	00004517          	auipc	a0,0x4
    3e7a:	bb250513          	addi	a0,a0,-1102 # 7a28 <malloc+0x19de>
    3e7e:	00002097          	auipc	ra,0x2
    3e82:	10c080e7          	jalr	268(ra) # 5f8a <printf>
    exit(1);
    3e86:	4505                	li	a0,1
    3e88:	00002097          	auipc	ra,0x2
    3e8c:	d8a080e7          	jalr	-630(ra) # 5c12 <exit>

0000000000003e90 <rmdot>:
{
    3e90:	1101                	addi	sp,sp,-32
    3e92:	ec06                	sd	ra,24(sp)
    3e94:	e822                	sd	s0,16(sp)
    3e96:	e426                	sd	s1,8(sp)
    3e98:	1000                	addi	s0,sp,32
    3e9a:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    3e9c:	00004517          	auipc	a0,0x4
    3ea0:	ba450513          	addi	a0,a0,-1116 # 7a40 <malloc+0x19f6>
    3ea4:	00002097          	auipc	ra,0x2
    3ea8:	dd6080e7          	jalr	-554(ra) # 5c7a <mkdir>
    3eac:	e549                	bnez	a0,3f36 <rmdot+0xa6>
  if(chdir("dots") != 0){
    3eae:	00004517          	auipc	a0,0x4
    3eb2:	b9250513          	addi	a0,a0,-1134 # 7a40 <malloc+0x19f6>
    3eb6:	00002097          	auipc	ra,0x2
    3eba:	dcc080e7          	jalr	-564(ra) # 5c82 <chdir>
    3ebe:	e951                	bnez	a0,3f52 <rmdot+0xc2>
  if(unlink(".") == 0){
    3ec0:	00003517          	auipc	a0,0x3
    3ec4:	9b050513          	addi	a0,a0,-1616 # 6870 <malloc+0x826>
    3ec8:	00002097          	auipc	ra,0x2
    3ecc:	d9a080e7          	jalr	-614(ra) # 5c62 <unlink>
    3ed0:	cd59                	beqz	a0,3f6e <rmdot+0xde>
  if(unlink("..") == 0){
    3ed2:	00003517          	auipc	a0,0x3
    3ed6:	5c650513          	addi	a0,a0,1478 # 7498 <malloc+0x144e>
    3eda:	00002097          	auipc	ra,0x2
    3ede:	d88080e7          	jalr	-632(ra) # 5c62 <unlink>
    3ee2:	c545                	beqz	a0,3f8a <rmdot+0xfa>
  if(chdir("/") != 0){
    3ee4:	00003517          	auipc	a0,0x3
    3ee8:	55c50513          	addi	a0,a0,1372 # 7440 <malloc+0x13f6>
    3eec:	00002097          	auipc	ra,0x2
    3ef0:	d96080e7          	jalr	-618(ra) # 5c82 <chdir>
    3ef4:	e94d                	bnez	a0,3fa6 <rmdot+0x116>
  if(unlink("dots/.") == 0){
    3ef6:	00004517          	auipc	a0,0x4
    3efa:	bb250513          	addi	a0,a0,-1102 # 7aa8 <malloc+0x1a5e>
    3efe:	00002097          	auipc	ra,0x2
    3f02:	d64080e7          	jalr	-668(ra) # 5c62 <unlink>
    3f06:	cd55                	beqz	a0,3fc2 <rmdot+0x132>
  if(unlink("dots/..") == 0){
    3f08:	00004517          	auipc	a0,0x4
    3f0c:	bc850513          	addi	a0,a0,-1080 # 7ad0 <malloc+0x1a86>
    3f10:	00002097          	auipc	ra,0x2
    3f14:	d52080e7          	jalr	-686(ra) # 5c62 <unlink>
    3f18:	c179                	beqz	a0,3fde <rmdot+0x14e>
  if(unlink("dots") != 0){
    3f1a:	00004517          	auipc	a0,0x4
    3f1e:	b2650513          	addi	a0,a0,-1242 # 7a40 <malloc+0x19f6>
    3f22:	00002097          	auipc	ra,0x2
    3f26:	d40080e7          	jalr	-704(ra) # 5c62 <unlink>
    3f2a:	e961                	bnez	a0,3ffa <rmdot+0x16a>
}
    3f2c:	60e2                	ld	ra,24(sp)
    3f2e:	6442                	ld	s0,16(sp)
    3f30:	64a2                	ld	s1,8(sp)
    3f32:	6105                	addi	sp,sp,32
    3f34:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3f36:	85a6                	mv	a1,s1
    3f38:	00004517          	auipc	a0,0x4
    3f3c:	b1050513          	addi	a0,a0,-1264 # 7a48 <malloc+0x19fe>
    3f40:	00002097          	auipc	ra,0x2
    3f44:	04a080e7          	jalr	74(ra) # 5f8a <printf>
    exit(1);
    3f48:	4505                	li	a0,1
    3f4a:	00002097          	auipc	ra,0x2
    3f4e:	cc8080e7          	jalr	-824(ra) # 5c12 <exit>
    printf("%s: chdir dots failed\n", s);
    3f52:	85a6                	mv	a1,s1
    3f54:	00004517          	auipc	a0,0x4
    3f58:	b0c50513          	addi	a0,a0,-1268 # 7a60 <malloc+0x1a16>
    3f5c:	00002097          	auipc	ra,0x2
    3f60:	02e080e7          	jalr	46(ra) # 5f8a <printf>
    exit(1);
    3f64:	4505                	li	a0,1
    3f66:	00002097          	auipc	ra,0x2
    3f6a:	cac080e7          	jalr	-852(ra) # 5c12 <exit>
    printf("%s: rm . worked!\n", s);
    3f6e:	85a6                	mv	a1,s1
    3f70:	00004517          	auipc	a0,0x4
    3f74:	b0850513          	addi	a0,a0,-1272 # 7a78 <malloc+0x1a2e>
    3f78:	00002097          	auipc	ra,0x2
    3f7c:	012080e7          	jalr	18(ra) # 5f8a <printf>
    exit(1);
    3f80:	4505                	li	a0,1
    3f82:	00002097          	auipc	ra,0x2
    3f86:	c90080e7          	jalr	-880(ra) # 5c12 <exit>
    printf("%s: rm .. worked!\n", s);
    3f8a:	85a6                	mv	a1,s1
    3f8c:	00004517          	auipc	a0,0x4
    3f90:	b0450513          	addi	a0,a0,-1276 # 7a90 <malloc+0x1a46>
    3f94:	00002097          	auipc	ra,0x2
    3f98:	ff6080e7          	jalr	-10(ra) # 5f8a <printf>
    exit(1);
    3f9c:	4505                	li	a0,1
    3f9e:	00002097          	auipc	ra,0x2
    3fa2:	c74080e7          	jalr	-908(ra) # 5c12 <exit>
    printf("%s: chdir / failed\n", s);
    3fa6:	85a6                	mv	a1,s1
    3fa8:	00003517          	auipc	a0,0x3
    3fac:	4a050513          	addi	a0,a0,1184 # 7448 <malloc+0x13fe>
    3fb0:	00002097          	auipc	ra,0x2
    3fb4:	fda080e7          	jalr	-38(ra) # 5f8a <printf>
    exit(1);
    3fb8:	4505                	li	a0,1
    3fba:	00002097          	auipc	ra,0x2
    3fbe:	c58080e7          	jalr	-936(ra) # 5c12 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3fc2:	85a6                	mv	a1,s1
    3fc4:	00004517          	auipc	a0,0x4
    3fc8:	aec50513          	addi	a0,a0,-1300 # 7ab0 <malloc+0x1a66>
    3fcc:	00002097          	auipc	ra,0x2
    3fd0:	fbe080e7          	jalr	-66(ra) # 5f8a <printf>
    exit(1);
    3fd4:	4505                	li	a0,1
    3fd6:	00002097          	auipc	ra,0x2
    3fda:	c3c080e7          	jalr	-964(ra) # 5c12 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3fde:	85a6                	mv	a1,s1
    3fe0:	00004517          	auipc	a0,0x4
    3fe4:	af850513          	addi	a0,a0,-1288 # 7ad8 <malloc+0x1a8e>
    3fe8:	00002097          	auipc	ra,0x2
    3fec:	fa2080e7          	jalr	-94(ra) # 5f8a <printf>
    exit(1);
    3ff0:	4505                	li	a0,1
    3ff2:	00002097          	auipc	ra,0x2
    3ff6:	c20080e7          	jalr	-992(ra) # 5c12 <exit>
    printf("%s: unlink dots failed!\n", s);
    3ffa:	85a6                	mv	a1,s1
    3ffc:	00004517          	auipc	a0,0x4
    4000:	afc50513          	addi	a0,a0,-1284 # 7af8 <malloc+0x1aae>
    4004:	00002097          	auipc	ra,0x2
    4008:	f86080e7          	jalr	-122(ra) # 5f8a <printf>
    exit(1);
    400c:	4505                	li	a0,1
    400e:	00002097          	auipc	ra,0x2
    4012:	c04080e7          	jalr	-1020(ra) # 5c12 <exit>

0000000000004016 <dirfile>:
{
    4016:	1101                	addi	sp,sp,-32
    4018:	ec06                	sd	ra,24(sp)
    401a:	e822                	sd	s0,16(sp)
    401c:	e426                	sd	s1,8(sp)
    401e:	e04a                	sd	s2,0(sp)
    4020:	1000                	addi	s0,sp,32
    4022:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    4024:	20000593          	li	a1,512
    4028:	00004517          	auipc	a0,0x4
    402c:	af050513          	addi	a0,a0,-1296 # 7b18 <malloc+0x1ace>
    4030:	00002097          	auipc	ra,0x2
    4034:	c22080e7          	jalr	-990(ra) # 5c52 <open>
  if(fd < 0){
    4038:	0e054d63          	bltz	a0,4132 <dirfile+0x11c>
  close(fd);
    403c:	00002097          	auipc	ra,0x2
    4040:	bfe080e7          	jalr	-1026(ra) # 5c3a <close>
  if(chdir("dirfile") == 0){
    4044:	00004517          	auipc	a0,0x4
    4048:	ad450513          	addi	a0,a0,-1324 # 7b18 <malloc+0x1ace>
    404c:	00002097          	auipc	ra,0x2
    4050:	c36080e7          	jalr	-970(ra) # 5c82 <chdir>
    4054:	cd6d                	beqz	a0,414e <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    4056:	4581                	li	a1,0
    4058:	00004517          	auipc	a0,0x4
    405c:	b0850513          	addi	a0,a0,-1272 # 7b60 <malloc+0x1b16>
    4060:	00002097          	auipc	ra,0x2
    4064:	bf2080e7          	jalr	-1038(ra) # 5c52 <open>
  if(fd >= 0){
    4068:	10055163          	bgez	a0,416a <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    406c:	20000593          	li	a1,512
    4070:	00004517          	auipc	a0,0x4
    4074:	af050513          	addi	a0,a0,-1296 # 7b60 <malloc+0x1b16>
    4078:	00002097          	auipc	ra,0x2
    407c:	bda080e7          	jalr	-1062(ra) # 5c52 <open>
  if(fd >= 0){
    4080:	10055363          	bgez	a0,4186 <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    4084:	00004517          	auipc	a0,0x4
    4088:	adc50513          	addi	a0,a0,-1316 # 7b60 <malloc+0x1b16>
    408c:	00002097          	auipc	ra,0x2
    4090:	bee080e7          	jalr	-1042(ra) # 5c7a <mkdir>
    4094:	10050763          	beqz	a0,41a2 <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    4098:	00004517          	auipc	a0,0x4
    409c:	ac850513          	addi	a0,a0,-1336 # 7b60 <malloc+0x1b16>
    40a0:	00002097          	auipc	ra,0x2
    40a4:	bc2080e7          	jalr	-1086(ra) # 5c62 <unlink>
    40a8:	10050b63          	beqz	a0,41be <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    40ac:	00004597          	auipc	a1,0x4
    40b0:	ab458593          	addi	a1,a1,-1356 # 7b60 <malloc+0x1b16>
    40b4:	00002517          	auipc	a0,0x2
    40b8:	2ac50513          	addi	a0,a0,684 # 6360 <malloc+0x316>
    40bc:	00002097          	auipc	ra,0x2
    40c0:	bb6080e7          	jalr	-1098(ra) # 5c72 <link>
    40c4:	10050b63          	beqz	a0,41da <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    40c8:	00004517          	auipc	a0,0x4
    40cc:	a5050513          	addi	a0,a0,-1456 # 7b18 <malloc+0x1ace>
    40d0:	00002097          	auipc	ra,0x2
    40d4:	b92080e7          	jalr	-1134(ra) # 5c62 <unlink>
    40d8:	10051f63          	bnez	a0,41f6 <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    40dc:	4589                	li	a1,2
    40de:	00002517          	auipc	a0,0x2
    40e2:	79250513          	addi	a0,a0,1938 # 6870 <malloc+0x826>
    40e6:	00002097          	auipc	ra,0x2
    40ea:	b6c080e7          	jalr	-1172(ra) # 5c52 <open>
  if(fd >= 0){
    40ee:	12055263          	bgez	a0,4212 <dirfile+0x1fc>
  fd = open(".", 0);
    40f2:	4581                	li	a1,0
    40f4:	00002517          	auipc	a0,0x2
    40f8:	77c50513          	addi	a0,a0,1916 # 6870 <malloc+0x826>
    40fc:	00002097          	auipc	ra,0x2
    4100:	b56080e7          	jalr	-1194(ra) # 5c52 <open>
    4104:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    4106:	4605                	li	a2,1
    4108:	00002597          	auipc	a1,0x2
    410c:	0f058593          	addi	a1,a1,240 # 61f8 <malloc+0x1ae>
    4110:	00002097          	auipc	ra,0x2
    4114:	b22080e7          	jalr	-1246(ra) # 5c32 <write>
    4118:	10a04b63          	bgtz	a0,422e <dirfile+0x218>
  close(fd);
    411c:	8526                	mv	a0,s1
    411e:	00002097          	auipc	ra,0x2
    4122:	b1c080e7          	jalr	-1252(ra) # 5c3a <close>
}
    4126:	60e2                	ld	ra,24(sp)
    4128:	6442                	ld	s0,16(sp)
    412a:	64a2                	ld	s1,8(sp)
    412c:	6902                	ld	s2,0(sp)
    412e:	6105                	addi	sp,sp,32
    4130:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    4132:	85ca                	mv	a1,s2
    4134:	00004517          	auipc	a0,0x4
    4138:	9ec50513          	addi	a0,a0,-1556 # 7b20 <malloc+0x1ad6>
    413c:	00002097          	auipc	ra,0x2
    4140:	e4e080e7          	jalr	-434(ra) # 5f8a <printf>
    exit(1);
    4144:	4505                	li	a0,1
    4146:	00002097          	auipc	ra,0x2
    414a:	acc080e7          	jalr	-1332(ra) # 5c12 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    414e:	85ca                	mv	a1,s2
    4150:	00004517          	auipc	a0,0x4
    4154:	9f050513          	addi	a0,a0,-1552 # 7b40 <malloc+0x1af6>
    4158:	00002097          	auipc	ra,0x2
    415c:	e32080e7          	jalr	-462(ra) # 5f8a <printf>
    exit(1);
    4160:	4505                	li	a0,1
    4162:	00002097          	auipc	ra,0x2
    4166:	ab0080e7          	jalr	-1360(ra) # 5c12 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    416a:	85ca                	mv	a1,s2
    416c:	00004517          	auipc	a0,0x4
    4170:	a0450513          	addi	a0,a0,-1532 # 7b70 <malloc+0x1b26>
    4174:	00002097          	auipc	ra,0x2
    4178:	e16080e7          	jalr	-490(ra) # 5f8a <printf>
    exit(1);
    417c:	4505                	li	a0,1
    417e:	00002097          	auipc	ra,0x2
    4182:	a94080e7          	jalr	-1388(ra) # 5c12 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    4186:	85ca                	mv	a1,s2
    4188:	00004517          	auipc	a0,0x4
    418c:	9e850513          	addi	a0,a0,-1560 # 7b70 <malloc+0x1b26>
    4190:	00002097          	auipc	ra,0x2
    4194:	dfa080e7          	jalr	-518(ra) # 5f8a <printf>
    exit(1);
    4198:	4505                	li	a0,1
    419a:	00002097          	auipc	ra,0x2
    419e:	a78080e7          	jalr	-1416(ra) # 5c12 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    41a2:	85ca                	mv	a1,s2
    41a4:	00004517          	auipc	a0,0x4
    41a8:	9f450513          	addi	a0,a0,-1548 # 7b98 <malloc+0x1b4e>
    41ac:	00002097          	auipc	ra,0x2
    41b0:	dde080e7          	jalr	-546(ra) # 5f8a <printf>
    exit(1);
    41b4:	4505                	li	a0,1
    41b6:	00002097          	auipc	ra,0x2
    41ba:	a5c080e7          	jalr	-1444(ra) # 5c12 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    41be:	85ca                	mv	a1,s2
    41c0:	00004517          	auipc	a0,0x4
    41c4:	a0050513          	addi	a0,a0,-1536 # 7bc0 <malloc+0x1b76>
    41c8:	00002097          	auipc	ra,0x2
    41cc:	dc2080e7          	jalr	-574(ra) # 5f8a <printf>
    exit(1);
    41d0:	4505                	li	a0,1
    41d2:	00002097          	auipc	ra,0x2
    41d6:	a40080e7          	jalr	-1472(ra) # 5c12 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    41da:	85ca                	mv	a1,s2
    41dc:	00004517          	auipc	a0,0x4
    41e0:	a0c50513          	addi	a0,a0,-1524 # 7be8 <malloc+0x1b9e>
    41e4:	00002097          	auipc	ra,0x2
    41e8:	da6080e7          	jalr	-602(ra) # 5f8a <printf>
    exit(1);
    41ec:	4505                	li	a0,1
    41ee:	00002097          	auipc	ra,0x2
    41f2:	a24080e7          	jalr	-1500(ra) # 5c12 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    41f6:	85ca                	mv	a1,s2
    41f8:	00004517          	auipc	a0,0x4
    41fc:	a1850513          	addi	a0,a0,-1512 # 7c10 <malloc+0x1bc6>
    4200:	00002097          	auipc	ra,0x2
    4204:	d8a080e7          	jalr	-630(ra) # 5f8a <printf>
    exit(1);
    4208:	4505                	li	a0,1
    420a:	00002097          	auipc	ra,0x2
    420e:	a08080e7          	jalr	-1528(ra) # 5c12 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    4212:	85ca                	mv	a1,s2
    4214:	00004517          	auipc	a0,0x4
    4218:	a1c50513          	addi	a0,a0,-1508 # 7c30 <malloc+0x1be6>
    421c:	00002097          	auipc	ra,0x2
    4220:	d6e080e7          	jalr	-658(ra) # 5f8a <printf>
    exit(1);
    4224:	4505                	li	a0,1
    4226:	00002097          	auipc	ra,0x2
    422a:	9ec080e7          	jalr	-1556(ra) # 5c12 <exit>
    printf("%s: write . succeeded!\n", s);
    422e:	85ca                	mv	a1,s2
    4230:	00004517          	auipc	a0,0x4
    4234:	a2850513          	addi	a0,a0,-1496 # 7c58 <malloc+0x1c0e>
    4238:	00002097          	auipc	ra,0x2
    423c:	d52080e7          	jalr	-686(ra) # 5f8a <printf>
    exit(1);
    4240:	4505                	li	a0,1
    4242:	00002097          	auipc	ra,0x2
    4246:	9d0080e7          	jalr	-1584(ra) # 5c12 <exit>

000000000000424a <iref>:
{
    424a:	7139                	addi	sp,sp,-64
    424c:	fc06                	sd	ra,56(sp)
    424e:	f822                	sd	s0,48(sp)
    4250:	f426                	sd	s1,40(sp)
    4252:	f04a                	sd	s2,32(sp)
    4254:	ec4e                	sd	s3,24(sp)
    4256:	e852                	sd	s4,16(sp)
    4258:	e456                	sd	s5,8(sp)
    425a:	e05a                	sd	s6,0(sp)
    425c:	0080                	addi	s0,sp,64
    425e:	8b2a                	mv	s6,a0
    4260:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    4264:	00004a17          	auipc	s4,0x4
    4268:	a0ca0a13          	addi	s4,s4,-1524 # 7c70 <malloc+0x1c26>
    mkdir("");
    426c:	00003497          	auipc	s1,0x3
    4270:	50c48493          	addi	s1,s1,1292 # 7778 <malloc+0x172e>
    link("README", "");
    4274:	00002a97          	auipc	s5,0x2
    4278:	0eca8a93          	addi	s5,s5,236 # 6360 <malloc+0x316>
    fd = open("xx", O_CREATE);
    427c:	00004997          	auipc	s3,0x4
    4280:	8ec98993          	addi	s3,s3,-1812 # 7b68 <malloc+0x1b1e>
    4284:	a891                	j	42d8 <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    4286:	85da                	mv	a1,s6
    4288:	00004517          	auipc	a0,0x4
    428c:	9f050513          	addi	a0,a0,-1552 # 7c78 <malloc+0x1c2e>
    4290:	00002097          	auipc	ra,0x2
    4294:	cfa080e7          	jalr	-774(ra) # 5f8a <printf>
      exit(1);
    4298:	4505                	li	a0,1
    429a:	00002097          	auipc	ra,0x2
    429e:	978080e7          	jalr	-1672(ra) # 5c12 <exit>
      printf("%s: chdir irefd failed\n", s);
    42a2:	85da                	mv	a1,s6
    42a4:	00004517          	auipc	a0,0x4
    42a8:	9ec50513          	addi	a0,a0,-1556 # 7c90 <malloc+0x1c46>
    42ac:	00002097          	auipc	ra,0x2
    42b0:	cde080e7          	jalr	-802(ra) # 5f8a <printf>
      exit(1);
    42b4:	4505                	li	a0,1
    42b6:	00002097          	auipc	ra,0x2
    42ba:	95c080e7          	jalr	-1700(ra) # 5c12 <exit>
      close(fd);
    42be:	00002097          	auipc	ra,0x2
    42c2:	97c080e7          	jalr	-1668(ra) # 5c3a <close>
    42c6:	a889                	j	4318 <iref+0xce>
    unlink("xx");
    42c8:	854e                	mv	a0,s3
    42ca:	00002097          	auipc	ra,0x2
    42ce:	998080e7          	jalr	-1640(ra) # 5c62 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    42d2:	397d                	addiw	s2,s2,-1
    42d4:	06090063          	beqz	s2,4334 <iref+0xea>
    if(mkdir("irefd") != 0){
    42d8:	8552                	mv	a0,s4
    42da:	00002097          	auipc	ra,0x2
    42de:	9a0080e7          	jalr	-1632(ra) # 5c7a <mkdir>
    42e2:	f155                	bnez	a0,4286 <iref+0x3c>
    if(chdir("irefd") != 0){
    42e4:	8552                	mv	a0,s4
    42e6:	00002097          	auipc	ra,0x2
    42ea:	99c080e7          	jalr	-1636(ra) # 5c82 <chdir>
    42ee:	f955                	bnez	a0,42a2 <iref+0x58>
    mkdir("");
    42f0:	8526                	mv	a0,s1
    42f2:	00002097          	auipc	ra,0x2
    42f6:	988080e7          	jalr	-1656(ra) # 5c7a <mkdir>
    link("README", "");
    42fa:	85a6                	mv	a1,s1
    42fc:	8556                	mv	a0,s5
    42fe:	00002097          	auipc	ra,0x2
    4302:	974080e7          	jalr	-1676(ra) # 5c72 <link>
    fd = open("", O_CREATE);
    4306:	20000593          	li	a1,512
    430a:	8526                	mv	a0,s1
    430c:	00002097          	auipc	ra,0x2
    4310:	946080e7          	jalr	-1722(ra) # 5c52 <open>
    if(fd >= 0)
    4314:	fa0555e3          	bgez	a0,42be <iref+0x74>
    fd = open("xx", O_CREATE);
    4318:	20000593          	li	a1,512
    431c:	854e                	mv	a0,s3
    431e:	00002097          	auipc	ra,0x2
    4322:	934080e7          	jalr	-1740(ra) # 5c52 <open>
    if(fd >= 0)
    4326:	fa0541e3          	bltz	a0,42c8 <iref+0x7e>
      close(fd);
    432a:	00002097          	auipc	ra,0x2
    432e:	910080e7          	jalr	-1776(ra) # 5c3a <close>
    4332:	bf59                	j	42c8 <iref+0x7e>
    4334:	03300493          	li	s1,51
    chdir("..");
    4338:	00003997          	auipc	s3,0x3
    433c:	16098993          	addi	s3,s3,352 # 7498 <malloc+0x144e>
    unlink("irefd");
    4340:	00004917          	auipc	s2,0x4
    4344:	93090913          	addi	s2,s2,-1744 # 7c70 <malloc+0x1c26>
    chdir("..");
    4348:	854e                	mv	a0,s3
    434a:	00002097          	auipc	ra,0x2
    434e:	938080e7          	jalr	-1736(ra) # 5c82 <chdir>
    unlink("irefd");
    4352:	854a                	mv	a0,s2
    4354:	00002097          	auipc	ra,0x2
    4358:	90e080e7          	jalr	-1778(ra) # 5c62 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    435c:	34fd                	addiw	s1,s1,-1
    435e:	f4ed                	bnez	s1,4348 <iref+0xfe>
  chdir("/");
    4360:	00003517          	auipc	a0,0x3
    4364:	0e050513          	addi	a0,a0,224 # 7440 <malloc+0x13f6>
    4368:	00002097          	auipc	ra,0x2
    436c:	91a080e7          	jalr	-1766(ra) # 5c82 <chdir>
}
    4370:	70e2                	ld	ra,56(sp)
    4372:	7442                	ld	s0,48(sp)
    4374:	74a2                	ld	s1,40(sp)
    4376:	7902                	ld	s2,32(sp)
    4378:	69e2                	ld	s3,24(sp)
    437a:	6a42                	ld	s4,16(sp)
    437c:	6aa2                	ld	s5,8(sp)
    437e:	6b02                	ld	s6,0(sp)
    4380:	6121                	addi	sp,sp,64
    4382:	8082                	ret

0000000000004384 <openiputtest>:
{
    4384:	7179                	addi	sp,sp,-48
    4386:	f406                	sd	ra,40(sp)
    4388:	f022                	sd	s0,32(sp)
    438a:	ec26                	sd	s1,24(sp)
    438c:	1800                	addi	s0,sp,48
    438e:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    4390:	00004517          	auipc	a0,0x4
    4394:	91850513          	addi	a0,a0,-1768 # 7ca8 <malloc+0x1c5e>
    4398:	00002097          	auipc	ra,0x2
    439c:	8e2080e7          	jalr	-1822(ra) # 5c7a <mkdir>
    43a0:	04054263          	bltz	a0,43e4 <openiputtest+0x60>
  pid = fork();
    43a4:	00002097          	auipc	ra,0x2
    43a8:	866080e7          	jalr	-1946(ra) # 5c0a <fork>
  if(pid < 0){
    43ac:	04054a63          	bltz	a0,4400 <openiputtest+0x7c>
  if(pid == 0){
    43b0:	e93d                	bnez	a0,4426 <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    43b2:	4589                	li	a1,2
    43b4:	00004517          	auipc	a0,0x4
    43b8:	8f450513          	addi	a0,a0,-1804 # 7ca8 <malloc+0x1c5e>
    43bc:	00002097          	auipc	ra,0x2
    43c0:	896080e7          	jalr	-1898(ra) # 5c52 <open>
    if(fd >= 0){
    43c4:	04054c63          	bltz	a0,441c <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    43c8:	85a6                	mv	a1,s1
    43ca:	00004517          	auipc	a0,0x4
    43ce:	8fe50513          	addi	a0,a0,-1794 # 7cc8 <malloc+0x1c7e>
    43d2:	00002097          	auipc	ra,0x2
    43d6:	bb8080e7          	jalr	-1096(ra) # 5f8a <printf>
      exit(1);
    43da:	4505                	li	a0,1
    43dc:	00002097          	auipc	ra,0x2
    43e0:	836080e7          	jalr	-1994(ra) # 5c12 <exit>
    printf("%s: mkdir oidir failed\n", s);
    43e4:	85a6                	mv	a1,s1
    43e6:	00004517          	auipc	a0,0x4
    43ea:	8ca50513          	addi	a0,a0,-1846 # 7cb0 <malloc+0x1c66>
    43ee:	00002097          	auipc	ra,0x2
    43f2:	b9c080e7          	jalr	-1124(ra) # 5f8a <printf>
    exit(1);
    43f6:	4505                	li	a0,1
    43f8:	00002097          	auipc	ra,0x2
    43fc:	81a080e7          	jalr	-2022(ra) # 5c12 <exit>
    printf("%s: fork failed\n", s);
    4400:	85a6                	mv	a1,s1
    4402:	00002517          	auipc	a0,0x2
    4406:	60e50513          	addi	a0,a0,1550 # 6a10 <malloc+0x9c6>
    440a:	00002097          	auipc	ra,0x2
    440e:	b80080e7          	jalr	-1152(ra) # 5f8a <printf>
    exit(1);
    4412:	4505                	li	a0,1
    4414:	00001097          	auipc	ra,0x1
    4418:	7fe080e7          	jalr	2046(ra) # 5c12 <exit>
    exit(0);
    441c:	4501                	li	a0,0
    441e:	00001097          	auipc	ra,0x1
    4422:	7f4080e7          	jalr	2036(ra) # 5c12 <exit>
  sleep(1);
    4426:	4505                	li	a0,1
    4428:	00002097          	auipc	ra,0x2
    442c:	87a080e7          	jalr	-1926(ra) # 5ca2 <sleep>
  if(unlink("oidir") != 0){
    4430:	00004517          	auipc	a0,0x4
    4434:	87850513          	addi	a0,a0,-1928 # 7ca8 <malloc+0x1c5e>
    4438:	00002097          	auipc	ra,0x2
    443c:	82a080e7          	jalr	-2006(ra) # 5c62 <unlink>
    4440:	cd19                	beqz	a0,445e <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    4442:	85a6                	mv	a1,s1
    4444:	00002517          	auipc	a0,0x2
    4448:	7bc50513          	addi	a0,a0,1980 # 6c00 <malloc+0xbb6>
    444c:	00002097          	auipc	ra,0x2
    4450:	b3e080e7          	jalr	-1218(ra) # 5f8a <printf>
    exit(1);
    4454:	4505                	li	a0,1
    4456:	00001097          	auipc	ra,0x1
    445a:	7bc080e7          	jalr	1980(ra) # 5c12 <exit>
  wait(&xstatus);
    445e:	fdc40513          	addi	a0,s0,-36
    4462:	00001097          	auipc	ra,0x1
    4466:	7b8080e7          	jalr	1976(ra) # 5c1a <wait>
  exit(xstatus);
    446a:	fdc42503          	lw	a0,-36(s0)
    446e:	00001097          	auipc	ra,0x1
    4472:	7a4080e7          	jalr	1956(ra) # 5c12 <exit>

0000000000004476 <forkforkfork>:
{
    4476:	1101                	addi	sp,sp,-32
    4478:	ec06                	sd	ra,24(sp)
    447a:	e822                	sd	s0,16(sp)
    447c:	e426                	sd	s1,8(sp)
    447e:	1000                	addi	s0,sp,32
    4480:	84aa                	mv	s1,a0
  unlink("stopforking");
    4482:	00004517          	auipc	a0,0x4
    4486:	86e50513          	addi	a0,a0,-1938 # 7cf0 <malloc+0x1ca6>
    448a:	00001097          	auipc	ra,0x1
    448e:	7d8080e7          	jalr	2008(ra) # 5c62 <unlink>
  int pid = fork();
    4492:	00001097          	auipc	ra,0x1
    4496:	778080e7          	jalr	1912(ra) # 5c0a <fork>
  if(pid < 0){
    449a:	04054563          	bltz	a0,44e4 <forkforkfork+0x6e>
  if(pid == 0){
    449e:	c12d                	beqz	a0,4500 <forkforkfork+0x8a>
  sleep(20); // two seconds
    44a0:	4551                	li	a0,20
    44a2:	00002097          	auipc	ra,0x2
    44a6:	800080e7          	jalr	-2048(ra) # 5ca2 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    44aa:	20200593          	li	a1,514
    44ae:	00004517          	auipc	a0,0x4
    44b2:	84250513          	addi	a0,a0,-1982 # 7cf0 <malloc+0x1ca6>
    44b6:	00001097          	auipc	ra,0x1
    44ba:	79c080e7          	jalr	1948(ra) # 5c52 <open>
    44be:	00001097          	auipc	ra,0x1
    44c2:	77c080e7          	jalr	1916(ra) # 5c3a <close>
  wait(0);
    44c6:	4501                	li	a0,0
    44c8:	00001097          	auipc	ra,0x1
    44cc:	752080e7          	jalr	1874(ra) # 5c1a <wait>
  sleep(10); // one second
    44d0:	4529                	li	a0,10
    44d2:	00001097          	auipc	ra,0x1
    44d6:	7d0080e7          	jalr	2000(ra) # 5ca2 <sleep>
}
    44da:	60e2                	ld	ra,24(sp)
    44dc:	6442                	ld	s0,16(sp)
    44de:	64a2                	ld	s1,8(sp)
    44e0:	6105                	addi	sp,sp,32
    44e2:	8082                	ret
    printf("%s: fork failed", s);
    44e4:	85a6                	mv	a1,s1
    44e6:	00002517          	auipc	a0,0x2
    44ea:	6ea50513          	addi	a0,a0,1770 # 6bd0 <malloc+0xb86>
    44ee:	00002097          	auipc	ra,0x2
    44f2:	a9c080e7          	jalr	-1380(ra) # 5f8a <printf>
    exit(1);
    44f6:	4505                	li	a0,1
    44f8:	00001097          	auipc	ra,0x1
    44fc:	71a080e7          	jalr	1818(ra) # 5c12 <exit>
      int fd = open("stopforking", 0);
    4500:	00003497          	auipc	s1,0x3
    4504:	7f048493          	addi	s1,s1,2032 # 7cf0 <malloc+0x1ca6>
    4508:	4581                	li	a1,0
    450a:	8526                	mv	a0,s1
    450c:	00001097          	auipc	ra,0x1
    4510:	746080e7          	jalr	1862(ra) # 5c52 <open>
      if(fd >= 0){
    4514:	02055463          	bgez	a0,453c <forkforkfork+0xc6>
      if(fork() < 0){
    4518:	00001097          	auipc	ra,0x1
    451c:	6f2080e7          	jalr	1778(ra) # 5c0a <fork>
    4520:	fe0554e3          	bgez	a0,4508 <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    4524:	20200593          	li	a1,514
    4528:	8526                	mv	a0,s1
    452a:	00001097          	auipc	ra,0x1
    452e:	728080e7          	jalr	1832(ra) # 5c52 <open>
    4532:	00001097          	auipc	ra,0x1
    4536:	708080e7          	jalr	1800(ra) # 5c3a <close>
    453a:	b7f9                	j	4508 <forkforkfork+0x92>
        exit(0);
    453c:	4501                	li	a0,0
    453e:	00001097          	auipc	ra,0x1
    4542:	6d4080e7          	jalr	1748(ra) # 5c12 <exit>

0000000000004546 <killstatus>:
{
    4546:	7139                	addi	sp,sp,-64
    4548:	fc06                	sd	ra,56(sp)
    454a:	f822                	sd	s0,48(sp)
    454c:	f426                	sd	s1,40(sp)
    454e:	f04a                	sd	s2,32(sp)
    4550:	ec4e                	sd	s3,24(sp)
    4552:	e852                	sd	s4,16(sp)
    4554:	0080                	addi	s0,sp,64
    4556:	8a2a                	mv	s4,a0
    4558:	06400913          	li	s2,100
    if(xst != -1) {
    455c:	59fd                	li	s3,-1
    int pid1 = fork();
    455e:	00001097          	auipc	ra,0x1
    4562:	6ac080e7          	jalr	1708(ra) # 5c0a <fork>
    4566:	84aa                	mv	s1,a0
    if(pid1 < 0){
    4568:	02054f63          	bltz	a0,45a6 <killstatus+0x60>
    if(pid1 == 0){
    456c:	c939                	beqz	a0,45c2 <killstatus+0x7c>
    sleep(1);
    456e:	4505                	li	a0,1
    4570:	00001097          	auipc	ra,0x1
    4574:	732080e7          	jalr	1842(ra) # 5ca2 <sleep>
    kill(pid1);
    4578:	8526                	mv	a0,s1
    457a:	00001097          	auipc	ra,0x1
    457e:	6c8080e7          	jalr	1736(ra) # 5c42 <kill>
    wait(&xst);
    4582:	fcc40513          	addi	a0,s0,-52
    4586:	00001097          	auipc	ra,0x1
    458a:	694080e7          	jalr	1684(ra) # 5c1a <wait>
    if(xst != -1) {
    458e:	fcc42783          	lw	a5,-52(s0)
    4592:	03379d63          	bne	a5,s3,45cc <killstatus+0x86>
  for(int i = 0; i < 100; i++){
    4596:	397d                	addiw	s2,s2,-1
    4598:	fc0913e3          	bnez	s2,455e <killstatus+0x18>
  exit(0);
    459c:	4501                	li	a0,0
    459e:	00001097          	auipc	ra,0x1
    45a2:	674080e7          	jalr	1652(ra) # 5c12 <exit>
      printf("%s: fork failed\n", s);
    45a6:	85d2                	mv	a1,s4
    45a8:	00002517          	auipc	a0,0x2
    45ac:	46850513          	addi	a0,a0,1128 # 6a10 <malloc+0x9c6>
    45b0:	00002097          	auipc	ra,0x2
    45b4:	9da080e7          	jalr	-1574(ra) # 5f8a <printf>
      exit(1);
    45b8:	4505                	li	a0,1
    45ba:	00001097          	auipc	ra,0x1
    45be:	658080e7          	jalr	1624(ra) # 5c12 <exit>
        getpid();
    45c2:	00001097          	auipc	ra,0x1
    45c6:	6d0080e7          	jalr	1744(ra) # 5c92 <getpid>
      while(1) {
    45ca:	bfe5                	j	45c2 <killstatus+0x7c>
       printf("%s: status should be -1\n", s);
    45cc:	85d2                	mv	a1,s4
    45ce:	00003517          	auipc	a0,0x3
    45d2:	73250513          	addi	a0,a0,1842 # 7d00 <malloc+0x1cb6>
    45d6:	00002097          	auipc	ra,0x2
    45da:	9b4080e7          	jalr	-1612(ra) # 5f8a <printf>
       exit(1);
    45de:	4505                	li	a0,1
    45e0:	00001097          	auipc	ra,0x1
    45e4:	632080e7          	jalr	1586(ra) # 5c12 <exit>

00000000000045e8 <preempt>:
{
    45e8:	7139                	addi	sp,sp,-64
    45ea:	fc06                	sd	ra,56(sp)
    45ec:	f822                	sd	s0,48(sp)
    45ee:	f426                	sd	s1,40(sp)
    45f0:	f04a                	sd	s2,32(sp)
    45f2:	ec4e                	sd	s3,24(sp)
    45f4:	e852                	sd	s4,16(sp)
    45f6:	0080                	addi	s0,sp,64
    45f8:	8a2a                	mv	s4,a0
  pid1 = fork();
    45fa:	00001097          	auipc	ra,0x1
    45fe:	610080e7          	jalr	1552(ra) # 5c0a <fork>
  if(pid1 < 0) {
    4602:	00054563          	bltz	a0,460c <preempt+0x24>
    4606:	89aa                	mv	s3,a0
  if(pid1 == 0)
    4608:	e105                	bnez	a0,4628 <preempt+0x40>
    for(;;)
    460a:	a001                	j	460a <preempt+0x22>
    printf("%s: fork failed", s);
    460c:	85d2                	mv	a1,s4
    460e:	00002517          	auipc	a0,0x2
    4612:	5c250513          	addi	a0,a0,1474 # 6bd0 <malloc+0xb86>
    4616:	00002097          	auipc	ra,0x2
    461a:	974080e7          	jalr	-1676(ra) # 5f8a <printf>
    exit(1);
    461e:	4505                	li	a0,1
    4620:	00001097          	auipc	ra,0x1
    4624:	5f2080e7          	jalr	1522(ra) # 5c12 <exit>
  pid2 = fork();
    4628:	00001097          	auipc	ra,0x1
    462c:	5e2080e7          	jalr	1506(ra) # 5c0a <fork>
    4630:	892a                	mv	s2,a0
  if(pid2 < 0) {
    4632:	00054463          	bltz	a0,463a <preempt+0x52>
  if(pid2 == 0)
    4636:	e105                	bnez	a0,4656 <preempt+0x6e>
    for(;;)
    4638:	a001                	j	4638 <preempt+0x50>
    printf("%s: fork failed\n", s);
    463a:	85d2                	mv	a1,s4
    463c:	00002517          	auipc	a0,0x2
    4640:	3d450513          	addi	a0,a0,980 # 6a10 <malloc+0x9c6>
    4644:	00002097          	auipc	ra,0x2
    4648:	946080e7          	jalr	-1722(ra) # 5f8a <printf>
    exit(1);
    464c:	4505                	li	a0,1
    464e:	00001097          	auipc	ra,0x1
    4652:	5c4080e7          	jalr	1476(ra) # 5c12 <exit>
  pipe(pfds);
    4656:	fc840513          	addi	a0,s0,-56
    465a:	00001097          	auipc	ra,0x1
    465e:	5c8080e7          	jalr	1480(ra) # 5c22 <pipe>
  pid3 = fork();
    4662:	00001097          	auipc	ra,0x1
    4666:	5a8080e7          	jalr	1448(ra) # 5c0a <fork>
    466a:	84aa                	mv	s1,a0
  if(pid3 < 0) {
    466c:	02054e63          	bltz	a0,46a8 <preempt+0xc0>
  if(pid3 == 0){
    4670:	e525                	bnez	a0,46d8 <preempt+0xf0>
    close(pfds[0]);
    4672:	fc842503          	lw	a0,-56(s0)
    4676:	00001097          	auipc	ra,0x1
    467a:	5c4080e7          	jalr	1476(ra) # 5c3a <close>
    if(write(pfds[1], "x", 1) != 1)
    467e:	4605                	li	a2,1
    4680:	00002597          	auipc	a1,0x2
    4684:	b7858593          	addi	a1,a1,-1160 # 61f8 <malloc+0x1ae>
    4688:	fcc42503          	lw	a0,-52(s0)
    468c:	00001097          	auipc	ra,0x1
    4690:	5a6080e7          	jalr	1446(ra) # 5c32 <write>
    4694:	4785                	li	a5,1
    4696:	02f51763          	bne	a0,a5,46c4 <preempt+0xdc>
    close(pfds[1]);
    469a:	fcc42503          	lw	a0,-52(s0)
    469e:	00001097          	auipc	ra,0x1
    46a2:	59c080e7          	jalr	1436(ra) # 5c3a <close>
    for(;;)
    46a6:	a001                	j	46a6 <preempt+0xbe>
     printf("%s: fork failed\n", s);
    46a8:	85d2                	mv	a1,s4
    46aa:	00002517          	auipc	a0,0x2
    46ae:	36650513          	addi	a0,a0,870 # 6a10 <malloc+0x9c6>
    46b2:	00002097          	auipc	ra,0x2
    46b6:	8d8080e7          	jalr	-1832(ra) # 5f8a <printf>
     exit(1);
    46ba:	4505                	li	a0,1
    46bc:	00001097          	auipc	ra,0x1
    46c0:	556080e7          	jalr	1366(ra) # 5c12 <exit>
      printf("%s: preempt write error", s);
    46c4:	85d2                	mv	a1,s4
    46c6:	00003517          	auipc	a0,0x3
    46ca:	65a50513          	addi	a0,a0,1626 # 7d20 <malloc+0x1cd6>
    46ce:	00002097          	auipc	ra,0x2
    46d2:	8bc080e7          	jalr	-1860(ra) # 5f8a <printf>
    46d6:	b7d1                	j	469a <preempt+0xb2>
  close(pfds[1]);
    46d8:	fcc42503          	lw	a0,-52(s0)
    46dc:	00001097          	auipc	ra,0x1
    46e0:	55e080e7          	jalr	1374(ra) # 5c3a <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    46e4:	660d                	lui	a2,0x3
    46e6:	00008597          	auipc	a1,0x8
    46ea:	59258593          	addi	a1,a1,1426 # cc78 <buf>
    46ee:	fc842503          	lw	a0,-56(s0)
    46f2:	00001097          	auipc	ra,0x1
    46f6:	538080e7          	jalr	1336(ra) # 5c2a <read>
    46fa:	4785                	li	a5,1
    46fc:	02f50363          	beq	a0,a5,4722 <preempt+0x13a>
    printf("%s: preempt read error", s);
    4700:	85d2                	mv	a1,s4
    4702:	00003517          	auipc	a0,0x3
    4706:	63650513          	addi	a0,a0,1590 # 7d38 <malloc+0x1cee>
    470a:	00002097          	auipc	ra,0x2
    470e:	880080e7          	jalr	-1920(ra) # 5f8a <printf>
}
    4712:	70e2                	ld	ra,56(sp)
    4714:	7442                	ld	s0,48(sp)
    4716:	74a2                	ld	s1,40(sp)
    4718:	7902                	ld	s2,32(sp)
    471a:	69e2                	ld	s3,24(sp)
    471c:	6a42                	ld	s4,16(sp)
    471e:	6121                	addi	sp,sp,64
    4720:	8082                	ret
  close(pfds[0]);
    4722:	fc842503          	lw	a0,-56(s0)
    4726:	00001097          	auipc	ra,0x1
    472a:	514080e7          	jalr	1300(ra) # 5c3a <close>
  printf("kill... ");
    472e:	00003517          	auipc	a0,0x3
    4732:	62250513          	addi	a0,a0,1570 # 7d50 <malloc+0x1d06>
    4736:	00002097          	auipc	ra,0x2
    473a:	854080e7          	jalr	-1964(ra) # 5f8a <printf>
  kill(pid1);
    473e:	854e                	mv	a0,s3
    4740:	00001097          	auipc	ra,0x1
    4744:	502080e7          	jalr	1282(ra) # 5c42 <kill>
  kill(pid2);
    4748:	854a                	mv	a0,s2
    474a:	00001097          	auipc	ra,0x1
    474e:	4f8080e7          	jalr	1272(ra) # 5c42 <kill>
  kill(pid3);
    4752:	8526                	mv	a0,s1
    4754:	00001097          	auipc	ra,0x1
    4758:	4ee080e7          	jalr	1262(ra) # 5c42 <kill>
  printf("wait... ");
    475c:	00003517          	auipc	a0,0x3
    4760:	60450513          	addi	a0,a0,1540 # 7d60 <malloc+0x1d16>
    4764:	00002097          	auipc	ra,0x2
    4768:	826080e7          	jalr	-2010(ra) # 5f8a <printf>
  wait(0);
    476c:	4501                	li	a0,0
    476e:	00001097          	auipc	ra,0x1
    4772:	4ac080e7          	jalr	1196(ra) # 5c1a <wait>
  wait(0);
    4776:	4501                	li	a0,0
    4778:	00001097          	auipc	ra,0x1
    477c:	4a2080e7          	jalr	1186(ra) # 5c1a <wait>
  wait(0);
    4780:	4501                	li	a0,0
    4782:	00001097          	auipc	ra,0x1
    4786:	498080e7          	jalr	1176(ra) # 5c1a <wait>
    478a:	b761                	j	4712 <preempt+0x12a>

000000000000478c <reparent>:
{
    478c:	7179                	addi	sp,sp,-48
    478e:	f406                	sd	ra,40(sp)
    4790:	f022                	sd	s0,32(sp)
    4792:	ec26                	sd	s1,24(sp)
    4794:	e84a                	sd	s2,16(sp)
    4796:	e44e                	sd	s3,8(sp)
    4798:	e052                	sd	s4,0(sp)
    479a:	1800                	addi	s0,sp,48
    479c:	89aa                	mv	s3,a0
  int master_pid = getpid();
    479e:	00001097          	auipc	ra,0x1
    47a2:	4f4080e7          	jalr	1268(ra) # 5c92 <getpid>
    47a6:	8a2a                	mv	s4,a0
    47a8:	0c800913          	li	s2,200
    int pid = fork();
    47ac:	00001097          	auipc	ra,0x1
    47b0:	45e080e7          	jalr	1118(ra) # 5c0a <fork>
    47b4:	84aa                	mv	s1,a0
    if(pid < 0){
    47b6:	02054263          	bltz	a0,47da <reparent+0x4e>
    if(pid){
    47ba:	cd21                	beqz	a0,4812 <reparent+0x86>
      if(wait(0) != pid){
    47bc:	4501                	li	a0,0
    47be:	00001097          	auipc	ra,0x1
    47c2:	45c080e7          	jalr	1116(ra) # 5c1a <wait>
    47c6:	02951863          	bne	a0,s1,47f6 <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    47ca:	397d                	addiw	s2,s2,-1
    47cc:	fe0910e3          	bnez	s2,47ac <reparent+0x20>
  exit(0);
    47d0:	4501                	li	a0,0
    47d2:	00001097          	auipc	ra,0x1
    47d6:	440080e7          	jalr	1088(ra) # 5c12 <exit>
      printf("%s: fork failed\n", s);
    47da:	85ce                	mv	a1,s3
    47dc:	00002517          	auipc	a0,0x2
    47e0:	23450513          	addi	a0,a0,564 # 6a10 <malloc+0x9c6>
    47e4:	00001097          	auipc	ra,0x1
    47e8:	7a6080e7          	jalr	1958(ra) # 5f8a <printf>
      exit(1);
    47ec:	4505                	li	a0,1
    47ee:	00001097          	auipc	ra,0x1
    47f2:	424080e7          	jalr	1060(ra) # 5c12 <exit>
        printf("%s: wait wrong pid\n", s);
    47f6:	85ce                	mv	a1,s3
    47f8:	00002517          	auipc	a0,0x2
    47fc:	3a050513          	addi	a0,a0,928 # 6b98 <malloc+0xb4e>
    4800:	00001097          	auipc	ra,0x1
    4804:	78a080e7          	jalr	1930(ra) # 5f8a <printf>
        exit(1);
    4808:	4505                	li	a0,1
    480a:	00001097          	auipc	ra,0x1
    480e:	408080e7          	jalr	1032(ra) # 5c12 <exit>
      int pid2 = fork();
    4812:	00001097          	auipc	ra,0x1
    4816:	3f8080e7          	jalr	1016(ra) # 5c0a <fork>
      if(pid2 < 0){
    481a:	00054763          	bltz	a0,4828 <reparent+0x9c>
      exit(0);
    481e:	4501                	li	a0,0
    4820:	00001097          	auipc	ra,0x1
    4824:	3f2080e7          	jalr	1010(ra) # 5c12 <exit>
        kill(master_pid);
    4828:	8552                	mv	a0,s4
    482a:	00001097          	auipc	ra,0x1
    482e:	418080e7          	jalr	1048(ra) # 5c42 <kill>
        exit(1);
    4832:	4505                	li	a0,1
    4834:	00001097          	auipc	ra,0x1
    4838:	3de080e7          	jalr	990(ra) # 5c12 <exit>

000000000000483c <sbrkfail>:
{
    483c:	7119                	addi	sp,sp,-128
    483e:	fc86                	sd	ra,120(sp)
    4840:	f8a2                	sd	s0,112(sp)
    4842:	f4a6                	sd	s1,104(sp)
    4844:	f0ca                	sd	s2,96(sp)
    4846:	ecce                	sd	s3,88(sp)
    4848:	e8d2                	sd	s4,80(sp)
    484a:	e4d6                	sd	s5,72(sp)
    484c:	0100                	addi	s0,sp,128
    484e:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    4850:	fb040513          	addi	a0,s0,-80
    4854:	00001097          	auipc	ra,0x1
    4858:	3ce080e7          	jalr	974(ra) # 5c22 <pipe>
    485c:	e901                	bnez	a0,486c <sbrkfail+0x30>
    485e:	f8040493          	addi	s1,s0,-128
    4862:	fa840993          	addi	s3,s0,-88
    4866:	8926                	mv	s2,s1
    if(pids[i] != -1)
    4868:	5a7d                	li	s4,-1
    486a:	a085                	j	48ca <sbrkfail+0x8e>
    printf("%s: pipe() failed\n", s);
    486c:	85d6                	mv	a1,s5
    486e:	00002517          	auipc	a0,0x2
    4872:	2aa50513          	addi	a0,a0,682 # 6b18 <malloc+0xace>
    4876:	00001097          	auipc	ra,0x1
    487a:	714080e7          	jalr	1812(ra) # 5f8a <printf>
    exit(1);
    487e:	4505                	li	a0,1
    4880:	00001097          	auipc	ra,0x1
    4884:	392080e7          	jalr	914(ra) # 5c12 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    4888:	00001097          	auipc	ra,0x1
    488c:	412080e7          	jalr	1042(ra) # 5c9a <sbrk>
    4890:	064007b7          	lui	a5,0x6400
    4894:	40a7853b          	subw	a0,a5,a0
    4898:	00001097          	auipc	ra,0x1
    489c:	402080e7          	jalr	1026(ra) # 5c9a <sbrk>
      write(fds[1], "x", 1);
    48a0:	4605                	li	a2,1
    48a2:	00002597          	auipc	a1,0x2
    48a6:	95658593          	addi	a1,a1,-1706 # 61f8 <malloc+0x1ae>
    48aa:	fb442503          	lw	a0,-76(s0)
    48ae:	00001097          	auipc	ra,0x1
    48b2:	384080e7          	jalr	900(ra) # 5c32 <write>
      for(;;) sleep(1000);
    48b6:	3e800513          	li	a0,1000
    48ba:	00001097          	auipc	ra,0x1
    48be:	3e8080e7          	jalr	1000(ra) # 5ca2 <sleep>
    48c2:	bfd5                	j	48b6 <sbrkfail+0x7a>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    48c4:	0911                	addi	s2,s2,4
    48c6:	03390563          	beq	s2,s3,48f0 <sbrkfail+0xb4>
    if((pids[i] = fork()) == 0){
    48ca:	00001097          	auipc	ra,0x1
    48ce:	340080e7          	jalr	832(ra) # 5c0a <fork>
    48d2:	00a92023          	sw	a0,0(s2)
    48d6:	d94d                	beqz	a0,4888 <sbrkfail+0x4c>
    if(pids[i] != -1)
    48d8:	ff4506e3          	beq	a0,s4,48c4 <sbrkfail+0x88>
      read(fds[0], &scratch, 1);
    48dc:	4605                	li	a2,1
    48de:	faf40593          	addi	a1,s0,-81
    48e2:	fb042503          	lw	a0,-80(s0)
    48e6:	00001097          	auipc	ra,0x1
    48ea:	344080e7          	jalr	836(ra) # 5c2a <read>
    48ee:	bfd9                	j	48c4 <sbrkfail+0x88>
  c = sbrk(PGSIZE);
    48f0:	6505                	lui	a0,0x1
    48f2:	00001097          	auipc	ra,0x1
    48f6:	3a8080e7          	jalr	936(ra) # 5c9a <sbrk>
    48fa:	892a                	mv	s2,a0
    if(pids[i] == -1)
    48fc:	5a7d                	li	s4,-1
    48fe:	a021                	j	4906 <sbrkfail+0xca>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    4900:	0491                	addi	s1,s1,4
    4902:	01348f63          	beq	s1,s3,4920 <sbrkfail+0xe4>
    if(pids[i] == -1)
    4906:	4088                	lw	a0,0(s1)
    4908:	ff450ce3          	beq	a0,s4,4900 <sbrkfail+0xc4>
    kill(pids[i]);
    490c:	00001097          	auipc	ra,0x1
    4910:	336080e7          	jalr	822(ra) # 5c42 <kill>
    wait(0);
    4914:	4501                	li	a0,0
    4916:	00001097          	auipc	ra,0x1
    491a:	304080e7          	jalr	772(ra) # 5c1a <wait>
    491e:	b7cd                	j	4900 <sbrkfail+0xc4>
  if(c == (char*)0xffffffffffffffffL){
    4920:	57fd                	li	a5,-1
    4922:	04f90163          	beq	s2,a5,4964 <sbrkfail+0x128>
  pid = fork();
    4926:	00001097          	auipc	ra,0x1
    492a:	2e4080e7          	jalr	740(ra) # 5c0a <fork>
    492e:	84aa                	mv	s1,a0
  if(pid < 0){
    4930:	04054863          	bltz	a0,4980 <sbrkfail+0x144>
  if(pid == 0){
    4934:	c525                	beqz	a0,499c <sbrkfail+0x160>
  wait(&xstatus);
    4936:	fbc40513          	addi	a0,s0,-68
    493a:	00001097          	auipc	ra,0x1
    493e:	2e0080e7          	jalr	736(ra) # 5c1a <wait>
  if(xstatus != -1 && xstatus != 2)
    4942:	fbc42783          	lw	a5,-68(s0)
    4946:	577d                	li	a4,-1
    4948:	00e78563          	beq	a5,a4,4952 <sbrkfail+0x116>
    494c:	4709                	li	a4,2
    494e:	08e79d63          	bne	a5,a4,49e8 <sbrkfail+0x1ac>
}
    4952:	70e6                	ld	ra,120(sp)
    4954:	7446                	ld	s0,112(sp)
    4956:	74a6                	ld	s1,104(sp)
    4958:	7906                	ld	s2,96(sp)
    495a:	69e6                	ld	s3,88(sp)
    495c:	6a46                	ld	s4,80(sp)
    495e:	6aa6                	ld	s5,72(sp)
    4960:	6109                	addi	sp,sp,128
    4962:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    4964:	85d6                	mv	a1,s5
    4966:	00003517          	auipc	a0,0x3
    496a:	40a50513          	addi	a0,a0,1034 # 7d70 <malloc+0x1d26>
    496e:	00001097          	auipc	ra,0x1
    4972:	61c080e7          	jalr	1564(ra) # 5f8a <printf>
    exit(1);
    4976:	4505                	li	a0,1
    4978:	00001097          	auipc	ra,0x1
    497c:	29a080e7          	jalr	666(ra) # 5c12 <exit>
    printf("%s: fork failed\n", s);
    4980:	85d6                	mv	a1,s5
    4982:	00002517          	auipc	a0,0x2
    4986:	08e50513          	addi	a0,a0,142 # 6a10 <malloc+0x9c6>
    498a:	00001097          	auipc	ra,0x1
    498e:	600080e7          	jalr	1536(ra) # 5f8a <printf>
    exit(1);
    4992:	4505                	li	a0,1
    4994:	00001097          	auipc	ra,0x1
    4998:	27e080e7          	jalr	638(ra) # 5c12 <exit>
    a = sbrk(0);
    499c:	4501                	li	a0,0
    499e:	00001097          	auipc	ra,0x1
    49a2:	2fc080e7          	jalr	764(ra) # 5c9a <sbrk>
    49a6:	892a                	mv	s2,a0
    sbrk(10*BIG);
    49a8:	3e800537          	lui	a0,0x3e800
    49ac:	00001097          	auipc	ra,0x1
    49b0:	2ee080e7          	jalr	750(ra) # 5c9a <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    49b4:	874a                	mv	a4,s2
    49b6:	3e8007b7          	lui	a5,0x3e800
    49ba:	97ca                	add	a5,a5,s2
    49bc:	6685                	lui	a3,0x1
      n += *(a+i);
    49be:	00074603          	lbu	a2,0(a4)
    49c2:	9cb1                	addw	s1,s1,a2
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    49c4:	9736                	add	a4,a4,a3
    49c6:	fee79ce3          	bne	a5,a4,49be <sbrkfail+0x182>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    49ca:	8626                	mv	a2,s1
    49cc:	85d6                	mv	a1,s5
    49ce:	00003517          	auipc	a0,0x3
    49d2:	3c250513          	addi	a0,a0,962 # 7d90 <malloc+0x1d46>
    49d6:	00001097          	auipc	ra,0x1
    49da:	5b4080e7          	jalr	1460(ra) # 5f8a <printf>
    exit(1);
    49de:	4505                	li	a0,1
    49e0:	00001097          	auipc	ra,0x1
    49e4:	232080e7          	jalr	562(ra) # 5c12 <exit>
    exit(1);
    49e8:	4505                	li	a0,1
    49ea:	00001097          	auipc	ra,0x1
    49ee:	228080e7          	jalr	552(ra) # 5c12 <exit>

00000000000049f2 <mem>:
{
    49f2:	7139                	addi	sp,sp,-64
    49f4:	fc06                	sd	ra,56(sp)
    49f6:	f822                	sd	s0,48(sp)
    49f8:	f426                	sd	s1,40(sp)
    49fa:	f04a                	sd	s2,32(sp)
    49fc:	ec4e                	sd	s3,24(sp)
    49fe:	0080                	addi	s0,sp,64
    4a00:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    4a02:	00001097          	auipc	ra,0x1
    4a06:	208080e7          	jalr	520(ra) # 5c0a <fork>
    m1 = 0;
    4a0a:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    4a0c:	6909                	lui	s2,0x2
    4a0e:	71190913          	addi	s2,s2,1809 # 2711 <copyinstr3+0xdf>
  if((pid = fork()) == 0){
    4a12:	e135                	bnez	a0,4a76 <mem+0x84>
    while((m2 = malloc(10001)) != 0){
    4a14:	854a                	mv	a0,s2
    4a16:	00001097          	auipc	ra,0x1
    4a1a:	634080e7          	jalr	1588(ra) # 604a <malloc>
    4a1e:	c501                	beqz	a0,4a26 <mem+0x34>
      *(char**)m2 = m1;
    4a20:	e104                	sd	s1,0(a0)
      m1 = m2;
    4a22:	84aa                	mv	s1,a0
    4a24:	bfc5                	j	4a14 <mem+0x22>
    while(m1){
    4a26:	c899                	beqz	s1,4a3c <mem+0x4a>
      m2 = *(char**)m1;
    4a28:	0004b903          	ld	s2,0(s1)
      free(m1);
    4a2c:	8526                	mv	a0,s1
    4a2e:	00001097          	auipc	ra,0x1
    4a32:	592080e7          	jalr	1426(ra) # 5fc0 <free>
      m1 = m2;
    4a36:	84ca                	mv	s1,s2
    while(m1){
    4a38:	fe0918e3          	bnez	s2,4a28 <mem+0x36>
    m1 = malloc(1024*20);
    4a3c:	6515                	lui	a0,0x5
    4a3e:	00001097          	auipc	ra,0x1
    4a42:	60c080e7          	jalr	1548(ra) # 604a <malloc>
    if(m1 == 0){
    4a46:	c911                	beqz	a0,4a5a <mem+0x68>
    free(m1);
    4a48:	00001097          	auipc	ra,0x1
    4a4c:	578080e7          	jalr	1400(ra) # 5fc0 <free>
    exit(0);
    4a50:	4501                	li	a0,0
    4a52:	00001097          	auipc	ra,0x1
    4a56:	1c0080e7          	jalr	448(ra) # 5c12 <exit>
      printf("couldn't allocate mem?!!\n", s);
    4a5a:	85ce                	mv	a1,s3
    4a5c:	00003517          	auipc	a0,0x3
    4a60:	36450513          	addi	a0,a0,868 # 7dc0 <malloc+0x1d76>
    4a64:	00001097          	auipc	ra,0x1
    4a68:	526080e7          	jalr	1318(ra) # 5f8a <printf>
      exit(1);
    4a6c:	4505                	li	a0,1
    4a6e:	00001097          	auipc	ra,0x1
    4a72:	1a4080e7          	jalr	420(ra) # 5c12 <exit>
    wait(&xstatus);
    4a76:	fcc40513          	addi	a0,s0,-52
    4a7a:	00001097          	auipc	ra,0x1
    4a7e:	1a0080e7          	jalr	416(ra) # 5c1a <wait>
    if(xstatus == -1){
    4a82:	fcc42503          	lw	a0,-52(s0)
    4a86:	57fd                	li	a5,-1
    4a88:	00f50663          	beq	a0,a5,4a94 <mem+0xa2>
    exit(xstatus);
    4a8c:	00001097          	auipc	ra,0x1
    4a90:	186080e7          	jalr	390(ra) # 5c12 <exit>
      exit(0);
    4a94:	4501                	li	a0,0
    4a96:	00001097          	auipc	ra,0x1
    4a9a:	17c080e7          	jalr	380(ra) # 5c12 <exit>

0000000000004a9e <sharedfd>:
{
    4a9e:	7159                	addi	sp,sp,-112
    4aa0:	f486                	sd	ra,104(sp)
    4aa2:	f0a2                	sd	s0,96(sp)
    4aa4:	eca6                	sd	s1,88(sp)
    4aa6:	e8ca                	sd	s2,80(sp)
    4aa8:	e4ce                	sd	s3,72(sp)
    4aaa:	e0d2                	sd	s4,64(sp)
    4aac:	fc56                	sd	s5,56(sp)
    4aae:	f85a                	sd	s6,48(sp)
    4ab0:	f45e                	sd	s7,40(sp)
    4ab2:	1880                	addi	s0,sp,112
    4ab4:	89aa                	mv	s3,a0
  unlink("sharedfd");
    4ab6:	00003517          	auipc	a0,0x3
    4aba:	32a50513          	addi	a0,a0,810 # 7de0 <malloc+0x1d96>
    4abe:	00001097          	auipc	ra,0x1
    4ac2:	1a4080e7          	jalr	420(ra) # 5c62 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    4ac6:	20200593          	li	a1,514
    4aca:	00003517          	auipc	a0,0x3
    4ace:	31650513          	addi	a0,a0,790 # 7de0 <malloc+0x1d96>
    4ad2:	00001097          	auipc	ra,0x1
    4ad6:	180080e7          	jalr	384(ra) # 5c52 <open>
  if(fd < 0){
    4ada:	04054a63          	bltz	a0,4b2e <sharedfd+0x90>
    4ade:	892a                	mv	s2,a0
  pid = fork();
    4ae0:	00001097          	auipc	ra,0x1
    4ae4:	12a080e7          	jalr	298(ra) # 5c0a <fork>
    4ae8:	8a2a                	mv	s4,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    4aea:	06300593          	li	a1,99
    4aee:	c119                	beqz	a0,4af4 <sharedfd+0x56>
    4af0:	07000593          	li	a1,112
    4af4:	4629                	li	a2,10
    4af6:	fa040513          	addi	a0,s0,-96
    4afa:	00001097          	auipc	ra,0x1
    4afe:	f02080e7          	jalr	-254(ra) # 59fc <memset>
    4b02:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    4b06:	4629                	li	a2,10
    4b08:	fa040593          	addi	a1,s0,-96
    4b0c:	854a                	mv	a0,s2
    4b0e:	00001097          	auipc	ra,0x1
    4b12:	124080e7          	jalr	292(ra) # 5c32 <write>
    4b16:	47a9                	li	a5,10
    4b18:	02f51963          	bne	a0,a5,4b4a <sharedfd+0xac>
  for(i = 0; i < N; i++){
    4b1c:	34fd                	addiw	s1,s1,-1
    4b1e:	f4e5                	bnez	s1,4b06 <sharedfd+0x68>
  if(pid == 0) {
    4b20:	040a1363          	bnez	s4,4b66 <sharedfd+0xc8>
    exit(0);
    4b24:	4501                	li	a0,0
    4b26:	00001097          	auipc	ra,0x1
    4b2a:	0ec080e7          	jalr	236(ra) # 5c12 <exit>
    printf("%s: cannot open sharedfd for writing", s);
    4b2e:	85ce                	mv	a1,s3
    4b30:	00003517          	auipc	a0,0x3
    4b34:	2c050513          	addi	a0,a0,704 # 7df0 <malloc+0x1da6>
    4b38:	00001097          	auipc	ra,0x1
    4b3c:	452080e7          	jalr	1106(ra) # 5f8a <printf>
    exit(1);
    4b40:	4505                	li	a0,1
    4b42:	00001097          	auipc	ra,0x1
    4b46:	0d0080e7          	jalr	208(ra) # 5c12 <exit>
      printf("%s: write sharedfd failed\n", s);
    4b4a:	85ce                	mv	a1,s3
    4b4c:	00003517          	auipc	a0,0x3
    4b50:	2cc50513          	addi	a0,a0,716 # 7e18 <malloc+0x1dce>
    4b54:	00001097          	auipc	ra,0x1
    4b58:	436080e7          	jalr	1078(ra) # 5f8a <printf>
      exit(1);
    4b5c:	4505                	li	a0,1
    4b5e:	00001097          	auipc	ra,0x1
    4b62:	0b4080e7          	jalr	180(ra) # 5c12 <exit>
    wait(&xstatus);
    4b66:	f9c40513          	addi	a0,s0,-100
    4b6a:	00001097          	auipc	ra,0x1
    4b6e:	0b0080e7          	jalr	176(ra) # 5c1a <wait>
    if(xstatus != 0)
    4b72:	f9c42a03          	lw	s4,-100(s0)
    4b76:	000a0763          	beqz	s4,4b84 <sharedfd+0xe6>
      exit(xstatus);
    4b7a:	8552                	mv	a0,s4
    4b7c:	00001097          	auipc	ra,0x1
    4b80:	096080e7          	jalr	150(ra) # 5c12 <exit>
  close(fd);
    4b84:	854a                	mv	a0,s2
    4b86:	00001097          	auipc	ra,0x1
    4b8a:	0b4080e7          	jalr	180(ra) # 5c3a <close>
  fd = open("sharedfd", 0);
    4b8e:	4581                	li	a1,0
    4b90:	00003517          	auipc	a0,0x3
    4b94:	25050513          	addi	a0,a0,592 # 7de0 <malloc+0x1d96>
    4b98:	00001097          	auipc	ra,0x1
    4b9c:	0ba080e7          	jalr	186(ra) # 5c52 <open>
    4ba0:	8baa                	mv	s7,a0
  nc = np = 0;
    4ba2:	8ad2                	mv	s5,s4
  if(fd < 0){
    4ba4:	02054563          	bltz	a0,4bce <sharedfd+0x130>
    4ba8:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    4bac:	06300493          	li	s1,99
      if(buf[i] == 'p')
    4bb0:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    4bb4:	4629                	li	a2,10
    4bb6:	fa040593          	addi	a1,s0,-96
    4bba:	855e                	mv	a0,s7
    4bbc:	00001097          	auipc	ra,0x1
    4bc0:	06e080e7          	jalr	110(ra) # 5c2a <read>
    4bc4:	02a05f63          	blez	a0,4c02 <sharedfd+0x164>
    4bc8:	fa040793          	addi	a5,s0,-96
    4bcc:	a01d                	j	4bf2 <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    4bce:	85ce                	mv	a1,s3
    4bd0:	00003517          	auipc	a0,0x3
    4bd4:	26850513          	addi	a0,a0,616 # 7e38 <malloc+0x1dee>
    4bd8:	00001097          	auipc	ra,0x1
    4bdc:	3b2080e7          	jalr	946(ra) # 5f8a <printf>
    exit(1);
    4be0:	4505                	li	a0,1
    4be2:	00001097          	auipc	ra,0x1
    4be6:	030080e7          	jalr	48(ra) # 5c12 <exit>
        nc++;
    4bea:	2a05                	addiw	s4,s4,1
    for(i = 0; i < sizeof(buf); i++){
    4bec:	0785                	addi	a5,a5,1
    4bee:	fd2783e3          	beq	a5,s2,4bb4 <sharedfd+0x116>
      if(buf[i] == 'c')
    4bf2:	0007c703          	lbu	a4,0(a5) # 3e800000 <base+0x3e7f0388>
    4bf6:	fe970ae3          	beq	a4,s1,4bea <sharedfd+0x14c>
      if(buf[i] == 'p')
    4bfa:	ff6719e3          	bne	a4,s6,4bec <sharedfd+0x14e>
        np++;
    4bfe:	2a85                	addiw	s5,s5,1
    4c00:	b7f5                	j	4bec <sharedfd+0x14e>
  close(fd);
    4c02:	855e                	mv	a0,s7
    4c04:	00001097          	auipc	ra,0x1
    4c08:	036080e7          	jalr	54(ra) # 5c3a <close>
  unlink("sharedfd");
    4c0c:	00003517          	auipc	a0,0x3
    4c10:	1d450513          	addi	a0,a0,468 # 7de0 <malloc+0x1d96>
    4c14:	00001097          	auipc	ra,0x1
    4c18:	04e080e7          	jalr	78(ra) # 5c62 <unlink>
  if(nc == N*SZ && np == N*SZ){
    4c1c:	6789                	lui	a5,0x2
    4c1e:	71078793          	addi	a5,a5,1808 # 2710 <copyinstr3+0xde>
    4c22:	00fa1763          	bne	s4,a5,4c30 <sharedfd+0x192>
    4c26:	6789                	lui	a5,0x2
    4c28:	71078793          	addi	a5,a5,1808 # 2710 <copyinstr3+0xde>
    4c2c:	02fa8063          	beq	s5,a5,4c4c <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    4c30:	85ce                	mv	a1,s3
    4c32:	00003517          	auipc	a0,0x3
    4c36:	22e50513          	addi	a0,a0,558 # 7e60 <malloc+0x1e16>
    4c3a:	00001097          	auipc	ra,0x1
    4c3e:	350080e7          	jalr	848(ra) # 5f8a <printf>
    exit(1);
    4c42:	4505                	li	a0,1
    4c44:	00001097          	auipc	ra,0x1
    4c48:	fce080e7          	jalr	-50(ra) # 5c12 <exit>
    exit(0);
    4c4c:	4501                	li	a0,0
    4c4e:	00001097          	auipc	ra,0x1
    4c52:	fc4080e7          	jalr	-60(ra) # 5c12 <exit>

0000000000004c56 <fourfiles>:
{
    4c56:	7135                	addi	sp,sp,-160
    4c58:	ed06                	sd	ra,152(sp)
    4c5a:	e922                	sd	s0,144(sp)
    4c5c:	e526                	sd	s1,136(sp)
    4c5e:	e14a                	sd	s2,128(sp)
    4c60:	fcce                	sd	s3,120(sp)
    4c62:	f8d2                	sd	s4,112(sp)
    4c64:	f4d6                	sd	s5,104(sp)
    4c66:	f0da                	sd	s6,96(sp)
    4c68:	ecde                	sd	s7,88(sp)
    4c6a:	e8e2                	sd	s8,80(sp)
    4c6c:	e4e6                	sd	s9,72(sp)
    4c6e:	e0ea                	sd	s10,64(sp)
    4c70:	fc6e                	sd	s11,56(sp)
    4c72:	1100                	addi	s0,sp,160
    4c74:	8d2a                	mv	s10,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    4c76:	00003797          	auipc	a5,0x3
    4c7a:	20278793          	addi	a5,a5,514 # 7e78 <malloc+0x1e2e>
    4c7e:	f6f43823          	sd	a5,-144(s0)
    4c82:	00003797          	auipc	a5,0x3
    4c86:	1fe78793          	addi	a5,a5,510 # 7e80 <malloc+0x1e36>
    4c8a:	f6f43c23          	sd	a5,-136(s0)
    4c8e:	00003797          	auipc	a5,0x3
    4c92:	1fa78793          	addi	a5,a5,506 # 7e88 <malloc+0x1e3e>
    4c96:	f8f43023          	sd	a5,-128(s0)
    4c9a:	00003797          	auipc	a5,0x3
    4c9e:	1f678793          	addi	a5,a5,502 # 7e90 <malloc+0x1e46>
    4ca2:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    4ca6:	f7040b13          	addi	s6,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    4caa:	895a                	mv	s2,s6
  for(pi = 0; pi < NCHILD; pi++){
    4cac:	4481                	li	s1,0
    4cae:	4a11                	li	s4,4
    fname = names[pi];
    4cb0:	00093983          	ld	s3,0(s2)
    unlink(fname);
    4cb4:	854e                	mv	a0,s3
    4cb6:	00001097          	auipc	ra,0x1
    4cba:	fac080e7          	jalr	-84(ra) # 5c62 <unlink>
    pid = fork();
    4cbe:	00001097          	auipc	ra,0x1
    4cc2:	f4c080e7          	jalr	-180(ra) # 5c0a <fork>
    if(pid < 0){
    4cc6:	04054063          	bltz	a0,4d06 <fourfiles+0xb0>
    if(pid == 0){
    4cca:	cd21                	beqz	a0,4d22 <fourfiles+0xcc>
  for(pi = 0; pi < NCHILD; pi++){
    4ccc:	2485                	addiw	s1,s1,1
    4cce:	0921                	addi	s2,s2,8
    4cd0:	ff4490e3          	bne	s1,s4,4cb0 <fourfiles+0x5a>
    4cd4:	4491                	li	s1,4
    wait(&xstatus);
    4cd6:	f6c40513          	addi	a0,s0,-148
    4cda:	00001097          	auipc	ra,0x1
    4cde:	f40080e7          	jalr	-192(ra) # 5c1a <wait>
    if(xstatus != 0)
    4ce2:	f6c42503          	lw	a0,-148(s0)
    4ce6:	e961                	bnez	a0,4db6 <fourfiles+0x160>
  for(pi = 0; pi < NCHILD; pi++){
    4ce8:	34fd                	addiw	s1,s1,-1
    4cea:	f4f5                	bnez	s1,4cd6 <fourfiles+0x80>
    4cec:	03000a93          	li	s5,48
    total = 0;
    4cf0:	8daa                	mv	s11,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4cf2:	00008997          	auipc	s3,0x8
    4cf6:	f8698993          	addi	s3,s3,-122 # cc78 <buf>
    if(total != N*SZ){
    4cfa:	6c05                	lui	s8,0x1
    4cfc:	770c0c13          	addi	s8,s8,1904 # 1770 <exectest+0x1c>
  for(i = 0; i < NCHILD; i++){
    4d00:	03400c93          	li	s9,52
    4d04:	aa15                	j	4e38 <fourfiles+0x1e2>
      printf("fork failed\n", s);
    4d06:	85ea                	mv	a1,s10
    4d08:	00002517          	auipc	a0,0x2
    4d0c:	11050513          	addi	a0,a0,272 # 6e18 <malloc+0xdce>
    4d10:	00001097          	auipc	ra,0x1
    4d14:	27a080e7          	jalr	634(ra) # 5f8a <printf>
      exit(1);
    4d18:	4505                	li	a0,1
    4d1a:	00001097          	auipc	ra,0x1
    4d1e:	ef8080e7          	jalr	-264(ra) # 5c12 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    4d22:	20200593          	li	a1,514
    4d26:	854e                	mv	a0,s3
    4d28:	00001097          	auipc	ra,0x1
    4d2c:	f2a080e7          	jalr	-214(ra) # 5c52 <open>
    4d30:	892a                	mv	s2,a0
      if(fd < 0){
    4d32:	04054663          	bltz	a0,4d7e <fourfiles+0x128>
      memset(buf, '0'+pi, SZ);
    4d36:	1f400613          	li	a2,500
    4d3a:	0304859b          	addiw	a1,s1,48
    4d3e:	00008517          	auipc	a0,0x8
    4d42:	f3a50513          	addi	a0,a0,-198 # cc78 <buf>
    4d46:	00001097          	auipc	ra,0x1
    4d4a:	cb6080e7          	jalr	-842(ra) # 59fc <memset>
    4d4e:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    4d50:	00008997          	auipc	s3,0x8
    4d54:	f2898993          	addi	s3,s3,-216 # cc78 <buf>
    4d58:	1f400613          	li	a2,500
    4d5c:	85ce                	mv	a1,s3
    4d5e:	854a                	mv	a0,s2
    4d60:	00001097          	auipc	ra,0x1
    4d64:	ed2080e7          	jalr	-302(ra) # 5c32 <write>
    4d68:	1f400793          	li	a5,500
    4d6c:	02f51763          	bne	a0,a5,4d9a <fourfiles+0x144>
      for(i = 0; i < N; i++){
    4d70:	34fd                	addiw	s1,s1,-1
    4d72:	f0fd                	bnez	s1,4d58 <fourfiles+0x102>
      exit(0);
    4d74:	4501                	li	a0,0
    4d76:	00001097          	auipc	ra,0x1
    4d7a:	e9c080e7          	jalr	-356(ra) # 5c12 <exit>
        printf("create failed\n", s);
    4d7e:	85ea                	mv	a1,s10
    4d80:	00003517          	auipc	a0,0x3
    4d84:	11850513          	addi	a0,a0,280 # 7e98 <malloc+0x1e4e>
    4d88:	00001097          	auipc	ra,0x1
    4d8c:	202080e7          	jalr	514(ra) # 5f8a <printf>
        exit(1);
    4d90:	4505                	li	a0,1
    4d92:	00001097          	auipc	ra,0x1
    4d96:	e80080e7          	jalr	-384(ra) # 5c12 <exit>
          printf("write failed %d\n", n);
    4d9a:	85aa                	mv	a1,a0
    4d9c:	00003517          	auipc	a0,0x3
    4da0:	10c50513          	addi	a0,a0,268 # 7ea8 <malloc+0x1e5e>
    4da4:	00001097          	auipc	ra,0x1
    4da8:	1e6080e7          	jalr	486(ra) # 5f8a <printf>
          exit(1);
    4dac:	4505                	li	a0,1
    4dae:	00001097          	auipc	ra,0x1
    4db2:	e64080e7          	jalr	-412(ra) # 5c12 <exit>
      exit(xstatus);
    4db6:	00001097          	auipc	ra,0x1
    4dba:	e5c080e7          	jalr	-420(ra) # 5c12 <exit>
      total += n;
    4dbe:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4dc2:	660d                	lui	a2,0x3
    4dc4:	85ce                	mv	a1,s3
    4dc6:	8552                	mv	a0,s4
    4dc8:	00001097          	auipc	ra,0x1
    4dcc:	e62080e7          	jalr	-414(ra) # 5c2a <read>
    4dd0:	04a05463          	blez	a0,4e18 <fourfiles+0x1c2>
        if(buf[j] != '0'+i){
    4dd4:	0009c783          	lbu	a5,0(s3)
    4dd8:	02979263          	bne	a5,s1,4dfc <fourfiles+0x1a6>
    4ddc:	00008797          	auipc	a5,0x8
    4de0:	e9d78793          	addi	a5,a5,-355 # cc79 <buf+0x1>
    4de4:	fff5069b          	addiw	a3,a0,-1
    4de8:	1682                	slli	a3,a3,0x20
    4dea:	9281                	srli	a3,a3,0x20
    4dec:	96be                	add	a3,a3,a5
      for(j = 0; j < n; j++){
    4dee:	fcd788e3          	beq	a5,a3,4dbe <fourfiles+0x168>
        if(buf[j] != '0'+i){
    4df2:	0007c703          	lbu	a4,0(a5)
    4df6:	0785                	addi	a5,a5,1
    4df8:	fe970be3          	beq	a4,s1,4dee <fourfiles+0x198>
          printf("wrong char\n", s);
    4dfc:	85ea                	mv	a1,s10
    4dfe:	00003517          	auipc	a0,0x3
    4e02:	0c250513          	addi	a0,a0,194 # 7ec0 <malloc+0x1e76>
    4e06:	00001097          	auipc	ra,0x1
    4e0a:	184080e7          	jalr	388(ra) # 5f8a <printf>
          exit(1);
    4e0e:	4505                	li	a0,1
    4e10:	00001097          	auipc	ra,0x1
    4e14:	e02080e7          	jalr	-510(ra) # 5c12 <exit>
    close(fd);
    4e18:	8552                	mv	a0,s4
    4e1a:	00001097          	auipc	ra,0x1
    4e1e:	e20080e7          	jalr	-480(ra) # 5c3a <close>
    if(total != N*SZ){
    4e22:	03891863          	bne	s2,s8,4e52 <fourfiles+0x1fc>
    unlink(fname);
    4e26:	855e                	mv	a0,s7
    4e28:	00001097          	auipc	ra,0x1
    4e2c:	e3a080e7          	jalr	-454(ra) # 5c62 <unlink>
  for(i = 0; i < NCHILD; i++){
    4e30:	0b21                	addi	s6,s6,8
    4e32:	2a85                	addiw	s5,s5,1
    4e34:	039a8d63          	beq	s5,s9,4e6e <fourfiles+0x218>
    fname = names[i];
    4e38:	000b3b83          	ld	s7,0(s6) # 3000 <execout+0x72>
    fd = open(fname, 0);
    4e3c:	4581                	li	a1,0
    4e3e:	855e                	mv	a0,s7
    4e40:	00001097          	auipc	ra,0x1
    4e44:	e12080e7          	jalr	-494(ra) # 5c52 <open>
    4e48:	8a2a                	mv	s4,a0
    total = 0;
    4e4a:	896e                	mv	s2,s11
    4e4c:	000a849b          	sext.w	s1,s5
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4e50:	bf8d                	j	4dc2 <fourfiles+0x16c>
      printf("wrong length %d\n", total);
    4e52:	85ca                	mv	a1,s2
    4e54:	00003517          	auipc	a0,0x3
    4e58:	07c50513          	addi	a0,a0,124 # 7ed0 <malloc+0x1e86>
    4e5c:	00001097          	auipc	ra,0x1
    4e60:	12e080e7          	jalr	302(ra) # 5f8a <printf>
      exit(1);
    4e64:	4505                	li	a0,1
    4e66:	00001097          	auipc	ra,0x1
    4e6a:	dac080e7          	jalr	-596(ra) # 5c12 <exit>
}
    4e6e:	60ea                	ld	ra,152(sp)
    4e70:	644a                	ld	s0,144(sp)
    4e72:	64aa                	ld	s1,136(sp)
    4e74:	690a                	ld	s2,128(sp)
    4e76:	79e6                	ld	s3,120(sp)
    4e78:	7a46                	ld	s4,112(sp)
    4e7a:	7aa6                	ld	s5,104(sp)
    4e7c:	7b06                	ld	s6,96(sp)
    4e7e:	6be6                	ld	s7,88(sp)
    4e80:	6c46                	ld	s8,80(sp)
    4e82:	6ca6                	ld	s9,72(sp)
    4e84:	6d06                	ld	s10,64(sp)
    4e86:	7de2                	ld	s11,56(sp)
    4e88:	610d                	addi	sp,sp,160
    4e8a:	8082                	ret

0000000000004e8c <concreate>:
{
    4e8c:	7135                	addi	sp,sp,-160
    4e8e:	ed06                	sd	ra,152(sp)
    4e90:	e922                	sd	s0,144(sp)
    4e92:	e526                	sd	s1,136(sp)
    4e94:	e14a                	sd	s2,128(sp)
    4e96:	fcce                	sd	s3,120(sp)
    4e98:	f8d2                	sd	s4,112(sp)
    4e9a:	f4d6                	sd	s5,104(sp)
    4e9c:	f0da                	sd	s6,96(sp)
    4e9e:	ecde                	sd	s7,88(sp)
    4ea0:	1100                	addi	s0,sp,160
    4ea2:	89aa                	mv	s3,a0
  file[0] = 'C';
    4ea4:	04300793          	li	a5,67
    4ea8:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    4eac:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    4eb0:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    4eb2:	4b0d                	li	s6,3
    4eb4:	4a85                	li	s5,1
      link("C0", file);
    4eb6:	00003b97          	auipc	s7,0x3
    4eba:	032b8b93          	addi	s7,s7,50 # 7ee8 <malloc+0x1e9e>
  for(i = 0; i < N; i++){
    4ebe:	02800a13          	li	s4,40
    4ec2:	acc1                	j	5192 <concreate+0x306>
      link("C0", file);
    4ec4:	fa840593          	addi	a1,s0,-88
    4ec8:	855e                	mv	a0,s7
    4eca:	00001097          	auipc	ra,0x1
    4ece:	da8080e7          	jalr	-600(ra) # 5c72 <link>
    if(pid == 0) {
    4ed2:	a45d                	j	5178 <concreate+0x2ec>
    } else if(pid == 0 && (i % 5) == 1){
    4ed4:	4795                	li	a5,5
    4ed6:	02f9693b          	remw	s2,s2,a5
    4eda:	4785                	li	a5,1
    4edc:	02f90b63          	beq	s2,a5,4f12 <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    4ee0:	20200593          	li	a1,514
    4ee4:	fa840513          	addi	a0,s0,-88
    4ee8:	00001097          	auipc	ra,0x1
    4eec:	d6a080e7          	jalr	-662(ra) # 5c52 <open>
      if(fd < 0){
    4ef0:	26055b63          	bgez	a0,5166 <concreate+0x2da>
        printf("concreate create %s failed\n", file);
    4ef4:	fa840593          	addi	a1,s0,-88
    4ef8:	00003517          	auipc	a0,0x3
    4efc:	ff850513          	addi	a0,a0,-8 # 7ef0 <malloc+0x1ea6>
    4f00:	00001097          	auipc	ra,0x1
    4f04:	08a080e7          	jalr	138(ra) # 5f8a <printf>
        exit(1);
    4f08:	4505                	li	a0,1
    4f0a:	00001097          	auipc	ra,0x1
    4f0e:	d08080e7          	jalr	-760(ra) # 5c12 <exit>
      link("C0", file);
    4f12:	fa840593          	addi	a1,s0,-88
    4f16:	00003517          	auipc	a0,0x3
    4f1a:	fd250513          	addi	a0,a0,-46 # 7ee8 <malloc+0x1e9e>
    4f1e:	00001097          	auipc	ra,0x1
    4f22:	d54080e7          	jalr	-684(ra) # 5c72 <link>
      exit(0);
    4f26:	4501                	li	a0,0
    4f28:	00001097          	auipc	ra,0x1
    4f2c:	cea080e7          	jalr	-790(ra) # 5c12 <exit>
        exit(1);
    4f30:	4505                	li	a0,1
    4f32:	00001097          	auipc	ra,0x1
    4f36:	ce0080e7          	jalr	-800(ra) # 5c12 <exit>
  memset(fa, 0, sizeof(fa));
    4f3a:	02800613          	li	a2,40
    4f3e:	4581                	li	a1,0
    4f40:	f8040513          	addi	a0,s0,-128
    4f44:	00001097          	auipc	ra,0x1
    4f48:	ab8080e7          	jalr	-1352(ra) # 59fc <memset>
  fd = open(".", 0);
    4f4c:	4581                	li	a1,0
    4f4e:	00002517          	auipc	a0,0x2
    4f52:	92250513          	addi	a0,a0,-1758 # 6870 <malloc+0x826>
    4f56:	00001097          	auipc	ra,0x1
    4f5a:	cfc080e7          	jalr	-772(ra) # 5c52 <open>
    4f5e:	892a                	mv	s2,a0
  n = 0;
    4f60:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4f62:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    4f66:	02700b13          	li	s6,39
      fa[i] = 1;
    4f6a:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    4f6c:	4641                	li	a2,16
    4f6e:	f7040593          	addi	a1,s0,-144
    4f72:	854a                	mv	a0,s2
    4f74:	00001097          	auipc	ra,0x1
    4f78:	cb6080e7          	jalr	-842(ra) # 5c2a <read>
    4f7c:	08a05163          	blez	a0,4ffe <concreate+0x172>
    if(de.inum == 0)
    4f80:	f7045783          	lhu	a5,-144(s0)
    4f84:	d7e5                	beqz	a5,4f6c <concreate+0xe0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4f86:	f7244783          	lbu	a5,-142(s0)
    4f8a:	ff4791e3          	bne	a5,s4,4f6c <concreate+0xe0>
    4f8e:	f7444783          	lbu	a5,-140(s0)
    4f92:	ffe9                	bnez	a5,4f6c <concreate+0xe0>
      i = de.name[1] - '0';
    4f94:	f7344783          	lbu	a5,-141(s0)
    4f98:	fd07879b          	addiw	a5,a5,-48
    4f9c:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    4fa0:	00eb6f63          	bltu	s6,a4,4fbe <concreate+0x132>
      if(fa[i]){
    4fa4:	fb040793          	addi	a5,s0,-80
    4fa8:	97ba                	add	a5,a5,a4
    4faa:	fd07c783          	lbu	a5,-48(a5)
    4fae:	eb85                	bnez	a5,4fde <concreate+0x152>
      fa[i] = 1;
    4fb0:	fb040793          	addi	a5,s0,-80
    4fb4:	973e                	add	a4,a4,a5
    4fb6:	fd770823          	sb	s7,-48(a4)
      n++;
    4fba:	2a85                	addiw	s5,s5,1
    4fbc:	bf45                	j	4f6c <concreate+0xe0>
        printf("%s: concreate weird file %s\n", s, de.name);
    4fbe:	f7240613          	addi	a2,s0,-142
    4fc2:	85ce                	mv	a1,s3
    4fc4:	00003517          	auipc	a0,0x3
    4fc8:	f4c50513          	addi	a0,a0,-180 # 7f10 <malloc+0x1ec6>
    4fcc:	00001097          	auipc	ra,0x1
    4fd0:	fbe080e7          	jalr	-66(ra) # 5f8a <printf>
        exit(1);
    4fd4:	4505                	li	a0,1
    4fd6:	00001097          	auipc	ra,0x1
    4fda:	c3c080e7          	jalr	-964(ra) # 5c12 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    4fde:	f7240613          	addi	a2,s0,-142
    4fe2:	85ce                	mv	a1,s3
    4fe4:	00003517          	auipc	a0,0x3
    4fe8:	f4c50513          	addi	a0,a0,-180 # 7f30 <malloc+0x1ee6>
    4fec:	00001097          	auipc	ra,0x1
    4ff0:	f9e080e7          	jalr	-98(ra) # 5f8a <printf>
        exit(1);
    4ff4:	4505                	li	a0,1
    4ff6:	00001097          	auipc	ra,0x1
    4ffa:	c1c080e7          	jalr	-996(ra) # 5c12 <exit>
  close(fd);
    4ffe:	854a                	mv	a0,s2
    5000:	00001097          	auipc	ra,0x1
    5004:	c3a080e7          	jalr	-966(ra) # 5c3a <close>
  if(n != N){
    5008:	02800793          	li	a5,40
    500c:	00fa9763          	bne	s5,a5,501a <concreate+0x18e>
    if(((i % 3) == 0 && pid == 0) ||
    5010:	4a8d                	li	s5,3
    5012:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    5014:	02800a13          	li	s4,40
    5018:	a8c9                	j	50ea <concreate+0x25e>
    printf("%s: concreate not enough files in directory listing\n", s);
    501a:	85ce                	mv	a1,s3
    501c:	00003517          	auipc	a0,0x3
    5020:	f3c50513          	addi	a0,a0,-196 # 7f58 <malloc+0x1f0e>
    5024:	00001097          	auipc	ra,0x1
    5028:	f66080e7          	jalr	-154(ra) # 5f8a <printf>
    exit(1);
    502c:	4505                	li	a0,1
    502e:	00001097          	auipc	ra,0x1
    5032:	be4080e7          	jalr	-1052(ra) # 5c12 <exit>
      printf("%s: fork failed\n", s);
    5036:	85ce                	mv	a1,s3
    5038:	00002517          	auipc	a0,0x2
    503c:	9d850513          	addi	a0,a0,-1576 # 6a10 <malloc+0x9c6>
    5040:	00001097          	auipc	ra,0x1
    5044:	f4a080e7          	jalr	-182(ra) # 5f8a <printf>
      exit(1);
    5048:	4505                	li	a0,1
    504a:	00001097          	auipc	ra,0x1
    504e:	bc8080e7          	jalr	-1080(ra) # 5c12 <exit>
      close(open(file, 0));
    5052:	4581                	li	a1,0
    5054:	fa840513          	addi	a0,s0,-88
    5058:	00001097          	auipc	ra,0x1
    505c:	bfa080e7          	jalr	-1030(ra) # 5c52 <open>
    5060:	00001097          	auipc	ra,0x1
    5064:	bda080e7          	jalr	-1062(ra) # 5c3a <close>
      close(open(file, 0));
    5068:	4581                	li	a1,0
    506a:	fa840513          	addi	a0,s0,-88
    506e:	00001097          	auipc	ra,0x1
    5072:	be4080e7          	jalr	-1052(ra) # 5c52 <open>
    5076:	00001097          	auipc	ra,0x1
    507a:	bc4080e7          	jalr	-1084(ra) # 5c3a <close>
      close(open(file, 0));
    507e:	4581                	li	a1,0
    5080:	fa840513          	addi	a0,s0,-88
    5084:	00001097          	auipc	ra,0x1
    5088:	bce080e7          	jalr	-1074(ra) # 5c52 <open>
    508c:	00001097          	auipc	ra,0x1
    5090:	bae080e7          	jalr	-1106(ra) # 5c3a <close>
      close(open(file, 0));
    5094:	4581                	li	a1,0
    5096:	fa840513          	addi	a0,s0,-88
    509a:	00001097          	auipc	ra,0x1
    509e:	bb8080e7          	jalr	-1096(ra) # 5c52 <open>
    50a2:	00001097          	auipc	ra,0x1
    50a6:	b98080e7          	jalr	-1128(ra) # 5c3a <close>
      close(open(file, 0));
    50aa:	4581                	li	a1,0
    50ac:	fa840513          	addi	a0,s0,-88
    50b0:	00001097          	auipc	ra,0x1
    50b4:	ba2080e7          	jalr	-1118(ra) # 5c52 <open>
    50b8:	00001097          	auipc	ra,0x1
    50bc:	b82080e7          	jalr	-1150(ra) # 5c3a <close>
      close(open(file, 0));
    50c0:	4581                	li	a1,0
    50c2:	fa840513          	addi	a0,s0,-88
    50c6:	00001097          	auipc	ra,0x1
    50ca:	b8c080e7          	jalr	-1140(ra) # 5c52 <open>
    50ce:	00001097          	auipc	ra,0x1
    50d2:	b6c080e7          	jalr	-1172(ra) # 5c3a <close>
    if(pid == 0)
    50d6:	08090363          	beqz	s2,515c <concreate+0x2d0>
      wait(0);
    50da:	4501                	li	a0,0
    50dc:	00001097          	auipc	ra,0x1
    50e0:	b3e080e7          	jalr	-1218(ra) # 5c1a <wait>
  for(i = 0; i < N; i++){
    50e4:	2485                	addiw	s1,s1,1
    50e6:	0f448563          	beq	s1,s4,51d0 <concreate+0x344>
    file[1] = '0' + i;
    50ea:	0304879b          	addiw	a5,s1,48
    50ee:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    50f2:	00001097          	auipc	ra,0x1
    50f6:	b18080e7          	jalr	-1256(ra) # 5c0a <fork>
    50fa:	892a                	mv	s2,a0
    if(pid < 0){
    50fc:	f2054de3          	bltz	a0,5036 <concreate+0x1aa>
    if(((i % 3) == 0 && pid == 0) ||
    5100:	0354e73b          	remw	a4,s1,s5
    5104:	00a767b3          	or	a5,a4,a0
    5108:	2781                	sext.w	a5,a5
    510a:	d7a1                	beqz	a5,5052 <concreate+0x1c6>
    510c:	01671363          	bne	a4,s6,5112 <concreate+0x286>
       ((i % 3) == 1 && pid != 0)){
    5110:	f129                	bnez	a0,5052 <concreate+0x1c6>
      unlink(file);
    5112:	fa840513          	addi	a0,s0,-88
    5116:	00001097          	auipc	ra,0x1
    511a:	b4c080e7          	jalr	-1204(ra) # 5c62 <unlink>
      unlink(file);
    511e:	fa840513          	addi	a0,s0,-88
    5122:	00001097          	auipc	ra,0x1
    5126:	b40080e7          	jalr	-1216(ra) # 5c62 <unlink>
      unlink(file);
    512a:	fa840513          	addi	a0,s0,-88
    512e:	00001097          	auipc	ra,0x1
    5132:	b34080e7          	jalr	-1228(ra) # 5c62 <unlink>
      unlink(file);
    5136:	fa840513          	addi	a0,s0,-88
    513a:	00001097          	auipc	ra,0x1
    513e:	b28080e7          	jalr	-1240(ra) # 5c62 <unlink>
      unlink(file);
    5142:	fa840513          	addi	a0,s0,-88
    5146:	00001097          	auipc	ra,0x1
    514a:	b1c080e7          	jalr	-1252(ra) # 5c62 <unlink>
      unlink(file);
    514e:	fa840513          	addi	a0,s0,-88
    5152:	00001097          	auipc	ra,0x1
    5156:	b10080e7          	jalr	-1264(ra) # 5c62 <unlink>
    515a:	bfb5                	j	50d6 <concreate+0x24a>
      exit(0);
    515c:	4501                	li	a0,0
    515e:	00001097          	auipc	ra,0x1
    5162:	ab4080e7          	jalr	-1356(ra) # 5c12 <exit>
      close(fd);
    5166:	00001097          	auipc	ra,0x1
    516a:	ad4080e7          	jalr	-1324(ra) # 5c3a <close>
    if(pid == 0) {
    516e:	bb65                	j	4f26 <concreate+0x9a>
      close(fd);
    5170:	00001097          	auipc	ra,0x1
    5174:	aca080e7          	jalr	-1334(ra) # 5c3a <close>
      wait(&xstatus);
    5178:	f6c40513          	addi	a0,s0,-148
    517c:	00001097          	auipc	ra,0x1
    5180:	a9e080e7          	jalr	-1378(ra) # 5c1a <wait>
      if(xstatus != 0)
    5184:	f6c42483          	lw	s1,-148(s0)
    5188:	da0494e3          	bnez	s1,4f30 <concreate+0xa4>
  for(i = 0; i < N; i++){
    518c:	2905                	addiw	s2,s2,1
    518e:	db4906e3          	beq	s2,s4,4f3a <concreate+0xae>
    file[1] = '0' + i;
    5192:	0309079b          	addiw	a5,s2,48
    5196:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    519a:	fa840513          	addi	a0,s0,-88
    519e:	00001097          	auipc	ra,0x1
    51a2:	ac4080e7          	jalr	-1340(ra) # 5c62 <unlink>
    pid = fork();
    51a6:	00001097          	auipc	ra,0x1
    51aa:	a64080e7          	jalr	-1436(ra) # 5c0a <fork>
    if(pid && (i % 3) == 1){
    51ae:	d20503e3          	beqz	a0,4ed4 <concreate+0x48>
    51b2:	036967bb          	remw	a5,s2,s6
    51b6:	d15787e3          	beq	a5,s5,4ec4 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    51ba:	20200593          	li	a1,514
    51be:	fa840513          	addi	a0,s0,-88
    51c2:	00001097          	auipc	ra,0x1
    51c6:	a90080e7          	jalr	-1392(ra) # 5c52 <open>
      if(fd < 0){
    51ca:	fa0553e3          	bgez	a0,5170 <concreate+0x2e4>
    51ce:	b31d                	j	4ef4 <concreate+0x68>
}
    51d0:	60ea                	ld	ra,152(sp)
    51d2:	644a                	ld	s0,144(sp)
    51d4:	64aa                	ld	s1,136(sp)
    51d6:	690a                	ld	s2,128(sp)
    51d8:	79e6                	ld	s3,120(sp)
    51da:	7a46                	ld	s4,112(sp)
    51dc:	7aa6                	ld	s5,104(sp)
    51de:	7b06                	ld	s6,96(sp)
    51e0:	6be6                	ld	s7,88(sp)
    51e2:	610d                	addi	sp,sp,160
    51e4:	8082                	ret

00000000000051e6 <bigfile>:
{
    51e6:	7139                	addi	sp,sp,-64
    51e8:	fc06                	sd	ra,56(sp)
    51ea:	f822                	sd	s0,48(sp)
    51ec:	f426                	sd	s1,40(sp)
    51ee:	f04a                	sd	s2,32(sp)
    51f0:	ec4e                	sd	s3,24(sp)
    51f2:	e852                	sd	s4,16(sp)
    51f4:	e456                	sd	s5,8(sp)
    51f6:	0080                	addi	s0,sp,64
    51f8:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    51fa:	00003517          	auipc	a0,0x3
    51fe:	d9650513          	addi	a0,a0,-618 # 7f90 <malloc+0x1f46>
    5202:	00001097          	auipc	ra,0x1
    5206:	a60080e7          	jalr	-1440(ra) # 5c62 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    520a:	20200593          	li	a1,514
    520e:	00003517          	auipc	a0,0x3
    5212:	d8250513          	addi	a0,a0,-638 # 7f90 <malloc+0x1f46>
    5216:	00001097          	auipc	ra,0x1
    521a:	a3c080e7          	jalr	-1476(ra) # 5c52 <open>
    521e:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    5220:	4481                	li	s1,0
    memset(buf, i, SZ);
    5222:	00008917          	auipc	s2,0x8
    5226:	a5690913          	addi	s2,s2,-1450 # cc78 <buf>
  for(i = 0; i < N; i++){
    522a:	4a51                	li	s4,20
  if(fd < 0){
    522c:	0a054063          	bltz	a0,52cc <bigfile+0xe6>
    memset(buf, i, SZ);
    5230:	25800613          	li	a2,600
    5234:	85a6                	mv	a1,s1
    5236:	854a                	mv	a0,s2
    5238:	00000097          	auipc	ra,0x0
    523c:	7c4080e7          	jalr	1988(ra) # 59fc <memset>
    if(write(fd, buf, SZ) != SZ){
    5240:	25800613          	li	a2,600
    5244:	85ca                	mv	a1,s2
    5246:	854e                	mv	a0,s3
    5248:	00001097          	auipc	ra,0x1
    524c:	9ea080e7          	jalr	-1558(ra) # 5c32 <write>
    5250:	25800793          	li	a5,600
    5254:	08f51a63          	bne	a0,a5,52e8 <bigfile+0x102>
  for(i = 0; i < N; i++){
    5258:	2485                	addiw	s1,s1,1
    525a:	fd449be3          	bne	s1,s4,5230 <bigfile+0x4a>
  close(fd);
    525e:	854e                	mv	a0,s3
    5260:	00001097          	auipc	ra,0x1
    5264:	9da080e7          	jalr	-1574(ra) # 5c3a <close>
  fd = open("bigfile.dat", 0);
    5268:	4581                	li	a1,0
    526a:	00003517          	auipc	a0,0x3
    526e:	d2650513          	addi	a0,a0,-730 # 7f90 <malloc+0x1f46>
    5272:	00001097          	auipc	ra,0x1
    5276:	9e0080e7          	jalr	-1568(ra) # 5c52 <open>
    527a:	8a2a                	mv	s4,a0
  total = 0;
    527c:	4981                	li	s3,0
  for(i = 0; ; i++){
    527e:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    5280:	00008917          	auipc	s2,0x8
    5284:	9f890913          	addi	s2,s2,-1544 # cc78 <buf>
  if(fd < 0){
    5288:	06054e63          	bltz	a0,5304 <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    528c:	12c00613          	li	a2,300
    5290:	85ca                	mv	a1,s2
    5292:	8552                	mv	a0,s4
    5294:	00001097          	auipc	ra,0x1
    5298:	996080e7          	jalr	-1642(ra) # 5c2a <read>
    if(cc < 0){
    529c:	08054263          	bltz	a0,5320 <bigfile+0x13a>
    if(cc == 0)
    52a0:	c971                	beqz	a0,5374 <bigfile+0x18e>
    if(cc != SZ/2){
    52a2:	12c00793          	li	a5,300
    52a6:	08f51b63          	bne	a0,a5,533c <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    52aa:	01f4d79b          	srliw	a5,s1,0x1f
    52ae:	9fa5                	addw	a5,a5,s1
    52b0:	4017d79b          	sraiw	a5,a5,0x1
    52b4:	00094703          	lbu	a4,0(s2)
    52b8:	0af71063          	bne	a4,a5,5358 <bigfile+0x172>
    52bc:	12b94703          	lbu	a4,299(s2)
    52c0:	08f71c63          	bne	a4,a5,5358 <bigfile+0x172>
    total += cc;
    52c4:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    52c8:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    52ca:	b7c9                	j	528c <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    52cc:	85d6                	mv	a1,s5
    52ce:	00003517          	auipc	a0,0x3
    52d2:	cd250513          	addi	a0,a0,-814 # 7fa0 <malloc+0x1f56>
    52d6:	00001097          	auipc	ra,0x1
    52da:	cb4080e7          	jalr	-844(ra) # 5f8a <printf>
    exit(1);
    52de:	4505                	li	a0,1
    52e0:	00001097          	auipc	ra,0x1
    52e4:	932080e7          	jalr	-1742(ra) # 5c12 <exit>
      printf("%s: write bigfile failed\n", s);
    52e8:	85d6                	mv	a1,s5
    52ea:	00003517          	auipc	a0,0x3
    52ee:	cd650513          	addi	a0,a0,-810 # 7fc0 <malloc+0x1f76>
    52f2:	00001097          	auipc	ra,0x1
    52f6:	c98080e7          	jalr	-872(ra) # 5f8a <printf>
      exit(1);
    52fa:	4505                	li	a0,1
    52fc:	00001097          	auipc	ra,0x1
    5300:	916080e7          	jalr	-1770(ra) # 5c12 <exit>
    printf("%s: cannot open bigfile\n", s);
    5304:	85d6                	mv	a1,s5
    5306:	00003517          	auipc	a0,0x3
    530a:	cda50513          	addi	a0,a0,-806 # 7fe0 <malloc+0x1f96>
    530e:	00001097          	auipc	ra,0x1
    5312:	c7c080e7          	jalr	-900(ra) # 5f8a <printf>
    exit(1);
    5316:	4505                	li	a0,1
    5318:	00001097          	auipc	ra,0x1
    531c:	8fa080e7          	jalr	-1798(ra) # 5c12 <exit>
      printf("%s: read bigfile failed\n", s);
    5320:	85d6                	mv	a1,s5
    5322:	00003517          	auipc	a0,0x3
    5326:	cde50513          	addi	a0,a0,-802 # 8000 <malloc+0x1fb6>
    532a:	00001097          	auipc	ra,0x1
    532e:	c60080e7          	jalr	-928(ra) # 5f8a <printf>
      exit(1);
    5332:	4505                	li	a0,1
    5334:	00001097          	auipc	ra,0x1
    5338:	8de080e7          	jalr	-1826(ra) # 5c12 <exit>
      printf("%s: short read bigfile\n", s);
    533c:	85d6                	mv	a1,s5
    533e:	00003517          	auipc	a0,0x3
    5342:	ce250513          	addi	a0,a0,-798 # 8020 <malloc+0x1fd6>
    5346:	00001097          	auipc	ra,0x1
    534a:	c44080e7          	jalr	-956(ra) # 5f8a <printf>
      exit(1);
    534e:	4505                	li	a0,1
    5350:	00001097          	auipc	ra,0x1
    5354:	8c2080e7          	jalr	-1854(ra) # 5c12 <exit>
      printf("%s: read bigfile wrong data\n", s);
    5358:	85d6                	mv	a1,s5
    535a:	00003517          	auipc	a0,0x3
    535e:	cde50513          	addi	a0,a0,-802 # 8038 <malloc+0x1fee>
    5362:	00001097          	auipc	ra,0x1
    5366:	c28080e7          	jalr	-984(ra) # 5f8a <printf>
      exit(1);
    536a:	4505                	li	a0,1
    536c:	00001097          	auipc	ra,0x1
    5370:	8a6080e7          	jalr	-1882(ra) # 5c12 <exit>
  close(fd);
    5374:	8552                	mv	a0,s4
    5376:	00001097          	auipc	ra,0x1
    537a:	8c4080e7          	jalr	-1852(ra) # 5c3a <close>
  if(total != N*SZ){
    537e:	678d                	lui	a5,0x3
    5380:	ee078793          	addi	a5,a5,-288 # 2ee0 <sbrklast+0x5e>
    5384:	02f99363          	bne	s3,a5,53aa <bigfile+0x1c4>
  unlink("bigfile.dat");
    5388:	00003517          	auipc	a0,0x3
    538c:	c0850513          	addi	a0,a0,-1016 # 7f90 <malloc+0x1f46>
    5390:	00001097          	auipc	ra,0x1
    5394:	8d2080e7          	jalr	-1838(ra) # 5c62 <unlink>
}
    5398:	70e2                	ld	ra,56(sp)
    539a:	7442                	ld	s0,48(sp)
    539c:	74a2                	ld	s1,40(sp)
    539e:	7902                	ld	s2,32(sp)
    53a0:	69e2                	ld	s3,24(sp)
    53a2:	6a42                	ld	s4,16(sp)
    53a4:	6aa2                	ld	s5,8(sp)
    53a6:	6121                	addi	sp,sp,64
    53a8:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    53aa:	85d6                	mv	a1,s5
    53ac:	00003517          	auipc	a0,0x3
    53b0:	cac50513          	addi	a0,a0,-852 # 8058 <malloc+0x200e>
    53b4:	00001097          	auipc	ra,0x1
    53b8:	bd6080e7          	jalr	-1066(ra) # 5f8a <printf>
    exit(1);
    53bc:	4505                	li	a0,1
    53be:	00001097          	auipc	ra,0x1
    53c2:	854080e7          	jalr	-1964(ra) # 5c12 <exit>

00000000000053c6 <fsfull>:
{
    53c6:	7171                	addi	sp,sp,-176
    53c8:	f506                	sd	ra,168(sp)
    53ca:	f122                	sd	s0,160(sp)
    53cc:	ed26                	sd	s1,152(sp)
    53ce:	e94a                	sd	s2,144(sp)
    53d0:	e54e                	sd	s3,136(sp)
    53d2:	e152                	sd	s4,128(sp)
    53d4:	fcd6                	sd	s5,120(sp)
    53d6:	f8da                	sd	s6,112(sp)
    53d8:	f4de                	sd	s7,104(sp)
    53da:	f0e2                	sd	s8,96(sp)
    53dc:	ece6                	sd	s9,88(sp)
    53de:	e8ea                	sd	s10,80(sp)
    53e0:	e4ee                	sd	s11,72(sp)
    53e2:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    53e4:	00003517          	auipc	a0,0x3
    53e8:	c9450513          	addi	a0,a0,-876 # 8078 <malloc+0x202e>
    53ec:	00001097          	auipc	ra,0x1
    53f0:	b9e080e7          	jalr	-1122(ra) # 5f8a <printf>
  for(nfiles = 0; ; nfiles++){
    53f4:	4481                	li	s1,0
    name[0] = 'f';
    53f6:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    53fa:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    53fe:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    5402:	4b29                	li	s6,10
    printf("writing %s\n", name);
    5404:	00003c97          	auipc	s9,0x3
    5408:	c84c8c93          	addi	s9,s9,-892 # 8088 <malloc+0x203e>
    int total = 0;
    540c:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    540e:	00008a17          	auipc	s4,0x8
    5412:	86aa0a13          	addi	s4,s4,-1942 # cc78 <buf>
    name[0] = 'f';
    5416:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    541a:	0384c7bb          	divw	a5,s1,s8
    541e:	0307879b          	addiw	a5,a5,48
    5422:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    5426:	0384e7bb          	remw	a5,s1,s8
    542a:	0377c7bb          	divw	a5,a5,s7
    542e:	0307879b          	addiw	a5,a5,48
    5432:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    5436:	0374e7bb          	remw	a5,s1,s7
    543a:	0367c7bb          	divw	a5,a5,s6
    543e:	0307879b          	addiw	a5,a5,48
    5442:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    5446:	0364e7bb          	remw	a5,s1,s6
    544a:	0307879b          	addiw	a5,a5,48
    544e:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    5452:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    5456:	f5040593          	addi	a1,s0,-176
    545a:	8566                	mv	a0,s9
    545c:	00001097          	auipc	ra,0x1
    5460:	b2e080e7          	jalr	-1234(ra) # 5f8a <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    5464:	20200593          	li	a1,514
    5468:	f5040513          	addi	a0,s0,-176
    546c:	00000097          	auipc	ra,0x0
    5470:	7e6080e7          	jalr	2022(ra) # 5c52 <open>
    5474:	89aa                	mv	s3,a0
    if(fd < 0){
    5476:	0a055663          	bgez	a0,5522 <fsfull+0x15c>
      printf("open %s failed\n", name);
    547a:	f5040593          	addi	a1,s0,-176
    547e:	00003517          	auipc	a0,0x3
    5482:	c1a50513          	addi	a0,a0,-998 # 8098 <malloc+0x204e>
    5486:	00001097          	auipc	ra,0x1
    548a:	b04080e7          	jalr	-1276(ra) # 5f8a <printf>
  while(nfiles >= 0){
    548e:	0604c363          	bltz	s1,54f4 <fsfull+0x12e>
    name[0] = 'f';
    5492:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    5496:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    549a:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    549e:	4929                	li	s2,10
  while(nfiles >= 0){
    54a0:	5afd                	li	s5,-1
    name[0] = 'f';
    54a2:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    54a6:	0344c7bb          	divw	a5,s1,s4
    54aa:	0307879b          	addiw	a5,a5,48
    54ae:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    54b2:	0344e7bb          	remw	a5,s1,s4
    54b6:	0337c7bb          	divw	a5,a5,s3
    54ba:	0307879b          	addiw	a5,a5,48
    54be:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    54c2:	0334e7bb          	remw	a5,s1,s3
    54c6:	0327c7bb          	divw	a5,a5,s2
    54ca:	0307879b          	addiw	a5,a5,48
    54ce:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    54d2:	0324e7bb          	remw	a5,s1,s2
    54d6:	0307879b          	addiw	a5,a5,48
    54da:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    54de:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    54e2:	f5040513          	addi	a0,s0,-176
    54e6:	00000097          	auipc	ra,0x0
    54ea:	77c080e7          	jalr	1916(ra) # 5c62 <unlink>
    nfiles--;
    54ee:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    54f0:	fb5499e3          	bne	s1,s5,54a2 <fsfull+0xdc>
  printf("fsfull test finished\n");
    54f4:	00003517          	auipc	a0,0x3
    54f8:	bc450513          	addi	a0,a0,-1084 # 80b8 <malloc+0x206e>
    54fc:	00001097          	auipc	ra,0x1
    5500:	a8e080e7          	jalr	-1394(ra) # 5f8a <printf>
}
    5504:	70aa                	ld	ra,168(sp)
    5506:	740a                	ld	s0,160(sp)
    5508:	64ea                	ld	s1,152(sp)
    550a:	694a                	ld	s2,144(sp)
    550c:	69aa                	ld	s3,136(sp)
    550e:	6a0a                	ld	s4,128(sp)
    5510:	7ae6                	ld	s5,120(sp)
    5512:	7b46                	ld	s6,112(sp)
    5514:	7ba6                	ld	s7,104(sp)
    5516:	7c06                	ld	s8,96(sp)
    5518:	6ce6                	ld	s9,88(sp)
    551a:	6d46                	ld	s10,80(sp)
    551c:	6da6                	ld	s11,72(sp)
    551e:	614d                	addi	sp,sp,176
    5520:	8082                	ret
    int total = 0;
    5522:	896e                	mv	s2,s11
      if(cc < BSIZE)
    5524:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    5528:	40000613          	li	a2,1024
    552c:	85d2                	mv	a1,s4
    552e:	854e                	mv	a0,s3
    5530:	00000097          	auipc	ra,0x0
    5534:	702080e7          	jalr	1794(ra) # 5c32 <write>
      if(cc < BSIZE)
    5538:	00aad563          	bge	s5,a0,5542 <fsfull+0x17c>
      total += cc;
    553c:	00a9093b          	addw	s2,s2,a0
    while(1){
    5540:	b7e5                	j	5528 <fsfull+0x162>
    printf("wrote %d bytes\n", total);
    5542:	85ca                	mv	a1,s2
    5544:	00003517          	auipc	a0,0x3
    5548:	b6450513          	addi	a0,a0,-1180 # 80a8 <malloc+0x205e>
    554c:	00001097          	auipc	ra,0x1
    5550:	a3e080e7          	jalr	-1474(ra) # 5f8a <printf>
    close(fd);
    5554:	854e                	mv	a0,s3
    5556:	00000097          	auipc	ra,0x0
    555a:	6e4080e7          	jalr	1764(ra) # 5c3a <close>
    if(total == 0)
    555e:	f20908e3          	beqz	s2,548e <fsfull+0xc8>
  for(nfiles = 0; ; nfiles++){
    5562:	2485                	addiw	s1,s1,1
    5564:	bd4d                	j	5416 <fsfull+0x50>

0000000000005566 <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    5566:	7179                	addi	sp,sp,-48
    5568:	f406                	sd	ra,40(sp)
    556a:	f022                	sd	s0,32(sp)
    556c:	ec26                	sd	s1,24(sp)
    556e:	e84a                	sd	s2,16(sp)
    5570:	1800                	addi	s0,sp,48
    5572:	84aa                	mv	s1,a0
    5574:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    5576:	00003517          	auipc	a0,0x3
    557a:	b5a50513          	addi	a0,a0,-1190 # 80d0 <malloc+0x2086>
    557e:	00001097          	auipc	ra,0x1
    5582:	a0c080e7          	jalr	-1524(ra) # 5f8a <printf>
  if((pid = fork()) < 0) {
    5586:	00000097          	auipc	ra,0x0
    558a:	684080e7          	jalr	1668(ra) # 5c0a <fork>
    558e:	02054e63          	bltz	a0,55ca <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    5592:	c929                	beqz	a0,55e4 <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    5594:	fdc40513          	addi	a0,s0,-36
    5598:	00000097          	auipc	ra,0x0
    559c:	682080e7          	jalr	1666(ra) # 5c1a <wait>
    if(xstatus != 0) 
    55a0:	fdc42783          	lw	a5,-36(s0)
    55a4:	c7b9                	beqz	a5,55f2 <run+0x8c>
      printf("FAILED\n");
    55a6:	00003517          	auipc	a0,0x3
    55aa:	b5250513          	addi	a0,a0,-1198 # 80f8 <malloc+0x20ae>
    55ae:	00001097          	auipc	ra,0x1
    55b2:	9dc080e7          	jalr	-1572(ra) # 5f8a <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    55b6:	fdc42503          	lw	a0,-36(s0)
  }
}
    55ba:	00153513          	seqz	a0,a0
    55be:	70a2                	ld	ra,40(sp)
    55c0:	7402                	ld	s0,32(sp)
    55c2:	64e2                	ld	s1,24(sp)
    55c4:	6942                	ld	s2,16(sp)
    55c6:	6145                	addi	sp,sp,48
    55c8:	8082                	ret
    printf("runtest: fork error\n");
    55ca:	00003517          	auipc	a0,0x3
    55ce:	b1650513          	addi	a0,a0,-1258 # 80e0 <malloc+0x2096>
    55d2:	00001097          	auipc	ra,0x1
    55d6:	9b8080e7          	jalr	-1608(ra) # 5f8a <printf>
    exit(1);
    55da:	4505                	li	a0,1
    55dc:	00000097          	auipc	ra,0x0
    55e0:	636080e7          	jalr	1590(ra) # 5c12 <exit>
    f(s);
    55e4:	854a                	mv	a0,s2
    55e6:	9482                	jalr	s1
    exit(0);
    55e8:	4501                	li	a0,0
    55ea:	00000097          	auipc	ra,0x0
    55ee:	628080e7          	jalr	1576(ra) # 5c12 <exit>
      printf("OK\n");
    55f2:	00003517          	auipc	a0,0x3
    55f6:	b0e50513          	addi	a0,a0,-1266 # 8100 <malloc+0x20b6>
    55fa:	00001097          	auipc	ra,0x1
    55fe:	990080e7          	jalr	-1648(ra) # 5f8a <printf>
    5602:	bf55                	j	55b6 <run+0x50>

0000000000005604 <runtests>:

int
runtests(struct test *tests, char *justone) {
    5604:	1101                	addi	sp,sp,-32
    5606:	ec06                	sd	ra,24(sp)
    5608:	e822                	sd	s0,16(sp)
    560a:	e426                	sd	s1,8(sp)
    560c:	e04a                	sd	s2,0(sp)
    560e:	1000                	addi	s0,sp,32
    5610:	84aa                	mv	s1,a0
    5612:	892e                	mv	s2,a1
  for (struct test *t = tests; t->s != 0; t++) {
    5614:	6508                	ld	a0,8(a0)
    5616:	ed09                	bnez	a0,5630 <runtests+0x2c>
        printf("SOME TESTS FAILED\n");
        return 1;
      }
    }
  }
  return 0;
    5618:	4501                	li	a0,0
    561a:	a82d                	j	5654 <runtests+0x50>
      if(!run(t->f, t->s)){
    561c:	648c                	ld	a1,8(s1)
    561e:	6088                	ld	a0,0(s1)
    5620:	00000097          	auipc	ra,0x0
    5624:	f46080e7          	jalr	-186(ra) # 5566 <run>
    5628:	cd09                	beqz	a0,5642 <runtests+0x3e>
  for (struct test *t = tests; t->s != 0; t++) {
    562a:	04c1                	addi	s1,s1,16
    562c:	6488                	ld	a0,8(s1)
    562e:	c11d                	beqz	a0,5654 <runtests+0x50>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    5630:	fe0906e3          	beqz	s2,561c <runtests+0x18>
    5634:	85ca                	mv	a1,s2
    5636:	00000097          	auipc	ra,0x0
    563a:	368080e7          	jalr	872(ra) # 599e <strcmp>
    563e:	f575                	bnez	a0,562a <runtests+0x26>
    5640:	bff1                	j	561c <runtests+0x18>
        printf("SOME TESTS FAILED\n");
    5642:	00003517          	auipc	a0,0x3
    5646:	ac650513          	addi	a0,a0,-1338 # 8108 <malloc+0x20be>
    564a:	00001097          	auipc	ra,0x1
    564e:	940080e7          	jalr	-1728(ra) # 5f8a <printf>
        return 1;
    5652:	4505                	li	a0,1
}
    5654:	60e2                	ld	ra,24(sp)
    5656:	6442                	ld	s0,16(sp)
    5658:	64a2                	ld	s1,8(sp)
    565a:	6902                	ld	s2,0(sp)
    565c:	6105                	addi	sp,sp,32
    565e:	8082                	ret

0000000000005660 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    5660:	7139                	addi	sp,sp,-64
    5662:	fc06                	sd	ra,56(sp)
    5664:	f822                	sd	s0,48(sp)
    5666:	f426                	sd	s1,40(sp)
    5668:	f04a                	sd	s2,32(sp)
    566a:	ec4e                	sd	s3,24(sp)
    566c:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    566e:	fc840513          	addi	a0,s0,-56
    5672:	00000097          	auipc	ra,0x0
    5676:	5b0080e7          	jalr	1456(ra) # 5c22 <pipe>
    567a:	06054863          	bltz	a0,56ea <countfree+0x8a>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    567e:	00000097          	auipc	ra,0x0
    5682:	58c080e7          	jalr	1420(ra) # 5c0a <fork>

  if(pid < 0){
    5686:	06054f63          	bltz	a0,5704 <countfree+0xa4>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    568a:	ed59                	bnez	a0,5728 <countfree+0xc8>
    close(fds[0]);
    568c:	fc842503          	lw	a0,-56(s0)
    5690:	00000097          	auipc	ra,0x0
    5694:	5aa080e7          	jalr	1450(ra) # 5c3a <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    5698:	54fd                	li	s1,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    569a:	4985                	li	s3,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    569c:	00001917          	auipc	s2,0x1
    56a0:	b5c90913          	addi	s2,s2,-1188 # 61f8 <malloc+0x1ae>
      uint64 a = (uint64) sbrk(4096);
    56a4:	6505                	lui	a0,0x1
    56a6:	00000097          	auipc	ra,0x0
    56aa:	5f4080e7          	jalr	1524(ra) # 5c9a <sbrk>
      if(a == 0xffffffffffffffff){
    56ae:	06950863          	beq	a0,s1,571e <countfree+0xbe>
      *(char *)(a + 4096 - 1) = 1;
    56b2:	6785                	lui	a5,0x1
    56b4:	97aa                	add	a5,a5,a0
    56b6:	ff378fa3          	sb	s3,-1(a5) # fff <linktest+0xf7>
      if(write(fds[1], "x", 1) != 1){
    56ba:	4605                	li	a2,1
    56bc:	85ca                	mv	a1,s2
    56be:	fcc42503          	lw	a0,-52(s0)
    56c2:	00000097          	auipc	ra,0x0
    56c6:	570080e7          	jalr	1392(ra) # 5c32 <write>
    56ca:	4785                	li	a5,1
    56cc:	fcf50ce3          	beq	a0,a5,56a4 <countfree+0x44>
        printf("write() failed in countfree()\n");
    56d0:	00003517          	auipc	a0,0x3
    56d4:	a9050513          	addi	a0,a0,-1392 # 8160 <malloc+0x2116>
    56d8:	00001097          	auipc	ra,0x1
    56dc:	8b2080e7          	jalr	-1870(ra) # 5f8a <printf>
        exit(1);
    56e0:	4505                	li	a0,1
    56e2:	00000097          	auipc	ra,0x0
    56e6:	530080e7          	jalr	1328(ra) # 5c12 <exit>
    printf("pipe() failed in countfree()\n");
    56ea:	00003517          	auipc	a0,0x3
    56ee:	a3650513          	addi	a0,a0,-1482 # 8120 <malloc+0x20d6>
    56f2:	00001097          	auipc	ra,0x1
    56f6:	898080e7          	jalr	-1896(ra) # 5f8a <printf>
    exit(1);
    56fa:	4505                	li	a0,1
    56fc:	00000097          	auipc	ra,0x0
    5700:	516080e7          	jalr	1302(ra) # 5c12 <exit>
    printf("fork failed in countfree()\n");
    5704:	00003517          	auipc	a0,0x3
    5708:	a3c50513          	addi	a0,a0,-1476 # 8140 <malloc+0x20f6>
    570c:	00001097          	auipc	ra,0x1
    5710:	87e080e7          	jalr	-1922(ra) # 5f8a <printf>
    exit(1);
    5714:	4505                	li	a0,1
    5716:	00000097          	auipc	ra,0x0
    571a:	4fc080e7          	jalr	1276(ra) # 5c12 <exit>
      }
    }

    exit(0);
    571e:	4501                	li	a0,0
    5720:	00000097          	auipc	ra,0x0
    5724:	4f2080e7          	jalr	1266(ra) # 5c12 <exit>
  }

  close(fds[1]);
    5728:	fcc42503          	lw	a0,-52(s0)
    572c:	00000097          	auipc	ra,0x0
    5730:	50e080e7          	jalr	1294(ra) # 5c3a <close>

  int n = 0;
    5734:	4481                	li	s1,0
    5736:	a839                	j	5754 <countfree+0xf4>
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    if(cc < 0){
      printf("read() failed in countfree()\n");
    5738:	00003517          	auipc	a0,0x3
    573c:	a4850513          	addi	a0,a0,-1464 # 8180 <malloc+0x2136>
    5740:	00001097          	auipc	ra,0x1
    5744:	84a080e7          	jalr	-1974(ra) # 5f8a <printf>
      exit(1);
    5748:	4505                	li	a0,1
    574a:	00000097          	auipc	ra,0x0
    574e:	4c8080e7          	jalr	1224(ra) # 5c12 <exit>
    }
    if(cc == 0)
      break;
    n += 1;
    5752:	2485                	addiw	s1,s1,1
    int cc = read(fds[0], &c, 1);
    5754:	4605                	li	a2,1
    5756:	fc740593          	addi	a1,s0,-57
    575a:	fc842503          	lw	a0,-56(s0)
    575e:	00000097          	auipc	ra,0x0
    5762:	4cc080e7          	jalr	1228(ra) # 5c2a <read>
    if(cc < 0){
    5766:	fc0549e3          	bltz	a0,5738 <countfree+0xd8>
    if(cc == 0)
    576a:	f565                	bnez	a0,5752 <countfree+0xf2>
  }

  close(fds[0]);
    576c:	fc842503          	lw	a0,-56(s0)
    5770:	00000097          	auipc	ra,0x0
    5774:	4ca080e7          	jalr	1226(ra) # 5c3a <close>
  wait((int*)0);
    5778:	4501                	li	a0,0
    577a:	00000097          	auipc	ra,0x0
    577e:	4a0080e7          	jalr	1184(ra) # 5c1a <wait>
  
  return n;
}
    5782:	8526                	mv	a0,s1
    5784:	70e2                	ld	ra,56(sp)
    5786:	7442                	ld	s0,48(sp)
    5788:	74a2                	ld	s1,40(sp)
    578a:	7902                	ld	s2,32(sp)
    578c:	69e2                	ld	s3,24(sp)
    578e:	6121                	addi	sp,sp,64
    5790:	8082                	ret

0000000000005792 <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    5792:	711d                	addi	sp,sp,-96
    5794:	ec86                	sd	ra,88(sp)
    5796:	e8a2                	sd	s0,80(sp)
    5798:	e4a6                	sd	s1,72(sp)
    579a:	e0ca                	sd	s2,64(sp)
    579c:	fc4e                	sd	s3,56(sp)
    579e:	f852                	sd	s4,48(sp)
    57a0:	f456                	sd	s5,40(sp)
    57a2:	f05a                	sd	s6,32(sp)
    57a4:	ec5e                	sd	s7,24(sp)
    57a6:	e862                	sd	s8,16(sp)
    57a8:	e466                	sd	s9,8(sp)
    57aa:	e06a                	sd	s10,0(sp)
    57ac:	1080                	addi	s0,sp,96
    57ae:	8baa                	mv	s7,a0
    57b0:	89ae                	mv	s3,a1
    57b2:	84b2                	mv	s1,a2
  do {
    printf("usertests starting\n");
    57b4:	00003b17          	auipc	s6,0x3
    57b8:	9ecb0b13          	addi	s6,s6,-1556 # 81a0 <malloc+0x2156>
    int free0 = countfree();
    int free1 = 0;
    if (runtests(quicktests, justone)) {
    57bc:	00004a97          	auipc	s5,0x4
    57c0:	854a8a93          	addi	s5,s5,-1964 # 9010 <quicktests>
      if(continuous != 2) {
    57c4:	4a09                	li	s4,2
          return 1;
        }
      }
    }
    if((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    57c6:	00003c97          	auipc	s9,0x3
    57ca:	a12c8c93          	addi	s9,s9,-1518 # 81d8 <malloc+0x218e>
      if (runtests(slowtests, justone)) {
    57ce:	00004c17          	auipc	s8,0x4
    57d2:	c12c0c13          	addi	s8,s8,-1006 # 93e0 <slowtests>
        printf("usertests slow tests starting\n");
    57d6:	00003d17          	auipc	s10,0x3
    57da:	9e2d0d13          	addi	s10,s10,-1566 # 81b8 <malloc+0x216e>
    57de:	a839                	j	57fc <drivetests+0x6a>
    57e0:	856a                	mv	a0,s10
    57e2:	00000097          	auipc	ra,0x0
    57e6:	7a8080e7          	jalr	1960(ra) # 5f8a <printf>
    57ea:	a83d                	j	5828 <drivetests+0x96>
    if((free1 = countfree()) < free0) {
    57ec:	00000097          	auipc	ra,0x0
    57f0:	e74080e7          	jalr	-396(ra) # 5660 <countfree>
    57f4:	07254163          	blt	a0,s2,5856 <drivetests+0xc4>
      if(continuous != 2) {
        return 1;
      }
    }
  } while(continuous);
    57f8:	06098e63          	beqz	s3,5874 <drivetests+0xe2>
    printf("usertests starting\n");
    57fc:	855a                	mv	a0,s6
    57fe:	00000097          	auipc	ra,0x0
    5802:	78c080e7          	jalr	1932(ra) # 5f8a <printf>
    int free0 = countfree();
    5806:	00000097          	auipc	ra,0x0
    580a:	e5a080e7          	jalr	-422(ra) # 5660 <countfree>
    580e:	892a                	mv	s2,a0
    if (runtests(quicktests, justone)) {
    5810:	85a6                	mv	a1,s1
    5812:	8556                	mv	a0,s5
    5814:	00000097          	auipc	ra,0x0
    5818:	df0080e7          	jalr	-528(ra) # 5604 <runtests>
    581c:	c119                	beqz	a0,5822 <drivetests+0x90>
      if(continuous != 2) {
    581e:	05499763          	bne	s3,s4,586c <drivetests+0xda>
    if(!quick) {
    5822:	fc0b95e3          	bnez	s7,57ec <drivetests+0x5a>
      if (justone == 0)
    5826:	dccd                	beqz	s1,57e0 <drivetests+0x4e>
      if (runtests(slowtests, justone)) {
    5828:	85a6                	mv	a1,s1
    582a:	8562                	mv	a0,s8
    582c:	00000097          	auipc	ra,0x0
    5830:	dd8080e7          	jalr	-552(ra) # 5604 <runtests>
    5834:	dd45                	beqz	a0,57ec <drivetests+0x5a>
        if(continuous != 2) {
    5836:	03499d63          	bne	s3,s4,5870 <drivetests+0xde>
    if((free1 = countfree()) < free0) {
    583a:	00000097          	auipc	ra,0x0
    583e:	e26080e7          	jalr	-474(ra) # 5660 <countfree>
    5842:	fb255be3          	bge	a0,s2,57f8 <drivetests+0x66>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    5846:	864a                	mv	a2,s2
    5848:	85aa                	mv	a1,a0
    584a:	8566                	mv	a0,s9
    584c:	00000097          	auipc	ra,0x0
    5850:	73e080e7          	jalr	1854(ra) # 5f8a <printf>
      if(continuous != 2) {
    5854:	b765                	j	57fc <drivetests+0x6a>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    5856:	864a                	mv	a2,s2
    5858:	85aa                	mv	a1,a0
    585a:	8566                	mv	a0,s9
    585c:	00000097          	auipc	ra,0x0
    5860:	72e080e7          	jalr	1838(ra) # 5f8a <printf>
      if(continuous != 2) {
    5864:	f9498ce3          	beq	s3,s4,57fc <drivetests+0x6a>
        return 1;
    5868:	4505                	li	a0,1
    586a:	a031                	j	5876 <drivetests+0xe4>
        return 1;
    586c:	4505                	li	a0,1
    586e:	a021                	j	5876 <drivetests+0xe4>
          return 1;
    5870:	4505                	li	a0,1
    5872:	a011                	j	5876 <drivetests+0xe4>
  return 0;
    5874:	854e                	mv	a0,s3
}
    5876:	60e6                	ld	ra,88(sp)
    5878:	6446                	ld	s0,80(sp)
    587a:	64a6                	ld	s1,72(sp)
    587c:	6906                	ld	s2,64(sp)
    587e:	79e2                	ld	s3,56(sp)
    5880:	7a42                	ld	s4,48(sp)
    5882:	7aa2                	ld	s5,40(sp)
    5884:	7b02                	ld	s6,32(sp)
    5886:	6be2                	ld	s7,24(sp)
    5888:	6c42                	ld	s8,16(sp)
    588a:	6ca2                	ld	s9,8(sp)
    588c:	6d02                	ld	s10,0(sp)
    588e:	6125                	addi	sp,sp,96
    5890:	8082                	ret

0000000000005892 <main>:

int
main(int argc, char *argv[])
{
    5892:	1101                	addi	sp,sp,-32
    5894:	ec06                	sd	ra,24(sp)
    5896:	e822                	sd	s0,16(sp)
    5898:	e426                	sd	s1,8(sp)
    589a:	e04a                	sd	s2,0(sp)
    589c:	1000                	addi	s0,sp,32
    589e:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    58a0:	4789                	li	a5,2
    58a2:	02f50363          	beq	a0,a5,58c8 <main+0x36>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    58a6:	4785                	li	a5,1
    58a8:	06a7cd63          	blt	a5,a0,5922 <main+0x90>
  char *justone = 0;
    58ac:	4601                	li	a2,0
  int quick = 0;
    58ae:	4501                	li	a0,0
  int continuous = 0;
    58b0:	4481                	li	s1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    58b2:	85a6                	mv	a1,s1
    58b4:	00000097          	auipc	ra,0x0
    58b8:	ede080e7          	jalr	-290(ra) # 5792 <drivetests>
    58bc:	c949                	beqz	a0,594e <main+0xbc>
    exit(1);
    58be:	4505                	li	a0,1
    58c0:	00000097          	auipc	ra,0x0
    58c4:	352080e7          	jalr	850(ra) # 5c12 <exit>
    58c8:	892e                	mv	s2,a1
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    58ca:	00003597          	auipc	a1,0x3
    58ce:	93e58593          	addi	a1,a1,-1730 # 8208 <malloc+0x21be>
    58d2:	00893503          	ld	a0,8(s2)
    58d6:	00000097          	auipc	ra,0x0
    58da:	0c8080e7          	jalr	200(ra) # 599e <strcmp>
    58de:	cd39                	beqz	a0,593c <main+0xaa>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    58e0:	00003597          	auipc	a1,0x3
    58e4:	98058593          	addi	a1,a1,-1664 # 8260 <malloc+0x2216>
    58e8:	00893503          	ld	a0,8(s2)
    58ec:	00000097          	auipc	ra,0x0
    58f0:	0b2080e7          	jalr	178(ra) # 599e <strcmp>
    58f4:	c931                	beqz	a0,5948 <main+0xb6>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    58f6:	00003597          	auipc	a1,0x3
    58fa:	96258593          	addi	a1,a1,-1694 # 8258 <malloc+0x220e>
    58fe:	00893503          	ld	a0,8(s2)
    5902:	00000097          	auipc	ra,0x0
    5906:	09c080e7          	jalr	156(ra) # 599e <strcmp>
    590a:	cd0d                	beqz	a0,5944 <main+0xb2>
  } else if(argc == 2 && argv[1][0] != '-'){
    590c:	00893603          	ld	a2,8(s2)
    5910:	00064703          	lbu	a4,0(a2) # 3000 <execout+0x72>
    5914:	02d00793          	li	a5,45
    5918:	00f70563          	beq	a4,a5,5922 <main+0x90>
  int quick = 0;
    591c:	4501                	li	a0,0
  int continuous = 0;
    591e:	4481                	li	s1,0
    5920:	bf49                	j	58b2 <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    5922:	00003517          	auipc	a0,0x3
    5926:	8ee50513          	addi	a0,a0,-1810 # 8210 <malloc+0x21c6>
    592a:	00000097          	auipc	ra,0x0
    592e:	660080e7          	jalr	1632(ra) # 5f8a <printf>
    exit(1);
    5932:	4505                	li	a0,1
    5934:	00000097          	auipc	ra,0x0
    5938:	2de080e7          	jalr	734(ra) # 5c12 <exit>
  int continuous = 0;
    593c:	84aa                	mv	s1,a0
  char *justone = 0;
    593e:	4601                	li	a2,0
    quick = 1;
    5940:	4505                	li	a0,1
    5942:	bf85                	j	58b2 <main+0x20>
  char *justone = 0;
    5944:	4601                	li	a2,0
    5946:	b7b5                	j	58b2 <main+0x20>
    5948:	4601                	li	a2,0
    continuous = 1;
    594a:	4485                	li	s1,1
    594c:	b79d                	j	58b2 <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    594e:	00003517          	auipc	a0,0x3
    5952:	8f250513          	addi	a0,a0,-1806 # 8240 <malloc+0x21f6>
    5956:	00000097          	auipc	ra,0x0
    595a:	634080e7          	jalr	1588(ra) # 5f8a <printf>
  exit(0);
    595e:	4501                	li	a0,0
    5960:	00000097          	auipc	ra,0x0
    5964:	2b2080e7          	jalr	690(ra) # 5c12 <exit>

0000000000005968 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
    5968:	1141                	addi	sp,sp,-16
    596a:	e406                	sd	ra,8(sp)
    596c:	e022                	sd	s0,0(sp)
    596e:	0800                	addi	s0,sp,16
  extern int main();
  main();
    5970:	00000097          	auipc	ra,0x0
    5974:	f22080e7          	jalr	-222(ra) # 5892 <main>
  exit(0);
    5978:	4501                	li	a0,0
    597a:	00000097          	auipc	ra,0x0
    597e:	298080e7          	jalr	664(ra) # 5c12 <exit>

0000000000005982 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    5982:	1141                	addi	sp,sp,-16
    5984:	e422                	sd	s0,8(sp)
    5986:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    5988:	87aa                	mv	a5,a0
    598a:	0585                	addi	a1,a1,1
    598c:	0785                	addi	a5,a5,1
    598e:	fff5c703          	lbu	a4,-1(a1)
    5992:	fee78fa3          	sb	a4,-1(a5)
    5996:	fb75                	bnez	a4,598a <strcpy+0x8>
    ;
  return os;
}
    5998:	6422                	ld	s0,8(sp)
    599a:	0141                	addi	sp,sp,16
    599c:	8082                	ret

000000000000599e <strcmp>:

int
strcmp(const char *p, const char *q)
{
    599e:	1141                	addi	sp,sp,-16
    59a0:	e422                	sd	s0,8(sp)
    59a2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    59a4:	00054783          	lbu	a5,0(a0)
    59a8:	cf91                	beqz	a5,59c4 <strcmp+0x26>
    59aa:	0005c703          	lbu	a4,0(a1)
    59ae:	00f71b63          	bne	a4,a5,59c4 <strcmp+0x26>
    p++, q++;
    59b2:	0505                	addi	a0,a0,1
    59b4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    59b6:	00054783          	lbu	a5,0(a0)
    59ba:	c789                	beqz	a5,59c4 <strcmp+0x26>
    59bc:	0005c703          	lbu	a4,0(a1)
    59c0:	fef709e3          	beq	a4,a5,59b2 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
    59c4:	0005c503          	lbu	a0,0(a1)
}
    59c8:	40a7853b          	subw	a0,a5,a0
    59cc:	6422                	ld	s0,8(sp)
    59ce:	0141                	addi	sp,sp,16
    59d0:	8082                	ret

00000000000059d2 <strlen>:

uint
strlen(const char *s)
{
    59d2:	1141                	addi	sp,sp,-16
    59d4:	e422                	sd	s0,8(sp)
    59d6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    59d8:	00054783          	lbu	a5,0(a0)
    59dc:	cf91                	beqz	a5,59f8 <strlen+0x26>
    59de:	0505                	addi	a0,a0,1
    59e0:	87aa                	mv	a5,a0
    59e2:	4685                	li	a3,1
    59e4:	9e89                	subw	a3,a3,a0
    59e6:	00f6853b          	addw	a0,a3,a5
    59ea:	0785                	addi	a5,a5,1
    59ec:	fff7c703          	lbu	a4,-1(a5)
    59f0:	fb7d                	bnez	a4,59e6 <strlen+0x14>
    ;
  return n;
}
    59f2:	6422                	ld	s0,8(sp)
    59f4:	0141                	addi	sp,sp,16
    59f6:	8082                	ret
  for(n = 0; s[n]; n++)
    59f8:	4501                	li	a0,0
    59fa:	bfe5                	j	59f2 <strlen+0x20>

00000000000059fc <memset>:

void*
memset(void *dst, int c, uint n)
{
    59fc:	1141                	addi	sp,sp,-16
    59fe:	e422                	sd	s0,8(sp)
    5a00:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    5a02:	ce09                	beqz	a2,5a1c <memset+0x20>
    5a04:	87aa                	mv	a5,a0
    5a06:	fff6071b          	addiw	a4,a2,-1
    5a0a:	1702                	slli	a4,a4,0x20
    5a0c:	9301                	srli	a4,a4,0x20
    5a0e:	0705                	addi	a4,a4,1
    5a10:	972a                	add	a4,a4,a0
    cdst[i] = c;
    5a12:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    5a16:	0785                	addi	a5,a5,1
    5a18:	fee79de3          	bne	a5,a4,5a12 <memset+0x16>
  }
  return dst;
}
    5a1c:	6422                	ld	s0,8(sp)
    5a1e:	0141                	addi	sp,sp,16
    5a20:	8082                	ret

0000000000005a22 <strchr>:

char*
strchr(const char *s, char c)
{
    5a22:	1141                	addi	sp,sp,-16
    5a24:	e422                	sd	s0,8(sp)
    5a26:	0800                	addi	s0,sp,16
  for(; *s; s++)
    5a28:	00054783          	lbu	a5,0(a0)
    5a2c:	cf91                	beqz	a5,5a48 <strchr+0x26>
    if(*s == c)
    5a2e:	00f58a63          	beq	a1,a5,5a42 <strchr+0x20>
  for(; *s; s++)
    5a32:	0505                	addi	a0,a0,1
    5a34:	00054783          	lbu	a5,0(a0)
    5a38:	c781                	beqz	a5,5a40 <strchr+0x1e>
    if(*s == c)
    5a3a:	feb79ce3          	bne	a5,a1,5a32 <strchr+0x10>
    5a3e:	a011                	j	5a42 <strchr+0x20>
      return (char*)s;
  return 0;
    5a40:	4501                	li	a0,0
}
    5a42:	6422                	ld	s0,8(sp)
    5a44:	0141                	addi	sp,sp,16
    5a46:	8082                	ret
  return 0;
    5a48:	4501                	li	a0,0
    5a4a:	bfe5                	j	5a42 <strchr+0x20>

0000000000005a4c <gets>:

char*
gets(char *buf, int max)
{
    5a4c:	711d                	addi	sp,sp,-96
    5a4e:	ec86                	sd	ra,88(sp)
    5a50:	e8a2                	sd	s0,80(sp)
    5a52:	e4a6                	sd	s1,72(sp)
    5a54:	e0ca                	sd	s2,64(sp)
    5a56:	fc4e                	sd	s3,56(sp)
    5a58:	f852                	sd	s4,48(sp)
    5a5a:	f456                	sd	s5,40(sp)
    5a5c:	f05a                	sd	s6,32(sp)
    5a5e:	ec5e                	sd	s7,24(sp)
    5a60:	1080                	addi	s0,sp,96
    5a62:	8baa                	mv	s7,a0
    5a64:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    5a66:	892a                	mv	s2,a0
    5a68:	4981                	li	s3,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    5a6a:	4aa9                	li	s5,10
    5a6c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    5a6e:	0019849b          	addiw	s1,s3,1
    5a72:	0344d863          	bge	s1,s4,5aa2 <gets+0x56>
    cc = read(0, &c, 1);
    5a76:	4605                	li	a2,1
    5a78:	faf40593          	addi	a1,s0,-81
    5a7c:	4501                	li	a0,0
    5a7e:	00000097          	auipc	ra,0x0
    5a82:	1ac080e7          	jalr	428(ra) # 5c2a <read>
    if(cc < 1)
    5a86:	00a05e63          	blez	a0,5aa2 <gets+0x56>
    buf[i++] = c;
    5a8a:	faf44783          	lbu	a5,-81(s0)
    5a8e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    5a92:	01578763          	beq	a5,s5,5aa0 <gets+0x54>
    5a96:	0905                	addi	s2,s2,1
  for(i=0; i+1 < max; ){
    5a98:	89a6                	mv	s3,s1
    if(c == '\n' || c == '\r')
    5a9a:	fd679ae3          	bne	a5,s6,5a6e <gets+0x22>
    5a9e:	a011                	j	5aa2 <gets+0x56>
  for(i=0; i+1 < max; ){
    5aa0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    5aa2:	99de                	add	s3,s3,s7
    5aa4:	00098023          	sb	zero,0(s3)
  return buf;
}
    5aa8:	855e                	mv	a0,s7
    5aaa:	60e6                	ld	ra,88(sp)
    5aac:	6446                	ld	s0,80(sp)
    5aae:	64a6                	ld	s1,72(sp)
    5ab0:	6906                	ld	s2,64(sp)
    5ab2:	79e2                	ld	s3,56(sp)
    5ab4:	7a42                	ld	s4,48(sp)
    5ab6:	7aa2                	ld	s5,40(sp)
    5ab8:	7b02                	ld	s6,32(sp)
    5aba:	6be2                	ld	s7,24(sp)
    5abc:	6125                	addi	sp,sp,96
    5abe:	8082                	ret

0000000000005ac0 <stat>:

int
stat(const char *n, struct stat *st)
{
    5ac0:	1101                	addi	sp,sp,-32
    5ac2:	ec06                	sd	ra,24(sp)
    5ac4:	e822                	sd	s0,16(sp)
    5ac6:	e426                	sd	s1,8(sp)
    5ac8:	e04a                	sd	s2,0(sp)
    5aca:	1000                	addi	s0,sp,32
    5acc:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    5ace:	4581                	li	a1,0
    5ad0:	00000097          	auipc	ra,0x0
    5ad4:	182080e7          	jalr	386(ra) # 5c52 <open>
  if(fd < 0)
    5ad8:	02054563          	bltz	a0,5b02 <stat+0x42>
    5adc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    5ade:	85ca                	mv	a1,s2
    5ae0:	00000097          	auipc	ra,0x0
    5ae4:	18a080e7          	jalr	394(ra) # 5c6a <fstat>
    5ae8:	892a                	mv	s2,a0
  close(fd);
    5aea:	8526                	mv	a0,s1
    5aec:	00000097          	auipc	ra,0x0
    5af0:	14e080e7          	jalr	334(ra) # 5c3a <close>
  return r;
}
    5af4:	854a                	mv	a0,s2
    5af6:	60e2                	ld	ra,24(sp)
    5af8:	6442                	ld	s0,16(sp)
    5afa:	64a2                	ld	s1,8(sp)
    5afc:	6902                	ld	s2,0(sp)
    5afe:	6105                	addi	sp,sp,32
    5b00:	8082                	ret
    return -1;
    5b02:	597d                	li	s2,-1
    5b04:	bfc5                	j	5af4 <stat+0x34>

0000000000005b06 <atoi>:

int
atoi(const char *s)
{
    5b06:	1141                	addi	sp,sp,-16
    5b08:	e422                	sd	s0,8(sp)
    5b0a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    5b0c:	00054683          	lbu	a3,0(a0)
    5b10:	fd06879b          	addiw	a5,a3,-48
    5b14:	0ff7f793          	andi	a5,a5,255
    5b18:	4725                	li	a4,9
    5b1a:	02f76963          	bltu	a4,a5,5b4c <atoi+0x46>
    5b1e:	862a                	mv	a2,a0
  n = 0;
    5b20:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    5b22:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    5b24:	0605                	addi	a2,a2,1
    5b26:	0025179b          	slliw	a5,a0,0x2
    5b2a:	9fa9                	addw	a5,a5,a0
    5b2c:	0017979b          	slliw	a5,a5,0x1
    5b30:	9fb5                	addw	a5,a5,a3
    5b32:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    5b36:	00064683          	lbu	a3,0(a2)
    5b3a:	fd06871b          	addiw	a4,a3,-48
    5b3e:	0ff77713          	andi	a4,a4,255
    5b42:	fee5f1e3          	bgeu	a1,a4,5b24 <atoi+0x1e>
  return n;
}
    5b46:	6422                	ld	s0,8(sp)
    5b48:	0141                	addi	sp,sp,16
    5b4a:	8082                	ret
  n = 0;
    5b4c:	4501                	li	a0,0
    5b4e:	bfe5                	j	5b46 <atoi+0x40>

0000000000005b50 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    5b50:	1141                	addi	sp,sp,-16
    5b52:	e422                	sd	s0,8(sp)
    5b54:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5b56:	02b57663          	bgeu	a0,a1,5b82 <memmove+0x32>
    while(n-- > 0)
    5b5a:	02c05163          	blez	a2,5b7c <memmove+0x2c>
    5b5e:	fff6079b          	addiw	a5,a2,-1
    5b62:	1782                	slli	a5,a5,0x20
    5b64:	9381                	srli	a5,a5,0x20
    5b66:	0785                	addi	a5,a5,1
    5b68:	97aa                	add	a5,a5,a0
  dst = vdst;
    5b6a:	872a                	mv	a4,a0
      *dst++ = *src++;
    5b6c:	0585                	addi	a1,a1,1
    5b6e:	0705                	addi	a4,a4,1
    5b70:	fff5c683          	lbu	a3,-1(a1)
    5b74:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    5b78:	fee79ae3          	bne	a5,a4,5b6c <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    5b7c:	6422                	ld	s0,8(sp)
    5b7e:	0141                	addi	sp,sp,16
    5b80:	8082                	ret
    dst += n;
    5b82:	00c50733          	add	a4,a0,a2
    src += n;
    5b86:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    5b88:	fec05ae3          	blez	a2,5b7c <memmove+0x2c>
    5b8c:	fff6079b          	addiw	a5,a2,-1
    5b90:	1782                	slli	a5,a5,0x20
    5b92:	9381                	srli	a5,a5,0x20
    5b94:	fff7c793          	not	a5,a5
    5b98:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    5b9a:	15fd                	addi	a1,a1,-1
    5b9c:	177d                	addi	a4,a4,-1
    5b9e:	0005c683          	lbu	a3,0(a1)
    5ba2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    5ba6:	fef71ae3          	bne	a4,a5,5b9a <memmove+0x4a>
    5baa:	bfc9                	j	5b7c <memmove+0x2c>

0000000000005bac <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    5bac:	1141                	addi	sp,sp,-16
    5bae:	e422                	sd	s0,8(sp)
    5bb0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5bb2:	ce15                	beqz	a2,5bee <memcmp+0x42>
    5bb4:	fff6069b          	addiw	a3,a2,-1
    if (*p1 != *p2) {
    5bb8:	00054783          	lbu	a5,0(a0)
    5bbc:	0005c703          	lbu	a4,0(a1)
    5bc0:	02e79063          	bne	a5,a4,5be0 <memcmp+0x34>
    5bc4:	1682                	slli	a3,a3,0x20
    5bc6:	9281                	srli	a3,a3,0x20
    5bc8:	0685                	addi	a3,a3,1
    5bca:	96aa                	add	a3,a3,a0
      return *p1 - *p2;
    }
    p1++;
    5bcc:	0505                	addi	a0,a0,1
    p2++;
    5bce:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    5bd0:	00d50d63          	beq	a0,a3,5bea <memcmp+0x3e>
    if (*p1 != *p2) {
    5bd4:	00054783          	lbu	a5,0(a0)
    5bd8:	0005c703          	lbu	a4,0(a1)
    5bdc:	fee788e3          	beq	a5,a4,5bcc <memcmp+0x20>
      return *p1 - *p2;
    5be0:	40e7853b          	subw	a0,a5,a4
  }
  return 0;
}
    5be4:	6422                	ld	s0,8(sp)
    5be6:	0141                	addi	sp,sp,16
    5be8:	8082                	ret
  return 0;
    5bea:	4501                	li	a0,0
    5bec:	bfe5                	j	5be4 <memcmp+0x38>
    5bee:	4501                	li	a0,0
    5bf0:	bfd5                	j	5be4 <memcmp+0x38>

0000000000005bf2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    5bf2:	1141                	addi	sp,sp,-16
    5bf4:	e406                	sd	ra,8(sp)
    5bf6:	e022                	sd	s0,0(sp)
    5bf8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    5bfa:	00000097          	auipc	ra,0x0
    5bfe:	f56080e7          	jalr	-170(ra) # 5b50 <memmove>
}
    5c02:	60a2                	ld	ra,8(sp)
    5c04:	6402                	ld	s0,0(sp)
    5c06:	0141                	addi	sp,sp,16
    5c08:	8082                	ret

0000000000005c0a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    5c0a:	4885                	li	a7,1
 ecall
    5c0c:	00000073          	ecall
 ret
    5c10:	8082                	ret

0000000000005c12 <exit>:
.global exit
exit:
 li a7, SYS_exit
    5c12:	4889                	li	a7,2
 ecall
    5c14:	00000073          	ecall
 ret
    5c18:	8082                	ret

0000000000005c1a <wait>:
.global wait
wait:
 li a7, SYS_wait
    5c1a:	488d                	li	a7,3
 ecall
    5c1c:	00000073          	ecall
 ret
    5c20:	8082                	ret

0000000000005c22 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5c22:	4891                	li	a7,4
 ecall
    5c24:	00000073          	ecall
 ret
    5c28:	8082                	ret

0000000000005c2a <read>:
.global read
read:
 li a7, SYS_read
    5c2a:	4895                	li	a7,5
 ecall
    5c2c:	00000073          	ecall
 ret
    5c30:	8082                	ret

0000000000005c32 <write>:
.global write
write:
 li a7, SYS_write
    5c32:	48c1                	li	a7,16
 ecall
    5c34:	00000073          	ecall
 ret
    5c38:	8082                	ret

0000000000005c3a <close>:
.global close
close:
 li a7, SYS_close
    5c3a:	48d5                	li	a7,21
 ecall
    5c3c:	00000073          	ecall
 ret
    5c40:	8082                	ret

0000000000005c42 <kill>:
.global kill
kill:
 li a7, SYS_kill
    5c42:	4899                	li	a7,6
 ecall
    5c44:	00000073          	ecall
 ret
    5c48:	8082                	ret

0000000000005c4a <exec>:
.global exec
exec:
 li a7, SYS_exec
    5c4a:	489d                	li	a7,7
 ecall
    5c4c:	00000073          	ecall
 ret
    5c50:	8082                	ret

0000000000005c52 <open>:
.global open
open:
 li a7, SYS_open
    5c52:	48bd                	li	a7,15
 ecall
    5c54:	00000073          	ecall
 ret
    5c58:	8082                	ret

0000000000005c5a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    5c5a:	48c5                	li	a7,17
 ecall
    5c5c:	00000073          	ecall
 ret
    5c60:	8082                	ret

0000000000005c62 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    5c62:	48c9                	li	a7,18
 ecall
    5c64:	00000073          	ecall
 ret
    5c68:	8082                	ret

0000000000005c6a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    5c6a:	48a1                	li	a7,8
 ecall
    5c6c:	00000073          	ecall
 ret
    5c70:	8082                	ret

0000000000005c72 <link>:
.global link
link:
 li a7, SYS_link
    5c72:	48cd                	li	a7,19
 ecall
    5c74:	00000073          	ecall
 ret
    5c78:	8082                	ret

0000000000005c7a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    5c7a:	48d1                	li	a7,20
 ecall
    5c7c:	00000073          	ecall
 ret
    5c80:	8082                	ret

0000000000005c82 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5c82:	48a5                	li	a7,9
 ecall
    5c84:	00000073          	ecall
 ret
    5c88:	8082                	ret

0000000000005c8a <dup>:
.global dup
dup:
 li a7, SYS_dup
    5c8a:	48a9                	li	a7,10
 ecall
    5c8c:	00000073          	ecall
 ret
    5c90:	8082                	ret

0000000000005c92 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5c92:	48ad                	li	a7,11
 ecall
    5c94:	00000073          	ecall
 ret
    5c98:	8082                	ret

0000000000005c9a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    5c9a:	48b1                	li	a7,12
 ecall
    5c9c:	00000073          	ecall
 ret
    5ca0:	8082                	ret

0000000000005ca2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    5ca2:	48b5                	li	a7,13
 ecall
    5ca4:	00000073          	ecall
 ret
    5ca8:	8082                	ret

0000000000005caa <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    5caa:	48b9                	li	a7,14
 ecall
    5cac:	00000073          	ecall
 ret
    5cb0:	8082                	ret

0000000000005cb2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    5cb2:	1101                	addi	sp,sp,-32
    5cb4:	ec06                	sd	ra,24(sp)
    5cb6:	e822                	sd	s0,16(sp)
    5cb8:	1000                	addi	s0,sp,32
    5cba:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5cbe:	4605                	li	a2,1
    5cc0:	fef40593          	addi	a1,s0,-17
    5cc4:	00000097          	auipc	ra,0x0
    5cc8:	f6e080e7          	jalr	-146(ra) # 5c32 <write>
}
    5ccc:	60e2                	ld	ra,24(sp)
    5cce:	6442                	ld	s0,16(sp)
    5cd0:	6105                	addi	sp,sp,32
    5cd2:	8082                	ret

0000000000005cd4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    5cd4:	7139                	addi	sp,sp,-64
    5cd6:	fc06                	sd	ra,56(sp)
    5cd8:	f822                	sd	s0,48(sp)
    5cda:	f426                	sd	s1,40(sp)
    5cdc:	f04a                	sd	s2,32(sp)
    5cde:	ec4e                	sd	s3,24(sp)
    5ce0:	0080                	addi	s0,sp,64
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    5ce2:	c299                	beqz	a3,5ce8 <printint+0x14>
    5ce4:	0005cd63          	bltz	a1,5cfe <printint+0x2a>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    5ce8:	2581                	sext.w	a1,a1
  neg = 0;
    5cea:	4301                	li	t1,0
    5cec:	fc040713          	addi	a4,s0,-64
  }

  i = 0;
    5cf0:	4801                	li	a6,0
  do{
    buf[i++] = digits[x % base];
    5cf2:	2601                	sext.w	a2,a2
    5cf4:	00003897          	auipc	a7,0x3
    5cf8:	8b488893          	addi	a7,a7,-1868 # 85a8 <digits>
    5cfc:	a801                	j	5d0c <printint+0x38>
    x = -xx;
    5cfe:	40b005bb          	negw	a1,a1
    5d02:	2581                	sext.w	a1,a1
    neg = 1;
    5d04:	4305                	li	t1,1
    x = -xx;
    5d06:	b7dd                	j	5cec <printint+0x18>
  }while((x /= base) != 0);
    5d08:	85be                	mv	a1,a5
    buf[i++] = digits[x % base];
    5d0a:	8836                	mv	a6,a3
    5d0c:	0018069b          	addiw	a3,a6,1
    5d10:	02c5f7bb          	remuw	a5,a1,a2
    5d14:	1782                	slli	a5,a5,0x20
    5d16:	9381                	srli	a5,a5,0x20
    5d18:	97c6                	add	a5,a5,a7
    5d1a:	0007c783          	lbu	a5,0(a5)
    5d1e:	00f70023          	sb	a5,0(a4)
  }while((x /= base) != 0);
    5d22:	0705                	addi	a4,a4,1
    5d24:	02c5d7bb          	divuw	a5,a1,a2
    5d28:	fec5f0e3          	bgeu	a1,a2,5d08 <printint+0x34>
  if(neg)
    5d2c:	00030b63          	beqz	t1,5d42 <printint+0x6e>
    buf[i++] = '-';
    5d30:	fd040793          	addi	a5,s0,-48
    5d34:	96be                	add	a3,a3,a5
    5d36:	02d00793          	li	a5,45
    5d3a:	fef68823          	sb	a5,-16(a3) # ff0 <linktest+0xe8>
    5d3e:	0028069b          	addiw	a3,a6,2

  while(--i >= 0)
    5d42:	02d05963          	blez	a3,5d74 <printint+0xa0>
    5d46:	89aa                	mv	s3,a0
    5d48:	fc040793          	addi	a5,s0,-64
    5d4c:	00d784b3          	add	s1,a5,a3
    5d50:	fff78913          	addi	s2,a5,-1
    5d54:	9936                	add	s2,s2,a3
    5d56:	36fd                	addiw	a3,a3,-1
    5d58:	1682                	slli	a3,a3,0x20
    5d5a:	9281                	srli	a3,a3,0x20
    5d5c:	40d90933          	sub	s2,s2,a3
    putc(fd, buf[i]);
    5d60:	fff4c583          	lbu	a1,-1(s1)
    5d64:	854e                	mv	a0,s3
    5d66:	00000097          	auipc	ra,0x0
    5d6a:	f4c080e7          	jalr	-180(ra) # 5cb2 <putc>
  while(--i >= 0)
    5d6e:	14fd                	addi	s1,s1,-1
    5d70:	ff2498e3          	bne	s1,s2,5d60 <printint+0x8c>
}
    5d74:	70e2                	ld	ra,56(sp)
    5d76:	7442                	ld	s0,48(sp)
    5d78:	74a2                	ld	s1,40(sp)
    5d7a:	7902                	ld	s2,32(sp)
    5d7c:	69e2                	ld	s3,24(sp)
    5d7e:	6121                	addi	sp,sp,64
    5d80:	8082                	ret

0000000000005d82 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5d82:	7119                	addi	sp,sp,-128
    5d84:	fc86                	sd	ra,120(sp)
    5d86:	f8a2                	sd	s0,112(sp)
    5d88:	f4a6                	sd	s1,104(sp)
    5d8a:	f0ca                	sd	s2,96(sp)
    5d8c:	ecce                	sd	s3,88(sp)
    5d8e:	e8d2                	sd	s4,80(sp)
    5d90:	e4d6                	sd	s5,72(sp)
    5d92:	e0da                	sd	s6,64(sp)
    5d94:	fc5e                	sd	s7,56(sp)
    5d96:	f862                	sd	s8,48(sp)
    5d98:	f466                	sd	s9,40(sp)
    5d9a:	f06a                	sd	s10,32(sp)
    5d9c:	ec6e                	sd	s11,24(sp)
    5d9e:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    5da0:	0005c483          	lbu	s1,0(a1)
    5da4:	18048d63          	beqz	s1,5f3e <vprintf+0x1bc>
    5da8:	8aaa                	mv	s5,a0
    5daa:	8b32                	mv	s6,a2
    5dac:	00158913          	addi	s2,a1,1
  state = 0;
    5db0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    5db2:	02500a13          	li	s4,37
      if(c == 'd'){
    5db6:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    5dba:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    5dbe:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    5dc2:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5dc6:	00002b97          	auipc	s7,0x2
    5dca:	7e2b8b93          	addi	s7,s7,2018 # 85a8 <digits>
    5dce:	a839                	j	5dec <vprintf+0x6a>
        putc(fd, c);
    5dd0:	85a6                	mv	a1,s1
    5dd2:	8556                	mv	a0,s5
    5dd4:	00000097          	auipc	ra,0x0
    5dd8:	ede080e7          	jalr	-290(ra) # 5cb2 <putc>
    5ddc:	a019                	j	5de2 <vprintf+0x60>
    } else if(state == '%'){
    5dde:	01498f63          	beq	s3,s4,5dfc <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    5de2:	0905                	addi	s2,s2,1
    5de4:	fff94483          	lbu	s1,-1(s2)
    5de8:	14048b63          	beqz	s1,5f3e <vprintf+0x1bc>
    c = fmt[i] & 0xff;
    5dec:	0004879b          	sext.w	a5,s1
    if(state == 0){
    5df0:	fe0997e3          	bnez	s3,5dde <vprintf+0x5c>
      if(c == '%'){
    5df4:	fd479ee3          	bne	a5,s4,5dd0 <vprintf+0x4e>
        state = '%';
    5df8:	89be                	mv	s3,a5
    5dfa:	b7e5                	j	5de2 <vprintf+0x60>
      if(c == 'd'){
    5dfc:	05878063          	beq	a5,s8,5e3c <vprintf+0xba>
      } else if(c == 'l') {
    5e00:	05978c63          	beq	a5,s9,5e58 <vprintf+0xd6>
      } else if(c == 'x') {
    5e04:	07a78863          	beq	a5,s10,5e74 <vprintf+0xf2>
      } else if(c == 'p') {
    5e08:	09b78463          	beq	a5,s11,5e90 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    5e0c:	07300713          	li	a4,115
    5e10:	0ce78563          	beq	a5,a4,5eda <vprintf+0x158>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    5e14:	06300713          	li	a4,99
    5e18:	0ee78c63          	beq	a5,a4,5f10 <vprintf+0x18e>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    5e1c:	11478663          	beq	a5,s4,5f28 <vprintf+0x1a6>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    5e20:	85d2                	mv	a1,s4
    5e22:	8556                	mv	a0,s5
    5e24:	00000097          	auipc	ra,0x0
    5e28:	e8e080e7          	jalr	-370(ra) # 5cb2 <putc>
        putc(fd, c);
    5e2c:	85a6                	mv	a1,s1
    5e2e:	8556                	mv	a0,s5
    5e30:	00000097          	auipc	ra,0x0
    5e34:	e82080e7          	jalr	-382(ra) # 5cb2 <putc>
      }
      state = 0;
    5e38:	4981                	li	s3,0
    5e3a:	b765                	j	5de2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    5e3c:	008b0493          	addi	s1,s6,8
    5e40:	4685                	li	a3,1
    5e42:	4629                	li	a2,10
    5e44:	000b2583          	lw	a1,0(s6)
    5e48:	8556                	mv	a0,s5
    5e4a:	00000097          	auipc	ra,0x0
    5e4e:	e8a080e7          	jalr	-374(ra) # 5cd4 <printint>
    5e52:	8b26                	mv	s6,s1
      state = 0;
    5e54:	4981                	li	s3,0
    5e56:	b771                	j	5de2 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5e58:	008b0493          	addi	s1,s6,8
    5e5c:	4681                	li	a3,0
    5e5e:	4629                	li	a2,10
    5e60:	000b2583          	lw	a1,0(s6)
    5e64:	8556                	mv	a0,s5
    5e66:	00000097          	auipc	ra,0x0
    5e6a:	e6e080e7          	jalr	-402(ra) # 5cd4 <printint>
    5e6e:	8b26                	mv	s6,s1
      state = 0;
    5e70:	4981                	li	s3,0
    5e72:	bf85                	j	5de2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    5e74:	008b0493          	addi	s1,s6,8
    5e78:	4681                	li	a3,0
    5e7a:	4641                	li	a2,16
    5e7c:	000b2583          	lw	a1,0(s6)
    5e80:	8556                	mv	a0,s5
    5e82:	00000097          	auipc	ra,0x0
    5e86:	e52080e7          	jalr	-430(ra) # 5cd4 <printint>
    5e8a:	8b26                	mv	s6,s1
      state = 0;
    5e8c:	4981                	li	s3,0
    5e8e:	bf91                	j	5de2 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    5e90:	008b0793          	addi	a5,s6,8
    5e94:	f8f43423          	sd	a5,-120(s0)
    5e98:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    5e9c:	03000593          	li	a1,48
    5ea0:	8556                	mv	a0,s5
    5ea2:	00000097          	auipc	ra,0x0
    5ea6:	e10080e7          	jalr	-496(ra) # 5cb2 <putc>
  putc(fd, 'x');
    5eaa:	85ea                	mv	a1,s10
    5eac:	8556                	mv	a0,s5
    5eae:	00000097          	auipc	ra,0x0
    5eb2:	e04080e7          	jalr	-508(ra) # 5cb2 <putc>
    5eb6:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5eb8:	03c9d793          	srli	a5,s3,0x3c
    5ebc:	97de                	add	a5,a5,s7
    5ebe:	0007c583          	lbu	a1,0(a5)
    5ec2:	8556                	mv	a0,s5
    5ec4:	00000097          	auipc	ra,0x0
    5ec8:	dee080e7          	jalr	-530(ra) # 5cb2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5ecc:	0992                	slli	s3,s3,0x4
    5ece:	34fd                	addiw	s1,s1,-1
    5ed0:	f4e5                	bnez	s1,5eb8 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    5ed2:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    5ed6:	4981                	li	s3,0
    5ed8:	b729                	j	5de2 <vprintf+0x60>
        s = va_arg(ap, char*);
    5eda:	008b0993          	addi	s3,s6,8
    5ede:	000b3483          	ld	s1,0(s6)
        if(s == 0)
    5ee2:	c085                	beqz	s1,5f02 <vprintf+0x180>
        while(*s != 0){
    5ee4:	0004c583          	lbu	a1,0(s1)
    5ee8:	c9a1                	beqz	a1,5f38 <vprintf+0x1b6>
          putc(fd, *s);
    5eea:	8556                	mv	a0,s5
    5eec:	00000097          	auipc	ra,0x0
    5ef0:	dc6080e7          	jalr	-570(ra) # 5cb2 <putc>
          s++;
    5ef4:	0485                	addi	s1,s1,1
        while(*s != 0){
    5ef6:	0004c583          	lbu	a1,0(s1)
    5efa:	f9e5                	bnez	a1,5eea <vprintf+0x168>
        s = va_arg(ap, char*);
    5efc:	8b4e                	mv	s6,s3
      state = 0;
    5efe:	4981                	li	s3,0
    5f00:	b5cd                	j	5de2 <vprintf+0x60>
          s = "(null)";
    5f02:	00002497          	auipc	s1,0x2
    5f06:	6be48493          	addi	s1,s1,1726 # 85c0 <digits+0x18>
        while(*s != 0){
    5f0a:	02800593          	li	a1,40
    5f0e:	bff1                	j	5eea <vprintf+0x168>
        putc(fd, va_arg(ap, uint));
    5f10:	008b0493          	addi	s1,s6,8
    5f14:	000b4583          	lbu	a1,0(s6)
    5f18:	8556                	mv	a0,s5
    5f1a:	00000097          	auipc	ra,0x0
    5f1e:	d98080e7          	jalr	-616(ra) # 5cb2 <putc>
    5f22:	8b26                	mv	s6,s1
      state = 0;
    5f24:	4981                	li	s3,0
    5f26:	bd75                	j	5de2 <vprintf+0x60>
        putc(fd, c);
    5f28:	85d2                	mv	a1,s4
    5f2a:	8556                	mv	a0,s5
    5f2c:	00000097          	auipc	ra,0x0
    5f30:	d86080e7          	jalr	-634(ra) # 5cb2 <putc>
      state = 0;
    5f34:	4981                	li	s3,0
    5f36:	b575                	j	5de2 <vprintf+0x60>
        s = va_arg(ap, char*);
    5f38:	8b4e                	mv	s6,s3
      state = 0;
    5f3a:	4981                	li	s3,0
    5f3c:	b55d                	j	5de2 <vprintf+0x60>
    }
  }
}
    5f3e:	70e6                	ld	ra,120(sp)
    5f40:	7446                	ld	s0,112(sp)
    5f42:	74a6                	ld	s1,104(sp)
    5f44:	7906                	ld	s2,96(sp)
    5f46:	69e6                	ld	s3,88(sp)
    5f48:	6a46                	ld	s4,80(sp)
    5f4a:	6aa6                	ld	s5,72(sp)
    5f4c:	6b06                	ld	s6,64(sp)
    5f4e:	7be2                	ld	s7,56(sp)
    5f50:	7c42                	ld	s8,48(sp)
    5f52:	7ca2                	ld	s9,40(sp)
    5f54:	7d02                	ld	s10,32(sp)
    5f56:	6de2                	ld	s11,24(sp)
    5f58:	6109                	addi	sp,sp,128
    5f5a:	8082                	ret

0000000000005f5c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5f5c:	715d                	addi	sp,sp,-80
    5f5e:	ec06                	sd	ra,24(sp)
    5f60:	e822                	sd	s0,16(sp)
    5f62:	1000                	addi	s0,sp,32
    5f64:	e010                	sd	a2,0(s0)
    5f66:	e414                	sd	a3,8(s0)
    5f68:	e818                	sd	a4,16(s0)
    5f6a:	ec1c                	sd	a5,24(s0)
    5f6c:	03043023          	sd	a6,32(s0)
    5f70:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5f74:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5f78:	8622                	mv	a2,s0
    5f7a:	00000097          	auipc	ra,0x0
    5f7e:	e08080e7          	jalr	-504(ra) # 5d82 <vprintf>
}
    5f82:	60e2                	ld	ra,24(sp)
    5f84:	6442                	ld	s0,16(sp)
    5f86:	6161                	addi	sp,sp,80
    5f88:	8082                	ret

0000000000005f8a <printf>:

void
printf(const char *fmt, ...)
{
    5f8a:	711d                	addi	sp,sp,-96
    5f8c:	ec06                	sd	ra,24(sp)
    5f8e:	e822                	sd	s0,16(sp)
    5f90:	1000                	addi	s0,sp,32
    5f92:	e40c                	sd	a1,8(s0)
    5f94:	e810                	sd	a2,16(s0)
    5f96:	ec14                	sd	a3,24(s0)
    5f98:	f018                	sd	a4,32(s0)
    5f9a:	f41c                	sd	a5,40(s0)
    5f9c:	03043823          	sd	a6,48(s0)
    5fa0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5fa4:	00840613          	addi	a2,s0,8
    5fa8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5fac:	85aa                	mv	a1,a0
    5fae:	4505                	li	a0,1
    5fb0:	00000097          	auipc	ra,0x0
    5fb4:	dd2080e7          	jalr	-558(ra) # 5d82 <vprintf>
}
    5fb8:	60e2                	ld	ra,24(sp)
    5fba:	6442                	ld	s0,16(sp)
    5fbc:	6125                	addi	sp,sp,96
    5fbe:	8082                	ret

0000000000005fc0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5fc0:	1141                	addi	sp,sp,-16
    5fc2:	e422                	sd	s0,8(sp)
    5fc4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5fc6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5fca:	00003797          	auipc	a5,0x3
    5fce:	48678793          	addi	a5,a5,1158 # 9450 <freep>
    5fd2:	639c                	ld	a5,0(a5)
    5fd4:	a805                	j	6004 <free+0x44>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    5fd6:	4618                	lw	a4,8(a2)
    5fd8:	9db9                	addw	a1,a1,a4
    5fda:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5fde:	6398                	ld	a4,0(a5)
    5fe0:	6318                	ld	a4,0(a4)
    5fe2:	fee53823          	sd	a4,-16(a0)
    5fe6:	a091                	j	602a <free+0x6a>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    5fe8:	ff852703          	lw	a4,-8(a0)
    5fec:	9e39                	addw	a2,a2,a4
    5fee:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    5ff0:	ff053703          	ld	a4,-16(a0)
    5ff4:	e398                	sd	a4,0(a5)
    5ff6:	a099                	j	603c <free+0x7c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5ff8:	6398                	ld	a4,0(a5)
    5ffa:	00e7e463          	bltu	a5,a4,6002 <free+0x42>
    5ffe:	00e6ea63          	bltu	a3,a4,6012 <free+0x52>
{
    6002:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    6004:	fed7fae3          	bgeu	a5,a3,5ff8 <free+0x38>
    6008:	6398                	ld	a4,0(a5)
    600a:	00e6e463          	bltu	a3,a4,6012 <free+0x52>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    600e:	fee7eae3          	bltu	a5,a4,6002 <free+0x42>
  if(bp + bp->s.size == p->s.ptr){
    6012:	ff852583          	lw	a1,-8(a0)
    6016:	6390                	ld	a2,0(a5)
    6018:	02059713          	slli	a4,a1,0x20
    601c:	9301                	srli	a4,a4,0x20
    601e:	0712                	slli	a4,a4,0x4
    6020:	9736                	add	a4,a4,a3
    6022:	fae60ae3          	beq	a2,a4,5fd6 <free+0x16>
    bp->s.ptr = p->s.ptr;
    6026:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    602a:	4790                	lw	a2,8(a5)
    602c:	02061713          	slli	a4,a2,0x20
    6030:	9301                	srli	a4,a4,0x20
    6032:	0712                	slli	a4,a4,0x4
    6034:	973e                	add	a4,a4,a5
    6036:	fae689e3          	beq	a3,a4,5fe8 <free+0x28>
  } else
    p->s.ptr = bp;
    603a:	e394                	sd	a3,0(a5)
  freep = p;
    603c:	00003717          	auipc	a4,0x3
    6040:	40f73a23          	sd	a5,1044(a4) # 9450 <freep>
}
    6044:	6422                	ld	s0,8(sp)
    6046:	0141                	addi	sp,sp,16
    6048:	8082                	ret

000000000000604a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    604a:	7139                	addi	sp,sp,-64
    604c:	fc06                	sd	ra,56(sp)
    604e:	f822                	sd	s0,48(sp)
    6050:	f426                	sd	s1,40(sp)
    6052:	f04a                	sd	s2,32(sp)
    6054:	ec4e                	sd	s3,24(sp)
    6056:	e852                	sd	s4,16(sp)
    6058:	e456                	sd	s5,8(sp)
    605a:	e05a                	sd	s6,0(sp)
    605c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    605e:	02051993          	slli	s3,a0,0x20
    6062:	0209d993          	srli	s3,s3,0x20
    6066:	09bd                	addi	s3,s3,15
    6068:	0049d993          	srli	s3,s3,0x4
    606c:	2985                	addiw	s3,s3,1
    606e:	0009891b          	sext.w	s2,s3
  if((prevp = freep) == 0){
    6072:	00003797          	auipc	a5,0x3
    6076:	3de78793          	addi	a5,a5,990 # 9450 <freep>
    607a:	6388                	ld	a0,0(a5)
    607c:	c515                	beqz	a0,60a8 <malloc+0x5e>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    607e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    6080:	4798                	lw	a4,8(a5)
    6082:	03277f63          	bgeu	a4,s2,60c0 <malloc+0x76>
    6086:	8a4e                	mv	s4,s3
    6088:	0009871b          	sext.w	a4,s3
    608c:	6685                	lui	a3,0x1
    608e:	00d77363          	bgeu	a4,a3,6094 <malloc+0x4a>
    6092:	6a05                	lui	s4,0x1
    6094:	000a0a9b          	sext.w	s5,s4
  p = sbrk(nu * sizeof(Header));
    6098:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    609c:	00003497          	auipc	s1,0x3
    60a0:	3b448493          	addi	s1,s1,948 # 9450 <freep>
  if(p == (char*)-1)
    60a4:	5b7d                	li	s6,-1
    60a6:	a885                	j	6116 <malloc+0xcc>
    base.s.ptr = freep = prevp = &base;
    60a8:	0000a797          	auipc	a5,0xa
    60ac:	bd078793          	addi	a5,a5,-1072 # fc78 <base>
    60b0:	00003717          	auipc	a4,0x3
    60b4:	3af73023          	sd	a5,928(a4) # 9450 <freep>
    60b8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    60ba:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    60be:	b7e1                	j	6086 <malloc+0x3c>
      if(p->s.size == nunits)
    60c0:	02e90b63          	beq	s2,a4,60f6 <malloc+0xac>
        p->s.size -= nunits;
    60c4:	4137073b          	subw	a4,a4,s3
    60c8:	c798                	sw	a4,8(a5)
        p += p->s.size;
    60ca:	1702                	slli	a4,a4,0x20
    60cc:	9301                	srli	a4,a4,0x20
    60ce:	0712                	slli	a4,a4,0x4
    60d0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    60d2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    60d6:	00003717          	auipc	a4,0x3
    60da:	36a73d23          	sd	a0,890(a4) # 9450 <freep>
      return (void*)(p + 1);
    60de:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    60e2:	70e2                	ld	ra,56(sp)
    60e4:	7442                	ld	s0,48(sp)
    60e6:	74a2                	ld	s1,40(sp)
    60e8:	7902                	ld	s2,32(sp)
    60ea:	69e2                	ld	s3,24(sp)
    60ec:	6a42                	ld	s4,16(sp)
    60ee:	6aa2                	ld	s5,8(sp)
    60f0:	6b02                	ld	s6,0(sp)
    60f2:	6121                	addi	sp,sp,64
    60f4:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    60f6:	6398                	ld	a4,0(a5)
    60f8:	e118                	sd	a4,0(a0)
    60fa:	bff1                	j	60d6 <malloc+0x8c>
  hp->s.size = nu;
    60fc:	01552423          	sw	s5,8(a0)
  free((void*)(hp + 1));
    6100:	0541                	addi	a0,a0,16
    6102:	00000097          	auipc	ra,0x0
    6106:	ebe080e7          	jalr	-322(ra) # 5fc0 <free>
  return freep;
    610a:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    610c:	d979                	beqz	a0,60e2 <malloc+0x98>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    610e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    6110:	4798                	lw	a4,8(a5)
    6112:	fb2777e3          	bgeu	a4,s2,60c0 <malloc+0x76>
    if(p == freep)
    6116:	6098                	ld	a4,0(s1)
    6118:	853e                	mv	a0,a5
    611a:	fef71ae3          	bne	a4,a5,610e <malloc+0xc4>
  p = sbrk(nu * sizeof(Header));
    611e:	8552                	mv	a0,s4
    6120:	00000097          	auipc	ra,0x0
    6124:	b7a080e7          	jalr	-1158(ra) # 5c9a <sbrk>
  if(p == (char*)-1)
    6128:	fd651ae3          	bne	a0,s6,60fc <malloc+0xb2>
        return 0;
    612c:	4501                	li	a0,0
    612e:	bf55                	j	60e2 <malloc+0x98>
