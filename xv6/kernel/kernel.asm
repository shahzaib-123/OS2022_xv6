
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	8d013103          	ld	sp,-1840(sp) # 800088d0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	076000ef          	jal	ra,8000008c <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f1402773          	csrr	a4,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000026:	2701                	sext.w	a4,a4

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80000028:	0037161b          	slliw	a2,a4,0x3
    8000002c:	020047b7          	lui	a5,0x2004
    80000030:	963e                	add	a2,a2,a5
    80000032:	0200c7b7          	lui	a5,0x200c
    80000036:	ff87b783          	ld	a5,-8(a5) # 200bff8 <_entry-0x7dff4008>
    8000003a:	000f46b7          	lui	a3,0xf4
    8000003e:	24068693          	addi	a3,a3,576 # f4240 <_entry-0x7ff0bdc0>
    80000042:	97b6                	add	a5,a5,a3
    80000044:	e21c                	sd	a5,0(a2)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000046:	00271793          	slli	a5,a4,0x2
    8000004a:	97ba                	add	a5,a5,a4
    8000004c:	00379713          	slli	a4,a5,0x3
    80000050:	00009797          	auipc	a5,0x9
    80000054:	8e078793          	addi	a5,a5,-1824 # 80008930 <timer_scratch>
    80000058:	97ba                	add	a5,a5,a4
  scratch[3] = CLINT_MTIMECMP(id);
    8000005a:	ef90                	sd	a2,24(a5)
  scratch[4] = interval;
    8000005c:	f394                	sd	a3,32(a5)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000005e:	34079073          	csrw	mscratch,a5
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000062:	00006797          	auipc	a5,0x6
    80000066:	d6e78793          	addi	a5,a5,-658 # 80005dd0 <timervec>
    8000006a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000006e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000072:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000076:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000007a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000007e:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80000082:	30479073          	csrw	mie,a5
}
    80000086:	6422                	ld	s0,8(sp)
    80000088:	0141                	addi	sp,sp,16
    8000008a:	8082                	ret

000000008000008c <start>:
{
    8000008c:	1141                	addi	sp,sp,-16
    8000008e:	e406                	sd	ra,8(sp)
    80000090:	e022                	sd	s0,0(sp)
    80000092:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000094:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000098:	7779                	lui	a4,0xffffe
    8000009a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdca5f>
    8000009e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a0:	6705                	lui	a4,0x1
    800000a2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ac:	00001797          	auipc	a5,0x1
    800000b0:	e5878793          	addi	a5,a5,-424 # 80000f04 <main>
    800000b4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000b8:	4781                	li	a5,0
    800000ba:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000be:	67c1                	lui	a5,0x10
    800000c0:	17fd                	addi	a5,a5,-1
    800000c2:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c6:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000ca:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000ce:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000d2:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000d6:	57fd                	li	a5,-1
    800000d8:	83a9                	srli	a5,a5,0xa
    800000da:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000de:	47bd                	li	a5,15
    800000e0:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000e4:	00000097          	auipc	ra,0x0
    800000e8:	f38080e7          	jalr	-200(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000ec:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000f0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000f2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000f4:	30200073          	mret
}
    800000f8:	60a2                	ld	ra,8(sp)
    800000fa:	6402                	ld	s0,0(sp)
    800000fc:	0141                	addi	sp,sp,16
    800000fe:	8082                	ret

0000000080000100 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80000100:	715d                	addi	sp,sp,-80
    80000102:	e486                	sd	ra,72(sp)
    80000104:	e0a2                	sd	s0,64(sp)
    80000106:	fc26                	sd	s1,56(sp)
    80000108:	f84a                	sd	s2,48(sp)
    8000010a:	f44e                	sd	s3,40(sp)
    8000010c:	f052                	sd	s4,32(sp)
    8000010e:	ec56                	sd	s5,24(sp)
    80000110:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80000112:	04c05663          	blez	a2,8000015e <consolewrite+0x5e>
    80000116:	8a2a                	mv	s4,a0
    80000118:	892e                	mv	s2,a1
    8000011a:	89b2                	mv	s3,a2
    8000011c:	4481                	li	s1,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000011e:	5afd                	li	s5,-1
    80000120:	4685                	li	a3,1
    80000122:	864a                	mv	a2,s2
    80000124:	85d2                	mv	a1,s4
    80000126:	fbf40513          	addi	a0,s0,-65
    8000012a:	00002097          	auipc	ra,0x2
    8000012e:	418080e7          	jalr	1048(ra) # 80002542 <either_copyin>
    80000132:	01550c63          	beq	a0,s5,8000014a <consolewrite+0x4a>
      break;
    uartputc(c);
    80000136:	fbf44503          	lbu	a0,-65(s0)
    8000013a:	00000097          	auipc	ra,0x0
    8000013e:	7d8080e7          	jalr	2008(ra) # 80000912 <uartputc>
  for(i = 0; i < n; i++){
    80000142:	2485                	addiw	s1,s1,1
    80000144:	0905                	addi	s2,s2,1
    80000146:	fc999de3          	bne	s3,s1,80000120 <consolewrite+0x20>
  }

  return i;
}
    8000014a:	8526                	mv	a0,s1
    8000014c:	60a6                	ld	ra,72(sp)
    8000014e:	6406                	ld	s0,64(sp)
    80000150:	74e2                	ld	s1,56(sp)
    80000152:	7942                	ld	s2,48(sp)
    80000154:	79a2                	ld	s3,40(sp)
    80000156:	7a02                	ld	s4,32(sp)
    80000158:	6ae2                	ld	s5,24(sp)
    8000015a:	6161                	addi	sp,sp,80
    8000015c:	8082                	ret
  for(i = 0; i < n; i++){
    8000015e:	4481                	li	s1,0
    80000160:	b7ed                	j	8000014a <consolewrite+0x4a>

0000000080000162 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000162:	7119                	addi	sp,sp,-128
    80000164:	fc86                	sd	ra,120(sp)
    80000166:	f8a2                	sd	s0,112(sp)
    80000168:	f4a6                	sd	s1,104(sp)
    8000016a:	f0ca                	sd	s2,96(sp)
    8000016c:	ecce                	sd	s3,88(sp)
    8000016e:	e8d2                	sd	s4,80(sp)
    80000170:	e4d6                	sd	s5,72(sp)
    80000172:	e0da                	sd	s6,64(sp)
    80000174:	fc5e                	sd	s7,56(sp)
    80000176:	f862                	sd	s8,48(sp)
    80000178:	f466                	sd	s9,40(sp)
    8000017a:	f06a                	sd	s10,32(sp)
    8000017c:	ec6e                	sd	s11,24(sp)
    8000017e:	0100                	addi	s0,sp,128
    80000180:	8caa                	mv	s9,a0
    80000182:	8aae                	mv	s5,a1
    80000184:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000186:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000018a:	00011517          	auipc	a0,0x11
    8000018e:	8e650513          	addi	a0,a0,-1818 # 80010a70 <cons>
    80000192:	00001097          	auipc	ra,0x1
    80000196:	aa6080e7          	jalr	-1370(ra) # 80000c38 <acquire>
  while(n > 0){
    8000019a:	09405963          	blez	s4,8000022c <consoleread+0xca>
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000019e:	00011497          	auipc	s1,0x11
    800001a2:	8d248493          	addi	s1,s1,-1838 # 80010a70 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a6:	89a6                	mv	s3,s1
    800001a8:	00011917          	auipc	s2,0x11
    800001ac:	96090913          	addi	s2,s2,-1696 # 80010b08 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    800001b0:	4c11                	li	s8,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001b2:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800001b4:	4da9                	li	s11,10
    while(cons.r == cons.w){
    800001b6:	0984a783          	lw	a5,152(s1)
    800001ba:	09c4a703          	lw	a4,156(s1)
    800001be:	02f71763          	bne	a4,a5,800001ec <consoleread+0x8a>
      if(killed(myproc())){
    800001c2:	00002097          	auipc	ra,0x2
    800001c6:	878080e7          	jalr	-1928(ra) # 80001a3a <myproc>
    800001ca:	00002097          	auipc	ra,0x2
    800001ce:	1c2080e7          	jalr	450(ra) # 8000238c <killed>
    800001d2:	e925                	bnez	a0,80000242 <consoleread+0xe0>
      sleep(&cons.r, &cons.lock);
    800001d4:	85ce                	mv	a1,s3
    800001d6:	854a                	mv	a0,s2
    800001d8:	00002097          	auipc	ra,0x2
    800001dc:	f0a080e7          	jalr	-246(ra) # 800020e2 <sleep>
    while(cons.r == cons.w){
    800001e0:	0984a783          	lw	a5,152(s1)
    800001e4:	09c4a703          	lw	a4,156(s1)
    800001e8:	fcf70de3          	beq	a4,a5,800001c2 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001ec:	0017871b          	addiw	a4,a5,1
    800001f0:	08e4ac23          	sw	a4,152(s1)
    800001f4:	07f7f713          	andi	a4,a5,127
    800001f8:	9726                	add	a4,a4,s1
    800001fa:	01874703          	lbu	a4,24(a4)
    800001fe:	00070b9b          	sext.w	s7,a4
    if(c == C('D')){  // end-of-file
    80000202:	078b8863          	beq	s7,s8,80000272 <consoleread+0x110>
    cbuf = c;
    80000206:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000020a:	4685                	li	a3,1
    8000020c:	f8f40613          	addi	a2,s0,-113
    80000210:	85d6                	mv	a1,s5
    80000212:	8566                	mv	a0,s9
    80000214:	00002097          	auipc	ra,0x2
    80000218:	2d8080e7          	jalr	728(ra) # 800024ec <either_copyout>
    8000021c:	01a50863          	beq	a0,s10,8000022c <consoleread+0xca>
    dst++;
    80000220:	0a85                	addi	s5,s5,1
    --n;
    80000222:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80000224:	01bb8463          	beq	s7,s11,8000022c <consoleread+0xca>
  while(n > 0){
    80000228:	f80a17e3          	bnez	s4,800001b6 <consoleread+0x54>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    8000022c:	00011517          	auipc	a0,0x11
    80000230:	84450513          	addi	a0,a0,-1980 # 80010a70 <cons>
    80000234:	00001097          	auipc	ra,0x1
    80000238:	ab8080e7          	jalr	-1352(ra) # 80000cec <release>

  return target - n;
    8000023c:	414b053b          	subw	a0,s6,s4
    80000240:	a811                	j	80000254 <consoleread+0xf2>
        release(&cons.lock);
    80000242:	00011517          	auipc	a0,0x11
    80000246:	82e50513          	addi	a0,a0,-2002 # 80010a70 <cons>
    8000024a:	00001097          	auipc	ra,0x1
    8000024e:	aa2080e7          	jalr	-1374(ra) # 80000cec <release>
        return -1;
    80000252:	557d                	li	a0,-1
}
    80000254:	70e6                	ld	ra,120(sp)
    80000256:	7446                	ld	s0,112(sp)
    80000258:	74a6                	ld	s1,104(sp)
    8000025a:	7906                	ld	s2,96(sp)
    8000025c:	69e6                	ld	s3,88(sp)
    8000025e:	6a46                	ld	s4,80(sp)
    80000260:	6aa6                	ld	s5,72(sp)
    80000262:	6b06                	ld	s6,64(sp)
    80000264:	7be2                	ld	s7,56(sp)
    80000266:	7c42                	ld	s8,48(sp)
    80000268:	7ca2                	ld	s9,40(sp)
    8000026a:	7d02                	ld	s10,32(sp)
    8000026c:	6de2                	ld	s11,24(sp)
    8000026e:	6109                	addi	sp,sp,128
    80000270:	8082                	ret
      if(n < target){
    80000272:	000a071b          	sext.w	a4,s4
    80000276:	fb677be3          	bgeu	a4,s6,8000022c <consoleread+0xca>
        cons.r--;
    8000027a:	00011717          	auipc	a4,0x11
    8000027e:	88f72723          	sw	a5,-1906(a4) # 80010b08 <cons+0x98>
    80000282:	b76d                	j	8000022c <consoleread+0xca>

0000000080000284 <consputc>:
{
    80000284:	1141                	addi	sp,sp,-16
    80000286:	e406                	sd	ra,8(sp)
    80000288:	e022                	sd	s0,0(sp)
    8000028a:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000028c:	10000793          	li	a5,256
    80000290:	00f50a63          	beq	a0,a5,800002a4 <consputc+0x20>
    uartputc_sync(c);
    80000294:	00000097          	auipc	ra,0x0
    80000298:	58a080e7          	jalr	1418(ra) # 8000081e <uartputc_sync>
}
    8000029c:	60a2                	ld	ra,8(sp)
    8000029e:	6402                	ld	s0,0(sp)
    800002a0:	0141                	addi	sp,sp,16
    800002a2:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800002a4:	4521                	li	a0,8
    800002a6:	00000097          	auipc	ra,0x0
    800002aa:	578080e7          	jalr	1400(ra) # 8000081e <uartputc_sync>
    800002ae:	02000513          	li	a0,32
    800002b2:	00000097          	auipc	ra,0x0
    800002b6:	56c080e7          	jalr	1388(ra) # 8000081e <uartputc_sync>
    800002ba:	4521                	li	a0,8
    800002bc:	00000097          	auipc	ra,0x0
    800002c0:	562080e7          	jalr	1378(ra) # 8000081e <uartputc_sync>
    800002c4:	bfe1                	j	8000029c <consputc+0x18>

00000000800002c6 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002c6:	1101                	addi	sp,sp,-32
    800002c8:	ec06                	sd	ra,24(sp)
    800002ca:	e822                	sd	s0,16(sp)
    800002cc:	e426                	sd	s1,8(sp)
    800002ce:	e04a                	sd	s2,0(sp)
    800002d0:	1000                	addi	s0,sp,32
    800002d2:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002d4:	00010517          	auipc	a0,0x10
    800002d8:	79c50513          	addi	a0,a0,1948 # 80010a70 <cons>
    800002dc:	00001097          	auipc	ra,0x1
    800002e0:	95c080e7          	jalr	-1700(ra) # 80000c38 <acquire>

  switch(c){
    800002e4:	47c1                	li	a5,16
    800002e6:	12f48463          	beq	s1,a5,8000040e <consoleintr+0x148>
    800002ea:	0297df63          	bge	a5,s1,80000328 <consoleintr+0x62>
    800002ee:	47d5                	li	a5,21
    800002f0:	0af48863          	beq	s1,a5,800003a0 <consoleintr+0xda>
    800002f4:	07f00793          	li	a5,127
    800002f8:	02f49b63          	bne	s1,a5,8000032e <consoleintr+0x68>
      consputc(BACKSPACE);
    }
    break;
  case C('H'): // Backspace
  case '\x7f': // Delete key
    if(cons.e != cons.w){
    800002fc:	00010717          	auipc	a4,0x10
    80000300:	77470713          	addi	a4,a4,1908 # 80010a70 <cons>
    80000304:	0a072783          	lw	a5,160(a4)
    80000308:	09c72703          	lw	a4,156(a4)
    8000030c:	10f70563          	beq	a4,a5,80000416 <consoleintr+0x150>
      cons.e--;
    80000310:	37fd                	addiw	a5,a5,-1
    80000312:	00010717          	auipc	a4,0x10
    80000316:	7ef72f23          	sw	a5,2046(a4) # 80010b10 <cons+0xa0>
      consputc(BACKSPACE);
    8000031a:	10000513          	li	a0,256
    8000031e:	00000097          	auipc	ra,0x0
    80000322:	f66080e7          	jalr	-154(ra) # 80000284 <consputc>
    80000326:	a8c5                	j	80000416 <consoleintr+0x150>
  switch(c){
    80000328:	47a1                	li	a5,8
    8000032a:	fcf489e3          	beq	s1,a5,800002fc <consoleintr+0x36>
    }
    break;
  default:
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000032e:	c4e5                	beqz	s1,80000416 <consoleintr+0x150>
    80000330:	00010717          	auipc	a4,0x10
    80000334:	74070713          	addi	a4,a4,1856 # 80010a70 <cons>
    80000338:	0a072783          	lw	a5,160(a4)
    8000033c:	09872703          	lw	a4,152(a4)
    80000340:	9f99                	subw	a5,a5,a4
    80000342:	07f00713          	li	a4,127
    80000346:	0cf76863          	bltu	a4,a5,80000416 <consoleintr+0x150>
      c = (c == '\r') ? '\n' : c;
    8000034a:	47b5                	li	a5,13
    8000034c:	0ef48363          	beq	s1,a5,80000432 <consoleintr+0x16c>

      // echo back to the user.
      consputc(c);
    80000350:	8526                	mv	a0,s1
    80000352:	00000097          	auipc	ra,0x0
    80000356:	f32080e7          	jalr	-206(ra) # 80000284 <consputc>

      // store for consumption by consoleread().
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8000035a:	00010797          	auipc	a5,0x10
    8000035e:	71678793          	addi	a5,a5,1814 # 80010a70 <cons>
    80000362:	0a07a683          	lw	a3,160(a5)
    80000366:	0016871b          	addiw	a4,a3,1
    8000036a:	0007061b          	sext.w	a2,a4
    8000036e:	0ae7a023          	sw	a4,160(a5)
    80000372:	07f6f693          	andi	a3,a3,127
    80000376:	97b6                	add	a5,a5,a3
    80000378:	00978c23          	sb	s1,24(a5)

      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    8000037c:	47a9                	li	a5,10
    8000037e:	0ef48163          	beq	s1,a5,80000460 <consoleintr+0x19a>
    80000382:	4791                	li	a5,4
    80000384:	0cf48e63          	beq	s1,a5,80000460 <consoleintr+0x19a>
    80000388:	00010797          	auipc	a5,0x10
    8000038c:	6e878793          	addi	a5,a5,1768 # 80010a70 <cons>
    80000390:	0987a783          	lw	a5,152(a5)
    80000394:	9f1d                	subw	a4,a4,a5
    80000396:	08000793          	li	a5,128
    8000039a:	06f71e63          	bne	a4,a5,80000416 <consoleintr+0x150>
    8000039e:	a0c9                	j	80000460 <consoleintr+0x19a>
    while(cons.e != cons.w &&
    800003a0:	00010717          	auipc	a4,0x10
    800003a4:	6d070713          	addi	a4,a4,1744 # 80010a70 <cons>
    800003a8:	0a072783          	lw	a5,160(a4)
    800003ac:	09c72703          	lw	a4,156(a4)
    800003b0:	06f70363          	beq	a4,a5,80000416 <consoleintr+0x150>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800003b4:	37fd                	addiw	a5,a5,-1
    800003b6:	0007871b          	sext.w	a4,a5
    800003ba:	07f7f793          	andi	a5,a5,127
    800003be:	00010697          	auipc	a3,0x10
    800003c2:	6b268693          	addi	a3,a3,1714 # 80010a70 <cons>
    800003c6:	97b6                	add	a5,a5,a3
    while(cons.e != cons.w &&
    800003c8:	0187c683          	lbu	a3,24(a5)
    800003cc:	47a9                	li	a5,10
      cons.e--;
    800003ce:	00010497          	auipc	s1,0x10
    800003d2:	6a248493          	addi	s1,s1,1698 # 80010a70 <cons>
    while(cons.e != cons.w &&
    800003d6:	4929                	li	s2,10
    800003d8:	02f68f63          	beq	a3,a5,80000416 <consoleintr+0x150>
      cons.e--;
    800003dc:	0ae4a023          	sw	a4,160(s1)
      consputc(BACKSPACE);
    800003e0:	10000513          	li	a0,256
    800003e4:	00000097          	auipc	ra,0x0
    800003e8:	ea0080e7          	jalr	-352(ra) # 80000284 <consputc>
    while(cons.e != cons.w &&
    800003ec:	0a04a783          	lw	a5,160(s1)
    800003f0:	09c4a703          	lw	a4,156(s1)
    800003f4:	02f70163          	beq	a4,a5,80000416 <consoleintr+0x150>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800003f8:	37fd                	addiw	a5,a5,-1
    800003fa:	0007871b          	sext.w	a4,a5
    800003fe:	07f7f793          	andi	a5,a5,127
    80000402:	97a6                	add	a5,a5,s1
    while(cons.e != cons.w &&
    80000404:	0187c783          	lbu	a5,24(a5)
    80000408:	fd279ae3          	bne	a5,s2,800003dc <consoleintr+0x116>
    8000040c:	a029                	j	80000416 <consoleintr+0x150>
    procdump();
    8000040e:	00002097          	auipc	ra,0x2
    80000412:	18a080e7          	jalr	394(ra) # 80002598 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80000416:	00010517          	auipc	a0,0x10
    8000041a:	65a50513          	addi	a0,a0,1626 # 80010a70 <cons>
    8000041e:	00001097          	auipc	ra,0x1
    80000422:	8ce080e7          	jalr	-1842(ra) # 80000cec <release>
}
    80000426:	60e2                	ld	ra,24(sp)
    80000428:	6442                	ld	s0,16(sp)
    8000042a:	64a2                	ld	s1,8(sp)
    8000042c:	6902                	ld	s2,0(sp)
    8000042e:	6105                	addi	sp,sp,32
    80000430:	8082                	ret
      consputc(c);
    80000432:	4529                	li	a0,10
    80000434:	00000097          	auipc	ra,0x0
    80000438:	e50080e7          	jalr	-432(ra) # 80000284 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8000043c:	00010797          	auipc	a5,0x10
    80000440:	63478793          	addi	a5,a5,1588 # 80010a70 <cons>
    80000444:	0a07a703          	lw	a4,160(a5)
    80000448:	0017069b          	addiw	a3,a4,1
    8000044c:	0006861b          	sext.w	a2,a3
    80000450:	0ad7a023          	sw	a3,160(a5)
    80000454:	07f77713          	andi	a4,a4,127
    80000458:	97ba                	add	a5,a5,a4
    8000045a:	4729                	li	a4,10
    8000045c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000460:	00010797          	auipc	a5,0x10
    80000464:	6ac7a623          	sw	a2,1708(a5) # 80010b0c <cons+0x9c>
        wakeup(&cons.r);
    80000468:	00010517          	auipc	a0,0x10
    8000046c:	6a050513          	addi	a0,a0,1696 # 80010b08 <cons+0x98>
    80000470:	00002097          	auipc	ra,0x2
    80000474:	cd6080e7          	jalr	-810(ra) # 80002146 <wakeup>
    80000478:	bf79                	j	80000416 <consoleintr+0x150>

000000008000047a <consoleinit>:

void
consoleinit(void)
{
    8000047a:	1141                	addi	sp,sp,-16
    8000047c:	e406                	sd	ra,8(sp)
    8000047e:	e022                	sd	s0,0(sp)
    80000480:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000482:	00008597          	auipc	a1,0x8
    80000486:	b8e58593          	addi	a1,a1,-1138 # 80008010 <etext+0x10>
    8000048a:	00010517          	auipc	a0,0x10
    8000048e:	5e650513          	addi	a0,a0,1510 # 80010a70 <cons>
    80000492:	00000097          	auipc	ra,0x0
    80000496:	716080e7          	jalr	1814(ra) # 80000ba8 <initlock>

  uartinit();
    8000049a:	00000097          	auipc	ra,0x0
    8000049e:	334080e7          	jalr	820(ra) # 800007ce <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    800004a2:	00020797          	auipc	a5,0x20
    800004a6:	76678793          	addi	a5,a5,1894 # 80020c08 <devsw>
    800004aa:	00000717          	auipc	a4,0x0
    800004ae:	cb870713          	addi	a4,a4,-840 # 80000162 <consoleread>
    800004b2:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800004b4:	00000717          	auipc	a4,0x0
    800004b8:	c4c70713          	addi	a4,a4,-948 # 80000100 <consolewrite>
    800004bc:	ef98                	sd	a4,24(a5)
}
    800004be:	60a2                	ld	ra,8(sp)
    800004c0:	6402                	ld	s0,0(sp)
    800004c2:	0141                	addi	sp,sp,16
    800004c4:	8082                	ret

00000000800004c6 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800004c6:	7179                	addi	sp,sp,-48
    800004c8:	f406                	sd	ra,40(sp)
    800004ca:	f022                	sd	s0,32(sp)
    800004cc:	ec26                	sd	s1,24(sp)
    800004ce:	e84a                	sd	s2,16(sp)
    800004d0:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004d2:	c219                	beqz	a2,800004d8 <printint+0x12>
    800004d4:	00054d63          	bltz	a0,800004ee <printint+0x28>
    x = -xx;
  else
    x = xx;
    800004d8:	2501                	sext.w	a0,a0
    800004da:	4881                	li	a7,0
    800004dc:	fd040713          	addi	a4,s0,-48

  i = 0;
    800004e0:	4601                	li	a2,0
  do {
    buf[i++] = digits[x % base];
    800004e2:	2581                	sext.w	a1,a1
    800004e4:	00008817          	auipc	a6,0x8
    800004e8:	b3480813          	addi	a6,a6,-1228 # 80008018 <digits>
    800004ec:	a801                	j	800004fc <printint+0x36>
    x = -xx;
    800004ee:	40a0053b          	negw	a0,a0
    800004f2:	2501                	sext.w	a0,a0
  if(sign && (sign = xx < 0))
    800004f4:	4885                	li	a7,1
    x = -xx;
    800004f6:	b7dd                	j	800004dc <printint+0x16>
  } while((x /= base) != 0);
    800004f8:	853e                	mv	a0,a5
    buf[i++] = digits[x % base];
    800004fa:	8636                	mv	a2,a3
    800004fc:	0016069b          	addiw	a3,a2,1
    80000500:	02b577bb          	remuw	a5,a0,a1
    80000504:	1782                	slli	a5,a5,0x20
    80000506:	9381                	srli	a5,a5,0x20
    80000508:	97c2                	add	a5,a5,a6
    8000050a:	0007c783          	lbu	a5,0(a5)
    8000050e:	00f70023          	sb	a5,0(a4)
  } while((x /= base) != 0);
    80000512:	0705                	addi	a4,a4,1
    80000514:	02b557bb          	divuw	a5,a0,a1
    80000518:	feb570e3          	bgeu	a0,a1,800004f8 <printint+0x32>

  if(sign)
    8000051c:	00088b63          	beqz	a7,80000532 <printint+0x6c>
    buf[i++] = '-';
    80000520:	fe040793          	addi	a5,s0,-32
    80000524:	96be                	add	a3,a3,a5
    80000526:	02d00793          	li	a5,45
    8000052a:	fef68823          	sb	a5,-16(a3)
    8000052e:	0026069b          	addiw	a3,a2,2

  while(--i >= 0)
    80000532:	02d05763          	blez	a3,80000560 <printint+0x9a>
    80000536:	fd040793          	addi	a5,s0,-48
    8000053a:	00d784b3          	add	s1,a5,a3
    8000053e:	fff78913          	addi	s2,a5,-1
    80000542:	9936                	add	s2,s2,a3
    80000544:	36fd                	addiw	a3,a3,-1
    80000546:	1682                	slli	a3,a3,0x20
    80000548:	9281                	srli	a3,a3,0x20
    8000054a:	40d90933          	sub	s2,s2,a3
    consputc(buf[i]);
    8000054e:	fff4c503          	lbu	a0,-1(s1)
    80000552:	00000097          	auipc	ra,0x0
    80000556:	d32080e7          	jalr	-718(ra) # 80000284 <consputc>
  while(--i >= 0)
    8000055a:	14fd                	addi	s1,s1,-1
    8000055c:	ff2499e3          	bne	s1,s2,8000054e <printint+0x88>
}
    80000560:	70a2                	ld	ra,40(sp)
    80000562:	7402                	ld	s0,32(sp)
    80000564:	64e2                	ld	s1,24(sp)
    80000566:	6942                	ld	s2,16(sp)
    80000568:	6145                	addi	sp,sp,48
    8000056a:	8082                	ret

000000008000056c <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    8000056c:	1101                	addi	sp,sp,-32
    8000056e:	ec06                	sd	ra,24(sp)
    80000570:	e822                	sd	s0,16(sp)
    80000572:	e426                	sd	s1,8(sp)
    80000574:	1000                	addi	s0,sp,32
    80000576:	84aa                	mv	s1,a0
  pr.locking = 0;
    80000578:	00010797          	auipc	a5,0x10
    8000057c:	5a07ac23          	sw	zero,1464(a5) # 80010b30 <pr+0x18>
  printf("panic: ");
    80000580:	00008517          	auipc	a0,0x8
    80000584:	ab050513          	addi	a0,a0,-1360 # 80008030 <digits+0x18>
    80000588:	00000097          	auipc	ra,0x0
    8000058c:	02e080e7          	jalr	46(ra) # 800005b6 <printf>
  printf(s);
    80000590:	8526                	mv	a0,s1
    80000592:	00000097          	auipc	ra,0x0
    80000596:	024080e7          	jalr	36(ra) # 800005b6 <printf>
  printf("\n");
    8000059a:	00008517          	auipc	a0,0x8
    8000059e:	b2e50513          	addi	a0,a0,-1234 # 800080c8 <digits+0xb0>
    800005a2:	00000097          	auipc	ra,0x0
    800005a6:	014080e7          	jalr	20(ra) # 800005b6 <printf>
  panicked = 1; // freeze uart output from other CPUs
    800005aa:	4785                	li	a5,1
    800005ac:	00008717          	auipc	a4,0x8
    800005b0:	34f72223          	sw	a5,836(a4) # 800088f0 <panicked>
  for(;;)
    800005b4:	a001                	j	800005b4 <panic+0x48>

00000000800005b6 <printf>:
{
    800005b6:	7131                	addi	sp,sp,-192
    800005b8:	fc86                	sd	ra,120(sp)
    800005ba:	f8a2                	sd	s0,112(sp)
    800005bc:	f4a6                	sd	s1,104(sp)
    800005be:	f0ca                	sd	s2,96(sp)
    800005c0:	ecce                	sd	s3,88(sp)
    800005c2:	e8d2                	sd	s4,80(sp)
    800005c4:	e4d6                	sd	s5,72(sp)
    800005c6:	e0da                	sd	s6,64(sp)
    800005c8:	fc5e                	sd	s7,56(sp)
    800005ca:	f862                	sd	s8,48(sp)
    800005cc:	f466                	sd	s9,40(sp)
    800005ce:	f06a                	sd	s10,32(sp)
    800005d0:	ec6e                	sd	s11,24(sp)
    800005d2:	0100                	addi	s0,sp,128
    800005d4:	8aaa                	mv	s5,a0
    800005d6:	e40c                	sd	a1,8(s0)
    800005d8:	e810                	sd	a2,16(s0)
    800005da:	ec14                	sd	a3,24(s0)
    800005dc:	f018                	sd	a4,32(s0)
    800005de:	f41c                	sd	a5,40(s0)
    800005e0:	03043823          	sd	a6,48(s0)
    800005e4:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005e8:	00010797          	auipc	a5,0x10
    800005ec:	53078793          	addi	a5,a5,1328 # 80010b18 <pr>
    800005f0:	0187ad83          	lw	s11,24(a5)
  if(locking)
    800005f4:	020d9b63          	bnez	s11,8000062a <printf+0x74>
  if (fmt == 0)
    800005f8:	020a8f63          	beqz	s5,80000636 <printf+0x80>
  va_start(ap, fmt);
    800005fc:	00840793          	addi	a5,s0,8
    80000600:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000604:	000ac503          	lbu	a0,0(s5)
    80000608:	16050063          	beqz	a0,80000768 <printf+0x1b2>
    8000060c:	4481                	li	s1,0
    if(c != '%'){
    8000060e:	02500a13          	li	s4,37
    switch(c){
    80000612:	07000b13          	li	s6,112
  consputc('x');
    80000616:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80000618:	00008b97          	auipc	s7,0x8
    8000061c:	a00b8b93          	addi	s7,s7,-1536 # 80008018 <digits>
    switch(c){
    80000620:	07300c93          	li	s9,115
    80000624:	06400c13          	li	s8,100
    80000628:	a815                	j	8000065c <printf+0xa6>
    acquire(&pr.lock);
    8000062a:	853e                	mv	a0,a5
    8000062c:	00000097          	auipc	ra,0x0
    80000630:	60c080e7          	jalr	1548(ra) # 80000c38 <acquire>
    80000634:	b7d1                	j	800005f8 <printf+0x42>
    panic("null fmt");
    80000636:	00008517          	auipc	a0,0x8
    8000063a:	a0a50513          	addi	a0,a0,-1526 # 80008040 <digits+0x28>
    8000063e:	00000097          	auipc	ra,0x0
    80000642:	f2e080e7          	jalr	-210(ra) # 8000056c <panic>
      consputc(c);
    80000646:	00000097          	auipc	ra,0x0
    8000064a:	c3e080e7          	jalr	-962(ra) # 80000284 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000064e:	2485                	addiw	s1,s1,1
    80000650:	009a87b3          	add	a5,s5,s1
    80000654:	0007c503          	lbu	a0,0(a5)
    80000658:	10050863          	beqz	a0,80000768 <printf+0x1b2>
    if(c != '%'){
    8000065c:	ff4515e3          	bne	a0,s4,80000646 <printf+0x90>
    c = fmt[++i] & 0xff;
    80000660:	2485                	addiw	s1,s1,1
    80000662:	009a87b3          	add	a5,s5,s1
    80000666:	0007c783          	lbu	a5,0(a5)
    8000066a:	0007891b          	sext.w	s2,a5
    if(c == 0)
    8000066e:	0e090d63          	beqz	s2,80000768 <printf+0x1b2>
    switch(c){
    80000672:	05678a63          	beq	a5,s6,800006c6 <printf+0x110>
    80000676:	02fb7663          	bgeu	s6,a5,800006a2 <printf+0xec>
    8000067a:	09978963          	beq	a5,s9,8000070c <printf+0x156>
    8000067e:	07800713          	li	a4,120
    80000682:	0ce79863          	bne	a5,a4,80000752 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80000686:	f8843783          	ld	a5,-120(s0)
    8000068a:	00878713          	addi	a4,a5,8
    8000068e:	f8e43423          	sd	a4,-120(s0)
    80000692:	4605                	li	a2,1
    80000694:	85ea                	mv	a1,s10
    80000696:	4388                	lw	a0,0(a5)
    80000698:	00000097          	auipc	ra,0x0
    8000069c:	e2e080e7          	jalr	-466(ra) # 800004c6 <printint>
      break;
    800006a0:	b77d                	j	8000064e <printf+0x98>
    switch(c){
    800006a2:	0b478263          	beq	a5,s4,80000746 <printf+0x190>
    800006a6:	0b879663          	bne	a5,s8,80000752 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    800006aa:	f8843783          	ld	a5,-120(s0)
    800006ae:	00878713          	addi	a4,a5,8
    800006b2:	f8e43423          	sd	a4,-120(s0)
    800006b6:	4605                	li	a2,1
    800006b8:	45a9                	li	a1,10
    800006ba:	4388                	lw	a0,0(a5)
    800006bc:	00000097          	auipc	ra,0x0
    800006c0:	e0a080e7          	jalr	-502(ra) # 800004c6 <printint>
      break;
    800006c4:	b769                	j	8000064e <printf+0x98>
      printptr(va_arg(ap, uint64));
    800006c6:	f8843783          	ld	a5,-120(s0)
    800006ca:	00878713          	addi	a4,a5,8
    800006ce:	f8e43423          	sd	a4,-120(s0)
    800006d2:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800006d6:	03000513          	li	a0,48
    800006da:	00000097          	auipc	ra,0x0
    800006de:	baa080e7          	jalr	-1110(ra) # 80000284 <consputc>
  consputc('x');
    800006e2:	07800513          	li	a0,120
    800006e6:	00000097          	auipc	ra,0x0
    800006ea:	b9e080e7          	jalr	-1122(ra) # 80000284 <consputc>
    800006ee:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006f0:	03c9d793          	srli	a5,s3,0x3c
    800006f4:	97de                	add	a5,a5,s7
    800006f6:	0007c503          	lbu	a0,0(a5)
    800006fa:	00000097          	auipc	ra,0x0
    800006fe:	b8a080e7          	jalr	-1142(ra) # 80000284 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80000702:	0992                	slli	s3,s3,0x4
    80000704:	397d                	addiw	s2,s2,-1
    80000706:	fe0915e3          	bnez	s2,800006f0 <printf+0x13a>
    8000070a:	b791                	j	8000064e <printf+0x98>
      if((s = va_arg(ap, char*)) == 0)
    8000070c:	f8843783          	ld	a5,-120(s0)
    80000710:	00878713          	addi	a4,a5,8
    80000714:	f8e43423          	sd	a4,-120(s0)
    80000718:	0007b903          	ld	s2,0(a5)
    8000071c:	00090e63          	beqz	s2,80000738 <printf+0x182>
      for(; *s; s++)
    80000720:	00094503          	lbu	a0,0(s2)
    80000724:	d50d                	beqz	a0,8000064e <printf+0x98>
        consputc(*s);
    80000726:	00000097          	auipc	ra,0x0
    8000072a:	b5e080e7          	jalr	-1186(ra) # 80000284 <consputc>
      for(; *s; s++)
    8000072e:	0905                	addi	s2,s2,1
    80000730:	00094503          	lbu	a0,0(s2)
    80000734:	f96d                	bnez	a0,80000726 <printf+0x170>
    80000736:	bf21                	j	8000064e <printf+0x98>
        s = "(null)";
    80000738:	00008917          	auipc	s2,0x8
    8000073c:	90090913          	addi	s2,s2,-1792 # 80008038 <digits+0x20>
      for(; *s; s++)
    80000740:	02800513          	li	a0,40
    80000744:	b7cd                	j	80000726 <printf+0x170>
      consputc('%');
    80000746:	8552                	mv	a0,s4
    80000748:	00000097          	auipc	ra,0x0
    8000074c:	b3c080e7          	jalr	-1220(ra) # 80000284 <consputc>
      break;
    80000750:	bdfd                	j	8000064e <printf+0x98>
      consputc('%');
    80000752:	8552                	mv	a0,s4
    80000754:	00000097          	auipc	ra,0x0
    80000758:	b30080e7          	jalr	-1232(ra) # 80000284 <consputc>
      consputc(c);
    8000075c:	854a                	mv	a0,s2
    8000075e:	00000097          	auipc	ra,0x0
    80000762:	b26080e7          	jalr	-1242(ra) # 80000284 <consputc>
      break;
    80000766:	b5e5                	j	8000064e <printf+0x98>
  if(locking)
    80000768:	020d9163          	bnez	s11,8000078a <printf+0x1d4>
}
    8000076c:	70e6                	ld	ra,120(sp)
    8000076e:	7446                	ld	s0,112(sp)
    80000770:	74a6                	ld	s1,104(sp)
    80000772:	7906                	ld	s2,96(sp)
    80000774:	69e6                	ld	s3,88(sp)
    80000776:	6a46                	ld	s4,80(sp)
    80000778:	6aa6                	ld	s5,72(sp)
    8000077a:	6b06                	ld	s6,64(sp)
    8000077c:	7be2                	ld	s7,56(sp)
    8000077e:	7c42                	ld	s8,48(sp)
    80000780:	7ca2                	ld	s9,40(sp)
    80000782:	7d02                	ld	s10,32(sp)
    80000784:	6de2                	ld	s11,24(sp)
    80000786:	6129                	addi	sp,sp,192
    80000788:	8082                	ret
    release(&pr.lock);
    8000078a:	00010517          	auipc	a0,0x10
    8000078e:	38e50513          	addi	a0,a0,910 # 80010b18 <pr>
    80000792:	00000097          	auipc	ra,0x0
    80000796:	55a080e7          	jalr	1370(ra) # 80000cec <release>
}
    8000079a:	bfc9                	j	8000076c <printf+0x1b6>

000000008000079c <printfinit>:
    ;
}

void
printfinit(void)
{
    8000079c:	1101                	addi	sp,sp,-32
    8000079e:	ec06                	sd	ra,24(sp)
    800007a0:	e822                	sd	s0,16(sp)
    800007a2:	e426                	sd	s1,8(sp)
    800007a4:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800007a6:	00010497          	auipc	s1,0x10
    800007aa:	37248493          	addi	s1,s1,882 # 80010b18 <pr>
    800007ae:	00008597          	auipc	a1,0x8
    800007b2:	8a258593          	addi	a1,a1,-1886 # 80008050 <digits+0x38>
    800007b6:	8526                	mv	a0,s1
    800007b8:	00000097          	auipc	ra,0x0
    800007bc:	3f0080e7          	jalr	1008(ra) # 80000ba8 <initlock>
  pr.locking = 1;
    800007c0:	4785                	li	a5,1
    800007c2:	cc9c                	sw	a5,24(s1)
}
    800007c4:	60e2                	ld	ra,24(sp)
    800007c6:	6442                	ld	s0,16(sp)
    800007c8:	64a2                	ld	s1,8(sp)
    800007ca:	6105                	addi	sp,sp,32
    800007cc:	8082                	ret

00000000800007ce <uartinit>:

void uartstart();

void
uartinit(void)
{
    800007ce:	1141                	addi	sp,sp,-16
    800007d0:	e406                	sd	ra,8(sp)
    800007d2:	e022                	sd	s0,0(sp)
    800007d4:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007d6:	100007b7          	lui	a5,0x10000
    800007da:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007de:	f8000713          	li	a4,-128
    800007e2:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007e6:	470d                	li	a4,3
    800007e8:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007ec:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007f0:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007f4:	469d                	li	a3,7
    800007f6:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007fa:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007fe:	00008597          	auipc	a1,0x8
    80000802:	85a58593          	addi	a1,a1,-1958 # 80008058 <digits+0x40>
    80000806:	00010517          	auipc	a0,0x10
    8000080a:	33250513          	addi	a0,a0,818 # 80010b38 <uart_tx_lock>
    8000080e:	00000097          	auipc	ra,0x0
    80000812:	39a080e7          	jalr	922(ra) # 80000ba8 <initlock>
}
    80000816:	60a2                	ld	ra,8(sp)
    80000818:	6402                	ld	s0,0(sp)
    8000081a:	0141                	addi	sp,sp,16
    8000081c:	8082                	ret

000000008000081e <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000081e:	1101                	addi	sp,sp,-32
    80000820:	ec06                	sd	ra,24(sp)
    80000822:	e822                	sd	s0,16(sp)
    80000824:	e426                	sd	s1,8(sp)
    80000826:	1000                	addi	s0,sp,32
    80000828:	84aa                	mv	s1,a0
  push_off();
    8000082a:	00000097          	auipc	ra,0x0
    8000082e:	3c2080e7          	jalr	962(ra) # 80000bec <push_off>

  if(panicked){
    80000832:	00008797          	auipc	a5,0x8
    80000836:	0be78793          	addi	a5,a5,190 # 800088f0 <panicked>
    8000083a:	439c                	lw	a5,0(a5)
    8000083c:	2781                	sext.w	a5,a5
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000083e:	10000737          	lui	a4,0x10000
  if(panicked){
    80000842:	c391                	beqz	a5,80000846 <uartputc_sync+0x28>
    for(;;)
    80000844:	a001                	j	80000844 <uartputc_sync+0x26>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000846:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000084a:	0ff7f793          	andi	a5,a5,255
    8000084e:	0207f793          	andi	a5,a5,32
    80000852:	dbf5                	beqz	a5,80000846 <uartputc_sync+0x28>
    ;
  WriteReg(THR, c);
    80000854:	0ff4f793          	andi	a5,s1,255
    80000858:	10000737          	lui	a4,0x10000
    8000085c:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80000860:	00000097          	auipc	ra,0x0
    80000864:	42c080e7          	jalr	1068(ra) # 80000c8c <pop_off>
}
    80000868:	60e2                	ld	ra,24(sp)
    8000086a:	6442                	ld	s0,16(sp)
    8000086c:	64a2                	ld	s1,8(sp)
    8000086e:	6105                	addi	sp,sp,32
    80000870:	8082                	ret

0000000080000872 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80000872:	00008797          	auipc	a5,0x8
    80000876:	08678793          	addi	a5,a5,134 # 800088f8 <uart_tx_r>
    8000087a:	639c                	ld	a5,0(a5)
    8000087c:	00008717          	auipc	a4,0x8
    80000880:	08470713          	addi	a4,a4,132 # 80008900 <uart_tx_w>
    80000884:	6318                	ld	a4,0(a4)
    80000886:	08f70563          	beq	a4,a5,80000910 <uartstart+0x9e>
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000088a:	10000737          	lui	a4,0x10000
    8000088e:	00574703          	lbu	a4,5(a4) # 10000005 <_entry-0x6ffffffb>
    80000892:	0ff77713          	andi	a4,a4,255
    80000896:	02077713          	andi	a4,a4,32
    8000089a:	cb3d                	beqz	a4,80000910 <uartstart+0x9e>
{
    8000089c:	7139                	addi	sp,sp,-64
    8000089e:	fc06                	sd	ra,56(sp)
    800008a0:	f822                	sd	s0,48(sp)
    800008a2:	f426                	sd	s1,40(sp)
    800008a4:	f04a                	sd	s2,32(sp)
    800008a6:	ec4e                	sd	s3,24(sp)
    800008a8:	e852                	sd	s4,16(sp)
    800008aa:	e456                	sd	s5,8(sp)
    800008ac:	0080                	addi	s0,sp,64
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008ae:	00010a17          	auipc	s4,0x10
    800008b2:	28aa0a13          	addi	s4,s4,650 # 80010b38 <uart_tx_lock>
    uart_tx_r += 1;
    800008b6:	00008497          	auipc	s1,0x8
    800008ba:	04248493          	addi	s1,s1,66 # 800088f8 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008be:	10000937          	lui	s2,0x10000
    if(uart_tx_w == uart_tx_r){
    800008c2:	00008997          	auipc	s3,0x8
    800008c6:	03e98993          	addi	s3,s3,62 # 80008900 <uart_tx_w>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008ca:	01f7f713          	andi	a4,a5,31
    800008ce:	9752                	add	a4,a4,s4
    800008d0:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    800008d4:	0785                	addi	a5,a5,1
    800008d6:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800008d8:	8526                	mv	a0,s1
    800008da:	00002097          	auipc	ra,0x2
    800008de:	86c080e7          	jalr	-1940(ra) # 80002146 <wakeup>
    WriteReg(THR, c);
    800008e2:	01590023          	sb	s5,0(s2) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    800008e6:	609c                	ld	a5,0(s1)
    800008e8:	0009b703          	ld	a4,0(s3)
    800008ec:	00f70963          	beq	a4,a5,800008fe <uartstart+0x8c>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008f0:	00594703          	lbu	a4,5(s2)
    800008f4:	0ff77713          	andi	a4,a4,255
    800008f8:	02077713          	andi	a4,a4,32
    800008fc:	f779                	bnez	a4,800008ca <uartstart+0x58>
  }
}
    800008fe:	70e2                	ld	ra,56(sp)
    80000900:	7442                	ld	s0,48(sp)
    80000902:	74a2                	ld	s1,40(sp)
    80000904:	7902                	ld	s2,32(sp)
    80000906:	69e2                	ld	s3,24(sp)
    80000908:	6a42                	ld	s4,16(sp)
    8000090a:	6aa2                	ld	s5,8(sp)
    8000090c:	6121                	addi	sp,sp,64
    8000090e:	8082                	ret
    80000910:	8082                	ret

0000000080000912 <uartputc>:
{
    80000912:	7179                	addi	sp,sp,-48
    80000914:	f406                	sd	ra,40(sp)
    80000916:	f022                	sd	s0,32(sp)
    80000918:	ec26                	sd	s1,24(sp)
    8000091a:	e84a                	sd	s2,16(sp)
    8000091c:	e44e                	sd	s3,8(sp)
    8000091e:	e052                	sd	s4,0(sp)
    80000920:	1800                	addi	s0,sp,48
    80000922:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80000924:	00010517          	auipc	a0,0x10
    80000928:	21450513          	addi	a0,a0,532 # 80010b38 <uart_tx_lock>
    8000092c:	00000097          	auipc	ra,0x0
    80000930:	30c080e7          	jalr	780(ra) # 80000c38 <acquire>
  if(panicked){
    80000934:	00008797          	auipc	a5,0x8
    80000938:	fbc78793          	addi	a5,a5,-68 # 800088f0 <panicked>
    8000093c:	439c                	lw	a5,0(a5)
    8000093e:	2781                	sext.w	a5,a5
    80000940:	e7d9                	bnez	a5,800009ce <uartputc+0xbc>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000942:	00008797          	auipc	a5,0x8
    80000946:	fbe78793          	addi	a5,a5,-66 # 80008900 <uart_tx_w>
    8000094a:	639c                	ld	a5,0(a5)
    8000094c:	00008717          	auipc	a4,0x8
    80000950:	fac70713          	addi	a4,a4,-84 # 800088f8 <uart_tx_r>
    80000954:	6318                	ld	a4,0(a4)
    80000956:	02070713          	addi	a4,a4,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000095a:	00010a17          	auipc	s4,0x10
    8000095e:	1dea0a13          	addi	s4,s4,478 # 80010b38 <uart_tx_lock>
    80000962:	00008497          	auipc	s1,0x8
    80000966:	f9648493          	addi	s1,s1,-106 # 800088f8 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000096a:	00008917          	auipc	s2,0x8
    8000096e:	f9690913          	addi	s2,s2,-106 # 80008900 <uart_tx_w>
    80000972:	00f71f63          	bne	a4,a5,80000990 <uartputc+0x7e>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000976:	85d2                	mv	a1,s4
    80000978:	8526                	mv	a0,s1
    8000097a:	00001097          	auipc	ra,0x1
    8000097e:	768080e7          	jalr	1896(ra) # 800020e2 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000982:	00093783          	ld	a5,0(s2)
    80000986:	6098                	ld	a4,0(s1)
    80000988:	02070713          	addi	a4,a4,32
    8000098c:	fef705e3          	beq	a4,a5,80000976 <uartputc+0x64>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000990:	00010497          	auipc	s1,0x10
    80000994:	1a848493          	addi	s1,s1,424 # 80010b38 <uart_tx_lock>
    80000998:	01f7f713          	andi	a4,a5,31
    8000099c:	9726                	add	a4,a4,s1
    8000099e:	01370c23          	sb	s3,24(a4)
  uart_tx_w += 1;
    800009a2:	0785                	addi	a5,a5,1
    800009a4:	00008717          	auipc	a4,0x8
    800009a8:	f4f73e23          	sd	a5,-164(a4) # 80008900 <uart_tx_w>
  uartstart();
    800009ac:	00000097          	auipc	ra,0x0
    800009b0:	ec6080e7          	jalr	-314(ra) # 80000872 <uartstart>
  release(&uart_tx_lock);
    800009b4:	8526                	mv	a0,s1
    800009b6:	00000097          	auipc	ra,0x0
    800009ba:	336080e7          	jalr	822(ra) # 80000cec <release>
}
    800009be:	70a2                	ld	ra,40(sp)
    800009c0:	7402                	ld	s0,32(sp)
    800009c2:	64e2                	ld	s1,24(sp)
    800009c4:	6942                	ld	s2,16(sp)
    800009c6:	69a2                	ld	s3,8(sp)
    800009c8:	6a02                	ld	s4,0(sp)
    800009ca:	6145                	addi	sp,sp,48
    800009cc:	8082                	ret
    for(;;)
    800009ce:	a001                	j	800009ce <uartputc+0xbc>

00000000800009d0 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009d0:	1141                	addi	sp,sp,-16
    800009d2:	e422                	sd	s0,8(sp)
    800009d4:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800009d6:	100007b7          	lui	a5,0x10000
    800009da:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800009de:	8b85                	andi	a5,a5,1
    800009e0:	cb91                	beqz	a5,800009f4 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800009e2:	100007b7          	lui	a5,0x10000
    800009e6:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800009ea:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800009ee:	6422                	ld	s0,8(sp)
    800009f0:	0141                	addi	sp,sp,16
    800009f2:	8082                	ret
    return -1;
    800009f4:	557d                	li	a0,-1
    800009f6:	bfe5                	j	800009ee <uartgetc+0x1e>

00000000800009f8 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800009f8:	1101                	addi	sp,sp,-32
    800009fa:	ec06                	sd	ra,24(sp)
    800009fc:	e822                	sd	s0,16(sp)
    800009fe:	e426                	sd	s1,8(sp)
    80000a00:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a02:	54fd                	li	s1,-1
    int c = uartgetc();
    80000a04:	00000097          	auipc	ra,0x0
    80000a08:	fcc080e7          	jalr	-52(ra) # 800009d0 <uartgetc>
    if(c == -1)
    80000a0c:	00950763          	beq	a0,s1,80000a1a <uartintr+0x22>
      break;
    consoleintr(c);
    80000a10:	00000097          	auipc	ra,0x0
    80000a14:	8b6080e7          	jalr	-1866(ra) # 800002c6 <consoleintr>
  while(1){
    80000a18:	b7f5                	j	80000a04 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000a1a:	00010497          	auipc	s1,0x10
    80000a1e:	11e48493          	addi	s1,s1,286 # 80010b38 <uart_tx_lock>
    80000a22:	8526                	mv	a0,s1
    80000a24:	00000097          	auipc	ra,0x0
    80000a28:	214080e7          	jalr	532(ra) # 80000c38 <acquire>
  uartstart();
    80000a2c:	00000097          	auipc	ra,0x0
    80000a30:	e46080e7          	jalr	-442(ra) # 80000872 <uartstart>
  release(&uart_tx_lock);
    80000a34:	8526                	mv	a0,s1
    80000a36:	00000097          	auipc	ra,0x0
    80000a3a:	2b6080e7          	jalr	694(ra) # 80000cec <release>
}
    80000a3e:	60e2                	ld	ra,24(sp)
    80000a40:	6442                	ld	s0,16(sp)
    80000a42:	64a2                	ld	s1,8(sp)
    80000a44:	6105                	addi	sp,sp,32
    80000a46:	8082                	ret

0000000080000a48 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a48:	1101                	addi	sp,sp,-32
    80000a4a:	ec06                	sd	ra,24(sp)
    80000a4c:	e822                	sd	s0,16(sp)
    80000a4e:	e426                	sd	s1,8(sp)
    80000a50:	e04a                	sd	s2,0(sp)
    80000a52:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a54:	6785                	lui	a5,0x1
    80000a56:	17fd                	addi	a5,a5,-1
    80000a58:	8fe9                	and	a5,a5,a0
    80000a5a:	ebb9                	bnez	a5,80000ab0 <kfree+0x68>
    80000a5c:	84aa                	mv	s1,a0
    80000a5e:	00021797          	auipc	a5,0x21
    80000a62:	34278793          	addi	a5,a5,834 # 80021da0 <end>
    80000a66:	04f56563          	bltu	a0,a5,80000ab0 <kfree+0x68>
    80000a6a:	47c5                	li	a5,17
    80000a6c:	07ee                	slli	a5,a5,0x1b
    80000a6e:	04f57163          	bgeu	a0,a5,80000ab0 <kfree+0x68>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a72:	6605                	lui	a2,0x1
    80000a74:	4585                	li	a1,1
    80000a76:	00000097          	auipc	ra,0x0
    80000a7a:	2be080e7          	jalr	702(ra) # 80000d34 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a7e:	00010917          	auipc	s2,0x10
    80000a82:	0f290913          	addi	s2,s2,242 # 80010b70 <kmem>
    80000a86:	854a                	mv	a0,s2
    80000a88:	00000097          	auipc	ra,0x0
    80000a8c:	1b0080e7          	jalr	432(ra) # 80000c38 <acquire>
  r->next = kmem.freelist;
    80000a90:	01893783          	ld	a5,24(s2)
    80000a94:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a96:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a9a:	854a                	mv	a0,s2
    80000a9c:	00000097          	auipc	ra,0x0
    80000aa0:	250080e7          	jalr	592(ra) # 80000cec <release>
}
    80000aa4:	60e2                	ld	ra,24(sp)
    80000aa6:	6442                	ld	s0,16(sp)
    80000aa8:	64a2                	ld	s1,8(sp)
    80000aaa:	6902                	ld	s2,0(sp)
    80000aac:	6105                	addi	sp,sp,32
    80000aae:	8082                	ret
    panic("kfree");
    80000ab0:	00007517          	auipc	a0,0x7
    80000ab4:	5b050513          	addi	a0,a0,1456 # 80008060 <digits+0x48>
    80000ab8:	00000097          	auipc	ra,0x0
    80000abc:	ab4080e7          	jalr	-1356(ra) # 8000056c <panic>

0000000080000ac0 <freerange>:
{
    80000ac0:	7179                	addi	sp,sp,-48
    80000ac2:	f406                	sd	ra,40(sp)
    80000ac4:	f022                	sd	s0,32(sp)
    80000ac6:	ec26                	sd	s1,24(sp)
    80000ac8:	e84a                	sd	s2,16(sp)
    80000aca:	e44e                	sd	s3,8(sp)
    80000acc:	e052                	sd	s4,0(sp)
    80000ace:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000ad0:	6705                	lui	a4,0x1
    80000ad2:	fff70793          	addi	a5,a4,-1 # fff <_entry-0x7ffff001>
    80000ad6:	00f504b3          	add	s1,a0,a5
    80000ada:	77fd                	lui	a5,0xfffff
    80000adc:	8cfd                	and	s1,s1,a5
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ade:	94ba                	add	s1,s1,a4
    80000ae0:	0095ee63          	bltu	a1,s1,80000afc <freerange+0x3c>
    80000ae4:	892e                	mv	s2,a1
    kfree(p);
    80000ae6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ae8:	6985                	lui	s3,0x1
    kfree(p);
    80000aea:	01448533          	add	a0,s1,s4
    80000aee:	00000097          	auipc	ra,0x0
    80000af2:	f5a080e7          	jalr	-166(ra) # 80000a48 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000af6:	94ce                	add	s1,s1,s3
    80000af8:	fe9979e3          	bgeu	s2,s1,80000aea <freerange+0x2a>
}
    80000afc:	70a2                	ld	ra,40(sp)
    80000afe:	7402                	ld	s0,32(sp)
    80000b00:	64e2                	ld	s1,24(sp)
    80000b02:	6942                	ld	s2,16(sp)
    80000b04:	69a2                	ld	s3,8(sp)
    80000b06:	6a02                	ld	s4,0(sp)
    80000b08:	6145                	addi	sp,sp,48
    80000b0a:	8082                	ret

0000000080000b0c <kinit>:
{
    80000b0c:	1141                	addi	sp,sp,-16
    80000b0e:	e406                	sd	ra,8(sp)
    80000b10:	e022                	sd	s0,0(sp)
    80000b12:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000b14:	00007597          	auipc	a1,0x7
    80000b18:	55458593          	addi	a1,a1,1364 # 80008068 <digits+0x50>
    80000b1c:	00010517          	auipc	a0,0x10
    80000b20:	05450513          	addi	a0,a0,84 # 80010b70 <kmem>
    80000b24:	00000097          	auipc	ra,0x0
    80000b28:	084080e7          	jalr	132(ra) # 80000ba8 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b2c:	45c5                	li	a1,17
    80000b2e:	05ee                	slli	a1,a1,0x1b
    80000b30:	00021517          	auipc	a0,0x21
    80000b34:	27050513          	addi	a0,a0,624 # 80021da0 <end>
    80000b38:	00000097          	auipc	ra,0x0
    80000b3c:	f88080e7          	jalr	-120(ra) # 80000ac0 <freerange>
}
    80000b40:	60a2                	ld	ra,8(sp)
    80000b42:	6402                	ld	s0,0(sp)
    80000b44:	0141                	addi	sp,sp,16
    80000b46:	8082                	ret

0000000080000b48 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b48:	1101                	addi	sp,sp,-32
    80000b4a:	ec06                	sd	ra,24(sp)
    80000b4c:	e822                	sd	s0,16(sp)
    80000b4e:	e426                	sd	s1,8(sp)
    80000b50:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b52:	00010497          	auipc	s1,0x10
    80000b56:	01e48493          	addi	s1,s1,30 # 80010b70 <kmem>
    80000b5a:	8526                	mv	a0,s1
    80000b5c:	00000097          	auipc	ra,0x0
    80000b60:	0dc080e7          	jalr	220(ra) # 80000c38 <acquire>
  r = kmem.freelist;
    80000b64:	6c84                	ld	s1,24(s1)
  if(r)
    80000b66:	c885                	beqz	s1,80000b96 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000b68:	609c                	ld	a5,0(s1)
    80000b6a:	00010517          	auipc	a0,0x10
    80000b6e:	00650513          	addi	a0,a0,6 # 80010b70 <kmem>
    80000b72:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b74:	00000097          	auipc	ra,0x0
    80000b78:	178080e7          	jalr	376(ra) # 80000cec <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b7c:	6605                	lui	a2,0x1
    80000b7e:	4595                	li	a1,5
    80000b80:	8526                	mv	a0,s1
    80000b82:	00000097          	auipc	ra,0x0
    80000b86:	1b2080e7          	jalr	434(ra) # 80000d34 <memset>
  return (void*)r;
}
    80000b8a:	8526                	mv	a0,s1
    80000b8c:	60e2                	ld	ra,24(sp)
    80000b8e:	6442                	ld	s0,16(sp)
    80000b90:	64a2                	ld	s1,8(sp)
    80000b92:	6105                	addi	sp,sp,32
    80000b94:	8082                	ret
  release(&kmem.lock);
    80000b96:	00010517          	auipc	a0,0x10
    80000b9a:	fda50513          	addi	a0,a0,-38 # 80010b70 <kmem>
    80000b9e:	00000097          	auipc	ra,0x0
    80000ba2:	14e080e7          	jalr	334(ra) # 80000cec <release>
  if(r)
    80000ba6:	b7d5                	j	80000b8a <kalloc+0x42>

0000000080000ba8 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000ba8:	1141                	addi	sp,sp,-16
    80000baa:	e422                	sd	s0,8(sp)
    80000bac:	0800                	addi	s0,sp,16
  lk->name = name;
    80000bae:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000bb0:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000bb4:	00053823          	sd	zero,16(a0)
}
    80000bb8:	6422                	ld	s0,8(sp)
    80000bba:	0141                	addi	sp,sp,16
    80000bbc:	8082                	ret

0000000080000bbe <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000bbe:	411c                	lw	a5,0(a0)
    80000bc0:	e399                	bnez	a5,80000bc6 <holding+0x8>
    80000bc2:	4501                	li	a0,0
  return r;
}
    80000bc4:	8082                	ret
{
    80000bc6:	1101                	addi	sp,sp,-32
    80000bc8:	ec06                	sd	ra,24(sp)
    80000bca:	e822                	sd	s0,16(sp)
    80000bcc:	e426                	sd	s1,8(sp)
    80000bce:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000bd0:	6904                	ld	s1,16(a0)
    80000bd2:	00001097          	auipc	ra,0x1
    80000bd6:	e4c080e7          	jalr	-436(ra) # 80001a1e <mycpu>
    80000bda:	40a48533          	sub	a0,s1,a0
    80000bde:	00153513          	seqz	a0,a0
}
    80000be2:	60e2                	ld	ra,24(sp)
    80000be4:	6442                	ld	s0,16(sp)
    80000be6:	64a2                	ld	s1,8(sp)
    80000be8:	6105                	addi	sp,sp,32
    80000bea:	8082                	ret

0000000080000bec <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000bec:	1101                	addi	sp,sp,-32
    80000bee:	ec06                	sd	ra,24(sp)
    80000bf0:	e822                	sd	s0,16(sp)
    80000bf2:	e426                	sd	s1,8(sp)
    80000bf4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bf6:	100024f3          	csrr	s1,sstatus
    80000bfa:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000bfe:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c00:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000c04:	00001097          	auipc	ra,0x1
    80000c08:	e1a080e7          	jalr	-486(ra) # 80001a1e <mycpu>
    80000c0c:	5d3c                	lw	a5,120(a0)
    80000c0e:	cf89                	beqz	a5,80000c28 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000c10:	00001097          	auipc	ra,0x1
    80000c14:	e0e080e7          	jalr	-498(ra) # 80001a1e <mycpu>
    80000c18:	5d3c                	lw	a5,120(a0)
    80000c1a:	2785                	addiw	a5,a5,1
    80000c1c:	dd3c                	sw	a5,120(a0)
}
    80000c1e:	60e2                	ld	ra,24(sp)
    80000c20:	6442                	ld	s0,16(sp)
    80000c22:	64a2                	ld	s1,8(sp)
    80000c24:	6105                	addi	sp,sp,32
    80000c26:	8082                	ret
    mycpu()->intena = old;
    80000c28:	00001097          	auipc	ra,0x1
    80000c2c:	df6080e7          	jalr	-522(ra) # 80001a1e <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000c30:	8085                	srli	s1,s1,0x1
    80000c32:	8885                	andi	s1,s1,1
    80000c34:	dd64                	sw	s1,124(a0)
    80000c36:	bfe9                	j	80000c10 <push_off+0x24>

0000000080000c38 <acquire>:
{
    80000c38:	1101                	addi	sp,sp,-32
    80000c3a:	ec06                	sd	ra,24(sp)
    80000c3c:	e822                	sd	s0,16(sp)
    80000c3e:	e426                	sd	s1,8(sp)
    80000c40:	1000                	addi	s0,sp,32
    80000c42:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c44:	00000097          	auipc	ra,0x0
    80000c48:	fa8080e7          	jalr	-88(ra) # 80000bec <push_off>
  if(holding(lk))
    80000c4c:	8526                	mv	a0,s1
    80000c4e:	00000097          	auipc	ra,0x0
    80000c52:	f70080e7          	jalr	-144(ra) # 80000bbe <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c56:	4705                	li	a4,1
  if(holding(lk))
    80000c58:	e115                	bnez	a0,80000c7c <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c5a:	87ba                	mv	a5,a4
    80000c5c:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c60:	2781                	sext.w	a5,a5
    80000c62:	ffe5                	bnez	a5,80000c5a <acquire+0x22>
  __sync_synchronize();
    80000c64:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000c68:	00001097          	auipc	ra,0x1
    80000c6c:	db6080e7          	jalr	-586(ra) # 80001a1e <mycpu>
    80000c70:	e888                	sd	a0,16(s1)
}
    80000c72:	60e2                	ld	ra,24(sp)
    80000c74:	6442                	ld	s0,16(sp)
    80000c76:	64a2                	ld	s1,8(sp)
    80000c78:	6105                	addi	sp,sp,32
    80000c7a:	8082                	ret
    panic("acquire");
    80000c7c:	00007517          	auipc	a0,0x7
    80000c80:	3f450513          	addi	a0,a0,1012 # 80008070 <digits+0x58>
    80000c84:	00000097          	auipc	ra,0x0
    80000c88:	8e8080e7          	jalr	-1816(ra) # 8000056c <panic>

0000000080000c8c <pop_off>:

void
pop_off(void)
{
    80000c8c:	1141                	addi	sp,sp,-16
    80000c8e:	e406                	sd	ra,8(sp)
    80000c90:	e022                	sd	s0,0(sp)
    80000c92:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c94:	00001097          	auipc	ra,0x1
    80000c98:	d8a080e7          	jalr	-630(ra) # 80001a1e <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c9c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000ca0:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000ca2:	e78d                	bnez	a5,80000ccc <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000ca4:	5d3c                	lw	a5,120(a0)
    80000ca6:	02f05b63          	blez	a5,80000cdc <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000caa:	37fd                	addiw	a5,a5,-1
    80000cac:	0007871b          	sext.w	a4,a5
    80000cb0:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000cb2:	eb09                	bnez	a4,80000cc4 <pop_off+0x38>
    80000cb4:	5d7c                	lw	a5,124(a0)
    80000cb6:	c799                	beqz	a5,80000cc4 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000cb8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000cbc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000cc0:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000cc4:	60a2                	ld	ra,8(sp)
    80000cc6:	6402                	ld	s0,0(sp)
    80000cc8:	0141                	addi	sp,sp,16
    80000cca:	8082                	ret
    panic("pop_off - interruptible");
    80000ccc:	00007517          	auipc	a0,0x7
    80000cd0:	3ac50513          	addi	a0,a0,940 # 80008078 <digits+0x60>
    80000cd4:	00000097          	auipc	ra,0x0
    80000cd8:	898080e7          	jalr	-1896(ra) # 8000056c <panic>
    panic("pop_off");
    80000cdc:	00007517          	auipc	a0,0x7
    80000ce0:	3b450513          	addi	a0,a0,948 # 80008090 <digits+0x78>
    80000ce4:	00000097          	auipc	ra,0x0
    80000ce8:	888080e7          	jalr	-1912(ra) # 8000056c <panic>

0000000080000cec <release>:
{
    80000cec:	1101                	addi	sp,sp,-32
    80000cee:	ec06                	sd	ra,24(sp)
    80000cf0:	e822                	sd	s0,16(sp)
    80000cf2:	e426                	sd	s1,8(sp)
    80000cf4:	1000                	addi	s0,sp,32
    80000cf6:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000cf8:	00000097          	auipc	ra,0x0
    80000cfc:	ec6080e7          	jalr	-314(ra) # 80000bbe <holding>
    80000d00:	c115                	beqz	a0,80000d24 <release+0x38>
  lk->cpu = 0;
    80000d02:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000d06:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000d0a:	0f50000f          	fence	iorw,ow
    80000d0e:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000d12:	00000097          	auipc	ra,0x0
    80000d16:	f7a080e7          	jalr	-134(ra) # 80000c8c <pop_off>
}
    80000d1a:	60e2                	ld	ra,24(sp)
    80000d1c:	6442                	ld	s0,16(sp)
    80000d1e:	64a2                	ld	s1,8(sp)
    80000d20:	6105                	addi	sp,sp,32
    80000d22:	8082                	ret
    panic("release");
    80000d24:	00007517          	auipc	a0,0x7
    80000d28:	37450513          	addi	a0,a0,884 # 80008098 <digits+0x80>
    80000d2c:	00000097          	auipc	ra,0x0
    80000d30:	840080e7          	jalr	-1984(ra) # 8000056c <panic>

0000000080000d34 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000d34:	1141                	addi	sp,sp,-16
    80000d36:	e422                	sd	s0,8(sp)
    80000d38:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000d3a:	ce09                	beqz	a2,80000d54 <memset+0x20>
    80000d3c:	87aa                	mv	a5,a0
    80000d3e:	fff6071b          	addiw	a4,a2,-1
    80000d42:	1702                	slli	a4,a4,0x20
    80000d44:	9301                	srli	a4,a4,0x20
    80000d46:	0705                	addi	a4,a4,1
    80000d48:	972a                	add	a4,a4,a0
    cdst[i] = c;
    80000d4a:	00b78023          	sb	a1,0(a5) # fffffffffffff000 <end+0xffffffff7ffdd260>
  for(i = 0; i < n; i++){
    80000d4e:	0785                	addi	a5,a5,1
    80000d50:	fee79de3          	bne	a5,a4,80000d4a <memset+0x16>
  }
  return dst;
}
    80000d54:	6422                	ld	s0,8(sp)
    80000d56:	0141                	addi	sp,sp,16
    80000d58:	8082                	ret

0000000080000d5a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000d5a:	1141                	addi	sp,sp,-16
    80000d5c:	e422                	sd	s0,8(sp)
    80000d5e:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000d60:	ce15                	beqz	a2,80000d9c <memcmp+0x42>
    80000d62:	fff6069b          	addiw	a3,a2,-1
    if(*s1 != *s2)
    80000d66:	00054783          	lbu	a5,0(a0)
    80000d6a:	0005c703          	lbu	a4,0(a1)
    80000d6e:	02e79063          	bne	a5,a4,80000d8e <memcmp+0x34>
    80000d72:	1682                	slli	a3,a3,0x20
    80000d74:	9281                	srli	a3,a3,0x20
    80000d76:	0685                	addi	a3,a3,1
    80000d78:	96aa                	add	a3,a3,a0
      return *s1 - *s2;
    s1++, s2++;
    80000d7a:	0505                	addi	a0,a0,1
    80000d7c:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d7e:	00d50d63          	beq	a0,a3,80000d98 <memcmp+0x3e>
    if(*s1 != *s2)
    80000d82:	00054783          	lbu	a5,0(a0)
    80000d86:	0005c703          	lbu	a4,0(a1)
    80000d8a:	fee788e3          	beq	a5,a4,80000d7a <memcmp+0x20>
      return *s1 - *s2;
    80000d8e:	40e7853b          	subw	a0,a5,a4
  }

  return 0;
}
    80000d92:	6422                	ld	s0,8(sp)
    80000d94:	0141                	addi	sp,sp,16
    80000d96:	8082                	ret
  return 0;
    80000d98:	4501                	li	a0,0
    80000d9a:	bfe5                	j	80000d92 <memcmp+0x38>
    80000d9c:	4501                	li	a0,0
    80000d9e:	bfd5                	j	80000d92 <memcmp+0x38>

0000000080000da0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000da0:	1141                	addi	sp,sp,-16
    80000da2:	e422                	sd	s0,8(sp)
    80000da4:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000da6:	ca0d                	beqz	a2,80000dd8 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000da8:	00a5f963          	bgeu	a1,a0,80000dba <memmove+0x1a>
    80000dac:	02061693          	slli	a3,a2,0x20
    80000db0:	9281                	srli	a3,a3,0x20
    80000db2:	00d58733          	add	a4,a1,a3
    80000db6:	02e56463          	bltu	a0,a4,80000dde <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000dba:	fff6079b          	addiw	a5,a2,-1
    80000dbe:	1782                	slli	a5,a5,0x20
    80000dc0:	9381                	srli	a5,a5,0x20
    80000dc2:	0785                	addi	a5,a5,1
    80000dc4:	97ae                	add	a5,a5,a1
    80000dc6:	872a                	mv	a4,a0
      *d++ = *s++;
    80000dc8:	0585                	addi	a1,a1,1
    80000dca:	0705                	addi	a4,a4,1
    80000dcc:	fff5c683          	lbu	a3,-1(a1)
    80000dd0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000dd4:	fef59ae3          	bne	a1,a5,80000dc8 <memmove+0x28>

  return dst;
}
    80000dd8:	6422                	ld	s0,8(sp)
    80000dda:	0141                	addi	sp,sp,16
    80000ddc:	8082                	ret
    d += n;
    80000dde:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000de0:	fff6079b          	addiw	a5,a2,-1
    80000de4:	1782                	slli	a5,a5,0x20
    80000de6:	9381                	srli	a5,a5,0x20
    80000de8:	fff7c793          	not	a5,a5
    80000dec:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000dee:	177d                	addi	a4,a4,-1
    80000df0:	16fd                	addi	a3,a3,-1
    80000df2:	00074603          	lbu	a2,0(a4)
    80000df6:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000dfa:	fee79ae3          	bne	a5,a4,80000dee <memmove+0x4e>
    80000dfe:	bfe9                	j	80000dd8 <memmove+0x38>

0000000080000e00 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000e00:	1141                	addi	sp,sp,-16
    80000e02:	e406                	sd	ra,8(sp)
    80000e04:	e022                	sd	s0,0(sp)
    80000e06:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000e08:	00000097          	auipc	ra,0x0
    80000e0c:	f98080e7          	jalr	-104(ra) # 80000da0 <memmove>
}
    80000e10:	60a2                	ld	ra,8(sp)
    80000e12:	6402                	ld	s0,0(sp)
    80000e14:	0141                	addi	sp,sp,16
    80000e16:	8082                	ret

0000000080000e18 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000e18:	1141                	addi	sp,sp,-16
    80000e1a:	e422                	sd	s0,8(sp)
    80000e1c:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000e1e:	c229                	beqz	a2,80000e60 <strncmp+0x48>
    80000e20:	00054783          	lbu	a5,0(a0)
    80000e24:	c795                	beqz	a5,80000e50 <strncmp+0x38>
    80000e26:	0005c703          	lbu	a4,0(a1)
    80000e2a:	02f71363          	bne	a4,a5,80000e50 <strncmp+0x38>
    80000e2e:	fff6071b          	addiw	a4,a2,-1
    80000e32:	1702                	slli	a4,a4,0x20
    80000e34:	9301                	srli	a4,a4,0x20
    80000e36:	0705                	addi	a4,a4,1
    80000e38:	972a                	add	a4,a4,a0
    n--, p++, q++;
    80000e3a:	0505                	addi	a0,a0,1
    80000e3c:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000e3e:	02e50363          	beq	a0,a4,80000e64 <strncmp+0x4c>
    80000e42:	00054783          	lbu	a5,0(a0)
    80000e46:	c789                	beqz	a5,80000e50 <strncmp+0x38>
    80000e48:	0005c683          	lbu	a3,0(a1)
    80000e4c:	fef687e3          	beq	a3,a5,80000e3a <strncmp+0x22>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
    80000e50:	00054503          	lbu	a0,0(a0)
    80000e54:	0005c783          	lbu	a5,0(a1)
    80000e58:	9d1d                	subw	a0,a0,a5
}
    80000e5a:	6422                	ld	s0,8(sp)
    80000e5c:	0141                	addi	sp,sp,16
    80000e5e:	8082                	ret
    return 0;
    80000e60:	4501                	li	a0,0
    80000e62:	bfe5                	j	80000e5a <strncmp+0x42>
    80000e64:	4501                	li	a0,0
    80000e66:	bfd5                	j	80000e5a <strncmp+0x42>

0000000080000e68 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000e68:	1141                	addi	sp,sp,-16
    80000e6a:	e422                	sd	s0,8(sp)
    80000e6c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000e6e:	872a                	mv	a4,a0
    80000e70:	a011                	j	80000e74 <strncpy+0xc>
    80000e72:	8636                	mv	a2,a3
    80000e74:	fff6069b          	addiw	a3,a2,-1
    80000e78:	00c05963          	blez	a2,80000e8a <strncpy+0x22>
    80000e7c:	0705                	addi	a4,a4,1
    80000e7e:	0005c783          	lbu	a5,0(a1)
    80000e82:	fef70fa3          	sb	a5,-1(a4)
    80000e86:	0585                	addi	a1,a1,1
    80000e88:	f7ed                	bnez	a5,80000e72 <strncpy+0xa>
    ;
  while(n-- > 0)
    80000e8a:	00d05c63          	blez	a3,80000ea2 <strncpy+0x3a>
    80000e8e:	86ba                	mv	a3,a4
    *s++ = 0;
    80000e90:	0685                	addi	a3,a3,1
    80000e92:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000e96:	fff6c793          	not	a5,a3
    80000e9a:	9fb9                	addw	a5,a5,a4
    80000e9c:	9fb1                	addw	a5,a5,a2
    80000e9e:	fef049e3          	bgtz	a5,80000e90 <strncpy+0x28>
  return os;
}
    80000ea2:	6422                	ld	s0,8(sp)
    80000ea4:	0141                	addi	sp,sp,16
    80000ea6:	8082                	ret

0000000080000ea8 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000ea8:	1141                	addi	sp,sp,-16
    80000eaa:	e422                	sd	s0,8(sp)
    80000eac:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000eae:	02c05363          	blez	a2,80000ed4 <safestrcpy+0x2c>
    80000eb2:	fff6069b          	addiw	a3,a2,-1
    80000eb6:	1682                	slli	a3,a3,0x20
    80000eb8:	9281                	srli	a3,a3,0x20
    80000eba:	96ae                	add	a3,a3,a1
    80000ebc:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000ebe:	00d58963          	beq	a1,a3,80000ed0 <safestrcpy+0x28>
    80000ec2:	0585                	addi	a1,a1,1
    80000ec4:	0785                	addi	a5,a5,1
    80000ec6:	fff5c703          	lbu	a4,-1(a1)
    80000eca:	fee78fa3          	sb	a4,-1(a5)
    80000ece:	fb65                	bnez	a4,80000ebe <safestrcpy+0x16>
    ;
  *s = 0;
    80000ed0:	00078023          	sb	zero,0(a5)
  return os;
}
    80000ed4:	6422                	ld	s0,8(sp)
    80000ed6:	0141                	addi	sp,sp,16
    80000ed8:	8082                	ret

0000000080000eda <strlen>:

int
strlen(const char *s)
{
    80000eda:	1141                	addi	sp,sp,-16
    80000edc:	e422                	sd	s0,8(sp)
    80000ede:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000ee0:	00054783          	lbu	a5,0(a0)
    80000ee4:	cf91                	beqz	a5,80000f00 <strlen+0x26>
    80000ee6:	0505                	addi	a0,a0,1
    80000ee8:	87aa                	mv	a5,a0
    80000eea:	4685                	li	a3,1
    80000eec:	9e89                	subw	a3,a3,a0
    80000eee:	00f6853b          	addw	a0,a3,a5
    80000ef2:	0785                	addi	a5,a5,1
    80000ef4:	fff7c703          	lbu	a4,-1(a5)
    80000ef8:	fb7d                	bnez	a4,80000eee <strlen+0x14>
    ;
  return n;
}
    80000efa:	6422                	ld	s0,8(sp)
    80000efc:	0141                	addi	sp,sp,16
    80000efe:	8082                	ret
  for(n = 0; s[n]; n++)
    80000f00:	4501                	li	a0,0
    80000f02:	bfe5                	j	80000efa <strlen+0x20>

0000000080000f04 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000f04:	1141                	addi	sp,sp,-16
    80000f06:	e406                	sd	ra,8(sp)
    80000f08:	e022                	sd	s0,0(sp)
    80000f0a:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000f0c:	00001097          	auipc	ra,0x1
    80000f10:	b02080e7          	jalr	-1278(ra) # 80001a0e <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000f14:	00008717          	auipc	a4,0x8
    80000f18:	9f470713          	addi	a4,a4,-1548 # 80008908 <started>
  if(cpuid() == 0){
    80000f1c:	c139                	beqz	a0,80000f62 <main+0x5e>
    while(started == 0)
    80000f1e:	431c                	lw	a5,0(a4)
    80000f20:	2781                	sext.w	a5,a5
    80000f22:	dff5                	beqz	a5,80000f1e <main+0x1a>
      ;
    __sync_synchronize();
    80000f24:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000f28:	00001097          	auipc	ra,0x1
    80000f2c:	ae6080e7          	jalr	-1306(ra) # 80001a0e <cpuid>
    80000f30:	85aa                	mv	a1,a0
    80000f32:	00007517          	auipc	a0,0x7
    80000f36:	18650513          	addi	a0,a0,390 # 800080b8 <digits+0xa0>
    80000f3a:	fffff097          	auipc	ra,0xfffff
    80000f3e:	67c080e7          	jalr	1660(ra) # 800005b6 <printf>
    kvminithart();    // turn on paging
    80000f42:	00000097          	auipc	ra,0x0
    80000f46:	0d8080e7          	jalr	216(ra) # 8000101a <kvminithart>
    trapinithart();   // install kernel trap vector
    80000f4a:	00001097          	auipc	ra,0x1
    80000f4e:	790080e7          	jalr	1936(ra) # 800026da <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000f52:	00005097          	auipc	ra,0x5
    80000f56:	ebe080e7          	jalr	-322(ra) # 80005e10 <plicinithart>
  }

  scheduler();        
    80000f5a:	00001097          	auipc	ra,0x1
    80000f5e:	fd4080e7          	jalr	-44(ra) # 80001f2e <scheduler>
    consoleinit();
    80000f62:	fffff097          	auipc	ra,0xfffff
    80000f66:	518080e7          	jalr	1304(ra) # 8000047a <consoleinit>
    printfinit();
    80000f6a:	00000097          	auipc	ra,0x0
    80000f6e:	832080e7          	jalr	-1998(ra) # 8000079c <printfinit>
    printf("\n");
    80000f72:	00007517          	auipc	a0,0x7
    80000f76:	15650513          	addi	a0,a0,342 # 800080c8 <digits+0xb0>
    80000f7a:	fffff097          	auipc	ra,0xfffff
    80000f7e:	63c080e7          	jalr	1596(ra) # 800005b6 <printf>
    printf("xv6 kernel is booting\n");
    80000f82:	00007517          	auipc	a0,0x7
    80000f86:	11e50513          	addi	a0,a0,286 # 800080a0 <digits+0x88>
    80000f8a:	fffff097          	auipc	ra,0xfffff
    80000f8e:	62c080e7          	jalr	1580(ra) # 800005b6 <printf>
    printf("\n");
    80000f92:	00007517          	auipc	a0,0x7
    80000f96:	13650513          	addi	a0,a0,310 # 800080c8 <digits+0xb0>
    80000f9a:	fffff097          	auipc	ra,0xfffff
    80000f9e:	61c080e7          	jalr	1564(ra) # 800005b6 <printf>
    kinit();         // physical page allocator
    80000fa2:	00000097          	auipc	ra,0x0
    80000fa6:	b6a080e7          	jalr	-1174(ra) # 80000b0c <kinit>
    kvminit();       // create kernel page table
    80000faa:	00000097          	auipc	ra,0x0
    80000fae:	326080e7          	jalr	806(ra) # 800012d0 <kvminit>
    kvminithart();   // turn on paging
    80000fb2:	00000097          	auipc	ra,0x0
    80000fb6:	068080e7          	jalr	104(ra) # 8000101a <kvminithart>
    procinit();      // process table
    80000fba:	00001097          	auipc	ra,0x1
    80000fbe:	9a0080e7          	jalr	-1632(ra) # 8000195a <procinit>
    trapinit();      // trap vectors
    80000fc2:	00001097          	auipc	ra,0x1
    80000fc6:	6f0080e7          	jalr	1776(ra) # 800026b2 <trapinit>
    trapinithart();  // install kernel trap vector
    80000fca:	00001097          	auipc	ra,0x1
    80000fce:	710080e7          	jalr	1808(ra) # 800026da <trapinithart>
    plicinit();      // set up interrupt controller
    80000fd2:	00005097          	auipc	ra,0x5
    80000fd6:	e28080e7          	jalr	-472(ra) # 80005dfa <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000fda:	00005097          	auipc	ra,0x5
    80000fde:	e36080e7          	jalr	-458(ra) # 80005e10 <plicinithart>
    binit();         // buffer cache
    80000fe2:	00002097          	auipc	ra,0x2
    80000fe6:	f1e080e7          	jalr	-226(ra) # 80002f00 <binit>
    iinit();         // inode table
    80000fea:	00002097          	auipc	ra,0x2
    80000fee:	602080e7          	jalr	1538(ra) # 800035ec <iinit>
    fileinit();      // file table
    80000ff2:	00003097          	auipc	ra,0x3
    80000ff6:	5cc080e7          	jalr	1484(ra) # 800045be <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000ffa:	00005097          	auipc	ra,0x5
    80000ffe:	f1e080e7          	jalr	-226(ra) # 80005f18 <virtio_disk_init>
    userinit();      // first user process
    80001002:	00001097          	auipc	ra,0x1
    80001006:	d12080e7          	jalr	-750(ra) # 80001d14 <userinit>
    __sync_synchronize();
    8000100a:	0ff0000f          	fence
    started = 1;
    8000100e:	4785                	li	a5,1
    80001010:	00008717          	auipc	a4,0x8
    80001014:	8ef72c23          	sw	a5,-1800(a4) # 80008908 <started>
    80001018:	b789                	j	80000f5a <main+0x56>

000000008000101a <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000101a:	1141                	addi	sp,sp,-16
    8000101c:	e422                	sd	s0,8(sp)
    8000101e:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80001020:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80001024:	00008797          	auipc	a5,0x8
    80001028:	8ec78793          	addi	a5,a5,-1812 # 80008910 <kernel_pagetable>
    8000102c:	639c                	ld	a5,0(a5)
    8000102e:	83b1                	srli	a5,a5,0xc
    80001030:	577d                	li	a4,-1
    80001032:	177e                	slli	a4,a4,0x3f
    80001034:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80001036:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    8000103a:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    8000103e:	6422                	ld	s0,8(sp)
    80001040:	0141                	addi	sp,sp,16
    80001042:	8082                	ret

0000000080001044 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80001044:	7139                	addi	sp,sp,-64
    80001046:	fc06                	sd	ra,56(sp)
    80001048:	f822                	sd	s0,48(sp)
    8000104a:	f426                	sd	s1,40(sp)
    8000104c:	f04a                	sd	s2,32(sp)
    8000104e:	ec4e                	sd	s3,24(sp)
    80001050:	e852                	sd	s4,16(sp)
    80001052:	e456                	sd	s5,8(sp)
    80001054:	e05a                	sd	s6,0(sp)
    80001056:	0080                	addi	s0,sp,64
    80001058:	84aa                	mv	s1,a0
    8000105a:	89ae                	mv	s3,a1
    8000105c:	8b32                	mv	s6,a2
  if(va >= MAXVA)
    8000105e:	57fd                	li	a5,-1
    80001060:	83e9                	srli	a5,a5,0x1a
    80001062:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80001064:	4ab1                	li	s5,12
  if(va >= MAXVA)
    80001066:	04b7f263          	bgeu	a5,a1,800010aa <walk+0x66>
    panic("walk");
    8000106a:	00007517          	auipc	a0,0x7
    8000106e:	06650513          	addi	a0,a0,102 # 800080d0 <digits+0xb8>
    80001072:	fffff097          	auipc	ra,0xfffff
    80001076:	4fa080e7          	jalr	1274(ra) # 8000056c <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000107a:	060b0663          	beqz	s6,800010e6 <walk+0xa2>
    8000107e:	00000097          	auipc	ra,0x0
    80001082:	aca080e7          	jalr	-1334(ra) # 80000b48 <kalloc>
    80001086:	84aa                	mv	s1,a0
    80001088:	c529                	beqz	a0,800010d2 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    8000108a:	6605                	lui	a2,0x1
    8000108c:	4581                	li	a1,0
    8000108e:	00000097          	auipc	ra,0x0
    80001092:	ca6080e7          	jalr	-858(ra) # 80000d34 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001096:	00c4d793          	srli	a5,s1,0xc
    8000109a:	07aa                	slli	a5,a5,0xa
    8000109c:	0017e793          	ori	a5,a5,1
    800010a0:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800010a4:	3a5d                	addiw	s4,s4,-9
    800010a6:	035a0063          	beq	s4,s5,800010c6 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800010aa:	0149d933          	srl	s2,s3,s4
    800010ae:	1ff97913          	andi	s2,s2,511
    800010b2:	090e                	slli	s2,s2,0x3
    800010b4:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800010b6:	00093483          	ld	s1,0(s2)
    800010ba:	0014f793          	andi	a5,s1,1
    800010be:	dfd5                	beqz	a5,8000107a <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800010c0:	80a9                	srli	s1,s1,0xa
    800010c2:	04b2                	slli	s1,s1,0xc
    800010c4:	b7c5                	j	800010a4 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800010c6:	00c9d513          	srli	a0,s3,0xc
    800010ca:	1ff57513          	andi	a0,a0,511
    800010ce:	050e                	slli	a0,a0,0x3
    800010d0:	9526                	add	a0,a0,s1
}
    800010d2:	70e2                	ld	ra,56(sp)
    800010d4:	7442                	ld	s0,48(sp)
    800010d6:	74a2                	ld	s1,40(sp)
    800010d8:	7902                	ld	s2,32(sp)
    800010da:	69e2                	ld	s3,24(sp)
    800010dc:	6a42                	ld	s4,16(sp)
    800010de:	6aa2                	ld	s5,8(sp)
    800010e0:	6b02                	ld	s6,0(sp)
    800010e2:	6121                	addi	sp,sp,64
    800010e4:	8082                	ret
        return 0;
    800010e6:	4501                	li	a0,0
    800010e8:	b7ed                	j	800010d2 <walk+0x8e>

00000000800010ea <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800010ea:	57fd                	li	a5,-1
    800010ec:	83e9                	srli	a5,a5,0x1a
    800010ee:	00b7f463          	bgeu	a5,a1,800010f6 <walkaddr+0xc>
    return 0;
    800010f2:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800010f4:	8082                	ret
{
    800010f6:	1141                	addi	sp,sp,-16
    800010f8:	e406                	sd	ra,8(sp)
    800010fa:	e022                	sd	s0,0(sp)
    800010fc:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800010fe:	4601                	li	a2,0
    80001100:	00000097          	auipc	ra,0x0
    80001104:	f44080e7          	jalr	-188(ra) # 80001044 <walk>
  if(pte == 0)
    80001108:	c105                	beqz	a0,80001128 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000110a:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000110c:	0117f693          	andi	a3,a5,17
    80001110:	4745                	li	a4,17
    return 0;
    80001112:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80001114:	00e68663          	beq	a3,a4,80001120 <walkaddr+0x36>
}
    80001118:	60a2                	ld	ra,8(sp)
    8000111a:	6402                	ld	s0,0(sp)
    8000111c:	0141                	addi	sp,sp,16
    8000111e:	8082                	ret
  pa = PTE2PA(*pte);
    80001120:	00a7d513          	srli	a0,a5,0xa
    80001124:	0532                	slli	a0,a0,0xc
  return pa;
    80001126:	bfcd                	j	80001118 <walkaddr+0x2e>
    return 0;
    80001128:	4501                	li	a0,0
    8000112a:	b7fd                	j	80001118 <walkaddr+0x2e>

000000008000112c <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000112c:	715d                	addi	sp,sp,-80
    8000112e:	e486                	sd	ra,72(sp)
    80001130:	e0a2                	sd	s0,64(sp)
    80001132:	fc26                	sd	s1,56(sp)
    80001134:	f84a                	sd	s2,48(sp)
    80001136:	f44e                	sd	s3,40(sp)
    80001138:	f052                	sd	s4,32(sp)
    8000113a:	ec56                	sd	s5,24(sp)
    8000113c:	e85a                	sd	s6,16(sp)
    8000113e:	e45e                	sd	s7,8(sp)
    80001140:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80001142:	ce19                	beqz	a2,80001160 <mappages+0x34>
    80001144:	8aaa                	mv	s5,a0
    80001146:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80001148:	79fd                	lui	s3,0xfffff
    8000114a:	0135f7b3          	and	a5,a1,s3
  last = PGROUNDDOWN(va + size - 1);
    8000114e:	15fd                	addi	a1,a1,-1
    80001150:	95b2                	add	a1,a1,a2
    80001152:	0135f9b3          	and	s3,a1,s3
  a = PGROUNDDOWN(va);
    80001156:	893e                	mv	s2,a5
    80001158:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000115c:	6b85                	lui	s7,0x1
    8000115e:	a015                	j	80001182 <mappages+0x56>
    panic("mappages: size");
    80001160:	00007517          	auipc	a0,0x7
    80001164:	f7850513          	addi	a0,a0,-136 # 800080d8 <digits+0xc0>
    80001168:	fffff097          	auipc	ra,0xfffff
    8000116c:	404080e7          	jalr	1028(ra) # 8000056c <panic>
      panic("mappages: remap");
    80001170:	00007517          	auipc	a0,0x7
    80001174:	f7850513          	addi	a0,a0,-136 # 800080e8 <digits+0xd0>
    80001178:	fffff097          	auipc	ra,0xfffff
    8000117c:	3f4080e7          	jalr	1012(ra) # 8000056c <panic>
    a += PGSIZE;
    80001180:	995e                	add	s2,s2,s7
  for(;;){
    80001182:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80001186:	4605                	li	a2,1
    80001188:	85ca                	mv	a1,s2
    8000118a:	8556                	mv	a0,s5
    8000118c:	00000097          	auipc	ra,0x0
    80001190:	eb8080e7          	jalr	-328(ra) # 80001044 <walk>
    80001194:	cd19                	beqz	a0,800011b2 <mappages+0x86>
    if(*pte & PTE_V)
    80001196:	611c                	ld	a5,0(a0)
    80001198:	8b85                	andi	a5,a5,1
    8000119a:	fbf9                	bnez	a5,80001170 <mappages+0x44>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000119c:	80b1                	srli	s1,s1,0xc
    8000119e:	04aa                	slli	s1,s1,0xa
    800011a0:	0164e4b3          	or	s1,s1,s6
    800011a4:	0014e493          	ori	s1,s1,1
    800011a8:	e104                	sd	s1,0(a0)
    if(a == last)
    800011aa:	fd391be3          	bne	s2,s3,80001180 <mappages+0x54>
    pa += PGSIZE;
  }
  return 0;
    800011ae:	4501                	li	a0,0
    800011b0:	a011                	j	800011b4 <mappages+0x88>
      return -1;
    800011b2:	557d                	li	a0,-1
}
    800011b4:	60a6                	ld	ra,72(sp)
    800011b6:	6406                	ld	s0,64(sp)
    800011b8:	74e2                	ld	s1,56(sp)
    800011ba:	7942                	ld	s2,48(sp)
    800011bc:	79a2                	ld	s3,40(sp)
    800011be:	7a02                	ld	s4,32(sp)
    800011c0:	6ae2                	ld	s5,24(sp)
    800011c2:	6b42                	ld	s6,16(sp)
    800011c4:	6ba2                	ld	s7,8(sp)
    800011c6:	6161                	addi	sp,sp,80
    800011c8:	8082                	ret

00000000800011ca <kvmmap>:
{
    800011ca:	1141                	addi	sp,sp,-16
    800011cc:	e406                	sd	ra,8(sp)
    800011ce:	e022                	sd	s0,0(sp)
    800011d0:	0800                	addi	s0,sp,16
    800011d2:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800011d4:	86b2                	mv	a3,a2
    800011d6:	863e                	mv	a2,a5
    800011d8:	00000097          	auipc	ra,0x0
    800011dc:	f54080e7          	jalr	-172(ra) # 8000112c <mappages>
    800011e0:	e509                	bnez	a0,800011ea <kvmmap+0x20>
}
    800011e2:	60a2                	ld	ra,8(sp)
    800011e4:	6402                	ld	s0,0(sp)
    800011e6:	0141                	addi	sp,sp,16
    800011e8:	8082                	ret
    panic("kvmmap");
    800011ea:	00007517          	auipc	a0,0x7
    800011ee:	f0e50513          	addi	a0,a0,-242 # 800080f8 <digits+0xe0>
    800011f2:	fffff097          	auipc	ra,0xfffff
    800011f6:	37a080e7          	jalr	890(ra) # 8000056c <panic>

00000000800011fa <kvmmake>:
{
    800011fa:	1101                	addi	sp,sp,-32
    800011fc:	ec06                	sd	ra,24(sp)
    800011fe:	e822                	sd	s0,16(sp)
    80001200:	e426                	sd	s1,8(sp)
    80001202:	e04a                	sd	s2,0(sp)
    80001204:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80001206:	00000097          	auipc	ra,0x0
    8000120a:	942080e7          	jalr	-1726(ra) # 80000b48 <kalloc>
    8000120e:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80001210:	6605                	lui	a2,0x1
    80001212:	4581                	li	a1,0
    80001214:	00000097          	auipc	ra,0x0
    80001218:	b20080e7          	jalr	-1248(ra) # 80000d34 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000121c:	4719                	li	a4,6
    8000121e:	6685                	lui	a3,0x1
    80001220:	10000637          	lui	a2,0x10000
    80001224:	100005b7          	lui	a1,0x10000
    80001228:	8526                	mv	a0,s1
    8000122a:	00000097          	auipc	ra,0x0
    8000122e:	fa0080e7          	jalr	-96(ra) # 800011ca <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001232:	4719                	li	a4,6
    80001234:	6685                	lui	a3,0x1
    80001236:	10001637          	lui	a2,0x10001
    8000123a:	100015b7          	lui	a1,0x10001
    8000123e:	8526                	mv	a0,s1
    80001240:	00000097          	auipc	ra,0x0
    80001244:	f8a080e7          	jalr	-118(ra) # 800011ca <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80001248:	4719                	li	a4,6
    8000124a:	004006b7          	lui	a3,0x400
    8000124e:	0c000637          	lui	a2,0xc000
    80001252:	0c0005b7          	lui	a1,0xc000
    80001256:	8526                	mv	a0,s1
    80001258:	00000097          	auipc	ra,0x0
    8000125c:	f72080e7          	jalr	-142(ra) # 800011ca <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001260:	00007917          	auipc	s2,0x7
    80001264:	da090913          	addi	s2,s2,-608 # 80008000 <etext>
    80001268:	4729                	li	a4,10
    8000126a:	80007697          	auipc	a3,0x80007
    8000126e:	d9668693          	addi	a3,a3,-618 # 8000 <_entry-0x7fff8000>
    80001272:	4605                	li	a2,1
    80001274:	067e                	slli	a2,a2,0x1f
    80001276:	85b2                	mv	a1,a2
    80001278:	8526                	mv	a0,s1
    8000127a:	00000097          	auipc	ra,0x0
    8000127e:	f50080e7          	jalr	-176(ra) # 800011ca <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001282:	4719                	li	a4,6
    80001284:	46c5                	li	a3,17
    80001286:	06ee                	slli	a3,a3,0x1b
    80001288:	412686b3          	sub	a3,a3,s2
    8000128c:	864a                	mv	a2,s2
    8000128e:	85ca                	mv	a1,s2
    80001290:	8526                	mv	a0,s1
    80001292:	00000097          	auipc	ra,0x0
    80001296:	f38080e7          	jalr	-200(ra) # 800011ca <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000129a:	4729                	li	a4,10
    8000129c:	6685                	lui	a3,0x1
    8000129e:	00006617          	auipc	a2,0x6
    800012a2:	d6260613          	addi	a2,a2,-670 # 80007000 <_trampoline>
    800012a6:	040005b7          	lui	a1,0x4000
    800012aa:	15fd                	addi	a1,a1,-1
    800012ac:	05b2                	slli	a1,a1,0xc
    800012ae:	8526                	mv	a0,s1
    800012b0:	00000097          	auipc	ra,0x0
    800012b4:	f1a080e7          	jalr	-230(ra) # 800011ca <kvmmap>
  proc_mapstacks(kpgtbl);
    800012b8:	8526                	mv	a0,s1
    800012ba:	00000097          	auipc	ra,0x0
    800012be:	60a080e7          	jalr	1546(ra) # 800018c4 <proc_mapstacks>
}
    800012c2:	8526                	mv	a0,s1
    800012c4:	60e2                	ld	ra,24(sp)
    800012c6:	6442                	ld	s0,16(sp)
    800012c8:	64a2                	ld	s1,8(sp)
    800012ca:	6902                	ld	s2,0(sp)
    800012cc:	6105                	addi	sp,sp,32
    800012ce:	8082                	ret

00000000800012d0 <kvminit>:
{
    800012d0:	1141                	addi	sp,sp,-16
    800012d2:	e406                	sd	ra,8(sp)
    800012d4:	e022                	sd	s0,0(sp)
    800012d6:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800012d8:	00000097          	auipc	ra,0x0
    800012dc:	f22080e7          	jalr	-222(ra) # 800011fa <kvmmake>
    800012e0:	00007797          	auipc	a5,0x7
    800012e4:	62a7b823          	sd	a0,1584(a5) # 80008910 <kernel_pagetable>
}
    800012e8:	60a2                	ld	ra,8(sp)
    800012ea:	6402                	ld	s0,0(sp)
    800012ec:	0141                	addi	sp,sp,16
    800012ee:	8082                	ret

00000000800012f0 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800012f0:	715d                	addi	sp,sp,-80
    800012f2:	e486                	sd	ra,72(sp)
    800012f4:	e0a2                	sd	s0,64(sp)
    800012f6:	fc26                	sd	s1,56(sp)
    800012f8:	f84a                	sd	s2,48(sp)
    800012fa:	f44e                	sd	s3,40(sp)
    800012fc:	f052                	sd	s4,32(sp)
    800012fe:	ec56                	sd	s5,24(sp)
    80001300:	e85a                	sd	s6,16(sp)
    80001302:	e45e                	sd	s7,8(sp)
    80001304:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001306:	6785                	lui	a5,0x1
    80001308:	17fd                	addi	a5,a5,-1
    8000130a:	8fed                	and	a5,a5,a1
    8000130c:	e795                	bnez	a5,80001338 <uvmunmap+0x48>
    8000130e:	8a2a                	mv	s4,a0
    80001310:	84ae                	mv	s1,a1
    80001312:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001314:	0632                	slli	a2,a2,0xc
    80001316:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000131a:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000131c:	6b05                	lui	s6,0x1
    8000131e:	0735e863          	bltu	a1,s3,8000138e <uvmunmap+0x9e>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80001322:	60a6                	ld	ra,72(sp)
    80001324:	6406                	ld	s0,64(sp)
    80001326:	74e2                	ld	s1,56(sp)
    80001328:	7942                	ld	s2,48(sp)
    8000132a:	79a2                	ld	s3,40(sp)
    8000132c:	7a02                	ld	s4,32(sp)
    8000132e:	6ae2                	ld	s5,24(sp)
    80001330:	6b42                	ld	s6,16(sp)
    80001332:	6ba2                	ld	s7,8(sp)
    80001334:	6161                	addi	sp,sp,80
    80001336:	8082                	ret
    panic("uvmunmap: not aligned");
    80001338:	00007517          	auipc	a0,0x7
    8000133c:	dc850513          	addi	a0,a0,-568 # 80008100 <digits+0xe8>
    80001340:	fffff097          	auipc	ra,0xfffff
    80001344:	22c080e7          	jalr	556(ra) # 8000056c <panic>
      panic("uvmunmap: walk");
    80001348:	00007517          	auipc	a0,0x7
    8000134c:	dd050513          	addi	a0,a0,-560 # 80008118 <digits+0x100>
    80001350:	fffff097          	auipc	ra,0xfffff
    80001354:	21c080e7          	jalr	540(ra) # 8000056c <panic>
      panic("uvmunmap: not mapped");
    80001358:	00007517          	auipc	a0,0x7
    8000135c:	dd050513          	addi	a0,a0,-560 # 80008128 <digits+0x110>
    80001360:	fffff097          	auipc	ra,0xfffff
    80001364:	20c080e7          	jalr	524(ra) # 8000056c <panic>
      panic("uvmunmap: not a leaf");
    80001368:	00007517          	auipc	a0,0x7
    8000136c:	dd850513          	addi	a0,a0,-552 # 80008140 <digits+0x128>
    80001370:	fffff097          	auipc	ra,0xfffff
    80001374:	1fc080e7          	jalr	508(ra) # 8000056c <panic>
      uint64 pa = PTE2PA(*pte);
    80001378:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    8000137a:	0532                	slli	a0,a0,0xc
    8000137c:	fffff097          	auipc	ra,0xfffff
    80001380:	6cc080e7          	jalr	1740(ra) # 80000a48 <kfree>
    *pte = 0;
    80001384:	00093023          	sd	zero,0(s2)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001388:	94da                	add	s1,s1,s6
    8000138a:	f934fce3          	bgeu	s1,s3,80001322 <uvmunmap+0x32>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000138e:	4601                	li	a2,0
    80001390:	85a6                	mv	a1,s1
    80001392:	8552                	mv	a0,s4
    80001394:	00000097          	auipc	ra,0x0
    80001398:	cb0080e7          	jalr	-848(ra) # 80001044 <walk>
    8000139c:	892a                	mv	s2,a0
    8000139e:	d54d                	beqz	a0,80001348 <uvmunmap+0x58>
    if((*pte & PTE_V) == 0)
    800013a0:	6108                	ld	a0,0(a0)
    800013a2:	00157793          	andi	a5,a0,1
    800013a6:	dbcd                	beqz	a5,80001358 <uvmunmap+0x68>
    if(PTE_FLAGS(*pte) == PTE_V)
    800013a8:	3ff57793          	andi	a5,a0,1023
    800013ac:	fb778ee3          	beq	a5,s7,80001368 <uvmunmap+0x78>
    if(do_free){
    800013b0:	fc0a8ae3          	beqz	s5,80001384 <uvmunmap+0x94>
    800013b4:	b7d1                	j	80001378 <uvmunmap+0x88>

00000000800013b6 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800013b6:	1101                	addi	sp,sp,-32
    800013b8:	ec06                	sd	ra,24(sp)
    800013ba:	e822                	sd	s0,16(sp)
    800013bc:	e426                	sd	s1,8(sp)
    800013be:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800013c0:	fffff097          	auipc	ra,0xfffff
    800013c4:	788080e7          	jalr	1928(ra) # 80000b48 <kalloc>
    800013c8:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800013ca:	c519                	beqz	a0,800013d8 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800013cc:	6605                	lui	a2,0x1
    800013ce:	4581                	li	a1,0
    800013d0:	00000097          	auipc	ra,0x0
    800013d4:	964080e7          	jalr	-1692(ra) # 80000d34 <memset>
  return pagetable;
}
    800013d8:	8526                	mv	a0,s1
    800013da:	60e2                	ld	ra,24(sp)
    800013dc:	6442                	ld	s0,16(sp)
    800013de:	64a2                	ld	s1,8(sp)
    800013e0:	6105                	addi	sp,sp,32
    800013e2:	8082                	ret

00000000800013e4 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800013e4:	7179                	addi	sp,sp,-48
    800013e6:	f406                	sd	ra,40(sp)
    800013e8:	f022                	sd	s0,32(sp)
    800013ea:	ec26                	sd	s1,24(sp)
    800013ec:	e84a                	sd	s2,16(sp)
    800013ee:	e44e                	sd	s3,8(sp)
    800013f0:	e052                	sd	s4,0(sp)
    800013f2:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800013f4:	6785                	lui	a5,0x1
    800013f6:	04f67863          	bgeu	a2,a5,80001446 <uvmfirst+0x62>
    800013fa:	8a2a                	mv	s4,a0
    800013fc:	89ae                	mv	s3,a1
    800013fe:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80001400:	fffff097          	auipc	ra,0xfffff
    80001404:	748080e7          	jalr	1864(ra) # 80000b48 <kalloc>
    80001408:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000140a:	6605                	lui	a2,0x1
    8000140c:	4581                	li	a1,0
    8000140e:	00000097          	auipc	ra,0x0
    80001412:	926080e7          	jalr	-1754(ra) # 80000d34 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001416:	4779                	li	a4,30
    80001418:	86ca                	mv	a3,s2
    8000141a:	6605                	lui	a2,0x1
    8000141c:	4581                	li	a1,0
    8000141e:	8552                	mv	a0,s4
    80001420:	00000097          	auipc	ra,0x0
    80001424:	d0c080e7          	jalr	-756(ra) # 8000112c <mappages>
  memmove(mem, src, sz);
    80001428:	8626                	mv	a2,s1
    8000142a:	85ce                	mv	a1,s3
    8000142c:	854a                	mv	a0,s2
    8000142e:	00000097          	auipc	ra,0x0
    80001432:	972080e7          	jalr	-1678(ra) # 80000da0 <memmove>
}
    80001436:	70a2                	ld	ra,40(sp)
    80001438:	7402                	ld	s0,32(sp)
    8000143a:	64e2                	ld	s1,24(sp)
    8000143c:	6942                	ld	s2,16(sp)
    8000143e:	69a2                	ld	s3,8(sp)
    80001440:	6a02                	ld	s4,0(sp)
    80001442:	6145                	addi	sp,sp,48
    80001444:	8082                	ret
    panic("uvmfirst: more than a page");
    80001446:	00007517          	auipc	a0,0x7
    8000144a:	d1250513          	addi	a0,a0,-750 # 80008158 <digits+0x140>
    8000144e:	fffff097          	auipc	ra,0xfffff
    80001452:	11e080e7          	jalr	286(ra) # 8000056c <panic>

0000000080001456 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001456:	1101                	addi	sp,sp,-32
    80001458:	ec06                	sd	ra,24(sp)
    8000145a:	e822                	sd	s0,16(sp)
    8000145c:	e426                	sd	s1,8(sp)
    8000145e:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80001460:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80001462:	00b67d63          	bgeu	a2,a1,8000147c <uvmdealloc+0x26>
    80001466:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80001468:	6605                	lui	a2,0x1
    8000146a:	167d                	addi	a2,a2,-1
    8000146c:	00c487b3          	add	a5,s1,a2
    80001470:	777d                	lui	a4,0xfffff
    80001472:	8ff9                	and	a5,a5,a4
    80001474:	962e                	add	a2,a2,a1
    80001476:	8e79                	and	a2,a2,a4
    80001478:	00c7e863          	bltu	a5,a2,80001488 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000147c:	8526                	mv	a0,s1
    8000147e:	60e2                	ld	ra,24(sp)
    80001480:	6442                	ld	s0,16(sp)
    80001482:	64a2                	ld	s1,8(sp)
    80001484:	6105                	addi	sp,sp,32
    80001486:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001488:	8e1d                	sub	a2,a2,a5
    8000148a:	8231                	srli	a2,a2,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    8000148c:	4685                	li	a3,1
    8000148e:	2601                	sext.w	a2,a2
    80001490:	85be                	mv	a1,a5
    80001492:	00000097          	auipc	ra,0x0
    80001496:	e5e080e7          	jalr	-418(ra) # 800012f0 <uvmunmap>
    8000149a:	b7cd                	j	8000147c <uvmdealloc+0x26>

000000008000149c <uvmalloc>:
  if(newsz < oldsz)
    8000149c:	0ab66563          	bltu	a2,a1,80001546 <uvmalloc+0xaa>
{
    800014a0:	7139                	addi	sp,sp,-64
    800014a2:	fc06                	sd	ra,56(sp)
    800014a4:	f822                	sd	s0,48(sp)
    800014a6:	f426                	sd	s1,40(sp)
    800014a8:	f04a                	sd	s2,32(sp)
    800014aa:	ec4e                	sd	s3,24(sp)
    800014ac:	e852                	sd	s4,16(sp)
    800014ae:	e456                	sd	s5,8(sp)
    800014b0:	e05a                	sd	s6,0(sp)
    800014b2:	0080                	addi	s0,sp,64
  oldsz = PGROUNDUP(oldsz);
    800014b4:	6a85                	lui	s5,0x1
    800014b6:	1afd                	addi	s5,s5,-1
    800014b8:	95d6                	add	a1,a1,s5
    800014ba:	7afd                	lui	s5,0xfffff
    800014bc:	0155fab3          	and	s5,a1,s5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800014c0:	08caf563          	bgeu	s5,a2,8000154a <uvmalloc+0xae>
    800014c4:	89b2                	mv	s3,a2
    800014c6:	8b2a                	mv	s6,a0
    800014c8:	8956                	mv	s2,s5
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800014ca:	0126ea13          	ori	s4,a3,18
    mem = kalloc();
    800014ce:	fffff097          	auipc	ra,0xfffff
    800014d2:	67a080e7          	jalr	1658(ra) # 80000b48 <kalloc>
    800014d6:	84aa                	mv	s1,a0
    if(mem == 0){
    800014d8:	c51d                	beqz	a0,80001506 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    800014da:	6605                	lui	a2,0x1
    800014dc:	4581                	li	a1,0
    800014de:	00000097          	auipc	ra,0x0
    800014e2:	856080e7          	jalr	-1962(ra) # 80000d34 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800014e6:	8752                	mv	a4,s4
    800014e8:	86a6                	mv	a3,s1
    800014ea:	6605                	lui	a2,0x1
    800014ec:	85ca                	mv	a1,s2
    800014ee:	855a                	mv	a0,s6
    800014f0:	00000097          	auipc	ra,0x0
    800014f4:	c3c080e7          	jalr	-964(ra) # 8000112c <mappages>
    800014f8:	e90d                	bnez	a0,8000152a <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800014fa:	6785                	lui	a5,0x1
    800014fc:	993e                	add	s2,s2,a5
    800014fe:	fd3968e3          	bltu	s2,s3,800014ce <uvmalloc+0x32>
  return newsz;
    80001502:	854e                	mv	a0,s3
    80001504:	a809                	j	80001516 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80001506:	8656                	mv	a2,s5
    80001508:	85ca                	mv	a1,s2
    8000150a:	855a                	mv	a0,s6
    8000150c:	00000097          	auipc	ra,0x0
    80001510:	f4a080e7          	jalr	-182(ra) # 80001456 <uvmdealloc>
      return 0;
    80001514:	4501                	li	a0,0
}
    80001516:	70e2                	ld	ra,56(sp)
    80001518:	7442                	ld	s0,48(sp)
    8000151a:	74a2                	ld	s1,40(sp)
    8000151c:	7902                	ld	s2,32(sp)
    8000151e:	69e2                	ld	s3,24(sp)
    80001520:	6a42                	ld	s4,16(sp)
    80001522:	6aa2                	ld	s5,8(sp)
    80001524:	6b02                	ld	s6,0(sp)
    80001526:	6121                	addi	sp,sp,64
    80001528:	8082                	ret
      kfree(mem);
    8000152a:	8526                	mv	a0,s1
    8000152c:	fffff097          	auipc	ra,0xfffff
    80001530:	51c080e7          	jalr	1308(ra) # 80000a48 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001534:	8656                	mv	a2,s5
    80001536:	85ca                	mv	a1,s2
    80001538:	855a                	mv	a0,s6
    8000153a:	00000097          	auipc	ra,0x0
    8000153e:	f1c080e7          	jalr	-228(ra) # 80001456 <uvmdealloc>
      return 0;
    80001542:	4501                	li	a0,0
    80001544:	bfc9                	j	80001516 <uvmalloc+0x7a>
    return oldsz;
    80001546:	852e                	mv	a0,a1
}
    80001548:	8082                	ret
  return newsz;
    8000154a:	8532                	mv	a0,a2
    8000154c:	b7e9                	j	80001516 <uvmalloc+0x7a>

000000008000154e <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000154e:	7179                	addi	sp,sp,-48
    80001550:	f406                	sd	ra,40(sp)
    80001552:	f022                	sd	s0,32(sp)
    80001554:	ec26                	sd	s1,24(sp)
    80001556:	e84a                	sd	s2,16(sp)
    80001558:	e44e                	sd	s3,8(sp)
    8000155a:	e052                	sd	s4,0(sp)
    8000155c:	1800                	addi	s0,sp,48
    8000155e:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80001560:	84aa                	mv	s1,a0
    80001562:	6905                	lui	s2,0x1
    80001564:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001566:	4985                	li	s3,1
    80001568:	a821                	j	80001580 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000156a:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    8000156c:	0532                	slli	a0,a0,0xc
    8000156e:	00000097          	auipc	ra,0x0
    80001572:	fe0080e7          	jalr	-32(ra) # 8000154e <freewalk>
      pagetable[i] = 0;
    80001576:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000157a:	04a1                	addi	s1,s1,8
    8000157c:	03248163          	beq	s1,s2,8000159e <freewalk+0x50>
    pte_t pte = pagetable[i];
    80001580:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001582:	00f57793          	andi	a5,a0,15
    80001586:	ff3782e3          	beq	a5,s3,8000156a <freewalk+0x1c>
    } else if(pte & PTE_V){
    8000158a:	8905                	andi	a0,a0,1
    8000158c:	d57d                	beqz	a0,8000157a <freewalk+0x2c>
      panic("freewalk: leaf");
    8000158e:	00007517          	auipc	a0,0x7
    80001592:	bea50513          	addi	a0,a0,-1046 # 80008178 <digits+0x160>
    80001596:	fffff097          	auipc	ra,0xfffff
    8000159a:	fd6080e7          	jalr	-42(ra) # 8000056c <panic>
    }
  }
  kfree((void*)pagetable);
    8000159e:	8552                	mv	a0,s4
    800015a0:	fffff097          	auipc	ra,0xfffff
    800015a4:	4a8080e7          	jalr	1192(ra) # 80000a48 <kfree>
}
    800015a8:	70a2                	ld	ra,40(sp)
    800015aa:	7402                	ld	s0,32(sp)
    800015ac:	64e2                	ld	s1,24(sp)
    800015ae:	6942                	ld	s2,16(sp)
    800015b0:	69a2                	ld	s3,8(sp)
    800015b2:	6a02                	ld	s4,0(sp)
    800015b4:	6145                	addi	sp,sp,48
    800015b6:	8082                	ret

00000000800015b8 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800015b8:	1101                	addi	sp,sp,-32
    800015ba:	ec06                	sd	ra,24(sp)
    800015bc:	e822                	sd	s0,16(sp)
    800015be:	e426                	sd	s1,8(sp)
    800015c0:	1000                	addi	s0,sp,32
    800015c2:	84aa                	mv	s1,a0
  if(sz > 0)
    800015c4:	e999                	bnez	a1,800015da <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800015c6:	8526                	mv	a0,s1
    800015c8:	00000097          	auipc	ra,0x0
    800015cc:	f86080e7          	jalr	-122(ra) # 8000154e <freewalk>
}
    800015d0:	60e2                	ld	ra,24(sp)
    800015d2:	6442                	ld	s0,16(sp)
    800015d4:	64a2                	ld	s1,8(sp)
    800015d6:	6105                	addi	sp,sp,32
    800015d8:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800015da:	6605                	lui	a2,0x1
    800015dc:	167d                	addi	a2,a2,-1
    800015de:	962e                	add	a2,a2,a1
    800015e0:	4685                	li	a3,1
    800015e2:	8231                	srli	a2,a2,0xc
    800015e4:	4581                	li	a1,0
    800015e6:	00000097          	auipc	ra,0x0
    800015ea:	d0a080e7          	jalr	-758(ra) # 800012f0 <uvmunmap>
    800015ee:	bfe1                	j	800015c6 <uvmfree+0xe>

00000000800015f0 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  //char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800015f0:	ce4d                	beqz	a2,800016aa <uvmcopy+0xba>
{
    800015f2:	7139                	addi	sp,sp,-64
    800015f4:	fc06                	sd	ra,56(sp)
    800015f6:	f822                	sd	s0,48(sp)
    800015f8:	f426                	sd	s1,40(sp)
    800015fa:	f04a                	sd	s2,32(sp)
    800015fc:	ec4e                	sd	s3,24(sp)
    800015fe:	e852                	sd	s4,16(sp)
    80001600:	e456                	sd	s5,8(sp)
    80001602:	e05a                	sd	s6,0(sp)
    80001604:	0080                	addi	s0,sp,64
    80001606:	8ab2                	mv	s5,a2
    80001608:	8b2e                	mv	s6,a1
    8000160a:	892a                	mv	s2,a0
  for(i = 0; i < sz; i += PGSIZE){
    8000160c:	4481                	li	s1,0
    if((pte = walk(old, i, 0)) == 0)
    8000160e:	4601                	li	a2,0
    80001610:	85a6                	mv	a1,s1
    80001612:	854a                	mv	a0,s2
    80001614:	00000097          	auipc	ra,0x0
    80001618:	a30080e7          	jalr	-1488(ra) # 80001044 <walk>
    8000161c:	c53d                	beqz	a0,8000168a <uvmcopy+0x9a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    8000161e:	00053983          	ld	s3,0(a0)
    80001622:	0019f793          	andi	a5,s3,1
    80001626:	cbb5                	beqz	a5,8000169a <uvmcopy+0xaa>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80001628:	00a9da13          	srli	s4,s3,0xa
    8000162c:	0a32                	slli	s4,s4,0xc
    flags = PTE_FLAGS(*pte);
    
    flags |= PTE_R; //PTE_RSW --> KEEP track of the pg that is cow mapping
    flags &= (~PTE_W); //--> CLEAR THIS IN PARAMETER IN PTES OF BOTH CHILD AND PARENT
    8000162e:	3fb9f993          	andi	s3,s3,1019
    
    if(mappages(new,i,PGSIZE,(uint64)pa,flags) !=0){
    80001632:	0029e993          	ori	s3,s3,2
    80001636:	874e                	mv	a4,s3
    80001638:	86d2                	mv	a3,s4
    8000163a:	6605                	lui	a2,0x1
    8000163c:	85a6                	mv	a1,s1
    8000163e:	855a                	mv	a0,s6
    80001640:	00000097          	auipc	ra,0x0
    80001644:	aec080e7          	jalr	-1300(ra) # 8000112c <mappages>
    	goto err; // free the mem
    }
    
    //add_ref((void*)pa);// bump reference count*
   err:
    uvmunmap(old,i,PGSIZE,0);//remove the mapping of parent pg table
    80001648:	4681                	li	a3,0
    8000164a:	6605                	lui	a2,0x1
    8000164c:	85a6                	mv	a1,s1
    8000164e:	854a                	mv	a0,s2
    80001650:	00000097          	auipc	ra,0x0
    80001654:	ca0080e7          	jalr	-864(ra) # 800012f0 <uvmunmap>
    
    if(mappages(old,i,PGSIZE,pa,flags) != 0){//readd mapping with write bit cleared flags
    80001658:	874e                	mv	a4,s3
    8000165a:	86d2                	mv	a3,s4
    8000165c:	6605                	lui	a2,0x1
    8000165e:	85a6                	mv	a1,s1
    80001660:	854a                	mv	a0,s2
    80001662:	00000097          	auipc	ra,0x0
    80001666:	aca080e7          	jalr	-1334(ra) # 8000112c <mappages>
    8000166a:	fd79                	bnez	a0,80001648 <uvmcopy+0x58>
  for(i = 0; i < sz; i += PGSIZE){
    8000166c:	6785                	lui	a5,0x1
    8000166e:	94be                	add	s1,s1,a5
    80001670:	f954efe3          	bltu	s1,s5,8000160e <uvmcopy+0x1e>
    	//kfree(mem);
    	goto err; // free mem
    }
   }
   return -1;
}
    80001674:	557d                	li	a0,-1
    80001676:	70e2                	ld	ra,56(sp)
    80001678:	7442                	ld	s0,48(sp)
    8000167a:	74a2                	ld	s1,40(sp)
    8000167c:	7902                	ld	s2,32(sp)
    8000167e:	69e2                	ld	s3,24(sp)
    80001680:	6a42                	ld	s4,16(sp)
    80001682:	6aa2                	ld	s5,8(sp)
    80001684:	6b02                	ld	s6,0(sp)
    80001686:	6121                	addi	sp,sp,64
    80001688:	8082                	ret
      panic("uvmcopy: pte should exist");
    8000168a:	00007517          	auipc	a0,0x7
    8000168e:	afe50513          	addi	a0,a0,-1282 # 80008188 <digits+0x170>
    80001692:	fffff097          	auipc	ra,0xfffff
    80001696:	eda080e7          	jalr	-294(ra) # 8000056c <panic>
      panic("uvmcopy: page not present");
    8000169a:	00007517          	auipc	a0,0x7
    8000169e:	b0e50513          	addi	a0,a0,-1266 # 800081a8 <digits+0x190>
    800016a2:	fffff097          	auipc	ra,0xfffff
    800016a6:	eca080e7          	jalr	-310(ra) # 8000056c <panic>
}
    800016aa:	557d                	li	a0,-1
    800016ac:	8082                	ret

00000000800016ae <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800016ae:	1141                	addi	sp,sp,-16
    800016b0:	e406                	sd	ra,8(sp)
    800016b2:	e022                	sd	s0,0(sp)
    800016b4:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800016b6:	4601                	li	a2,0
    800016b8:	00000097          	auipc	ra,0x0
    800016bc:	98c080e7          	jalr	-1652(ra) # 80001044 <walk>
  if(pte == 0)
    800016c0:	c901                	beqz	a0,800016d0 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800016c2:	611c                	ld	a5,0(a0)
    800016c4:	9bbd                	andi	a5,a5,-17
    800016c6:	e11c                	sd	a5,0(a0)
}
    800016c8:	60a2                	ld	ra,8(sp)
    800016ca:	6402                	ld	s0,0(sp)
    800016cc:	0141                	addi	sp,sp,16
    800016ce:	8082                	ret
    panic("uvmclear");
    800016d0:	00007517          	auipc	a0,0x7
    800016d4:	af850513          	addi	a0,a0,-1288 # 800081c8 <digits+0x1b0>
    800016d8:	fffff097          	auipc	ra,0xfffff
    800016dc:	e94080e7          	jalr	-364(ra) # 8000056c <panic>

00000000800016e0 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800016e0:	c6bd                	beqz	a3,8000174e <copyout+0x6e>
{
    800016e2:	715d                	addi	sp,sp,-80
    800016e4:	e486                	sd	ra,72(sp)
    800016e6:	e0a2                	sd	s0,64(sp)
    800016e8:	fc26                	sd	s1,56(sp)
    800016ea:	f84a                	sd	s2,48(sp)
    800016ec:	f44e                	sd	s3,40(sp)
    800016ee:	f052                	sd	s4,32(sp)
    800016f0:	ec56                	sd	s5,24(sp)
    800016f2:	e85a                	sd	s6,16(sp)
    800016f4:	e45e                	sd	s7,8(sp)
    800016f6:	e062                	sd	s8,0(sp)
    800016f8:	0880                	addi	s0,sp,80
    800016fa:	8baa                	mv	s7,a0
    800016fc:	8a2e                	mv	s4,a1
    800016fe:	8ab2                	mv	s5,a2
    80001700:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80001702:	7c7d                	lui	s8,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80001704:	6b05                	lui	s6,0x1
    80001706:	a015                	j	8000172a <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001708:	9552                	add	a0,a0,s4
    8000170a:	0004861b          	sext.w	a2,s1
    8000170e:	85d6                	mv	a1,s5
    80001710:	41250533          	sub	a0,a0,s2
    80001714:	fffff097          	auipc	ra,0xfffff
    80001718:	68c080e7          	jalr	1676(ra) # 80000da0 <memmove>

    len -= n;
    8000171c:	409989b3          	sub	s3,s3,s1
    src += n;
    80001720:	9aa6                	add	s5,s5,s1
    dstva = va0 + PGSIZE;
    80001722:	01690a33          	add	s4,s2,s6
  while(len > 0){
    80001726:	02098263          	beqz	s3,8000174a <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    8000172a:	018a7933          	and	s2,s4,s8
    pa0 = walkaddr(pagetable, va0);
    8000172e:	85ca                	mv	a1,s2
    80001730:	855e                	mv	a0,s7
    80001732:	00000097          	auipc	ra,0x0
    80001736:	9b8080e7          	jalr	-1608(ra) # 800010ea <walkaddr>
    if(pa0 == 0)
    8000173a:	cd01                	beqz	a0,80001752 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    8000173c:	414904b3          	sub	s1,s2,s4
    80001740:	94da                	add	s1,s1,s6
    if(n > len)
    80001742:	fc99f3e3          	bgeu	s3,s1,80001708 <copyout+0x28>
    80001746:	84ce                	mv	s1,s3
    80001748:	b7c1                	j	80001708 <copyout+0x28>
  }
  return 0;
    8000174a:	4501                	li	a0,0
    8000174c:	a021                	j	80001754 <copyout+0x74>
    8000174e:	4501                	li	a0,0
}
    80001750:	8082                	ret
      return -1;
    80001752:	557d                	li	a0,-1
}
    80001754:	60a6                	ld	ra,72(sp)
    80001756:	6406                	ld	s0,64(sp)
    80001758:	74e2                	ld	s1,56(sp)
    8000175a:	7942                	ld	s2,48(sp)
    8000175c:	79a2                	ld	s3,40(sp)
    8000175e:	7a02                	ld	s4,32(sp)
    80001760:	6ae2                	ld	s5,24(sp)
    80001762:	6b42                	ld	s6,16(sp)
    80001764:	6ba2                	ld	s7,8(sp)
    80001766:	6c02                	ld	s8,0(sp)
    80001768:	6161                	addi	sp,sp,80
    8000176a:	8082                	ret

000000008000176c <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8000176c:	caa5                	beqz	a3,800017dc <copyin+0x70>
{
    8000176e:	715d                	addi	sp,sp,-80
    80001770:	e486                	sd	ra,72(sp)
    80001772:	e0a2                	sd	s0,64(sp)
    80001774:	fc26                	sd	s1,56(sp)
    80001776:	f84a                	sd	s2,48(sp)
    80001778:	f44e                	sd	s3,40(sp)
    8000177a:	f052                	sd	s4,32(sp)
    8000177c:	ec56                	sd	s5,24(sp)
    8000177e:	e85a                	sd	s6,16(sp)
    80001780:	e45e                	sd	s7,8(sp)
    80001782:	e062                	sd	s8,0(sp)
    80001784:	0880                	addi	s0,sp,80
    80001786:	8baa                	mv	s7,a0
    80001788:	8aae                	mv	s5,a1
    8000178a:	8a32                	mv	s4,a2
    8000178c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    8000178e:	7c7d                	lui	s8,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001790:	6b05                	lui	s6,0x1
    80001792:	a01d                	j	800017b8 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001794:	014505b3          	add	a1,a0,s4
    80001798:	0004861b          	sext.w	a2,s1
    8000179c:	412585b3          	sub	a1,a1,s2
    800017a0:	8556                	mv	a0,s5
    800017a2:	fffff097          	auipc	ra,0xfffff
    800017a6:	5fe080e7          	jalr	1534(ra) # 80000da0 <memmove>

    len -= n;
    800017aa:	409989b3          	sub	s3,s3,s1
    dst += n;
    800017ae:	9aa6                	add	s5,s5,s1
    srcva = va0 + PGSIZE;
    800017b0:	01690a33          	add	s4,s2,s6
  while(len > 0){
    800017b4:	02098263          	beqz	s3,800017d8 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    800017b8:	018a7933          	and	s2,s4,s8
    pa0 = walkaddr(pagetable, va0);
    800017bc:	85ca                	mv	a1,s2
    800017be:	855e                	mv	a0,s7
    800017c0:	00000097          	auipc	ra,0x0
    800017c4:	92a080e7          	jalr	-1750(ra) # 800010ea <walkaddr>
    if(pa0 == 0)
    800017c8:	cd01                	beqz	a0,800017e0 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    800017ca:	414904b3          	sub	s1,s2,s4
    800017ce:	94da                	add	s1,s1,s6
    if(n > len)
    800017d0:	fc99f2e3          	bgeu	s3,s1,80001794 <copyin+0x28>
    800017d4:	84ce                	mv	s1,s3
    800017d6:	bf7d                	j	80001794 <copyin+0x28>
  }
  return 0;
    800017d8:	4501                	li	a0,0
    800017da:	a021                	j	800017e2 <copyin+0x76>
    800017dc:	4501                	li	a0,0
}
    800017de:	8082                	ret
      return -1;
    800017e0:	557d                	li	a0,-1
}
    800017e2:	60a6                	ld	ra,72(sp)
    800017e4:	6406                	ld	s0,64(sp)
    800017e6:	74e2                	ld	s1,56(sp)
    800017e8:	7942                	ld	s2,48(sp)
    800017ea:	79a2                	ld	s3,40(sp)
    800017ec:	7a02                	ld	s4,32(sp)
    800017ee:	6ae2                	ld	s5,24(sp)
    800017f0:	6b42                	ld	s6,16(sp)
    800017f2:	6ba2                	ld	s7,8(sp)
    800017f4:	6c02                	ld	s8,0(sp)
    800017f6:	6161                	addi	sp,sp,80
    800017f8:	8082                	ret

00000000800017fa <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    800017fa:	ced5                	beqz	a3,800018b6 <copyinstr+0xbc>
{
    800017fc:	715d                	addi	sp,sp,-80
    800017fe:	e486                	sd	ra,72(sp)
    80001800:	e0a2                	sd	s0,64(sp)
    80001802:	fc26                	sd	s1,56(sp)
    80001804:	f84a                	sd	s2,48(sp)
    80001806:	f44e                	sd	s3,40(sp)
    80001808:	f052                	sd	s4,32(sp)
    8000180a:	ec56                	sd	s5,24(sp)
    8000180c:	e85a                	sd	s6,16(sp)
    8000180e:	e45e                	sd	s7,8(sp)
    80001810:	e062                	sd	s8,0(sp)
    80001812:	0880                	addi	s0,sp,80
    80001814:	8aaa                	mv	s5,a0
    80001816:	84ae                	mv	s1,a1
    80001818:	8c32                	mv	s8,a2
    8000181a:	8bb6                	mv	s7,a3
    va0 = PGROUNDDOWN(srcva);
    8000181c:	7a7d                	lui	s4,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000181e:	6985                	lui	s3,0x1
    80001820:	4b05                	li	s6,1
    80001822:	a801                	j	80001832 <copyinstr+0x38>
    if(n > max)
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
    80001824:	87a6                	mv	a5,s1
    80001826:	a085                	j	80001886 <copyinstr+0x8c>
        *dst = *p;
      }
      --n;
      --max;
      p++;
      dst++;
    80001828:	84b2                	mv	s1,a2
    }

    srcva = va0 + PGSIZE;
    8000182a:	01390c33          	add	s8,s2,s3
  while(got_null == 0 && max > 0){
    8000182e:	080b8063          	beqz	s7,800018ae <copyinstr+0xb4>
    va0 = PGROUNDDOWN(srcva);
    80001832:	014c7933          	and	s2,s8,s4
    pa0 = walkaddr(pagetable, va0);
    80001836:	85ca                	mv	a1,s2
    80001838:	8556                	mv	a0,s5
    8000183a:	00000097          	auipc	ra,0x0
    8000183e:	8b0080e7          	jalr	-1872(ra) # 800010ea <walkaddr>
    if(pa0 == 0)
    80001842:	c925                	beqz	a0,800018b2 <copyinstr+0xb8>
    n = PGSIZE - (srcva - va0);
    80001844:	41890633          	sub	a2,s2,s8
    80001848:	964e                	add	a2,a2,s3
    if(n > max)
    8000184a:	00cbf363          	bgeu	s7,a2,80001850 <copyinstr+0x56>
    8000184e:	865e                	mv	a2,s7
    char *p = (char *) (pa0 + (srcva - va0));
    80001850:	9562                	add	a0,a0,s8
    80001852:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80001856:	da71                	beqz	a2,8000182a <copyinstr+0x30>
      if(*p == '\0'){
    80001858:	00054703          	lbu	a4,0(a0)
    8000185c:	d761                	beqz	a4,80001824 <copyinstr+0x2a>
    8000185e:	9626                	add	a2,a2,s1
    80001860:	87a6                	mv	a5,s1
    80001862:	1bfd                	addi	s7,s7,-1
    80001864:	009b86b3          	add	a3,s7,s1
    80001868:	409b04b3          	sub	s1,s6,s1
    8000186c:	94aa                	add	s1,s1,a0
        *dst = *p;
    8000186e:	00e78023          	sb	a4,0(a5) # 1000 <_entry-0x7ffff000>
      --max;
    80001872:	40f68bb3          	sub	s7,a3,a5
      p++;
    80001876:	00f48733          	add	a4,s1,a5
      dst++;
    8000187a:	0785                	addi	a5,a5,1
    while(n > 0){
    8000187c:	faf606e3          	beq	a2,a5,80001828 <copyinstr+0x2e>
      if(*p == '\0'){
    80001880:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffdd260>
    80001884:	f76d                	bnez	a4,8000186e <copyinstr+0x74>
        *dst = '\0';
    80001886:	00078023          	sb	zero,0(a5)
    8000188a:	4785                	li	a5,1
  }
  if(got_null){
    8000188c:	0017b513          	seqz	a0,a5
    80001890:	40a0053b          	negw	a0,a0
    80001894:	2501                	sext.w	a0,a0
    return 0;
  } else {
    return -1;
  }
}
    80001896:	60a6                	ld	ra,72(sp)
    80001898:	6406                	ld	s0,64(sp)
    8000189a:	74e2                	ld	s1,56(sp)
    8000189c:	7942                	ld	s2,48(sp)
    8000189e:	79a2                	ld	s3,40(sp)
    800018a0:	7a02                	ld	s4,32(sp)
    800018a2:	6ae2                	ld	s5,24(sp)
    800018a4:	6b42                	ld	s6,16(sp)
    800018a6:	6ba2                	ld	s7,8(sp)
    800018a8:	6c02                	ld	s8,0(sp)
    800018aa:	6161                	addi	sp,sp,80
    800018ac:	8082                	ret
    800018ae:	4781                	li	a5,0
    800018b0:	bff1                	j	8000188c <copyinstr+0x92>
      return -1;
    800018b2:	557d                	li	a0,-1
    800018b4:	b7cd                	j	80001896 <copyinstr+0x9c>
  int got_null = 0;
    800018b6:	4781                	li	a5,0
  if(got_null){
    800018b8:	0017b513          	seqz	a0,a5
    800018bc:	40a0053b          	negw	a0,a0
    800018c0:	2501                	sext.w	a0,a0
}
    800018c2:	8082                	ret

00000000800018c4 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    800018c4:	7139                	addi	sp,sp,-64
    800018c6:	fc06                	sd	ra,56(sp)
    800018c8:	f822                	sd	s0,48(sp)
    800018ca:	f426                	sd	s1,40(sp)
    800018cc:	f04a                	sd	s2,32(sp)
    800018ce:	ec4e                	sd	s3,24(sp)
    800018d0:	e852                	sd	s4,16(sp)
    800018d2:	e456                	sd	s5,8(sp)
    800018d4:	e05a                	sd	s6,0(sp)
    800018d6:	0080                	addi	s0,sp,64
    800018d8:	8b2a                	mv	s6,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    800018da:	0000f497          	auipc	s1,0xf
    800018de:	6e648493          	addi	s1,s1,1766 # 80010fc0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    800018e2:	8aa6                	mv	s5,s1
    800018e4:	00006a17          	auipc	s4,0x6
    800018e8:	71ca0a13          	addi	s4,s4,1820 # 80008000 <etext>
    800018ec:	04000937          	lui	s2,0x4000
    800018f0:	197d                	addi	s2,s2,-1
    800018f2:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800018f4:	00015997          	auipc	s3,0x15
    800018f8:	0cc98993          	addi	s3,s3,204 # 800169c0 <tickslock>
    char *pa = kalloc();
    800018fc:	fffff097          	auipc	ra,0xfffff
    80001900:	24c080e7          	jalr	588(ra) # 80000b48 <kalloc>
    80001904:	862a                	mv	a2,a0
    if(pa == 0)
    80001906:	c131                	beqz	a0,8000194a <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80001908:	415485b3          	sub	a1,s1,s5
    8000190c:	858d                	srai	a1,a1,0x3
    8000190e:	000a3783          	ld	a5,0(s4)
    80001912:	02f585b3          	mul	a1,a1,a5
    80001916:	2585                	addiw	a1,a1,1
    80001918:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    8000191c:	4719                	li	a4,6
    8000191e:	6685                	lui	a3,0x1
    80001920:	40b905b3          	sub	a1,s2,a1
    80001924:	855a                	mv	a0,s6
    80001926:	00000097          	auipc	ra,0x0
    8000192a:	8a4080e7          	jalr	-1884(ra) # 800011ca <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000192e:	16848493          	addi	s1,s1,360
    80001932:	fd3495e3          	bne	s1,s3,800018fc <proc_mapstacks+0x38>
  }
}
    80001936:	70e2                	ld	ra,56(sp)
    80001938:	7442                	ld	s0,48(sp)
    8000193a:	74a2                	ld	s1,40(sp)
    8000193c:	7902                	ld	s2,32(sp)
    8000193e:	69e2                	ld	s3,24(sp)
    80001940:	6a42                	ld	s4,16(sp)
    80001942:	6aa2                	ld	s5,8(sp)
    80001944:	6b02                	ld	s6,0(sp)
    80001946:	6121                	addi	sp,sp,64
    80001948:	8082                	ret
      panic("kalloc");
    8000194a:	00007517          	auipc	a0,0x7
    8000194e:	8be50513          	addi	a0,a0,-1858 # 80008208 <states.1742+0x30>
    80001952:	fffff097          	auipc	ra,0xfffff
    80001956:	c1a080e7          	jalr	-998(ra) # 8000056c <panic>

000000008000195a <procinit>:

// initialize the proc table.
void
procinit(void)
{
    8000195a:	7139                	addi	sp,sp,-64
    8000195c:	fc06                	sd	ra,56(sp)
    8000195e:	f822                	sd	s0,48(sp)
    80001960:	f426                	sd	s1,40(sp)
    80001962:	f04a                	sd	s2,32(sp)
    80001964:	ec4e                	sd	s3,24(sp)
    80001966:	e852                	sd	s4,16(sp)
    80001968:	e456                	sd	s5,8(sp)
    8000196a:	e05a                	sd	s6,0(sp)
    8000196c:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    8000196e:	00007597          	auipc	a1,0x7
    80001972:	8a258593          	addi	a1,a1,-1886 # 80008210 <states.1742+0x38>
    80001976:	0000f517          	auipc	a0,0xf
    8000197a:	21a50513          	addi	a0,a0,538 # 80010b90 <pid_lock>
    8000197e:	fffff097          	auipc	ra,0xfffff
    80001982:	22a080e7          	jalr	554(ra) # 80000ba8 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001986:	00007597          	auipc	a1,0x7
    8000198a:	89258593          	addi	a1,a1,-1902 # 80008218 <states.1742+0x40>
    8000198e:	0000f517          	auipc	a0,0xf
    80001992:	21a50513          	addi	a0,a0,538 # 80010ba8 <wait_lock>
    80001996:	fffff097          	auipc	ra,0xfffff
    8000199a:	212080e7          	jalr	530(ra) # 80000ba8 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000199e:	0000f497          	auipc	s1,0xf
    800019a2:	62248493          	addi	s1,s1,1570 # 80010fc0 <proc>
      initlock(&p->lock, "proc");
    800019a6:	00007b17          	auipc	s6,0x7
    800019aa:	882b0b13          	addi	s6,s6,-1918 # 80008228 <states.1742+0x50>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    800019ae:	8aa6                	mv	s5,s1
    800019b0:	00006a17          	auipc	s4,0x6
    800019b4:	650a0a13          	addi	s4,s4,1616 # 80008000 <etext>
    800019b8:	04000937          	lui	s2,0x4000
    800019bc:	197d                	addi	s2,s2,-1
    800019be:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800019c0:	00015997          	auipc	s3,0x15
    800019c4:	00098993          	mv	s3,s3
      initlock(&p->lock, "proc");
    800019c8:	85da                	mv	a1,s6
    800019ca:	8526                	mv	a0,s1
    800019cc:	fffff097          	auipc	ra,0xfffff
    800019d0:	1dc080e7          	jalr	476(ra) # 80000ba8 <initlock>
      p->state = UNUSED;
    800019d4:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    800019d8:	415487b3          	sub	a5,s1,s5
    800019dc:	878d                	srai	a5,a5,0x3
    800019de:	000a3703          	ld	a4,0(s4)
    800019e2:	02e787b3          	mul	a5,a5,a4
    800019e6:	2785                	addiw	a5,a5,1
    800019e8:	00d7979b          	slliw	a5,a5,0xd
    800019ec:	40f907b3          	sub	a5,s2,a5
    800019f0:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    800019f2:	16848493          	addi	s1,s1,360
    800019f6:	fd3499e3          	bne	s1,s3,800019c8 <procinit+0x6e>
  }
}
    800019fa:	70e2                	ld	ra,56(sp)
    800019fc:	7442                	ld	s0,48(sp)
    800019fe:	74a2                	ld	s1,40(sp)
    80001a00:	7902                	ld	s2,32(sp)
    80001a02:	69e2                	ld	s3,24(sp)
    80001a04:	6a42                	ld	s4,16(sp)
    80001a06:	6aa2                	ld	s5,8(sp)
    80001a08:	6b02                	ld	s6,0(sp)
    80001a0a:	6121                	addi	sp,sp,64
    80001a0c:	8082                	ret

0000000080001a0e <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001a0e:	1141                	addi	sp,sp,-16
    80001a10:	e422                	sd	s0,8(sp)
    80001a12:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001a14:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001a16:	2501                	sext.w	a0,a0
    80001a18:	6422                	ld	s0,8(sp)
    80001a1a:	0141                	addi	sp,sp,16
    80001a1c:	8082                	ret

0000000080001a1e <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80001a1e:	1141                	addi	sp,sp,-16
    80001a20:	e422                	sd	s0,8(sp)
    80001a22:	0800                	addi	s0,sp,16
    80001a24:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001a26:	2781                	sext.w	a5,a5
    80001a28:	079e                	slli	a5,a5,0x7
  return c;
}
    80001a2a:	0000f517          	auipc	a0,0xf
    80001a2e:	19650513          	addi	a0,a0,406 # 80010bc0 <cpus>
    80001a32:	953e                	add	a0,a0,a5
    80001a34:	6422                	ld	s0,8(sp)
    80001a36:	0141                	addi	sp,sp,16
    80001a38:	8082                	ret

0000000080001a3a <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80001a3a:	1101                	addi	sp,sp,-32
    80001a3c:	ec06                	sd	ra,24(sp)
    80001a3e:	e822                	sd	s0,16(sp)
    80001a40:	e426                	sd	s1,8(sp)
    80001a42:	1000                	addi	s0,sp,32
  push_off();
    80001a44:	fffff097          	auipc	ra,0xfffff
    80001a48:	1a8080e7          	jalr	424(ra) # 80000bec <push_off>
    80001a4c:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001a4e:	2781                	sext.w	a5,a5
    80001a50:	079e                	slli	a5,a5,0x7
    80001a52:	0000f717          	auipc	a4,0xf
    80001a56:	13e70713          	addi	a4,a4,318 # 80010b90 <pid_lock>
    80001a5a:	97ba                	add	a5,a5,a4
    80001a5c:	7b84                	ld	s1,48(a5)
  pop_off();
    80001a5e:	fffff097          	auipc	ra,0xfffff
    80001a62:	22e080e7          	jalr	558(ra) # 80000c8c <pop_off>
  return p;
}
    80001a66:	8526                	mv	a0,s1
    80001a68:	60e2                	ld	ra,24(sp)
    80001a6a:	6442                	ld	s0,16(sp)
    80001a6c:	64a2                	ld	s1,8(sp)
    80001a6e:	6105                	addi	sp,sp,32
    80001a70:	8082                	ret

0000000080001a72 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001a72:	1141                	addi	sp,sp,-16
    80001a74:	e406                	sd	ra,8(sp)
    80001a76:	e022                	sd	s0,0(sp)
    80001a78:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001a7a:	00000097          	auipc	ra,0x0
    80001a7e:	fc0080e7          	jalr	-64(ra) # 80001a3a <myproc>
    80001a82:	fffff097          	auipc	ra,0xfffff
    80001a86:	26a080e7          	jalr	618(ra) # 80000cec <release>

  if (first) {
    80001a8a:	00007797          	auipc	a5,0x7
    80001a8e:	df678793          	addi	a5,a5,-522 # 80008880 <first.1698>
    80001a92:	439c                	lw	a5,0(a5)
    80001a94:	eb89                	bnez	a5,80001aa6 <forkret+0x34>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001a96:	00001097          	auipc	ra,0x1
    80001a9a:	c74080e7          	jalr	-908(ra) # 8000270a <usertrapret>
}
    80001a9e:	60a2                	ld	ra,8(sp)
    80001aa0:	6402                	ld	s0,0(sp)
    80001aa2:	0141                	addi	sp,sp,16
    80001aa4:	8082                	ret
    first = 0;
    80001aa6:	00007797          	auipc	a5,0x7
    80001aaa:	dc07ad23          	sw	zero,-550(a5) # 80008880 <first.1698>
    fsinit(ROOTDEV);
    80001aae:	4505                	li	a0,1
    80001ab0:	00002097          	auipc	ra,0x2
    80001ab4:	abe080e7          	jalr	-1346(ra) # 8000356e <fsinit>
    80001ab8:	bff9                	j	80001a96 <forkret+0x24>

0000000080001aba <allocpid>:
{
    80001aba:	1101                	addi	sp,sp,-32
    80001abc:	ec06                	sd	ra,24(sp)
    80001abe:	e822                	sd	s0,16(sp)
    80001ac0:	e426                	sd	s1,8(sp)
    80001ac2:	e04a                	sd	s2,0(sp)
    80001ac4:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001ac6:	0000f917          	auipc	s2,0xf
    80001aca:	0ca90913          	addi	s2,s2,202 # 80010b90 <pid_lock>
    80001ace:	854a                	mv	a0,s2
    80001ad0:	fffff097          	auipc	ra,0xfffff
    80001ad4:	168080e7          	jalr	360(ra) # 80000c38 <acquire>
  pid = nextpid;
    80001ad8:	00007797          	auipc	a5,0x7
    80001adc:	dac78793          	addi	a5,a5,-596 # 80008884 <nextpid>
    80001ae0:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001ae2:	0014871b          	addiw	a4,s1,1
    80001ae6:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001ae8:	854a                	mv	a0,s2
    80001aea:	fffff097          	auipc	ra,0xfffff
    80001aee:	202080e7          	jalr	514(ra) # 80000cec <release>
}
    80001af2:	8526                	mv	a0,s1
    80001af4:	60e2                	ld	ra,24(sp)
    80001af6:	6442                	ld	s0,16(sp)
    80001af8:	64a2                	ld	s1,8(sp)
    80001afa:	6902                	ld	s2,0(sp)
    80001afc:	6105                	addi	sp,sp,32
    80001afe:	8082                	ret

0000000080001b00 <proc_pagetable>:
{
    80001b00:	1101                	addi	sp,sp,-32
    80001b02:	ec06                	sd	ra,24(sp)
    80001b04:	e822                	sd	s0,16(sp)
    80001b06:	e426                	sd	s1,8(sp)
    80001b08:	e04a                	sd	s2,0(sp)
    80001b0a:	1000                	addi	s0,sp,32
    80001b0c:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001b0e:	00000097          	auipc	ra,0x0
    80001b12:	8a8080e7          	jalr	-1880(ra) # 800013b6 <uvmcreate>
    80001b16:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001b18:	c121                	beqz	a0,80001b58 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001b1a:	4729                	li	a4,10
    80001b1c:	00005697          	auipc	a3,0x5
    80001b20:	4e468693          	addi	a3,a3,1252 # 80007000 <_trampoline>
    80001b24:	6605                	lui	a2,0x1
    80001b26:	040005b7          	lui	a1,0x4000
    80001b2a:	15fd                	addi	a1,a1,-1
    80001b2c:	05b2                	slli	a1,a1,0xc
    80001b2e:	fffff097          	auipc	ra,0xfffff
    80001b32:	5fe080e7          	jalr	1534(ra) # 8000112c <mappages>
    80001b36:	02054863          	bltz	a0,80001b66 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001b3a:	4719                	li	a4,6
    80001b3c:	05893683          	ld	a3,88(s2)
    80001b40:	6605                	lui	a2,0x1
    80001b42:	020005b7          	lui	a1,0x2000
    80001b46:	15fd                	addi	a1,a1,-1
    80001b48:	05b6                	slli	a1,a1,0xd
    80001b4a:	8526                	mv	a0,s1
    80001b4c:	fffff097          	auipc	ra,0xfffff
    80001b50:	5e0080e7          	jalr	1504(ra) # 8000112c <mappages>
    80001b54:	02054163          	bltz	a0,80001b76 <proc_pagetable+0x76>
}
    80001b58:	8526                	mv	a0,s1
    80001b5a:	60e2                	ld	ra,24(sp)
    80001b5c:	6442                	ld	s0,16(sp)
    80001b5e:	64a2                	ld	s1,8(sp)
    80001b60:	6902                	ld	s2,0(sp)
    80001b62:	6105                	addi	sp,sp,32
    80001b64:	8082                	ret
    uvmfree(pagetable, 0);
    80001b66:	4581                	li	a1,0
    80001b68:	8526                	mv	a0,s1
    80001b6a:	00000097          	auipc	ra,0x0
    80001b6e:	a4e080e7          	jalr	-1458(ra) # 800015b8 <uvmfree>
    return 0;
    80001b72:	4481                	li	s1,0
    80001b74:	b7d5                	j	80001b58 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b76:	4681                	li	a3,0
    80001b78:	4605                	li	a2,1
    80001b7a:	040005b7          	lui	a1,0x4000
    80001b7e:	15fd                	addi	a1,a1,-1
    80001b80:	05b2                	slli	a1,a1,0xc
    80001b82:	8526                	mv	a0,s1
    80001b84:	fffff097          	auipc	ra,0xfffff
    80001b88:	76c080e7          	jalr	1900(ra) # 800012f0 <uvmunmap>
    uvmfree(pagetable, 0);
    80001b8c:	4581                	li	a1,0
    80001b8e:	8526                	mv	a0,s1
    80001b90:	00000097          	auipc	ra,0x0
    80001b94:	a28080e7          	jalr	-1496(ra) # 800015b8 <uvmfree>
    return 0;
    80001b98:	4481                	li	s1,0
    80001b9a:	bf7d                	j	80001b58 <proc_pagetable+0x58>

0000000080001b9c <proc_freepagetable>:
{
    80001b9c:	1101                	addi	sp,sp,-32
    80001b9e:	ec06                	sd	ra,24(sp)
    80001ba0:	e822                	sd	s0,16(sp)
    80001ba2:	e426                	sd	s1,8(sp)
    80001ba4:	e04a                	sd	s2,0(sp)
    80001ba6:	1000                	addi	s0,sp,32
    80001ba8:	84aa                	mv	s1,a0
    80001baa:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001bac:	4681                	li	a3,0
    80001bae:	4605                	li	a2,1
    80001bb0:	040005b7          	lui	a1,0x4000
    80001bb4:	15fd                	addi	a1,a1,-1
    80001bb6:	05b2                	slli	a1,a1,0xc
    80001bb8:	fffff097          	auipc	ra,0xfffff
    80001bbc:	738080e7          	jalr	1848(ra) # 800012f0 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001bc0:	4681                	li	a3,0
    80001bc2:	4605                	li	a2,1
    80001bc4:	020005b7          	lui	a1,0x2000
    80001bc8:	15fd                	addi	a1,a1,-1
    80001bca:	05b6                	slli	a1,a1,0xd
    80001bcc:	8526                	mv	a0,s1
    80001bce:	fffff097          	auipc	ra,0xfffff
    80001bd2:	722080e7          	jalr	1826(ra) # 800012f0 <uvmunmap>
  uvmfree(pagetable, sz);
    80001bd6:	85ca                	mv	a1,s2
    80001bd8:	8526                	mv	a0,s1
    80001bda:	00000097          	auipc	ra,0x0
    80001bde:	9de080e7          	jalr	-1570(ra) # 800015b8 <uvmfree>
}
    80001be2:	60e2                	ld	ra,24(sp)
    80001be4:	6442                	ld	s0,16(sp)
    80001be6:	64a2                	ld	s1,8(sp)
    80001be8:	6902                	ld	s2,0(sp)
    80001bea:	6105                	addi	sp,sp,32
    80001bec:	8082                	ret

0000000080001bee <freeproc>:
{
    80001bee:	1101                	addi	sp,sp,-32
    80001bf0:	ec06                	sd	ra,24(sp)
    80001bf2:	e822                	sd	s0,16(sp)
    80001bf4:	e426                	sd	s1,8(sp)
    80001bf6:	1000                	addi	s0,sp,32
    80001bf8:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001bfa:	6d28                	ld	a0,88(a0)
    80001bfc:	c509                	beqz	a0,80001c06 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001bfe:	fffff097          	auipc	ra,0xfffff
    80001c02:	e4a080e7          	jalr	-438(ra) # 80000a48 <kfree>
  p->trapframe = 0;
    80001c06:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001c0a:	68a8                	ld	a0,80(s1)
    80001c0c:	c511                	beqz	a0,80001c18 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001c0e:	64ac                	ld	a1,72(s1)
    80001c10:	00000097          	auipc	ra,0x0
    80001c14:	f8c080e7          	jalr	-116(ra) # 80001b9c <proc_freepagetable>
  p->pagetable = 0;
    80001c18:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001c1c:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001c20:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001c24:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001c28:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001c2c:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001c30:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001c34:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001c38:	0004ac23          	sw	zero,24(s1)
}
    80001c3c:	60e2                	ld	ra,24(sp)
    80001c3e:	6442                	ld	s0,16(sp)
    80001c40:	64a2                	ld	s1,8(sp)
    80001c42:	6105                	addi	sp,sp,32
    80001c44:	8082                	ret

0000000080001c46 <allocproc>:
{
    80001c46:	1101                	addi	sp,sp,-32
    80001c48:	ec06                	sd	ra,24(sp)
    80001c4a:	e822                	sd	s0,16(sp)
    80001c4c:	e426                	sd	s1,8(sp)
    80001c4e:	e04a                	sd	s2,0(sp)
    80001c50:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c52:	0000f497          	auipc	s1,0xf
    80001c56:	36e48493          	addi	s1,s1,878 # 80010fc0 <proc>
    80001c5a:	00015917          	auipc	s2,0x15
    80001c5e:	d6690913          	addi	s2,s2,-666 # 800169c0 <tickslock>
    acquire(&p->lock);
    80001c62:	8526                	mv	a0,s1
    80001c64:	fffff097          	auipc	ra,0xfffff
    80001c68:	fd4080e7          	jalr	-44(ra) # 80000c38 <acquire>
    if(p->state == UNUSED) {
    80001c6c:	4c9c                	lw	a5,24(s1)
    80001c6e:	cf81                	beqz	a5,80001c86 <allocproc+0x40>
      release(&p->lock);
    80001c70:	8526                	mv	a0,s1
    80001c72:	fffff097          	auipc	ra,0xfffff
    80001c76:	07a080e7          	jalr	122(ra) # 80000cec <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c7a:	16848493          	addi	s1,s1,360
    80001c7e:	ff2492e3          	bne	s1,s2,80001c62 <allocproc+0x1c>
  return 0;
    80001c82:	4481                	li	s1,0
    80001c84:	a889                	j	80001cd6 <allocproc+0x90>
  p->pid = allocpid();
    80001c86:	00000097          	auipc	ra,0x0
    80001c8a:	e34080e7          	jalr	-460(ra) # 80001aba <allocpid>
    80001c8e:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001c90:	4785                	li	a5,1
    80001c92:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001c94:	fffff097          	auipc	ra,0xfffff
    80001c98:	eb4080e7          	jalr	-332(ra) # 80000b48 <kalloc>
    80001c9c:	892a                	mv	s2,a0
    80001c9e:	eca8                	sd	a0,88(s1)
    80001ca0:	c131                	beqz	a0,80001ce4 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001ca2:	8526                	mv	a0,s1
    80001ca4:	00000097          	auipc	ra,0x0
    80001ca8:	e5c080e7          	jalr	-420(ra) # 80001b00 <proc_pagetable>
    80001cac:	892a                	mv	s2,a0
    80001cae:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001cb0:	c531                	beqz	a0,80001cfc <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001cb2:	07000613          	li	a2,112
    80001cb6:	4581                	li	a1,0
    80001cb8:	06048513          	addi	a0,s1,96
    80001cbc:	fffff097          	auipc	ra,0xfffff
    80001cc0:	078080e7          	jalr	120(ra) # 80000d34 <memset>
  p->context.ra = (uint64)forkret;
    80001cc4:	00000797          	auipc	a5,0x0
    80001cc8:	dae78793          	addi	a5,a5,-594 # 80001a72 <forkret>
    80001ccc:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001cce:	60bc                	ld	a5,64(s1)
    80001cd0:	6705                	lui	a4,0x1
    80001cd2:	97ba                	add	a5,a5,a4
    80001cd4:	f4bc                	sd	a5,104(s1)
}
    80001cd6:	8526                	mv	a0,s1
    80001cd8:	60e2                	ld	ra,24(sp)
    80001cda:	6442                	ld	s0,16(sp)
    80001cdc:	64a2                	ld	s1,8(sp)
    80001cde:	6902                	ld	s2,0(sp)
    80001ce0:	6105                	addi	sp,sp,32
    80001ce2:	8082                	ret
    freeproc(p);
    80001ce4:	8526                	mv	a0,s1
    80001ce6:	00000097          	auipc	ra,0x0
    80001cea:	f08080e7          	jalr	-248(ra) # 80001bee <freeproc>
    release(&p->lock);
    80001cee:	8526                	mv	a0,s1
    80001cf0:	fffff097          	auipc	ra,0xfffff
    80001cf4:	ffc080e7          	jalr	-4(ra) # 80000cec <release>
    return 0;
    80001cf8:	84ca                	mv	s1,s2
    80001cfa:	bff1                	j	80001cd6 <allocproc+0x90>
    freeproc(p);
    80001cfc:	8526                	mv	a0,s1
    80001cfe:	00000097          	auipc	ra,0x0
    80001d02:	ef0080e7          	jalr	-272(ra) # 80001bee <freeproc>
    release(&p->lock);
    80001d06:	8526                	mv	a0,s1
    80001d08:	fffff097          	auipc	ra,0xfffff
    80001d0c:	fe4080e7          	jalr	-28(ra) # 80000cec <release>
    return 0;
    80001d10:	84ca                	mv	s1,s2
    80001d12:	b7d1                	j	80001cd6 <allocproc+0x90>

0000000080001d14 <userinit>:
{
    80001d14:	1101                	addi	sp,sp,-32
    80001d16:	ec06                	sd	ra,24(sp)
    80001d18:	e822                	sd	s0,16(sp)
    80001d1a:	e426                	sd	s1,8(sp)
    80001d1c:	1000                	addi	s0,sp,32
  p = allocproc();
    80001d1e:	00000097          	auipc	ra,0x0
    80001d22:	f28080e7          	jalr	-216(ra) # 80001c46 <allocproc>
    80001d26:	84aa                	mv	s1,a0
  initproc = p;
    80001d28:	00007797          	auipc	a5,0x7
    80001d2c:	bea7b823          	sd	a0,-1040(a5) # 80008918 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001d30:	03400613          	li	a2,52
    80001d34:	00007597          	auipc	a1,0x7
    80001d38:	b5c58593          	addi	a1,a1,-1188 # 80008890 <initcode>
    80001d3c:	6928                	ld	a0,80(a0)
    80001d3e:	fffff097          	auipc	ra,0xfffff
    80001d42:	6a6080e7          	jalr	1702(ra) # 800013e4 <uvmfirst>
  p->sz = PGSIZE;
    80001d46:	6785                	lui	a5,0x1
    80001d48:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001d4a:	6cb8                	ld	a4,88(s1)
    80001d4c:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001d50:	6cb8                	ld	a4,88(s1)
    80001d52:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001d54:	4641                	li	a2,16
    80001d56:	00006597          	auipc	a1,0x6
    80001d5a:	4da58593          	addi	a1,a1,1242 # 80008230 <states.1742+0x58>
    80001d5e:	15848513          	addi	a0,s1,344
    80001d62:	fffff097          	auipc	ra,0xfffff
    80001d66:	146080e7          	jalr	326(ra) # 80000ea8 <safestrcpy>
  p->cwd = namei("/");
    80001d6a:	00006517          	auipc	a0,0x6
    80001d6e:	4d650513          	addi	a0,a0,1238 # 80008240 <states.1742+0x68>
    80001d72:	00002097          	auipc	ra,0x2
    80001d76:	22c080e7          	jalr	556(ra) # 80003f9e <namei>
    80001d7a:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001d7e:	478d                	li	a5,3
    80001d80:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001d82:	8526                	mv	a0,s1
    80001d84:	fffff097          	auipc	ra,0xfffff
    80001d88:	f68080e7          	jalr	-152(ra) # 80000cec <release>
}
    80001d8c:	60e2                	ld	ra,24(sp)
    80001d8e:	6442                	ld	s0,16(sp)
    80001d90:	64a2                	ld	s1,8(sp)
    80001d92:	6105                	addi	sp,sp,32
    80001d94:	8082                	ret

0000000080001d96 <growproc>:
{
    80001d96:	1101                	addi	sp,sp,-32
    80001d98:	ec06                	sd	ra,24(sp)
    80001d9a:	e822                	sd	s0,16(sp)
    80001d9c:	e426                	sd	s1,8(sp)
    80001d9e:	e04a                	sd	s2,0(sp)
    80001da0:	1000                	addi	s0,sp,32
    80001da2:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001da4:	00000097          	auipc	ra,0x0
    80001da8:	c96080e7          	jalr	-874(ra) # 80001a3a <myproc>
    80001dac:	84aa                	mv	s1,a0
  sz = p->sz;
    80001dae:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001db0:	01204c63          	bgtz	s2,80001dc8 <growproc+0x32>
  } else if(n < 0){
    80001db4:	02094663          	bltz	s2,80001de0 <growproc+0x4a>
  p->sz = sz;
    80001db8:	e4ac                	sd	a1,72(s1)
  return 0;
    80001dba:	4501                	li	a0,0
}
    80001dbc:	60e2                	ld	ra,24(sp)
    80001dbe:	6442                	ld	s0,16(sp)
    80001dc0:	64a2                	ld	s1,8(sp)
    80001dc2:	6902                	ld	s2,0(sp)
    80001dc4:	6105                	addi	sp,sp,32
    80001dc6:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001dc8:	4691                	li	a3,4
    80001dca:	00b90633          	add	a2,s2,a1
    80001dce:	6928                	ld	a0,80(a0)
    80001dd0:	fffff097          	auipc	ra,0xfffff
    80001dd4:	6cc080e7          	jalr	1740(ra) # 8000149c <uvmalloc>
    80001dd8:	85aa                	mv	a1,a0
    80001dda:	fd79                	bnez	a0,80001db8 <growproc+0x22>
      return -1;
    80001ddc:	557d                	li	a0,-1
    80001dde:	bff9                	j	80001dbc <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001de0:	00b90633          	add	a2,s2,a1
    80001de4:	6928                	ld	a0,80(a0)
    80001de6:	fffff097          	auipc	ra,0xfffff
    80001dea:	670080e7          	jalr	1648(ra) # 80001456 <uvmdealloc>
    80001dee:	85aa                	mv	a1,a0
    80001df0:	b7e1                	j	80001db8 <growproc+0x22>

0000000080001df2 <fork>:
{
    80001df2:	7179                	addi	sp,sp,-48
    80001df4:	f406                	sd	ra,40(sp)
    80001df6:	f022                	sd	s0,32(sp)
    80001df8:	ec26                	sd	s1,24(sp)
    80001dfa:	e84a                	sd	s2,16(sp)
    80001dfc:	e44e                	sd	s3,8(sp)
    80001dfe:	e052                	sd	s4,0(sp)
    80001e00:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001e02:	00000097          	auipc	ra,0x0
    80001e06:	c38080e7          	jalr	-968(ra) # 80001a3a <myproc>
    80001e0a:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001e0c:	00000097          	auipc	ra,0x0
    80001e10:	e3a080e7          	jalr	-454(ra) # 80001c46 <allocproc>
    80001e14:	10050b63          	beqz	a0,80001f2a <fork+0x138>
    80001e18:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001e1a:	04893603          	ld	a2,72(s2)
    80001e1e:	692c                	ld	a1,80(a0)
    80001e20:	05093503          	ld	a0,80(s2)
    80001e24:	fffff097          	auipc	ra,0xfffff
    80001e28:	7cc080e7          	jalr	1996(ra) # 800015f0 <uvmcopy>
    80001e2c:	04054663          	bltz	a0,80001e78 <fork+0x86>
  np->sz = p->sz;
    80001e30:	04893783          	ld	a5,72(s2)
    80001e34:	04f9b423          	sd	a5,72(s3) # 80016a08 <bcache+0x30>
  *(np->trapframe) = *(p->trapframe);
    80001e38:	05893683          	ld	a3,88(s2)
    80001e3c:	87b6                	mv	a5,a3
    80001e3e:	0589b703          	ld	a4,88(s3)
    80001e42:	12068693          	addi	a3,a3,288
    80001e46:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001e4a:	6788                	ld	a0,8(a5)
    80001e4c:	6b8c                	ld	a1,16(a5)
    80001e4e:	6f90                	ld	a2,24(a5)
    80001e50:	01073023          	sd	a6,0(a4)
    80001e54:	e708                	sd	a0,8(a4)
    80001e56:	eb0c                	sd	a1,16(a4)
    80001e58:	ef10                	sd	a2,24(a4)
    80001e5a:	02078793          	addi	a5,a5,32
    80001e5e:	02070713          	addi	a4,a4,32
    80001e62:	fed792e3          	bne	a5,a3,80001e46 <fork+0x54>
  np->trapframe->a0 = 0;
    80001e66:	0589b783          	ld	a5,88(s3)
    80001e6a:	0607b823          	sd	zero,112(a5)
    80001e6e:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    80001e72:	15000a13          	li	s4,336
    80001e76:	a03d                	j	80001ea4 <fork+0xb2>
    freeproc(np);
    80001e78:	854e                	mv	a0,s3
    80001e7a:	00000097          	auipc	ra,0x0
    80001e7e:	d74080e7          	jalr	-652(ra) # 80001bee <freeproc>
    release(&np->lock);
    80001e82:	854e                	mv	a0,s3
    80001e84:	fffff097          	auipc	ra,0xfffff
    80001e88:	e68080e7          	jalr	-408(ra) # 80000cec <release>
    return -1;
    80001e8c:	5a7d                	li	s4,-1
    80001e8e:	a069                	j	80001f18 <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    80001e90:	00002097          	auipc	ra,0x2
    80001e94:	7d4080e7          	jalr	2004(ra) # 80004664 <filedup>
    80001e98:	009987b3          	add	a5,s3,s1
    80001e9c:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    80001e9e:	04a1                	addi	s1,s1,8
    80001ea0:	01448763          	beq	s1,s4,80001eae <fork+0xbc>
    if(p->ofile[i])
    80001ea4:	009907b3          	add	a5,s2,s1
    80001ea8:	6388                	ld	a0,0(a5)
    80001eaa:	f17d                	bnez	a0,80001e90 <fork+0x9e>
    80001eac:	bfcd                	j	80001e9e <fork+0xac>
  np->cwd = idup(p->cwd);
    80001eae:	15093503          	ld	a0,336(s2)
    80001eb2:	00002097          	auipc	ra,0x2
    80001eb6:	8fc080e7          	jalr	-1796(ra) # 800037ae <idup>
    80001eba:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001ebe:	4641                	li	a2,16
    80001ec0:	15890593          	addi	a1,s2,344
    80001ec4:	15898513          	addi	a0,s3,344
    80001ec8:	fffff097          	auipc	ra,0xfffff
    80001ecc:	fe0080e7          	jalr	-32(ra) # 80000ea8 <safestrcpy>
  pid = np->pid;
    80001ed0:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    80001ed4:	854e                	mv	a0,s3
    80001ed6:	fffff097          	auipc	ra,0xfffff
    80001eda:	e16080e7          	jalr	-490(ra) # 80000cec <release>
  acquire(&wait_lock);
    80001ede:	0000f497          	auipc	s1,0xf
    80001ee2:	cca48493          	addi	s1,s1,-822 # 80010ba8 <wait_lock>
    80001ee6:	8526                	mv	a0,s1
    80001ee8:	fffff097          	auipc	ra,0xfffff
    80001eec:	d50080e7          	jalr	-688(ra) # 80000c38 <acquire>
  np->parent = p;
    80001ef0:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    80001ef4:	8526                	mv	a0,s1
    80001ef6:	fffff097          	auipc	ra,0xfffff
    80001efa:	df6080e7          	jalr	-522(ra) # 80000cec <release>
  acquire(&np->lock);
    80001efe:	854e                	mv	a0,s3
    80001f00:	fffff097          	auipc	ra,0xfffff
    80001f04:	d38080e7          	jalr	-712(ra) # 80000c38 <acquire>
  np->state = RUNNABLE;
    80001f08:	478d                	li	a5,3
    80001f0a:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001f0e:	854e                	mv	a0,s3
    80001f10:	fffff097          	auipc	ra,0xfffff
    80001f14:	ddc080e7          	jalr	-548(ra) # 80000cec <release>
}
    80001f18:	8552                	mv	a0,s4
    80001f1a:	70a2                	ld	ra,40(sp)
    80001f1c:	7402                	ld	s0,32(sp)
    80001f1e:	64e2                	ld	s1,24(sp)
    80001f20:	6942                	ld	s2,16(sp)
    80001f22:	69a2                	ld	s3,8(sp)
    80001f24:	6a02                	ld	s4,0(sp)
    80001f26:	6145                	addi	sp,sp,48
    80001f28:	8082                	ret
    return -1;
    80001f2a:	5a7d                	li	s4,-1
    80001f2c:	b7f5                	j	80001f18 <fork+0x126>

0000000080001f2e <scheduler>:
{
    80001f2e:	7139                	addi	sp,sp,-64
    80001f30:	fc06                	sd	ra,56(sp)
    80001f32:	f822                	sd	s0,48(sp)
    80001f34:	f426                	sd	s1,40(sp)
    80001f36:	f04a                	sd	s2,32(sp)
    80001f38:	ec4e                	sd	s3,24(sp)
    80001f3a:	e852                	sd	s4,16(sp)
    80001f3c:	e456                	sd	s5,8(sp)
    80001f3e:	e05a                	sd	s6,0(sp)
    80001f40:	0080                	addi	s0,sp,64
    80001f42:	8792                	mv	a5,tp
  int id = r_tp();
    80001f44:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001f46:	00779a93          	slli	s5,a5,0x7
    80001f4a:	0000f717          	auipc	a4,0xf
    80001f4e:	c4670713          	addi	a4,a4,-954 # 80010b90 <pid_lock>
    80001f52:	9756                	add	a4,a4,s5
    80001f54:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001f58:	0000f717          	auipc	a4,0xf
    80001f5c:	c7070713          	addi	a4,a4,-912 # 80010bc8 <cpus+0x8>
    80001f60:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001f62:	498d                	li	s3,3
        p->state = RUNNING;
    80001f64:	4b11                	li	s6,4
        c->proc = p;
    80001f66:	079e                	slli	a5,a5,0x7
    80001f68:	0000fa17          	auipc	s4,0xf
    80001f6c:	c28a0a13          	addi	s4,s4,-984 # 80010b90 <pid_lock>
    80001f70:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f72:	00015917          	auipc	s2,0x15
    80001f76:	a4e90913          	addi	s2,s2,-1458 # 800169c0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f7a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f7e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f82:	10079073          	csrw	sstatus,a5
    80001f86:	0000f497          	auipc	s1,0xf
    80001f8a:	03a48493          	addi	s1,s1,58 # 80010fc0 <proc>
    80001f8e:	a03d                	j	80001fbc <scheduler+0x8e>
        p->state = RUNNING;
    80001f90:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001f94:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001f98:	06048593          	addi	a1,s1,96
    80001f9c:	8556                	mv	a0,s5
    80001f9e:	00000097          	auipc	ra,0x0
    80001fa2:	6aa080e7          	jalr	1706(ra) # 80002648 <swtch>
        c->proc = 0;
    80001fa6:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    80001faa:	8526                	mv	a0,s1
    80001fac:	fffff097          	auipc	ra,0xfffff
    80001fb0:	d40080e7          	jalr	-704(ra) # 80000cec <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001fb4:	16848493          	addi	s1,s1,360
    80001fb8:	fd2481e3          	beq	s1,s2,80001f7a <scheduler+0x4c>
      acquire(&p->lock);
    80001fbc:	8526                	mv	a0,s1
    80001fbe:	fffff097          	auipc	ra,0xfffff
    80001fc2:	c7a080e7          	jalr	-902(ra) # 80000c38 <acquire>
      if(p->state == RUNNABLE) {
    80001fc6:	4c9c                	lw	a5,24(s1)
    80001fc8:	ff3791e3          	bne	a5,s3,80001faa <scheduler+0x7c>
    80001fcc:	b7d1                	j	80001f90 <scheduler+0x62>

0000000080001fce <sched>:
{
    80001fce:	7179                	addi	sp,sp,-48
    80001fd0:	f406                	sd	ra,40(sp)
    80001fd2:	f022                	sd	s0,32(sp)
    80001fd4:	ec26                	sd	s1,24(sp)
    80001fd6:	e84a                	sd	s2,16(sp)
    80001fd8:	e44e                	sd	s3,8(sp)
    80001fda:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001fdc:	00000097          	auipc	ra,0x0
    80001fe0:	a5e080e7          	jalr	-1442(ra) # 80001a3a <myproc>
    80001fe4:	892a                	mv	s2,a0
  if(!holding(&p->lock))
    80001fe6:	fffff097          	auipc	ra,0xfffff
    80001fea:	bd8080e7          	jalr	-1064(ra) # 80000bbe <holding>
    80001fee:	cd25                	beqz	a0,80002066 <sched+0x98>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001ff0:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001ff2:	2781                	sext.w	a5,a5
    80001ff4:	079e                	slli	a5,a5,0x7
    80001ff6:	0000f717          	auipc	a4,0xf
    80001ffa:	b9a70713          	addi	a4,a4,-1126 # 80010b90 <pid_lock>
    80001ffe:	97ba                	add	a5,a5,a4
    80002000:	0a87a703          	lw	a4,168(a5)
    80002004:	4785                	li	a5,1
    80002006:	06f71863          	bne	a4,a5,80002076 <sched+0xa8>
  if(p->state == RUNNING)
    8000200a:	01892703          	lw	a4,24(s2)
    8000200e:	4791                	li	a5,4
    80002010:	06f70b63          	beq	a4,a5,80002086 <sched+0xb8>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002014:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002018:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000201a:	efb5                	bnez	a5,80002096 <sched+0xc8>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000201c:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000201e:	0000f497          	auipc	s1,0xf
    80002022:	b7248493          	addi	s1,s1,-1166 # 80010b90 <pid_lock>
    80002026:	2781                	sext.w	a5,a5
    80002028:	079e                	slli	a5,a5,0x7
    8000202a:	97a6                	add	a5,a5,s1
    8000202c:	0ac7a983          	lw	s3,172(a5)
    80002030:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80002032:	2781                	sext.w	a5,a5
    80002034:	079e                	slli	a5,a5,0x7
    80002036:	0000f597          	auipc	a1,0xf
    8000203a:	b9258593          	addi	a1,a1,-1134 # 80010bc8 <cpus+0x8>
    8000203e:	95be                	add	a1,a1,a5
    80002040:	06090513          	addi	a0,s2,96
    80002044:	00000097          	auipc	ra,0x0
    80002048:	604080e7          	jalr	1540(ra) # 80002648 <swtch>
    8000204c:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000204e:	2781                	sext.w	a5,a5
    80002050:	079e                	slli	a5,a5,0x7
    80002052:	97a6                	add	a5,a5,s1
    80002054:	0b37a623          	sw	s3,172(a5)
}
    80002058:	70a2                	ld	ra,40(sp)
    8000205a:	7402                	ld	s0,32(sp)
    8000205c:	64e2                	ld	s1,24(sp)
    8000205e:	6942                	ld	s2,16(sp)
    80002060:	69a2                	ld	s3,8(sp)
    80002062:	6145                	addi	sp,sp,48
    80002064:	8082                	ret
    panic("sched p->lock");
    80002066:	00006517          	auipc	a0,0x6
    8000206a:	1e250513          	addi	a0,a0,482 # 80008248 <states.1742+0x70>
    8000206e:	ffffe097          	auipc	ra,0xffffe
    80002072:	4fe080e7          	jalr	1278(ra) # 8000056c <panic>
    panic("sched locks");
    80002076:	00006517          	auipc	a0,0x6
    8000207a:	1e250513          	addi	a0,a0,482 # 80008258 <states.1742+0x80>
    8000207e:	ffffe097          	auipc	ra,0xffffe
    80002082:	4ee080e7          	jalr	1262(ra) # 8000056c <panic>
    panic("sched running");
    80002086:	00006517          	auipc	a0,0x6
    8000208a:	1e250513          	addi	a0,a0,482 # 80008268 <states.1742+0x90>
    8000208e:	ffffe097          	auipc	ra,0xffffe
    80002092:	4de080e7          	jalr	1246(ra) # 8000056c <panic>
    panic("sched interruptible");
    80002096:	00006517          	auipc	a0,0x6
    8000209a:	1e250513          	addi	a0,a0,482 # 80008278 <states.1742+0xa0>
    8000209e:	ffffe097          	auipc	ra,0xffffe
    800020a2:	4ce080e7          	jalr	1230(ra) # 8000056c <panic>

00000000800020a6 <yield>:
{
    800020a6:	1101                	addi	sp,sp,-32
    800020a8:	ec06                	sd	ra,24(sp)
    800020aa:	e822                	sd	s0,16(sp)
    800020ac:	e426                	sd	s1,8(sp)
    800020ae:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800020b0:	00000097          	auipc	ra,0x0
    800020b4:	98a080e7          	jalr	-1654(ra) # 80001a3a <myproc>
    800020b8:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800020ba:	fffff097          	auipc	ra,0xfffff
    800020be:	b7e080e7          	jalr	-1154(ra) # 80000c38 <acquire>
  p->state = RUNNABLE;
    800020c2:	478d                	li	a5,3
    800020c4:	cc9c                	sw	a5,24(s1)
  sched();
    800020c6:	00000097          	auipc	ra,0x0
    800020ca:	f08080e7          	jalr	-248(ra) # 80001fce <sched>
  release(&p->lock);
    800020ce:	8526                	mv	a0,s1
    800020d0:	fffff097          	auipc	ra,0xfffff
    800020d4:	c1c080e7          	jalr	-996(ra) # 80000cec <release>
}
    800020d8:	60e2                	ld	ra,24(sp)
    800020da:	6442                	ld	s0,16(sp)
    800020dc:	64a2                	ld	s1,8(sp)
    800020de:	6105                	addi	sp,sp,32
    800020e0:	8082                	ret

00000000800020e2 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800020e2:	7179                	addi	sp,sp,-48
    800020e4:	f406                	sd	ra,40(sp)
    800020e6:	f022                	sd	s0,32(sp)
    800020e8:	ec26                	sd	s1,24(sp)
    800020ea:	e84a                	sd	s2,16(sp)
    800020ec:	e44e                	sd	s3,8(sp)
    800020ee:	1800                	addi	s0,sp,48
    800020f0:	89aa                	mv	s3,a0
    800020f2:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800020f4:	00000097          	auipc	ra,0x0
    800020f8:	946080e7          	jalr	-1722(ra) # 80001a3a <myproc>
    800020fc:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800020fe:	fffff097          	auipc	ra,0xfffff
    80002102:	b3a080e7          	jalr	-1222(ra) # 80000c38 <acquire>
  release(lk);
    80002106:	854a                	mv	a0,s2
    80002108:	fffff097          	auipc	ra,0xfffff
    8000210c:	be4080e7          	jalr	-1052(ra) # 80000cec <release>

  // Go to sleep.
  p->chan = chan;
    80002110:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80002114:	4789                	li	a5,2
    80002116:	cc9c                	sw	a5,24(s1)

  sched();
    80002118:	00000097          	auipc	ra,0x0
    8000211c:	eb6080e7          	jalr	-330(ra) # 80001fce <sched>

  // Tidy up.
  p->chan = 0;
    80002120:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80002124:	8526                	mv	a0,s1
    80002126:	fffff097          	auipc	ra,0xfffff
    8000212a:	bc6080e7          	jalr	-1082(ra) # 80000cec <release>
  acquire(lk);
    8000212e:	854a                	mv	a0,s2
    80002130:	fffff097          	auipc	ra,0xfffff
    80002134:	b08080e7          	jalr	-1272(ra) # 80000c38 <acquire>
}
    80002138:	70a2                	ld	ra,40(sp)
    8000213a:	7402                	ld	s0,32(sp)
    8000213c:	64e2                	ld	s1,24(sp)
    8000213e:	6942                	ld	s2,16(sp)
    80002140:	69a2                	ld	s3,8(sp)
    80002142:	6145                	addi	sp,sp,48
    80002144:	8082                	ret

0000000080002146 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80002146:	7139                	addi	sp,sp,-64
    80002148:	fc06                	sd	ra,56(sp)
    8000214a:	f822                	sd	s0,48(sp)
    8000214c:	f426                	sd	s1,40(sp)
    8000214e:	f04a                	sd	s2,32(sp)
    80002150:	ec4e                	sd	s3,24(sp)
    80002152:	e852                	sd	s4,16(sp)
    80002154:	e456                	sd	s5,8(sp)
    80002156:	0080                	addi	s0,sp,64
    80002158:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000215a:	0000f497          	auipc	s1,0xf
    8000215e:	e6648493          	addi	s1,s1,-410 # 80010fc0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80002162:	4989                	li	s3,2
        p->state = RUNNABLE;
    80002164:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80002166:	00015917          	auipc	s2,0x15
    8000216a:	85a90913          	addi	s2,s2,-1958 # 800169c0 <tickslock>
    8000216e:	a821                	j	80002186 <wakeup+0x40>
        p->state = RUNNABLE;
    80002170:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    80002174:	8526                	mv	a0,s1
    80002176:	fffff097          	auipc	ra,0xfffff
    8000217a:	b76080e7          	jalr	-1162(ra) # 80000cec <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000217e:	16848493          	addi	s1,s1,360
    80002182:	03248463          	beq	s1,s2,800021aa <wakeup+0x64>
    if(p != myproc()){
    80002186:	00000097          	auipc	ra,0x0
    8000218a:	8b4080e7          	jalr	-1868(ra) # 80001a3a <myproc>
    8000218e:	fea488e3          	beq	s1,a0,8000217e <wakeup+0x38>
      acquire(&p->lock);
    80002192:	8526                	mv	a0,s1
    80002194:	fffff097          	auipc	ra,0xfffff
    80002198:	aa4080e7          	jalr	-1372(ra) # 80000c38 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000219c:	4c9c                	lw	a5,24(s1)
    8000219e:	fd379be3          	bne	a5,s3,80002174 <wakeup+0x2e>
    800021a2:	709c                	ld	a5,32(s1)
    800021a4:	fd4798e3          	bne	a5,s4,80002174 <wakeup+0x2e>
    800021a8:	b7e1                	j	80002170 <wakeup+0x2a>
    }
  }
}
    800021aa:	70e2                	ld	ra,56(sp)
    800021ac:	7442                	ld	s0,48(sp)
    800021ae:	74a2                	ld	s1,40(sp)
    800021b0:	7902                	ld	s2,32(sp)
    800021b2:	69e2                	ld	s3,24(sp)
    800021b4:	6a42                	ld	s4,16(sp)
    800021b6:	6aa2                	ld	s5,8(sp)
    800021b8:	6121                	addi	sp,sp,64
    800021ba:	8082                	ret

00000000800021bc <reparent>:
{
    800021bc:	7179                	addi	sp,sp,-48
    800021be:	f406                	sd	ra,40(sp)
    800021c0:	f022                	sd	s0,32(sp)
    800021c2:	ec26                	sd	s1,24(sp)
    800021c4:	e84a                	sd	s2,16(sp)
    800021c6:	e44e                	sd	s3,8(sp)
    800021c8:	e052                	sd	s4,0(sp)
    800021ca:	1800                	addi	s0,sp,48
    800021cc:	89aa                	mv	s3,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800021ce:	0000f497          	auipc	s1,0xf
    800021d2:	df248493          	addi	s1,s1,-526 # 80010fc0 <proc>
      pp->parent = initproc;
    800021d6:	00006a17          	auipc	s4,0x6
    800021da:	742a0a13          	addi	s4,s4,1858 # 80008918 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800021de:	00014917          	auipc	s2,0x14
    800021e2:	7e290913          	addi	s2,s2,2018 # 800169c0 <tickslock>
    800021e6:	a029                	j	800021f0 <reparent+0x34>
    800021e8:	16848493          	addi	s1,s1,360
    800021ec:	01248d63          	beq	s1,s2,80002206 <reparent+0x4a>
    if(pp->parent == p){
    800021f0:	7c9c                	ld	a5,56(s1)
    800021f2:	ff379be3          	bne	a5,s3,800021e8 <reparent+0x2c>
      pp->parent = initproc;
    800021f6:	000a3503          	ld	a0,0(s4)
    800021fa:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800021fc:	00000097          	auipc	ra,0x0
    80002200:	f4a080e7          	jalr	-182(ra) # 80002146 <wakeup>
    80002204:	b7d5                	j	800021e8 <reparent+0x2c>
}
    80002206:	70a2                	ld	ra,40(sp)
    80002208:	7402                	ld	s0,32(sp)
    8000220a:	64e2                	ld	s1,24(sp)
    8000220c:	6942                	ld	s2,16(sp)
    8000220e:	69a2                	ld	s3,8(sp)
    80002210:	6a02                	ld	s4,0(sp)
    80002212:	6145                	addi	sp,sp,48
    80002214:	8082                	ret

0000000080002216 <exit>:
{
    80002216:	7179                	addi	sp,sp,-48
    80002218:	f406                	sd	ra,40(sp)
    8000221a:	f022                	sd	s0,32(sp)
    8000221c:	ec26                	sd	s1,24(sp)
    8000221e:	e84a                	sd	s2,16(sp)
    80002220:	e44e                	sd	s3,8(sp)
    80002222:	e052                	sd	s4,0(sp)
    80002224:	1800                	addi	s0,sp,48
    80002226:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002228:	00000097          	auipc	ra,0x0
    8000222c:	812080e7          	jalr	-2030(ra) # 80001a3a <myproc>
    80002230:	89aa                	mv	s3,a0
  if(p == initproc)
    80002232:	00006797          	auipc	a5,0x6
    80002236:	6e678793          	addi	a5,a5,1766 # 80008918 <initproc>
    8000223a:	639c                	ld	a5,0(a5)
    8000223c:	0d050493          	addi	s1,a0,208
    80002240:	15050913          	addi	s2,a0,336
    80002244:	02a79363          	bne	a5,a0,8000226a <exit+0x54>
    panic("init exiting");
    80002248:	00006517          	auipc	a0,0x6
    8000224c:	04850513          	addi	a0,a0,72 # 80008290 <states.1742+0xb8>
    80002250:	ffffe097          	auipc	ra,0xffffe
    80002254:	31c080e7          	jalr	796(ra) # 8000056c <panic>
      fileclose(f);
    80002258:	00002097          	auipc	ra,0x2
    8000225c:	45e080e7          	jalr	1118(ra) # 800046b6 <fileclose>
      p->ofile[fd] = 0;
    80002260:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80002264:	04a1                	addi	s1,s1,8
    80002266:	01248563          	beq	s1,s2,80002270 <exit+0x5a>
    if(p->ofile[fd]){
    8000226a:	6088                	ld	a0,0(s1)
    8000226c:	f575                	bnez	a0,80002258 <exit+0x42>
    8000226e:	bfdd                	j	80002264 <exit+0x4e>
  begin_op();
    80002270:	00002097          	auipc	ra,0x2
    80002274:	f4c080e7          	jalr	-180(ra) # 800041bc <begin_op>
  iput(p->cwd);
    80002278:	1509b503          	ld	a0,336(s3)
    8000227c:	00001097          	auipc	ra,0x1
    80002280:	72c080e7          	jalr	1836(ra) # 800039a8 <iput>
  end_op();
    80002284:	00002097          	auipc	ra,0x2
    80002288:	fb8080e7          	jalr	-72(ra) # 8000423c <end_op>
  p->cwd = 0;
    8000228c:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80002290:	0000f497          	auipc	s1,0xf
    80002294:	91848493          	addi	s1,s1,-1768 # 80010ba8 <wait_lock>
    80002298:	8526                	mv	a0,s1
    8000229a:	fffff097          	auipc	ra,0xfffff
    8000229e:	99e080e7          	jalr	-1634(ra) # 80000c38 <acquire>
  reparent(p);
    800022a2:	854e                	mv	a0,s3
    800022a4:	00000097          	auipc	ra,0x0
    800022a8:	f18080e7          	jalr	-232(ra) # 800021bc <reparent>
  wakeup(p->parent);
    800022ac:	0389b503          	ld	a0,56(s3)
    800022b0:	00000097          	auipc	ra,0x0
    800022b4:	e96080e7          	jalr	-362(ra) # 80002146 <wakeup>
  acquire(&p->lock);
    800022b8:	854e                	mv	a0,s3
    800022ba:	fffff097          	auipc	ra,0xfffff
    800022be:	97e080e7          	jalr	-1666(ra) # 80000c38 <acquire>
  p->xstate = status;
    800022c2:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800022c6:	4795                	li	a5,5
    800022c8:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800022cc:	8526                	mv	a0,s1
    800022ce:	fffff097          	auipc	ra,0xfffff
    800022d2:	a1e080e7          	jalr	-1506(ra) # 80000cec <release>
  sched();
    800022d6:	00000097          	auipc	ra,0x0
    800022da:	cf8080e7          	jalr	-776(ra) # 80001fce <sched>
  panic("zombie exit");
    800022de:	00006517          	auipc	a0,0x6
    800022e2:	fc250513          	addi	a0,a0,-62 # 800082a0 <states.1742+0xc8>
    800022e6:	ffffe097          	auipc	ra,0xffffe
    800022ea:	286080e7          	jalr	646(ra) # 8000056c <panic>

00000000800022ee <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800022ee:	7179                	addi	sp,sp,-48
    800022f0:	f406                	sd	ra,40(sp)
    800022f2:	f022                	sd	s0,32(sp)
    800022f4:	ec26                	sd	s1,24(sp)
    800022f6:	e84a                	sd	s2,16(sp)
    800022f8:	e44e                	sd	s3,8(sp)
    800022fa:	1800                	addi	s0,sp,48
    800022fc:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800022fe:	0000f497          	auipc	s1,0xf
    80002302:	cc248493          	addi	s1,s1,-830 # 80010fc0 <proc>
    80002306:	00014997          	auipc	s3,0x14
    8000230a:	6ba98993          	addi	s3,s3,1722 # 800169c0 <tickslock>
    acquire(&p->lock);
    8000230e:	8526                	mv	a0,s1
    80002310:	fffff097          	auipc	ra,0xfffff
    80002314:	928080e7          	jalr	-1752(ra) # 80000c38 <acquire>
    if(p->pid == pid){
    80002318:	589c                	lw	a5,48(s1)
    8000231a:	01278d63          	beq	a5,s2,80002334 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000231e:	8526                	mv	a0,s1
    80002320:	fffff097          	auipc	ra,0xfffff
    80002324:	9cc080e7          	jalr	-1588(ra) # 80000cec <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002328:	16848493          	addi	s1,s1,360
    8000232c:	ff3491e3          	bne	s1,s3,8000230e <kill+0x20>
  }
  return -1;
    80002330:	557d                	li	a0,-1
    80002332:	a829                	j	8000234c <kill+0x5e>
      p->killed = 1;
    80002334:	4785                	li	a5,1
    80002336:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80002338:	4c98                	lw	a4,24(s1)
    8000233a:	4789                	li	a5,2
    8000233c:	00f70f63          	beq	a4,a5,8000235a <kill+0x6c>
      release(&p->lock);
    80002340:	8526                	mv	a0,s1
    80002342:	fffff097          	auipc	ra,0xfffff
    80002346:	9aa080e7          	jalr	-1622(ra) # 80000cec <release>
      return 0;
    8000234a:	4501                	li	a0,0
}
    8000234c:	70a2                	ld	ra,40(sp)
    8000234e:	7402                	ld	s0,32(sp)
    80002350:	64e2                	ld	s1,24(sp)
    80002352:	6942                	ld	s2,16(sp)
    80002354:	69a2                	ld	s3,8(sp)
    80002356:	6145                	addi	sp,sp,48
    80002358:	8082                	ret
        p->state = RUNNABLE;
    8000235a:	478d                	li	a5,3
    8000235c:	cc9c                	sw	a5,24(s1)
    8000235e:	b7cd                	j	80002340 <kill+0x52>

0000000080002360 <setkilled>:

void
setkilled(struct proc *p)
{
    80002360:	1101                	addi	sp,sp,-32
    80002362:	ec06                	sd	ra,24(sp)
    80002364:	e822                	sd	s0,16(sp)
    80002366:	e426                	sd	s1,8(sp)
    80002368:	1000                	addi	s0,sp,32
    8000236a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000236c:	fffff097          	auipc	ra,0xfffff
    80002370:	8cc080e7          	jalr	-1844(ra) # 80000c38 <acquire>
  p->killed = 1;
    80002374:	4785                	li	a5,1
    80002376:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002378:	8526                	mv	a0,s1
    8000237a:	fffff097          	auipc	ra,0xfffff
    8000237e:	972080e7          	jalr	-1678(ra) # 80000cec <release>
}
    80002382:	60e2                	ld	ra,24(sp)
    80002384:	6442                	ld	s0,16(sp)
    80002386:	64a2                	ld	s1,8(sp)
    80002388:	6105                	addi	sp,sp,32
    8000238a:	8082                	ret

000000008000238c <killed>:

int
killed(struct proc *p)
{
    8000238c:	1101                	addi	sp,sp,-32
    8000238e:	ec06                	sd	ra,24(sp)
    80002390:	e822                	sd	s0,16(sp)
    80002392:	e426                	sd	s1,8(sp)
    80002394:	e04a                	sd	s2,0(sp)
    80002396:	1000                	addi	s0,sp,32
    80002398:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000239a:	fffff097          	auipc	ra,0xfffff
    8000239e:	89e080e7          	jalr	-1890(ra) # 80000c38 <acquire>
  k = p->killed;
    800023a2:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800023a6:	8526                	mv	a0,s1
    800023a8:	fffff097          	auipc	ra,0xfffff
    800023ac:	944080e7          	jalr	-1724(ra) # 80000cec <release>
  return k;
}
    800023b0:	854a                	mv	a0,s2
    800023b2:	60e2                	ld	ra,24(sp)
    800023b4:	6442                	ld	s0,16(sp)
    800023b6:	64a2                	ld	s1,8(sp)
    800023b8:	6902                	ld	s2,0(sp)
    800023ba:	6105                	addi	sp,sp,32
    800023bc:	8082                	ret

00000000800023be <wait>:
{
    800023be:	715d                	addi	sp,sp,-80
    800023c0:	e486                	sd	ra,72(sp)
    800023c2:	e0a2                	sd	s0,64(sp)
    800023c4:	fc26                	sd	s1,56(sp)
    800023c6:	f84a                	sd	s2,48(sp)
    800023c8:	f44e                	sd	s3,40(sp)
    800023ca:	f052                	sd	s4,32(sp)
    800023cc:	ec56                	sd	s5,24(sp)
    800023ce:	e85a                	sd	s6,16(sp)
    800023d0:	e45e                	sd	s7,8(sp)
    800023d2:	e062                	sd	s8,0(sp)
    800023d4:	0880                	addi	s0,sp,80
    800023d6:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    800023d8:	fffff097          	auipc	ra,0xfffff
    800023dc:	662080e7          	jalr	1634(ra) # 80001a3a <myproc>
    800023e0:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800023e2:	0000e517          	auipc	a0,0xe
    800023e6:	7c650513          	addi	a0,a0,1990 # 80010ba8 <wait_lock>
    800023ea:	fffff097          	auipc	ra,0xfffff
    800023ee:	84e080e7          	jalr	-1970(ra) # 80000c38 <acquire>
    havekids = 0;
    800023f2:	4b01                	li	s6,0
        if(pp->state == ZOMBIE){
    800023f4:	4a15                	li	s4,5
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800023f6:	00014997          	auipc	s3,0x14
    800023fa:	5ca98993          	addi	s3,s3,1482 # 800169c0 <tickslock>
        havekids = 1;
    800023fe:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002400:	0000ec17          	auipc	s8,0xe
    80002404:	7a8c0c13          	addi	s8,s8,1960 # 80010ba8 <wait_lock>
    havekids = 0;
    80002408:	875a                	mv	a4,s6
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000240a:	0000f497          	auipc	s1,0xf
    8000240e:	bb648493          	addi	s1,s1,-1098 # 80010fc0 <proc>
    80002412:	a0bd                	j	80002480 <wait+0xc2>
          pid = pp->pid;
    80002414:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002418:	000b8e63          	beqz	s7,80002434 <wait+0x76>
    8000241c:	4691                	li	a3,4
    8000241e:	02c48613          	addi	a2,s1,44
    80002422:	85de                	mv	a1,s7
    80002424:	05093503          	ld	a0,80(s2)
    80002428:	fffff097          	auipc	ra,0xfffff
    8000242c:	2b8080e7          	jalr	696(ra) # 800016e0 <copyout>
    80002430:	02054563          	bltz	a0,8000245a <wait+0x9c>
          freeproc(pp);
    80002434:	8526                	mv	a0,s1
    80002436:	fffff097          	auipc	ra,0xfffff
    8000243a:	7b8080e7          	jalr	1976(ra) # 80001bee <freeproc>
          release(&pp->lock);
    8000243e:	8526                	mv	a0,s1
    80002440:	fffff097          	auipc	ra,0xfffff
    80002444:	8ac080e7          	jalr	-1876(ra) # 80000cec <release>
          release(&wait_lock);
    80002448:	0000e517          	auipc	a0,0xe
    8000244c:	76050513          	addi	a0,a0,1888 # 80010ba8 <wait_lock>
    80002450:	fffff097          	auipc	ra,0xfffff
    80002454:	89c080e7          	jalr	-1892(ra) # 80000cec <release>
          return pid;
    80002458:	a0b5                	j	800024c4 <wait+0x106>
            release(&pp->lock);
    8000245a:	8526                	mv	a0,s1
    8000245c:	fffff097          	auipc	ra,0xfffff
    80002460:	890080e7          	jalr	-1904(ra) # 80000cec <release>
            release(&wait_lock);
    80002464:	0000e517          	auipc	a0,0xe
    80002468:	74450513          	addi	a0,a0,1860 # 80010ba8 <wait_lock>
    8000246c:	fffff097          	auipc	ra,0xfffff
    80002470:	880080e7          	jalr	-1920(ra) # 80000cec <release>
            return -1;
    80002474:	59fd                	li	s3,-1
    80002476:	a0b9                	j	800024c4 <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002478:	16848493          	addi	s1,s1,360
    8000247c:	03348463          	beq	s1,s3,800024a4 <wait+0xe6>
      if(pp->parent == p){
    80002480:	7c9c                	ld	a5,56(s1)
    80002482:	ff279be3          	bne	a5,s2,80002478 <wait+0xba>
        acquire(&pp->lock);
    80002486:	8526                	mv	a0,s1
    80002488:	ffffe097          	auipc	ra,0xffffe
    8000248c:	7b0080e7          	jalr	1968(ra) # 80000c38 <acquire>
        if(pp->state == ZOMBIE){
    80002490:	4c9c                	lw	a5,24(s1)
    80002492:	f94781e3          	beq	a5,s4,80002414 <wait+0x56>
        release(&pp->lock);
    80002496:	8526                	mv	a0,s1
    80002498:	fffff097          	auipc	ra,0xfffff
    8000249c:	854080e7          	jalr	-1964(ra) # 80000cec <release>
        havekids = 1;
    800024a0:	8756                	mv	a4,s5
    800024a2:	bfd9                	j	80002478 <wait+0xba>
    if(!havekids || killed(p)){
    800024a4:	c719                	beqz	a4,800024b2 <wait+0xf4>
    800024a6:	854a                	mv	a0,s2
    800024a8:	00000097          	auipc	ra,0x0
    800024ac:	ee4080e7          	jalr	-284(ra) # 8000238c <killed>
    800024b0:	c51d                	beqz	a0,800024de <wait+0x120>
      release(&wait_lock);
    800024b2:	0000e517          	auipc	a0,0xe
    800024b6:	6f650513          	addi	a0,a0,1782 # 80010ba8 <wait_lock>
    800024ba:	fffff097          	auipc	ra,0xfffff
    800024be:	832080e7          	jalr	-1998(ra) # 80000cec <release>
      return -1;
    800024c2:	59fd                	li	s3,-1
}
    800024c4:	854e                	mv	a0,s3
    800024c6:	60a6                	ld	ra,72(sp)
    800024c8:	6406                	ld	s0,64(sp)
    800024ca:	74e2                	ld	s1,56(sp)
    800024cc:	7942                	ld	s2,48(sp)
    800024ce:	79a2                	ld	s3,40(sp)
    800024d0:	7a02                	ld	s4,32(sp)
    800024d2:	6ae2                	ld	s5,24(sp)
    800024d4:	6b42                	ld	s6,16(sp)
    800024d6:	6ba2                	ld	s7,8(sp)
    800024d8:	6c02                	ld	s8,0(sp)
    800024da:	6161                	addi	sp,sp,80
    800024dc:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800024de:	85e2                	mv	a1,s8
    800024e0:	854a                	mv	a0,s2
    800024e2:	00000097          	auipc	ra,0x0
    800024e6:	c00080e7          	jalr	-1024(ra) # 800020e2 <sleep>
    havekids = 0;
    800024ea:	bf39                	j	80002408 <wait+0x4a>

00000000800024ec <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800024ec:	7179                	addi	sp,sp,-48
    800024ee:	f406                	sd	ra,40(sp)
    800024f0:	f022                	sd	s0,32(sp)
    800024f2:	ec26                	sd	s1,24(sp)
    800024f4:	e84a                	sd	s2,16(sp)
    800024f6:	e44e                	sd	s3,8(sp)
    800024f8:	e052                	sd	s4,0(sp)
    800024fa:	1800                	addi	s0,sp,48
    800024fc:	84aa                	mv	s1,a0
    800024fe:	892e                	mv	s2,a1
    80002500:	89b2                	mv	s3,a2
    80002502:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002504:	fffff097          	auipc	ra,0xfffff
    80002508:	536080e7          	jalr	1334(ra) # 80001a3a <myproc>
  if(user_dst){
    8000250c:	c08d                	beqz	s1,8000252e <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    8000250e:	86d2                	mv	a3,s4
    80002510:	864e                	mv	a2,s3
    80002512:	85ca                	mv	a1,s2
    80002514:	6928                	ld	a0,80(a0)
    80002516:	fffff097          	auipc	ra,0xfffff
    8000251a:	1ca080e7          	jalr	458(ra) # 800016e0 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000251e:	70a2                	ld	ra,40(sp)
    80002520:	7402                	ld	s0,32(sp)
    80002522:	64e2                	ld	s1,24(sp)
    80002524:	6942                	ld	s2,16(sp)
    80002526:	69a2                	ld	s3,8(sp)
    80002528:	6a02                	ld	s4,0(sp)
    8000252a:	6145                	addi	sp,sp,48
    8000252c:	8082                	ret
    memmove((char *)dst, src, len);
    8000252e:	000a061b          	sext.w	a2,s4
    80002532:	85ce                	mv	a1,s3
    80002534:	854a                	mv	a0,s2
    80002536:	fffff097          	auipc	ra,0xfffff
    8000253a:	86a080e7          	jalr	-1942(ra) # 80000da0 <memmove>
    return 0;
    8000253e:	8526                	mv	a0,s1
    80002540:	bff9                	j	8000251e <either_copyout+0x32>

0000000080002542 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002542:	7179                	addi	sp,sp,-48
    80002544:	f406                	sd	ra,40(sp)
    80002546:	f022                	sd	s0,32(sp)
    80002548:	ec26                	sd	s1,24(sp)
    8000254a:	e84a                	sd	s2,16(sp)
    8000254c:	e44e                	sd	s3,8(sp)
    8000254e:	e052                	sd	s4,0(sp)
    80002550:	1800                	addi	s0,sp,48
    80002552:	892a                	mv	s2,a0
    80002554:	84ae                	mv	s1,a1
    80002556:	89b2                	mv	s3,a2
    80002558:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000255a:	fffff097          	auipc	ra,0xfffff
    8000255e:	4e0080e7          	jalr	1248(ra) # 80001a3a <myproc>
  if(user_src){
    80002562:	c08d                	beqz	s1,80002584 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80002564:	86d2                	mv	a3,s4
    80002566:	864e                	mv	a2,s3
    80002568:	85ca                	mv	a1,s2
    8000256a:	6928                	ld	a0,80(a0)
    8000256c:	fffff097          	auipc	ra,0xfffff
    80002570:	200080e7          	jalr	512(ra) # 8000176c <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002574:	70a2                	ld	ra,40(sp)
    80002576:	7402                	ld	s0,32(sp)
    80002578:	64e2                	ld	s1,24(sp)
    8000257a:	6942                	ld	s2,16(sp)
    8000257c:	69a2                	ld	s3,8(sp)
    8000257e:	6a02                	ld	s4,0(sp)
    80002580:	6145                	addi	sp,sp,48
    80002582:	8082                	ret
    memmove(dst, (char*)src, len);
    80002584:	000a061b          	sext.w	a2,s4
    80002588:	85ce                	mv	a1,s3
    8000258a:	854a                	mv	a0,s2
    8000258c:	fffff097          	auipc	ra,0xfffff
    80002590:	814080e7          	jalr	-2028(ra) # 80000da0 <memmove>
    return 0;
    80002594:	8526                	mv	a0,s1
    80002596:	bff9                	j	80002574 <either_copyin+0x32>

0000000080002598 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002598:	715d                	addi	sp,sp,-80
    8000259a:	e486                	sd	ra,72(sp)
    8000259c:	e0a2                	sd	s0,64(sp)
    8000259e:	fc26                	sd	s1,56(sp)
    800025a0:	f84a                	sd	s2,48(sp)
    800025a2:	f44e                	sd	s3,40(sp)
    800025a4:	f052                	sd	s4,32(sp)
    800025a6:	ec56                	sd	s5,24(sp)
    800025a8:	e85a                	sd	s6,16(sp)
    800025aa:	e45e                	sd	s7,8(sp)
    800025ac:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800025ae:	00006517          	auipc	a0,0x6
    800025b2:	b1a50513          	addi	a0,a0,-1254 # 800080c8 <digits+0xb0>
    800025b6:	ffffe097          	auipc	ra,0xffffe
    800025ba:	000080e7          	jalr	ra # 800005b6 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800025be:	0000f497          	auipc	s1,0xf
    800025c2:	b5a48493          	addi	s1,s1,-1190 # 80011118 <proc+0x158>
    800025c6:	00014917          	auipc	s2,0x14
    800025ca:	55290913          	addi	s2,s2,1362 # 80016b18 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800025ce:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800025d0:	00006997          	auipc	s3,0x6
    800025d4:	ce098993          	addi	s3,s3,-800 # 800082b0 <states.1742+0xd8>
    printf("%d %s %s", p->pid, state, p->name);
    800025d8:	00006a97          	auipc	s5,0x6
    800025dc:	ce0a8a93          	addi	s5,s5,-800 # 800082b8 <states.1742+0xe0>
    printf("\n");
    800025e0:	00006a17          	auipc	s4,0x6
    800025e4:	ae8a0a13          	addi	s4,s4,-1304 # 800080c8 <digits+0xb0>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800025e8:	00006b97          	auipc	s7,0x6
    800025ec:	bf0b8b93          	addi	s7,s7,-1040 # 800081d8 <states.1742>
    800025f0:	a015                	j	80002614 <procdump+0x7c>
    printf("%d %s %s", p->pid, state, p->name);
    800025f2:	86ba                	mv	a3,a4
    800025f4:	ed872583          	lw	a1,-296(a4)
    800025f8:	8556                	mv	a0,s5
    800025fa:	ffffe097          	auipc	ra,0xffffe
    800025fe:	fbc080e7          	jalr	-68(ra) # 800005b6 <printf>
    printf("\n");
    80002602:	8552                	mv	a0,s4
    80002604:	ffffe097          	auipc	ra,0xffffe
    80002608:	fb2080e7          	jalr	-78(ra) # 800005b6 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000260c:	16848493          	addi	s1,s1,360
    80002610:	03248163          	beq	s1,s2,80002632 <procdump+0x9a>
    if(p->state == UNUSED)
    80002614:	8726                	mv	a4,s1
    80002616:	ec04a783          	lw	a5,-320(s1)
    8000261a:	dbed                	beqz	a5,8000260c <procdump+0x74>
      state = "???";
    8000261c:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000261e:	fcfb6ae3          	bltu	s6,a5,800025f2 <procdump+0x5a>
    80002622:	1782                	slli	a5,a5,0x20
    80002624:	9381                	srli	a5,a5,0x20
    80002626:	078e                	slli	a5,a5,0x3
    80002628:	97de                	add	a5,a5,s7
    8000262a:	6390                	ld	a2,0(a5)
    8000262c:	f279                	bnez	a2,800025f2 <procdump+0x5a>
      state = "???";
    8000262e:	864e                	mv	a2,s3
    80002630:	b7c9                	j	800025f2 <procdump+0x5a>
  }
}
    80002632:	60a6                	ld	ra,72(sp)
    80002634:	6406                	ld	s0,64(sp)
    80002636:	74e2                	ld	s1,56(sp)
    80002638:	7942                	ld	s2,48(sp)
    8000263a:	79a2                	ld	s3,40(sp)
    8000263c:	7a02                	ld	s4,32(sp)
    8000263e:	6ae2                	ld	s5,24(sp)
    80002640:	6b42                	ld	s6,16(sp)
    80002642:	6ba2                	ld	s7,8(sp)
    80002644:	6161                	addi	sp,sp,80
    80002646:	8082                	ret

0000000080002648 <swtch>:
    80002648:	00153023          	sd	ra,0(a0)
    8000264c:	00253423          	sd	sp,8(a0)
    80002650:	e900                	sd	s0,16(a0)
    80002652:	ed04                	sd	s1,24(a0)
    80002654:	03253023          	sd	s2,32(a0)
    80002658:	03353423          	sd	s3,40(a0)
    8000265c:	03453823          	sd	s4,48(a0)
    80002660:	03553c23          	sd	s5,56(a0)
    80002664:	05653023          	sd	s6,64(a0)
    80002668:	05753423          	sd	s7,72(a0)
    8000266c:	05853823          	sd	s8,80(a0)
    80002670:	05953c23          	sd	s9,88(a0)
    80002674:	07a53023          	sd	s10,96(a0)
    80002678:	07b53423          	sd	s11,104(a0)
    8000267c:	0005b083          	ld	ra,0(a1)
    80002680:	0085b103          	ld	sp,8(a1)
    80002684:	6980                	ld	s0,16(a1)
    80002686:	6d84                	ld	s1,24(a1)
    80002688:	0205b903          	ld	s2,32(a1)
    8000268c:	0285b983          	ld	s3,40(a1)
    80002690:	0305ba03          	ld	s4,48(a1)
    80002694:	0385ba83          	ld	s5,56(a1)
    80002698:	0405bb03          	ld	s6,64(a1)
    8000269c:	0485bb83          	ld	s7,72(a1)
    800026a0:	0505bc03          	ld	s8,80(a1)
    800026a4:	0585bc83          	ld	s9,88(a1)
    800026a8:	0605bd03          	ld	s10,96(a1)
    800026ac:	0685bd83          	ld	s11,104(a1)
    800026b0:	8082                	ret

00000000800026b2 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800026b2:	1141                	addi	sp,sp,-16
    800026b4:	e406                	sd	ra,8(sp)
    800026b6:	e022                	sd	s0,0(sp)
    800026b8:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800026ba:	00006597          	auipc	a1,0x6
    800026be:	c3e58593          	addi	a1,a1,-962 # 800082f8 <states.1742+0x120>
    800026c2:	00014517          	auipc	a0,0x14
    800026c6:	2fe50513          	addi	a0,a0,766 # 800169c0 <tickslock>
    800026ca:	ffffe097          	auipc	ra,0xffffe
    800026ce:	4de080e7          	jalr	1246(ra) # 80000ba8 <initlock>
}
    800026d2:	60a2                	ld	ra,8(sp)
    800026d4:	6402                	ld	s0,0(sp)
    800026d6:	0141                	addi	sp,sp,16
    800026d8:	8082                	ret

00000000800026da <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800026da:	1141                	addi	sp,sp,-16
    800026dc:	e422                	sd	s0,8(sp)
    800026de:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800026e0:	00003797          	auipc	a5,0x3
    800026e4:	66078793          	addi	a5,a5,1632 # 80005d40 <kernelvec>
    800026e8:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800026ec:	6422                	ld	s0,8(sp)
    800026ee:	0141                	addi	sp,sp,16
    800026f0:	8082                	ret

00000000800026f2 <add_ref>:

//
// handle an interrupt, exception, or system call from user space.
// called from trampoline.S
//
void add_ref(void *pa) {
    800026f2:	1141                	addi	sp,sp,-16
    800026f4:	e422                	sd	s0,8(sp)
    800026f6:	0800                	addi	s0,sp,16
    return;
   }
   
//efc[index]=refc[index]+1;refc
index=index+1;
}
    800026f8:	6422                	ld	s0,8(sp)
    800026fa:	0141                	addi	sp,sp,16
    800026fc:	8082                	ret

00000000800026fe <dec_ref>:
void dec_ref(void *pa) {
    800026fe:	1141                	addi	sp,sp,-16
    80002700:	e422                	sd	s0,8(sp)
    80002702:	0800                	addi	s0,sp,16
  index = cur_count-1;
//if ([index] == 0) { //refc
  if(index == 0) {
    dec_ref(pa);
  }
}
    80002704:	6422                	ld	s0,8(sp)
    80002706:	0141                	addi	sp,sp,16
    80002708:	8082                	ret

000000008000270a <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    8000270a:	1141                	addi	sp,sp,-16
    8000270c:	e406                	sd	ra,8(sp)
    8000270e:	e022                	sd	s0,0(sp)
    80002710:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002712:	fffff097          	auipc	ra,0xfffff
    80002716:	328080e7          	jalr	808(ra) # 80001a3a <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000271a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000271e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002720:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002724:	00005617          	auipc	a2,0x5
    80002728:	8dc60613          	addi	a2,a2,-1828 # 80007000 <_trampoline>
    8000272c:	00005697          	auipc	a3,0x5
    80002730:	8d468693          	addi	a3,a3,-1836 # 80007000 <_trampoline>
    80002734:	8e91                	sub	a3,a3,a2
    80002736:	040007b7          	lui	a5,0x4000
    8000273a:	17fd                	addi	a5,a5,-1
    8000273c:	07b2                	slli	a5,a5,0xc
    8000273e:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002740:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002744:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002746:	180026f3          	csrr	a3,satp
    8000274a:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000274c:	6d38                	ld	a4,88(a0)
    8000274e:	6134                	ld	a3,64(a0)
    80002750:	6585                	lui	a1,0x1
    80002752:	96ae                	add	a3,a3,a1
    80002754:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002756:	6d38                	ld	a4,88(a0)
    80002758:	00000697          	auipc	a3,0x0
    8000275c:	13068693          	addi	a3,a3,304 # 80002888 <usertrap>
    80002760:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002762:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002764:	8692                	mv	a3,tp
    80002766:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002768:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000276c:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002770:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002774:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002778:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000277a:	6f18                	ld	a4,24(a4)
    8000277c:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002780:	6928                	ld	a0,80(a0)
    80002782:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002784:	00005717          	auipc	a4,0x5
    80002788:	91870713          	addi	a4,a4,-1768 # 8000709c <userret>
    8000278c:	8f11                	sub	a4,a4,a2
    8000278e:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002790:	577d                	li	a4,-1
    80002792:	177e                	slli	a4,a4,0x3f
    80002794:	8d59                	or	a0,a0,a4
    80002796:	9782                	jalr	a5
}
    80002798:	60a2                	ld	ra,8(sp)
    8000279a:	6402                	ld	s0,0(sp)
    8000279c:	0141                	addi	sp,sp,16
    8000279e:	8082                	ret

00000000800027a0 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800027a0:	1101                	addi	sp,sp,-32
    800027a2:	ec06                	sd	ra,24(sp)
    800027a4:	e822                	sd	s0,16(sp)
    800027a6:	e426                	sd	s1,8(sp)
    800027a8:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    800027aa:	00014497          	auipc	s1,0x14
    800027ae:	21648493          	addi	s1,s1,534 # 800169c0 <tickslock>
    800027b2:	8526                	mv	a0,s1
    800027b4:	ffffe097          	auipc	ra,0xffffe
    800027b8:	484080e7          	jalr	1156(ra) # 80000c38 <acquire>
  ticks++;
    800027bc:	00006517          	auipc	a0,0x6
    800027c0:	16450513          	addi	a0,a0,356 # 80008920 <ticks>
    800027c4:	411c                	lw	a5,0(a0)
    800027c6:	2785                	addiw	a5,a5,1
    800027c8:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    800027ca:	00000097          	auipc	ra,0x0
    800027ce:	97c080e7          	jalr	-1668(ra) # 80002146 <wakeup>
  release(&tickslock);
    800027d2:	8526                	mv	a0,s1
    800027d4:	ffffe097          	auipc	ra,0xffffe
    800027d8:	518080e7          	jalr	1304(ra) # 80000cec <release>
}
    800027dc:	60e2                	ld	ra,24(sp)
    800027de:	6442                	ld	s0,16(sp)
    800027e0:	64a2                	ld	s1,8(sp)
    800027e2:	6105                	addi	sp,sp,32
    800027e4:	8082                	ret

00000000800027e6 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800027e6:	1101                	addi	sp,sp,-32
    800027e8:	ec06                	sd	ra,24(sp)
    800027ea:	e822                	sd	s0,16(sp)
    800027ec:	e426                	sd	s1,8(sp)
    800027ee:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800027f0:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    800027f4:	00074d63          	bltz	a4,8000280e <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    800027f8:	57fd                	li	a5,-1
    800027fa:	17fe                	slli	a5,a5,0x3f
    800027fc:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    800027fe:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80002800:	06f70363          	beq	a4,a5,80002866 <devintr+0x80>
  }
}
    80002804:	60e2                	ld	ra,24(sp)
    80002806:	6442                	ld	s0,16(sp)
    80002808:	64a2                	ld	s1,8(sp)
    8000280a:	6105                	addi	sp,sp,32
    8000280c:	8082                	ret
     (scause & 0xff) == 9){
    8000280e:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80002812:	46a5                	li	a3,9
    80002814:	fed792e3          	bne	a5,a3,800027f8 <devintr+0x12>
    int irq = plic_claim();
    80002818:	00003097          	auipc	ra,0x3
    8000281c:	630080e7          	jalr	1584(ra) # 80005e48 <plic_claim>
    80002820:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002822:	47a9                	li	a5,10
    80002824:	02f50763          	beq	a0,a5,80002852 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80002828:	4785                	li	a5,1
    8000282a:	02f50963          	beq	a0,a5,8000285c <devintr+0x76>
    return 1;
    8000282e:	4505                	li	a0,1
    } else if(irq){
    80002830:	d8f1                	beqz	s1,80002804 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80002832:	85a6                	mv	a1,s1
    80002834:	00006517          	auipc	a0,0x6
    80002838:	acc50513          	addi	a0,a0,-1332 # 80008300 <states.1742+0x128>
    8000283c:	ffffe097          	auipc	ra,0xffffe
    80002840:	d7a080e7          	jalr	-646(ra) # 800005b6 <printf>
      plic_complete(irq);
    80002844:	8526                	mv	a0,s1
    80002846:	00003097          	auipc	ra,0x3
    8000284a:	626080e7          	jalr	1574(ra) # 80005e6c <plic_complete>
    return 1;
    8000284e:	4505                	li	a0,1
    80002850:	bf55                	j	80002804 <devintr+0x1e>
      uartintr();
    80002852:	ffffe097          	auipc	ra,0xffffe
    80002856:	1a6080e7          	jalr	422(ra) # 800009f8 <uartintr>
    8000285a:	b7ed                	j	80002844 <devintr+0x5e>
      virtio_disk_intr();
    8000285c:	00004097          	auipc	ra,0x4
    80002860:	b48080e7          	jalr	-1208(ra) # 800063a4 <virtio_disk_intr>
    80002864:	b7c5                	j	80002844 <devintr+0x5e>
    if(cpuid() == 0){
    80002866:	fffff097          	auipc	ra,0xfffff
    8000286a:	1a8080e7          	jalr	424(ra) # 80001a0e <cpuid>
    8000286e:	c901                	beqz	a0,8000287e <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002870:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002874:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002876:	14479073          	csrw	sip,a5
    return 2;
    8000287a:	4509                	li	a0,2
    8000287c:	b761                	j	80002804 <devintr+0x1e>
      clockintr();
    8000287e:	00000097          	auipc	ra,0x0
    80002882:	f22080e7          	jalr	-222(ra) # 800027a0 <clockintr>
    80002886:	b7ed                	j	80002870 <devintr+0x8a>

0000000080002888 <usertrap>:
{
    80002888:	7139                	addi	sp,sp,-64
    8000288a:	fc06                	sd	ra,56(sp)
    8000288c:	f822                	sd	s0,48(sp)
    8000288e:	f426                	sd	s1,40(sp)
    80002890:	f04a                	sd	s2,32(sp)
    80002892:	ec4e                	sd	s3,24(sp)
    80002894:	e852                	sd	s4,16(sp)
    80002896:	e456                	sd	s5,8(sp)
    80002898:	0080                	addi	s0,sp,64
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000289a:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    8000289e:	1007f793          	andi	a5,a5,256
    800028a2:	eba9                	bnez	a5,800028f4 <usertrap+0x6c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800028a4:	00003797          	auipc	a5,0x3
    800028a8:	49c78793          	addi	a5,a5,1180 # 80005d40 <kernelvec>
    800028ac:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800028b0:	fffff097          	auipc	ra,0xfffff
    800028b4:	18a080e7          	jalr	394(ra) # 80001a3a <myproc>
    800028b8:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800028ba:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800028bc:	14102773          	csrr	a4,sepc
    800028c0:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800028c2:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800028c6:	47a1                	li	a5,8
    800028c8:	02f70e63          	beq	a4,a5,80002904 <usertrap+0x7c>
    800028cc:	14202773          	csrr	a4,scause
  else if(r_scause()==15){
    800028d0:	47bd                	li	a5,15
    800028d2:	06f70363          	beq	a4,a5,80002938 <usertrap+0xb0>
  else if((which_dev = devintr()) != 0){
    800028d6:	00000097          	auipc	ra,0x0
    800028da:	f10080e7          	jalr	-240(ra) # 800027e6 <devintr>
    800028de:	892a                	mv	s2,a0
    800028e0:	10050d63          	beqz	a0,800029fa <usertrap+0x172>
  if(killed(p))
    800028e4:	8526                	mv	a0,s1
    800028e6:	00000097          	auipc	ra,0x0
    800028ea:	aa6080e7          	jalr	-1370(ra) # 8000238c <killed>
    800028ee:	14050963          	beqz	a0,80002a40 <usertrap+0x1b8>
    800028f2:	a291                	j	80002a36 <usertrap+0x1ae>
    panic("usertrap: not from user mode");
    800028f4:	00006517          	auipc	a0,0x6
    800028f8:	a2c50513          	addi	a0,a0,-1492 # 80008320 <states.1742+0x148>
    800028fc:	ffffe097          	auipc	ra,0xffffe
    80002900:	c70080e7          	jalr	-912(ra) # 8000056c <panic>
    if(killed(p))
    80002904:	00000097          	auipc	ra,0x0
    80002908:	a88080e7          	jalr	-1400(ra) # 8000238c <killed>
    8000290c:	e105                	bnez	a0,8000292c <usertrap+0xa4>
    p->trapframe->epc += 4;
    8000290e:	6cb8                	ld	a4,88(s1)
    80002910:	6f1c                	ld	a5,24(a4)
    80002912:	0791                	addi	a5,a5,4
    80002914:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002916:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000291a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000291e:	10079073          	csrw	sstatus,a5
    syscall();
    80002922:	00000097          	auipc	ra,0x0
    80002926:	37e080e7          	jalr	894(ra) # 80002ca0 <syscall>
    8000292a:	a825                	j	80002962 <usertrap+0xda>
      exit(-1);
    8000292c:	557d                	li	a0,-1
    8000292e:	00000097          	auipc	ra,0x0
    80002932:	8e8080e7          	jalr	-1816(ra) # 80002216 <exit>
    80002936:	bfe1                	j	8000290e <usertrap+0x86>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002938:	14302973          	csrr	s2,stval
    uint64 start_va = PGROUNDDOWN(r_stval());
    8000293c:	77fd                	lui	a5,0xfffff
    8000293e:	00f97933          	and	s2,s2,a5
    pte = walk(p->pagetable, start_va, 0);
    80002942:	4601                	li	a2,0
    80002944:	85ca                	mv	a1,s2
    80002946:	6928                	ld	a0,80(a0)
    80002948:	ffffe097          	auipc	ra,0xffffe
    8000294c:	6fc080e7          	jalr	1788(ra) # 80001044 <walk>
    80002950:	89aa                	mv	s3,a0
    if (pte == 0) {
    80002952:	c91d                	beqz	a0,80002988 <usertrap+0x100>
    if ((*pte & PTE_V) && (*pte & PTE_U) && (*pte & PTE_R)) { //ptersw
    80002954:	0009ba03          	ld	s4,0(s3)
    80002958:	013a7713          	andi	a4,s4,19
    8000295c:	47cd                	li	a5,19
    8000295e:	04f70063          	beq	a4,a5,8000299e <usertrap+0x116>
  if(killed(p))
    80002962:	8526                	mv	a0,s1
    80002964:	00000097          	auipc	ra,0x0
    80002968:	a28080e7          	jalr	-1496(ra) # 8000238c <killed>
    8000296c:	e561                	bnez	a0,80002a34 <usertrap+0x1ac>
  usertrapret();
    8000296e:	00000097          	auipc	ra,0x0
    80002972:	d9c080e7          	jalr	-612(ra) # 8000270a <usertrapret>
}
    80002976:	70e2                	ld	ra,56(sp)
    80002978:	7442                	ld	s0,48(sp)
    8000297a:	74a2                	ld	s1,40(sp)
    8000297c:	7902                	ld	s2,32(sp)
    8000297e:	69e2                	ld	s3,24(sp)
    80002980:	6a42                	ld	s4,16(sp)
    80002982:	6aa2                	ld	s5,8(sp)
    80002984:	6121                	addi	sp,sp,64
    80002986:	8082                	ret
      printf("pge not found\n");
    80002988:	00006517          	auipc	a0,0x6
    8000298c:	9b850513          	addi	a0,a0,-1608 # 80008340 <states.1742+0x168>
    80002990:	ffffe097          	auipc	ra,0xffffe
    80002994:	c26080e7          	jalr	-986(ra) # 800005b6 <printf>
      p->killed = 1;
    80002998:	4785                	li	a5,1
    8000299a:	d49c                	sw	a5,40(s1)
    8000299c:	bf65                	j	80002954 <usertrap+0xcc>
      char *mem = kalloc();
    8000299e:	ffffe097          	auipc	ra,0xffffe
    800029a2:	1aa080e7          	jalr	426(ra) # 80000b48 <kalloc>
    800029a6:	8aaa                	mv	s5,a0
      char *pa = (char *)PTE2PA(*pte);
    800029a8:	0009b583          	ld	a1,0(s3)
    800029ac:	81a9                	srli	a1,a1,0xa
      memmove(mem, pa, PGSIZE);
    800029ae:	6605                	lui	a2,0x1
    800029b0:	05b2                	slli	a1,a1,0xc
    800029b2:	ffffe097          	auipc	ra,0xffffe
    800029b6:	3ee080e7          	jalr	1006(ra) # 80000da0 <memmove>
      uvmunmap(p->pagetable, start_va, PGSIZE, 0);
    800029ba:	4681                	li	a3,0
    800029bc:	6605                	lui	a2,0x1
    800029be:	85ca                	mv	a1,s2
    800029c0:	68a8                	ld	a0,80(s1)
    800029c2:	fffff097          	auipc	ra,0xfffff
    800029c6:	92e080e7          	jalr	-1746(ra) # 800012f0 <uvmunmap>
      flags &= (~PTE_R); //rsw
    800029ca:	3fda7713          	andi	a4,s4,1021
      if (mappages(p->pagetable, start_va, PGSIZE, (uint64)mem, flags) != 0) {
    800029ce:	00476713          	ori	a4,a4,4
    800029d2:	86d6                	mv	a3,s5
    800029d4:	6605                	lui	a2,0x1
    800029d6:	85ca                	mv	a1,s2
    800029d8:	68a8                	ld	a0,80(s1)
    800029da:	ffffe097          	auipc	ra,0xffffe
    800029de:	752080e7          	jalr	1874(ra) # 8000112c <mappages>
    800029e2:	d141                	beqz	a0,80002962 <usertrap+0xda>
      p->killed = 1;
    800029e4:	4785                	li	a5,1
    800029e6:	d49c                	sw	a5,40(s1)
      printf("ometthing is wrong in mappages in trap.\n");
    800029e8:	00006517          	auipc	a0,0x6
    800029ec:	96850513          	addi	a0,a0,-1688 # 80008350 <states.1742+0x178>
    800029f0:	ffffe097          	auipc	ra,0xffffe
    800029f4:	bc6080e7          	jalr	-1082(ra) # 800005b6 <printf>
    800029f8:	b7ad                	j	80002962 <usertrap+0xda>
  asm volatile("csrr %0, scause" : "=r" (x) );
    800029fa:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    800029fe:	5890                	lw	a2,48(s1)
    80002a00:	00006517          	auipc	a0,0x6
    80002a04:	98050513          	addi	a0,a0,-1664 # 80008380 <states.1742+0x1a8>
    80002a08:	ffffe097          	auipc	ra,0xffffe
    80002a0c:	bae080e7          	jalr	-1106(ra) # 800005b6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a10:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002a14:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002a18:	00006517          	auipc	a0,0x6
    80002a1c:	99850513          	addi	a0,a0,-1640 # 800083b0 <states.1742+0x1d8>
    80002a20:	ffffe097          	auipc	ra,0xffffe
    80002a24:	b96080e7          	jalr	-1130(ra) # 800005b6 <printf>
    setkilled(p);
    80002a28:	8526                	mv	a0,s1
    80002a2a:	00000097          	auipc	ra,0x0
    80002a2e:	936080e7          	jalr	-1738(ra) # 80002360 <setkilled>
    80002a32:	bf05                	j	80002962 <usertrap+0xda>
  if(killed(p))
    80002a34:	4901                	li	s2,0
    exit(-1);
    80002a36:	557d                	li	a0,-1
    80002a38:	fffff097          	auipc	ra,0xfffff
    80002a3c:	7de080e7          	jalr	2014(ra) # 80002216 <exit>
  if(which_dev == 2)
    80002a40:	4789                	li	a5,2
    80002a42:	f2f916e3          	bne	s2,a5,8000296e <usertrap+0xe6>
    yield();
    80002a46:	fffff097          	auipc	ra,0xfffff
    80002a4a:	660080e7          	jalr	1632(ra) # 800020a6 <yield>
    80002a4e:	b705                	j	8000296e <usertrap+0xe6>

0000000080002a50 <kerneltrap>:
{
    80002a50:	7179                	addi	sp,sp,-48
    80002a52:	f406                	sd	ra,40(sp)
    80002a54:	f022                	sd	s0,32(sp)
    80002a56:	ec26                	sd	s1,24(sp)
    80002a58:	e84a                	sd	s2,16(sp)
    80002a5a:	e44e                	sd	s3,8(sp)
    80002a5c:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a5e:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a62:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002a66:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002a6a:	1004f793          	andi	a5,s1,256
    80002a6e:	cb85                	beqz	a5,80002a9e <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a70:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002a74:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002a76:	ef85                	bnez	a5,80002aae <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002a78:	00000097          	auipc	ra,0x0
    80002a7c:	d6e080e7          	jalr	-658(ra) # 800027e6 <devintr>
    80002a80:	cd1d                	beqz	a0,80002abe <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002a82:	4789                	li	a5,2
    80002a84:	06f50a63          	beq	a0,a5,80002af8 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002a88:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002a8c:	10049073          	csrw	sstatus,s1
}
    80002a90:	70a2                	ld	ra,40(sp)
    80002a92:	7402                	ld	s0,32(sp)
    80002a94:	64e2                	ld	s1,24(sp)
    80002a96:	6942                	ld	s2,16(sp)
    80002a98:	69a2                	ld	s3,8(sp)
    80002a9a:	6145                	addi	sp,sp,48
    80002a9c:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002a9e:	00006517          	auipc	a0,0x6
    80002aa2:	93250513          	addi	a0,a0,-1742 # 800083d0 <states.1742+0x1f8>
    80002aa6:	ffffe097          	auipc	ra,0xffffe
    80002aaa:	ac6080e7          	jalr	-1338(ra) # 8000056c <panic>
    panic("kerneltrap: interrupts enabled");
    80002aae:	00006517          	auipc	a0,0x6
    80002ab2:	94a50513          	addi	a0,a0,-1718 # 800083f8 <states.1742+0x220>
    80002ab6:	ffffe097          	auipc	ra,0xffffe
    80002aba:	ab6080e7          	jalr	-1354(ra) # 8000056c <panic>
    printf("scause %p\n", scause);
    80002abe:	85ce                	mv	a1,s3
    80002ac0:	00006517          	auipc	a0,0x6
    80002ac4:	95850513          	addi	a0,a0,-1704 # 80008418 <states.1742+0x240>
    80002ac8:	ffffe097          	auipc	ra,0xffffe
    80002acc:	aee080e7          	jalr	-1298(ra) # 800005b6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002ad0:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002ad4:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002ad8:	00006517          	auipc	a0,0x6
    80002adc:	95050513          	addi	a0,a0,-1712 # 80008428 <states.1742+0x250>
    80002ae0:	ffffe097          	auipc	ra,0xffffe
    80002ae4:	ad6080e7          	jalr	-1322(ra) # 800005b6 <printf>
    panic("kerneltrap");
    80002ae8:	00006517          	auipc	a0,0x6
    80002aec:	95850513          	addi	a0,a0,-1704 # 80008440 <states.1742+0x268>
    80002af0:	ffffe097          	auipc	ra,0xffffe
    80002af4:	a7c080e7          	jalr	-1412(ra) # 8000056c <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002af8:	fffff097          	auipc	ra,0xfffff
    80002afc:	f42080e7          	jalr	-190(ra) # 80001a3a <myproc>
    80002b00:	d541                	beqz	a0,80002a88 <kerneltrap+0x38>
    80002b02:	fffff097          	auipc	ra,0xfffff
    80002b06:	f38080e7          	jalr	-200(ra) # 80001a3a <myproc>
    80002b0a:	4d18                	lw	a4,24(a0)
    80002b0c:	4791                	li	a5,4
    80002b0e:	f6f71de3          	bne	a4,a5,80002a88 <kerneltrap+0x38>
    yield();
    80002b12:	fffff097          	auipc	ra,0xfffff
    80002b16:	594080e7          	jalr	1428(ra) # 800020a6 <yield>
    80002b1a:	b7bd                	j	80002a88 <kerneltrap+0x38>

0000000080002b1c <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002b1c:	1101                	addi	sp,sp,-32
    80002b1e:	ec06                	sd	ra,24(sp)
    80002b20:	e822                	sd	s0,16(sp)
    80002b22:	e426                	sd	s1,8(sp)
    80002b24:	1000                	addi	s0,sp,32
    80002b26:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002b28:	fffff097          	auipc	ra,0xfffff
    80002b2c:	f12080e7          	jalr	-238(ra) # 80001a3a <myproc>
  switch (n) {
    80002b30:	4795                	li	a5,5
    80002b32:	0497e363          	bltu	a5,s1,80002b78 <argraw+0x5c>
    80002b36:	1482                	slli	s1,s1,0x20
    80002b38:	9081                	srli	s1,s1,0x20
    80002b3a:	048a                	slli	s1,s1,0x2
    80002b3c:	00006717          	auipc	a4,0x6
    80002b40:	91470713          	addi	a4,a4,-1772 # 80008450 <states.1742+0x278>
    80002b44:	94ba                	add	s1,s1,a4
    80002b46:	409c                	lw	a5,0(s1)
    80002b48:	97ba                	add	a5,a5,a4
    80002b4a:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002b4c:	6d3c                	ld	a5,88(a0)
    80002b4e:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002b50:	60e2                	ld	ra,24(sp)
    80002b52:	6442                	ld	s0,16(sp)
    80002b54:	64a2                	ld	s1,8(sp)
    80002b56:	6105                	addi	sp,sp,32
    80002b58:	8082                	ret
    return p->trapframe->a1;
    80002b5a:	6d3c                	ld	a5,88(a0)
    80002b5c:	7fa8                	ld	a0,120(a5)
    80002b5e:	bfcd                	j	80002b50 <argraw+0x34>
    return p->trapframe->a2;
    80002b60:	6d3c                	ld	a5,88(a0)
    80002b62:	63c8                	ld	a0,128(a5)
    80002b64:	b7f5                	j	80002b50 <argraw+0x34>
    return p->trapframe->a3;
    80002b66:	6d3c                	ld	a5,88(a0)
    80002b68:	67c8                	ld	a0,136(a5)
    80002b6a:	b7dd                	j	80002b50 <argraw+0x34>
    return p->trapframe->a4;
    80002b6c:	6d3c                	ld	a5,88(a0)
    80002b6e:	6bc8                	ld	a0,144(a5)
    80002b70:	b7c5                	j	80002b50 <argraw+0x34>
    return p->trapframe->a5;
    80002b72:	6d3c                	ld	a5,88(a0)
    80002b74:	6fc8                	ld	a0,152(a5)
    80002b76:	bfe9                	j	80002b50 <argraw+0x34>
  panic("argraw");
    80002b78:	00006517          	auipc	a0,0x6
    80002b7c:	9a050513          	addi	a0,a0,-1632 # 80008518 <syscalls+0xb0>
    80002b80:	ffffe097          	auipc	ra,0xffffe
    80002b84:	9ec080e7          	jalr	-1556(ra) # 8000056c <panic>

0000000080002b88 <fetchaddr>:
{
    80002b88:	1101                	addi	sp,sp,-32
    80002b8a:	ec06                	sd	ra,24(sp)
    80002b8c:	e822                	sd	s0,16(sp)
    80002b8e:	e426                	sd	s1,8(sp)
    80002b90:	e04a                	sd	s2,0(sp)
    80002b92:	1000                	addi	s0,sp,32
    80002b94:	84aa                	mv	s1,a0
    80002b96:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002b98:	fffff097          	auipc	ra,0xfffff
    80002b9c:	ea2080e7          	jalr	-350(ra) # 80001a3a <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002ba0:	653c                	ld	a5,72(a0)
    80002ba2:	02f4f963          	bgeu	s1,a5,80002bd4 <fetchaddr+0x4c>
    80002ba6:	00848713          	addi	a4,s1,8
    80002baa:	02e7e763          	bltu	a5,a4,80002bd8 <fetchaddr+0x50>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002bae:	46a1                	li	a3,8
    80002bb0:	8626                	mv	a2,s1
    80002bb2:	85ca                	mv	a1,s2
    80002bb4:	6928                	ld	a0,80(a0)
    80002bb6:	fffff097          	auipc	ra,0xfffff
    80002bba:	bb6080e7          	jalr	-1098(ra) # 8000176c <copyin>
    80002bbe:	00a03533          	snez	a0,a0
    80002bc2:	40a0053b          	negw	a0,a0
    80002bc6:	2501                	sext.w	a0,a0
}
    80002bc8:	60e2                	ld	ra,24(sp)
    80002bca:	6442                	ld	s0,16(sp)
    80002bcc:	64a2                	ld	s1,8(sp)
    80002bce:	6902                	ld	s2,0(sp)
    80002bd0:	6105                	addi	sp,sp,32
    80002bd2:	8082                	ret
    return -1;
    80002bd4:	557d                	li	a0,-1
    80002bd6:	bfcd                	j	80002bc8 <fetchaddr+0x40>
    80002bd8:	557d                	li	a0,-1
    80002bda:	b7fd                	j	80002bc8 <fetchaddr+0x40>

0000000080002bdc <fetchstr>:
{
    80002bdc:	7179                	addi	sp,sp,-48
    80002bde:	f406                	sd	ra,40(sp)
    80002be0:	f022                	sd	s0,32(sp)
    80002be2:	ec26                	sd	s1,24(sp)
    80002be4:	e84a                	sd	s2,16(sp)
    80002be6:	e44e                	sd	s3,8(sp)
    80002be8:	1800                	addi	s0,sp,48
    80002bea:	892a                	mv	s2,a0
    80002bec:	84ae                	mv	s1,a1
    80002bee:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002bf0:	fffff097          	auipc	ra,0xfffff
    80002bf4:	e4a080e7          	jalr	-438(ra) # 80001a3a <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002bf8:	86ce                	mv	a3,s3
    80002bfa:	864a                	mv	a2,s2
    80002bfc:	85a6                	mv	a1,s1
    80002bfe:	6928                	ld	a0,80(a0)
    80002c00:	fffff097          	auipc	ra,0xfffff
    80002c04:	bfa080e7          	jalr	-1030(ra) # 800017fa <copyinstr>
    80002c08:	00054e63          	bltz	a0,80002c24 <fetchstr+0x48>
  return strlen(buf);
    80002c0c:	8526                	mv	a0,s1
    80002c0e:	ffffe097          	auipc	ra,0xffffe
    80002c12:	2cc080e7          	jalr	716(ra) # 80000eda <strlen>
}
    80002c16:	70a2                	ld	ra,40(sp)
    80002c18:	7402                	ld	s0,32(sp)
    80002c1a:	64e2                	ld	s1,24(sp)
    80002c1c:	6942                	ld	s2,16(sp)
    80002c1e:	69a2                	ld	s3,8(sp)
    80002c20:	6145                	addi	sp,sp,48
    80002c22:	8082                	ret
    return -1;
    80002c24:	557d                	li	a0,-1
    80002c26:	bfc5                	j	80002c16 <fetchstr+0x3a>

0000000080002c28 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002c28:	1101                	addi	sp,sp,-32
    80002c2a:	ec06                	sd	ra,24(sp)
    80002c2c:	e822                	sd	s0,16(sp)
    80002c2e:	e426                	sd	s1,8(sp)
    80002c30:	1000                	addi	s0,sp,32
    80002c32:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002c34:	00000097          	auipc	ra,0x0
    80002c38:	ee8080e7          	jalr	-280(ra) # 80002b1c <argraw>
    80002c3c:	c088                	sw	a0,0(s1)
}
    80002c3e:	60e2                	ld	ra,24(sp)
    80002c40:	6442                	ld	s0,16(sp)
    80002c42:	64a2                	ld	s1,8(sp)
    80002c44:	6105                	addi	sp,sp,32
    80002c46:	8082                	ret

0000000080002c48 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002c48:	1101                	addi	sp,sp,-32
    80002c4a:	ec06                	sd	ra,24(sp)
    80002c4c:	e822                	sd	s0,16(sp)
    80002c4e:	e426                	sd	s1,8(sp)
    80002c50:	1000                	addi	s0,sp,32
    80002c52:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002c54:	00000097          	auipc	ra,0x0
    80002c58:	ec8080e7          	jalr	-312(ra) # 80002b1c <argraw>
    80002c5c:	e088                	sd	a0,0(s1)
}
    80002c5e:	60e2                	ld	ra,24(sp)
    80002c60:	6442                	ld	s0,16(sp)
    80002c62:	64a2                	ld	s1,8(sp)
    80002c64:	6105                	addi	sp,sp,32
    80002c66:	8082                	ret

0000000080002c68 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002c68:	7179                	addi	sp,sp,-48
    80002c6a:	f406                	sd	ra,40(sp)
    80002c6c:	f022                	sd	s0,32(sp)
    80002c6e:	ec26                	sd	s1,24(sp)
    80002c70:	e84a                	sd	s2,16(sp)
    80002c72:	1800                	addi	s0,sp,48
    80002c74:	84ae                	mv	s1,a1
    80002c76:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002c78:	fd840593          	addi	a1,s0,-40
    80002c7c:	00000097          	auipc	ra,0x0
    80002c80:	fcc080e7          	jalr	-52(ra) # 80002c48 <argaddr>
  return fetchstr(addr, buf, max);
    80002c84:	864a                	mv	a2,s2
    80002c86:	85a6                	mv	a1,s1
    80002c88:	fd843503          	ld	a0,-40(s0)
    80002c8c:	00000097          	auipc	ra,0x0
    80002c90:	f50080e7          	jalr	-176(ra) # 80002bdc <fetchstr>
}
    80002c94:	70a2                	ld	ra,40(sp)
    80002c96:	7402                	ld	s0,32(sp)
    80002c98:	64e2                	ld	s1,24(sp)
    80002c9a:	6942                	ld	s2,16(sp)
    80002c9c:	6145                	addi	sp,sp,48
    80002c9e:	8082                	ret

0000000080002ca0 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80002ca0:	1101                	addi	sp,sp,-32
    80002ca2:	ec06                	sd	ra,24(sp)
    80002ca4:	e822                	sd	s0,16(sp)
    80002ca6:	e426                	sd	s1,8(sp)
    80002ca8:	e04a                	sd	s2,0(sp)
    80002caa:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002cac:	fffff097          	auipc	ra,0xfffff
    80002cb0:	d8e080e7          	jalr	-626(ra) # 80001a3a <myproc>
    80002cb4:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002cb6:	05853903          	ld	s2,88(a0)
    80002cba:	0a893783          	ld	a5,168(s2)
    80002cbe:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002cc2:	37fd                	addiw	a5,a5,-1
    80002cc4:	4751                	li	a4,20
    80002cc6:	00f76f63          	bltu	a4,a5,80002ce4 <syscall+0x44>
    80002cca:	00369713          	slli	a4,a3,0x3
    80002cce:	00005797          	auipc	a5,0x5
    80002cd2:	79a78793          	addi	a5,a5,1946 # 80008468 <syscalls>
    80002cd6:	97ba                	add	a5,a5,a4
    80002cd8:	639c                	ld	a5,0(a5)
    80002cda:	c789                	beqz	a5,80002ce4 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002cdc:	9782                	jalr	a5
    80002cde:	06a93823          	sd	a0,112(s2)
    80002ce2:	a839                	j	80002d00 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002ce4:	15848613          	addi	a2,s1,344
    80002ce8:	588c                	lw	a1,48(s1)
    80002cea:	00006517          	auipc	a0,0x6
    80002cee:	83650513          	addi	a0,a0,-1994 # 80008520 <syscalls+0xb8>
    80002cf2:	ffffe097          	auipc	ra,0xffffe
    80002cf6:	8c4080e7          	jalr	-1852(ra) # 800005b6 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002cfa:	6cbc                	ld	a5,88(s1)
    80002cfc:	577d                	li	a4,-1
    80002cfe:	fbb8                	sd	a4,112(a5)
  }
}
    80002d00:	60e2                	ld	ra,24(sp)
    80002d02:	6442                	ld	s0,16(sp)
    80002d04:	64a2                	ld	s1,8(sp)
    80002d06:	6902                	ld	s2,0(sp)
    80002d08:	6105                	addi	sp,sp,32
    80002d0a:	8082                	ret

0000000080002d0c <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002d0c:	1101                	addi	sp,sp,-32
    80002d0e:	ec06                	sd	ra,24(sp)
    80002d10:	e822                	sd	s0,16(sp)
    80002d12:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002d14:	fec40593          	addi	a1,s0,-20
    80002d18:	4501                	li	a0,0
    80002d1a:	00000097          	auipc	ra,0x0
    80002d1e:	f0e080e7          	jalr	-242(ra) # 80002c28 <argint>
  exit(n);
    80002d22:	fec42503          	lw	a0,-20(s0)
    80002d26:	fffff097          	auipc	ra,0xfffff
    80002d2a:	4f0080e7          	jalr	1264(ra) # 80002216 <exit>
  return 0;  // not reached
}
    80002d2e:	4501                	li	a0,0
    80002d30:	60e2                	ld	ra,24(sp)
    80002d32:	6442                	ld	s0,16(sp)
    80002d34:	6105                	addi	sp,sp,32
    80002d36:	8082                	ret

0000000080002d38 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002d38:	1141                	addi	sp,sp,-16
    80002d3a:	e406                	sd	ra,8(sp)
    80002d3c:	e022                	sd	s0,0(sp)
    80002d3e:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002d40:	fffff097          	auipc	ra,0xfffff
    80002d44:	cfa080e7          	jalr	-774(ra) # 80001a3a <myproc>
}
    80002d48:	5908                	lw	a0,48(a0)
    80002d4a:	60a2                	ld	ra,8(sp)
    80002d4c:	6402                	ld	s0,0(sp)
    80002d4e:	0141                	addi	sp,sp,16
    80002d50:	8082                	ret

0000000080002d52 <sys_fork>:

uint64
sys_fork(void)
{
    80002d52:	1141                	addi	sp,sp,-16
    80002d54:	e406                	sd	ra,8(sp)
    80002d56:	e022                	sd	s0,0(sp)
    80002d58:	0800                	addi	s0,sp,16
  return fork();
    80002d5a:	fffff097          	auipc	ra,0xfffff
    80002d5e:	098080e7          	jalr	152(ra) # 80001df2 <fork>
}
    80002d62:	60a2                	ld	ra,8(sp)
    80002d64:	6402                	ld	s0,0(sp)
    80002d66:	0141                	addi	sp,sp,16
    80002d68:	8082                	ret

0000000080002d6a <sys_wait>:

uint64
sys_wait(void)
{
    80002d6a:	1101                	addi	sp,sp,-32
    80002d6c:	ec06                	sd	ra,24(sp)
    80002d6e:	e822                	sd	s0,16(sp)
    80002d70:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002d72:	fe840593          	addi	a1,s0,-24
    80002d76:	4501                	li	a0,0
    80002d78:	00000097          	auipc	ra,0x0
    80002d7c:	ed0080e7          	jalr	-304(ra) # 80002c48 <argaddr>
  return wait(p);
    80002d80:	fe843503          	ld	a0,-24(s0)
    80002d84:	fffff097          	auipc	ra,0xfffff
    80002d88:	63a080e7          	jalr	1594(ra) # 800023be <wait>
}
    80002d8c:	60e2                	ld	ra,24(sp)
    80002d8e:	6442                	ld	s0,16(sp)
    80002d90:	6105                	addi	sp,sp,32
    80002d92:	8082                	ret

0000000080002d94 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002d94:	7179                	addi	sp,sp,-48
    80002d96:	f406                	sd	ra,40(sp)
    80002d98:	f022                	sd	s0,32(sp)
    80002d9a:	ec26                	sd	s1,24(sp)
    80002d9c:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002d9e:	fdc40593          	addi	a1,s0,-36
    80002da2:	4501                	li	a0,0
    80002da4:	00000097          	auipc	ra,0x0
    80002da8:	e84080e7          	jalr	-380(ra) # 80002c28 <argint>
  addr = myproc()->sz;
    80002dac:	fffff097          	auipc	ra,0xfffff
    80002db0:	c8e080e7          	jalr	-882(ra) # 80001a3a <myproc>
    80002db4:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002db6:	fdc42503          	lw	a0,-36(s0)
    80002dba:	fffff097          	auipc	ra,0xfffff
    80002dbe:	fdc080e7          	jalr	-36(ra) # 80001d96 <growproc>
    80002dc2:	00054863          	bltz	a0,80002dd2 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002dc6:	8526                	mv	a0,s1
    80002dc8:	70a2                	ld	ra,40(sp)
    80002dca:	7402                	ld	s0,32(sp)
    80002dcc:	64e2                	ld	s1,24(sp)
    80002dce:	6145                	addi	sp,sp,48
    80002dd0:	8082                	ret
    return -1;
    80002dd2:	54fd                	li	s1,-1
    80002dd4:	bfcd                	j	80002dc6 <sys_sbrk+0x32>

0000000080002dd6 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002dd6:	7139                	addi	sp,sp,-64
    80002dd8:	fc06                	sd	ra,56(sp)
    80002dda:	f822                	sd	s0,48(sp)
    80002ddc:	f426                	sd	s1,40(sp)
    80002dde:	f04a                	sd	s2,32(sp)
    80002de0:	ec4e                	sd	s3,24(sp)
    80002de2:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002de4:	fcc40593          	addi	a1,s0,-52
    80002de8:	4501                	li	a0,0
    80002dea:	00000097          	auipc	ra,0x0
    80002dee:	e3e080e7          	jalr	-450(ra) # 80002c28 <argint>
  acquire(&tickslock);
    80002df2:	00014517          	auipc	a0,0x14
    80002df6:	bce50513          	addi	a0,a0,-1074 # 800169c0 <tickslock>
    80002dfa:	ffffe097          	auipc	ra,0xffffe
    80002dfe:	e3e080e7          	jalr	-450(ra) # 80000c38 <acquire>
  ticks0 = ticks;
    80002e02:	00006797          	auipc	a5,0x6
    80002e06:	b1e78793          	addi	a5,a5,-1250 # 80008920 <ticks>
    80002e0a:	0007a903          	lw	s2,0(a5)
  while(ticks - ticks0 < n){
    80002e0e:	fcc42783          	lw	a5,-52(s0)
    80002e12:	cf9d                	beqz	a5,80002e50 <sys_sleep+0x7a>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002e14:	00014997          	auipc	s3,0x14
    80002e18:	bac98993          	addi	s3,s3,-1108 # 800169c0 <tickslock>
    80002e1c:	00006497          	auipc	s1,0x6
    80002e20:	b0448493          	addi	s1,s1,-1276 # 80008920 <ticks>
    if(killed(myproc())){
    80002e24:	fffff097          	auipc	ra,0xfffff
    80002e28:	c16080e7          	jalr	-1002(ra) # 80001a3a <myproc>
    80002e2c:	fffff097          	auipc	ra,0xfffff
    80002e30:	560080e7          	jalr	1376(ra) # 8000238c <killed>
    80002e34:	ed15                	bnez	a0,80002e70 <sys_sleep+0x9a>
    sleep(&ticks, &tickslock);
    80002e36:	85ce                	mv	a1,s3
    80002e38:	8526                	mv	a0,s1
    80002e3a:	fffff097          	auipc	ra,0xfffff
    80002e3e:	2a8080e7          	jalr	680(ra) # 800020e2 <sleep>
  while(ticks - ticks0 < n){
    80002e42:	409c                	lw	a5,0(s1)
    80002e44:	412787bb          	subw	a5,a5,s2
    80002e48:	fcc42703          	lw	a4,-52(s0)
    80002e4c:	fce7ece3          	bltu	a5,a4,80002e24 <sys_sleep+0x4e>
  }
  release(&tickslock);
    80002e50:	00014517          	auipc	a0,0x14
    80002e54:	b7050513          	addi	a0,a0,-1168 # 800169c0 <tickslock>
    80002e58:	ffffe097          	auipc	ra,0xffffe
    80002e5c:	e94080e7          	jalr	-364(ra) # 80000cec <release>
  return 0;
    80002e60:	4501                	li	a0,0
}
    80002e62:	70e2                	ld	ra,56(sp)
    80002e64:	7442                	ld	s0,48(sp)
    80002e66:	74a2                	ld	s1,40(sp)
    80002e68:	7902                	ld	s2,32(sp)
    80002e6a:	69e2                	ld	s3,24(sp)
    80002e6c:	6121                	addi	sp,sp,64
    80002e6e:	8082                	ret
      release(&tickslock);
    80002e70:	00014517          	auipc	a0,0x14
    80002e74:	b5050513          	addi	a0,a0,-1200 # 800169c0 <tickslock>
    80002e78:	ffffe097          	auipc	ra,0xffffe
    80002e7c:	e74080e7          	jalr	-396(ra) # 80000cec <release>
      return -1;
    80002e80:	557d                	li	a0,-1
    80002e82:	b7c5                	j	80002e62 <sys_sleep+0x8c>

0000000080002e84 <sys_find>:


uint64
sys_find(void){
    80002e84:	1141                	addi	sp,sp,-16
    80002e86:	e422                	sd	s0,8(sp)
    80002e88:	0800                	addi	s0,sp,16
  return 0;
}
    80002e8a:	4501                	li	a0,0
    80002e8c:	6422                	ld	s0,8(sp)
    80002e8e:	0141                	addi	sp,sp,16
    80002e90:	8082                	ret

0000000080002e92 <sys_kill>:

uint64
sys_kill(void)
{
    80002e92:	1101                	addi	sp,sp,-32
    80002e94:	ec06                	sd	ra,24(sp)
    80002e96:	e822                	sd	s0,16(sp)
    80002e98:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002e9a:	fec40593          	addi	a1,s0,-20
    80002e9e:	4501                	li	a0,0
    80002ea0:	00000097          	auipc	ra,0x0
    80002ea4:	d88080e7          	jalr	-632(ra) # 80002c28 <argint>
  return kill(pid);
    80002ea8:	fec42503          	lw	a0,-20(s0)
    80002eac:	fffff097          	auipc	ra,0xfffff
    80002eb0:	442080e7          	jalr	1090(ra) # 800022ee <kill>
}
    80002eb4:	60e2                	ld	ra,24(sp)
    80002eb6:	6442                	ld	s0,16(sp)
    80002eb8:	6105                	addi	sp,sp,32
    80002eba:	8082                	ret

0000000080002ebc <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002ebc:	1101                	addi	sp,sp,-32
    80002ebe:	ec06                	sd	ra,24(sp)
    80002ec0:	e822                	sd	s0,16(sp)
    80002ec2:	e426                	sd	s1,8(sp)
    80002ec4:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002ec6:	00014517          	auipc	a0,0x14
    80002eca:	afa50513          	addi	a0,a0,-1286 # 800169c0 <tickslock>
    80002ece:	ffffe097          	auipc	ra,0xffffe
    80002ed2:	d6a080e7          	jalr	-662(ra) # 80000c38 <acquire>
  xticks = ticks;
    80002ed6:	00006797          	auipc	a5,0x6
    80002eda:	a4a78793          	addi	a5,a5,-1462 # 80008920 <ticks>
    80002ede:	4384                	lw	s1,0(a5)
  release(&tickslock);
    80002ee0:	00014517          	auipc	a0,0x14
    80002ee4:	ae050513          	addi	a0,a0,-1312 # 800169c0 <tickslock>
    80002ee8:	ffffe097          	auipc	ra,0xffffe
    80002eec:	e04080e7          	jalr	-508(ra) # 80000cec <release>
  return xticks;
}
    80002ef0:	02049513          	slli	a0,s1,0x20
    80002ef4:	9101                	srli	a0,a0,0x20
    80002ef6:	60e2                	ld	ra,24(sp)
    80002ef8:	6442                	ld	s0,16(sp)
    80002efa:	64a2                	ld	s1,8(sp)
    80002efc:	6105                	addi	sp,sp,32
    80002efe:	8082                	ret

0000000080002f00 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002f00:	7179                	addi	sp,sp,-48
    80002f02:	f406                	sd	ra,40(sp)
    80002f04:	f022                	sd	s0,32(sp)
    80002f06:	ec26                	sd	s1,24(sp)
    80002f08:	e84a                	sd	s2,16(sp)
    80002f0a:	e44e                	sd	s3,8(sp)
    80002f0c:	e052                	sd	s4,0(sp)
    80002f0e:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002f10:	00005597          	auipc	a1,0x5
    80002f14:	63058593          	addi	a1,a1,1584 # 80008540 <syscalls+0xd8>
    80002f18:	00014517          	auipc	a0,0x14
    80002f1c:	ac050513          	addi	a0,a0,-1344 # 800169d8 <bcache>
    80002f20:	ffffe097          	auipc	ra,0xffffe
    80002f24:	c88080e7          	jalr	-888(ra) # 80000ba8 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002f28:	0001c797          	auipc	a5,0x1c
    80002f2c:	ab078793          	addi	a5,a5,-1360 # 8001e9d8 <bcache+0x8000>
    80002f30:	0001c717          	auipc	a4,0x1c
    80002f34:	d1070713          	addi	a4,a4,-752 # 8001ec40 <bcache+0x8268>
    80002f38:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002f3c:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002f40:	00014497          	auipc	s1,0x14
    80002f44:	ab048493          	addi	s1,s1,-1360 # 800169f0 <bcache+0x18>
    b->next = bcache.head.next;
    80002f48:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002f4a:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002f4c:	00005a17          	auipc	s4,0x5
    80002f50:	5fca0a13          	addi	s4,s4,1532 # 80008548 <syscalls+0xe0>
    b->next = bcache.head.next;
    80002f54:	2b893783          	ld	a5,696(s2)
    80002f58:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002f5a:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002f5e:	85d2                	mv	a1,s4
    80002f60:	01048513          	addi	a0,s1,16
    80002f64:	00001097          	auipc	ra,0x1
    80002f68:	530080e7          	jalr	1328(ra) # 80004494 <initsleeplock>
    bcache.head.next->prev = b;
    80002f6c:	2b893783          	ld	a5,696(s2)
    80002f70:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002f72:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002f76:	45848493          	addi	s1,s1,1112
    80002f7a:	fd349de3          	bne	s1,s3,80002f54 <binit+0x54>
  }
}
    80002f7e:	70a2                	ld	ra,40(sp)
    80002f80:	7402                	ld	s0,32(sp)
    80002f82:	64e2                	ld	s1,24(sp)
    80002f84:	6942                	ld	s2,16(sp)
    80002f86:	69a2                	ld	s3,8(sp)
    80002f88:	6a02                	ld	s4,0(sp)
    80002f8a:	6145                	addi	sp,sp,48
    80002f8c:	8082                	ret

0000000080002f8e <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002f8e:	7179                	addi	sp,sp,-48
    80002f90:	f406                	sd	ra,40(sp)
    80002f92:	f022                	sd	s0,32(sp)
    80002f94:	ec26                	sd	s1,24(sp)
    80002f96:	e84a                	sd	s2,16(sp)
    80002f98:	e44e                	sd	s3,8(sp)
    80002f9a:	1800                	addi	s0,sp,48
    80002f9c:	89aa                	mv	s3,a0
    80002f9e:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002fa0:	00014517          	auipc	a0,0x14
    80002fa4:	a3850513          	addi	a0,a0,-1480 # 800169d8 <bcache>
    80002fa8:	ffffe097          	auipc	ra,0xffffe
    80002fac:	c90080e7          	jalr	-880(ra) # 80000c38 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002fb0:	0001c797          	auipc	a5,0x1c
    80002fb4:	a2878793          	addi	a5,a5,-1496 # 8001e9d8 <bcache+0x8000>
    80002fb8:	2b87b483          	ld	s1,696(a5)
    80002fbc:	0001c797          	auipc	a5,0x1c
    80002fc0:	c8478793          	addi	a5,a5,-892 # 8001ec40 <bcache+0x8268>
    80002fc4:	02f48f63          	beq	s1,a5,80003002 <bread+0x74>
    80002fc8:	873e                	mv	a4,a5
    80002fca:	a021                	j	80002fd2 <bread+0x44>
    80002fcc:	68a4                	ld	s1,80(s1)
    80002fce:	02e48a63          	beq	s1,a4,80003002 <bread+0x74>
    if(b->dev == dev && b->blockno == blockno){
    80002fd2:	449c                	lw	a5,8(s1)
    80002fd4:	ff379ce3          	bne	a5,s3,80002fcc <bread+0x3e>
    80002fd8:	44dc                	lw	a5,12(s1)
    80002fda:	ff2799e3          	bne	a5,s2,80002fcc <bread+0x3e>
      b->refcnt++;
    80002fde:	40bc                	lw	a5,64(s1)
    80002fe0:	2785                	addiw	a5,a5,1
    80002fe2:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002fe4:	00014517          	auipc	a0,0x14
    80002fe8:	9f450513          	addi	a0,a0,-1548 # 800169d8 <bcache>
    80002fec:	ffffe097          	auipc	ra,0xffffe
    80002ff0:	d00080e7          	jalr	-768(ra) # 80000cec <release>
      acquiresleep(&b->lock);
    80002ff4:	01048513          	addi	a0,s1,16
    80002ff8:	00001097          	auipc	ra,0x1
    80002ffc:	4d6080e7          	jalr	1238(ra) # 800044ce <acquiresleep>
      return b;
    80003000:	a8b1                	j	8000305c <bread+0xce>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003002:	0001c797          	auipc	a5,0x1c
    80003006:	9d678793          	addi	a5,a5,-1578 # 8001e9d8 <bcache+0x8000>
    8000300a:	2b07b483          	ld	s1,688(a5)
    8000300e:	0001c797          	auipc	a5,0x1c
    80003012:	c3278793          	addi	a5,a5,-974 # 8001ec40 <bcache+0x8268>
    80003016:	04f48d63          	beq	s1,a5,80003070 <bread+0xe2>
    if(b->refcnt == 0) {
    8000301a:	40bc                	lw	a5,64(s1)
    8000301c:	cb91                	beqz	a5,80003030 <bread+0xa2>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000301e:	0001c717          	auipc	a4,0x1c
    80003022:	c2270713          	addi	a4,a4,-990 # 8001ec40 <bcache+0x8268>
    80003026:	64a4                	ld	s1,72(s1)
    80003028:	04e48463          	beq	s1,a4,80003070 <bread+0xe2>
    if(b->refcnt == 0) {
    8000302c:	40bc                	lw	a5,64(s1)
    8000302e:	ffe5                	bnez	a5,80003026 <bread+0x98>
      b->dev = dev;
    80003030:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80003034:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80003038:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000303c:	4785                	li	a5,1
    8000303e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003040:	00014517          	auipc	a0,0x14
    80003044:	99850513          	addi	a0,a0,-1640 # 800169d8 <bcache>
    80003048:	ffffe097          	auipc	ra,0xffffe
    8000304c:	ca4080e7          	jalr	-860(ra) # 80000cec <release>
      acquiresleep(&b->lock);
    80003050:	01048513          	addi	a0,s1,16
    80003054:	00001097          	auipc	ra,0x1
    80003058:	47a080e7          	jalr	1146(ra) # 800044ce <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000305c:	409c                	lw	a5,0(s1)
    8000305e:	c38d                	beqz	a5,80003080 <bread+0xf2>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003060:	8526                	mv	a0,s1
    80003062:	70a2                	ld	ra,40(sp)
    80003064:	7402                	ld	s0,32(sp)
    80003066:	64e2                	ld	s1,24(sp)
    80003068:	6942                	ld	s2,16(sp)
    8000306a:	69a2                	ld	s3,8(sp)
    8000306c:	6145                	addi	sp,sp,48
    8000306e:	8082                	ret
  panic("bget: no buffers");
    80003070:	00005517          	auipc	a0,0x5
    80003074:	4e050513          	addi	a0,a0,1248 # 80008550 <syscalls+0xe8>
    80003078:	ffffd097          	auipc	ra,0xffffd
    8000307c:	4f4080e7          	jalr	1268(ra) # 8000056c <panic>
    virtio_disk_rw(b, 0);
    80003080:	4581                	li	a1,0
    80003082:	8526                	mv	a0,s1
    80003084:	00003097          	auipc	ra,0x3
    80003088:	07e080e7          	jalr	126(ra) # 80006102 <virtio_disk_rw>
    b->valid = 1;
    8000308c:	4785                	li	a5,1
    8000308e:	c09c                	sw	a5,0(s1)
  return b;
    80003090:	bfc1                	j	80003060 <bread+0xd2>

0000000080003092 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003092:	1101                	addi	sp,sp,-32
    80003094:	ec06                	sd	ra,24(sp)
    80003096:	e822                	sd	s0,16(sp)
    80003098:	e426                	sd	s1,8(sp)
    8000309a:	1000                	addi	s0,sp,32
    8000309c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000309e:	0541                	addi	a0,a0,16
    800030a0:	00001097          	auipc	ra,0x1
    800030a4:	4c8080e7          	jalr	1224(ra) # 80004568 <holdingsleep>
    800030a8:	cd01                	beqz	a0,800030c0 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800030aa:	4585                	li	a1,1
    800030ac:	8526                	mv	a0,s1
    800030ae:	00003097          	auipc	ra,0x3
    800030b2:	054080e7          	jalr	84(ra) # 80006102 <virtio_disk_rw>
}
    800030b6:	60e2                	ld	ra,24(sp)
    800030b8:	6442                	ld	s0,16(sp)
    800030ba:	64a2                	ld	s1,8(sp)
    800030bc:	6105                	addi	sp,sp,32
    800030be:	8082                	ret
    panic("bwrite");
    800030c0:	00005517          	auipc	a0,0x5
    800030c4:	4a850513          	addi	a0,a0,1192 # 80008568 <syscalls+0x100>
    800030c8:	ffffd097          	auipc	ra,0xffffd
    800030cc:	4a4080e7          	jalr	1188(ra) # 8000056c <panic>

00000000800030d0 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800030d0:	1101                	addi	sp,sp,-32
    800030d2:	ec06                	sd	ra,24(sp)
    800030d4:	e822                	sd	s0,16(sp)
    800030d6:	e426                	sd	s1,8(sp)
    800030d8:	e04a                	sd	s2,0(sp)
    800030da:	1000                	addi	s0,sp,32
    800030dc:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800030de:	01050913          	addi	s2,a0,16
    800030e2:	854a                	mv	a0,s2
    800030e4:	00001097          	auipc	ra,0x1
    800030e8:	484080e7          	jalr	1156(ra) # 80004568 <holdingsleep>
    800030ec:	c92d                	beqz	a0,8000315e <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800030ee:	854a                	mv	a0,s2
    800030f0:	00001097          	auipc	ra,0x1
    800030f4:	434080e7          	jalr	1076(ra) # 80004524 <releasesleep>

  acquire(&bcache.lock);
    800030f8:	00014517          	auipc	a0,0x14
    800030fc:	8e050513          	addi	a0,a0,-1824 # 800169d8 <bcache>
    80003100:	ffffe097          	auipc	ra,0xffffe
    80003104:	b38080e7          	jalr	-1224(ra) # 80000c38 <acquire>
  b->refcnt--;
    80003108:	40bc                	lw	a5,64(s1)
    8000310a:	37fd                	addiw	a5,a5,-1
    8000310c:	0007871b          	sext.w	a4,a5
    80003110:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003112:	eb05                	bnez	a4,80003142 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003114:	68bc                	ld	a5,80(s1)
    80003116:	64b8                	ld	a4,72(s1)
    80003118:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000311a:	64bc                	ld	a5,72(s1)
    8000311c:	68b8                	ld	a4,80(s1)
    8000311e:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003120:	0001c797          	auipc	a5,0x1c
    80003124:	8b878793          	addi	a5,a5,-1864 # 8001e9d8 <bcache+0x8000>
    80003128:	2b87b703          	ld	a4,696(a5)
    8000312c:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000312e:	0001c717          	auipc	a4,0x1c
    80003132:	b1270713          	addi	a4,a4,-1262 # 8001ec40 <bcache+0x8268>
    80003136:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003138:	2b87b703          	ld	a4,696(a5)
    8000313c:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000313e:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80003142:	00014517          	auipc	a0,0x14
    80003146:	89650513          	addi	a0,a0,-1898 # 800169d8 <bcache>
    8000314a:	ffffe097          	auipc	ra,0xffffe
    8000314e:	ba2080e7          	jalr	-1118(ra) # 80000cec <release>
}
    80003152:	60e2                	ld	ra,24(sp)
    80003154:	6442                	ld	s0,16(sp)
    80003156:	64a2                	ld	s1,8(sp)
    80003158:	6902                	ld	s2,0(sp)
    8000315a:	6105                	addi	sp,sp,32
    8000315c:	8082                	ret
    panic("brelse");
    8000315e:	00005517          	auipc	a0,0x5
    80003162:	41250513          	addi	a0,a0,1042 # 80008570 <syscalls+0x108>
    80003166:	ffffd097          	auipc	ra,0xffffd
    8000316a:	406080e7          	jalr	1030(ra) # 8000056c <panic>

000000008000316e <bpin>:

void
bpin(struct buf *b) {
    8000316e:	1101                	addi	sp,sp,-32
    80003170:	ec06                	sd	ra,24(sp)
    80003172:	e822                	sd	s0,16(sp)
    80003174:	e426                	sd	s1,8(sp)
    80003176:	1000                	addi	s0,sp,32
    80003178:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000317a:	00014517          	auipc	a0,0x14
    8000317e:	85e50513          	addi	a0,a0,-1954 # 800169d8 <bcache>
    80003182:	ffffe097          	auipc	ra,0xffffe
    80003186:	ab6080e7          	jalr	-1354(ra) # 80000c38 <acquire>
  b->refcnt++;
    8000318a:	40bc                	lw	a5,64(s1)
    8000318c:	2785                	addiw	a5,a5,1
    8000318e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003190:	00014517          	auipc	a0,0x14
    80003194:	84850513          	addi	a0,a0,-1976 # 800169d8 <bcache>
    80003198:	ffffe097          	auipc	ra,0xffffe
    8000319c:	b54080e7          	jalr	-1196(ra) # 80000cec <release>
}
    800031a0:	60e2                	ld	ra,24(sp)
    800031a2:	6442                	ld	s0,16(sp)
    800031a4:	64a2                	ld	s1,8(sp)
    800031a6:	6105                	addi	sp,sp,32
    800031a8:	8082                	ret

00000000800031aa <bunpin>:

void
bunpin(struct buf *b) {
    800031aa:	1101                	addi	sp,sp,-32
    800031ac:	ec06                	sd	ra,24(sp)
    800031ae:	e822                	sd	s0,16(sp)
    800031b0:	e426                	sd	s1,8(sp)
    800031b2:	1000                	addi	s0,sp,32
    800031b4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800031b6:	00014517          	auipc	a0,0x14
    800031ba:	82250513          	addi	a0,a0,-2014 # 800169d8 <bcache>
    800031be:	ffffe097          	auipc	ra,0xffffe
    800031c2:	a7a080e7          	jalr	-1414(ra) # 80000c38 <acquire>
  b->refcnt--;
    800031c6:	40bc                	lw	a5,64(s1)
    800031c8:	37fd                	addiw	a5,a5,-1
    800031ca:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800031cc:	00014517          	auipc	a0,0x14
    800031d0:	80c50513          	addi	a0,a0,-2036 # 800169d8 <bcache>
    800031d4:	ffffe097          	auipc	ra,0xffffe
    800031d8:	b18080e7          	jalr	-1256(ra) # 80000cec <release>
}
    800031dc:	60e2                	ld	ra,24(sp)
    800031de:	6442                	ld	s0,16(sp)
    800031e0:	64a2                	ld	s1,8(sp)
    800031e2:	6105                	addi	sp,sp,32
    800031e4:	8082                	ret

00000000800031e6 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800031e6:	1101                	addi	sp,sp,-32
    800031e8:	ec06                	sd	ra,24(sp)
    800031ea:	e822                	sd	s0,16(sp)
    800031ec:	e426                	sd	s1,8(sp)
    800031ee:	e04a                	sd	s2,0(sp)
    800031f0:	1000                	addi	s0,sp,32
    800031f2:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800031f4:	00d5d59b          	srliw	a1,a1,0xd
    800031f8:	0001c797          	auipc	a5,0x1c
    800031fc:	ea078793          	addi	a5,a5,-352 # 8001f098 <sb>
    80003200:	4fdc                	lw	a5,28(a5)
    80003202:	9dbd                	addw	a1,a1,a5
    80003204:	00000097          	auipc	ra,0x0
    80003208:	d8a080e7          	jalr	-630(ra) # 80002f8e <bread>
  bi = b % BPB;
    8000320c:	2481                	sext.w	s1,s1
  m = 1 << (bi % 8);
    8000320e:	0074f793          	andi	a5,s1,7
    80003212:	4705                	li	a4,1
    80003214:	00f7173b          	sllw	a4,a4,a5
  bi = b % BPB;
    80003218:	6789                	lui	a5,0x2
    8000321a:	17fd                	addi	a5,a5,-1
    8000321c:	8cfd                	and	s1,s1,a5
  if((bp->data[bi/8] & m) == 0)
    8000321e:	41f4d79b          	sraiw	a5,s1,0x1f
    80003222:	01d7d79b          	srliw	a5,a5,0x1d
    80003226:	9fa5                	addw	a5,a5,s1
    80003228:	4037d79b          	sraiw	a5,a5,0x3
    8000322c:	00f506b3          	add	a3,a0,a5
    80003230:	0586c683          	lbu	a3,88(a3)
    80003234:	00d77633          	and	a2,a4,a3
    80003238:	c61d                	beqz	a2,80003266 <bfree+0x80>
    8000323a:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000323c:	97aa                	add	a5,a5,a0
    8000323e:	fff74713          	not	a4,a4
    80003242:	8f75                	and	a4,a4,a3
    80003244:	04e78c23          	sb	a4,88(a5) # 2058 <_entry-0x7fffdfa8>
  log_write(bp);
    80003248:	00001097          	auipc	ra,0x1
    8000324c:	152080e7          	jalr	338(ra) # 8000439a <log_write>
  brelse(bp);
    80003250:	854a                	mv	a0,s2
    80003252:	00000097          	auipc	ra,0x0
    80003256:	e7e080e7          	jalr	-386(ra) # 800030d0 <brelse>
}
    8000325a:	60e2                	ld	ra,24(sp)
    8000325c:	6442                	ld	s0,16(sp)
    8000325e:	64a2                	ld	s1,8(sp)
    80003260:	6902                	ld	s2,0(sp)
    80003262:	6105                	addi	sp,sp,32
    80003264:	8082                	ret
    panic("freeing free block");
    80003266:	00005517          	auipc	a0,0x5
    8000326a:	31250513          	addi	a0,a0,786 # 80008578 <syscalls+0x110>
    8000326e:	ffffd097          	auipc	ra,0xffffd
    80003272:	2fe080e7          	jalr	766(ra) # 8000056c <panic>

0000000080003276 <balloc>:
{
    80003276:	711d                	addi	sp,sp,-96
    80003278:	ec86                	sd	ra,88(sp)
    8000327a:	e8a2                	sd	s0,80(sp)
    8000327c:	e4a6                	sd	s1,72(sp)
    8000327e:	e0ca                	sd	s2,64(sp)
    80003280:	fc4e                	sd	s3,56(sp)
    80003282:	f852                	sd	s4,48(sp)
    80003284:	f456                	sd	s5,40(sp)
    80003286:	f05a                	sd	s6,32(sp)
    80003288:	ec5e                	sd	s7,24(sp)
    8000328a:	e862                	sd	s8,16(sp)
    8000328c:	e466                	sd	s9,8(sp)
    8000328e:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003290:	0001c797          	auipc	a5,0x1c
    80003294:	e0878793          	addi	a5,a5,-504 # 8001f098 <sb>
    80003298:	43dc                	lw	a5,4(a5)
    8000329a:	10078e63          	beqz	a5,800033b6 <balloc+0x140>
    8000329e:	8baa                	mv	s7,a0
    800032a0:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800032a2:	0001cb17          	auipc	s6,0x1c
    800032a6:	df6b0b13          	addi	s6,s6,-522 # 8001f098 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800032aa:	4c05                	li	s8,1
      m = 1 << (bi % 8);
    800032ac:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800032ae:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800032b0:	6c89                	lui	s9,0x2
    800032b2:	a079                	j	80003340 <balloc+0xca>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800032b4:	8942                	mv	s2,a6
      m = 1 << (bi % 8);
    800032b6:	4705                	li	a4,1
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800032b8:	4681                	li	a3,0
        bp->data[bi/8] |= m;  // Mark block in use.
    800032ba:	96a6                	add	a3,a3,s1
    800032bc:	8f51                	or	a4,a4,a2
    800032be:	04e68c23          	sb	a4,88(a3)
        log_write(bp);
    800032c2:	8526                	mv	a0,s1
    800032c4:	00001097          	auipc	ra,0x1
    800032c8:	0d6080e7          	jalr	214(ra) # 8000439a <log_write>
        brelse(bp);
    800032cc:	8526                	mv	a0,s1
    800032ce:	00000097          	auipc	ra,0x0
    800032d2:	e02080e7          	jalr	-510(ra) # 800030d0 <brelse>
  bp = bread(dev, bno);
    800032d6:	85ca                	mv	a1,s2
    800032d8:	855e                	mv	a0,s7
    800032da:	00000097          	auipc	ra,0x0
    800032de:	cb4080e7          	jalr	-844(ra) # 80002f8e <bread>
    800032e2:	84aa                	mv	s1,a0
  memset(bp->data, 0, BSIZE);
    800032e4:	40000613          	li	a2,1024
    800032e8:	4581                	li	a1,0
    800032ea:	05850513          	addi	a0,a0,88
    800032ee:	ffffe097          	auipc	ra,0xffffe
    800032f2:	a46080e7          	jalr	-1466(ra) # 80000d34 <memset>
  log_write(bp);
    800032f6:	8526                	mv	a0,s1
    800032f8:	00001097          	auipc	ra,0x1
    800032fc:	0a2080e7          	jalr	162(ra) # 8000439a <log_write>
  brelse(bp);
    80003300:	8526                	mv	a0,s1
    80003302:	00000097          	auipc	ra,0x0
    80003306:	dce080e7          	jalr	-562(ra) # 800030d0 <brelse>
}
    8000330a:	854a                	mv	a0,s2
    8000330c:	60e6                	ld	ra,88(sp)
    8000330e:	6446                	ld	s0,80(sp)
    80003310:	64a6                	ld	s1,72(sp)
    80003312:	6906                	ld	s2,64(sp)
    80003314:	79e2                	ld	s3,56(sp)
    80003316:	7a42                	ld	s4,48(sp)
    80003318:	7aa2                	ld	s5,40(sp)
    8000331a:	7b02                	ld	s6,32(sp)
    8000331c:	6be2                	ld	s7,24(sp)
    8000331e:	6c42                	ld	s8,16(sp)
    80003320:	6ca2                	ld	s9,8(sp)
    80003322:	6125                	addi	sp,sp,96
    80003324:	8082                	ret
    brelse(bp);
    80003326:	8526                	mv	a0,s1
    80003328:	00000097          	auipc	ra,0x0
    8000332c:	da8080e7          	jalr	-600(ra) # 800030d0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003330:	015c87bb          	addw	a5,s9,s5
    80003334:	00078a9b          	sext.w	s5,a5
    80003338:	004b2703          	lw	a4,4(s6)
    8000333c:	06eafd63          	bgeu	s5,a4,800033b6 <balloc+0x140>
    bp = bread(dev, BBLOCK(b, sb));
    80003340:	41fad79b          	sraiw	a5,s5,0x1f
    80003344:	0137d79b          	srliw	a5,a5,0x13
    80003348:	015787bb          	addw	a5,a5,s5
    8000334c:	40d7d79b          	sraiw	a5,a5,0xd
    80003350:	01cb2583          	lw	a1,28(s6)
    80003354:	9dbd                	addw	a1,a1,a5
    80003356:	855e                	mv	a0,s7
    80003358:	00000097          	auipc	ra,0x0
    8000335c:	c36080e7          	jalr	-970(ra) # 80002f8e <bread>
    80003360:	84aa                	mv	s1,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003362:	000a881b          	sext.w	a6,s5
    80003366:	004b2503          	lw	a0,4(s6)
    8000336a:	faa87ee3          	bgeu	a6,a0,80003326 <balloc+0xb0>
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000336e:	0584c603          	lbu	a2,88(s1)
    80003372:	00167793          	andi	a5,a2,1
    80003376:	df9d                	beqz	a5,800032b4 <balloc+0x3e>
    80003378:	4105053b          	subw	a0,a0,a6
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000337c:	87e2                	mv	a5,s8
    8000337e:	0107893b          	addw	s2,a5,a6
    80003382:	faa782e3          	beq	a5,a0,80003326 <balloc+0xb0>
      m = 1 << (bi % 8);
    80003386:	41f7d71b          	sraiw	a4,a5,0x1f
    8000338a:	01d7561b          	srliw	a2,a4,0x1d
    8000338e:	00f606bb          	addw	a3,a2,a5
    80003392:	0076f713          	andi	a4,a3,7
    80003396:	9f11                	subw	a4,a4,a2
    80003398:	00e9973b          	sllw	a4,s3,a4
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000339c:	4036d69b          	sraiw	a3,a3,0x3
    800033a0:	00d48633          	add	a2,s1,a3
    800033a4:	05864603          	lbu	a2,88(a2) # 1058 <_entry-0x7fffefa8>
    800033a8:	00c775b3          	and	a1,a4,a2
    800033ac:	d599                	beqz	a1,800032ba <balloc+0x44>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800033ae:	2785                	addiw	a5,a5,1
    800033b0:	fd4797e3          	bne	a5,s4,8000337e <balloc+0x108>
    800033b4:	bf8d                	j	80003326 <balloc+0xb0>
  printf("balloc: out of blocks\n");
    800033b6:	00005517          	auipc	a0,0x5
    800033ba:	1da50513          	addi	a0,a0,474 # 80008590 <syscalls+0x128>
    800033be:	ffffd097          	auipc	ra,0xffffd
    800033c2:	1f8080e7          	jalr	504(ra) # 800005b6 <printf>
  return 0;
    800033c6:	4901                	li	s2,0
    800033c8:	b789                	j	8000330a <balloc+0x94>

00000000800033ca <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800033ca:	7179                	addi	sp,sp,-48
    800033cc:	f406                	sd	ra,40(sp)
    800033ce:	f022                	sd	s0,32(sp)
    800033d0:	ec26                	sd	s1,24(sp)
    800033d2:	e84a                	sd	s2,16(sp)
    800033d4:	e44e                	sd	s3,8(sp)
    800033d6:	e052                	sd	s4,0(sp)
    800033d8:	1800                	addi	s0,sp,48
    800033da:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800033dc:	47ad                	li	a5,11
    800033de:	02b7e763          	bltu	a5,a1,8000340c <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    800033e2:	02059493          	slli	s1,a1,0x20
    800033e6:	9081                	srli	s1,s1,0x20
    800033e8:	048a                	slli	s1,s1,0x2
    800033ea:	94aa                	add	s1,s1,a0
    800033ec:	0504a903          	lw	s2,80(s1)
    800033f0:	06091e63          	bnez	s2,8000346c <bmap+0xa2>
      addr = balloc(ip->dev);
    800033f4:	4108                	lw	a0,0(a0)
    800033f6:	00000097          	auipc	ra,0x0
    800033fa:	e80080e7          	jalr	-384(ra) # 80003276 <balloc>
    800033fe:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003402:	06090563          	beqz	s2,8000346c <bmap+0xa2>
        return 0;
      ip->addrs[bn] = addr;
    80003406:	0524a823          	sw	s2,80(s1)
    8000340a:	a08d                	j	8000346c <bmap+0xa2>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000340c:	ff45849b          	addiw	s1,a1,-12
    80003410:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003414:	0ff00793          	li	a5,255
    80003418:	08e7e563          	bltu	a5,a4,800034a2 <bmap+0xd8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000341c:	08052903          	lw	s2,128(a0)
    80003420:	00091d63          	bnez	s2,8000343a <bmap+0x70>
      addr = balloc(ip->dev);
    80003424:	4108                	lw	a0,0(a0)
    80003426:	00000097          	auipc	ra,0x0
    8000342a:	e50080e7          	jalr	-432(ra) # 80003276 <balloc>
    8000342e:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003432:	02090d63          	beqz	s2,8000346c <bmap+0xa2>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003436:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    8000343a:	85ca                	mv	a1,s2
    8000343c:	0009a503          	lw	a0,0(s3)
    80003440:	00000097          	auipc	ra,0x0
    80003444:	b4e080e7          	jalr	-1202(ra) # 80002f8e <bread>
    80003448:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000344a:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000344e:	02049593          	slli	a1,s1,0x20
    80003452:	9181                	srli	a1,a1,0x20
    80003454:	058a                	slli	a1,a1,0x2
    80003456:	00b784b3          	add	s1,a5,a1
    8000345a:	0004a903          	lw	s2,0(s1)
    8000345e:	02090063          	beqz	s2,8000347e <bmap+0xb4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003462:	8552                	mv	a0,s4
    80003464:	00000097          	auipc	ra,0x0
    80003468:	c6c080e7          	jalr	-916(ra) # 800030d0 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000346c:	854a                	mv	a0,s2
    8000346e:	70a2                	ld	ra,40(sp)
    80003470:	7402                	ld	s0,32(sp)
    80003472:	64e2                	ld	s1,24(sp)
    80003474:	6942                	ld	s2,16(sp)
    80003476:	69a2                	ld	s3,8(sp)
    80003478:	6a02                	ld	s4,0(sp)
    8000347a:	6145                	addi	sp,sp,48
    8000347c:	8082                	ret
      addr = balloc(ip->dev);
    8000347e:	0009a503          	lw	a0,0(s3)
    80003482:	00000097          	auipc	ra,0x0
    80003486:	df4080e7          	jalr	-524(ra) # 80003276 <balloc>
    8000348a:	0005091b          	sext.w	s2,a0
      if(addr){
    8000348e:	fc090ae3          	beqz	s2,80003462 <bmap+0x98>
        a[bn] = addr;
    80003492:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80003496:	8552                	mv	a0,s4
    80003498:	00001097          	auipc	ra,0x1
    8000349c:	f02080e7          	jalr	-254(ra) # 8000439a <log_write>
    800034a0:	b7c9                	j	80003462 <bmap+0x98>
  panic("bmap: out of range");
    800034a2:	00005517          	auipc	a0,0x5
    800034a6:	10650513          	addi	a0,a0,262 # 800085a8 <syscalls+0x140>
    800034aa:	ffffd097          	auipc	ra,0xffffd
    800034ae:	0c2080e7          	jalr	194(ra) # 8000056c <panic>

00000000800034b2 <iget>:
{
    800034b2:	7179                	addi	sp,sp,-48
    800034b4:	f406                	sd	ra,40(sp)
    800034b6:	f022                	sd	s0,32(sp)
    800034b8:	ec26                	sd	s1,24(sp)
    800034ba:	e84a                	sd	s2,16(sp)
    800034bc:	e44e                	sd	s3,8(sp)
    800034be:	e052                	sd	s4,0(sp)
    800034c0:	1800                	addi	s0,sp,48
    800034c2:	89aa                	mv	s3,a0
    800034c4:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800034c6:	0001c517          	auipc	a0,0x1c
    800034ca:	bf250513          	addi	a0,a0,-1038 # 8001f0b8 <itable>
    800034ce:	ffffd097          	auipc	ra,0xffffd
    800034d2:	76a080e7          	jalr	1898(ra) # 80000c38 <acquire>
  empty = 0;
    800034d6:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800034d8:	0001c497          	auipc	s1,0x1c
    800034dc:	bf848493          	addi	s1,s1,-1032 # 8001f0d0 <itable+0x18>
    800034e0:	0001d697          	auipc	a3,0x1d
    800034e4:	68068693          	addi	a3,a3,1664 # 80020b60 <log>
    800034e8:	a039                	j	800034f6 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800034ea:	02090b63          	beqz	s2,80003520 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800034ee:	08848493          	addi	s1,s1,136
    800034f2:	02d48a63          	beq	s1,a3,80003526 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800034f6:	449c                	lw	a5,8(s1)
    800034f8:	fef059e3          	blez	a5,800034ea <iget+0x38>
    800034fc:	4098                	lw	a4,0(s1)
    800034fe:	ff3716e3          	bne	a4,s3,800034ea <iget+0x38>
    80003502:	40d8                	lw	a4,4(s1)
    80003504:	ff4713e3          	bne	a4,s4,800034ea <iget+0x38>
      ip->ref++;
    80003508:	2785                	addiw	a5,a5,1
    8000350a:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000350c:	0001c517          	auipc	a0,0x1c
    80003510:	bac50513          	addi	a0,a0,-1108 # 8001f0b8 <itable>
    80003514:	ffffd097          	auipc	ra,0xffffd
    80003518:	7d8080e7          	jalr	2008(ra) # 80000cec <release>
      return ip;
    8000351c:	8926                	mv	s2,s1
    8000351e:	a03d                	j	8000354c <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003520:	f7f9                	bnez	a5,800034ee <iget+0x3c>
    80003522:	8926                	mv	s2,s1
    80003524:	b7e9                	j	800034ee <iget+0x3c>
  if(empty == 0)
    80003526:	02090c63          	beqz	s2,8000355e <iget+0xac>
  ip->dev = dev;
    8000352a:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000352e:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003532:	4785                	li	a5,1
    80003534:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003538:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000353c:	0001c517          	auipc	a0,0x1c
    80003540:	b7c50513          	addi	a0,a0,-1156 # 8001f0b8 <itable>
    80003544:	ffffd097          	auipc	ra,0xffffd
    80003548:	7a8080e7          	jalr	1960(ra) # 80000cec <release>
}
    8000354c:	854a                	mv	a0,s2
    8000354e:	70a2                	ld	ra,40(sp)
    80003550:	7402                	ld	s0,32(sp)
    80003552:	64e2                	ld	s1,24(sp)
    80003554:	6942                	ld	s2,16(sp)
    80003556:	69a2                	ld	s3,8(sp)
    80003558:	6a02                	ld	s4,0(sp)
    8000355a:	6145                	addi	sp,sp,48
    8000355c:	8082                	ret
    panic("iget: no inodes");
    8000355e:	00005517          	auipc	a0,0x5
    80003562:	06250513          	addi	a0,a0,98 # 800085c0 <syscalls+0x158>
    80003566:	ffffd097          	auipc	ra,0xffffd
    8000356a:	006080e7          	jalr	6(ra) # 8000056c <panic>

000000008000356e <fsinit>:
fsinit(int dev) {
    8000356e:	7179                	addi	sp,sp,-48
    80003570:	f406                	sd	ra,40(sp)
    80003572:	f022                	sd	s0,32(sp)
    80003574:	ec26                	sd	s1,24(sp)
    80003576:	e84a                	sd	s2,16(sp)
    80003578:	e44e                	sd	s3,8(sp)
    8000357a:	1800                	addi	s0,sp,48
    8000357c:	89aa                	mv	s3,a0
  bp = bread(dev, 1);
    8000357e:	4585                	li	a1,1
    80003580:	00000097          	auipc	ra,0x0
    80003584:	a0e080e7          	jalr	-1522(ra) # 80002f8e <bread>
    80003588:	892a                	mv	s2,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000358a:	0001c497          	auipc	s1,0x1c
    8000358e:	b0e48493          	addi	s1,s1,-1266 # 8001f098 <sb>
    80003592:	02000613          	li	a2,32
    80003596:	05850593          	addi	a1,a0,88
    8000359a:	8526                	mv	a0,s1
    8000359c:	ffffe097          	auipc	ra,0xffffe
    800035a0:	804080e7          	jalr	-2044(ra) # 80000da0 <memmove>
  brelse(bp);
    800035a4:	854a                	mv	a0,s2
    800035a6:	00000097          	auipc	ra,0x0
    800035aa:	b2a080e7          	jalr	-1238(ra) # 800030d0 <brelse>
  if(sb.magic != FSMAGIC)
    800035ae:	4098                	lw	a4,0(s1)
    800035b0:	102037b7          	lui	a5,0x10203
    800035b4:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800035b8:	02f71263          	bne	a4,a5,800035dc <fsinit+0x6e>
  initlog(dev, &sb);
    800035bc:	0001c597          	auipc	a1,0x1c
    800035c0:	adc58593          	addi	a1,a1,-1316 # 8001f098 <sb>
    800035c4:	854e                	mv	a0,s3
    800035c6:	00001097          	auipc	ra,0x1
    800035ca:	b52080e7          	jalr	-1198(ra) # 80004118 <initlog>
}
    800035ce:	70a2                	ld	ra,40(sp)
    800035d0:	7402                	ld	s0,32(sp)
    800035d2:	64e2                	ld	s1,24(sp)
    800035d4:	6942                	ld	s2,16(sp)
    800035d6:	69a2                	ld	s3,8(sp)
    800035d8:	6145                	addi	sp,sp,48
    800035da:	8082                	ret
    panic("invalid file system");
    800035dc:	00005517          	auipc	a0,0x5
    800035e0:	ff450513          	addi	a0,a0,-12 # 800085d0 <syscalls+0x168>
    800035e4:	ffffd097          	auipc	ra,0xffffd
    800035e8:	f88080e7          	jalr	-120(ra) # 8000056c <panic>

00000000800035ec <iinit>:
{
    800035ec:	7179                	addi	sp,sp,-48
    800035ee:	f406                	sd	ra,40(sp)
    800035f0:	f022                	sd	s0,32(sp)
    800035f2:	ec26                	sd	s1,24(sp)
    800035f4:	e84a                	sd	s2,16(sp)
    800035f6:	e44e                	sd	s3,8(sp)
    800035f8:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800035fa:	00005597          	auipc	a1,0x5
    800035fe:	fee58593          	addi	a1,a1,-18 # 800085e8 <syscalls+0x180>
    80003602:	0001c517          	auipc	a0,0x1c
    80003606:	ab650513          	addi	a0,a0,-1354 # 8001f0b8 <itable>
    8000360a:	ffffd097          	auipc	ra,0xffffd
    8000360e:	59e080e7          	jalr	1438(ra) # 80000ba8 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003612:	0001c497          	auipc	s1,0x1c
    80003616:	ace48493          	addi	s1,s1,-1330 # 8001f0e0 <itable+0x28>
    8000361a:	0001d997          	auipc	s3,0x1d
    8000361e:	55698993          	addi	s3,s3,1366 # 80020b70 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003622:	00005917          	auipc	s2,0x5
    80003626:	fce90913          	addi	s2,s2,-50 # 800085f0 <syscalls+0x188>
    8000362a:	85ca                	mv	a1,s2
    8000362c:	8526                	mv	a0,s1
    8000362e:	00001097          	auipc	ra,0x1
    80003632:	e66080e7          	jalr	-410(ra) # 80004494 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003636:	08848493          	addi	s1,s1,136
    8000363a:	ff3498e3          	bne	s1,s3,8000362a <iinit+0x3e>
}
    8000363e:	70a2                	ld	ra,40(sp)
    80003640:	7402                	ld	s0,32(sp)
    80003642:	64e2                	ld	s1,24(sp)
    80003644:	6942                	ld	s2,16(sp)
    80003646:	69a2                	ld	s3,8(sp)
    80003648:	6145                	addi	sp,sp,48
    8000364a:	8082                	ret

000000008000364c <ialloc>:
{
    8000364c:	715d                	addi	sp,sp,-80
    8000364e:	e486                	sd	ra,72(sp)
    80003650:	e0a2                	sd	s0,64(sp)
    80003652:	fc26                	sd	s1,56(sp)
    80003654:	f84a                	sd	s2,48(sp)
    80003656:	f44e                	sd	s3,40(sp)
    80003658:	f052                	sd	s4,32(sp)
    8000365a:	ec56                	sd	s5,24(sp)
    8000365c:	e85a                	sd	s6,16(sp)
    8000365e:	e45e                	sd	s7,8(sp)
    80003660:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80003662:	0001c797          	auipc	a5,0x1c
    80003666:	a3678793          	addi	a5,a5,-1482 # 8001f098 <sb>
    8000366a:	47d8                	lw	a4,12(a5)
    8000366c:	4785                	li	a5,1
    8000366e:	04e7fa63          	bgeu	a5,a4,800036c2 <ialloc+0x76>
    80003672:	8a2a                	mv	s4,a0
    80003674:	8b2e                	mv	s6,a1
    80003676:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003678:	0001c997          	auipc	s3,0x1c
    8000367c:	a2098993          	addi	s3,s3,-1504 # 8001f098 <sb>
    80003680:	00048a9b          	sext.w	s5,s1
    80003684:	0044d593          	srli	a1,s1,0x4
    80003688:	0189a783          	lw	a5,24(s3)
    8000368c:	9dbd                	addw	a1,a1,a5
    8000368e:	8552                	mv	a0,s4
    80003690:	00000097          	auipc	ra,0x0
    80003694:	8fe080e7          	jalr	-1794(ra) # 80002f8e <bread>
    80003698:	8baa                	mv	s7,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000369a:	05850913          	addi	s2,a0,88
    8000369e:	00f4f793          	andi	a5,s1,15
    800036a2:	079a                	slli	a5,a5,0x6
    800036a4:	993e                	add	s2,s2,a5
    if(dip->type == 0){  // a free inode
    800036a6:	00091783          	lh	a5,0(s2)
    800036aa:	c3a1                	beqz	a5,800036ea <ialloc+0x9e>
    brelse(bp);
    800036ac:	00000097          	auipc	ra,0x0
    800036b0:	a24080e7          	jalr	-1500(ra) # 800030d0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800036b4:	0485                	addi	s1,s1,1
    800036b6:	00c9a703          	lw	a4,12(s3)
    800036ba:	0004879b          	sext.w	a5,s1
    800036be:	fce7e1e3          	bltu	a5,a4,80003680 <ialloc+0x34>
  printf("ialloc: no inodes\n");
    800036c2:	00005517          	auipc	a0,0x5
    800036c6:	f3650513          	addi	a0,a0,-202 # 800085f8 <syscalls+0x190>
    800036ca:	ffffd097          	auipc	ra,0xffffd
    800036ce:	eec080e7          	jalr	-276(ra) # 800005b6 <printf>
  return 0;
    800036d2:	4501                	li	a0,0
}
    800036d4:	60a6                	ld	ra,72(sp)
    800036d6:	6406                	ld	s0,64(sp)
    800036d8:	74e2                	ld	s1,56(sp)
    800036da:	7942                	ld	s2,48(sp)
    800036dc:	79a2                	ld	s3,40(sp)
    800036de:	7a02                	ld	s4,32(sp)
    800036e0:	6ae2                	ld	s5,24(sp)
    800036e2:	6b42                	ld	s6,16(sp)
    800036e4:	6ba2                	ld	s7,8(sp)
    800036e6:	6161                	addi	sp,sp,80
    800036e8:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800036ea:	04000613          	li	a2,64
    800036ee:	4581                	li	a1,0
    800036f0:	854a                	mv	a0,s2
    800036f2:	ffffd097          	auipc	ra,0xffffd
    800036f6:	642080e7          	jalr	1602(ra) # 80000d34 <memset>
      dip->type = type;
    800036fa:	01691023          	sh	s6,0(s2)
      log_write(bp);   // mark it allocated on the disk
    800036fe:	855e                	mv	a0,s7
    80003700:	00001097          	auipc	ra,0x1
    80003704:	c9a080e7          	jalr	-870(ra) # 8000439a <log_write>
      brelse(bp);
    80003708:	855e                	mv	a0,s7
    8000370a:	00000097          	auipc	ra,0x0
    8000370e:	9c6080e7          	jalr	-1594(ra) # 800030d0 <brelse>
      return iget(dev, inum);
    80003712:	85d6                	mv	a1,s5
    80003714:	8552                	mv	a0,s4
    80003716:	00000097          	auipc	ra,0x0
    8000371a:	d9c080e7          	jalr	-612(ra) # 800034b2 <iget>
    8000371e:	bf5d                	j	800036d4 <ialloc+0x88>

0000000080003720 <iupdate>:
{
    80003720:	1101                	addi	sp,sp,-32
    80003722:	ec06                	sd	ra,24(sp)
    80003724:	e822                	sd	s0,16(sp)
    80003726:	e426                	sd	s1,8(sp)
    80003728:	e04a                	sd	s2,0(sp)
    8000372a:	1000                	addi	s0,sp,32
    8000372c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000372e:	415c                	lw	a5,4(a0)
    80003730:	0047d79b          	srliw	a5,a5,0x4
    80003734:	0001c717          	auipc	a4,0x1c
    80003738:	96470713          	addi	a4,a4,-1692 # 8001f098 <sb>
    8000373c:	4f0c                	lw	a1,24(a4)
    8000373e:	9dbd                	addw	a1,a1,a5
    80003740:	4108                	lw	a0,0(a0)
    80003742:	00000097          	auipc	ra,0x0
    80003746:	84c080e7          	jalr	-1972(ra) # 80002f8e <bread>
    8000374a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000374c:	05850513          	addi	a0,a0,88
    80003750:	40dc                	lw	a5,4(s1)
    80003752:	8bbd                	andi	a5,a5,15
    80003754:	079a                	slli	a5,a5,0x6
    80003756:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80003758:	04449783          	lh	a5,68(s1)
    8000375c:	00f51023          	sh	a5,0(a0)
  dip->major = ip->major;
    80003760:	04649783          	lh	a5,70(s1)
    80003764:	00f51123          	sh	a5,2(a0)
  dip->minor = ip->minor;
    80003768:	04849783          	lh	a5,72(s1)
    8000376c:	00f51223          	sh	a5,4(a0)
  dip->nlink = ip->nlink;
    80003770:	04a49783          	lh	a5,74(s1)
    80003774:	00f51323          	sh	a5,6(a0)
  dip->size = ip->size;
    80003778:	44fc                	lw	a5,76(s1)
    8000377a:	c51c                	sw	a5,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000377c:	03400613          	li	a2,52
    80003780:	05048593          	addi	a1,s1,80
    80003784:	0531                	addi	a0,a0,12
    80003786:	ffffd097          	auipc	ra,0xffffd
    8000378a:	61a080e7          	jalr	1562(ra) # 80000da0 <memmove>
  log_write(bp);
    8000378e:	854a                	mv	a0,s2
    80003790:	00001097          	auipc	ra,0x1
    80003794:	c0a080e7          	jalr	-1014(ra) # 8000439a <log_write>
  brelse(bp);
    80003798:	854a                	mv	a0,s2
    8000379a:	00000097          	auipc	ra,0x0
    8000379e:	936080e7          	jalr	-1738(ra) # 800030d0 <brelse>
}
    800037a2:	60e2                	ld	ra,24(sp)
    800037a4:	6442                	ld	s0,16(sp)
    800037a6:	64a2                	ld	s1,8(sp)
    800037a8:	6902                	ld	s2,0(sp)
    800037aa:	6105                	addi	sp,sp,32
    800037ac:	8082                	ret

00000000800037ae <idup>:
{
    800037ae:	1101                	addi	sp,sp,-32
    800037b0:	ec06                	sd	ra,24(sp)
    800037b2:	e822                	sd	s0,16(sp)
    800037b4:	e426                	sd	s1,8(sp)
    800037b6:	1000                	addi	s0,sp,32
    800037b8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800037ba:	0001c517          	auipc	a0,0x1c
    800037be:	8fe50513          	addi	a0,a0,-1794 # 8001f0b8 <itable>
    800037c2:	ffffd097          	auipc	ra,0xffffd
    800037c6:	476080e7          	jalr	1142(ra) # 80000c38 <acquire>
  ip->ref++;
    800037ca:	449c                	lw	a5,8(s1)
    800037cc:	2785                	addiw	a5,a5,1
    800037ce:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800037d0:	0001c517          	auipc	a0,0x1c
    800037d4:	8e850513          	addi	a0,a0,-1816 # 8001f0b8 <itable>
    800037d8:	ffffd097          	auipc	ra,0xffffd
    800037dc:	514080e7          	jalr	1300(ra) # 80000cec <release>
}
    800037e0:	8526                	mv	a0,s1
    800037e2:	60e2                	ld	ra,24(sp)
    800037e4:	6442                	ld	s0,16(sp)
    800037e6:	64a2                	ld	s1,8(sp)
    800037e8:	6105                	addi	sp,sp,32
    800037ea:	8082                	ret

00000000800037ec <ilock>:
{
    800037ec:	1101                	addi	sp,sp,-32
    800037ee:	ec06                	sd	ra,24(sp)
    800037f0:	e822                	sd	s0,16(sp)
    800037f2:	e426                	sd	s1,8(sp)
    800037f4:	e04a                	sd	s2,0(sp)
    800037f6:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800037f8:	c115                	beqz	a0,8000381c <ilock+0x30>
    800037fa:	84aa                	mv	s1,a0
    800037fc:	451c                	lw	a5,8(a0)
    800037fe:	00f05f63          	blez	a5,8000381c <ilock+0x30>
  acquiresleep(&ip->lock);
    80003802:	0541                	addi	a0,a0,16
    80003804:	00001097          	auipc	ra,0x1
    80003808:	cca080e7          	jalr	-822(ra) # 800044ce <acquiresleep>
  if(ip->valid == 0){
    8000380c:	40bc                	lw	a5,64(s1)
    8000380e:	cf99                	beqz	a5,8000382c <ilock+0x40>
}
    80003810:	60e2                	ld	ra,24(sp)
    80003812:	6442                	ld	s0,16(sp)
    80003814:	64a2                	ld	s1,8(sp)
    80003816:	6902                	ld	s2,0(sp)
    80003818:	6105                	addi	sp,sp,32
    8000381a:	8082                	ret
    panic("ilock");
    8000381c:	00005517          	auipc	a0,0x5
    80003820:	df450513          	addi	a0,a0,-524 # 80008610 <syscalls+0x1a8>
    80003824:	ffffd097          	auipc	ra,0xffffd
    80003828:	d48080e7          	jalr	-696(ra) # 8000056c <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000382c:	40dc                	lw	a5,4(s1)
    8000382e:	0047d79b          	srliw	a5,a5,0x4
    80003832:	0001c717          	auipc	a4,0x1c
    80003836:	86670713          	addi	a4,a4,-1946 # 8001f098 <sb>
    8000383a:	4f0c                	lw	a1,24(a4)
    8000383c:	9dbd                	addw	a1,a1,a5
    8000383e:	4088                	lw	a0,0(s1)
    80003840:	fffff097          	auipc	ra,0xfffff
    80003844:	74e080e7          	jalr	1870(ra) # 80002f8e <bread>
    80003848:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000384a:	05850593          	addi	a1,a0,88
    8000384e:	40dc                	lw	a5,4(s1)
    80003850:	8bbd                	andi	a5,a5,15
    80003852:	079a                	slli	a5,a5,0x6
    80003854:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003856:	00059783          	lh	a5,0(a1)
    8000385a:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000385e:	00259783          	lh	a5,2(a1)
    80003862:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003866:	00459783          	lh	a5,4(a1)
    8000386a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000386e:	00659783          	lh	a5,6(a1)
    80003872:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003876:	459c                	lw	a5,8(a1)
    80003878:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000387a:	03400613          	li	a2,52
    8000387e:	05b1                	addi	a1,a1,12
    80003880:	05048513          	addi	a0,s1,80
    80003884:	ffffd097          	auipc	ra,0xffffd
    80003888:	51c080e7          	jalr	1308(ra) # 80000da0 <memmove>
    brelse(bp);
    8000388c:	854a                	mv	a0,s2
    8000388e:	00000097          	auipc	ra,0x0
    80003892:	842080e7          	jalr	-1982(ra) # 800030d0 <brelse>
    ip->valid = 1;
    80003896:	4785                	li	a5,1
    80003898:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    8000389a:	04449783          	lh	a5,68(s1)
    8000389e:	fbad                	bnez	a5,80003810 <ilock+0x24>
      panic("ilock: no type");
    800038a0:	00005517          	auipc	a0,0x5
    800038a4:	d7850513          	addi	a0,a0,-648 # 80008618 <syscalls+0x1b0>
    800038a8:	ffffd097          	auipc	ra,0xffffd
    800038ac:	cc4080e7          	jalr	-828(ra) # 8000056c <panic>

00000000800038b0 <iunlock>:
{
    800038b0:	1101                	addi	sp,sp,-32
    800038b2:	ec06                	sd	ra,24(sp)
    800038b4:	e822                	sd	s0,16(sp)
    800038b6:	e426                	sd	s1,8(sp)
    800038b8:	e04a                	sd	s2,0(sp)
    800038ba:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800038bc:	c905                	beqz	a0,800038ec <iunlock+0x3c>
    800038be:	84aa                	mv	s1,a0
    800038c0:	01050913          	addi	s2,a0,16
    800038c4:	854a                	mv	a0,s2
    800038c6:	00001097          	auipc	ra,0x1
    800038ca:	ca2080e7          	jalr	-862(ra) # 80004568 <holdingsleep>
    800038ce:	cd19                	beqz	a0,800038ec <iunlock+0x3c>
    800038d0:	449c                	lw	a5,8(s1)
    800038d2:	00f05d63          	blez	a5,800038ec <iunlock+0x3c>
  releasesleep(&ip->lock);
    800038d6:	854a                	mv	a0,s2
    800038d8:	00001097          	auipc	ra,0x1
    800038dc:	c4c080e7          	jalr	-948(ra) # 80004524 <releasesleep>
}
    800038e0:	60e2                	ld	ra,24(sp)
    800038e2:	6442                	ld	s0,16(sp)
    800038e4:	64a2                	ld	s1,8(sp)
    800038e6:	6902                	ld	s2,0(sp)
    800038e8:	6105                	addi	sp,sp,32
    800038ea:	8082                	ret
    panic("iunlock");
    800038ec:	00005517          	auipc	a0,0x5
    800038f0:	d3c50513          	addi	a0,a0,-708 # 80008628 <syscalls+0x1c0>
    800038f4:	ffffd097          	auipc	ra,0xffffd
    800038f8:	c78080e7          	jalr	-904(ra) # 8000056c <panic>

00000000800038fc <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800038fc:	7179                	addi	sp,sp,-48
    800038fe:	f406                	sd	ra,40(sp)
    80003900:	f022                	sd	s0,32(sp)
    80003902:	ec26                	sd	s1,24(sp)
    80003904:	e84a                	sd	s2,16(sp)
    80003906:	e44e                	sd	s3,8(sp)
    80003908:	e052                	sd	s4,0(sp)
    8000390a:	1800                	addi	s0,sp,48
    8000390c:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    8000390e:	05050493          	addi	s1,a0,80
    80003912:	08050913          	addi	s2,a0,128
    80003916:	a821                	j	8000392e <itrunc+0x32>
    if(ip->addrs[i]){
      bfree(ip->dev, ip->addrs[i]);
    80003918:	0009a503          	lw	a0,0(s3)
    8000391c:	00000097          	auipc	ra,0x0
    80003920:	8ca080e7          	jalr	-1846(ra) # 800031e6 <bfree>
      ip->addrs[i] = 0;
    80003924:	0004a023          	sw	zero,0(s1)
  for(i = 0; i < NDIRECT; i++){
    80003928:	0491                	addi	s1,s1,4
    8000392a:	01248563          	beq	s1,s2,80003934 <itrunc+0x38>
    if(ip->addrs[i]){
    8000392e:	408c                	lw	a1,0(s1)
    80003930:	dde5                	beqz	a1,80003928 <itrunc+0x2c>
    80003932:	b7dd                	j	80003918 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003934:	0809a583          	lw	a1,128(s3)
    80003938:	e185                	bnez	a1,80003958 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000393a:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000393e:	854e                	mv	a0,s3
    80003940:	00000097          	auipc	ra,0x0
    80003944:	de0080e7          	jalr	-544(ra) # 80003720 <iupdate>
}
    80003948:	70a2                	ld	ra,40(sp)
    8000394a:	7402                	ld	s0,32(sp)
    8000394c:	64e2                	ld	s1,24(sp)
    8000394e:	6942                	ld	s2,16(sp)
    80003950:	69a2                	ld	s3,8(sp)
    80003952:	6a02                	ld	s4,0(sp)
    80003954:	6145                	addi	sp,sp,48
    80003956:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003958:	0009a503          	lw	a0,0(s3)
    8000395c:	fffff097          	auipc	ra,0xfffff
    80003960:	632080e7          	jalr	1586(ra) # 80002f8e <bread>
    80003964:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003966:	05850493          	addi	s1,a0,88
    8000396a:	45850913          	addi	s2,a0,1112
    8000396e:	a811                	j	80003982 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80003970:	0009a503          	lw	a0,0(s3)
    80003974:	00000097          	auipc	ra,0x0
    80003978:	872080e7          	jalr	-1934(ra) # 800031e6 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    8000397c:	0491                	addi	s1,s1,4
    8000397e:	01248563          	beq	s1,s2,80003988 <itrunc+0x8c>
      if(a[j])
    80003982:	408c                	lw	a1,0(s1)
    80003984:	dde5                	beqz	a1,8000397c <itrunc+0x80>
    80003986:	b7ed                	j	80003970 <itrunc+0x74>
    brelse(bp);
    80003988:	8552                	mv	a0,s4
    8000398a:	fffff097          	auipc	ra,0xfffff
    8000398e:	746080e7          	jalr	1862(ra) # 800030d0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003992:	0809a583          	lw	a1,128(s3)
    80003996:	0009a503          	lw	a0,0(s3)
    8000399a:	00000097          	auipc	ra,0x0
    8000399e:	84c080e7          	jalr	-1972(ra) # 800031e6 <bfree>
    ip->addrs[NDIRECT] = 0;
    800039a2:	0809a023          	sw	zero,128(s3)
    800039a6:	bf51                	j	8000393a <itrunc+0x3e>

00000000800039a8 <iput>:
{
    800039a8:	1101                	addi	sp,sp,-32
    800039aa:	ec06                	sd	ra,24(sp)
    800039ac:	e822                	sd	s0,16(sp)
    800039ae:	e426                	sd	s1,8(sp)
    800039b0:	e04a                	sd	s2,0(sp)
    800039b2:	1000                	addi	s0,sp,32
    800039b4:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800039b6:	0001b517          	auipc	a0,0x1b
    800039ba:	70250513          	addi	a0,a0,1794 # 8001f0b8 <itable>
    800039be:	ffffd097          	auipc	ra,0xffffd
    800039c2:	27a080e7          	jalr	634(ra) # 80000c38 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800039c6:	4498                	lw	a4,8(s1)
    800039c8:	4785                	li	a5,1
    800039ca:	02f70363          	beq	a4,a5,800039f0 <iput+0x48>
  ip->ref--;
    800039ce:	449c                	lw	a5,8(s1)
    800039d0:	37fd                	addiw	a5,a5,-1
    800039d2:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800039d4:	0001b517          	auipc	a0,0x1b
    800039d8:	6e450513          	addi	a0,a0,1764 # 8001f0b8 <itable>
    800039dc:	ffffd097          	auipc	ra,0xffffd
    800039e0:	310080e7          	jalr	784(ra) # 80000cec <release>
}
    800039e4:	60e2                	ld	ra,24(sp)
    800039e6:	6442                	ld	s0,16(sp)
    800039e8:	64a2                	ld	s1,8(sp)
    800039ea:	6902                	ld	s2,0(sp)
    800039ec:	6105                	addi	sp,sp,32
    800039ee:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800039f0:	40bc                	lw	a5,64(s1)
    800039f2:	dff1                	beqz	a5,800039ce <iput+0x26>
    800039f4:	04a49783          	lh	a5,74(s1)
    800039f8:	fbf9                	bnez	a5,800039ce <iput+0x26>
    acquiresleep(&ip->lock);
    800039fa:	01048913          	addi	s2,s1,16
    800039fe:	854a                	mv	a0,s2
    80003a00:	00001097          	auipc	ra,0x1
    80003a04:	ace080e7          	jalr	-1330(ra) # 800044ce <acquiresleep>
    release(&itable.lock);
    80003a08:	0001b517          	auipc	a0,0x1b
    80003a0c:	6b050513          	addi	a0,a0,1712 # 8001f0b8 <itable>
    80003a10:	ffffd097          	auipc	ra,0xffffd
    80003a14:	2dc080e7          	jalr	732(ra) # 80000cec <release>
    itrunc(ip);
    80003a18:	8526                	mv	a0,s1
    80003a1a:	00000097          	auipc	ra,0x0
    80003a1e:	ee2080e7          	jalr	-286(ra) # 800038fc <itrunc>
    ip->type = 0;
    80003a22:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003a26:	8526                	mv	a0,s1
    80003a28:	00000097          	auipc	ra,0x0
    80003a2c:	cf8080e7          	jalr	-776(ra) # 80003720 <iupdate>
    ip->valid = 0;
    80003a30:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003a34:	854a                	mv	a0,s2
    80003a36:	00001097          	auipc	ra,0x1
    80003a3a:	aee080e7          	jalr	-1298(ra) # 80004524 <releasesleep>
    acquire(&itable.lock);
    80003a3e:	0001b517          	auipc	a0,0x1b
    80003a42:	67a50513          	addi	a0,a0,1658 # 8001f0b8 <itable>
    80003a46:	ffffd097          	auipc	ra,0xffffd
    80003a4a:	1f2080e7          	jalr	498(ra) # 80000c38 <acquire>
    80003a4e:	b741                	j	800039ce <iput+0x26>

0000000080003a50 <iunlockput>:
{
    80003a50:	1101                	addi	sp,sp,-32
    80003a52:	ec06                	sd	ra,24(sp)
    80003a54:	e822                	sd	s0,16(sp)
    80003a56:	e426                	sd	s1,8(sp)
    80003a58:	1000                	addi	s0,sp,32
    80003a5a:	84aa                	mv	s1,a0
  iunlock(ip);
    80003a5c:	00000097          	auipc	ra,0x0
    80003a60:	e54080e7          	jalr	-428(ra) # 800038b0 <iunlock>
  iput(ip);
    80003a64:	8526                	mv	a0,s1
    80003a66:	00000097          	auipc	ra,0x0
    80003a6a:	f42080e7          	jalr	-190(ra) # 800039a8 <iput>
}
    80003a6e:	60e2                	ld	ra,24(sp)
    80003a70:	6442                	ld	s0,16(sp)
    80003a72:	64a2                	ld	s1,8(sp)
    80003a74:	6105                	addi	sp,sp,32
    80003a76:	8082                	ret

0000000080003a78 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003a78:	1141                	addi	sp,sp,-16
    80003a7a:	e422                	sd	s0,8(sp)
    80003a7c:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003a7e:	411c                	lw	a5,0(a0)
    80003a80:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003a82:	415c                	lw	a5,4(a0)
    80003a84:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003a86:	04451783          	lh	a5,68(a0)
    80003a8a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003a8e:	04a51783          	lh	a5,74(a0)
    80003a92:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003a96:	04c56783          	lwu	a5,76(a0)
    80003a9a:	e99c                	sd	a5,16(a1)
}
    80003a9c:	6422                	ld	s0,8(sp)
    80003a9e:	0141                	addi	sp,sp,16
    80003aa0:	8082                	ret

0000000080003aa2 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003aa2:	457c                	lw	a5,76(a0)
    80003aa4:	0ed7e963          	bltu	a5,a3,80003b96 <readi+0xf4>
{
    80003aa8:	7159                	addi	sp,sp,-112
    80003aaa:	f486                	sd	ra,104(sp)
    80003aac:	f0a2                	sd	s0,96(sp)
    80003aae:	eca6                	sd	s1,88(sp)
    80003ab0:	e8ca                	sd	s2,80(sp)
    80003ab2:	e4ce                	sd	s3,72(sp)
    80003ab4:	e0d2                	sd	s4,64(sp)
    80003ab6:	fc56                	sd	s5,56(sp)
    80003ab8:	f85a                	sd	s6,48(sp)
    80003aba:	f45e                	sd	s7,40(sp)
    80003abc:	f062                	sd	s8,32(sp)
    80003abe:	ec66                	sd	s9,24(sp)
    80003ac0:	e86a                	sd	s10,16(sp)
    80003ac2:	e46e                	sd	s11,8(sp)
    80003ac4:	1880                	addi	s0,sp,112
    80003ac6:	8baa                	mv	s7,a0
    80003ac8:	8c2e                	mv	s8,a1
    80003aca:	8a32                	mv	s4,a2
    80003acc:	84b6                	mv	s1,a3
    80003ace:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003ad0:	9f35                	addw	a4,a4,a3
    return 0;
    80003ad2:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003ad4:	0ad76063          	bltu	a4,a3,80003b74 <readi+0xd2>
  if(off + n > ip->size)
    80003ad8:	00e7f463          	bgeu	a5,a4,80003ae0 <readi+0x3e>
    n = ip->size - off;
    80003adc:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003ae0:	0a0b0963          	beqz	s6,80003b92 <readi+0xf0>
    80003ae4:	4901                	li	s2,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003ae6:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003aea:	5cfd                	li	s9,-1
    80003aec:	a82d                	j	80003b26 <readi+0x84>
    80003aee:	02099d93          	slli	s11,s3,0x20
    80003af2:	020ddd93          	srli	s11,s11,0x20
    80003af6:	058a8613          	addi	a2,s5,88
    80003afa:	86ee                	mv	a3,s11
    80003afc:	963a                	add	a2,a2,a4
    80003afe:	85d2                	mv	a1,s4
    80003b00:	8562                	mv	a0,s8
    80003b02:	fffff097          	auipc	ra,0xfffff
    80003b06:	9ea080e7          	jalr	-1558(ra) # 800024ec <either_copyout>
    80003b0a:	05950d63          	beq	a0,s9,80003b64 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003b0e:	8556                	mv	a0,s5
    80003b10:	fffff097          	auipc	ra,0xfffff
    80003b14:	5c0080e7          	jalr	1472(ra) # 800030d0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003b18:	0129893b          	addw	s2,s3,s2
    80003b1c:	009984bb          	addw	s1,s3,s1
    80003b20:	9a6e                	add	s4,s4,s11
    80003b22:	05697763          	bgeu	s2,s6,80003b70 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80003b26:	00a4d59b          	srliw	a1,s1,0xa
    80003b2a:	855e                	mv	a0,s7
    80003b2c:	00000097          	auipc	ra,0x0
    80003b30:	89e080e7          	jalr	-1890(ra) # 800033ca <bmap>
    80003b34:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003b38:	cd85                	beqz	a1,80003b70 <readi+0xce>
    bp = bread(ip->dev, addr);
    80003b3a:	000ba503          	lw	a0,0(s7)
    80003b3e:	fffff097          	auipc	ra,0xfffff
    80003b42:	450080e7          	jalr	1104(ra) # 80002f8e <bread>
    80003b46:	8aaa                	mv	s5,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003b48:	3ff4f713          	andi	a4,s1,1023
    80003b4c:	40ed07bb          	subw	a5,s10,a4
    80003b50:	412b06bb          	subw	a3,s6,s2
    80003b54:	89be                	mv	s3,a5
    80003b56:	2781                	sext.w	a5,a5
    80003b58:	0006861b          	sext.w	a2,a3
    80003b5c:	f8f679e3          	bgeu	a2,a5,80003aee <readi+0x4c>
    80003b60:	89b6                	mv	s3,a3
    80003b62:	b771                	j	80003aee <readi+0x4c>
      brelse(bp);
    80003b64:	8556                	mv	a0,s5
    80003b66:	fffff097          	auipc	ra,0xfffff
    80003b6a:	56a080e7          	jalr	1386(ra) # 800030d0 <brelse>
      tot = -1;
    80003b6e:	597d                	li	s2,-1
  }
  return tot;
    80003b70:	0009051b          	sext.w	a0,s2
}
    80003b74:	70a6                	ld	ra,104(sp)
    80003b76:	7406                	ld	s0,96(sp)
    80003b78:	64e6                	ld	s1,88(sp)
    80003b7a:	6946                	ld	s2,80(sp)
    80003b7c:	69a6                	ld	s3,72(sp)
    80003b7e:	6a06                	ld	s4,64(sp)
    80003b80:	7ae2                	ld	s5,56(sp)
    80003b82:	7b42                	ld	s6,48(sp)
    80003b84:	7ba2                	ld	s7,40(sp)
    80003b86:	7c02                	ld	s8,32(sp)
    80003b88:	6ce2                	ld	s9,24(sp)
    80003b8a:	6d42                	ld	s10,16(sp)
    80003b8c:	6da2                	ld	s11,8(sp)
    80003b8e:	6165                	addi	sp,sp,112
    80003b90:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003b92:	895a                	mv	s2,s6
    80003b94:	bff1                	j	80003b70 <readi+0xce>
    return 0;
    80003b96:	4501                	li	a0,0
}
    80003b98:	8082                	ret

0000000080003b9a <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003b9a:	457c                	lw	a5,76(a0)
    80003b9c:	10d7e863          	bltu	a5,a3,80003cac <writei+0x112>
{
    80003ba0:	7159                	addi	sp,sp,-112
    80003ba2:	f486                	sd	ra,104(sp)
    80003ba4:	f0a2                	sd	s0,96(sp)
    80003ba6:	eca6                	sd	s1,88(sp)
    80003ba8:	e8ca                	sd	s2,80(sp)
    80003baa:	e4ce                	sd	s3,72(sp)
    80003bac:	e0d2                	sd	s4,64(sp)
    80003bae:	fc56                	sd	s5,56(sp)
    80003bb0:	f85a                	sd	s6,48(sp)
    80003bb2:	f45e                	sd	s7,40(sp)
    80003bb4:	f062                	sd	s8,32(sp)
    80003bb6:	ec66                	sd	s9,24(sp)
    80003bb8:	e86a                	sd	s10,16(sp)
    80003bba:	e46e                	sd	s11,8(sp)
    80003bbc:	1880                	addi	s0,sp,112
    80003bbe:	8b2a                	mv	s6,a0
    80003bc0:	8c2e                	mv	s8,a1
    80003bc2:	8ab2                	mv	s5,a2
    80003bc4:	84b6                	mv	s1,a3
    80003bc6:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80003bc8:	00e687bb          	addw	a5,a3,a4
    80003bcc:	0ed7e263          	bltu	a5,a3,80003cb0 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003bd0:	00043737          	lui	a4,0x43
    80003bd4:	0ef76063          	bltu	a4,a5,80003cb4 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003bd8:	0c0b8863          	beqz	s7,80003ca8 <writei+0x10e>
    80003bdc:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003bde:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003be2:	5cfd                	li	s9,-1
    80003be4:	a091                	j	80003c28 <writei+0x8e>
    80003be6:	02091d93          	slli	s11,s2,0x20
    80003bea:	020ddd93          	srli	s11,s11,0x20
    80003bee:	058a0513          	addi	a0,s4,88 # 2058 <_entry-0x7fffdfa8>
    80003bf2:	86ee                	mv	a3,s11
    80003bf4:	8656                	mv	a2,s5
    80003bf6:	85e2                	mv	a1,s8
    80003bf8:	953a                	add	a0,a0,a4
    80003bfa:	fffff097          	auipc	ra,0xfffff
    80003bfe:	948080e7          	jalr	-1720(ra) # 80002542 <either_copyin>
    80003c02:	07950263          	beq	a0,s9,80003c66 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003c06:	8552                	mv	a0,s4
    80003c08:	00000097          	auipc	ra,0x0
    80003c0c:	792080e7          	jalr	1938(ra) # 8000439a <log_write>
    brelse(bp);
    80003c10:	8552                	mv	a0,s4
    80003c12:	fffff097          	auipc	ra,0xfffff
    80003c16:	4be080e7          	jalr	1214(ra) # 800030d0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003c1a:	013909bb          	addw	s3,s2,s3
    80003c1e:	009904bb          	addw	s1,s2,s1
    80003c22:	9aee                	add	s5,s5,s11
    80003c24:	0579f663          	bgeu	s3,s7,80003c70 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80003c28:	00a4d59b          	srliw	a1,s1,0xa
    80003c2c:	855a                	mv	a0,s6
    80003c2e:	fffff097          	auipc	ra,0xfffff
    80003c32:	79c080e7          	jalr	1948(ra) # 800033ca <bmap>
    80003c36:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003c3a:	c99d                	beqz	a1,80003c70 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80003c3c:	000b2503          	lw	a0,0(s6)
    80003c40:	fffff097          	auipc	ra,0xfffff
    80003c44:	34e080e7          	jalr	846(ra) # 80002f8e <bread>
    80003c48:	8a2a                	mv	s4,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003c4a:	3ff4f713          	andi	a4,s1,1023
    80003c4e:	40ed07bb          	subw	a5,s10,a4
    80003c52:	413b86bb          	subw	a3,s7,s3
    80003c56:	893e                	mv	s2,a5
    80003c58:	2781                	sext.w	a5,a5
    80003c5a:	0006861b          	sext.w	a2,a3
    80003c5e:	f8f674e3          	bgeu	a2,a5,80003be6 <writei+0x4c>
    80003c62:	8936                	mv	s2,a3
    80003c64:	b749                	j	80003be6 <writei+0x4c>
      brelse(bp);
    80003c66:	8552                	mv	a0,s4
    80003c68:	fffff097          	auipc	ra,0xfffff
    80003c6c:	468080e7          	jalr	1128(ra) # 800030d0 <brelse>
  }

  if(off > ip->size)
    80003c70:	04cb2783          	lw	a5,76(s6)
    80003c74:	0097f463          	bgeu	a5,s1,80003c7c <writei+0xe2>
    ip->size = off;
    80003c78:	049b2623          	sw	s1,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003c7c:	855a                	mv	a0,s6
    80003c7e:	00000097          	auipc	ra,0x0
    80003c82:	aa2080e7          	jalr	-1374(ra) # 80003720 <iupdate>

  return tot;
    80003c86:	0009851b          	sext.w	a0,s3
}
    80003c8a:	70a6                	ld	ra,104(sp)
    80003c8c:	7406                	ld	s0,96(sp)
    80003c8e:	64e6                	ld	s1,88(sp)
    80003c90:	6946                	ld	s2,80(sp)
    80003c92:	69a6                	ld	s3,72(sp)
    80003c94:	6a06                	ld	s4,64(sp)
    80003c96:	7ae2                	ld	s5,56(sp)
    80003c98:	7b42                	ld	s6,48(sp)
    80003c9a:	7ba2                	ld	s7,40(sp)
    80003c9c:	7c02                	ld	s8,32(sp)
    80003c9e:	6ce2                	ld	s9,24(sp)
    80003ca0:	6d42                	ld	s10,16(sp)
    80003ca2:	6da2                	ld	s11,8(sp)
    80003ca4:	6165                	addi	sp,sp,112
    80003ca6:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003ca8:	89de                	mv	s3,s7
    80003caa:	bfc9                	j	80003c7c <writei+0xe2>
    return -1;
    80003cac:	557d                	li	a0,-1
}
    80003cae:	8082                	ret
    return -1;
    80003cb0:	557d                	li	a0,-1
    80003cb2:	bfe1                	j	80003c8a <writei+0xf0>
    return -1;
    80003cb4:	557d                	li	a0,-1
    80003cb6:	bfd1                	j	80003c8a <writei+0xf0>

0000000080003cb8 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003cb8:	1141                	addi	sp,sp,-16
    80003cba:	e406                	sd	ra,8(sp)
    80003cbc:	e022                	sd	s0,0(sp)
    80003cbe:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003cc0:	4639                	li	a2,14
    80003cc2:	ffffd097          	auipc	ra,0xffffd
    80003cc6:	156080e7          	jalr	342(ra) # 80000e18 <strncmp>
}
    80003cca:	60a2                	ld	ra,8(sp)
    80003ccc:	6402                	ld	s0,0(sp)
    80003cce:	0141                	addi	sp,sp,16
    80003cd0:	8082                	ret

0000000080003cd2 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003cd2:	7139                	addi	sp,sp,-64
    80003cd4:	fc06                	sd	ra,56(sp)
    80003cd6:	f822                	sd	s0,48(sp)
    80003cd8:	f426                	sd	s1,40(sp)
    80003cda:	f04a                	sd	s2,32(sp)
    80003cdc:	ec4e                	sd	s3,24(sp)
    80003cde:	e852                	sd	s4,16(sp)
    80003ce0:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003ce2:	04451703          	lh	a4,68(a0)
    80003ce6:	4785                	li	a5,1
    80003ce8:	00f71a63          	bne	a4,a5,80003cfc <dirlookup+0x2a>
    80003cec:	892a                	mv	s2,a0
    80003cee:	89ae                	mv	s3,a1
    80003cf0:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003cf2:	457c                	lw	a5,76(a0)
    80003cf4:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003cf6:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003cf8:	e79d                	bnez	a5,80003d26 <dirlookup+0x54>
    80003cfa:	a8a5                	j	80003d72 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003cfc:	00005517          	auipc	a0,0x5
    80003d00:	93450513          	addi	a0,a0,-1740 # 80008630 <syscalls+0x1c8>
    80003d04:	ffffd097          	auipc	ra,0xffffd
    80003d08:	868080e7          	jalr	-1944(ra) # 8000056c <panic>
      panic("dirlookup read");
    80003d0c:	00005517          	auipc	a0,0x5
    80003d10:	93c50513          	addi	a0,a0,-1732 # 80008648 <syscalls+0x1e0>
    80003d14:	ffffd097          	auipc	ra,0xffffd
    80003d18:	858080e7          	jalr	-1960(ra) # 8000056c <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003d1c:	24c1                	addiw	s1,s1,16
    80003d1e:	04c92783          	lw	a5,76(s2)
    80003d22:	04f4f763          	bgeu	s1,a5,80003d70 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003d26:	4741                	li	a4,16
    80003d28:	86a6                	mv	a3,s1
    80003d2a:	fc040613          	addi	a2,s0,-64
    80003d2e:	4581                	li	a1,0
    80003d30:	854a                	mv	a0,s2
    80003d32:	00000097          	auipc	ra,0x0
    80003d36:	d70080e7          	jalr	-656(ra) # 80003aa2 <readi>
    80003d3a:	47c1                	li	a5,16
    80003d3c:	fcf518e3          	bne	a0,a5,80003d0c <dirlookup+0x3a>
    if(de.inum == 0)
    80003d40:	fc045783          	lhu	a5,-64(s0)
    80003d44:	dfe1                	beqz	a5,80003d1c <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003d46:	fc240593          	addi	a1,s0,-62
    80003d4a:	854e                	mv	a0,s3
    80003d4c:	00000097          	auipc	ra,0x0
    80003d50:	f6c080e7          	jalr	-148(ra) # 80003cb8 <namecmp>
    80003d54:	f561                	bnez	a0,80003d1c <dirlookup+0x4a>
      if(poff)
    80003d56:	000a0463          	beqz	s4,80003d5e <dirlookup+0x8c>
        *poff = off;
    80003d5a:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003d5e:	fc045583          	lhu	a1,-64(s0)
    80003d62:	00092503          	lw	a0,0(s2)
    80003d66:	fffff097          	auipc	ra,0xfffff
    80003d6a:	74c080e7          	jalr	1868(ra) # 800034b2 <iget>
    80003d6e:	a011                	j	80003d72 <dirlookup+0xa0>
  return 0;
    80003d70:	4501                	li	a0,0
}
    80003d72:	70e2                	ld	ra,56(sp)
    80003d74:	7442                	ld	s0,48(sp)
    80003d76:	74a2                	ld	s1,40(sp)
    80003d78:	7902                	ld	s2,32(sp)
    80003d7a:	69e2                	ld	s3,24(sp)
    80003d7c:	6a42                	ld	s4,16(sp)
    80003d7e:	6121                	addi	sp,sp,64
    80003d80:	8082                	ret

0000000080003d82 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003d82:	711d                	addi	sp,sp,-96
    80003d84:	ec86                	sd	ra,88(sp)
    80003d86:	e8a2                	sd	s0,80(sp)
    80003d88:	e4a6                	sd	s1,72(sp)
    80003d8a:	e0ca                	sd	s2,64(sp)
    80003d8c:	fc4e                	sd	s3,56(sp)
    80003d8e:	f852                	sd	s4,48(sp)
    80003d90:	f456                	sd	s5,40(sp)
    80003d92:	f05a                	sd	s6,32(sp)
    80003d94:	ec5e                	sd	s7,24(sp)
    80003d96:	e862                	sd	s8,16(sp)
    80003d98:	e466                	sd	s9,8(sp)
    80003d9a:	1080                	addi	s0,sp,96
    80003d9c:	84aa                	mv	s1,a0
    80003d9e:	8bae                	mv	s7,a1
    80003da0:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003da2:	00054703          	lbu	a4,0(a0)
    80003da6:	02f00793          	li	a5,47
    80003daa:	02f70363          	beq	a4,a5,80003dd0 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003dae:	ffffe097          	auipc	ra,0xffffe
    80003db2:	c8c080e7          	jalr	-884(ra) # 80001a3a <myproc>
    80003db6:	15053503          	ld	a0,336(a0)
    80003dba:	00000097          	auipc	ra,0x0
    80003dbe:	9f4080e7          	jalr	-1548(ra) # 800037ae <idup>
    80003dc2:	89aa                	mv	s3,a0
  while(*path == '/')
    80003dc4:	02f00913          	li	s2,47
  len = path - s;
    80003dc8:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    80003dca:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003dcc:	4c05                	li	s8,1
    80003dce:	a865                	j	80003e86 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003dd0:	4585                	li	a1,1
    80003dd2:	4505                	li	a0,1
    80003dd4:	fffff097          	auipc	ra,0xfffff
    80003dd8:	6de080e7          	jalr	1758(ra) # 800034b2 <iget>
    80003ddc:	89aa                	mv	s3,a0
    80003dde:	b7dd                	j	80003dc4 <namex+0x42>
      iunlockput(ip);
    80003de0:	854e                	mv	a0,s3
    80003de2:	00000097          	auipc	ra,0x0
    80003de6:	c6e080e7          	jalr	-914(ra) # 80003a50 <iunlockput>
      return 0;
    80003dea:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003dec:	854e                	mv	a0,s3
    80003dee:	60e6                	ld	ra,88(sp)
    80003df0:	6446                	ld	s0,80(sp)
    80003df2:	64a6                	ld	s1,72(sp)
    80003df4:	6906                	ld	s2,64(sp)
    80003df6:	79e2                	ld	s3,56(sp)
    80003df8:	7a42                	ld	s4,48(sp)
    80003dfa:	7aa2                	ld	s5,40(sp)
    80003dfc:	7b02                	ld	s6,32(sp)
    80003dfe:	6be2                	ld	s7,24(sp)
    80003e00:	6c42                	ld	s8,16(sp)
    80003e02:	6ca2                	ld	s9,8(sp)
    80003e04:	6125                	addi	sp,sp,96
    80003e06:	8082                	ret
      iunlock(ip);
    80003e08:	854e                	mv	a0,s3
    80003e0a:	00000097          	auipc	ra,0x0
    80003e0e:	aa6080e7          	jalr	-1370(ra) # 800038b0 <iunlock>
      return ip;
    80003e12:	bfe9                	j	80003dec <namex+0x6a>
      iunlockput(ip);
    80003e14:	854e                	mv	a0,s3
    80003e16:	00000097          	auipc	ra,0x0
    80003e1a:	c3a080e7          	jalr	-966(ra) # 80003a50 <iunlockput>
      return 0;
    80003e1e:	89d2                	mv	s3,s4
    80003e20:	b7f1                	j	80003dec <namex+0x6a>
  len = path - s;
    80003e22:	40b48633          	sub	a2,s1,a1
    80003e26:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80003e2a:	094cd663          	bge	s9,s4,80003eb6 <namex+0x134>
    memmove(name, s, DIRSIZ);
    80003e2e:	4639                	li	a2,14
    80003e30:	8556                	mv	a0,s5
    80003e32:	ffffd097          	auipc	ra,0xffffd
    80003e36:	f6e080e7          	jalr	-146(ra) # 80000da0 <memmove>
  while(*path == '/')
    80003e3a:	0004c783          	lbu	a5,0(s1)
    80003e3e:	01279763          	bne	a5,s2,80003e4c <namex+0xca>
    path++;
    80003e42:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003e44:	0004c783          	lbu	a5,0(s1)
    80003e48:	ff278de3          	beq	a5,s2,80003e42 <namex+0xc0>
    ilock(ip);
    80003e4c:	854e                	mv	a0,s3
    80003e4e:	00000097          	auipc	ra,0x0
    80003e52:	99e080e7          	jalr	-1634(ra) # 800037ec <ilock>
    if(ip->type != T_DIR){
    80003e56:	04499783          	lh	a5,68(s3)
    80003e5a:	f98793e3          	bne	a5,s8,80003de0 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003e5e:	000b8563          	beqz	s7,80003e68 <namex+0xe6>
    80003e62:	0004c783          	lbu	a5,0(s1)
    80003e66:	d3cd                	beqz	a5,80003e08 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003e68:	865a                	mv	a2,s6
    80003e6a:	85d6                	mv	a1,s5
    80003e6c:	854e                	mv	a0,s3
    80003e6e:	00000097          	auipc	ra,0x0
    80003e72:	e64080e7          	jalr	-412(ra) # 80003cd2 <dirlookup>
    80003e76:	8a2a                	mv	s4,a0
    80003e78:	dd51                	beqz	a0,80003e14 <namex+0x92>
    iunlockput(ip);
    80003e7a:	854e                	mv	a0,s3
    80003e7c:	00000097          	auipc	ra,0x0
    80003e80:	bd4080e7          	jalr	-1068(ra) # 80003a50 <iunlockput>
    ip = next;
    80003e84:	89d2                	mv	s3,s4
  while(*path == '/')
    80003e86:	0004c783          	lbu	a5,0(s1)
    80003e8a:	05279d63          	bne	a5,s2,80003ee4 <namex+0x162>
    path++;
    80003e8e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003e90:	0004c783          	lbu	a5,0(s1)
    80003e94:	ff278de3          	beq	a5,s2,80003e8e <namex+0x10c>
  if(*path == 0)
    80003e98:	cf8d                	beqz	a5,80003ed2 <namex+0x150>
  while(*path != '/' && *path != 0)
    80003e9a:	01278b63          	beq	a5,s2,80003eb0 <namex+0x12e>
    80003e9e:	c795                	beqz	a5,80003eca <namex+0x148>
    path++;
    80003ea0:	85a6                	mv	a1,s1
    path++;
    80003ea2:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003ea4:	0004c783          	lbu	a5,0(s1)
    80003ea8:	f7278de3          	beq	a5,s2,80003e22 <namex+0xa0>
    80003eac:	fbfd                	bnez	a5,80003ea2 <namex+0x120>
    80003eae:	bf95                	j	80003e22 <namex+0xa0>
    80003eb0:	85a6                	mv	a1,s1
  len = path - s;
    80003eb2:	8a5a                	mv	s4,s6
    80003eb4:	865a                	mv	a2,s6
    memmove(name, s, len);
    80003eb6:	2601                	sext.w	a2,a2
    80003eb8:	8556                	mv	a0,s5
    80003eba:	ffffd097          	auipc	ra,0xffffd
    80003ebe:	ee6080e7          	jalr	-282(ra) # 80000da0 <memmove>
    name[len] = 0;
    80003ec2:	9a56                	add	s4,s4,s5
    80003ec4:	000a0023          	sb	zero,0(s4)
    80003ec8:	bf8d                	j	80003e3a <namex+0xb8>
  while(*path != '/' && *path != 0)
    80003eca:	85a6                	mv	a1,s1
  len = path - s;
    80003ecc:	8a5a                	mv	s4,s6
    80003ece:	865a                	mv	a2,s6
    80003ed0:	b7dd                	j	80003eb6 <namex+0x134>
  if(nameiparent){
    80003ed2:	f00b8de3          	beqz	s7,80003dec <namex+0x6a>
    iput(ip);
    80003ed6:	854e                	mv	a0,s3
    80003ed8:	00000097          	auipc	ra,0x0
    80003edc:	ad0080e7          	jalr	-1328(ra) # 800039a8 <iput>
    return 0;
    80003ee0:	4981                	li	s3,0
    80003ee2:	b729                	j	80003dec <namex+0x6a>
  if(*path == 0)
    80003ee4:	d7fd                	beqz	a5,80003ed2 <namex+0x150>
    80003ee6:	85a6                	mv	a1,s1
    80003ee8:	bf6d                	j	80003ea2 <namex+0x120>

0000000080003eea <dirlink>:
{
    80003eea:	7139                	addi	sp,sp,-64
    80003eec:	fc06                	sd	ra,56(sp)
    80003eee:	f822                	sd	s0,48(sp)
    80003ef0:	f426                	sd	s1,40(sp)
    80003ef2:	f04a                	sd	s2,32(sp)
    80003ef4:	ec4e                	sd	s3,24(sp)
    80003ef6:	e852                	sd	s4,16(sp)
    80003ef8:	0080                	addi	s0,sp,64
    80003efa:	892a                	mv	s2,a0
    80003efc:	8a2e                	mv	s4,a1
    80003efe:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003f00:	4601                	li	a2,0
    80003f02:	00000097          	auipc	ra,0x0
    80003f06:	dd0080e7          	jalr	-560(ra) # 80003cd2 <dirlookup>
    80003f0a:	ed25                	bnez	a0,80003f82 <dirlink+0x98>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003f0c:	04c92483          	lw	s1,76(s2)
    80003f10:	c49d                	beqz	s1,80003f3e <dirlink+0x54>
    80003f12:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003f14:	4741                	li	a4,16
    80003f16:	86a6                	mv	a3,s1
    80003f18:	fc040613          	addi	a2,s0,-64
    80003f1c:	4581                	li	a1,0
    80003f1e:	854a                	mv	a0,s2
    80003f20:	00000097          	auipc	ra,0x0
    80003f24:	b82080e7          	jalr	-1150(ra) # 80003aa2 <readi>
    80003f28:	47c1                	li	a5,16
    80003f2a:	06f51263          	bne	a0,a5,80003f8e <dirlink+0xa4>
    if(de.inum == 0)
    80003f2e:	fc045783          	lhu	a5,-64(s0)
    80003f32:	c791                	beqz	a5,80003f3e <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003f34:	24c1                	addiw	s1,s1,16
    80003f36:	04c92783          	lw	a5,76(s2)
    80003f3a:	fcf4ede3          	bltu	s1,a5,80003f14 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003f3e:	4639                	li	a2,14
    80003f40:	85d2                	mv	a1,s4
    80003f42:	fc240513          	addi	a0,s0,-62
    80003f46:	ffffd097          	auipc	ra,0xffffd
    80003f4a:	f22080e7          	jalr	-222(ra) # 80000e68 <strncpy>
  de.inum = inum;
    80003f4e:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003f52:	4741                	li	a4,16
    80003f54:	86a6                	mv	a3,s1
    80003f56:	fc040613          	addi	a2,s0,-64
    80003f5a:	4581                	li	a1,0
    80003f5c:	854a                	mv	a0,s2
    80003f5e:	00000097          	auipc	ra,0x0
    80003f62:	c3c080e7          	jalr	-964(ra) # 80003b9a <writei>
    80003f66:	1541                	addi	a0,a0,-16
    80003f68:	00a03533          	snez	a0,a0
    80003f6c:	40a0053b          	negw	a0,a0
    80003f70:	2501                	sext.w	a0,a0
}
    80003f72:	70e2                	ld	ra,56(sp)
    80003f74:	7442                	ld	s0,48(sp)
    80003f76:	74a2                	ld	s1,40(sp)
    80003f78:	7902                	ld	s2,32(sp)
    80003f7a:	69e2                	ld	s3,24(sp)
    80003f7c:	6a42                	ld	s4,16(sp)
    80003f7e:	6121                	addi	sp,sp,64
    80003f80:	8082                	ret
    iput(ip);
    80003f82:	00000097          	auipc	ra,0x0
    80003f86:	a26080e7          	jalr	-1498(ra) # 800039a8 <iput>
    return -1;
    80003f8a:	557d                	li	a0,-1
    80003f8c:	b7dd                	j	80003f72 <dirlink+0x88>
      panic("dirlink read");
    80003f8e:	00004517          	auipc	a0,0x4
    80003f92:	6ca50513          	addi	a0,a0,1738 # 80008658 <syscalls+0x1f0>
    80003f96:	ffffc097          	auipc	ra,0xffffc
    80003f9a:	5d6080e7          	jalr	1494(ra) # 8000056c <panic>

0000000080003f9e <namei>:

struct inode*
namei(char *path)
{
    80003f9e:	1101                	addi	sp,sp,-32
    80003fa0:	ec06                	sd	ra,24(sp)
    80003fa2:	e822                	sd	s0,16(sp)
    80003fa4:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003fa6:	fe040613          	addi	a2,s0,-32
    80003faa:	4581                	li	a1,0
    80003fac:	00000097          	auipc	ra,0x0
    80003fb0:	dd6080e7          	jalr	-554(ra) # 80003d82 <namex>
}
    80003fb4:	60e2                	ld	ra,24(sp)
    80003fb6:	6442                	ld	s0,16(sp)
    80003fb8:	6105                	addi	sp,sp,32
    80003fba:	8082                	ret

0000000080003fbc <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003fbc:	1141                	addi	sp,sp,-16
    80003fbe:	e406                	sd	ra,8(sp)
    80003fc0:	e022                	sd	s0,0(sp)
    80003fc2:	0800                	addi	s0,sp,16
  return namex(path, 1, name);
    80003fc4:	862e                	mv	a2,a1
    80003fc6:	4585                	li	a1,1
    80003fc8:	00000097          	auipc	ra,0x0
    80003fcc:	dba080e7          	jalr	-582(ra) # 80003d82 <namex>
}
    80003fd0:	60a2                	ld	ra,8(sp)
    80003fd2:	6402                	ld	s0,0(sp)
    80003fd4:	0141                	addi	sp,sp,16
    80003fd6:	8082                	ret

0000000080003fd8 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003fd8:	1101                	addi	sp,sp,-32
    80003fda:	ec06                	sd	ra,24(sp)
    80003fdc:	e822                	sd	s0,16(sp)
    80003fde:	e426                	sd	s1,8(sp)
    80003fe0:	e04a                	sd	s2,0(sp)
    80003fe2:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003fe4:	0001d917          	auipc	s2,0x1d
    80003fe8:	b7c90913          	addi	s2,s2,-1156 # 80020b60 <log>
    80003fec:	01892583          	lw	a1,24(s2)
    80003ff0:	02892503          	lw	a0,40(s2)
    80003ff4:	fffff097          	auipc	ra,0xfffff
    80003ff8:	f9a080e7          	jalr	-102(ra) # 80002f8e <bread>
    80003ffc:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003ffe:	02c92683          	lw	a3,44(s2)
    80004002:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80004004:	02d05763          	blez	a3,80004032 <write_head+0x5a>
    80004008:	0001d797          	auipc	a5,0x1d
    8000400c:	b8878793          	addi	a5,a5,-1144 # 80020b90 <log+0x30>
    80004010:	05c50713          	addi	a4,a0,92
    80004014:	36fd                	addiw	a3,a3,-1
    80004016:	1682                	slli	a3,a3,0x20
    80004018:	9281                	srli	a3,a3,0x20
    8000401a:	068a                	slli	a3,a3,0x2
    8000401c:	0001d617          	auipc	a2,0x1d
    80004020:	b7860613          	addi	a2,a2,-1160 # 80020b94 <log+0x34>
    80004024:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80004026:	4390                	lw	a2,0(a5)
    80004028:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000402a:	0791                	addi	a5,a5,4
    8000402c:	0711                	addi	a4,a4,4
    8000402e:	fed79ce3          	bne	a5,a3,80004026 <write_head+0x4e>
  }
  bwrite(buf);
    80004032:	8526                	mv	a0,s1
    80004034:	fffff097          	auipc	ra,0xfffff
    80004038:	05e080e7          	jalr	94(ra) # 80003092 <bwrite>
  brelse(buf);
    8000403c:	8526                	mv	a0,s1
    8000403e:	fffff097          	auipc	ra,0xfffff
    80004042:	092080e7          	jalr	146(ra) # 800030d0 <brelse>
}
    80004046:	60e2                	ld	ra,24(sp)
    80004048:	6442                	ld	s0,16(sp)
    8000404a:	64a2                	ld	s1,8(sp)
    8000404c:	6902                	ld	s2,0(sp)
    8000404e:	6105                	addi	sp,sp,32
    80004050:	8082                	ret

0000000080004052 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80004052:	0001d797          	auipc	a5,0x1d
    80004056:	b0e78793          	addi	a5,a5,-1266 # 80020b60 <log>
    8000405a:	57dc                	lw	a5,44(a5)
    8000405c:	0af05d63          	blez	a5,80004116 <install_trans+0xc4>
{
    80004060:	7139                	addi	sp,sp,-64
    80004062:	fc06                	sd	ra,56(sp)
    80004064:	f822                	sd	s0,48(sp)
    80004066:	f426                	sd	s1,40(sp)
    80004068:	f04a                	sd	s2,32(sp)
    8000406a:	ec4e                	sd	s3,24(sp)
    8000406c:	e852                	sd	s4,16(sp)
    8000406e:	e456                	sd	s5,8(sp)
    80004070:	e05a                	sd	s6,0(sp)
    80004072:	0080                	addi	s0,sp,64
    80004074:	8b2a                	mv	s6,a0
    80004076:	0001da17          	auipc	s4,0x1d
    8000407a:	b1aa0a13          	addi	s4,s4,-1254 # 80020b90 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000407e:	4981                	li	s3,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004080:	0001d917          	auipc	s2,0x1d
    80004084:	ae090913          	addi	s2,s2,-1312 # 80020b60 <log>
    80004088:	a035                	j	800040b4 <install_trans+0x62>
      bunpin(dbuf);
    8000408a:	8526                	mv	a0,s1
    8000408c:	fffff097          	auipc	ra,0xfffff
    80004090:	11e080e7          	jalr	286(ra) # 800031aa <bunpin>
    brelse(lbuf);
    80004094:	8556                	mv	a0,s5
    80004096:	fffff097          	auipc	ra,0xfffff
    8000409a:	03a080e7          	jalr	58(ra) # 800030d0 <brelse>
    brelse(dbuf);
    8000409e:	8526                	mv	a0,s1
    800040a0:	fffff097          	auipc	ra,0xfffff
    800040a4:	030080e7          	jalr	48(ra) # 800030d0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800040a8:	2985                	addiw	s3,s3,1
    800040aa:	0a11                	addi	s4,s4,4
    800040ac:	02c92783          	lw	a5,44(s2)
    800040b0:	04f9d963          	bge	s3,a5,80004102 <install_trans+0xb0>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800040b4:	01892583          	lw	a1,24(s2)
    800040b8:	013585bb          	addw	a1,a1,s3
    800040bc:	2585                	addiw	a1,a1,1
    800040be:	02892503          	lw	a0,40(s2)
    800040c2:	fffff097          	auipc	ra,0xfffff
    800040c6:	ecc080e7          	jalr	-308(ra) # 80002f8e <bread>
    800040ca:	8aaa                	mv	s5,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800040cc:	000a2583          	lw	a1,0(s4)
    800040d0:	02892503          	lw	a0,40(s2)
    800040d4:	fffff097          	auipc	ra,0xfffff
    800040d8:	eba080e7          	jalr	-326(ra) # 80002f8e <bread>
    800040dc:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800040de:	40000613          	li	a2,1024
    800040e2:	058a8593          	addi	a1,s5,88
    800040e6:	05850513          	addi	a0,a0,88
    800040ea:	ffffd097          	auipc	ra,0xffffd
    800040ee:	cb6080e7          	jalr	-842(ra) # 80000da0 <memmove>
    bwrite(dbuf);  // write dst to disk
    800040f2:	8526                	mv	a0,s1
    800040f4:	fffff097          	auipc	ra,0xfffff
    800040f8:	f9e080e7          	jalr	-98(ra) # 80003092 <bwrite>
    if(recovering == 0)
    800040fc:	f80b1ce3          	bnez	s6,80004094 <install_trans+0x42>
    80004100:	b769                	j	8000408a <install_trans+0x38>
}
    80004102:	70e2                	ld	ra,56(sp)
    80004104:	7442                	ld	s0,48(sp)
    80004106:	74a2                	ld	s1,40(sp)
    80004108:	7902                	ld	s2,32(sp)
    8000410a:	69e2                	ld	s3,24(sp)
    8000410c:	6a42                	ld	s4,16(sp)
    8000410e:	6aa2                	ld	s5,8(sp)
    80004110:	6b02                	ld	s6,0(sp)
    80004112:	6121                	addi	sp,sp,64
    80004114:	8082                	ret
    80004116:	8082                	ret

0000000080004118 <initlog>:
{
    80004118:	7179                	addi	sp,sp,-48
    8000411a:	f406                	sd	ra,40(sp)
    8000411c:	f022                	sd	s0,32(sp)
    8000411e:	ec26                	sd	s1,24(sp)
    80004120:	e84a                	sd	s2,16(sp)
    80004122:	e44e                	sd	s3,8(sp)
    80004124:	1800                	addi	s0,sp,48
    80004126:	892a                	mv	s2,a0
    80004128:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000412a:	0001d497          	auipc	s1,0x1d
    8000412e:	a3648493          	addi	s1,s1,-1482 # 80020b60 <log>
    80004132:	00004597          	auipc	a1,0x4
    80004136:	53658593          	addi	a1,a1,1334 # 80008668 <syscalls+0x200>
    8000413a:	8526                	mv	a0,s1
    8000413c:	ffffd097          	auipc	ra,0xffffd
    80004140:	a6c080e7          	jalr	-1428(ra) # 80000ba8 <initlock>
  log.start = sb->logstart;
    80004144:	0149a583          	lw	a1,20(s3)
    80004148:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000414a:	0109a783          	lw	a5,16(s3)
    8000414e:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80004150:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004154:	854a                	mv	a0,s2
    80004156:	fffff097          	auipc	ra,0xfffff
    8000415a:	e38080e7          	jalr	-456(ra) # 80002f8e <bread>
  log.lh.n = lh->n;
    8000415e:	4d3c                	lw	a5,88(a0)
    80004160:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80004162:	02f05563          	blez	a5,8000418c <initlog+0x74>
    80004166:	05c50713          	addi	a4,a0,92
    8000416a:	0001d697          	auipc	a3,0x1d
    8000416e:	a2668693          	addi	a3,a3,-1498 # 80020b90 <log+0x30>
    80004172:	37fd                	addiw	a5,a5,-1
    80004174:	1782                	slli	a5,a5,0x20
    80004176:	9381                	srli	a5,a5,0x20
    80004178:	078a                	slli	a5,a5,0x2
    8000417a:	06050613          	addi	a2,a0,96
    8000417e:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80004180:	4310                	lw	a2,0(a4)
    80004182:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80004184:	0711                	addi	a4,a4,4
    80004186:	0691                	addi	a3,a3,4
    80004188:	fef71ce3          	bne	a4,a5,80004180 <initlog+0x68>
  brelse(buf);
    8000418c:	fffff097          	auipc	ra,0xfffff
    80004190:	f44080e7          	jalr	-188(ra) # 800030d0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004194:	4505                	li	a0,1
    80004196:	00000097          	auipc	ra,0x0
    8000419a:	ebc080e7          	jalr	-324(ra) # 80004052 <install_trans>
  log.lh.n = 0;
    8000419e:	0001d797          	auipc	a5,0x1d
    800041a2:	9e07a723          	sw	zero,-1554(a5) # 80020b8c <log+0x2c>
  write_head(); // clear the log
    800041a6:	00000097          	auipc	ra,0x0
    800041aa:	e32080e7          	jalr	-462(ra) # 80003fd8 <write_head>
}
    800041ae:	70a2                	ld	ra,40(sp)
    800041b0:	7402                	ld	s0,32(sp)
    800041b2:	64e2                	ld	s1,24(sp)
    800041b4:	6942                	ld	s2,16(sp)
    800041b6:	69a2                	ld	s3,8(sp)
    800041b8:	6145                	addi	sp,sp,48
    800041ba:	8082                	ret

00000000800041bc <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800041bc:	1101                	addi	sp,sp,-32
    800041be:	ec06                	sd	ra,24(sp)
    800041c0:	e822                	sd	s0,16(sp)
    800041c2:	e426                	sd	s1,8(sp)
    800041c4:	e04a                	sd	s2,0(sp)
    800041c6:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800041c8:	0001d517          	auipc	a0,0x1d
    800041cc:	99850513          	addi	a0,a0,-1640 # 80020b60 <log>
    800041d0:	ffffd097          	auipc	ra,0xffffd
    800041d4:	a68080e7          	jalr	-1432(ra) # 80000c38 <acquire>
  while(1){
    if(log.committing){
    800041d8:	0001d497          	auipc	s1,0x1d
    800041dc:	98848493          	addi	s1,s1,-1656 # 80020b60 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800041e0:	4979                	li	s2,30
    800041e2:	a039                	j	800041f0 <begin_op+0x34>
      sleep(&log, &log.lock);
    800041e4:	85a6                	mv	a1,s1
    800041e6:	8526                	mv	a0,s1
    800041e8:	ffffe097          	auipc	ra,0xffffe
    800041ec:	efa080e7          	jalr	-262(ra) # 800020e2 <sleep>
    if(log.committing){
    800041f0:	50dc                	lw	a5,36(s1)
    800041f2:	fbed                	bnez	a5,800041e4 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800041f4:	509c                	lw	a5,32(s1)
    800041f6:	0017871b          	addiw	a4,a5,1
    800041fa:	0007069b          	sext.w	a3,a4
    800041fe:	0027179b          	slliw	a5,a4,0x2
    80004202:	9fb9                	addw	a5,a5,a4
    80004204:	0017979b          	slliw	a5,a5,0x1
    80004208:	54d8                	lw	a4,44(s1)
    8000420a:	9fb9                	addw	a5,a5,a4
    8000420c:	00f95963          	bge	s2,a5,8000421e <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004210:	85a6                	mv	a1,s1
    80004212:	8526                	mv	a0,s1
    80004214:	ffffe097          	auipc	ra,0xffffe
    80004218:	ece080e7          	jalr	-306(ra) # 800020e2 <sleep>
    8000421c:	bfd1                	j	800041f0 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000421e:	0001d517          	auipc	a0,0x1d
    80004222:	94250513          	addi	a0,a0,-1726 # 80020b60 <log>
    80004226:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80004228:	ffffd097          	auipc	ra,0xffffd
    8000422c:	ac4080e7          	jalr	-1340(ra) # 80000cec <release>
      break;
    }
  }
}
    80004230:	60e2                	ld	ra,24(sp)
    80004232:	6442                	ld	s0,16(sp)
    80004234:	64a2                	ld	s1,8(sp)
    80004236:	6902                	ld	s2,0(sp)
    80004238:	6105                	addi	sp,sp,32
    8000423a:	8082                	ret

000000008000423c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000423c:	7139                	addi	sp,sp,-64
    8000423e:	fc06                	sd	ra,56(sp)
    80004240:	f822                	sd	s0,48(sp)
    80004242:	f426                	sd	s1,40(sp)
    80004244:	f04a                	sd	s2,32(sp)
    80004246:	ec4e                	sd	s3,24(sp)
    80004248:	e852                	sd	s4,16(sp)
    8000424a:	e456                	sd	s5,8(sp)
    8000424c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000424e:	0001d917          	auipc	s2,0x1d
    80004252:	91290913          	addi	s2,s2,-1774 # 80020b60 <log>
    80004256:	854a                	mv	a0,s2
    80004258:	ffffd097          	auipc	ra,0xffffd
    8000425c:	9e0080e7          	jalr	-1568(ra) # 80000c38 <acquire>
  log.outstanding -= 1;
    80004260:	02092783          	lw	a5,32(s2)
    80004264:	37fd                	addiw	a5,a5,-1
    80004266:	0007849b          	sext.w	s1,a5
    8000426a:	02f92023          	sw	a5,32(s2)
  if(log.committing)
    8000426e:	02492783          	lw	a5,36(s2)
    80004272:	eba1                	bnez	a5,800042c2 <end_op+0x86>
    panic("log.committing");
  if(log.outstanding == 0){
    80004274:	ecb9                	bnez	s1,800042d2 <end_op+0x96>
    do_commit = 1;
    log.committing = 1;
    80004276:	0001d917          	auipc	s2,0x1d
    8000427a:	8ea90913          	addi	s2,s2,-1814 # 80020b60 <log>
    8000427e:	4785                	li	a5,1
    80004280:	02f92223          	sw	a5,36(s2)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004284:	854a                	mv	a0,s2
    80004286:	ffffd097          	auipc	ra,0xffffd
    8000428a:	a66080e7          	jalr	-1434(ra) # 80000cec <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000428e:	02c92783          	lw	a5,44(s2)
    80004292:	06f04763          	bgtz	a5,80004300 <end_op+0xc4>
    acquire(&log.lock);
    80004296:	0001d497          	auipc	s1,0x1d
    8000429a:	8ca48493          	addi	s1,s1,-1846 # 80020b60 <log>
    8000429e:	8526                	mv	a0,s1
    800042a0:	ffffd097          	auipc	ra,0xffffd
    800042a4:	998080e7          	jalr	-1640(ra) # 80000c38 <acquire>
    log.committing = 0;
    800042a8:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800042ac:	8526                	mv	a0,s1
    800042ae:	ffffe097          	auipc	ra,0xffffe
    800042b2:	e98080e7          	jalr	-360(ra) # 80002146 <wakeup>
    release(&log.lock);
    800042b6:	8526                	mv	a0,s1
    800042b8:	ffffd097          	auipc	ra,0xffffd
    800042bc:	a34080e7          	jalr	-1484(ra) # 80000cec <release>
}
    800042c0:	a03d                	j	800042ee <end_op+0xb2>
    panic("log.committing");
    800042c2:	00004517          	auipc	a0,0x4
    800042c6:	3ae50513          	addi	a0,a0,942 # 80008670 <syscalls+0x208>
    800042ca:	ffffc097          	auipc	ra,0xffffc
    800042ce:	2a2080e7          	jalr	674(ra) # 8000056c <panic>
    wakeup(&log);
    800042d2:	0001d497          	auipc	s1,0x1d
    800042d6:	88e48493          	addi	s1,s1,-1906 # 80020b60 <log>
    800042da:	8526                	mv	a0,s1
    800042dc:	ffffe097          	auipc	ra,0xffffe
    800042e0:	e6a080e7          	jalr	-406(ra) # 80002146 <wakeup>
  release(&log.lock);
    800042e4:	8526                	mv	a0,s1
    800042e6:	ffffd097          	auipc	ra,0xffffd
    800042ea:	a06080e7          	jalr	-1530(ra) # 80000cec <release>
}
    800042ee:	70e2                	ld	ra,56(sp)
    800042f0:	7442                	ld	s0,48(sp)
    800042f2:	74a2                	ld	s1,40(sp)
    800042f4:	7902                	ld	s2,32(sp)
    800042f6:	69e2                	ld	s3,24(sp)
    800042f8:	6a42                	ld	s4,16(sp)
    800042fa:	6aa2                	ld	s5,8(sp)
    800042fc:	6121                	addi	sp,sp,64
    800042fe:	8082                	ret
    80004300:	0001da17          	auipc	s4,0x1d
    80004304:	890a0a13          	addi	s4,s4,-1904 # 80020b90 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004308:	0001d917          	auipc	s2,0x1d
    8000430c:	85890913          	addi	s2,s2,-1960 # 80020b60 <log>
    80004310:	01892583          	lw	a1,24(s2)
    80004314:	9da5                	addw	a1,a1,s1
    80004316:	2585                	addiw	a1,a1,1
    80004318:	02892503          	lw	a0,40(s2)
    8000431c:	fffff097          	auipc	ra,0xfffff
    80004320:	c72080e7          	jalr	-910(ra) # 80002f8e <bread>
    80004324:	89aa                	mv	s3,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004326:	000a2583          	lw	a1,0(s4)
    8000432a:	02892503          	lw	a0,40(s2)
    8000432e:	fffff097          	auipc	ra,0xfffff
    80004332:	c60080e7          	jalr	-928(ra) # 80002f8e <bread>
    80004336:	8aaa                	mv	s5,a0
    memmove(to->data, from->data, BSIZE);
    80004338:	40000613          	li	a2,1024
    8000433c:	05850593          	addi	a1,a0,88
    80004340:	05898513          	addi	a0,s3,88
    80004344:	ffffd097          	auipc	ra,0xffffd
    80004348:	a5c080e7          	jalr	-1444(ra) # 80000da0 <memmove>
    bwrite(to);  // write the log
    8000434c:	854e                	mv	a0,s3
    8000434e:	fffff097          	auipc	ra,0xfffff
    80004352:	d44080e7          	jalr	-700(ra) # 80003092 <bwrite>
    brelse(from);
    80004356:	8556                	mv	a0,s5
    80004358:	fffff097          	auipc	ra,0xfffff
    8000435c:	d78080e7          	jalr	-648(ra) # 800030d0 <brelse>
    brelse(to);
    80004360:	854e                	mv	a0,s3
    80004362:	fffff097          	auipc	ra,0xfffff
    80004366:	d6e080e7          	jalr	-658(ra) # 800030d0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000436a:	2485                	addiw	s1,s1,1
    8000436c:	0a11                	addi	s4,s4,4
    8000436e:	02c92783          	lw	a5,44(s2)
    80004372:	f8f4cfe3          	blt	s1,a5,80004310 <end_op+0xd4>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004376:	00000097          	auipc	ra,0x0
    8000437a:	c62080e7          	jalr	-926(ra) # 80003fd8 <write_head>
    install_trans(0); // Now install writes to home locations
    8000437e:	4501                	li	a0,0
    80004380:	00000097          	auipc	ra,0x0
    80004384:	cd2080e7          	jalr	-814(ra) # 80004052 <install_trans>
    log.lh.n = 0;
    80004388:	0001d797          	auipc	a5,0x1d
    8000438c:	8007a223          	sw	zero,-2044(a5) # 80020b8c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004390:	00000097          	auipc	ra,0x0
    80004394:	c48080e7          	jalr	-952(ra) # 80003fd8 <write_head>
    80004398:	bdfd                	j	80004296 <end_op+0x5a>

000000008000439a <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000439a:	1101                	addi	sp,sp,-32
    8000439c:	ec06                	sd	ra,24(sp)
    8000439e:	e822                	sd	s0,16(sp)
    800043a0:	e426                	sd	s1,8(sp)
    800043a2:	e04a                	sd	s2,0(sp)
    800043a4:	1000                	addi	s0,sp,32
    800043a6:	892a                	mv	s2,a0
  int i;

  acquire(&log.lock);
    800043a8:	0001c497          	auipc	s1,0x1c
    800043ac:	7b848493          	addi	s1,s1,1976 # 80020b60 <log>
    800043b0:	8526                	mv	a0,s1
    800043b2:	ffffd097          	auipc	ra,0xffffd
    800043b6:	886080e7          	jalr	-1914(ra) # 80000c38 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800043ba:	54d0                	lw	a2,44(s1)
    800043bc:	47f5                	li	a5,29
    800043be:	06c7ca63          	blt	a5,a2,80004432 <log_write+0x98>
    800043c2:	4cdc                	lw	a5,28(s1)
    800043c4:	37fd                	addiw	a5,a5,-1
    800043c6:	06f65663          	bge	a2,a5,80004432 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800043ca:	0001c797          	auipc	a5,0x1c
    800043ce:	79678793          	addi	a5,a5,1942 # 80020b60 <log>
    800043d2:	539c                	lw	a5,32(a5)
    800043d4:	06f05763          	blez	a5,80004442 <log_write+0xa8>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800043d8:	0ac05463          	blez	a2,80004480 <log_write+0xe6>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800043dc:	00c92583          	lw	a1,12(s2)
    800043e0:	0001c797          	auipc	a5,0x1c
    800043e4:	78078793          	addi	a5,a5,1920 # 80020b60 <log>
    800043e8:	5b9c                	lw	a5,48(a5)
    800043ea:	0ab78363          	beq	a5,a1,80004490 <log_write+0xf6>
    800043ee:	0001c717          	auipc	a4,0x1c
    800043f2:	7a670713          	addi	a4,a4,1958 # 80020b94 <log+0x34>
  for (i = 0; i < log.lh.n; i++) {
    800043f6:	4781                	li	a5,0
    800043f8:	2785                	addiw	a5,a5,1
    800043fa:	04f60c63          	beq	a2,a5,80004452 <log_write+0xb8>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800043fe:	4314                	lw	a3,0(a4)
    80004400:	0711                	addi	a4,a4,4
    80004402:	feb69be3          	bne	a3,a1,800043f8 <log_write+0x5e>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004406:	07a1                	addi	a5,a5,8
    80004408:	078a                	slli	a5,a5,0x2
    8000440a:	0001c717          	auipc	a4,0x1c
    8000440e:	75670713          	addi	a4,a4,1878 # 80020b60 <log>
    80004412:	97ba                	add	a5,a5,a4
    80004414:	cb8c                	sw	a1,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    log.lh.n++;
  }
  release(&log.lock);
    80004416:	0001c517          	auipc	a0,0x1c
    8000441a:	74a50513          	addi	a0,a0,1866 # 80020b60 <log>
    8000441e:	ffffd097          	auipc	ra,0xffffd
    80004422:	8ce080e7          	jalr	-1842(ra) # 80000cec <release>
}
    80004426:	60e2                	ld	ra,24(sp)
    80004428:	6442                	ld	s0,16(sp)
    8000442a:	64a2                	ld	s1,8(sp)
    8000442c:	6902                	ld	s2,0(sp)
    8000442e:	6105                	addi	sp,sp,32
    80004430:	8082                	ret
    panic("too big a transaction");
    80004432:	00004517          	auipc	a0,0x4
    80004436:	24e50513          	addi	a0,a0,590 # 80008680 <syscalls+0x218>
    8000443a:	ffffc097          	auipc	ra,0xffffc
    8000443e:	132080e7          	jalr	306(ra) # 8000056c <panic>
    panic("log_write outside of trans");
    80004442:	00004517          	auipc	a0,0x4
    80004446:	25650513          	addi	a0,a0,598 # 80008698 <syscalls+0x230>
    8000444a:	ffffc097          	auipc	ra,0xffffc
    8000444e:	122080e7          	jalr	290(ra) # 8000056c <panic>
  log.lh.block[i] = b->blockno;
    80004452:	0621                	addi	a2,a2,8
    80004454:	060a                	slli	a2,a2,0x2
    80004456:	0001c797          	auipc	a5,0x1c
    8000445a:	70a78793          	addi	a5,a5,1802 # 80020b60 <log>
    8000445e:	963e                	add	a2,a2,a5
    80004460:	00c92783          	lw	a5,12(s2)
    80004464:	ca1c                	sw	a5,16(a2)
    bpin(b);
    80004466:	854a                	mv	a0,s2
    80004468:	fffff097          	auipc	ra,0xfffff
    8000446c:	d06080e7          	jalr	-762(ra) # 8000316e <bpin>
    log.lh.n++;
    80004470:	0001c717          	auipc	a4,0x1c
    80004474:	6f070713          	addi	a4,a4,1776 # 80020b60 <log>
    80004478:	575c                	lw	a5,44(a4)
    8000447a:	2785                	addiw	a5,a5,1
    8000447c:	d75c                	sw	a5,44(a4)
    8000447e:	bf61                	j	80004416 <log_write+0x7c>
  log.lh.block[i] = b->blockno;
    80004480:	00c92783          	lw	a5,12(s2)
    80004484:	0001c717          	auipc	a4,0x1c
    80004488:	70f72623          	sw	a5,1804(a4) # 80020b90 <log+0x30>
  if (i == log.lh.n) {  // Add new block to log?
    8000448c:	f649                	bnez	a2,80004416 <log_write+0x7c>
    8000448e:	bfe1                	j	80004466 <log_write+0xcc>
  for (i = 0; i < log.lh.n; i++) {
    80004490:	4781                	li	a5,0
    80004492:	bf95                	j	80004406 <log_write+0x6c>

0000000080004494 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004494:	1101                	addi	sp,sp,-32
    80004496:	ec06                	sd	ra,24(sp)
    80004498:	e822                	sd	s0,16(sp)
    8000449a:	e426                	sd	s1,8(sp)
    8000449c:	e04a                	sd	s2,0(sp)
    8000449e:	1000                	addi	s0,sp,32
    800044a0:	84aa                	mv	s1,a0
    800044a2:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800044a4:	00004597          	auipc	a1,0x4
    800044a8:	21458593          	addi	a1,a1,532 # 800086b8 <syscalls+0x250>
    800044ac:	0521                	addi	a0,a0,8
    800044ae:	ffffc097          	auipc	ra,0xffffc
    800044b2:	6fa080e7          	jalr	1786(ra) # 80000ba8 <initlock>
  lk->name = name;
    800044b6:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800044ba:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800044be:	0204a423          	sw	zero,40(s1)
}
    800044c2:	60e2                	ld	ra,24(sp)
    800044c4:	6442                	ld	s0,16(sp)
    800044c6:	64a2                	ld	s1,8(sp)
    800044c8:	6902                	ld	s2,0(sp)
    800044ca:	6105                	addi	sp,sp,32
    800044cc:	8082                	ret

00000000800044ce <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800044ce:	1101                	addi	sp,sp,-32
    800044d0:	ec06                	sd	ra,24(sp)
    800044d2:	e822                	sd	s0,16(sp)
    800044d4:	e426                	sd	s1,8(sp)
    800044d6:	e04a                	sd	s2,0(sp)
    800044d8:	1000                	addi	s0,sp,32
    800044da:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800044dc:	00850913          	addi	s2,a0,8
    800044e0:	854a                	mv	a0,s2
    800044e2:	ffffc097          	auipc	ra,0xffffc
    800044e6:	756080e7          	jalr	1878(ra) # 80000c38 <acquire>
  while (lk->locked) {
    800044ea:	409c                	lw	a5,0(s1)
    800044ec:	cb89                	beqz	a5,800044fe <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800044ee:	85ca                	mv	a1,s2
    800044f0:	8526                	mv	a0,s1
    800044f2:	ffffe097          	auipc	ra,0xffffe
    800044f6:	bf0080e7          	jalr	-1040(ra) # 800020e2 <sleep>
  while (lk->locked) {
    800044fa:	409c                	lw	a5,0(s1)
    800044fc:	fbed                	bnez	a5,800044ee <acquiresleep+0x20>
  }
  lk->locked = 1;
    800044fe:	4785                	li	a5,1
    80004500:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004502:	ffffd097          	auipc	ra,0xffffd
    80004506:	538080e7          	jalr	1336(ra) # 80001a3a <myproc>
    8000450a:	591c                	lw	a5,48(a0)
    8000450c:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000450e:	854a                	mv	a0,s2
    80004510:	ffffc097          	auipc	ra,0xffffc
    80004514:	7dc080e7          	jalr	2012(ra) # 80000cec <release>
}
    80004518:	60e2                	ld	ra,24(sp)
    8000451a:	6442                	ld	s0,16(sp)
    8000451c:	64a2                	ld	s1,8(sp)
    8000451e:	6902                	ld	s2,0(sp)
    80004520:	6105                	addi	sp,sp,32
    80004522:	8082                	ret

0000000080004524 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004524:	1101                	addi	sp,sp,-32
    80004526:	ec06                	sd	ra,24(sp)
    80004528:	e822                	sd	s0,16(sp)
    8000452a:	e426                	sd	s1,8(sp)
    8000452c:	e04a                	sd	s2,0(sp)
    8000452e:	1000                	addi	s0,sp,32
    80004530:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004532:	00850913          	addi	s2,a0,8
    80004536:	854a                	mv	a0,s2
    80004538:	ffffc097          	auipc	ra,0xffffc
    8000453c:	700080e7          	jalr	1792(ra) # 80000c38 <acquire>
  lk->locked = 0;
    80004540:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004544:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004548:	8526                	mv	a0,s1
    8000454a:	ffffe097          	auipc	ra,0xffffe
    8000454e:	bfc080e7          	jalr	-1028(ra) # 80002146 <wakeup>
  release(&lk->lk);
    80004552:	854a                	mv	a0,s2
    80004554:	ffffc097          	auipc	ra,0xffffc
    80004558:	798080e7          	jalr	1944(ra) # 80000cec <release>
}
    8000455c:	60e2                	ld	ra,24(sp)
    8000455e:	6442                	ld	s0,16(sp)
    80004560:	64a2                	ld	s1,8(sp)
    80004562:	6902                	ld	s2,0(sp)
    80004564:	6105                	addi	sp,sp,32
    80004566:	8082                	ret

0000000080004568 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004568:	7179                	addi	sp,sp,-48
    8000456a:	f406                	sd	ra,40(sp)
    8000456c:	f022                	sd	s0,32(sp)
    8000456e:	ec26                	sd	s1,24(sp)
    80004570:	e84a                	sd	s2,16(sp)
    80004572:	e44e                	sd	s3,8(sp)
    80004574:	1800                	addi	s0,sp,48
    80004576:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004578:	00850913          	addi	s2,a0,8
    8000457c:	854a                	mv	a0,s2
    8000457e:	ffffc097          	auipc	ra,0xffffc
    80004582:	6ba080e7          	jalr	1722(ra) # 80000c38 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004586:	409c                	lw	a5,0(s1)
    80004588:	ef99                	bnez	a5,800045a6 <holdingsleep+0x3e>
    8000458a:	4481                	li	s1,0
  release(&lk->lk);
    8000458c:	854a                	mv	a0,s2
    8000458e:	ffffc097          	auipc	ra,0xffffc
    80004592:	75e080e7          	jalr	1886(ra) # 80000cec <release>
  return r;
}
    80004596:	8526                	mv	a0,s1
    80004598:	70a2                	ld	ra,40(sp)
    8000459a:	7402                	ld	s0,32(sp)
    8000459c:	64e2                	ld	s1,24(sp)
    8000459e:	6942                	ld	s2,16(sp)
    800045a0:	69a2                	ld	s3,8(sp)
    800045a2:	6145                	addi	sp,sp,48
    800045a4:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800045a6:	0284a983          	lw	s3,40(s1)
    800045aa:	ffffd097          	auipc	ra,0xffffd
    800045ae:	490080e7          	jalr	1168(ra) # 80001a3a <myproc>
    800045b2:	5904                	lw	s1,48(a0)
    800045b4:	413484b3          	sub	s1,s1,s3
    800045b8:	0014b493          	seqz	s1,s1
    800045bc:	bfc1                	j	8000458c <holdingsleep+0x24>

00000000800045be <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800045be:	1141                	addi	sp,sp,-16
    800045c0:	e406                	sd	ra,8(sp)
    800045c2:	e022                	sd	s0,0(sp)
    800045c4:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800045c6:	00004597          	auipc	a1,0x4
    800045ca:	10258593          	addi	a1,a1,258 # 800086c8 <syscalls+0x260>
    800045ce:	0001c517          	auipc	a0,0x1c
    800045d2:	6da50513          	addi	a0,a0,1754 # 80020ca8 <ftable>
    800045d6:	ffffc097          	auipc	ra,0xffffc
    800045da:	5d2080e7          	jalr	1490(ra) # 80000ba8 <initlock>
}
    800045de:	60a2                	ld	ra,8(sp)
    800045e0:	6402                	ld	s0,0(sp)
    800045e2:	0141                	addi	sp,sp,16
    800045e4:	8082                	ret

00000000800045e6 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800045e6:	1101                	addi	sp,sp,-32
    800045e8:	ec06                	sd	ra,24(sp)
    800045ea:	e822                	sd	s0,16(sp)
    800045ec:	e426                	sd	s1,8(sp)
    800045ee:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800045f0:	0001c517          	auipc	a0,0x1c
    800045f4:	6b850513          	addi	a0,a0,1720 # 80020ca8 <ftable>
    800045f8:	ffffc097          	auipc	ra,0xffffc
    800045fc:	640080e7          	jalr	1600(ra) # 80000c38 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
    80004600:	0001c797          	auipc	a5,0x1c
    80004604:	6a878793          	addi	a5,a5,1704 # 80020ca8 <ftable>
    80004608:	4fdc                	lw	a5,28(a5)
    8000460a:	cb8d                	beqz	a5,8000463c <filealloc+0x56>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000460c:	0001c497          	auipc	s1,0x1c
    80004610:	6dc48493          	addi	s1,s1,1756 # 80020ce8 <ftable+0x40>
    80004614:	0001d717          	auipc	a4,0x1d
    80004618:	64c70713          	addi	a4,a4,1612 # 80021c60 <disk>
    if(f->ref == 0){
    8000461c:	40dc                	lw	a5,4(s1)
    8000461e:	c39d                	beqz	a5,80004644 <filealloc+0x5e>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004620:	02848493          	addi	s1,s1,40
    80004624:	fee49ce3          	bne	s1,a4,8000461c <filealloc+0x36>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004628:	0001c517          	auipc	a0,0x1c
    8000462c:	68050513          	addi	a0,a0,1664 # 80020ca8 <ftable>
    80004630:	ffffc097          	auipc	ra,0xffffc
    80004634:	6bc080e7          	jalr	1724(ra) # 80000cec <release>
  return 0;
    80004638:	4481                	li	s1,0
    8000463a:	a839                	j	80004658 <filealloc+0x72>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000463c:	0001c497          	auipc	s1,0x1c
    80004640:	68448493          	addi	s1,s1,1668 # 80020cc0 <ftable+0x18>
      f->ref = 1;
    80004644:	4785                	li	a5,1
    80004646:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004648:	0001c517          	auipc	a0,0x1c
    8000464c:	66050513          	addi	a0,a0,1632 # 80020ca8 <ftable>
    80004650:	ffffc097          	auipc	ra,0xffffc
    80004654:	69c080e7          	jalr	1692(ra) # 80000cec <release>
}
    80004658:	8526                	mv	a0,s1
    8000465a:	60e2                	ld	ra,24(sp)
    8000465c:	6442                	ld	s0,16(sp)
    8000465e:	64a2                	ld	s1,8(sp)
    80004660:	6105                	addi	sp,sp,32
    80004662:	8082                	ret

0000000080004664 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004664:	1101                	addi	sp,sp,-32
    80004666:	ec06                	sd	ra,24(sp)
    80004668:	e822                	sd	s0,16(sp)
    8000466a:	e426                	sd	s1,8(sp)
    8000466c:	1000                	addi	s0,sp,32
    8000466e:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004670:	0001c517          	auipc	a0,0x1c
    80004674:	63850513          	addi	a0,a0,1592 # 80020ca8 <ftable>
    80004678:	ffffc097          	auipc	ra,0xffffc
    8000467c:	5c0080e7          	jalr	1472(ra) # 80000c38 <acquire>
  if(f->ref < 1)
    80004680:	40dc                	lw	a5,4(s1)
    80004682:	02f05263          	blez	a5,800046a6 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004686:	2785                	addiw	a5,a5,1
    80004688:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000468a:	0001c517          	auipc	a0,0x1c
    8000468e:	61e50513          	addi	a0,a0,1566 # 80020ca8 <ftable>
    80004692:	ffffc097          	auipc	ra,0xffffc
    80004696:	65a080e7          	jalr	1626(ra) # 80000cec <release>
  return f;
}
    8000469a:	8526                	mv	a0,s1
    8000469c:	60e2                	ld	ra,24(sp)
    8000469e:	6442                	ld	s0,16(sp)
    800046a0:	64a2                	ld	s1,8(sp)
    800046a2:	6105                	addi	sp,sp,32
    800046a4:	8082                	ret
    panic("filedup");
    800046a6:	00004517          	auipc	a0,0x4
    800046aa:	02a50513          	addi	a0,a0,42 # 800086d0 <syscalls+0x268>
    800046ae:	ffffc097          	auipc	ra,0xffffc
    800046b2:	ebe080e7          	jalr	-322(ra) # 8000056c <panic>

00000000800046b6 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800046b6:	7139                	addi	sp,sp,-64
    800046b8:	fc06                	sd	ra,56(sp)
    800046ba:	f822                	sd	s0,48(sp)
    800046bc:	f426                	sd	s1,40(sp)
    800046be:	f04a                	sd	s2,32(sp)
    800046c0:	ec4e                	sd	s3,24(sp)
    800046c2:	e852                	sd	s4,16(sp)
    800046c4:	e456                	sd	s5,8(sp)
    800046c6:	0080                	addi	s0,sp,64
    800046c8:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800046ca:	0001c517          	auipc	a0,0x1c
    800046ce:	5de50513          	addi	a0,a0,1502 # 80020ca8 <ftable>
    800046d2:	ffffc097          	auipc	ra,0xffffc
    800046d6:	566080e7          	jalr	1382(ra) # 80000c38 <acquire>
  if(f->ref < 1)
    800046da:	40dc                	lw	a5,4(s1)
    800046dc:	06f05163          	blez	a5,8000473e <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    800046e0:	37fd                	addiw	a5,a5,-1
    800046e2:	0007871b          	sext.w	a4,a5
    800046e6:	c0dc                	sw	a5,4(s1)
    800046e8:	06e04363          	bgtz	a4,8000474e <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800046ec:	0004a903          	lw	s2,0(s1)
    800046f0:	0094ca83          	lbu	s5,9(s1)
    800046f4:	0104ba03          	ld	s4,16(s1)
    800046f8:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800046fc:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004700:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004704:	0001c517          	auipc	a0,0x1c
    80004708:	5a450513          	addi	a0,a0,1444 # 80020ca8 <ftable>
    8000470c:	ffffc097          	auipc	ra,0xffffc
    80004710:	5e0080e7          	jalr	1504(ra) # 80000cec <release>

  if(ff.type == FD_PIPE){
    80004714:	4785                	li	a5,1
    80004716:	04f90d63          	beq	s2,a5,80004770 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    8000471a:	3979                	addiw	s2,s2,-2
    8000471c:	4785                	li	a5,1
    8000471e:	0527e063          	bltu	a5,s2,8000475e <fileclose+0xa8>
    begin_op();
    80004722:	00000097          	auipc	ra,0x0
    80004726:	a9a080e7          	jalr	-1382(ra) # 800041bc <begin_op>
    iput(ff.ip);
    8000472a:	854e                	mv	a0,s3
    8000472c:	fffff097          	auipc	ra,0xfffff
    80004730:	27c080e7          	jalr	636(ra) # 800039a8 <iput>
    end_op();
    80004734:	00000097          	auipc	ra,0x0
    80004738:	b08080e7          	jalr	-1272(ra) # 8000423c <end_op>
    8000473c:	a00d                	j	8000475e <fileclose+0xa8>
    panic("fileclose");
    8000473e:	00004517          	auipc	a0,0x4
    80004742:	f9a50513          	addi	a0,a0,-102 # 800086d8 <syscalls+0x270>
    80004746:	ffffc097          	auipc	ra,0xffffc
    8000474a:	e26080e7          	jalr	-474(ra) # 8000056c <panic>
    release(&ftable.lock);
    8000474e:	0001c517          	auipc	a0,0x1c
    80004752:	55a50513          	addi	a0,a0,1370 # 80020ca8 <ftable>
    80004756:	ffffc097          	auipc	ra,0xffffc
    8000475a:	596080e7          	jalr	1430(ra) # 80000cec <release>
  }
}
    8000475e:	70e2                	ld	ra,56(sp)
    80004760:	7442                	ld	s0,48(sp)
    80004762:	74a2                	ld	s1,40(sp)
    80004764:	7902                	ld	s2,32(sp)
    80004766:	69e2                	ld	s3,24(sp)
    80004768:	6a42                	ld	s4,16(sp)
    8000476a:	6aa2                	ld	s5,8(sp)
    8000476c:	6121                	addi	sp,sp,64
    8000476e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004770:	85d6                	mv	a1,s5
    80004772:	8552                	mv	a0,s4
    80004774:	00000097          	auipc	ra,0x0
    80004778:	340080e7          	jalr	832(ra) # 80004ab4 <pipeclose>
    8000477c:	b7cd                	j	8000475e <fileclose+0xa8>

000000008000477e <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    8000477e:	715d                	addi	sp,sp,-80
    80004780:	e486                	sd	ra,72(sp)
    80004782:	e0a2                	sd	s0,64(sp)
    80004784:	fc26                	sd	s1,56(sp)
    80004786:	f84a                	sd	s2,48(sp)
    80004788:	f44e                	sd	s3,40(sp)
    8000478a:	0880                	addi	s0,sp,80
    8000478c:	84aa                	mv	s1,a0
    8000478e:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004790:	ffffd097          	auipc	ra,0xffffd
    80004794:	2aa080e7          	jalr	682(ra) # 80001a3a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004798:	409c                	lw	a5,0(s1)
    8000479a:	37f9                	addiw	a5,a5,-2
    8000479c:	4705                	li	a4,1
    8000479e:	04f76763          	bltu	a4,a5,800047ec <filestat+0x6e>
    800047a2:	892a                	mv	s2,a0
    ilock(f->ip);
    800047a4:	6c88                	ld	a0,24(s1)
    800047a6:	fffff097          	auipc	ra,0xfffff
    800047aa:	046080e7          	jalr	70(ra) # 800037ec <ilock>
    stati(f->ip, &st);
    800047ae:	fb840593          	addi	a1,s0,-72
    800047b2:	6c88                	ld	a0,24(s1)
    800047b4:	fffff097          	auipc	ra,0xfffff
    800047b8:	2c4080e7          	jalr	708(ra) # 80003a78 <stati>
    iunlock(f->ip);
    800047bc:	6c88                	ld	a0,24(s1)
    800047be:	fffff097          	auipc	ra,0xfffff
    800047c2:	0f2080e7          	jalr	242(ra) # 800038b0 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800047c6:	46e1                	li	a3,24
    800047c8:	fb840613          	addi	a2,s0,-72
    800047cc:	85ce                	mv	a1,s3
    800047ce:	05093503          	ld	a0,80(s2)
    800047d2:	ffffd097          	auipc	ra,0xffffd
    800047d6:	f0e080e7          	jalr	-242(ra) # 800016e0 <copyout>
    800047da:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    800047de:	60a6                	ld	ra,72(sp)
    800047e0:	6406                	ld	s0,64(sp)
    800047e2:	74e2                	ld	s1,56(sp)
    800047e4:	7942                	ld	s2,48(sp)
    800047e6:	79a2                	ld	s3,40(sp)
    800047e8:	6161                	addi	sp,sp,80
    800047ea:	8082                	ret
  return -1;
    800047ec:	557d                	li	a0,-1
    800047ee:	bfc5                	j	800047de <filestat+0x60>

00000000800047f0 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800047f0:	7179                	addi	sp,sp,-48
    800047f2:	f406                	sd	ra,40(sp)
    800047f4:	f022                	sd	s0,32(sp)
    800047f6:	ec26                	sd	s1,24(sp)
    800047f8:	e84a                	sd	s2,16(sp)
    800047fa:	e44e                	sd	s3,8(sp)
    800047fc:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800047fe:	00854783          	lbu	a5,8(a0)
    80004802:	c3d5                	beqz	a5,800048a6 <fileread+0xb6>
    80004804:	89b2                	mv	s3,a2
    80004806:	892e                	mv	s2,a1
    80004808:	84aa                	mv	s1,a0
    return -1;

  if(f->type == FD_PIPE){
    8000480a:	411c                	lw	a5,0(a0)
    8000480c:	4705                	li	a4,1
    8000480e:	04e78963          	beq	a5,a4,80004860 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004812:	470d                	li	a4,3
    80004814:	04e78d63          	beq	a5,a4,8000486e <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004818:	4709                	li	a4,2
    8000481a:	06e79e63          	bne	a5,a4,80004896 <fileread+0xa6>
    ilock(f->ip);
    8000481e:	6d08                	ld	a0,24(a0)
    80004820:	fffff097          	auipc	ra,0xfffff
    80004824:	fcc080e7          	jalr	-52(ra) # 800037ec <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004828:	874e                	mv	a4,s3
    8000482a:	5094                	lw	a3,32(s1)
    8000482c:	864a                	mv	a2,s2
    8000482e:	4585                	li	a1,1
    80004830:	6c88                	ld	a0,24(s1)
    80004832:	fffff097          	auipc	ra,0xfffff
    80004836:	270080e7          	jalr	624(ra) # 80003aa2 <readi>
    8000483a:	892a                	mv	s2,a0
    8000483c:	00a05563          	blez	a0,80004846 <fileread+0x56>
      f->off += r;
    80004840:	509c                	lw	a5,32(s1)
    80004842:	9fa9                	addw	a5,a5,a0
    80004844:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004846:	6c88                	ld	a0,24(s1)
    80004848:	fffff097          	auipc	ra,0xfffff
    8000484c:	068080e7          	jalr	104(ra) # 800038b0 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004850:	854a                	mv	a0,s2
    80004852:	70a2                	ld	ra,40(sp)
    80004854:	7402                	ld	s0,32(sp)
    80004856:	64e2                	ld	s1,24(sp)
    80004858:	6942                	ld	s2,16(sp)
    8000485a:	69a2                	ld	s3,8(sp)
    8000485c:	6145                	addi	sp,sp,48
    8000485e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004860:	6908                	ld	a0,16(a0)
    80004862:	00000097          	auipc	ra,0x0
    80004866:	3c8080e7          	jalr	968(ra) # 80004c2a <piperead>
    8000486a:	892a                	mv	s2,a0
    8000486c:	b7d5                	j	80004850 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000486e:	02451783          	lh	a5,36(a0)
    80004872:	03079693          	slli	a3,a5,0x30
    80004876:	92c1                	srli	a3,a3,0x30
    80004878:	4725                	li	a4,9
    8000487a:	02d76863          	bltu	a4,a3,800048aa <fileread+0xba>
    8000487e:	0792                	slli	a5,a5,0x4
    80004880:	0001c717          	auipc	a4,0x1c
    80004884:	38870713          	addi	a4,a4,904 # 80020c08 <devsw>
    80004888:	97ba                	add	a5,a5,a4
    8000488a:	639c                	ld	a5,0(a5)
    8000488c:	c38d                	beqz	a5,800048ae <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    8000488e:	4505                	li	a0,1
    80004890:	9782                	jalr	a5
    80004892:	892a                	mv	s2,a0
    80004894:	bf75                	j	80004850 <fileread+0x60>
    panic("fileread");
    80004896:	00004517          	auipc	a0,0x4
    8000489a:	e5250513          	addi	a0,a0,-430 # 800086e8 <syscalls+0x280>
    8000489e:	ffffc097          	auipc	ra,0xffffc
    800048a2:	cce080e7          	jalr	-818(ra) # 8000056c <panic>
    return -1;
    800048a6:	597d                	li	s2,-1
    800048a8:	b765                	j	80004850 <fileread+0x60>
      return -1;
    800048aa:	597d                	li	s2,-1
    800048ac:	b755                	j	80004850 <fileread+0x60>
    800048ae:	597d                	li	s2,-1
    800048b0:	b745                	j	80004850 <fileread+0x60>

00000000800048b2 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    800048b2:	715d                	addi	sp,sp,-80
    800048b4:	e486                	sd	ra,72(sp)
    800048b6:	e0a2                	sd	s0,64(sp)
    800048b8:	fc26                	sd	s1,56(sp)
    800048ba:	f84a                	sd	s2,48(sp)
    800048bc:	f44e                	sd	s3,40(sp)
    800048be:	f052                	sd	s4,32(sp)
    800048c0:	ec56                	sd	s5,24(sp)
    800048c2:	e85a                	sd	s6,16(sp)
    800048c4:	e45e                	sd	s7,8(sp)
    800048c6:	e062                	sd	s8,0(sp)
    800048c8:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    800048ca:	00954783          	lbu	a5,9(a0)
    800048ce:	10078063          	beqz	a5,800049ce <filewrite+0x11c>
    800048d2:	84aa                	mv	s1,a0
    800048d4:	8bae                	mv	s7,a1
    800048d6:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    800048d8:	411c                	lw	a5,0(a0)
    800048da:	4705                	li	a4,1
    800048dc:	02e78263          	beq	a5,a4,80004900 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800048e0:	470d                	li	a4,3
    800048e2:	02e78663          	beq	a5,a4,8000490e <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800048e6:	4709                	li	a4,2
    800048e8:	0ce79b63          	bne	a5,a4,800049be <filewrite+0x10c>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800048ec:	0ac05763          	blez	a2,8000499a <filewrite+0xe8>
    int i = 0;
    800048f0:	4901                	li	s2,0
    800048f2:	6b05                	lui	s6,0x1
    800048f4:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    800048f8:	6c05                	lui	s8,0x1
    800048fa:	c00c0c1b          	addiw	s8,s8,-1024
    800048fe:	a071                	j	8000498a <filewrite+0xd8>
    ret = pipewrite(f->pipe, addr, n);
    80004900:	6908                	ld	a0,16(a0)
    80004902:	00000097          	auipc	ra,0x0
    80004906:	222080e7          	jalr	546(ra) # 80004b24 <pipewrite>
    8000490a:	8aaa                	mv	s5,a0
    8000490c:	a851                	j	800049a0 <filewrite+0xee>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    8000490e:	02451783          	lh	a5,36(a0)
    80004912:	03079693          	slli	a3,a5,0x30
    80004916:	92c1                	srli	a3,a3,0x30
    80004918:	4725                	li	a4,9
    8000491a:	0ad76c63          	bltu	a4,a3,800049d2 <filewrite+0x120>
    8000491e:	0792                	slli	a5,a5,0x4
    80004920:	0001c717          	auipc	a4,0x1c
    80004924:	2e870713          	addi	a4,a4,744 # 80020c08 <devsw>
    80004928:	97ba                	add	a5,a5,a4
    8000492a:	679c                	ld	a5,8(a5)
    8000492c:	c7cd                	beqz	a5,800049d6 <filewrite+0x124>
    ret = devsw[f->major].write(1, addr, n);
    8000492e:	4505                	li	a0,1
    80004930:	9782                	jalr	a5
    80004932:	8aaa                	mv	s5,a0
    80004934:	a0b5                	j	800049a0 <filewrite+0xee>
    80004936:	00098a1b          	sext.w	s4,s3
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    8000493a:	00000097          	auipc	ra,0x0
    8000493e:	882080e7          	jalr	-1918(ra) # 800041bc <begin_op>
      ilock(f->ip);
    80004942:	6c88                	ld	a0,24(s1)
    80004944:	fffff097          	auipc	ra,0xfffff
    80004948:	ea8080e7          	jalr	-344(ra) # 800037ec <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000494c:	8752                	mv	a4,s4
    8000494e:	5094                	lw	a3,32(s1)
    80004950:	01790633          	add	a2,s2,s7
    80004954:	4585                	li	a1,1
    80004956:	6c88                	ld	a0,24(s1)
    80004958:	fffff097          	auipc	ra,0xfffff
    8000495c:	242080e7          	jalr	578(ra) # 80003b9a <writei>
    80004960:	89aa                	mv	s3,a0
    80004962:	00a05563          	blez	a0,8000496c <filewrite+0xba>
        f->off += r;
    80004966:	509c                	lw	a5,32(s1)
    80004968:	9fa9                	addw	a5,a5,a0
    8000496a:	d09c                	sw	a5,32(s1)
      iunlock(f->ip);
    8000496c:	6c88                	ld	a0,24(s1)
    8000496e:	fffff097          	auipc	ra,0xfffff
    80004972:	f42080e7          	jalr	-190(ra) # 800038b0 <iunlock>
      end_op();
    80004976:	00000097          	auipc	ra,0x0
    8000497a:	8c6080e7          	jalr	-1850(ra) # 8000423c <end_op>

      if(r != n1){
    8000497e:	01499f63          	bne	s3,s4,8000499c <filewrite+0xea>
        // error from writei
        break;
      }
      i += r;
    80004982:	012a093b          	addw	s2,s4,s2
    while(i < n){
    80004986:	01595b63          	bge	s2,s5,8000499c <filewrite+0xea>
      int n1 = n - i;
    8000498a:	412a87bb          	subw	a5,s5,s2
      if(n1 > max)
    8000498e:	89be                	mv	s3,a5
    80004990:	2781                	sext.w	a5,a5
    80004992:	fafb52e3          	bge	s6,a5,80004936 <filewrite+0x84>
    80004996:	89e2                	mv	s3,s8
    80004998:	bf79                	j	80004936 <filewrite+0x84>
    int i = 0;
    8000499a:	4901                	li	s2,0
    }
    ret = (i == n ? n : -1);
    8000499c:	012a9f63          	bne	s5,s2,800049ba <filewrite+0x108>
  } else {
    panic("filewrite");
  }

  return ret;
}
    800049a0:	8556                	mv	a0,s5
    800049a2:	60a6                	ld	ra,72(sp)
    800049a4:	6406                	ld	s0,64(sp)
    800049a6:	74e2                	ld	s1,56(sp)
    800049a8:	7942                	ld	s2,48(sp)
    800049aa:	79a2                	ld	s3,40(sp)
    800049ac:	7a02                	ld	s4,32(sp)
    800049ae:	6ae2                	ld	s5,24(sp)
    800049b0:	6b42                	ld	s6,16(sp)
    800049b2:	6ba2                	ld	s7,8(sp)
    800049b4:	6c02                	ld	s8,0(sp)
    800049b6:	6161                	addi	sp,sp,80
    800049b8:	8082                	ret
    ret = (i == n ? n : -1);
    800049ba:	5afd                	li	s5,-1
    800049bc:	b7d5                	j	800049a0 <filewrite+0xee>
    panic("filewrite");
    800049be:	00004517          	auipc	a0,0x4
    800049c2:	d3a50513          	addi	a0,a0,-710 # 800086f8 <syscalls+0x290>
    800049c6:	ffffc097          	auipc	ra,0xffffc
    800049ca:	ba6080e7          	jalr	-1114(ra) # 8000056c <panic>
    return -1;
    800049ce:	5afd                	li	s5,-1
    800049d0:	bfc1                	j	800049a0 <filewrite+0xee>
      return -1;
    800049d2:	5afd                	li	s5,-1
    800049d4:	b7f1                	j	800049a0 <filewrite+0xee>
    800049d6:	5afd                	li	s5,-1
    800049d8:	b7e1                	j	800049a0 <filewrite+0xee>

00000000800049da <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800049da:	7179                	addi	sp,sp,-48
    800049dc:	f406                	sd	ra,40(sp)
    800049de:	f022                	sd	s0,32(sp)
    800049e0:	ec26                	sd	s1,24(sp)
    800049e2:	e84a                	sd	s2,16(sp)
    800049e4:	e44e                	sd	s3,8(sp)
    800049e6:	e052                	sd	s4,0(sp)
    800049e8:	1800                	addi	s0,sp,48
    800049ea:	84aa                	mv	s1,a0
    800049ec:	892e                	mv	s2,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800049ee:	0005b023          	sd	zero,0(a1)
    800049f2:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800049f6:	00000097          	auipc	ra,0x0
    800049fa:	bf0080e7          	jalr	-1040(ra) # 800045e6 <filealloc>
    800049fe:	e088                	sd	a0,0(s1)
    80004a00:	c551                	beqz	a0,80004a8c <pipealloc+0xb2>
    80004a02:	00000097          	auipc	ra,0x0
    80004a06:	be4080e7          	jalr	-1052(ra) # 800045e6 <filealloc>
    80004a0a:	00a93023          	sd	a0,0(s2)
    80004a0e:	c92d                	beqz	a0,80004a80 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004a10:	ffffc097          	auipc	ra,0xffffc
    80004a14:	138080e7          	jalr	312(ra) # 80000b48 <kalloc>
    80004a18:	89aa                	mv	s3,a0
    80004a1a:	c125                	beqz	a0,80004a7a <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004a1c:	4a05                	li	s4,1
    80004a1e:	23452023          	sw	s4,544(a0)
  pi->writeopen = 1;
    80004a22:	23452223          	sw	s4,548(a0)
  pi->nwrite = 0;
    80004a26:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004a2a:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004a2e:	00004597          	auipc	a1,0x4
    80004a32:	cda58593          	addi	a1,a1,-806 # 80008708 <syscalls+0x2a0>
    80004a36:	ffffc097          	auipc	ra,0xffffc
    80004a3a:	172080e7          	jalr	370(ra) # 80000ba8 <initlock>
  (*f0)->type = FD_PIPE;
    80004a3e:	609c                	ld	a5,0(s1)
    80004a40:	0147a023          	sw	s4,0(a5)
  (*f0)->readable = 1;
    80004a44:	609c                	ld	a5,0(s1)
    80004a46:	01478423          	sb	s4,8(a5)
  (*f0)->writable = 0;
    80004a4a:	609c                	ld	a5,0(s1)
    80004a4c:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004a50:	609c                	ld	a5,0(s1)
    80004a52:	0137b823          	sd	s3,16(a5)
  (*f1)->type = FD_PIPE;
    80004a56:	00093783          	ld	a5,0(s2)
    80004a5a:	0147a023          	sw	s4,0(a5)
  (*f1)->readable = 0;
    80004a5e:	00093783          	ld	a5,0(s2)
    80004a62:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004a66:	00093783          	ld	a5,0(s2)
    80004a6a:	014784a3          	sb	s4,9(a5)
  (*f1)->pipe = pi;
    80004a6e:	00093783          	ld	a5,0(s2)
    80004a72:	0137b823          	sd	s3,16(a5)
  return 0;
    80004a76:	4501                	li	a0,0
    80004a78:	a025                	j	80004aa0 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004a7a:	6088                	ld	a0,0(s1)
    80004a7c:	e501                	bnez	a0,80004a84 <pipealloc+0xaa>
    80004a7e:	a039                	j	80004a8c <pipealloc+0xb2>
    80004a80:	6088                	ld	a0,0(s1)
    80004a82:	c51d                	beqz	a0,80004ab0 <pipealloc+0xd6>
    fileclose(*f0);
    80004a84:	00000097          	auipc	ra,0x0
    80004a88:	c32080e7          	jalr	-974(ra) # 800046b6 <fileclose>
  if(*f1)
    80004a8c:	00093783          	ld	a5,0(s2)
    fileclose(*f1);
  return -1;
    80004a90:	557d                	li	a0,-1
  if(*f1)
    80004a92:	c799                	beqz	a5,80004aa0 <pipealloc+0xc6>
    fileclose(*f1);
    80004a94:	853e                	mv	a0,a5
    80004a96:	00000097          	auipc	ra,0x0
    80004a9a:	c20080e7          	jalr	-992(ra) # 800046b6 <fileclose>
  return -1;
    80004a9e:	557d                	li	a0,-1
}
    80004aa0:	70a2                	ld	ra,40(sp)
    80004aa2:	7402                	ld	s0,32(sp)
    80004aa4:	64e2                	ld	s1,24(sp)
    80004aa6:	6942                	ld	s2,16(sp)
    80004aa8:	69a2                	ld	s3,8(sp)
    80004aaa:	6a02                	ld	s4,0(sp)
    80004aac:	6145                	addi	sp,sp,48
    80004aae:	8082                	ret
  return -1;
    80004ab0:	557d                	li	a0,-1
    80004ab2:	b7fd                	j	80004aa0 <pipealloc+0xc6>

0000000080004ab4 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004ab4:	1101                	addi	sp,sp,-32
    80004ab6:	ec06                	sd	ra,24(sp)
    80004ab8:	e822                	sd	s0,16(sp)
    80004aba:	e426                	sd	s1,8(sp)
    80004abc:	e04a                	sd	s2,0(sp)
    80004abe:	1000                	addi	s0,sp,32
    80004ac0:	84aa                	mv	s1,a0
    80004ac2:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004ac4:	ffffc097          	auipc	ra,0xffffc
    80004ac8:	174080e7          	jalr	372(ra) # 80000c38 <acquire>
  if(writable){
    80004acc:	02090d63          	beqz	s2,80004b06 <pipeclose+0x52>
    pi->writeopen = 0;
    80004ad0:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004ad4:	21848513          	addi	a0,s1,536
    80004ad8:	ffffd097          	auipc	ra,0xffffd
    80004adc:	66e080e7          	jalr	1646(ra) # 80002146 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004ae0:	2204b783          	ld	a5,544(s1)
    80004ae4:	eb95                	bnez	a5,80004b18 <pipeclose+0x64>
    release(&pi->lock);
    80004ae6:	8526                	mv	a0,s1
    80004ae8:	ffffc097          	auipc	ra,0xffffc
    80004aec:	204080e7          	jalr	516(ra) # 80000cec <release>
    kfree((char*)pi);
    80004af0:	8526                	mv	a0,s1
    80004af2:	ffffc097          	auipc	ra,0xffffc
    80004af6:	f56080e7          	jalr	-170(ra) # 80000a48 <kfree>
  } else
    release(&pi->lock);
}
    80004afa:	60e2                	ld	ra,24(sp)
    80004afc:	6442                	ld	s0,16(sp)
    80004afe:	64a2                	ld	s1,8(sp)
    80004b00:	6902                	ld	s2,0(sp)
    80004b02:	6105                	addi	sp,sp,32
    80004b04:	8082                	ret
    pi->readopen = 0;
    80004b06:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004b0a:	21c48513          	addi	a0,s1,540
    80004b0e:	ffffd097          	auipc	ra,0xffffd
    80004b12:	638080e7          	jalr	1592(ra) # 80002146 <wakeup>
    80004b16:	b7e9                	j	80004ae0 <pipeclose+0x2c>
    release(&pi->lock);
    80004b18:	8526                	mv	a0,s1
    80004b1a:	ffffc097          	auipc	ra,0xffffc
    80004b1e:	1d2080e7          	jalr	466(ra) # 80000cec <release>
}
    80004b22:	bfe1                	j	80004afa <pipeclose+0x46>

0000000080004b24 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004b24:	7159                	addi	sp,sp,-112
    80004b26:	f486                	sd	ra,104(sp)
    80004b28:	f0a2                	sd	s0,96(sp)
    80004b2a:	eca6                	sd	s1,88(sp)
    80004b2c:	e8ca                	sd	s2,80(sp)
    80004b2e:	e4ce                	sd	s3,72(sp)
    80004b30:	e0d2                	sd	s4,64(sp)
    80004b32:	fc56                	sd	s5,56(sp)
    80004b34:	f85a                	sd	s6,48(sp)
    80004b36:	f45e                	sd	s7,40(sp)
    80004b38:	f062                	sd	s8,32(sp)
    80004b3a:	ec66                	sd	s9,24(sp)
    80004b3c:	1880                	addi	s0,sp,112
    80004b3e:	84aa                	mv	s1,a0
    80004b40:	8aae                	mv	s5,a1
    80004b42:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004b44:	ffffd097          	auipc	ra,0xffffd
    80004b48:	ef6080e7          	jalr	-266(ra) # 80001a3a <myproc>
    80004b4c:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004b4e:	8526                	mv	a0,s1
    80004b50:	ffffc097          	auipc	ra,0xffffc
    80004b54:	0e8080e7          	jalr	232(ra) # 80000c38 <acquire>
  while(i < n){
    80004b58:	0d405763          	blez	s4,80004c26 <pipewrite+0x102>
    80004b5c:	8ba6                	mv	s7,s1
    if(pi->readopen == 0 || killed(pr)){
    80004b5e:	2204a783          	lw	a5,544(s1)
    80004b62:	cb81                	beqz	a5,80004b72 <pipewrite+0x4e>
  int i = 0;
    80004b64:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004b66:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004b68:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004b6c:	21c48c13          	addi	s8,s1,540
    80004b70:	a0a5                	j	80004bd8 <pipewrite+0xb4>
      release(&pi->lock);
    80004b72:	8526                	mv	a0,s1
    80004b74:	ffffc097          	auipc	ra,0xffffc
    80004b78:	178080e7          	jalr	376(ra) # 80000cec <release>
      return -1;
    80004b7c:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004b7e:	854a                	mv	a0,s2
    80004b80:	70a6                	ld	ra,104(sp)
    80004b82:	7406                	ld	s0,96(sp)
    80004b84:	64e6                	ld	s1,88(sp)
    80004b86:	6946                	ld	s2,80(sp)
    80004b88:	69a6                	ld	s3,72(sp)
    80004b8a:	6a06                	ld	s4,64(sp)
    80004b8c:	7ae2                	ld	s5,56(sp)
    80004b8e:	7b42                	ld	s6,48(sp)
    80004b90:	7ba2                	ld	s7,40(sp)
    80004b92:	7c02                	ld	s8,32(sp)
    80004b94:	6ce2                	ld	s9,24(sp)
    80004b96:	6165                	addi	sp,sp,112
    80004b98:	8082                	ret
      wakeup(&pi->nread);
    80004b9a:	8566                	mv	a0,s9
    80004b9c:	ffffd097          	auipc	ra,0xffffd
    80004ba0:	5aa080e7          	jalr	1450(ra) # 80002146 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004ba4:	85de                	mv	a1,s7
    80004ba6:	8562                	mv	a0,s8
    80004ba8:	ffffd097          	auipc	ra,0xffffd
    80004bac:	53a080e7          	jalr	1338(ra) # 800020e2 <sleep>
    80004bb0:	a839                	j	80004bce <pipewrite+0xaa>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004bb2:	21c4a783          	lw	a5,540(s1)
    80004bb6:	0017871b          	addiw	a4,a5,1
    80004bba:	20e4ae23          	sw	a4,540(s1)
    80004bbe:	1ff7f793          	andi	a5,a5,511
    80004bc2:	97a6                	add	a5,a5,s1
    80004bc4:	f9f44703          	lbu	a4,-97(s0)
    80004bc8:	00e78c23          	sb	a4,24(a5)
      i++;
    80004bcc:	2905                	addiw	s2,s2,1
  while(i < n){
    80004bce:	05495063          	bge	s2,s4,80004c0e <pipewrite+0xea>
    if(pi->readopen == 0 || killed(pr)){
    80004bd2:	2204a783          	lw	a5,544(s1)
    80004bd6:	dfd1                	beqz	a5,80004b72 <pipewrite+0x4e>
    80004bd8:	854e                	mv	a0,s3
    80004bda:	ffffd097          	auipc	ra,0xffffd
    80004bde:	7b2080e7          	jalr	1970(ra) # 8000238c <killed>
    80004be2:	f941                	bnez	a0,80004b72 <pipewrite+0x4e>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004be4:	2184a783          	lw	a5,536(s1)
    80004be8:	21c4a703          	lw	a4,540(s1)
    80004bec:	2007879b          	addiw	a5,a5,512
    80004bf0:	faf705e3          	beq	a4,a5,80004b9a <pipewrite+0x76>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004bf4:	4685                	li	a3,1
    80004bf6:	01590633          	add	a2,s2,s5
    80004bfa:	f9f40593          	addi	a1,s0,-97
    80004bfe:	0509b503          	ld	a0,80(s3)
    80004c02:	ffffd097          	auipc	ra,0xffffd
    80004c06:	b6a080e7          	jalr	-1174(ra) # 8000176c <copyin>
    80004c0a:	fb6514e3          	bne	a0,s6,80004bb2 <pipewrite+0x8e>
  wakeup(&pi->nread);
    80004c0e:	21848513          	addi	a0,s1,536
    80004c12:	ffffd097          	auipc	ra,0xffffd
    80004c16:	534080e7          	jalr	1332(ra) # 80002146 <wakeup>
  release(&pi->lock);
    80004c1a:	8526                	mv	a0,s1
    80004c1c:	ffffc097          	auipc	ra,0xffffc
    80004c20:	0d0080e7          	jalr	208(ra) # 80000cec <release>
  return i;
    80004c24:	bfa9                	j	80004b7e <pipewrite+0x5a>
  int i = 0;
    80004c26:	4901                	li	s2,0
    80004c28:	b7dd                	j	80004c0e <pipewrite+0xea>

0000000080004c2a <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004c2a:	715d                	addi	sp,sp,-80
    80004c2c:	e486                	sd	ra,72(sp)
    80004c2e:	e0a2                	sd	s0,64(sp)
    80004c30:	fc26                	sd	s1,56(sp)
    80004c32:	f84a                	sd	s2,48(sp)
    80004c34:	f44e                	sd	s3,40(sp)
    80004c36:	f052                	sd	s4,32(sp)
    80004c38:	ec56                	sd	s5,24(sp)
    80004c3a:	e85a                	sd	s6,16(sp)
    80004c3c:	0880                	addi	s0,sp,80
    80004c3e:	84aa                	mv	s1,a0
    80004c40:	89ae                	mv	s3,a1
    80004c42:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004c44:	ffffd097          	auipc	ra,0xffffd
    80004c48:	df6080e7          	jalr	-522(ra) # 80001a3a <myproc>
    80004c4c:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004c4e:	8526                	mv	a0,s1
    80004c50:	ffffc097          	auipc	ra,0xffffc
    80004c54:	fe8080e7          	jalr	-24(ra) # 80000c38 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004c58:	2184a703          	lw	a4,536(s1)
    80004c5c:	21c4a783          	lw	a5,540(s1)
    80004c60:	06f71b63          	bne	a4,a5,80004cd6 <piperead+0xac>
    80004c64:	8926                	mv	s2,s1
    80004c66:	2244a783          	lw	a5,548(s1)
    80004c6a:	cb85                	beqz	a5,80004c9a <piperead+0x70>
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004c6c:	21848b13          	addi	s6,s1,536
    if(killed(pr)){
    80004c70:	8552                	mv	a0,s4
    80004c72:	ffffd097          	auipc	ra,0xffffd
    80004c76:	71a080e7          	jalr	1818(ra) # 8000238c <killed>
    80004c7a:	e539                	bnez	a0,80004cc8 <piperead+0x9e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004c7c:	85ca                	mv	a1,s2
    80004c7e:	855a                	mv	a0,s6
    80004c80:	ffffd097          	auipc	ra,0xffffd
    80004c84:	462080e7          	jalr	1122(ra) # 800020e2 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004c88:	2184a703          	lw	a4,536(s1)
    80004c8c:	21c4a783          	lw	a5,540(s1)
    80004c90:	04f71363          	bne	a4,a5,80004cd6 <piperead+0xac>
    80004c94:	2244a783          	lw	a5,548(s1)
    80004c98:	ffe1                	bnez	a5,80004c70 <piperead+0x46>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    if(pi->nread == pi->nwrite)
    80004c9a:	4901                	li	s2,0
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004c9c:	21c48513          	addi	a0,s1,540
    80004ca0:	ffffd097          	auipc	ra,0xffffd
    80004ca4:	4a6080e7          	jalr	1190(ra) # 80002146 <wakeup>
  release(&pi->lock);
    80004ca8:	8526                	mv	a0,s1
    80004caa:	ffffc097          	auipc	ra,0xffffc
    80004cae:	042080e7          	jalr	66(ra) # 80000cec <release>
  return i;
}
    80004cb2:	854a                	mv	a0,s2
    80004cb4:	60a6                	ld	ra,72(sp)
    80004cb6:	6406                	ld	s0,64(sp)
    80004cb8:	74e2                	ld	s1,56(sp)
    80004cba:	7942                	ld	s2,48(sp)
    80004cbc:	79a2                	ld	s3,40(sp)
    80004cbe:	7a02                	ld	s4,32(sp)
    80004cc0:	6ae2                	ld	s5,24(sp)
    80004cc2:	6b42                	ld	s6,16(sp)
    80004cc4:	6161                	addi	sp,sp,80
    80004cc6:	8082                	ret
      release(&pi->lock);
    80004cc8:	8526                	mv	a0,s1
    80004cca:	ffffc097          	auipc	ra,0xffffc
    80004cce:	022080e7          	jalr	34(ra) # 80000cec <release>
      return -1;
    80004cd2:	597d                	li	s2,-1
    80004cd4:	bff9                	j	80004cb2 <piperead+0x88>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004cd6:	4901                	li	s2,0
    80004cd8:	fd5052e3          	blez	s5,80004c9c <piperead+0x72>
    if(pi->nread == pi->nwrite)
    80004cdc:	2184a783          	lw	a5,536(s1)
    80004ce0:	4901                	li	s2,0
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004ce2:	5b7d                	li	s6,-1
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004ce4:	0017871b          	addiw	a4,a5,1
    80004ce8:	20e4ac23          	sw	a4,536(s1)
    80004cec:	1ff7f793          	andi	a5,a5,511
    80004cf0:	97a6                	add	a5,a5,s1
    80004cf2:	0187c783          	lbu	a5,24(a5)
    80004cf6:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004cfa:	4685                	li	a3,1
    80004cfc:	fbf40613          	addi	a2,s0,-65
    80004d00:	85ce                	mv	a1,s3
    80004d02:	050a3503          	ld	a0,80(s4)
    80004d06:	ffffd097          	auipc	ra,0xffffd
    80004d0a:	9da080e7          	jalr	-1574(ra) # 800016e0 <copyout>
    80004d0e:	f96507e3          	beq	a0,s6,80004c9c <piperead+0x72>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004d12:	2905                	addiw	s2,s2,1
    80004d14:	f92a84e3          	beq	s5,s2,80004c9c <piperead+0x72>
    if(pi->nread == pi->nwrite)
    80004d18:	2184a783          	lw	a5,536(s1)
    80004d1c:	0985                	addi	s3,s3,1
    80004d1e:	21c4a703          	lw	a4,540(s1)
    80004d22:	fcf711e3          	bne	a4,a5,80004ce4 <piperead+0xba>
    80004d26:	bf9d                	j	80004c9c <piperead+0x72>

0000000080004d28 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004d28:	1141                	addi	sp,sp,-16
    80004d2a:	e422                	sd	s0,8(sp)
    80004d2c:	0800                	addi	s0,sp,16
    80004d2e:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004d30:	8905                	andi	a0,a0,1
    80004d32:	c111                	beqz	a0,80004d36 <flags2perm+0xe>
      perm = PTE_X;
    80004d34:	4521                	li	a0,8
    if(flags & 0x2)
    80004d36:	8b89                	andi	a5,a5,2
    80004d38:	c399                	beqz	a5,80004d3e <flags2perm+0x16>
      perm |= PTE_W;
    80004d3a:	00456513          	ori	a0,a0,4
    return perm;
}
    80004d3e:	6422                	ld	s0,8(sp)
    80004d40:	0141                	addi	sp,sp,16
    80004d42:	8082                	ret

0000000080004d44 <exec>:

int
exec(char *path, char **argv)
{
    80004d44:	de010113          	addi	sp,sp,-544
    80004d48:	20113c23          	sd	ra,536(sp)
    80004d4c:	20813823          	sd	s0,528(sp)
    80004d50:	20913423          	sd	s1,520(sp)
    80004d54:	21213023          	sd	s2,512(sp)
    80004d58:	ffce                	sd	s3,504(sp)
    80004d5a:	fbd2                	sd	s4,496(sp)
    80004d5c:	f7d6                	sd	s5,488(sp)
    80004d5e:	f3da                	sd	s6,480(sp)
    80004d60:	efde                	sd	s7,472(sp)
    80004d62:	ebe2                	sd	s8,464(sp)
    80004d64:	e7e6                	sd	s9,456(sp)
    80004d66:	e3ea                	sd	s10,448(sp)
    80004d68:	ff6e                	sd	s11,440(sp)
    80004d6a:	1400                	addi	s0,sp,544
    80004d6c:	892a                	mv	s2,a0
    80004d6e:	dea43823          	sd	a0,-528(s0)
    80004d72:	deb43c23          	sd	a1,-520(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004d76:	ffffd097          	auipc	ra,0xffffd
    80004d7a:	cc4080e7          	jalr	-828(ra) # 80001a3a <myproc>
    80004d7e:	84aa                	mv	s1,a0

  begin_op();
    80004d80:	fffff097          	auipc	ra,0xfffff
    80004d84:	43c080e7          	jalr	1084(ra) # 800041bc <begin_op>

  if((ip = namei(path)) == 0){
    80004d88:	854a                	mv	a0,s2
    80004d8a:	fffff097          	auipc	ra,0xfffff
    80004d8e:	214080e7          	jalr	532(ra) # 80003f9e <namei>
    80004d92:	c93d                	beqz	a0,80004e08 <exec+0xc4>
    80004d94:	892a                	mv	s2,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004d96:	fffff097          	auipc	ra,0xfffff
    80004d9a:	a56080e7          	jalr	-1450(ra) # 800037ec <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004d9e:	04000713          	li	a4,64
    80004da2:	4681                	li	a3,0
    80004da4:	e5040613          	addi	a2,s0,-432
    80004da8:	4581                	li	a1,0
    80004daa:	854a                	mv	a0,s2
    80004dac:	fffff097          	auipc	ra,0xfffff
    80004db0:	cf6080e7          	jalr	-778(ra) # 80003aa2 <readi>
    80004db4:	04000793          	li	a5,64
    80004db8:	00f51a63          	bne	a0,a5,80004dcc <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004dbc:	e5042703          	lw	a4,-432(s0)
    80004dc0:	464c47b7          	lui	a5,0x464c4
    80004dc4:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004dc8:	04f70663          	beq	a4,a5,80004e14 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004dcc:	854a                	mv	a0,s2
    80004dce:	fffff097          	auipc	ra,0xfffff
    80004dd2:	c82080e7          	jalr	-894(ra) # 80003a50 <iunlockput>
    end_op();
    80004dd6:	fffff097          	auipc	ra,0xfffff
    80004dda:	466080e7          	jalr	1126(ra) # 8000423c <end_op>
  }
  return -1;
    80004dde:	557d                	li	a0,-1
}
    80004de0:	21813083          	ld	ra,536(sp)
    80004de4:	21013403          	ld	s0,528(sp)
    80004de8:	20813483          	ld	s1,520(sp)
    80004dec:	20013903          	ld	s2,512(sp)
    80004df0:	79fe                	ld	s3,504(sp)
    80004df2:	7a5e                	ld	s4,496(sp)
    80004df4:	7abe                	ld	s5,488(sp)
    80004df6:	7b1e                	ld	s6,480(sp)
    80004df8:	6bfe                	ld	s7,472(sp)
    80004dfa:	6c5e                	ld	s8,464(sp)
    80004dfc:	6cbe                	ld	s9,456(sp)
    80004dfe:	6d1e                	ld	s10,448(sp)
    80004e00:	7dfa                	ld	s11,440(sp)
    80004e02:	22010113          	addi	sp,sp,544
    80004e06:	8082                	ret
    end_op();
    80004e08:	fffff097          	auipc	ra,0xfffff
    80004e0c:	434080e7          	jalr	1076(ra) # 8000423c <end_op>
    return -1;
    80004e10:	557d                	li	a0,-1
    80004e12:	b7f9                	j	80004de0 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004e14:	8526                	mv	a0,s1
    80004e16:	ffffd097          	auipc	ra,0xffffd
    80004e1a:	cea080e7          	jalr	-790(ra) # 80001b00 <proc_pagetable>
    80004e1e:	e0a43423          	sd	a0,-504(s0)
    80004e22:	d54d                	beqz	a0,80004dcc <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004e24:	e7042983          	lw	s3,-400(s0)
    80004e28:	e8845783          	lhu	a5,-376(s0)
    80004e2c:	c7ad                	beqz	a5,80004e96 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004e2e:	4a01                	li	s4,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004e30:	4b01                	li	s6,0
    if(ph.vaddr % PGSIZE != 0)
    80004e32:	6c05                	lui	s8,0x1
    80004e34:	fffc0793          	addi	a5,s8,-1 # fff <_entry-0x7ffff001>
    80004e38:	def43423          	sd	a5,-536(s0)
    80004e3c:	7cfd                	lui	s9,0xfffff
    80004e3e:	a481                	j	8000507e <exec+0x33a>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004e40:	00004517          	auipc	a0,0x4
    80004e44:	8d050513          	addi	a0,a0,-1840 # 80008710 <syscalls+0x2a8>
    80004e48:	ffffb097          	auipc	ra,0xffffb
    80004e4c:	724080e7          	jalr	1828(ra) # 8000056c <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004e50:	8756                	mv	a4,s5
    80004e52:	009d86bb          	addw	a3,s11,s1
    80004e56:	4581                	li	a1,0
    80004e58:	854a                	mv	a0,s2
    80004e5a:	fffff097          	auipc	ra,0xfffff
    80004e5e:	c48080e7          	jalr	-952(ra) # 80003aa2 <readi>
    80004e62:	2501                	sext.w	a0,a0
    80004e64:	1caa9063          	bne	s5,a0,80005024 <exec+0x2e0>
  for(i = 0; i < sz; i += PGSIZE){
    80004e68:	6785                	lui	a5,0x1
    80004e6a:	9cbd                	addw	s1,s1,a5
    80004e6c:	014c8a3b          	addw	s4,s9,s4
    80004e70:	1f74fe63          	bgeu	s1,s7,8000506c <exec+0x328>
    pa = walkaddr(pagetable, va + i);
    80004e74:	02049593          	slli	a1,s1,0x20
    80004e78:	9181                	srli	a1,a1,0x20
    80004e7a:	95ea                	add	a1,a1,s10
    80004e7c:	e0843503          	ld	a0,-504(s0)
    80004e80:	ffffc097          	auipc	ra,0xffffc
    80004e84:	26a080e7          	jalr	618(ra) # 800010ea <walkaddr>
    80004e88:	862a                	mv	a2,a0
    if(pa == 0)
    80004e8a:	d95d                	beqz	a0,80004e40 <exec+0xfc>
      n = PGSIZE;
    80004e8c:	8ae2                	mv	s5,s8
    if(sz - i < PGSIZE)
    80004e8e:	fd8a71e3          	bgeu	s4,s8,80004e50 <exec+0x10c>
      n = sz - i;
    80004e92:	8ad2                	mv	s5,s4
    80004e94:	bf75                	j	80004e50 <exec+0x10c>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004e96:	4a01                	li	s4,0
  iunlockput(ip);
    80004e98:	854a                	mv	a0,s2
    80004e9a:	fffff097          	auipc	ra,0xfffff
    80004e9e:	bb6080e7          	jalr	-1098(ra) # 80003a50 <iunlockput>
  end_op();
    80004ea2:	fffff097          	auipc	ra,0xfffff
    80004ea6:	39a080e7          	jalr	922(ra) # 8000423c <end_op>
  p = myproc();
    80004eaa:	ffffd097          	auipc	ra,0xffffd
    80004eae:	b90080e7          	jalr	-1136(ra) # 80001a3a <myproc>
    80004eb2:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004eb4:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004eb8:	6785                	lui	a5,0x1
    80004eba:	17fd                	addi	a5,a5,-1
    80004ebc:	9a3e                	add	s4,s4,a5
    80004ebe:	77fd                	lui	a5,0xfffff
    80004ec0:	00fa77b3          	and	a5,s4,a5
    80004ec4:	e0f43023          	sd	a5,-512(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004ec8:	4691                	li	a3,4
    80004eca:	6609                	lui	a2,0x2
    80004ecc:	963e                	add	a2,a2,a5
    80004ece:	85be                	mv	a1,a5
    80004ed0:	e0843483          	ld	s1,-504(s0)
    80004ed4:	8526                	mv	a0,s1
    80004ed6:	ffffc097          	auipc	ra,0xffffc
    80004eda:	5c6080e7          	jalr	1478(ra) # 8000149c <uvmalloc>
    80004ede:	8b2a                	mv	s6,a0
  ip = 0;
    80004ee0:	4901                	li	s2,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004ee2:	14050163          	beqz	a0,80005024 <exec+0x2e0>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004ee6:	75f9                	lui	a1,0xffffe
    80004ee8:	95aa                	add	a1,a1,a0
    80004eea:	8526                	mv	a0,s1
    80004eec:	ffffc097          	auipc	ra,0xffffc
    80004ef0:	7c2080e7          	jalr	1986(ra) # 800016ae <uvmclear>
  stackbase = sp - PGSIZE;
    80004ef4:	7bfd                	lui	s7,0xfffff
    80004ef6:	9bda                	add	s7,s7,s6
  for(argc = 0; argv[argc]; argc++) {
    80004ef8:	df843783          	ld	a5,-520(s0)
    80004efc:	6388                	ld	a0,0(a5)
    80004efe:	c925                	beqz	a0,80004f6e <exec+0x22a>
    80004f00:	e9040993          	addi	s3,s0,-368
    80004f04:	f9040c13          	addi	s8,s0,-112
  sp = sz;
    80004f08:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80004f0a:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004f0c:	ffffc097          	auipc	ra,0xffffc
    80004f10:	fce080e7          	jalr	-50(ra) # 80000eda <strlen>
    80004f14:	2505                	addiw	a0,a0,1
    80004f16:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004f1a:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004f1e:	13796b63          	bltu	s2,s7,80005054 <exec+0x310>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004f22:	df843c83          	ld	s9,-520(s0)
    80004f26:	000cba03          	ld	s4,0(s9) # fffffffffffff000 <end+0xffffffff7ffdd260>
    80004f2a:	8552                	mv	a0,s4
    80004f2c:	ffffc097          	auipc	ra,0xffffc
    80004f30:	fae080e7          	jalr	-82(ra) # 80000eda <strlen>
    80004f34:	0015069b          	addiw	a3,a0,1
    80004f38:	8652                	mv	a2,s4
    80004f3a:	85ca                	mv	a1,s2
    80004f3c:	e0843503          	ld	a0,-504(s0)
    80004f40:	ffffc097          	auipc	ra,0xffffc
    80004f44:	7a0080e7          	jalr	1952(ra) # 800016e0 <copyout>
    80004f48:	10054a63          	bltz	a0,8000505c <exec+0x318>
    ustack[argc] = sp;
    80004f4c:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004f50:	0485                	addi	s1,s1,1
    80004f52:	008c8793          	addi	a5,s9,8
    80004f56:	def43c23          	sd	a5,-520(s0)
    80004f5a:	008cb503          	ld	a0,8(s9)
    80004f5e:	c911                	beqz	a0,80004f72 <exec+0x22e>
    if(argc >= MAXARG)
    80004f60:	09a1                	addi	s3,s3,8
    80004f62:	fb8995e3          	bne	s3,s8,80004f0c <exec+0x1c8>
  sz = sz1;
    80004f66:	e1643023          	sd	s6,-512(s0)
  ip = 0;
    80004f6a:	4901                	li	s2,0
    80004f6c:	a865                	j	80005024 <exec+0x2e0>
  sp = sz;
    80004f6e:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80004f70:	4481                	li	s1,0
  ustack[argc] = 0;
    80004f72:	00349793          	slli	a5,s1,0x3
    80004f76:	f9040713          	addi	a4,s0,-112
    80004f7a:	97ba                	add	a5,a5,a4
    80004f7c:	f007b023          	sd	zero,-256(a5) # ffffffffffffef00 <end+0xffffffff7ffdd160>
  sp -= (argc+1) * sizeof(uint64);
    80004f80:	00148693          	addi	a3,s1,1
    80004f84:	068e                	slli	a3,a3,0x3
    80004f86:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004f8a:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004f8e:	01797663          	bgeu	s2,s7,80004f9a <exec+0x256>
  sz = sz1;
    80004f92:	e1643023          	sd	s6,-512(s0)
  ip = 0;
    80004f96:	4901                	li	s2,0
    80004f98:	a071                	j	80005024 <exec+0x2e0>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004f9a:	e9040613          	addi	a2,s0,-368
    80004f9e:	85ca                	mv	a1,s2
    80004fa0:	e0843503          	ld	a0,-504(s0)
    80004fa4:	ffffc097          	auipc	ra,0xffffc
    80004fa8:	73c080e7          	jalr	1852(ra) # 800016e0 <copyout>
    80004fac:	0a054c63          	bltz	a0,80005064 <exec+0x320>
  p->trapframe->a1 = sp;
    80004fb0:	058ab783          	ld	a5,88(s5)
    80004fb4:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004fb8:	df043783          	ld	a5,-528(s0)
    80004fbc:	0007c703          	lbu	a4,0(a5)
    80004fc0:	cf11                	beqz	a4,80004fdc <exec+0x298>
    80004fc2:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004fc4:	02f00693          	li	a3,47
    80004fc8:	a039                	j	80004fd6 <exec+0x292>
      last = s+1;
    80004fca:	def43823          	sd	a5,-528(s0)
  for(last=s=path; *s; s++)
    80004fce:	0785                	addi	a5,a5,1
    80004fd0:	fff7c703          	lbu	a4,-1(a5)
    80004fd4:	c701                	beqz	a4,80004fdc <exec+0x298>
    if(*s == '/')
    80004fd6:	fed71ce3          	bne	a4,a3,80004fce <exec+0x28a>
    80004fda:	bfc5                	j	80004fca <exec+0x286>
  safestrcpy(p->name, last, sizeof(p->name));
    80004fdc:	4641                	li	a2,16
    80004fde:	df043583          	ld	a1,-528(s0)
    80004fe2:	158a8513          	addi	a0,s5,344
    80004fe6:	ffffc097          	auipc	ra,0xffffc
    80004fea:	ec2080e7          	jalr	-318(ra) # 80000ea8 <safestrcpy>
  oldpagetable = p->pagetable;
    80004fee:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004ff2:	e0843783          	ld	a5,-504(s0)
    80004ff6:	04fab823          	sd	a5,80(s5)
  p->sz = sz;
    80004ffa:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004ffe:	058ab783          	ld	a5,88(s5)
    80005002:	e6843703          	ld	a4,-408(s0)
    80005006:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80005008:	058ab783          	ld	a5,88(s5)
    8000500c:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80005010:	85ea                	mv	a1,s10
    80005012:	ffffd097          	auipc	ra,0xffffd
    80005016:	b8a080e7          	jalr	-1142(ra) # 80001b9c <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000501a:	0004851b          	sext.w	a0,s1
    8000501e:	b3c9                	j	80004de0 <exec+0x9c>
    80005020:	e1443023          	sd	s4,-512(s0)
    proc_freepagetable(pagetable, sz);
    80005024:	e0043583          	ld	a1,-512(s0)
    80005028:	e0843503          	ld	a0,-504(s0)
    8000502c:	ffffd097          	auipc	ra,0xffffd
    80005030:	b70080e7          	jalr	-1168(ra) # 80001b9c <proc_freepagetable>
  if(ip){
    80005034:	d8091ce3          	bnez	s2,80004dcc <exec+0x88>
  return -1;
    80005038:	557d                	li	a0,-1
    8000503a:	b35d                	j	80004de0 <exec+0x9c>
    8000503c:	e1443023          	sd	s4,-512(s0)
    80005040:	b7d5                	j	80005024 <exec+0x2e0>
    80005042:	e1443023          	sd	s4,-512(s0)
    80005046:	bff9                	j	80005024 <exec+0x2e0>
    80005048:	e1443023          	sd	s4,-512(s0)
    8000504c:	bfe1                	j	80005024 <exec+0x2e0>
    8000504e:	e1443023          	sd	s4,-512(s0)
    80005052:	bfc9                	j	80005024 <exec+0x2e0>
  sz = sz1;
    80005054:	e1643023          	sd	s6,-512(s0)
  ip = 0;
    80005058:	4901                	li	s2,0
    8000505a:	b7e9                	j	80005024 <exec+0x2e0>
  sz = sz1;
    8000505c:	e1643023          	sd	s6,-512(s0)
  ip = 0;
    80005060:	4901                	li	s2,0
    80005062:	b7c9                	j	80005024 <exec+0x2e0>
  sz = sz1;
    80005064:	e1643023          	sd	s6,-512(s0)
  ip = 0;
    80005068:	4901                	li	s2,0
    8000506a:	bf6d                	j	80005024 <exec+0x2e0>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000506c:	e0043a03          	ld	s4,-512(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005070:	2b05                	addiw	s6,s6,1
    80005072:	0389899b          	addiw	s3,s3,56
    80005076:	e8845783          	lhu	a5,-376(s0)
    8000507a:	e0fb5fe3          	bge	s6,a5,80004e98 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000507e:	2981                	sext.w	s3,s3
    80005080:	03800713          	li	a4,56
    80005084:	86ce                	mv	a3,s3
    80005086:	e1840613          	addi	a2,s0,-488
    8000508a:	4581                	li	a1,0
    8000508c:	854a                	mv	a0,s2
    8000508e:	fffff097          	auipc	ra,0xfffff
    80005092:	a14080e7          	jalr	-1516(ra) # 80003aa2 <readi>
    80005096:	03800793          	li	a5,56
    8000509a:	f8f513e3          	bne	a0,a5,80005020 <exec+0x2dc>
    if(ph.type != ELF_PROG_LOAD)
    8000509e:	e1842783          	lw	a5,-488(s0)
    800050a2:	4705                	li	a4,1
    800050a4:	fce796e3          	bne	a5,a4,80005070 <exec+0x32c>
    if(ph.memsz < ph.filesz)
    800050a8:	e4043483          	ld	s1,-448(s0)
    800050ac:	e3843783          	ld	a5,-456(s0)
    800050b0:	f8f4e6e3          	bltu	s1,a5,8000503c <exec+0x2f8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800050b4:	e2843783          	ld	a5,-472(s0)
    800050b8:	94be                	add	s1,s1,a5
    800050ba:	f8f4e4e3          	bltu	s1,a5,80005042 <exec+0x2fe>
    if(ph.vaddr % PGSIZE != 0)
    800050be:	de843703          	ld	a4,-536(s0)
    800050c2:	8ff9                	and	a5,a5,a4
    800050c4:	f3d1                	bnez	a5,80005048 <exec+0x304>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800050c6:	e1c42503          	lw	a0,-484(s0)
    800050ca:	00000097          	auipc	ra,0x0
    800050ce:	c5e080e7          	jalr	-930(ra) # 80004d28 <flags2perm>
    800050d2:	86aa                	mv	a3,a0
    800050d4:	8626                	mv	a2,s1
    800050d6:	85d2                	mv	a1,s4
    800050d8:	e0843503          	ld	a0,-504(s0)
    800050dc:	ffffc097          	auipc	ra,0xffffc
    800050e0:	3c0080e7          	jalr	960(ra) # 8000149c <uvmalloc>
    800050e4:	e0a43023          	sd	a0,-512(s0)
    800050e8:	d13d                	beqz	a0,8000504e <exec+0x30a>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800050ea:	e2843d03          	ld	s10,-472(s0)
    800050ee:	e2042d83          	lw	s11,-480(s0)
    800050f2:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800050f6:	f60b8be3          	beqz	s7,8000506c <exec+0x328>
    800050fa:	8a5e                	mv	s4,s7
    800050fc:	4481                	li	s1,0
    800050fe:	bb9d                	j	80004e74 <exec+0x130>

0000000080005100 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005100:	7179                	addi	sp,sp,-48
    80005102:	f406                	sd	ra,40(sp)
    80005104:	f022                	sd	s0,32(sp)
    80005106:	ec26                	sd	s1,24(sp)
    80005108:	e84a                	sd	s2,16(sp)
    8000510a:	1800                	addi	s0,sp,48
    8000510c:	892e                	mv	s2,a1
    8000510e:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80005110:	fdc40593          	addi	a1,s0,-36
    80005114:	ffffe097          	auipc	ra,0xffffe
    80005118:	b14080e7          	jalr	-1260(ra) # 80002c28 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000511c:	fdc42703          	lw	a4,-36(s0)
    80005120:	47bd                	li	a5,15
    80005122:	02e7eb63          	bltu	a5,a4,80005158 <argfd+0x58>
    80005126:	ffffd097          	auipc	ra,0xffffd
    8000512a:	914080e7          	jalr	-1772(ra) # 80001a3a <myproc>
    8000512e:	fdc42703          	lw	a4,-36(s0)
    80005132:	01a70793          	addi	a5,a4,26
    80005136:	078e                	slli	a5,a5,0x3
    80005138:	953e                	add	a0,a0,a5
    8000513a:	611c                	ld	a5,0(a0)
    8000513c:	c385                	beqz	a5,8000515c <argfd+0x5c>
    return -1;
  if(pfd)
    8000513e:	00090463          	beqz	s2,80005146 <argfd+0x46>
    *pfd = fd;
    80005142:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005146:	4501                	li	a0,0
  if(pf)
    80005148:	c091                	beqz	s1,8000514c <argfd+0x4c>
    *pf = f;
    8000514a:	e09c                	sd	a5,0(s1)
}
    8000514c:	70a2                	ld	ra,40(sp)
    8000514e:	7402                	ld	s0,32(sp)
    80005150:	64e2                	ld	s1,24(sp)
    80005152:	6942                	ld	s2,16(sp)
    80005154:	6145                	addi	sp,sp,48
    80005156:	8082                	ret
    return -1;
    80005158:	557d                	li	a0,-1
    8000515a:	bfcd                	j	8000514c <argfd+0x4c>
    8000515c:	557d                	li	a0,-1
    8000515e:	b7fd                	j	8000514c <argfd+0x4c>

0000000080005160 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80005160:	1101                	addi	sp,sp,-32
    80005162:	ec06                	sd	ra,24(sp)
    80005164:	e822                	sd	s0,16(sp)
    80005166:	e426                	sd	s1,8(sp)
    80005168:	1000                	addi	s0,sp,32
    8000516a:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000516c:	ffffd097          	auipc	ra,0xffffd
    80005170:	8ce080e7          	jalr	-1842(ra) # 80001a3a <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(p->ofile[fd] == 0){
    80005174:	697c                	ld	a5,208(a0)
    80005176:	c395                	beqz	a5,8000519a <fdalloc+0x3a>
    80005178:	0d850713          	addi	a4,a0,216
  for(fd = 0; fd < NOFILE; fd++){
    8000517c:	4785                	li	a5,1
    8000517e:	4641                	li	a2,16
    if(p->ofile[fd] == 0){
    80005180:	6314                	ld	a3,0(a4)
    80005182:	ce89                	beqz	a3,8000519c <fdalloc+0x3c>
  for(fd = 0; fd < NOFILE; fd++){
    80005184:	2785                	addiw	a5,a5,1
    80005186:	0721                	addi	a4,a4,8
    80005188:	fec79ce3          	bne	a5,a2,80005180 <fdalloc+0x20>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000518c:	57fd                	li	a5,-1
}
    8000518e:	853e                	mv	a0,a5
    80005190:	60e2                	ld	ra,24(sp)
    80005192:	6442                	ld	s0,16(sp)
    80005194:	64a2                	ld	s1,8(sp)
    80005196:	6105                	addi	sp,sp,32
    80005198:	8082                	ret
  for(fd = 0; fd < NOFILE; fd++){
    8000519a:	4781                	li	a5,0
      p->ofile[fd] = f;
    8000519c:	01a78713          	addi	a4,a5,26
    800051a0:	070e                	slli	a4,a4,0x3
    800051a2:	953a                	add	a0,a0,a4
    800051a4:	e104                	sd	s1,0(a0)
      return fd;
    800051a6:	b7e5                	j	8000518e <fdalloc+0x2e>

00000000800051a8 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800051a8:	715d                	addi	sp,sp,-80
    800051aa:	e486                	sd	ra,72(sp)
    800051ac:	e0a2                	sd	s0,64(sp)
    800051ae:	fc26                	sd	s1,56(sp)
    800051b0:	f84a                	sd	s2,48(sp)
    800051b2:	f44e                	sd	s3,40(sp)
    800051b4:	f052                	sd	s4,32(sp)
    800051b6:	ec56                	sd	s5,24(sp)
    800051b8:	e85a                	sd	s6,16(sp)
    800051ba:	0880                	addi	s0,sp,80
    800051bc:	89ae                	mv	s3,a1
    800051be:	8b32                	mv	s6,a2
    800051c0:	8ab6                	mv	s5,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800051c2:	fb040593          	addi	a1,s0,-80
    800051c6:	fffff097          	auipc	ra,0xfffff
    800051ca:	df6080e7          	jalr	-522(ra) # 80003fbc <nameiparent>
    800051ce:	84aa                	mv	s1,a0
    800051d0:	14050e63          	beqz	a0,8000532c <create+0x184>
    return 0;

  ilock(dp);
    800051d4:	ffffe097          	auipc	ra,0xffffe
    800051d8:	618080e7          	jalr	1560(ra) # 800037ec <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800051dc:	4601                	li	a2,0
    800051de:	fb040593          	addi	a1,s0,-80
    800051e2:	8526                	mv	a0,s1
    800051e4:	fffff097          	auipc	ra,0xfffff
    800051e8:	aee080e7          	jalr	-1298(ra) # 80003cd2 <dirlookup>
    800051ec:	892a                	mv	s2,a0
    800051ee:	c929                	beqz	a0,80005240 <create+0x98>
    iunlockput(dp);
    800051f0:	8526                	mv	a0,s1
    800051f2:	fffff097          	auipc	ra,0xfffff
    800051f6:	85e080e7          	jalr	-1954(ra) # 80003a50 <iunlockput>
    ilock(ip);
    800051fa:	854a                	mv	a0,s2
    800051fc:	ffffe097          	auipc	ra,0xffffe
    80005200:	5f0080e7          	jalr	1520(ra) # 800037ec <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005204:	2981                	sext.w	s3,s3
    80005206:	4789                	li	a5,2
    80005208:	02f99563          	bne	s3,a5,80005232 <create+0x8a>
    8000520c:	04495783          	lhu	a5,68(s2)
    80005210:	37f9                	addiw	a5,a5,-2
    80005212:	17c2                	slli	a5,a5,0x30
    80005214:	93c1                	srli	a5,a5,0x30
    80005216:	4705                	li	a4,1
    80005218:	00f76d63          	bltu	a4,a5,80005232 <create+0x8a>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    8000521c:	854a                	mv	a0,s2
    8000521e:	60a6                	ld	ra,72(sp)
    80005220:	6406                	ld	s0,64(sp)
    80005222:	74e2                	ld	s1,56(sp)
    80005224:	7942                	ld	s2,48(sp)
    80005226:	79a2                	ld	s3,40(sp)
    80005228:	7a02                	ld	s4,32(sp)
    8000522a:	6ae2                	ld	s5,24(sp)
    8000522c:	6b42                	ld	s6,16(sp)
    8000522e:	6161                	addi	sp,sp,80
    80005230:	8082                	ret
    iunlockput(ip);
    80005232:	854a                	mv	a0,s2
    80005234:	fffff097          	auipc	ra,0xfffff
    80005238:	81c080e7          	jalr	-2020(ra) # 80003a50 <iunlockput>
    return 0;
    8000523c:	4901                	li	s2,0
    8000523e:	bff9                	j	8000521c <create+0x74>
  if((ip = ialloc(dp->dev, type)) == 0){
    80005240:	85ce                	mv	a1,s3
    80005242:	4088                	lw	a0,0(s1)
    80005244:	ffffe097          	auipc	ra,0xffffe
    80005248:	408080e7          	jalr	1032(ra) # 8000364c <ialloc>
    8000524c:	8a2a                	mv	s4,a0
    8000524e:	c539                	beqz	a0,8000529c <create+0xf4>
  ilock(ip);
    80005250:	ffffe097          	auipc	ra,0xffffe
    80005254:	59c080e7          	jalr	1436(ra) # 800037ec <ilock>
  ip->major = major;
    80005258:	056a1323          	sh	s6,70(s4)
  ip->minor = minor;
    8000525c:	055a1423          	sh	s5,72(s4)
  ip->nlink = 1;
    80005260:	4785                	li	a5,1
    80005262:	04fa1523          	sh	a5,74(s4)
  iupdate(ip);
    80005266:	8552                	mv	a0,s4
    80005268:	ffffe097          	auipc	ra,0xffffe
    8000526c:	4b8080e7          	jalr	1208(ra) # 80003720 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005270:	2981                	sext.w	s3,s3
    80005272:	4785                	li	a5,1
    80005274:	02f98b63          	beq	s3,a5,800052aa <create+0x102>
  if(dirlink(dp, name, ip->inum) < 0)
    80005278:	004a2603          	lw	a2,4(s4)
    8000527c:	fb040593          	addi	a1,s0,-80
    80005280:	8526                	mv	a0,s1
    80005282:	fffff097          	auipc	ra,0xfffff
    80005286:	c68080e7          	jalr	-920(ra) # 80003eea <dirlink>
    8000528a:	06054f63          	bltz	a0,80005308 <create+0x160>
  iunlockput(dp);
    8000528e:	8526                	mv	a0,s1
    80005290:	ffffe097          	auipc	ra,0xffffe
    80005294:	7c0080e7          	jalr	1984(ra) # 80003a50 <iunlockput>
  return ip;
    80005298:	8952                	mv	s2,s4
    8000529a:	b749                	j	8000521c <create+0x74>
    iunlockput(dp);
    8000529c:	8526                	mv	a0,s1
    8000529e:	ffffe097          	auipc	ra,0xffffe
    800052a2:	7b2080e7          	jalr	1970(ra) # 80003a50 <iunlockput>
    return 0;
    800052a6:	8952                	mv	s2,s4
    800052a8:	bf95                	j	8000521c <create+0x74>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800052aa:	004a2603          	lw	a2,4(s4)
    800052ae:	00003597          	auipc	a1,0x3
    800052b2:	48258593          	addi	a1,a1,1154 # 80008730 <syscalls+0x2c8>
    800052b6:	8552                	mv	a0,s4
    800052b8:	fffff097          	auipc	ra,0xfffff
    800052bc:	c32080e7          	jalr	-974(ra) # 80003eea <dirlink>
    800052c0:	04054463          	bltz	a0,80005308 <create+0x160>
    800052c4:	40d0                	lw	a2,4(s1)
    800052c6:	00003597          	auipc	a1,0x3
    800052ca:	47258593          	addi	a1,a1,1138 # 80008738 <syscalls+0x2d0>
    800052ce:	8552                	mv	a0,s4
    800052d0:	fffff097          	auipc	ra,0xfffff
    800052d4:	c1a080e7          	jalr	-998(ra) # 80003eea <dirlink>
    800052d8:	02054863          	bltz	a0,80005308 <create+0x160>
  if(dirlink(dp, name, ip->inum) < 0)
    800052dc:	004a2603          	lw	a2,4(s4)
    800052e0:	fb040593          	addi	a1,s0,-80
    800052e4:	8526                	mv	a0,s1
    800052e6:	fffff097          	auipc	ra,0xfffff
    800052ea:	c04080e7          	jalr	-1020(ra) # 80003eea <dirlink>
    800052ee:	00054d63          	bltz	a0,80005308 <create+0x160>
    dp->nlink++;  // for ".."
    800052f2:	04a4d783          	lhu	a5,74(s1)
    800052f6:	2785                	addiw	a5,a5,1
    800052f8:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800052fc:	8526                	mv	a0,s1
    800052fe:	ffffe097          	auipc	ra,0xffffe
    80005302:	422080e7          	jalr	1058(ra) # 80003720 <iupdate>
    80005306:	b761                	j	8000528e <create+0xe6>
  ip->nlink = 0;
    80005308:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    8000530c:	8552                	mv	a0,s4
    8000530e:	ffffe097          	auipc	ra,0xffffe
    80005312:	412080e7          	jalr	1042(ra) # 80003720 <iupdate>
  iunlockput(ip);
    80005316:	8552                	mv	a0,s4
    80005318:	ffffe097          	auipc	ra,0xffffe
    8000531c:	738080e7          	jalr	1848(ra) # 80003a50 <iunlockput>
  iunlockput(dp);
    80005320:	8526                	mv	a0,s1
    80005322:	ffffe097          	auipc	ra,0xffffe
    80005326:	72e080e7          	jalr	1838(ra) # 80003a50 <iunlockput>
  return 0;
    8000532a:	bdcd                	j	8000521c <create+0x74>
    return 0;
    8000532c:	892a                	mv	s2,a0
    8000532e:	b5fd                	j	8000521c <create+0x74>

0000000080005330 <sys_dup>:
{
    80005330:	7179                	addi	sp,sp,-48
    80005332:	f406                	sd	ra,40(sp)
    80005334:	f022                	sd	s0,32(sp)
    80005336:	ec26                	sd	s1,24(sp)
    80005338:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000533a:	fd840613          	addi	a2,s0,-40
    8000533e:	4581                	li	a1,0
    80005340:	4501                	li	a0,0
    80005342:	00000097          	auipc	ra,0x0
    80005346:	dbe080e7          	jalr	-578(ra) # 80005100 <argfd>
    return -1;
    8000534a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000534c:	02054363          	bltz	a0,80005372 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80005350:	fd843503          	ld	a0,-40(s0)
    80005354:	00000097          	auipc	ra,0x0
    80005358:	e0c080e7          	jalr	-500(ra) # 80005160 <fdalloc>
    8000535c:	84aa                	mv	s1,a0
    return -1;
    8000535e:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005360:	00054963          	bltz	a0,80005372 <sys_dup+0x42>
  filedup(f);
    80005364:	fd843503          	ld	a0,-40(s0)
    80005368:	fffff097          	auipc	ra,0xfffff
    8000536c:	2fc080e7          	jalr	764(ra) # 80004664 <filedup>
  return fd;
    80005370:	87a6                	mv	a5,s1
}
    80005372:	853e                	mv	a0,a5
    80005374:	70a2                	ld	ra,40(sp)
    80005376:	7402                	ld	s0,32(sp)
    80005378:	64e2                	ld	s1,24(sp)
    8000537a:	6145                	addi	sp,sp,48
    8000537c:	8082                	ret

000000008000537e <sys_read>:
{
    8000537e:	7179                	addi	sp,sp,-48
    80005380:	f406                	sd	ra,40(sp)
    80005382:	f022                	sd	s0,32(sp)
    80005384:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005386:	fd840593          	addi	a1,s0,-40
    8000538a:	4505                	li	a0,1
    8000538c:	ffffe097          	auipc	ra,0xffffe
    80005390:	8bc080e7          	jalr	-1860(ra) # 80002c48 <argaddr>
  argint(2, &n);
    80005394:	fe440593          	addi	a1,s0,-28
    80005398:	4509                	li	a0,2
    8000539a:	ffffe097          	auipc	ra,0xffffe
    8000539e:	88e080e7          	jalr	-1906(ra) # 80002c28 <argint>
  if(argfd(0, 0, &f) < 0)
    800053a2:	fe840613          	addi	a2,s0,-24
    800053a6:	4581                	li	a1,0
    800053a8:	4501                	li	a0,0
    800053aa:	00000097          	auipc	ra,0x0
    800053ae:	d56080e7          	jalr	-682(ra) # 80005100 <argfd>
    return -1;
    800053b2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800053b4:	00054d63          	bltz	a0,800053ce <sys_read+0x50>
  return fileread(f, p, n);
    800053b8:	fe442603          	lw	a2,-28(s0)
    800053bc:	fd843583          	ld	a1,-40(s0)
    800053c0:	fe843503          	ld	a0,-24(s0)
    800053c4:	fffff097          	auipc	ra,0xfffff
    800053c8:	42c080e7          	jalr	1068(ra) # 800047f0 <fileread>
    800053cc:	87aa                	mv	a5,a0
}
    800053ce:	853e                	mv	a0,a5
    800053d0:	70a2                	ld	ra,40(sp)
    800053d2:	7402                	ld	s0,32(sp)
    800053d4:	6145                	addi	sp,sp,48
    800053d6:	8082                	ret

00000000800053d8 <sys_write>:
{
    800053d8:	7179                	addi	sp,sp,-48
    800053da:	f406                	sd	ra,40(sp)
    800053dc:	f022                	sd	s0,32(sp)
    800053de:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800053e0:	fd840593          	addi	a1,s0,-40
    800053e4:	4505                	li	a0,1
    800053e6:	ffffe097          	auipc	ra,0xffffe
    800053ea:	862080e7          	jalr	-1950(ra) # 80002c48 <argaddr>
  argint(2, &n);
    800053ee:	fe440593          	addi	a1,s0,-28
    800053f2:	4509                	li	a0,2
    800053f4:	ffffe097          	auipc	ra,0xffffe
    800053f8:	834080e7          	jalr	-1996(ra) # 80002c28 <argint>
  if(argfd(0, 0, &f) < 0)
    800053fc:	fe840613          	addi	a2,s0,-24
    80005400:	4581                	li	a1,0
    80005402:	4501                	li	a0,0
    80005404:	00000097          	auipc	ra,0x0
    80005408:	cfc080e7          	jalr	-772(ra) # 80005100 <argfd>
    return -1;
    8000540c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000540e:	00054d63          	bltz	a0,80005428 <sys_write+0x50>
  return filewrite(f, p, n);
    80005412:	fe442603          	lw	a2,-28(s0)
    80005416:	fd843583          	ld	a1,-40(s0)
    8000541a:	fe843503          	ld	a0,-24(s0)
    8000541e:	fffff097          	auipc	ra,0xfffff
    80005422:	494080e7          	jalr	1172(ra) # 800048b2 <filewrite>
    80005426:	87aa                	mv	a5,a0
}
    80005428:	853e                	mv	a0,a5
    8000542a:	70a2                	ld	ra,40(sp)
    8000542c:	7402                	ld	s0,32(sp)
    8000542e:	6145                	addi	sp,sp,48
    80005430:	8082                	ret

0000000080005432 <sys_close>:
{
    80005432:	1101                	addi	sp,sp,-32
    80005434:	ec06                	sd	ra,24(sp)
    80005436:	e822                	sd	s0,16(sp)
    80005438:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000543a:	fe040613          	addi	a2,s0,-32
    8000543e:	fec40593          	addi	a1,s0,-20
    80005442:	4501                	li	a0,0
    80005444:	00000097          	auipc	ra,0x0
    80005448:	cbc080e7          	jalr	-836(ra) # 80005100 <argfd>
    return -1;
    8000544c:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000544e:	02054463          	bltz	a0,80005476 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80005452:	ffffc097          	auipc	ra,0xffffc
    80005456:	5e8080e7          	jalr	1512(ra) # 80001a3a <myproc>
    8000545a:	fec42783          	lw	a5,-20(s0)
    8000545e:	07e9                	addi	a5,a5,26
    80005460:	078e                	slli	a5,a5,0x3
    80005462:	953e                	add	a0,a0,a5
    80005464:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80005468:	fe043503          	ld	a0,-32(s0)
    8000546c:	fffff097          	auipc	ra,0xfffff
    80005470:	24a080e7          	jalr	586(ra) # 800046b6 <fileclose>
  return 0;
    80005474:	4781                	li	a5,0
}
    80005476:	853e                	mv	a0,a5
    80005478:	60e2                	ld	ra,24(sp)
    8000547a:	6442                	ld	s0,16(sp)
    8000547c:	6105                	addi	sp,sp,32
    8000547e:	8082                	ret

0000000080005480 <sys_fstat>:
{
    80005480:	1101                	addi	sp,sp,-32
    80005482:	ec06                	sd	ra,24(sp)
    80005484:	e822                	sd	s0,16(sp)
    80005486:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80005488:	fe040593          	addi	a1,s0,-32
    8000548c:	4505                	li	a0,1
    8000548e:	ffffd097          	auipc	ra,0xffffd
    80005492:	7ba080e7          	jalr	1978(ra) # 80002c48 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80005496:	fe840613          	addi	a2,s0,-24
    8000549a:	4581                	li	a1,0
    8000549c:	4501                	li	a0,0
    8000549e:	00000097          	auipc	ra,0x0
    800054a2:	c62080e7          	jalr	-926(ra) # 80005100 <argfd>
    return -1;
    800054a6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800054a8:	00054b63          	bltz	a0,800054be <sys_fstat+0x3e>
  return filestat(f, st);
    800054ac:	fe043583          	ld	a1,-32(s0)
    800054b0:	fe843503          	ld	a0,-24(s0)
    800054b4:	fffff097          	auipc	ra,0xfffff
    800054b8:	2ca080e7          	jalr	714(ra) # 8000477e <filestat>
    800054bc:	87aa                	mv	a5,a0
}
    800054be:	853e                	mv	a0,a5
    800054c0:	60e2                	ld	ra,24(sp)
    800054c2:	6442                	ld	s0,16(sp)
    800054c4:	6105                	addi	sp,sp,32
    800054c6:	8082                	ret

00000000800054c8 <sys_link>:
{
    800054c8:	7169                	addi	sp,sp,-304
    800054ca:	f606                	sd	ra,296(sp)
    800054cc:	f222                	sd	s0,288(sp)
    800054ce:	ee26                	sd	s1,280(sp)
    800054d0:	ea4a                	sd	s2,272(sp)
    800054d2:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800054d4:	08000613          	li	a2,128
    800054d8:	ed040593          	addi	a1,s0,-304
    800054dc:	4501                	li	a0,0
    800054de:	ffffd097          	auipc	ra,0xffffd
    800054e2:	78a080e7          	jalr	1930(ra) # 80002c68 <argstr>
    return -1;
    800054e6:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800054e8:	10054e63          	bltz	a0,80005604 <sys_link+0x13c>
    800054ec:	08000613          	li	a2,128
    800054f0:	f5040593          	addi	a1,s0,-176
    800054f4:	4505                	li	a0,1
    800054f6:	ffffd097          	auipc	ra,0xffffd
    800054fa:	772080e7          	jalr	1906(ra) # 80002c68 <argstr>
    return -1;
    800054fe:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005500:	10054263          	bltz	a0,80005604 <sys_link+0x13c>
  begin_op();
    80005504:	fffff097          	auipc	ra,0xfffff
    80005508:	cb8080e7          	jalr	-840(ra) # 800041bc <begin_op>
  if((ip = namei(old)) == 0){
    8000550c:	ed040513          	addi	a0,s0,-304
    80005510:	fffff097          	auipc	ra,0xfffff
    80005514:	a8e080e7          	jalr	-1394(ra) # 80003f9e <namei>
    80005518:	84aa                	mv	s1,a0
    8000551a:	c551                	beqz	a0,800055a6 <sys_link+0xde>
  ilock(ip);
    8000551c:	ffffe097          	auipc	ra,0xffffe
    80005520:	2d0080e7          	jalr	720(ra) # 800037ec <ilock>
  if(ip->type == T_DIR){
    80005524:	04449703          	lh	a4,68(s1)
    80005528:	4785                	li	a5,1
    8000552a:	08f70463          	beq	a4,a5,800055b2 <sys_link+0xea>
  ip->nlink++;
    8000552e:	04a4d783          	lhu	a5,74(s1)
    80005532:	2785                	addiw	a5,a5,1
    80005534:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005538:	8526                	mv	a0,s1
    8000553a:	ffffe097          	auipc	ra,0xffffe
    8000553e:	1e6080e7          	jalr	486(ra) # 80003720 <iupdate>
  iunlock(ip);
    80005542:	8526                	mv	a0,s1
    80005544:	ffffe097          	auipc	ra,0xffffe
    80005548:	36c080e7          	jalr	876(ra) # 800038b0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000554c:	fd040593          	addi	a1,s0,-48
    80005550:	f5040513          	addi	a0,s0,-176
    80005554:	fffff097          	auipc	ra,0xfffff
    80005558:	a68080e7          	jalr	-1432(ra) # 80003fbc <nameiparent>
    8000555c:	892a                	mv	s2,a0
    8000555e:	c935                	beqz	a0,800055d2 <sys_link+0x10a>
  ilock(dp);
    80005560:	ffffe097          	auipc	ra,0xffffe
    80005564:	28c080e7          	jalr	652(ra) # 800037ec <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005568:	00092703          	lw	a4,0(s2)
    8000556c:	409c                	lw	a5,0(s1)
    8000556e:	04f71d63          	bne	a4,a5,800055c8 <sys_link+0x100>
    80005572:	40d0                	lw	a2,4(s1)
    80005574:	fd040593          	addi	a1,s0,-48
    80005578:	854a                	mv	a0,s2
    8000557a:	fffff097          	auipc	ra,0xfffff
    8000557e:	970080e7          	jalr	-1680(ra) # 80003eea <dirlink>
    80005582:	04054363          	bltz	a0,800055c8 <sys_link+0x100>
  iunlockput(dp);
    80005586:	854a                	mv	a0,s2
    80005588:	ffffe097          	auipc	ra,0xffffe
    8000558c:	4c8080e7          	jalr	1224(ra) # 80003a50 <iunlockput>
  iput(ip);
    80005590:	8526                	mv	a0,s1
    80005592:	ffffe097          	auipc	ra,0xffffe
    80005596:	416080e7          	jalr	1046(ra) # 800039a8 <iput>
  end_op();
    8000559a:	fffff097          	auipc	ra,0xfffff
    8000559e:	ca2080e7          	jalr	-862(ra) # 8000423c <end_op>
  return 0;
    800055a2:	4781                	li	a5,0
    800055a4:	a085                	j	80005604 <sys_link+0x13c>
    end_op();
    800055a6:	fffff097          	auipc	ra,0xfffff
    800055aa:	c96080e7          	jalr	-874(ra) # 8000423c <end_op>
    return -1;
    800055ae:	57fd                	li	a5,-1
    800055b0:	a891                	j	80005604 <sys_link+0x13c>
    iunlockput(ip);
    800055b2:	8526                	mv	a0,s1
    800055b4:	ffffe097          	auipc	ra,0xffffe
    800055b8:	49c080e7          	jalr	1180(ra) # 80003a50 <iunlockput>
    end_op();
    800055bc:	fffff097          	auipc	ra,0xfffff
    800055c0:	c80080e7          	jalr	-896(ra) # 8000423c <end_op>
    return -1;
    800055c4:	57fd                	li	a5,-1
    800055c6:	a83d                	j	80005604 <sys_link+0x13c>
    iunlockput(dp);
    800055c8:	854a                	mv	a0,s2
    800055ca:	ffffe097          	auipc	ra,0xffffe
    800055ce:	486080e7          	jalr	1158(ra) # 80003a50 <iunlockput>
  ilock(ip);
    800055d2:	8526                	mv	a0,s1
    800055d4:	ffffe097          	auipc	ra,0xffffe
    800055d8:	218080e7          	jalr	536(ra) # 800037ec <ilock>
  ip->nlink--;
    800055dc:	04a4d783          	lhu	a5,74(s1)
    800055e0:	37fd                	addiw	a5,a5,-1
    800055e2:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800055e6:	8526                	mv	a0,s1
    800055e8:	ffffe097          	auipc	ra,0xffffe
    800055ec:	138080e7          	jalr	312(ra) # 80003720 <iupdate>
  iunlockput(ip);
    800055f0:	8526                	mv	a0,s1
    800055f2:	ffffe097          	auipc	ra,0xffffe
    800055f6:	45e080e7          	jalr	1118(ra) # 80003a50 <iunlockput>
  end_op();
    800055fa:	fffff097          	auipc	ra,0xfffff
    800055fe:	c42080e7          	jalr	-958(ra) # 8000423c <end_op>
  return -1;
    80005602:	57fd                	li	a5,-1
}
    80005604:	853e                	mv	a0,a5
    80005606:	70b2                	ld	ra,296(sp)
    80005608:	7412                	ld	s0,288(sp)
    8000560a:	64f2                	ld	s1,280(sp)
    8000560c:	6952                	ld	s2,272(sp)
    8000560e:	6155                	addi	sp,sp,304
    80005610:	8082                	ret

0000000080005612 <sys_unlink>:
{
    80005612:	7151                	addi	sp,sp,-240
    80005614:	f586                	sd	ra,232(sp)
    80005616:	f1a2                	sd	s0,224(sp)
    80005618:	eda6                	sd	s1,216(sp)
    8000561a:	e9ca                	sd	s2,208(sp)
    8000561c:	e5ce                	sd	s3,200(sp)
    8000561e:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005620:	08000613          	li	a2,128
    80005624:	f3040593          	addi	a1,s0,-208
    80005628:	4501                	li	a0,0
    8000562a:	ffffd097          	auipc	ra,0xffffd
    8000562e:	63e080e7          	jalr	1598(ra) # 80002c68 <argstr>
    80005632:	16054f63          	bltz	a0,800057b0 <sys_unlink+0x19e>
  begin_op();
    80005636:	fffff097          	auipc	ra,0xfffff
    8000563a:	b86080e7          	jalr	-1146(ra) # 800041bc <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000563e:	fb040593          	addi	a1,s0,-80
    80005642:	f3040513          	addi	a0,s0,-208
    80005646:	fffff097          	auipc	ra,0xfffff
    8000564a:	976080e7          	jalr	-1674(ra) # 80003fbc <nameiparent>
    8000564e:	89aa                	mv	s3,a0
    80005650:	c979                	beqz	a0,80005726 <sys_unlink+0x114>
  ilock(dp);
    80005652:	ffffe097          	auipc	ra,0xffffe
    80005656:	19a080e7          	jalr	410(ra) # 800037ec <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000565a:	00003597          	auipc	a1,0x3
    8000565e:	0d658593          	addi	a1,a1,214 # 80008730 <syscalls+0x2c8>
    80005662:	fb040513          	addi	a0,s0,-80
    80005666:	ffffe097          	auipc	ra,0xffffe
    8000566a:	652080e7          	jalr	1618(ra) # 80003cb8 <namecmp>
    8000566e:	14050863          	beqz	a0,800057be <sys_unlink+0x1ac>
    80005672:	00003597          	auipc	a1,0x3
    80005676:	0c658593          	addi	a1,a1,198 # 80008738 <syscalls+0x2d0>
    8000567a:	fb040513          	addi	a0,s0,-80
    8000567e:	ffffe097          	auipc	ra,0xffffe
    80005682:	63a080e7          	jalr	1594(ra) # 80003cb8 <namecmp>
    80005686:	12050c63          	beqz	a0,800057be <sys_unlink+0x1ac>
  if((ip = dirlookup(dp, name, &off)) == 0)
    8000568a:	f2c40613          	addi	a2,s0,-212
    8000568e:	fb040593          	addi	a1,s0,-80
    80005692:	854e                	mv	a0,s3
    80005694:	ffffe097          	auipc	ra,0xffffe
    80005698:	63e080e7          	jalr	1598(ra) # 80003cd2 <dirlookup>
    8000569c:	84aa                	mv	s1,a0
    8000569e:	12050063          	beqz	a0,800057be <sys_unlink+0x1ac>
  ilock(ip);
    800056a2:	ffffe097          	auipc	ra,0xffffe
    800056a6:	14a080e7          	jalr	330(ra) # 800037ec <ilock>
  if(ip->nlink < 1)
    800056aa:	04a49783          	lh	a5,74(s1)
    800056ae:	08f05263          	blez	a5,80005732 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800056b2:	04449703          	lh	a4,68(s1)
    800056b6:	4785                	li	a5,1
    800056b8:	08f70563          	beq	a4,a5,80005742 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    800056bc:	4641                	li	a2,16
    800056be:	4581                	li	a1,0
    800056c0:	fc040513          	addi	a0,s0,-64
    800056c4:	ffffb097          	auipc	ra,0xffffb
    800056c8:	670080e7          	jalr	1648(ra) # 80000d34 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800056cc:	4741                	li	a4,16
    800056ce:	f2c42683          	lw	a3,-212(s0)
    800056d2:	fc040613          	addi	a2,s0,-64
    800056d6:	4581                	li	a1,0
    800056d8:	854e                	mv	a0,s3
    800056da:	ffffe097          	auipc	ra,0xffffe
    800056de:	4c0080e7          	jalr	1216(ra) # 80003b9a <writei>
    800056e2:	47c1                	li	a5,16
    800056e4:	0af51363          	bne	a0,a5,8000578a <sys_unlink+0x178>
  if(ip->type == T_DIR){
    800056e8:	04449703          	lh	a4,68(s1)
    800056ec:	4785                	li	a5,1
    800056ee:	0af70663          	beq	a4,a5,8000579a <sys_unlink+0x188>
  iunlockput(dp);
    800056f2:	854e                	mv	a0,s3
    800056f4:	ffffe097          	auipc	ra,0xffffe
    800056f8:	35c080e7          	jalr	860(ra) # 80003a50 <iunlockput>
  ip->nlink--;
    800056fc:	04a4d783          	lhu	a5,74(s1)
    80005700:	37fd                	addiw	a5,a5,-1
    80005702:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005706:	8526                	mv	a0,s1
    80005708:	ffffe097          	auipc	ra,0xffffe
    8000570c:	018080e7          	jalr	24(ra) # 80003720 <iupdate>
  iunlockput(ip);
    80005710:	8526                	mv	a0,s1
    80005712:	ffffe097          	auipc	ra,0xffffe
    80005716:	33e080e7          	jalr	830(ra) # 80003a50 <iunlockput>
  end_op();
    8000571a:	fffff097          	auipc	ra,0xfffff
    8000571e:	b22080e7          	jalr	-1246(ra) # 8000423c <end_op>
  return 0;
    80005722:	4501                	li	a0,0
    80005724:	a07d                	j	800057d2 <sys_unlink+0x1c0>
    end_op();
    80005726:	fffff097          	auipc	ra,0xfffff
    8000572a:	b16080e7          	jalr	-1258(ra) # 8000423c <end_op>
    return -1;
    8000572e:	557d                	li	a0,-1
    80005730:	a04d                	j	800057d2 <sys_unlink+0x1c0>
    panic("unlink: nlink < 1");
    80005732:	00003517          	auipc	a0,0x3
    80005736:	00e50513          	addi	a0,a0,14 # 80008740 <syscalls+0x2d8>
    8000573a:	ffffb097          	auipc	ra,0xffffb
    8000573e:	e32080e7          	jalr	-462(ra) # 8000056c <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005742:	44f8                	lw	a4,76(s1)
    80005744:	02000793          	li	a5,32
    80005748:	f6e7fae3          	bgeu	a5,a4,800056bc <sys_unlink+0xaa>
    8000574c:	02000913          	li	s2,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005750:	4741                	li	a4,16
    80005752:	86ca                	mv	a3,s2
    80005754:	f1840613          	addi	a2,s0,-232
    80005758:	4581                	li	a1,0
    8000575a:	8526                	mv	a0,s1
    8000575c:	ffffe097          	auipc	ra,0xffffe
    80005760:	346080e7          	jalr	838(ra) # 80003aa2 <readi>
    80005764:	47c1                	li	a5,16
    80005766:	00f51a63          	bne	a0,a5,8000577a <sys_unlink+0x168>
    if(de.inum != 0)
    8000576a:	f1845783          	lhu	a5,-232(s0)
    8000576e:	e3b9                	bnez	a5,800057b4 <sys_unlink+0x1a2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005770:	2941                	addiw	s2,s2,16
    80005772:	44fc                	lw	a5,76(s1)
    80005774:	fcf96ee3          	bltu	s2,a5,80005750 <sys_unlink+0x13e>
    80005778:	b791                	j	800056bc <sys_unlink+0xaa>
      panic("isdirempty: readi");
    8000577a:	00003517          	auipc	a0,0x3
    8000577e:	fde50513          	addi	a0,a0,-34 # 80008758 <syscalls+0x2f0>
    80005782:	ffffb097          	auipc	ra,0xffffb
    80005786:	dea080e7          	jalr	-534(ra) # 8000056c <panic>
    panic("unlink: writei");
    8000578a:	00003517          	auipc	a0,0x3
    8000578e:	fe650513          	addi	a0,a0,-26 # 80008770 <syscalls+0x308>
    80005792:	ffffb097          	auipc	ra,0xffffb
    80005796:	dda080e7          	jalr	-550(ra) # 8000056c <panic>
    dp->nlink--;
    8000579a:	04a9d783          	lhu	a5,74(s3)
    8000579e:	37fd                	addiw	a5,a5,-1
    800057a0:	04f99523          	sh	a5,74(s3)
    iupdate(dp);
    800057a4:	854e                	mv	a0,s3
    800057a6:	ffffe097          	auipc	ra,0xffffe
    800057aa:	f7a080e7          	jalr	-134(ra) # 80003720 <iupdate>
    800057ae:	b791                	j	800056f2 <sys_unlink+0xe0>
    return -1;
    800057b0:	557d                	li	a0,-1
    800057b2:	a005                	j	800057d2 <sys_unlink+0x1c0>
    iunlockput(ip);
    800057b4:	8526                	mv	a0,s1
    800057b6:	ffffe097          	auipc	ra,0xffffe
    800057ba:	29a080e7          	jalr	666(ra) # 80003a50 <iunlockput>
  iunlockput(dp);
    800057be:	854e                	mv	a0,s3
    800057c0:	ffffe097          	auipc	ra,0xffffe
    800057c4:	290080e7          	jalr	656(ra) # 80003a50 <iunlockput>
  end_op();
    800057c8:	fffff097          	auipc	ra,0xfffff
    800057cc:	a74080e7          	jalr	-1420(ra) # 8000423c <end_op>
  return -1;
    800057d0:	557d                	li	a0,-1
}
    800057d2:	70ae                	ld	ra,232(sp)
    800057d4:	740e                	ld	s0,224(sp)
    800057d6:	64ee                	ld	s1,216(sp)
    800057d8:	694e                	ld	s2,208(sp)
    800057da:	69ae                	ld	s3,200(sp)
    800057dc:	616d                	addi	sp,sp,240
    800057de:	8082                	ret

00000000800057e0 <sys_open>:

uint64
sys_open(void)
{
    800057e0:	7131                	addi	sp,sp,-192
    800057e2:	fd06                	sd	ra,184(sp)
    800057e4:	f922                	sd	s0,176(sp)
    800057e6:	f526                	sd	s1,168(sp)
    800057e8:	f14a                	sd	s2,160(sp)
    800057ea:	ed4e                	sd	s3,152(sp)
    800057ec:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800057ee:	f4c40593          	addi	a1,s0,-180
    800057f2:	4505                	li	a0,1
    800057f4:	ffffd097          	auipc	ra,0xffffd
    800057f8:	434080e7          	jalr	1076(ra) # 80002c28 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    800057fc:	08000613          	li	a2,128
    80005800:	f5040593          	addi	a1,s0,-176
    80005804:	4501                	li	a0,0
    80005806:	ffffd097          	auipc	ra,0xffffd
    8000580a:	462080e7          	jalr	1122(ra) # 80002c68 <argstr>
    return -1;
    8000580e:	597d                	li	s2,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005810:	0a054863          	bltz	a0,800058c0 <sys_open+0xe0>

  begin_op();
    80005814:	fffff097          	auipc	ra,0xfffff
    80005818:	9a8080e7          	jalr	-1624(ra) # 800041bc <begin_op>

  if(omode & O_CREATE){
    8000581c:	f4c42783          	lw	a5,-180(s0)
    80005820:	2007f793          	andi	a5,a5,512
    80005824:	cbdd                	beqz	a5,800058da <sys_open+0xfa>
    ip = create(path, T_FILE, 0, 0);
    80005826:	4681                	li	a3,0
    80005828:	4601                	li	a2,0
    8000582a:	4589                	li	a1,2
    8000582c:	f5040513          	addi	a0,s0,-176
    80005830:	00000097          	auipc	ra,0x0
    80005834:	978080e7          	jalr	-1672(ra) # 800051a8 <create>
    80005838:	84aa                	mv	s1,a0
    if(ip == 0){
    8000583a:	c959                	beqz	a0,800058d0 <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000583c:	04449703          	lh	a4,68(s1)
    80005840:	478d                	li	a5,3
    80005842:	00f71763          	bne	a4,a5,80005850 <sys_open+0x70>
    80005846:	0464d703          	lhu	a4,70(s1)
    8000584a:	47a5                	li	a5,9
    8000584c:	0ce7ec63          	bltu	a5,a4,80005924 <sys_open+0x144>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005850:	fffff097          	auipc	ra,0xfffff
    80005854:	d96080e7          	jalr	-618(ra) # 800045e6 <filealloc>
    80005858:	89aa                	mv	s3,a0
    8000585a:	10050263          	beqz	a0,8000595e <sys_open+0x17e>
    8000585e:	00000097          	auipc	ra,0x0
    80005862:	902080e7          	jalr	-1790(ra) # 80005160 <fdalloc>
    80005866:	892a                	mv	s2,a0
    80005868:	0e054663          	bltz	a0,80005954 <sys_open+0x174>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    8000586c:	04449703          	lh	a4,68(s1)
    80005870:	478d                	li	a5,3
    80005872:	0cf70463          	beq	a4,a5,8000593a <sys_open+0x15a>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005876:	4789                	li	a5,2
    80005878:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    8000587c:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005880:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005884:	f4c42783          	lw	a5,-180(s0)
    80005888:	0017c713          	xori	a4,a5,1
    8000588c:	8b05                	andi	a4,a4,1
    8000588e:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005892:	0037f713          	andi	a4,a5,3
    80005896:	00e03733          	snez	a4,a4
    8000589a:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    8000589e:	4007f793          	andi	a5,a5,1024
    800058a2:	c791                	beqz	a5,800058ae <sys_open+0xce>
    800058a4:	04449703          	lh	a4,68(s1)
    800058a8:	4789                	li	a5,2
    800058aa:	08f70f63          	beq	a4,a5,80005948 <sys_open+0x168>
    itrunc(ip);
  }

  iunlock(ip);
    800058ae:	8526                	mv	a0,s1
    800058b0:	ffffe097          	auipc	ra,0xffffe
    800058b4:	000080e7          	jalr	ra # 800038b0 <iunlock>
  end_op();
    800058b8:	fffff097          	auipc	ra,0xfffff
    800058bc:	984080e7          	jalr	-1660(ra) # 8000423c <end_op>

  return fd;
}
    800058c0:	854a                	mv	a0,s2
    800058c2:	70ea                	ld	ra,184(sp)
    800058c4:	744a                	ld	s0,176(sp)
    800058c6:	74aa                	ld	s1,168(sp)
    800058c8:	790a                	ld	s2,160(sp)
    800058ca:	69ea                	ld	s3,152(sp)
    800058cc:	6129                	addi	sp,sp,192
    800058ce:	8082                	ret
      end_op();
    800058d0:	fffff097          	auipc	ra,0xfffff
    800058d4:	96c080e7          	jalr	-1684(ra) # 8000423c <end_op>
      return -1;
    800058d8:	b7e5                	j	800058c0 <sys_open+0xe0>
    if((ip = namei(path)) == 0){
    800058da:	f5040513          	addi	a0,s0,-176
    800058de:	ffffe097          	auipc	ra,0xffffe
    800058e2:	6c0080e7          	jalr	1728(ra) # 80003f9e <namei>
    800058e6:	84aa                	mv	s1,a0
    800058e8:	c905                	beqz	a0,80005918 <sys_open+0x138>
    ilock(ip);
    800058ea:	ffffe097          	auipc	ra,0xffffe
    800058ee:	f02080e7          	jalr	-254(ra) # 800037ec <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800058f2:	04449703          	lh	a4,68(s1)
    800058f6:	4785                	li	a5,1
    800058f8:	f4f712e3          	bne	a4,a5,8000583c <sys_open+0x5c>
    800058fc:	f4c42783          	lw	a5,-180(s0)
    80005900:	dba1                	beqz	a5,80005850 <sys_open+0x70>
      iunlockput(ip);
    80005902:	8526                	mv	a0,s1
    80005904:	ffffe097          	auipc	ra,0xffffe
    80005908:	14c080e7          	jalr	332(ra) # 80003a50 <iunlockput>
      end_op();
    8000590c:	fffff097          	auipc	ra,0xfffff
    80005910:	930080e7          	jalr	-1744(ra) # 8000423c <end_op>
      return -1;
    80005914:	597d                	li	s2,-1
    80005916:	b76d                	j	800058c0 <sys_open+0xe0>
      end_op();
    80005918:	fffff097          	auipc	ra,0xfffff
    8000591c:	924080e7          	jalr	-1756(ra) # 8000423c <end_op>
      return -1;
    80005920:	597d                	li	s2,-1
    80005922:	bf79                	j	800058c0 <sys_open+0xe0>
    iunlockput(ip);
    80005924:	8526                	mv	a0,s1
    80005926:	ffffe097          	auipc	ra,0xffffe
    8000592a:	12a080e7          	jalr	298(ra) # 80003a50 <iunlockput>
    end_op();
    8000592e:	fffff097          	auipc	ra,0xfffff
    80005932:	90e080e7          	jalr	-1778(ra) # 8000423c <end_op>
    return -1;
    80005936:	597d                	li	s2,-1
    80005938:	b761                	j	800058c0 <sys_open+0xe0>
    f->type = FD_DEVICE;
    8000593a:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    8000593e:	04649783          	lh	a5,70(s1)
    80005942:	02f99223          	sh	a5,36(s3)
    80005946:	bf2d                	j	80005880 <sys_open+0xa0>
    itrunc(ip);
    80005948:	8526                	mv	a0,s1
    8000594a:	ffffe097          	auipc	ra,0xffffe
    8000594e:	fb2080e7          	jalr	-78(ra) # 800038fc <itrunc>
    80005952:	bfb1                	j	800058ae <sys_open+0xce>
      fileclose(f);
    80005954:	854e                	mv	a0,s3
    80005956:	fffff097          	auipc	ra,0xfffff
    8000595a:	d60080e7          	jalr	-672(ra) # 800046b6 <fileclose>
    iunlockput(ip);
    8000595e:	8526                	mv	a0,s1
    80005960:	ffffe097          	auipc	ra,0xffffe
    80005964:	0f0080e7          	jalr	240(ra) # 80003a50 <iunlockput>
    end_op();
    80005968:	fffff097          	auipc	ra,0xfffff
    8000596c:	8d4080e7          	jalr	-1836(ra) # 8000423c <end_op>
    return -1;
    80005970:	597d                	li	s2,-1
    80005972:	b7b9                	j	800058c0 <sys_open+0xe0>

0000000080005974 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005974:	7175                	addi	sp,sp,-144
    80005976:	e506                	sd	ra,136(sp)
    80005978:	e122                	sd	s0,128(sp)
    8000597a:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000597c:	fffff097          	auipc	ra,0xfffff
    80005980:	840080e7          	jalr	-1984(ra) # 800041bc <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005984:	08000613          	li	a2,128
    80005988:	f7040593          	addi	a1,s0,-144
    8000598c:	4501                	li	a0,0
    8000598e:	ffffd097          	auipc	ra,0xffffd
    80005992:	2da080e7          	jalr	730(ra) # 80002c68 <argstr>
    80005996:	02054963          	bltz	a0,800059c8 <sys_mkdir+0x54>
    8000599a:	4681                	li	a3,0
    8000599c:	4601                	li	a2,0
    8000599e:	4585                	li	a1,1
    800059a0:	f7040513          	addi	a0,s0,-144
    800059a4:	00000097          	auipc	ra,0x0
    800059a8:	804080e7          	jalr	-2044(ra) # 800051a8 <create>
    800059ac:	cd11                	beqz	a0,800059c8 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800059ae:	ffffe097          	auipc	ra,0xffffe
    800059b2:	0a2080e7          	jalr	162(ra) # 80003a50 <iunlockput>
  end_op();
    800059b6:	fffff097          	auipc	ra,0xfffff
    800059ba:	886080e7          	jalr	-1914(ra) # 8000423c <end_op>
  return 0;
    800059be:	4501                	li	a0,0
}
    800059c0:	60aa                	ld	ra,136(sp)
    800059c2:	640a                	ld	s0,128(sp)
    800059c4:	6149                	addi	sp,sp,144
    800059c6:	8082                	ret
    end_op();
    800059c8:	fffff097          	auipc	ra,0xfffff
    800059cc:	874080e7          	jalr	-1932(ra) # 8000423c <end_op>
    return -1;
    800059d0:	557d                	li	a0,-1
    800059d2:	b7fd                	j	800059c0 <sys_mkdir+0x4c>

00000000800059d4 <sys_mknod>:

uint64
sys_mknod(void)
{
    800059d4:	7135                	addi	sp,sp,-160
    800059d6:	ed06                	sd	ra,152(sp)
    800059d8:	e922                	sd	s0,144(sp)
    800059da:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800059dc:	ffffe097          	auipc	ra,0xffffe
    800059e0:	7e0080e7          	jalr	2016(ra) # 800041bc <begin_op>
  argint(1, &major);
    800059e4:	f6c40593          	addi	a1,s0,-148
    800059e8:	4505                	li	a0,1
    800059ea:	ffffd097          	auipc	ra,0xffffd
    800059ee:	23e080e7          	jalr	574(ra) # 80002c28 <argint>
  argint(2, &minor);
    800059f2:	f6840593          	addi	a1,s0,-152
    800059f6:	4509                	li	a0,2
    800059f8:	ffffd097          	auipc	ra,0xffffd
    800059fc:	230080e7          	jalr	560(ra) # 80002c28 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005a00:	08000613          	li	a2,128
    80005a04:	f7040593          	addi	a1,s0,-144
    80005a08:	4501                	li	a0,0
    80005a0a:	ffffd097          	auipc	ra,0xffffd
    80005a0e:	25e080e7          	jalr	606(ra) # 80002c68 <argstr>
    80005a12:	02054b63          	bltz	a0,80005a48 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005a16:	f6841683          	lh	a3,-152(s0)
    80005a1a:	f6c41603          	lh	a2,-148(s0)
    80005a1e:	458d                	li	a1,3
    80005a20:	f7040513          	addi	a0,s0,-144
    80005a24:	fffff097          	auipc	ra,0xfffff
    80005a28:	784080e7          	jalr	1924(ra) # 800051a8 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005a2c:	cd11                	beqz	a0,80005a48 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005a2e:	ffffe097          	auipc	ra,0xffffe
    80005a32:	022080e7          	jalr	34(ra) # 80003a50 <iunlockput>
  end_op();
    80005a36:	fffff097          	auipc	ra,0xfffff
    80005a3a:	806080e7          	jalr	-2042(ra) # 8000423c <end_op>
  return 0;
    80005a3e:	4501                	li	a0,0
}
    80005a40:	60ea                	ld	ra,152(sp)
    80005a42:	644a                	ld	s0,144(sp)
    80005a44:	610d                	addi	sp,sp,160
    80005a46:	8082                	ret
    end_op();
    80005a48:	ffffe097          	auipc	ra,0xffffe
    80005a4c:	7f4080e7          	jalr	2036(ra) # 8000423c <end_op>
    return -1;
    80005a50:	557d                	li	a0,-1
    80005a52:	b7fd                	j	80005a40 <sys_mknod+0x6c>

0000000080005a54 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005a54:	7135                	addi	sp,sp,-160
    80005a56:	ed06                	sd	ra,152(sp)
    80005a58:	e922                	sd	s0,144(sp)
    80005a5a:	e526                	sd	s1,136(sp)
    80005a5c:	e14a                	sd	s2,128(sp)
    80005a5e:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005a60:	ffffc097          	auipc	ra,0xffffc
    80005a64:	fda080e7          	jalr	-38(ra) # 80001a3a <myproc>
    80005a68:	892a                	mv	s2,a0
  
  begin_op();
    80005a6a:	ffffe097          	auipc	ra,0xffffe
    80005a6e:	752080e7          	jalr	1874(ra) # 800041bc <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005a72:	08000613          	li	a2,128
    80005a76:	f6040593          	addi	a1,s0,-160
    80005a7a:	4501                	li	a0,0
    80005a7c:	ffffd097          	auipc	ra,0xffffd
    80005a80:	1ec080e7          	jalr	492(ra) # 80002c68 <argstr>
    80005a84:	04054b63          	bltz	a0,80005ada <sys_chdir+0x86>
    80005a88:	f6040513          	addi	a0,s0,-160
    80005a8c:	ffffe097          	auipc	ra,0xffffe
    80005a90:	512080e7          	jalr	1298(ra) # 80003f9e <namei>
    80005a94:	84aa                	mv	s1,a0
    80005a96:	c131                	beqz	a0,80005ada <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005a98:	ffffe097          	auipc	ra,0xffffe
    80005a9c:	d54080e7          	jalr	-684(ra) # 800037ec <ilock>
  if(ip->type != T_DIR){
    80005aa0:	04449703          	lh	a4,68(s1)
    80005aa4:	4785                	li	a5,1
    80005aa6:	04f71063          	bne	a4,a5,80005ae6 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005aaa:	8526                	mv	a0,s1
    80005aac:	ffffe097          	auipc	ra,0xffffe
    80005ab0:	e04080e7          	jalr	-508(ra) # 800038b0 <iunlock>
  iput(p->cwd);
    80005ab4:	15093503          	ld	a0,336(s2)
    80005ab8:	ffffe097          	auipc	ra,0xffffe
    80005abc:	ef0080e7          	jalr	-272(ra) # 800039a8 <iput>
  end_op();
    80005ac0:	ffffe097          	auipc	ra,0xffffe
    80005ac4:	77c080e7          	jalr	1916(ra) # 8000423c <end_op>
  p->cwd = ip;
    80005ac8:	14993823          	sd	s1,336(s2)
  return 0;
    80005acc:	4501                	li	a0,0
}
    80005ace:	60ea                	ld	ra,152(sp)
    80005ad0:	644a                	ld	s0,144(sp)
    80005ad2:	64aa                	ld	s1,136(sp)
    80005ad4:	690a                	ld	s2,128(sp)
    80005ad6:	610d                	addi	sp,sp,160
    80005ad8:	8082                	ret
    end_op();
    80005ada:	ffffe097          	auipc	ra,0xffffe
    80005ade:	762080e7          	jalr	1890(ra) # 8000423c <end_op>
    return -1;
    80005ae2:	557d                	li	a0,-1
    80005ae4:	b7ed                	j	80005ace <sys_chdir+0x7a>
    iunlockput(ip);
    80005ae6:	8526                	mv	a0,s1
    80005ae8:	ffffe097          	auipc	ra,0xffffe
    80005aec:	f68080e7          	jalr	-152(ra) # 80003a50 <iunlockput>
    end_op();
    80005af0:	ffffe097          	auipc	ra,0xffffe
    80005af4:	74c080e7          	jalr	1868(ra) # 8000423c <end_op>
    return -1;
    80005af8:	557d                	li	a0,-1
    80005afa:	bfd1                	j	80005ace <sys_chdir+0x7a>

0000000080005afc <sys_exec>:

uint64
sys_exec(void)
{
    80005afc:	7145                	addi	sp,sp,-464
    80005afe:	e786                	sd	ra,456(sp)
    80005b00:	e3a2                	sd	s0,448(sp)
    80005b02:	ff26                	sd	s1,440(sp)
    80005b04:	fb4a                	sd	s2,432(sp)
    80005b06:	f74e                	sd	s3,424(sp)
    80005b08:	f352                	sd	s4,416(sp)
    80005b0a:	ef56                	sd	s5,408(sp)
    80005b0c:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005b0e:	e3840593          	addi	a1,s0,-456
    80005b12:	4505                	li	a0,1
    80005b14:	ffffd097          	auipc	ra,0xffffd
    80005b18:	134080e7          	jalr	308(ra) # 80002c48 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005b1c:	08000613          	li	a2,128
    80005b20:	f4040593          	addi	a1,s0,-192
    80005b24:	4501                	li	a0,0
    80005b26:	ffffd097          	auipc	ra,0xffffd
    80005b2a:	142080e7          	jalr	322(ra) # 80002c68 <argstr>
    return -1;
    80005b2e:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005b30:	0e054363          	bltz	a0,80005c16 <sys_exec+0x11a>
  }
  memset(argv, 0, sizeof(argv));
    80005b34:	e4040913          	addi	s2,s0,-448
    80005b38:	10000613          	li	a2,256
    80005b3c:	4581                	li	a1,0
    80005b3e:	854a                	mv	a0,s2
    80005b40:	ffffb097          	auipc	ra,0xffffb
    80005b44:	1f4080e7          	jalr	500(ra) # 80000d34 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005b48:	89ca                	mv	s3,s2
  memset(argv, 0, sizeof(argv));
    80005b4a:	4481                	li	s1,0
    if(i >= NELEM(argv)){
    80005b4c:	02000a93          	li	s5,32
    80005b50:	00048a1b          	sext.w	s4,s1
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005b54:	00349513          	slli	a0,s1,0x3
    80005b58:	e3040593          	addi	a1,s0,-464
    80005b5c:	e3843783          	ld	a5,-456(s0)
    80005b60:	953e                	add	a0,a0,a5
    80005b62:	ffffd097          	auipc	ra,0xffffd
    80005b66:	026080e7          	jalr	38(ra) # 80002b88 <fetchaddr>
    80005b6a:	02054a63          	bltz	a0,80005b9e <sys_exec+0xa2>
      goto bad;
    }
    if(uarg == 0){
    80005b6e:	e3043783          	ld	a5,-464(s0)
    80005b72:	cfa9                	beqz	a5,80005bcc <sys_exec+0xd0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005b74:	ffffb097          	auipc	ra,0xffffb
    80005b78:	fd4080e7          	jalr	-44(ra) # 80000b48 <kalloc>
    80005b7c:	00a93023          	sd	a0,0(s2)
    if(argv[i] == 0)
    80005b80:	cd19                	beqz	a0,80005b9e <sys_exec+0xa2>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005b82:	6605                	lui	a2,0x1
    80005b84:	85aa                	mv	a1,a0
    80005b86:	e3043503          	ld	a0,-464(s0)
    80005b8a:	ffffd097          	auipc	ra,0xffffd
    80005b8e:	052080e7          	jalr	82(ra) # 80002bdc <fetchstr>
    80005b92:	00054663          	bltz	a0,80005b9e <sys_exec+0xa2>
    if(i >= NELEM(argv)){
    80005b96:	0485                	addi	s1,s1,1
    80005b98:	0921                	addi	s2,s2,8
    80005b9a:	fb549be3          	bne	s1,s5,80005b50 <sys_exec+0x54>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005b9e:	e4043503          	ld	a0,-448(s0)
    kfree(argv[i]);
  return -1;
    80005ba2:	597d                	li	s2,-1
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005ba4:	c92d                	beqz	a0,80005c16 <sys_exec+0x11a>
    kfree(argv[i]);
    80005ba6:	ffffb097          	auipc	ra,0xffffb
    80005baa:	ea2080e7          	jalr	-350(ra) # 80000a48 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005bae:	e4840493          	addi	s1,s0,-440
    80005bb2:	10098993          	addi	s3,s3,256
    80005bb6:	6088                	ld	a0,0(s1)
    80005bb8:	cd31                	beqz	a0,80005c14 <sys_exec+0x118>
    kfree(argv[i]);
    80005bba:	ffffb097          	auipc	ra,0xffffb
    80005bbe:	e8e080e7          	jalr	-370(ra) # 80000a48 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005bc2:	04a1                	addi	s1,s1,8
    80005bc4:	ff3499e3          	bne	s1,s3,80005bb6 <sys_exec+0xba>
  return -1;
    80005bc8:	597d                	li	s2,-1
    80005bca:	a0b1                	j	80005c16 <sys_exec+0x11a>
      argv[i] = 0;
    80005bcc:	0a0e                	slli	s4,s4,0x3
    80005bce:	fc040793          	addi	a5,s0,-64
    80005bd2:	9a3e                	add	s4,s4,a5
    80005bd4:	e80a3023          	sd	zero,-384(s4)
  int ret = exec(path, argv);
    80005bd8:	e4040593          	addi	a1,s0,-448
    80005bdc:	f4040513          	addi	a0,s0,-192
    80005be0:	fffff097          	auipc	ra,0xfffff
    80005be4:	164080e7          	jalr	356(ra) # 80004d44 <exec>
    80005be8:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005bea:	e4043503          	ld	a0,-448(s0)
    80005bee:	c505                	beqz	a0,80005c16 <sys_exec+0x11a>
    kfree(argv[i]);
    80005bf0:	ffffb097          	auipc	ra,0xffffb
    80005bf4:	e58080e7          	jalr	-424(ra) # 80000a48 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005bf8:	e4840493          	addi	s1,s0,-440
    80005bfc:	10098993          	addi	s3,s3,256
    80005c00:	6088                	ld	a0,0(s1)
    80005c02:	c911                	beqz	a0,80005c16 <sys_exec+0x11a>
    kfree(argv[i]);
    80005c04:	ffffb097          	auipc	ra,0xffffb
    80005c08:	e44080e7          	jalr	-444(ra) # 80000a48 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005c0c:	04a1                	addi	s1,s1,8
    80005c0e:	ff3499e3          	bne	s1,s3,80005c00 <sys_exec+0x104>
    80005c12:	a011                	j	80005c16 <sys_exec+0x11a>
  return -1;
    80005c14:	597d                	li	s2,-1
}
    80005c16:	854a                	mv	a0,s2
    80005c18:	60be                	ld	ra,456(sp)
    80005c1a:	641e                	ld	s0,448(sp)
    80005c1c:	74fa                	ld	s1,440(sp)
    80005c1e:	795a                	ld	s2,432(sp)
    80005c20:	79ba                	ld	s3,424(sp)
    80005c22:	7a1a                	ld	s4,416(sp)
    80005c24:	6afa                	ld	s5,408(sp)
    80005c26:	6179                	addi	sp,sp,464
    80005c28:	8082                	ret

0000000080005c2a <sys_pipe>:

uint64
sys_pipe(void)
{
    80005c2a:	7139                	addi	sp,sp,-64
    80005c2c:	fc06                	sd	ra,56(sp)
    80005c2e:	f822                	sd	s0,48(sp)
    80005c30:	f426                	sd	s1,40(sp)
    80005c32:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005c34:	ffffc097          	auipc	ra,0xffffc
    80005c38:	e06080e7          	jalr	-506(ra) # 80001a3a <myproc>
    80005c3c:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005c3e:	fd840593          	addi	a1,s0,-40
    80005c42:	4501                	li	a0,0
    80005c44:	ffffd097          	auipc	ra,0xffffd
    80005c48:	004080e7          	jalr	4(ra) # 80002c48 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005c4c:	fc840593          	addi	a1,s0,-56
    80005c50:	fd040513          	addi	a0,s0,-48
    80005c54:	fffff097          	auipc	ra,0xfffff
    80005c58:	d86080e7          	jalr	-634(ra) # 800049da <pipealloc>
    return -1;
    80005c5c:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005c5e:	0c054463          	bltz	a0,80005d26 <sys_pipe+0xfc>
  fd0 = -1;
    80005c62:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005c66:	fd043503          	ld	a0,-48(s0)
    80005c6a:	fffff097          	auipc	ra,0xfffff
    80005c6e:	4f6080e7          	jalr	1270(ra) # 80005160 <fdalloc>
    80005c72:	fca42223          	sw	a0,-60(s0)
    80005c76:	08054b63          	bltz	a0,80005d0c <sys_pipe+0xe2>
    80005c7a:	fc843503          	ld	a0,-56(s0)
    80005c7e:	fffff097          	auipc	ra,0xfffff
    80005c82:	4e2080e7          	jalr	1250(ra) # 80005160 <fdalloc>
    80005c86:	fca42023          	sw	a0,-64(s0)
    80005c8a:	06054863          	bltz	a0,80005cfa <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005c8e:	4691                	li	a3,4
    80005c90:	fc440613          	addi	a2,s0,-60
    80005c94:	fd843583          	ld	a1,-40(s0)
    80005c98:	68a8                	ld	a0,80(s1)
    80005c9a:	ffffc097          	auipc	ra,0xffffc
    80005c9e:	a46080e7          	jalr	-1466(ra) # 800016e0 <copyout>
    80005ca2:	02054063          	bltz	a0,80005cc2 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005ca6:	4691                	li	a3,4
    80005ca8:	fc040613          	addi	a2,s0,-64
    80005cac:	fd843583          	ld	a1,-40(s0)
    80005cb0:	0591                	addi	a1,a1,4
    80005cb2:	68a8                	ld	a0,80(s1)
    80005cb4:	ffffc097          	auipc	ra,0xffffc
    80005cb8:	a2c080e7          	jalr	-1492(ra) # 800016e0 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005cbc:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005cbe:	06055463          	bgez	a0,80005d26 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005cc2:	fc442783          	lw	a5,-60(s0)
    80005cc6:	07e9                	addi	a5,a5,26
    80005cc8:	078e                	slli	a5,a5,0x3
    80005cca:	97a6                	add	a5,a5,s1
    80005ccc:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005cd0:	fc042783          	lw	a5,-64(s0)
    80005cd4:	07e9                	addi	a5,a5,26
    80005cd6:	078e                	slli	a5,a5,0x3
    80005cd8:	94be                	add	s1,s1,a5
    80005cda:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005cde:	fd043503          	ld	a0,-48(s0)
    80005ce2:	fffff097          	auipc	ra,0xfffff
    80005ce6:	9d4080e7          	jalr	-1580(ra) # 800046b6 <fileclose>
    fileclose(wf);
    80005cea:	fc843503          	ld	a0,-56(s0)
    80005cee:	fffff097          	auipc	ra,0xfffff
    80005cf2:	9c8080e7          	jalr	-1592(ra) # 800046b6 <fileclose>
    return -1;
    80005cf6:	57fd                	li	a5,-1
    80005cf8:	a03d                	j	80005d26 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80005cfa:	fc442783          	lw	a5,-60(s0)
    80005cfe:	0007c763          	bltz	a5,80005d0c <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005d02:	07e9                	addi	a5,a5,26
    80005d04:	078e                	slli	a5,a5,0x3
    80005d06:	94be                	add	s1,s1,a5
    80005d08:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005d0c:	fd043503          	ld	a0,-48(s0)
    80005d10:	fffff097          	auipc	ra,0xfffff
    80005d14:	9a6080e7          	jalr	-1626(ra) # 800046b6 <fileclose>
    fileclose(wf);
    80005d18:	fc843503          	ld	a0,-56(s0)
    80005d1c:	fffff097          	auipc	ra,0xfffff
    80005d20:	99a080e7          	jalr	-1638(ra) # 800046b6 <fileclose>
    return -1;
    80005d24:	57fd                	li	a5,-1
}
    80005d26:	853e                	mv	a0,a5
    80005d28:	70e2                	ld	ra,56(sp)
    80005d2a:	7442                	ld	s0,48(sp)
    80005d2c:	74a2                	ld	s1,40(sp)
    80005d2e:	6121                	addi	sp,sp,64
    80005d30:	8082                	ret
	...

0000000080005d40 <kernelvec>:
    80005d40:	7111                	addi	sp,sp,-256
    80005d42:	e006                	sd	ra,0(sp)
    80005d44:	e40a                	sd	sp,8(sp)
    80005d46:	e80e                	sd	gp,16(sp)
    80005d48:	ec12                	sd	tp,24(sp)
    80005d4a:	f016                	sd	t0,32(sp)
    80005d4c:	f41a                	sd	t1,40(sp)
    80005d4e:	f81e                	sd	t2,48(sp)
    80005d50:	fc22                	sd	s0,56(sp)
    80005d52:	e0a6                	sd	s1,64(sp)
    80005d54:	e4aa                	sd	a0,72(sp)
    80005d56:	e8ae                	sd	a1,80(sp)
    80005d58:	ecb2                	sd	a2,88(sp)
    80005d5a:	f0b6                	sd	a3,96(sp)
    80005d5c:	f4ba                	sd	a4,104(sp)
    80005d5e:	f8be                	sd	a5,112(sp)
    80005d60:	fcc2                	sd	a6,120(sp)
    80005d62:	e146                	sd	a7,128(sp)
    80005d64:	e54a                	sd	s2,136(sp)
    80005d66:	e94e                	sd	s3,144(sp)
    80005d68:	ed52                	sd	s4,152(sp)
    80005d6a:	f156                	sd	s5,160(sp)
    80005d6c:	f55a                	sd	s6,168(sp)
    80005d6e:	f95e                	sd	s7,176(sp)
    80005d70:	fd62                	sd	s8,184(sp)
    80005d72:	e1e6                	sd	s9,192(sp)
    80005d74:	e5ea                	sd	s10,200(sp)
    80005d76:	e9ee                	sd	s11,208(sp)
    80005d78:	edf2                	sd	t3,216(sp)
    80005d7a:	f1f6                	sd	t4,224(sp)
    80005d7c:	f5fa                	sd	t5,232(sp)
    80005d7e:	f9fe                	sd	t6,240(sp)
    80005d80:	cd1fc0ef          	jal	ra,80002a50 <kerneltrap>
    80005d84:	6082                	ld	ra,0(sp)
    80005d86:	6122                	ld	sp,8(sp)
    80005d88:	61c2                	ld	gp,16(sp)
    80005d8a:	7282                	ld	t0,32(sp)
    80005d8c:	7322                	ld	t1,40(sp)
    80005d8e:	73c2                	ld	t2,48(sp)
    80005d90:	7462                	ld	s0,56(sp)
    80005d92:	6486                	ld	s1,64(sp)
    80005d94:	6526                	ld	a0,72(sp)
    80005d96:	65c6                	ld	a1,80(sp)
    80005d98:	6666                	ld	a2,88(sp)
    80005d9a:	7686                	ld	a3,96(sp)
    80005d9c:	7726                	ld	a4,104(sp)
    80005d9e:	77c6                	ld	a5,112(sp)
    80005da0:	7866                	ld	a6,120(sp)
    80005da2:	688a                	ld	a7,128(sp)
    80005da4:	692a                	ld	s2,136(sp)
    80005da6:	69ca                	ld	s3,144(sp)
    80005da8:	6a6a                	ld	s4,152(sp)
    80005daa:	7a8a                	ld	s5,160(sp)
    80005dac:	7b2a                	ld	s6,168(sp)
    80005dae:	7bca                	ld	s7,176(sp)
    80005db0:	7c6a                	ld	s8,184(sp)
    80005db2:	6c8e                	ld	s9,192(sp)
    80005db4:	6d2e                	ld	s10,200(sp)
    80005db6:	6dce                	ld	s11,208(sp)
    80005db8:	6e6e                	ld	t3,216(sp)
    80005dba:	7e8e                	ld	t4,224(sp)
    80005dbc:	7f2e                	ld	t5,232(sp)
    80005dbe:	7fce                	ld	t6,240(sp)
    80005dc0:	6111                	addi	sp,sp,256
    80005dc2:	10200073          	sret
    80005dc6:	00000013          	nop
    80005dca:	00000013          	nop
    80005dce:	0001                	nop

0000000080005dd0 <timervec>:
    80005dd0:	34051573          	csrrw	a0,mscratch,a0
    80005dd4:	e10c                	sd	a1,0(a0)
    80005dd6:	e510                	sd	a2,8(a0)
    80005dd8:	e914                	sd	a3,16(a0)
    80005dda:	6d0c                	ld	a1,24(a0)
    80005ddc:	7110                	ld	a2,32(a0)
    80005dde:	6194                	ld	a3,0(a1)
    80005de0:	96b2                	add	a3,a3,a2
    80005de2:	e194                	sd	a3,0(a1)
    80005de4:	4589                	li	a1,2
    80005de6:	14459073          	csrw	sip,a1
    80005dea:	6914                	ld	a3,16(a0)
    80005dec:	6510                	ld	a2,8(a0)
    80005dee:	610c                	ld	a1,0(a0)
    80005df0:	34051573          	csrrw	a0,mscratch,a0
    80005df4:	30200073          	mret
	...

0000000080005dfa <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005dfa:	1141                	addi	sp,sp,-16
    80005dfc:	e422                	sd	s0,8(sp)
    80005dfe:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005e00:	0c0007b7          	lui	a5,0xc000
    80005e04:	4705                	li	a4,1
    80005e06:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005e08:	c3d8                	sw	a4,4(a5)
}
    80005e0a:	6422                	ld	s0,8(sp)
    80005e0c:	0141                	addi	sp,sp,16
    80005e0e:	8082                	ret

0000000080005e10 <plicinithart>:

void
plicinithart(void)
{
    80005e10:	1141                	addi	sp,sp,-16
    80005e12:	e406                	sd	ra,8(sp)
    80005e14:	e022                	sd	s0,0(sp)
    80005e16:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005e18:	ffffc097          	auipc	ra,0xffffc
    80005e1c:	bf6080e7          	jalr	-1034(ra) # 80001a0e <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005e20:	0085171b          	slliw	a4,a0,0x8
    80005e24:	0c0027b7          	lui	a5,0xc002
    80005e28:	97ba                	add	a5,a5,a4
    80005e2a:	40200713          	li	a4,1026
    80005e2e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005e32:	00d5151b          	slliw	a0,a0,0xd
    80005e36:	0c2017b7          	lui	a5,0xc201
    80005e3a:	953e                	add	a0,a0,a5
    80005e3c:	00052023          	sw	zero,0(a0)
}
    80005e40:	60a2                	ld	ra,8(sp)
    80005e42:	6402                	ld	s0,0(sp)
    80005e44:	0141                	addi	sp,sp,16
    80005e46:	8082                	ret

0000000080005e48 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005e48:	1141                	addi	sp,sp,-16
    80005e4a:	e406                	sd	ra,8(sp)
    80005e4c:	e022                	sd	s0,0(sp)
    80005e4e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005e50:	ffffc097          	auipc	ra,0xffffc
    80005e54:	bbe080e7          	jalr	-1090(ra) # 80001a0e <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005e58:	00d5151b          	slliw	a0,a0,0xd
    80005e5c:	0c2017b7          	lui	a5,0xc201
    80005e60:	97aa                	add	a5,a5,a0
  return irq;
}
    80005e62:	43c8                	lw	a0,4(a5)
    80005e64:	60a2                	ld	ra,8(sp)
    80005e66:	6402                	ld	s0,0(sp)
    80005e68:	0141                	addi	sp,sp,16
    80005e6a:	8082                	ret

0000000080005e6c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005e6c:	1101                	addi	sp,sp,-32
    80005e6e:	ec06                	sd	ra,24(sp)
    80005e70:	e822                	sd	s0,16(sp)
    80005e72:	e426                	sd	s1,8(sp)
    80005e74:	1000                	addi	s0,sp,32
    80005e76:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005e78:	ffffc097          	auipc	ra,0xffffc
    80005e7c:	b96080e7          	jalr	-1130(ra) # 80001a0e <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005e80:	00d5151b          	slliw	a0,a0,0xd
    80005e84:	0c2017b7          	lui	a5,0xc201
    80005e88:	97aa                	add	a5,a5,a0
    80005e8a:	c3c4                	sw	s1,4(a5)
}
    80005e8c:	60e2                	ld	ra,24(sp)
    80005e8e:	6442                	ld	s0,16(sp)
    80005e90:	64a2                	ld	s1,8(sp)
    80005e92:	6105                	addi	sp,sp,32
    80005e94:	8082                	ret

0000000080005e96 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005e96:	1141                	addi	sp,sp,-16
    80005e98:	e406                	sd	ra,8(sp)
    80005e9a:	e022                	sd	s0,0(sp)
    80005e9c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005e9e:	479d                	li	a5,7
    80005ea0:	04a7cc63          	blt	a5,a0,80005ef8 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005ea4:	0001c797          	auipc	a5,0x1c
    80005ea8:	dbc78793          	addi	a5,a5,-580 # 80021c60 <disk>
    80005eac:	97aa                	add	a5,a5,a0
    80005eae:	0187c783          	lbu	a5,24(a5)
    80005eb2:	ebb9                	bnez	a5,80005f08 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005eb4:	00451613          	slli	a2,a0,0x4
    80005eb8:	0001c797          	auipc	a5,0x1c
    80005ebc:	da878793          	addi	a5,a5,-600 # 80021c60 <disk>
    80005ec0:	6394                	ld	a3,0(a5)
    80005ec2:	96b2                	add	a3,a3,a2
    80005ec4:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005ec8:	6398                	ld	a4,0(a5)
    80005eca:	9732                	add	a4,a4,a2
    80005ecc:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005ed0:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005ed4:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005ed8:	97aa                	add	a5,a5,a0
    80005eda:	4705                	li	a4,1
    80005edc:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005ee0:	0001c517          	auipc	a0,0x1c
    80005ee4:	d9850513          	addi	a0,a0,-616 # 80021c78 <disk+0x18>
    80005ee8:	ffffc097          	auipc	ra,0xffffc
    80005eec:	25e080e7          	jalr	606(ra) # 80002146 <wakeup>
}
    80005ef0:	60a2                	ld	ra,8(sp)
    80005ef2:	6402                	ld	s0,0(sp)
    80005ef4:	0141                	addi	sp,sp,16
    80005ef6:	8082                	ret
    panic("free_desc 1");
    80005ef8:	00003517          	auipc	a0,0x3
    80005efc:	88850513          	addi	a0,a0,-1912 # 80008780 <syscalls+0x318>
    80005f00:	ffffa097          	auipc	ra,0xffffa
    80005f04:	66c080e7          	jalr	1644(ra) # 8000056c <panic>
    panic("free_desc 2");
    80005f08:	00003517          	auipc	a0,0x3
    80005f0c:	88850513          	addi	a0,a0,-1912 # 80008790 <syscalls+0x328>
    80005f10:	ffffa097          	auipc	ra,0xffffa
    80005f14:	65c080e7          	jalr	1628(ra) # 8000056c <panic>

0000000080005f18 <virtio_disk_init>:
{
    80005f18:	1101                	addi	sp,sp,-32
    80005f1a:	ec06                	sd	ra,24(sp)
    80005f1c:	e822                	sd	s0,16(sp)
    80005f1e:	e426                	sd	s1,8(sp)
    80005f20:	e04a                	sd	s2,0(sp)
    80005f22:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005f24:	00003597          	auipc	a1,0x3
    80005f28:	87c58593          	addi	a1,a1,-1924 # 800087a0 <syscalls+0x338>
    80005f2c:	0001c517          	auipc	a0,0x1c
    80005f30:	e5c50513          	addi	a0,a0,-420 # 80021d88 <disk+0x128>
    80005f34:	ffffb097          	auipc	ra,0xffffb
    80005f38:	c74080e7          	jalr	-908(ra) # 80000ba8 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005f3c:	100017b7          	lui	a5,0x10001
    80005f40:	4398                	lw	a4,0(a5)
    80005f42:	2701                	sext.w	a4,a4
    80005f44:	747277b7          	lui	a5,0x74727
    80005f48:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005f4c:	14f71b63          	bne	a4,a5,800060a2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005f50:	100017b7          	lui	a5,0x10001
    80005f54:	43dc                	lw	a5,4(a5)
    80005f56:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005f58:	4709                	li	a4,2
    80005f5a:	14e79463          	bne	a5,a4,800060a2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005f5e:	100017b7          	lui	a5,0x10001
    80005f62:	479c                	lw	a5,8(a5)
    80005f64:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005f66:	12e79e63          	bne	a5,a4,800060a2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005f6a:	100017b7          	lui	a5,0x10001
    80005f6e:	47d8                	lw	a4,12(a5)
    80005f70:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005f72:	554d47b7          	lui	a5,0x554d4
    80005f76:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005f7a:	12f71463          	bne	a4,a5,800060a2 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005f7e:	100017b7          	lui	a5,0x10001
    80005f82:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005f86:	4705                	li	a4,1
    80005f88:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005f8a:	470d                	li	a4,3
    80005f8c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005f8e:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005f90:	c7ffe737          	lui	a4,0xc7ffe
    80005f94:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc9bf>
    80005f98:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005f9a:	2701                	sext.w	a4,a4
    80005f9c:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005f9e:	472d                	li	a4,11
    80005fa0:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005fa2:	0707a903          	lw	s2,112(a5)
    80005fa6:	2901                	sext.w	s2,s2
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005fa8:	00897793          	andi	a5,s2,8
    80005fac:	10078363          	beqz	a5,800060b2 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005fb0:	100017b7          	lui	a5,0x10001
    80005fb4:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005fb8:	43fc                	lw	a5,68(a5)
    80005fba:	2781                	sext.w	a5,a5
    80005fbc:	10079363          	bnez	a5,800060c2 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005fc0:	100017b7          	lui	a5,0x10001
    80005fc4:	5bdc                	lw	a5,52(a5)
    80005fc6:	2781                	sext.w	a5,a5
  if(max == 0)
    80005fc8:	10078563          	beqz	a5,800060d2 <virtio_disk_init+0x1ba>
  if(max < NUM)
    80005fcc:	471d                	li	a4,7
    80005fce:	10f77a63          	bgeu	a4,a5,800060e2 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    80005fd2:	ffffb097          	auipc	ra,0xffffb
    80005fd6:	b76080e7          	jalr	-1162(ra) # 80000b48 <kalloc>
    80005fda:	0001c497          	auipc	s1,0x1c
    80005fde:	c8648493          	addi	s1,s1,-890 # 80021c60 <disk>
    80005fe2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005fe4:	ffffb097          	auipc	ra,0xffffb
    80005fe8:	b64080e7          	jalr	-1180(ra) # 80000b48 <kalloc>
    80005fec:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80005fee:	ffffb097          	auipc	ra,0xffffb
    80005ff2:	b5a080e7          	jalr	-1190(ra) # 80000b48 <kalloc>
    80005ff6:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005ff8:	609c                	ld	a5,0(s1)
    80005ffa:	cfe5                	beqz	a5,800060f2 <virtio_disk_init+0x1da>
    80005ffc:	6498                	ld	a4,8(s1)
    80005ffe:	cb75                	beqz	a4,800060f2 <virtio_disk_init+0x1da>
    80006000:	c96d                	beqz	a0,800060f2 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80006002:	6605                	lui	a2,0x1
    80006004:	4581                	li	a1,0
    80006006:	853e                	mv	a0,a5
    80006008:	ffffb097          	auipc	ra,0xffffb
    8000600c:	d2c080e7          	jalr	-724(ra) # 80000d34 <memset>
  memset(disk.avail, 0, PGSIZE);
    80006010:	0001c497          	auipc	s1,0x1c
    80006014:	c5048493          	addi	s1,s1,-944 # 80021c60 <disk>
    80006018:	6605                	lui	a2,0x1
    8000601a:	4581                	li	a1,0
    8000601c:	6488                	ld	a0,8(s1)
    8000601e:	ffffb097          	auipc	ra,0xffffb
    80006022:	d16080e7          	jalr	-746(ra) # 80000d34 <memset>
  memset(disk.used, 0, PGSIZE);
    80006026:	6605                	lui	a2,0x1
    80006028:	4581                	li	a1,0
    8000602a:	6888                	ld	a0,16(s1)
    8000602c:	ffffb097          	auipc	ra,0xffffb
    80006030:	d08080e7          	jalr	-760(ra) # 80000d34 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006034:	100017b7          	lui	a5,0x10001
    80006038:	4721                	li	a4,8
    8000603a:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    8000603c:	4098                	lw	a4,0(s1)
    8000603e:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80006042:	40d8                	lw	a4,4(s1)
    80006044:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80006048:	6498                	ld	a4,8(s1)
    8000604a:	0007069b          	sext.w	a3,a4
    8000604e:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80006052:	9701                	srai	a4,a4,0x20
    80006054:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80006058:	6898                	ld	a4,16(s1)
    8000605a:	0007069b          	sext.w	a3,a4
    8000605e:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80006062:	9701                	srai	a4,a4,0x20
    80006064:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80006068:	4685                	li	a3,1
    8000606a:	c3f4                	sw	a3,68(a5)
    disk.free[i] = 1;
    8000606c:	4705                	li	a4,1
    8000606e:	00d48c23          	sb	a3,24(s1)
    80006072:	00e48ca3          	sb	a4,25(s1)
    80006076:	00e48d23          	sb	a4,26(s1)
    8000607a:	00e48da3          	sb	a4,27(s1)
    8000607e:	00e48e23          	sb	a4,28(s1)
    80006082:	00e48ea3          	sb	a4,29(s1)
    80006086:	00e48f23          	sb	a4,30(s1)
    8000608a:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    8000608e:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80006092:	0727a823          	sw	s2,112(a5)
}
    80006096:	60e2                	ld	ra,24(sp)
    80006098:	6442                	ld	s0,16(sp)
    8000609a:	64a2                	ld	s1,8(sp)
    8000609c:	6902                	ld	s2,0(sp)
    8000609e:	6105                	addi	sp,sp,32
    800060a0:	8082                	ret
    panic("could not find virtio disk");
    800060a2:	00002517          	auipc	a0,0x2
    800060a6:	70e50513          	addi	a0,a0,1806 # 800087b0 <syscalls+0x348>
    800060aa:	ffffa097          	auipc	ra,0xffffa
    800060ae:	4c2080e7          	jalr	1218(ra) # 8000056c <panic>
    panic("virtio disk FEATURES_OK unset");
    800060b2:	00002517          	auipc	a0,0x2
    800060b6:	71e50513          	addi	a0,a0,1822 # 800087d0 <syscalls+0x368>
    800060ba:	ffffa097          	auipc	ra,0xffffa
    800060be:	4b2080e7          	jalr	1202(ra) # 8000056c <panic>
    panic("virtio disk should not be ready");
    800060c2:	00002517          	auipc	a0,0x2
    800060c6:	72e50513          	addi	a0,a0,1838 # 800087f0 <syscalls+0x388>
    800060ca:	ffffa097          	auipc	ra,0xffffa
    800060ce:	4a2080e7          	jalr	1186(ra) # 8000056c <panic>
    panic("virtio disk has no queue 0");
    800060d2:	00002517          	auipc	a0,0x2
    800060d6:	73e50513          	addi	a0,a0,1854 # 80008810 <syscalls+0x3a8>
    800060da:	ffffa097          	auipc	ra,0xffffa
    800060de:	492080e7          	jalr	1170(ra) # 8000056c <panic>
    panic("virtio disk max queue too short");
    800060e2:	00002517          	auipc	a0,0x2
    800060e6:	74e50513          	addi	a0,a0,1870 # 80008830 <syscalls+0x3c8>
    800060ea:	ffffa097          	auipc	ra,0xffffa
    800060ee:	482080e7          	jalr	1154(ra) # 8000056c <panic>
    panic("virtio disk kalloc");
    800060f2:	00002517          	auipc	a0,0x2
    800060f6:	75e50513          	addi	a0,a0,1886 # 80008850 <syscalls+0x3e8>
    800060fa:	ffffa097          	auipc	ra,0xffffa
    800060fe:	472080e7          	jalr	1138(ra) # 8000056c <panic>

0000000080006102 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006102:	7159                	addi	sp,sp,-112
    80006104:	f486                	sd	ra,104(sp)
    80006106:	f0a2                	sd	s0,96(sp)
    80006108:	eca6                	sd	s1,88(sp)
    8000610a:	e8ca                	sd	s2,80(sp)
    8000610c:	e4ce                	sd	s3,72(sp)
    8000610e:	e0d2                	sd	s4,64(sp)
    80006110:	fc56                	sd	s5,56(sp)
    80006112:	f85a                	sd	s6,48(sp)
    80006114:	f45e                	sd	s7,40(sp)
    80006116:	f062                	sd	s8,32(sp)
    80006118:	ec66                	sd	s9,24(sp)
    8000611a:	e86a                	sd	s10,16(sp)
    8000611c:	1880                	addi	s0,sp,112
    8000611e:	892a                	mv	s2,a0
    80006120:	8cae                	mv	s9,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006122:	00c52c03          	lw	s8,12(a0)
    80006126:	001c1c1b          	slliw	s8,s8,0x1
    8000612a:	1c02                	slli	s8,s8,0x20
    8000612c:	020c5c13          	srli	s8,s8,0x20

  acquire(&disk.vdisk_lock);
    80006130:	0001c517          	auipc	a0,0x1c
    80006134:	c5850513          	addi	a0,a0,-936 # 80021d88 <disk+0x128>
    80006138:	ffffb097          	auipc	ra,0xffffb
    8000613c:	b00080e7          	jalr	-1280(ra) # 80000c38 <acquire>
    if(disk.free[i]){
    80006140:	0001c997          	auipc	s3,0x1c
    80006144:	b2098993          	addi	s3,s3,-1248 # 80021c60 <disk>
  for(int i = 0; i < NUM; i++){
    80006148:	4d05                	li	s10,1
    8000614a:	4b21                	li	s6,8
  for(int i = 0; i < 3; i++){
    8000614c:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    8000614e:	8a6a                	mv	s4,s10
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006150:	0001cb97          	auipc	s7,0x1c
    80006154:	c38b8b93          	addi	s7,s7,-968 # 80021d88 <disk+0x128>
    80006158:	a049                	j	800061da <virtio_disk_rw+0xd8>
      disk.free[i] = 0;
    8000615a:	00f986b3          	add	a3,s3,a5
    8000615e:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80006162:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80006164:	0207c963          	bltz	a5,80006196 <virtio_disk_rw+0x94>
  for(int i = 0; i < 3; i++){
    80006168:	2485                	addiw	s1,s1,1
    8000616a:	0711                	addi	a4,a4,4
    8000616c:	1f548f63          	beq	s1,s5,8000636a <virtio_disk_rw+0x268>
    idx[i] = alloc_desc();
    80006170:	863a                	mv	a2,a4
    if(disk.free[i]){
    80006172:	0189c783          	lbu	a5,24(s3)
    80006176:	22079263          	bnez	a5,8000639a <virtio_disk_rw+0x298>
    8000617a:	0001c697          	auipc	a3,0x1c
    8000617e:	ae668693          	addi	a3,a3,-1306 # 80021c60 <disk>
  for(int i = 0; i < NUM; i++){
    80006182:	87d2                	mv	a5,s4
    if(disk.free[i]){
    80006184:	0196c583          	lbu	a1,25(a3)
    80006188:	f9e9                	bnez	a1,8000615a <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    8000618a:	2785                	addiw	a5,a5,1
    8000618c:	0685                	addi	a3,a3,1
    8000618e:	ff679be3          	bne	a5,s6,80006184 <virtio_disk_rw+0x82>
    idx[i] = alloc_desc();
    80006192:	57fd                	li	a5,-1
    80006194:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    80006196:	02905963          	blez	s1,800061c8 <virtio_disk_rw+0xc6>
        free_desc(idx[j]);
    8000619a:	f9042503          	lw	a0,-112(s0)
    8000619e:	00000097          	auipc	ra,0x0
    800061a2:	cf8080e7          	jalr	-776(ra) # 80005e96 <free_desc>
      for(int j = 0; j < i; j++)
    800061a6:	029d5163          	bge	s10,s1,800061c8 <virtio_disk_rw+0xc6>
        free_desc(idx[j]);
    800061aa:	f9442503          	lw	a0,-108(s0)
    800061ae:	00000097          	auipc	ra,0x0
    800061b2:	ce8080e7          	jalr	-792(ra) # 80005e96 <free_desc>
      for(int j = 0; j < i; j++)
    800061b6:	4789                	li	a5,2
    800061b8:	0097d863          	bge	a5,s1,800061c8 <virtio_disk_rw+0xc6>
        free_desc(idx[j]);
    800061bc:	f9842503          	lw	a0,-104(s0)
    800061c0:	00000097          	auipc	ra,0x0
    800061c4:	cd6080e7          	jalr	-810(ra) # 80005e96 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800061c8:	85de                	mv	a1,s7
    800061ca:	0001c517          	auipc	a0,0x1c
    800061ce:	aae50513          	addi	a0,a0,-1362 # 80021c78 <disk+0x18>
    800061d2:	ffffc097          	auipc	ra,0xffffc
    800061d6:	f10080e7          	jalr	-240(ra) # 800020e2 <sleep>
  for(int i = 0; i < 3; i++){
    800061da:	f9040713          	addi	a4,s0,-112
    800061de:	4481                	li	s1,0
    800061e0:	bf41                	j	80006170 <virtio_disk_rw+0x6e>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    800061e2:	00a70793          	addi	a5,a4,10
    800061e6:	00479613          	slli	a2,a5,0x4
    800061ea:	0001c797          	auipc	a5,0x1c
    800061ee:	a7678793          	addi	a5,a5,-1418 # 80021c60 <disk>
    800061f2:	97b2                	add	a5,a5,a2
    800061f4:	4605                	li	a2,1
    800061f6:	c790                	sw	a2,8(a5)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800061f8:	0001c617          	auipc	a2,0x1c
    800061fc:	a6860613          	addi	a2,a2,-1432 # 80021c60 <disk>
    80006200:	00a70793          	addi	a5,a4,10
    80006204:	0792                	slli	a5,a5,0x4
    80006206:	97b2                	add	a5,a5,a2
    80006208:	0007a623          	sw	zero,12(a5)
  buf0->sector = sector;
    8000620c:	0187b823          	sd	s8,16(a5)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80006210:	621c                	ld	a5,0(a2)
    80006212:	96be                	add	a3,a3,a5
    80006214:	f6b6b023          	sd	a1,-160(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80006218:	620c                	ld	a1,0(a2)
    8000621a:	00471693          	slli	a3,a4,0x4
    8000621e:	00d58533          	add	a0,a1,a3
    80006222:	47c1                	li	a5,16
    80006224:	c51c                	sw	a5,8(a0)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006226:	4785                	li	a5,1
    80006228:	00f51623          	sh	a5,12(a0)
  disk.desc[idx[0]].next = idx[1];
    8000622c:	f9442783          	lw	a5,-108(s0)
    80006230:	00f51723          	sh	a5,14(a0)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80006234:	0792                	slli	a5,a5,0x4
    80006236:	95be                	add	a1,a1,a5
    80006238:	05890513          	addi	a0,s2,88
    8000623c:	e188                	sd	a0,0(a1)
  disk.desc[idx[1]].len = BSIZE;
    8000623e:	6208                	ld	a0,0(a2)
    80006240:	97aa                	add	a5,a5,a0
    80006242:	40000613          	li	a2,1024
    80006246:	c790                	sw	a2,8(a5)
  if(write)
    80006248:	100c8d63          	beqz	s9,80006362 <virtio_disk_rw+0x260>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000624c:	00079623          	sh	zero,12(a5)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006250:	00c7d603          	lhu	a2,12(a5)
    80006254:	00166613          	ori	a2,a2,1
    80006258:	00c79623          	sh	a2,12(a5)
  disk.desc[idx[1]].next = idx[2];
    8000625c:	f9842583          	lw	a1,-104(s0)
    80006260:	00b79723          	sh	a1,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80006264:	0001c617          	auipc	a2,0x1c
    80006268:	9fc60613          	addi	a2,a2,-1540 # 80021c60 <disk>
    8000626c:	00270793          	addi	a5,a4,2
    80006270:	0792                	slli	a5,a5,0x4
    80006272:	97b2                	add	a5,a5,a2
    80006274:	587d                	li	a6,-1
    80006276:	01078823          	sb	a6,16(a5)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000627a:	0592                	slli	a1,a1,0x4
    8000627c:	952e                	add	a0,a0,a1
    8000627e:	03068693          	addi	a3,a3,48
    80006282:	96b2                	add	a3,a3,a2
    80006284:	e114                	sd	a3,0(a0)
  disk.desc[idx[2]].len = 1;
    80006286:	6214                	ld	a3,0(a2)
    80006288:	96ae                	add	a3,a3,a1
    8000628a:	4585                	li	a1,1
    8000628c:	c68c                	sw	a1,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000628e:	4509                	li	a0,2
    80006290:	00a69623          	sh	a0,12(a3)
  disk.desc[idx[2]].next = 0;
    80006294:	00069723          	sh	zero,14(a3)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80006298:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    8000629c:	0127b423          	sd	s2,8(a5)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800062a0:	6614                	ld	a3,8(a2)
    800062a2:	0026d783          	lhu	a5,2(a3)
    800062a6:	8b9d                	andi	a5,a5,7
    800062a8:	0786                	slli	a5,a5,0x1
    800062aa:	97b6                	add	a5,a5,a3
    800062ac:	00e79223          	sh	a4,4(a5)

  __sync_synchronize();
    800062b0:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800062b4:	6618                	ld	a4,8(a2)
    800062b6:	00275783          	lhu	a5,2(a4)
    800062ba:	2785                	addiw	a5,a5,1
    800062bc:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800062c0:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800062c4:	100017b7          	lui	a5,0x10001
    800062c8:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800062cc:	00492703          	lw	a4,4(s2)
    800062d0:	4785                	li	a5,1
    800062d2:	02f71163          	bne	a4,a5,800062f4 <virtio_disk_rw+0x1f2>
    sleep(b, &disk.vdisk_lock);
    800062d6:	0001c997          	auipc	s3,0x1c
    800062da:	ab298993          	addi	s3,s3,-1358 # 80021d88 <disk+0x128>
  while(b->disk == 1) {
    800062de:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800062e0:	85ce                	mv	a1,s3
    800062e2:	854a                	mv	a0,s2
    800062e4:	ffffc097          	auipc	ra,0xffffc
    800062e8:	dfe080e7          	jalr	-514(ra) # 800020e2 <sleep>
  while(b->disk == 1) {
    800062ec:	00492783          	lw	a5,4(s2)
    800062f0:	fe9788e3          	beq	a5,s1,800062e0 <virtio_disk_rw+0x1de>
  }

  disk.info[idx[0]].b = 0;
    800062f4:	f9042503          	lw	a0,-112(s0)
    800062f8:	00250793          	addi	a5,a0,2
    800062fc:	00479713          	slli	a4,a5,0x4
    80006300:	0001c797          	auipc	a5,0x1c
    80006304:	96078793          	addi	a5,a5,-1696 # 80021c60 <disk>
    80006308:	97ba                	add	a5,a5,a4
    8000630a:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000630e:	0001c997          	auipc	s3,0x1c
    80006312:	95298993          	addi	s3,s3,-1710 # 80021c60 <disk>
    80006316:	00451713          	slli	a4,a0,0x4
    8000631a:	0009b783          	ld	a5,0(s3)
    8000631e:	97ba                	add	a5,a5,a4
    80006320:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006324:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80006328:	00000097          	auipc	ra,0x0
    8000632c:	b6e080e7          	jalr	-1170(ra) # 80005e96 <free_desc>
      i = nxt;
    80006330:	854a                	mv	a0,s2
    if(flag & VRING_DESC_F_NEXT)
    80006332:	8885                	andi	s1,s1,1
    80006334:	f0ed                	bnez	s1,80006316 <virtio_disk_rw+0x214>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006336:	0001c517          	auipc	a0,0x1c
    8000633a:	a5250513          	addi	a0,a0,-1454 # 80021d88 <disk+0x128>
    8000633e:	ffffb097          	auipc	ra,0xffffb
    80006342:	9ae080e7          	jalr	-1618(ra) # 80000cec <release>
}
    80006346:	70a6                	ld	ra,104(sp)
    80006348:	7406                	ld	s0,96(sp)
    8000634a:	64e6                	ld	s1,88(sp)
    8000634c:	6946                	ld	s2,80(sp)
    8000634e:	69a6                	ld	s3,72(sp)
    80006350:	6a06                	ld	s4,64(sp)
    80006352:	7ae2                	ld	s5,56(sp)
    80006354:	7b42                	ld	s6,48(sp)
    80006356:	7ba2                	ld	s7,40(sp)
    80006358:	7c02                	ld	s8,32(sp)
    8000635a:	6ce2                	ld	s9,24(sp)
    8000635c:	6d42                	ld	s10,16(sp)
    8000635e:	6165                	addi	sp,sp,112
    80006360:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80006362:	4609                	li	a2,2
    80006364:	00c79623          	sh	a2,12(a5)
    80006368:	b5e5                	j	80006250 <virtio_disk_rw+0x14e>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000636a:	f9042703          	lw	a4,-112(s0)
    8000636e:	00a70693          	addi	a3,a4,10
    80006372:	0692                	slli	a3,a3,0x4
    80006374:	0001c597          	auipc	a1,0x1c
    80006378:	8f458593          	addi	a1,a1,-1804 # 80021c68 <disk+0x8>
    8000637c:	95b6                	add	a1,a1,a3
  if(write)
    8000637e:	e60c92e3          	bnez	s9,800061e2 <virtio_disk_rw+0xe0>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80006382:	00a70793          	addi	a5,a4,10
    80006386:	00479613          	slli	a2,a5,0x4
    8000638a:	0001c797          	auipc	a5,0x1c
    8000638e:	8d678793          	addi	a5,a5,-1834 # 80021c60 <disk>
    80006392:	97b2                	add	a5,a5,a2
    80006394:	0007a423          	sw	zero,8(a5)
    80006398:	b585                	j	800061f8 <virtio_disk_rw+0xf6>
      disk.free[i] = 0;
    8000639a:	00098c23          	sb	zero,24(s3)
    idx[i] = alloc_desc();
    8000639e:	00072023          	sw	zero,0(a4)
    if(idx[i] < 0){
    800063a2:	b3d9                	j	80006168 <virtio_disk_rw+0x66>

00000000800063a4 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800063a4:	1101                	addi	sp,sp,-32
    800063a6:	ec06                	sd	ra,24(sp)
    800063a8:	e822                	sd	s0,16(sp)
    800063aa:	e426                	sd	s1,8(sp)
    800063ac:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800063ae:	0001c497          	auipc	s1,0x1c
    800063b2:	8b248493          	addi	s1,s1,-1870 # 80021c60 <disk>
    800063b6:	0001c517          	auipc	a0,0x1c
    800063ba:	9d250513          	addi	a0,a0,-1582 # 80021d88 <disk+0x128>
    800063be:	ffffb097          	auipc	ra,0xffffb
    800063c2:	87a080e7          	jalr	-1926(ra) # 80000c38 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800063c6:	10001737          	lui	a4,0x10001
    800063ca:	533c                	lw	a5,96(a4)
    800063cc:	8b8d                	andi	a5,a5,3
    800063ce:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800063d0:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800063d4:	689c                	ld	a5,16(s1)
    800063d6:	0204d703          	lhu	a4,32(s1)
    800063da:	0027d783          	lhu	a5,2(a5)
    800063de:	04f70863          	beq	a4,a5,8000642e <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800063e2:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800063e6:	6898                	ld	a4,16(s1)
    800063e8:	0204d783          	lhu	a5,32(s1)
    800063ec:	8b9d                	andi	a5,a5,7
    800063ee:	078e                	slli	a5,a5,0x3
    800063f0:	97ba                	add	a5,a5,a4
    800063f2:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800063f4:	00278713          	addi	a4,a5,2
    800063f8:	0712                	slli	a4,a4,0x4
    800063fa:	9726                	add	a4,a4,s1
    800063fc:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80006400:	e721                	bnez	a4,80006448 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006402:	0789                	addi	a5,a5,2
    80006404:	0792                	slli	a5,a5,0x4
    80006406:	97a6                	add	a5,a5,s1
    80006408:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000640a:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000640e:	ffffc097          	auipc	ra,0xffffc
    80006412:	d38080e7          	jalr	-712(ra) # 80002146 <wakeup>

    disk.used_idx += 1;
    80006416:	0204d783          	lhu	a5,32(s1)
    8000641a:	2785                	addiw	a5,a5,1
    8000641c:	17c2                	slli	a5,a5,0x30
    8000641e:	93c1                	srli	a5,a5,0x30
    80006420:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006424:	6898                	ld	a4,16(s1)
    80006426:	00275703          	lhu	a4,2(a4)
    8000642a:	faf71ce3          	bne	a4,a5,800063e2 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    8000642e:	0001c517          	auipc	a0,0x1c
    80006432:	95a50513          	addi	a0,a0,-1702 # 80021d88 <disk+0x128>
    80006436:	ffffb097          	auipc	ra,0xffffb
    8000643a:	8b6080e7          	jalr	-1866(ra) # 80000cec <release>
}
    8000643e:	60e2                	ld	ra,24(sp)
    80006440:	6442                	ld	s0,16(sp)
    80006442:	64a2                	ld	s1,8(sp)
    80006444:	6105                	addi	sp,sp,32
    80006446:	8082                	ret
      panic("virtio_disk_intr status");
    80006448:	00002517          	auipc	a0,0x2
    8000644c:	42050513          	addi	a0,a0,1056 # 80008868 <syscalls+0x400>
    80006450:	ffffa097          	auipc	ra,0xffffa
    80006454:	11c080e7          	jalr	284(ra) # 8000056c <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
