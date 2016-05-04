
vmm/guest/obj/fs/fs:     file format elf64-x86-64


Disassembly of section .text:

0000000000800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	movabs $USTACKTOP, %rax
  800020:	48 b8 00 e0 7f ef 00 	movabs $0xef7fe000,%rax
  800027:	00 00 00 
	cmpq %rax,%rsp
  80002a:	48 39 c4             	cmp    %rax,%rsp
	jne args_exist
  80002d:	75 04                	jne    800033 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushq $0
  80002f:	6a 00                	pushq  $0x0
	pushq $0
  800031:	6a 00                	pushq  $0x0

0000000000800033 <args_exist>:

args_exist:
	movq 8(%rsp), %rsi
  800033:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
	movq (%rsp), %rdi
  800038:	48 8b 3c 24          	mov    (%rsp),%rdi
	call libmain
  80003c:	e8 fd 33 00 00       	callq  80343e <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <ide_wait_ready>:

static int diskno = 1;

static int
ide_wait_ready(bool check_error)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 14          	sub    $0x14,%rsp
  80004b:	89 f8                	mov    %edi,%eax
  80004d:	88 45 ec             	mov    %al,-0x14(%rbp)
	int r;

	while (((r = inb(0x1F7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
  800050:	90                   	nop
  800051:	c7 45 f8 f7 01 00 00 	movl   $0x1f7,-0x8(%rbp)

    static __inline uint8_t
inb(int port)
{
    uint8_t data;
    __asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800058:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80005b:	89 c2                	mov    %eax,%edx
  80005d:	ec                   	in     (%dx),%al
  80005e:	88 45 f7             	mov    %al,-0x9(%rbp)
    return data;
  800061:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
  800065:	0f b6 c0             	movzbl %al,%eax
  800068:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80006b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80006e:	25 c0 00 00 00       	and    $0xc0,%eax
  800073:	83 f8 40             	cmp    $0x40,%eax
  800076:	75 d9                	jne    800051 <ide_wait_ready+0xe>
		/* do nothing */;

	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  800078:	80 7d ec 00          	cmpb   $0x0,-0x14(%rbp)
  80007c:	74 11                	je     80008f <ide_wait_ready+0x4c>
  80007e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800081:	83 e0 21             	and    $0x21,%eax
  800084:	85 c0                	test   %eax,%eax
  800086:	74 07                	je     80008f <ide_wait_ready+0x4c>
		return -1;
  800088:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80008d:	eb 05                	jmp    800094 <ide_wait_ready+0x51>
	return 0;
  80008f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800094:	c9                   	leaveq 
  800095:	c3                   	retq   

0000000000800096 <ide_probe_disk1>:

bool
ide_probe_disk1(void)
{
  800096:	55                   	push   %rbp
  800097:	48 89 e5             	mov    %rsp,%rbp
  80009a:	48 83 ec 20          	sub    $0x20,%rsp
	int r, x;

	// wait for Device 0 to be ready
	ide_wait_ready(0);
  80009e:	bf 00 00 00 00       	mov    $0x0,%edi
  8000a3:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000aa:	00 00 00 
  8000ad:	ff d0                	callq  *%rax
  8000af:	c7 45 f4 f6 01 00 00 	movl   $0x1f6,-0xc(%rbp)
  8000b6:	c6 45 f3 f0          	movb   $0xf0,-0xd(%rbp)
}

    static __inline void
outb(int port, uint8_t data)
{
    __asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  8000ba:	0f b6 45 f3          	movzbl -0xd(%rbp),%eax
  8000be:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8000c1:	ee                   	out    %al,(%dx)

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
  8000c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8000c9:	eb 04                	jmp    8000cf <ide_probe_disk1+0x39>
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
	     x++)
  8000cb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
  8000cf:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%rbp)
  8000d6:	7f 26                	jg     8000fe <ide_probe_disk1+0x68>
  8000d8:	c7 45 ec f7 01 00 00 	movl   $0x1f7,-0x14(%rbp)

    static __inline uint8_t
inb(int port)
{
    uint8_t data;
    __asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  8000df:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000e2:	89 c2                	mov    %eax,%edx
  8000e4:	ec                   	in     (%dx),%al
  8000e5:	88 45 eb             	mov    %al,-0x15(%rbp)
    return data;
  8000e8:	0f b6 45 eb          	movzbl -0x15(%rbp),%eax
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
  8000ec:	0f b6 c0             	movzbl %al,%eax
  8000ef:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000f2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000f5:	25 a1 00 00 00       	and    $0xa1,%eax
  8000fa:	85 c0                	test   %eax,%eax
  8000fc:	75 cd                	jne    8000cb <ide_probe_disk1+0x35>
  8000fe:	c7 45 e4 f6 01 00 00 	movl   $0x1f6,-0x1c(%rbp)
  800105:	c6 45 e3 e0          	movb   $0xe0,-0x1d(%rbp)
}

    static __inline void
outb(int port, uint8_t data)
{
    __asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800109:	0f b6 45 e3          	movzbl -0x1d(%rbp),%eax
  80010d:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800110:	ee                   	out    %al,(%dx)
		/* do nothing */;

	// switch back to Device 0
	outb(0x1F6, 0xE0 | (0<<4));

	cprintf("Device 1 presence: %d\n", (x < 1000));
  800111:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%rbp)
  800118:	0f 9e c0             	setle  %al
  80011b:	0f b6 c0             	movzbl %al,%eax
  80011e:	89 c6                	mov    %eax,%esi
  800120:	48 bf a0 6b 80 00 00 	movabs $0x806ba0,%rdi
  800127:	00 00 00 
  80012a:	b8 00 00 00 00       	mov    $0x0,%eax
  80012f:	48 ba 1d 37 80 00 00 	movabs $0x80371d,%rdx
  800136:	00 00 00 
  800139:	ff d2                	callq  *%rdx
	return (x < 1000);
  80013b:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%rbp)
  800142:	0f 9e c0             	setle  %al
}
  800145:	c9                   	leaveq 
  800146:	c3                   	retq   

0000000000800147 <ide_set_disk>:

void
ide_set_disk(int d)
{
  800147:	55                   	push   %rbp
  800148:	48 89 e5             	mov    %rsp,%rbp
  80014b:	48 83 ec 10          	sub    $0x10,%rsp
  80014f:	89 7d fc             	mov    %edi,-0x4(%rbp)
	if (d != 0 && d != 1)
  800152:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800156:	74 30                	je     800188 <ide_set_disk+0x41>
  800158:	83 7d fc 01          	cmpl   $0x1,-0x4(%rbp)
  80015c:	74 2a                	je     800188 <ide_set_disk+0x41>
		panic("bad disk number");
  80015e:	48 ba b7 6b 80 00 00 	movabs $0x806bb7,%rdx
  800165:	00 00 00 
  800168:	be 3a 00 00 00       	mov    $0x3a,%esi
  80016d:	48 bf c7 6b 80 00 00 	movabs $0x806bc7,%rdi
  800174:	00 00 00 
  800177:	b8 00 00 00 00       	mov    $0x0,%eax
  80017c:	48 b9 e4 34 80 00 00 	movabs $0x8034e4,%rcx
  800183:	00 00 00 
  800186:	ff d1                	callq  *%rcx
	diskno = d;
  800188:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80018f:	00 00 00 
  800192:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800195:	89 10                	mov    %edx,(%rax)
}
  800197:	c9                   	leaveq 
  800198:	c3                   	retq   

0000000000800199 <ide_read>:

int
ide_read(uint32_t secno, void *dst, size_t nsecs)
{
  800199:	55                   	push   %rbp
  80019a:	48 89 e5             	mov    %rsp,%rbp
  80019d:	48 83 ec 70          	sub    $0x70,%rsp
  8001a1:	89 7d ac             	mov    %edi,-0x54(%rbp)
  8001a4:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8001a8:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
	int r;

	assert(nsecs <= 256);
  8001ac:	48 81 7d 98 00 01 00 	cmpq   $0x100,-0x68(%rbp)
  8001b3:	00 
  8001b4:	76 35                	jbe    8001eb <ide_read+0x52>
  8001b6:	48 b9 d0 6b 80 00 00 	movabs $0x806bd0,%rcx
  8001bd:	00 00 00 
  8001c0:	48 ba dd 6b 80 00 00 	movabs $0x806bdd,%rdx
  8001c7:	00 00 00 
  8001ca:	be 43 00 00 00       	mov    $0x43,%esi
  8001cf:	48 bf c7 6b 80 00 00 	movabs $0x806bc7,%rdi
  8001d6:	00 00 00 
  8001d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8001de:	49 b8 e4 34 80 00 00 	movabs $0x8034e4,%r8
  8001e5:	00 00 00 
  8001e8:	41 ff d0             	callq  *%r8

	ide_wait_ready(0);
  8001eb:	bf 00 00 00 00       	mov    $0x0,%edi
  8001f0:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001f7:	00 00 00 
  8001fa:	ff d0                	callq  *%rax

	outb(0x1F2, nsecs);
  8001fc:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800200:	0f b6 c0             	movzbl %al,%eax
  800203:	c7 45 f8 f2 01 00 00 	movl   $0x1f2,-0x8(%rbp)
  80020a:	88 45 f7             	mov    %al,-0x9(%rbp)
  80020d:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
  800211:	8b 55 f8             	mov    -0x8(%rbp),%edx
  800214:	ee                   	out    %al,(%dx)
	outb(0x1F3, secno & 0xFF);
  800215:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800218:	0f b6 c0             	movzbl %al,%eax
  80021b:	c7 45 f0 f3 01 00 00 	movl   $0x1f3,-0x10(%rbp)
  800222:	88 45 ef             	mov    %al,-0x11(%rbp)
  800225:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  800229:	8b 55 f0             	mov    -0x10(%rbp),%edx
  80022c:	ee                   	out    %al,(%dx)
	outb(0x1F4, (secno >> 8) & 0xFF);
  80022d:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800230:	c1 e8 08             	shr    $0x8,%eax
  800233:	0f b6 c0             	movzbl %al,%eax
  800236:	c7 45 e8 f4 01 00 00 	movl   $0x1f4,-0x18(%rbp)
  80023d:	88 45 e7             	mov    %al,-0x19(%rbp)
  800240:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  800244:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800247:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  800248:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80024b:	c1 e8 10             	shr    $0x10,%eax
  80024e:	0f b6 c0             	movzbl %al,%eax
  800251:	c7 45 e0 f5 01 00 00 	movl   $0x1f5,-0x20(%rbp)
  800258:	88 45 df             	mov    %al,-0x21(%rbp)
  80025b:	0f b6 45 df          	movzbl -0x21(%rbp),%eax
  80025f:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800262:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  800263:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80026a:	00 00 00 
  80026d:	8b 00                	mov    (%rax),%eax
  80026f:	83 e0 01             	and    $0x1,%eax
  800272:	c1 e0 04             	shl    $0x4,%eax
  800275:	89 c2                	mov    %eax,%edx
  800277:	8b 45 ac             	mov    -0x54(%rbp),%eax
  80027a:	c1 e8 18             	shr    $0x18,%eax
  80027d:	83 e0 0f             	and    $0xf,%eax
  800280:	09 d0                	or     %edx,%eax
  800282:	83 c8 e0             	or     $0xffffffe0,%eax
  800285:	0f b6 c0             	movzbl %al,%eax
  800288:	c7 45 d8 f6 01 00 00 	movl   $0x1f6,-0x28(%rbp)
  80028f:	88 45 d7             	mov    %al,-0x29(%rbp)
  800292:	0f b6 45 d7          	movzbl -0x29(%rbp),%eax
  800296:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800299:	ee                   	out    %al,(%dx)
  80029a:	c7 45 d0 f7 01 00 00 	movl   $0x1f7,-0x30(%rbp)
  8002a1:	c6 45 cf 20          	movb   $0x20,-0x31(%rbp)
  8002a5:	0f b6 45 cf          	movzbl -0x31(%rbp),%eax
  8002a9:	8b 55 d0             	mov    -0x30(%rbp),%edx
  8002ac:	ee                   	out    %al,(%dx)
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  8002ad:	eb 64                	jmp    800313 <ide_read+0x17a>
		if ((r = ide_wait_ready(1)) < 0)
  8002af:	bf 01 00 00 00       	mov    $0x1,%edi
  8002b4:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8002bb:	00 00 00 
  8002be:	ff d0                	callq  *%rax
  8002c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8002c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8002c7:	79 05                	jns    8002ce <ide_read+0x135>
			return r;
  8002c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002cc:	eb 51                	jmp    80031f <ide_read+0x186>
  8002ce:	c7 45 c8 f0 01 00 00 	movl   $0x1f0,-0x38(%rbp)
  8002d5:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  8002d9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8002dd:	c7 45 bc 00 01 00 00 	movl   $0x100,-0x44(%rbp)
}

    static __inline void
insw(int port, void *addr, int cnt)
{
    __asm __volatile("cld\n\trepne\n\tinsw"			:
  8002e4:	8b 55 c8             	mov    -0x38(%rbp),%edx
  8002e7:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  8002eb:	8b 45 bc             	mov    -0x44(%rbp),%eax
  8002ee:	48 89 ce             	mov    %rcx,%rsi
  8002f1:	48 89 f7             	mov    %rsi,%rdi
  8002f4:	89 c1                	mov    %eax,%ecx
  8002f6:	fc                   	cld    
  8002f7:	f2 66 6d             	repnz insw (%dx),%es:(%rdi)
  8002fa:	89 c8                	mov    %ecx,%eax
  8002fc:	48 89 fe             	mov    %rdi,%rsi
  8002ff:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  800303:	89 45 bc             	mov    %eax,-0x44(%rbp)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  800306:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80030b:	48 81 45 a0 00 02 00 	addq   $0x200,-0x60(%rbp)
  800312:	00 
  800313:	48 83 7d 98 00       	cmpq   $0x0,-0x68(%rbp)
  800318:	75 95                	jne    8002af <ide_read+0x116>
		if ((r = ide_wait_ready(1)) < 0)
			return r;
		insw(0x1F0, dst, SECTSIZE/2);
	}

	return 0;
  80031a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80031f:	c9                   	leaveq 
  800320:	c3                   	retq   

0000000000800321 <ide_write>:

int
ide_write(uint32_t secno, const void *src, size_t nsecs)
{
  800321:	55                   	push   %rbp
  800322:	48 89 e5             	mov    %rsp,%rbp
  800325:	48 83 ec 70          	sub    $0x70,%rsp
  800329:	89 7d ac             	mov    %edi,-0x54(%rbp)
  80032c:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800330:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
	int r;

	assert(nsecs <= 256);
  800334:	48 81 7d 98 00 01 00 	cmpq   $0x100,-0x68(%rbp)
  80033b:	00 
  80033c:	76 35                	jbe    800373 <ide_write+0x52>
  80033e:	48 b9 d0 6b 80 00 00 	movabs $0x806bd0,%rcx
  800345:	00 00 00 
  800348:	48 ba dd 6b 80 00 00 	movabs $0x806bdd,%rdx
  80034f:	00 00 00 
  800352:	be 5c 00 00 00       	mov    $0x5c,%esi
  800357:	48 bf c7 6b 80 00 00 	movabs $0x806bc7,%rdi
  80035e:	00 00 00 
  800361:	b8 00 00 00 00       	mov    $0x0,%eax
  800366:	49 b8 e4 34 80 00 00 	movabs $0x8034e4,%r8
  80036d:	00 00 00 
  800370:	41 ff d0             	callq  *%r8

	ide_wait_ready(0);
  800373:	bf 00 00 00 00       	mov    $0x0,%edi
  800378:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80037f:	00 00 00 
  800382:	ff d0                	callq  *%rax

	outb(0x1F2, nsecs);
  800384:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800388:	0f b6 c0             	movzbl %al,%eax
  80038b:	c7 45 f8 f2 01 00 00 	movl   $0x1f2,-0x8(%rbp)
  800392:	88 45 f7             	mov    %al,-0x9(%rbp)
}

    static __inline void
outb(int port, uint8_t data)
{
    __asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800395:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
  800399:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80039c:	ee                   	out    %al,(%dx)
	outb(0x1F3, secno & 0xFF);
  80039d:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8003a0:	0f b6 c0             	movzbl %al,%eax
  8003a3:	c7 45 f0 f3 01 00 00 	movl   $0x1f3,-0x10(%rbp)
  8003aa:	88 45 ef             	mov    %al,-0x11(%rbp)
  8003ad:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8003b1:	8b 55 f0             	mov    -0x10(%rbp),%edx
  8003b4:	ee                   	out    %al,(%dx)
	outb(0x1F4, (secno >> 8) & 0xFF);
  8003b5:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8003b8:	c1 e8 08             	shr    $0x8,%eax
  8003bb:	0f b6 c0             	movzbl %al,%eax
  8003be:	c7 45 e8 f4 01 00 00 	movl   $0x1f4,-0x18(%rbp)
  8003c5:	88 45 e7             	mov    %al,-0x19(%rbp)
  8003c8:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
  8003cc:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8003cf:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  8003d0:	8b 45 ac             	mov    -0x54(%rbp),%eax
  8003d3:	c1 e8 10             	shr    $0x10,%eax
  8003d6:	0f b6 c0             	movzbl %al,%eax
  8003d9:	c7 45 e0 f5 01 00 00 	movl   $0x1f5,-0x20(%rbp)
  8003e0:	88 45 df             	mov    %al,-0x21(%rbp)
  8003e3:	0f b6 45 df          	movzbl -0x21(%rbp),%eax
  8003e7:	8b 55 e0             	mov    -0x20(%rbp),%edx
  8003ea:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  8003eb:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8003f2:	00 00 00 
  8003f5:	8b 00                	mov    (%rax),%eax
  8003f7:	83 e0 01             	and    $0x1,%eax
  8003fa:	c1 e0 04             	shl    $0x4,%eax
  8003fd:	89 c2                	mov    %eax,%edx
  8003ff:	8b 45 ac             	mov    -0x54(%rbp),%eax
  800402:	c1 e8 18             	shr    $0x18,%eax
  800405:	83 e0 0f             	and    $0xf,%eax
  800408:	09 d0                	or     %edx,%eax
  80040a:	83 c8 e0             	or     $0xffffffe0,%eax
  80040d:	0f b6 c0             	movzbl %al,%eax
  800410:	c7 45 d8 f6 01 00 00 	movl   $0x1f6,-0x28(%rbp)
  800417:	88 45 d7             	mov    %al,-0x29(%rbp)
  80041a:	0f b6 45 d7          	movzbl -0x29(%rbp),%eax
  80041e:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800421:	ee                   	out    %al,(%dx)
  800422:	c7 45 d0 f7 01 00 00 	movl   $0x1f7,-0x30(%rbp)
  800429:	c6 45 cf 30          	movb   $0x30,-0x31(%rbp)
  80042d:	0f b6 45 cf          	movzbl -0x31(%rbp),%eax
  800431:	8b 55 d0             	mov    -0x30(%rbp),%edx
  800434:	ee                   	out    %al,(%dx)
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  800435:	eb 5e                	jmp    800495 <ide_write+0x174>
		if ((r = ide_wait_ready(1)) < 0)
  800437:	bf 01 00 00 00       	mov    $0x1,%edi
  80043c:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800443:	00 00 00 
  800446:	ff d0                	callq  *%rax
  800448:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80044b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80044f:	79 05                	jns    800456 <ide_write+0x135>
			return r;
  800451:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800454:	eb 4b                	jmp    8004a1 <ide_write+0x180>
  800456:	c7 45 c8 f0 01 00 00 	movl   $0x1f0,-0x38(%rbp)
  80045d:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
  800461:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  800465:	c7 45 bc 00 01 00 00 	movl   $0x100,-0x44(%rbp)
}

    static __inline void
outsw(int port, const void *addr, int cnt)
{
    __asm __volatile("cld\n\trepne\n\toutsw"		:
  80046c:	8b 55 c8             	mov    -0x38(%rbp),%edx
  80046f:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  800473:	8b 45 bc             	mov    -0x44(%rbp),%eax
  800476:	48 89 ce             	mov    %rcx,%rsi
  800479:	89 c1                	mov    %eax,%ecx
  80047b:	fc                   	cld    
  80047c:	f2 66 6f             	repnz outsw %ds:(%rsi),(%dx)
  80047f:	89 c8                	mov    %ecx,%eax
  800481:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  800485:	89 45 bc             	mov    %eax,-0x44(%rbp)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  800488:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80048d:	48 81 45 a0 00 02 00 	addq   $0x200,-0x60(%rbp)
  800494:	00 
  800495:	48 83 7d 98 00       	cmpq   $0x0,-0x68(%rbp)
  80049a:	75 9b                	jne    800437 <ide_write+0x116>
		if ((r = ide_wait_ready(1)) < 0)
			return r;
		outsw(0x1F0, src, SECTSIZE/2);
	}

	return 0;
  80049c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004a1:	c9                   	leaveq 
  8004a2:	c3                   	retq   

00000000008004a3 <diskaddr>:
#include "fs.h"

// Return the virtual address of this disk block.
void*
diskaddr(uint64_t blockno)
{
  8004a3:	55                   	push   %rbp
  8004a4:	48 89 e5             	mov    %rsp,%rbp
  8004a7:	48 83 ec 10          	sub    $0x10,%rsp
  8004ab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (blockno == 0 || (super && blockno >= super->s_nblocks))
  8004af:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8004b4:	74 2a                	je     8004e0 <diskaddr+0x3d>
  8004b6:	48 b8 18 40 81 00 00 	movabs $0x814018,%rax
  8004bd:	00 00 00 
  8004c0:	48 8b 00             	mov    (%rax),%rax
  8004c3:	48 85 c0             	test   %rax,%rax
  8004c6:	74 4a                	je     800512 <diskaddr+0x6f>
  8004c8:	48 b8 18 40 81 00 00 	movabs $0x814018,%rax
  8004cf:	00 00 00 
  8004d2:	48 8b 00             	mov    (%rax),%rax
  8004d5:	8b 40 04             	mov    0x4(%rax),%eax
  8004d8:	89 c0                	mov    %eax,%eax
  8004da:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8004de:	77 32                	ja     800512 <diskaddr+0x6f>
		panic("bad block number %08x in diskaddr", blockno);
  8004e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004e4:	48 89 c1             	mov    %rax,%rcx
  8004e7:	48 ba f8 6b 80 00 00 	movabs $0x806bf8,%rdx
  8004ee:	00 00 00 
  8004f1:	be 09 00 00 00       	mov    $0x9,%esi
  8004f6:	48 bf 1a 6c 80 00 00 	movabs $0x806c1a,%rdi
  8004fd:	00 00 00 
  800500:	b8 00 00 00 00       	mov    $0x0,%eax
  800505:	49 b8 e4 34 80 00 00 	movabs $0x8034e4,%r8
  80050c:	00 00 00 
  80050f:	41 ff d0             	callq  *%r8
	return (char*) (DISKMAP + blockno * BLKSIZE);
  800512:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800516:	48 05 00 00 01 00    	add    $0x10000,%rax
  80051c:	48 c1 e0 0c          	shl    $0xc,%rax
}
  800520:	c9                   	leaveq 
  800521:	c3                   	retq   

0000000000800522 <va_is_mapped>:

// Is this virtual address mapped?
bool
va_is_mapped(void *va)
{
  800522:	55                   	push   %rbp
  800523:	48 89 e5             	mov    %rsp,%rbp
  800526:	48 83 ec 08          	sub    $0x8,%rsp
  80052a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (uvpml4e[VPML4E(va)] & PTE_P) && (uvpde[VPDPE(va)] & PTE_P) && (uvpd[VPD(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P);
  80052e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800532:	48 c1 e8 27          	shr    $0x27,%rax
  800536:	48 89 c2             	mov    %rax,%rdx
  800539:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  800540:	01 00 00 
  800543:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800547:	83 e0 01             	and    $0x1,%eax
  80054a:	48 85 c0             	test   %rax,%rax
  80054d:	74 6a                	je     8005b9 <va_is_mapped+0x97>
  80054f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800553:	48 c1 e8 1e          	shr    $0x1e,%rax
  800557:	48 89 c2             	mov    %rax,%rdx
  80055a:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  800561:	01 00 00 
  800564:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800568:	83 e0 01             	and    $0x1,%eax
  80056b:	48 85 c0             	test   %rax,%rax
  80056e:	74 49                	je     8005b9 <va_is_mapped+0x97>
  800570:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800574:	48 c1 e8 15          	shr    $0x15,%rax
  800578:	48 89 c2             	mov    %rax,%rdx
  80057b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800582:	01 00 00 
  800585:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800589:	83 e0 01             	and    $0x1,%eax
  80058c:	48 85 c0             	test   %rax,%rax
  80058f:	74 28                	je     8005b9 <va_is_mapped+0x97>
  800591:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800595:	48 c1 e8 0c          	shr    $0xc,%rax
  800599:	48 89 c2             	mov    %rax,%rdx
  80059c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8005a3:	01 00 00 
  8005a6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8005aa:	83 e0 01             	and    $0x1,%eax
  8005ad:	48 85 c0             	test   %rax,%rax
  8005b0:	74 07                	je     8005b9 <va_is_mapped+0x97>
  8005b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8005b7:	eb 05                	jmp    8005be <va_is_mapped+0x9c>
  8005b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8005be:	83 e0 01             	and    $0x1,%eax
}
  8005c1:	c9                   	leaveq 
  8005c2:	c3                   	retq   

00000000008005c3 <va_is_dirty>:

// Is this virtual address dirty?
bool
va_is_dirty(void *va)
{
  8005c3:	55                   	push   %rbp
  8005c4:	48 89 e5             	mov    %rsp,%rbp
  8005c7:	48 83 ec 08          	sub    $0x8,%rsp
  8005cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (uvpt[PGNUM(va)] & PTE_D) != 0;
  8005cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005d3:	48 c1 e8 0c          	shr    $0xc,%rax
  8005d7:	48 89 c2             	mov    %rax,%rdx
  8005da:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8005e1:	01 00 00 
  8005e4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8005e8:	83 e0 40             	and    $0x40,%eax
  8005eb:	48 85 c0             	test   %rax,%rax
  8005ee:	0f 95 c0             	setne  %al
}
  8005f1:	c9                   	leaveq 
  8005f2:	c3                   	retq   

00000000008005f3 <bc_pgfault>:
// Fault any disk block that is read in to memory by
// loading it from disk.
// Hint: Use ide_read and BLKSECTS.
static void
bc_pgfault(struct UTrapframe *utf)
{
  8005f3:	55                   	push   %rbp
  8005f4:	48 89 e5             	mov    %rsp,%rbp
  8005f7:	48 83 ec 40          	sub    $0x40,%rsp
  8005fb:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  8005ff:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800603:	48 8b 00             	mov    (%rax),%rax
  800606:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint64_t blockno = ((uint64_t)addr - DISKMAP) / BLKSIZE;
  80060a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80060e:	48 2d 00 00 00 10    	sub    $0x10000000,%rax
  800614:	48 c1 e8 0c          	shr    $0xc,%rax
  800618:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	int r;

	// Check that the fault was within the block cache region
	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  80061c:	48 81 7d f8 ff ff ff 	cmpq   $0xfffffff,-0x8(%rbp)
  800623:	0f 
  800624:	76 0b                	jbe    800631 <bc_pgfault+0x3e>
  800626:	b8 ff ff ff cf       	mov    $0xcfffffff,%eax
  80062b:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  80062f:	76 4b                	jbe    80067c <bc_pgfault+0x89>
		panic("page fault in FS: eip %08x, va %08x, err %04x",
  800631:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800635:	48 8b 48 08          	mov    0x8(%rax),%rcx
  800639:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80063d:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
  800644:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800648:	49 89 c9             	mov    %rcx,%r9
  80064b:	49 89 d0             	mov    %rdx,%r8
  80064e:	48 89 c1             	mov    %rax,%rcx
  800651:	48 ba 28 6c 80 00 00 	movabs $0x806c28,%rdx
  800658:	00 00 00 
  80065b:	be 28 00 00 00       	mov    $0x28,%esi
  800660:	48 bf 1a 6c 80 00 00 	movabs $0x806c1a,%rdi
  800667:	00 00 00 
  80066a:	b8 00 00 00 00       	mov    $0x0,%eax
  80066f:	49 ba e4 34 80 00 00 	movabs $0x8034e4,%r10
  800676:	00 00 00 
  800679:	41 ff d2             	callq  *%r10
		      utf->utf_rip, addr, utf->utf_err);

	// Sanity check the block number.
	if (super && blockno >= super->s_nblocks)
  80067c:	48 b8 18 40 81 00 00 	movabs $0x814018,%rax
  800683:	00 00 00 
  800686:	48 8b 00             	mov    (%rax),%rax
  800689:	48 85 c0             	test   %rax,%rax
  80068c:	74 4a                	je     8006d8 <bc_pgfault+0xe5>
  80068e:	48 b8 18 40 81 00 00 	movabs $0x814018,%rax
  800695:	00 00 00 
  800698:	48 8b 00             	mov    (%rax),%rax
  80069b:	8b 40 04             	mov    0x4(%rax),%eax
  80069e:	89 c0                	mov    %eax,%eax
  8006a0:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8006a4:	77 32                	ja     8006d8 <bc_pgfault+0xe5>
		panic("reading non-existent block %08x\n", blockno);
  8006a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006aa:	48 89 c1             	mov    %rax,%rcx
  8006ad:	48 ba 58 6c 80 00 00 	movabs $0x806c58,%rdx
  8006b4:	00 00 00 
  8006b7:	be 2c 00 00 00       	mov    $0x2c,%esi
  8006bc:	48 bf 1a 6c 80 00 00 	movabs $0x806c1a,%rdi
  8006c3:	00 00 00 
  8006c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8006cb:	49 b8 e4 34 80 00 00 	movabs $0x8034e4,%r8
  8006d2:	00 00 00 
  8006d5:	41 ff d0             	callq  *%r8
	// Allocate a page in the disk map region, read the contents
	// of the block from the disk into that page.
	// Hint: first round addr to page boundary.
	//
	// LAB 5: your code here:
	if ((r=sys_page_alloc(0,ROUNDDOWN(addr,PGSIZE),PTE_U|PTE_W|PTE_P))<0)
  8006d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006dc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8006e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e4:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8006ea:	ba 07 00 00 00       	mov    $0x7,%edx
  8006ef:	48 89 c6             	mov    %rax,%rsi
  8006f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8006f7:	48 b8 42 4c 80 00 00 	movabs $0x804c42,%rax
  8006fe:	00 00 00 
  800701:	ff d0                	callq  *%rax
  800703:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  800706:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80070a:	79 30                	jns    80073c <bc_pgfault+0x149>
		panic("in bc_pgfault, sys_page_alloc: %e", r);
  80070c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80070f:	89 c1                	mov    %eax,%ecx
  800711:	48 ba 80 6c 80 00 00 	movabs $0x806c80,%rdx
  800718:	00 00 00 
  80071b:	be 34 00 00 00       	mov    $0x34,%esi
  800720:	48 bf 1a 6c 80 00 00 	movabs $0x806c1a,%rdi
  800727:	00 00 00 
  80072a:	b8 00 00 00 00       	mov    $0x0,%eax
  80072f:	49 b8 e4 34 80 00 00 	movabs $0x8034e4,%r8
  800736:	00 00 00 
  800739:	41 ff d0             	callq  *%r8
	if ((r=ide_read(blockno* BLKSECTS,ROUNDDOWN(addr,PGSIZE),BLKSECTS))<0)
  80073c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800740:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800744:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800748:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80074e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800752:	8d 0c d5 00 00 00 00 	lea    0x0(,%rdx,8),%ecx
  800759:	ba 08 00 00 00       	mov    $0x8,%edx
  80075e:	48 89 c6             	mov    %rax,%rsi
  800761:	89 cf                	mov    %ecx,%edi
  800763:	48 b8 99 01 80 00 00 	movabs $0x800199,%rax
  80076a:	00 00 00 
  80076d:	ff d0                	callq  *%rax
  80076f:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  800772:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800776:	79 30                	jns    8007a8 <bc_pgfault+0x1b5>
		panic("in bc_pgfault, ide_read: %e", r);
  800778:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80077b:	89 c1                	mov    %eax,%ecx
  80077d:	48 ba a2 6c 80 00 00 	movabs $0x806ca2,%rdx
  800784:	00 00 00 
  800787:	be 36 00 00 00       	mov    $0x36,%esi
  80078c:	48 bf 1a 6c 80 00 00 	movabs $0x806c1a,%rdi
  800793:	00 00 00 
  800796:	b8 00 00 00 00       	mov    $0x0,%eax
  80079b:	49 b8 e4 34 80 00 00 	movabs $0x8034e4,%r8
  8007a2:	00 00 00 
  8007a5:	41 ff d0             	callq  *%r8

	// Check that the block we read was allocated. (exercise for
	// the reader: why do we do this *after* reading the block
	// in?)
	if (bitmap && block_is_free(blockno))
  8007a8:	48 b8 10 40 81 00 00 	movabs $0x814010,%rax
  8007af:	00 00 00 
  8007b2:	48 8b 00             	mov    (%rax),%rax
  8007b5:	48 85 c0             	test   %rax,%rax
  8007b8:	74 48                	je     800802 <bc_pgfault+0x20f>
  8007ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8007be:	89 c7                	mov    %eax,%edi
  8007c0:	48 b8 bc 0c 80 00 00 	movabs $0x800cbc,%rax
  8007c7:	00 00 00 
  8007ca:	ff d0                	callq  *%rax
  8007cc:	84 c0                	test   %al,%al
  8007ce:	74 32                	je     800802 <bc_pgfault+0x20f>
		panic("reading free block %08x\n", blockno);
  8007d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8007d4:	48 89 c1             	mov    %rax,%rcx
  8007d7:	48 ba be 6c 80 00 00 	movabs $0x806cbe,%rdx
  8007de:	00 00 00 
  8007e1:	be 3c 00 00 00       	mov    $0x3c,%esi
  8007e6:	48 bf 1a 6c 80 00 00 	movabs $0x806c1a,%rdi
  8007ed:	00 00 00 
  8007f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8007f5:	49 b8 e4 34 80 00 00 	movabs $0x8034e4,%r8
  8007fc:	00 00 00 
  8007ff:	41 ff d0             	callq  *%r8
}
  800802:	c9                   	leaveq 
  800803:	c3                   	retq   

0000000000800804 <flush_block>:
// Hint: Use va_is_mapped, va_is_dirty, and ide_write.
// Hint: Use the PTE_SYSCALL constant when calling sys_page_map.
// Hint: Don't forget to round addr down.
void
flush_block(void *addr)
{
  800804:	55                   	push   %rbp
  800805:	48 89 e5             	mov    %rsp,%rbp
  800808:	48 83 ec 20          	sub    $0x20,%rsp
  80080c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t blockno = ((uint64_t)addr - DISKMAP) / BLKSIZE;
  800810:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800814:	48 2d 00 00 00 10    	sub    $0x10000000,%rax
  80081a:	48 c1 e8 0c          	shr    $0xc,%rax
  80081e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  800822:	48 81 7d e8 ff ff ff 	cmpq   $0xfffffff,-0x18(%rbp)
  800829:	0f 
  80082a:	76 0b                	jbe    800837 <flush_block+0x33>
  80082c:	b8 ff ff ff cf       	mov    $0xcfffffff,%eax
  800831:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
  800835:	76 32                	jbe    800869 <flush_block+0x65>
		panic("flush_block of bad va %08x", addr);
  800837:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80083b:	48 89 c1             	mov    %rax,%rcx
  80083e:	48 ba d7 6c 80 00 00 	movabs $0x806cd7,%rdx
  800845:	00 00 00 
  800848:	be 4c 00 00 00       	mov    $0x4c,%esi
  80084d:	48 bf 1a 6c 80 00 00 	movabs $0x806c1a,%rdi
  800854:	00 00 00 
  800857:	b8 00 00 00 00       	mov    $0x0,%eax
  80085c:	49 b8 e4 34 80 00 00 	movabs $0x8034e4,%r8
  800863:	00 00 00 
  800866:	41 ff d0             	callq  *%r8

	// LAB 5: Your code here.
	addr=ROUNDDOWN(addr,PGSIZE);
  800869:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80086d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800871:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800875:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80087b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	if (va_is_mapped(addr) && va_is_dirty(addr)){
  80087f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800883:	48 89 c7             	mov    %rax,%rdi
  800886:	48 b8 22 05 80 00 00 	movabs $0x800522,%rax
  80088d:	00 00 00 
  800890:	ff d0                	callq  *%rax
  800892:	84 c0                	test   %al,%al
  800894:	0f 84 94 00 00 00    	je     80092e <flush_block+0x12a>
  80089a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80089e:	48 89 c7             	mov    %rax,%rdi
  8008a1:	48 b8 c3 05 80 00 00 	movabs $0x8005c3,%rax
  8008a8:	00 00 00 
  8008ab:	ff d0                	callq  *%rax
  8008ad:	84 c0                	test   %al,%al
  8008af:	74 7d                	je     80092e <flush_block+0x12a>
		
		ide_write(blockno* BLKSECTS,addr,BLKSECTS);
  8008b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8008b5:	8d 0c c5 00 00 00 00 	lea    0x0(,%rax,8),%ecx
  8008bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c0:	ba 08 00 00 00       	mov    $0x8,%edx
  8008c5:	48 89 c6             	mov    %rax,%rsi
  8008c8:	89 cf                	mov    %ecx,%edi
  8008ca:	48 b8 21 03 80 00 00 	movabs $0x800321,%rax
  8008d1:	00 00 00 
  8008d4:	ff d0                	callq  *%rax

		if (sys_page_map(0,addr,0,addr,PTE_SYSCALL)<0)
  8008d6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008de:	41 b8 07 0e 00 00    	mov    $0xe07,%r8d
  8008e4:	48 89 d1             	mov    %rdx,%rcx
  8008e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ec:	48 89 c6             	mov    %rax,%rsi
  8008ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8008f4:	48 b8 92 4c 80 00 00 	movabs $0x804c92,%rax
  8008fb:	00 00 00 
  8008fe:	ff d0                	callq  *%rax
  800900:	85 c0                	test   %eax,%eax
  800902:	79 2a                	jns    80092e <flush_block+0x12a>
			panic("in flush_block: sys_page_map\n");
  800904:	48 ba f2 6c 80 00 00 	movabs $0x806cf2,%rdx
  80090b:	00 00 00 
  80090e:	be 55 00 00 00       	mov    $0x55,%esi
  800913:	48 bf 1a 6c 80 00 00 	movabs $0x806c1a,%rdi
  80091a:	00 00 00 
  80091d:	b8 00 00 00 00       	mov    $0x0,%eax
  800922:	48 b9 e4 34 80 00 00 	movabs $0x8034e4,%rcx
  800929:	00 00 00 
  80092c:	ff d1                	callq  *%rcx
	}

	//panic("flush_block not implemented");
}
  80092e:	c9                   	leaveq 
  80092f:	c3                   	retq   

0000000000800930 <check_bc>:

// Test that the block cache works, by smashing the superblock and
// reading it back.
static void
check_bc(void)
{
  800930:	55                   	push   %rbp
  800931:	48 89 e5             	mov    %rsp,%rbp
  800934:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
	struct Super backup;

	// back up super block
	memmove(&backup, diskaddr(1), sizeof backup);
  80093b:	bf 01 00 00 00       	mov    $0x1,%edi
  800940:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800947:	00 00 00 
  80094a:	ff d0                	callq  *%rax
  80094c:	48 89 c1             	mov    %rax,%rcx
  80094f:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800956:	ba 08 01 00 00       	mov    $0x108,%edx
  80095b:	48 89 ce             	mov    %rcx,%rsi
  80095e:	48 89 c7             	mov    %rax,%rdi
  800961:	48 b8 37 46 80 00 00 	movabs $0x804637,%rax
  800968:	00 00 00 
  80096b:	ff d0                	callq  *%rax

	// smash it
	strcpy(diskaddr(1), "OOPS!\n");
  80096d:	bf 01 00 00 00       	mov    $0x1,%edi
  800972:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800979:	00 00 00 
  80097c:	ff d0                	callq  *%rax
  80097e:	48 be 10 6d 80 00 00 	movabs $0x806d10,%rsi
  800985:	00 00 00 
  800988:	48 89 c7             	mov    %rax,%rdi
  80098b:	48 b8 13 43 80 00 00 	movabs $0x804313,%rax
  800992:	00 00 00 
  800995:	ff d0                	callq  *%rax
	flush_block(diskaddr(1));
  800997:	bf 01 00 00 00       	mov    $0x1,%edi
  80099c:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  8009a3:	00 00 00 
  8009a6:	ff d0                	callq  *%rax
  8009a8:	48 89 c7             	mov    %rax,%rdi
  8009ab:	48 b8 04 08 80 00 00 	movabs $0x800804,%rax
  8009b2:	00 00 00 
  8009b5:	ff d0                	callq  *%rax
	assert(va_is_mapped(diskaddr(1)));
  8009b7:	bf 01 00 00 00       	mov    $0x1,%edi
  8009bc:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  8009c3:	00 00 00 
  8009c6:	ff d0                	callq  *%rax
  8009c8:	48 89 c7             	mov    %rax,%rdi
  8009cb:	48 b8 22 05 80 00 00 	movabs $0x800522,%rax
  8009d2:	00 00 00 
  8009d5:	ff d0                	callq  *%rax
  8009d7:	83 f0 01             	xor    $0x1,%eax
  8009da:	84 c0                	test   %al,%al
  8009dc:	74 35                	je     800a13 <check_bc+0xe3>
  8009de:	48 b9 17 6d 80 00 00 	movabs $0x806d17,%rcx
  8009e5:	00 00 00 
  8009e8:	48 ba 31 6d 80 00 00 	movabs $0x806d31,%rdx
  8009ef:	00 00 00 
  8009f2:	be 68 00 00 00       	mov    $0x68,%esi
  8009f7:	48 bf 1a 6c 80 00 00 	movabs $0x806c1a,%rdi
  8009fe:	00 00 00 
  800a01:	b8 00 00 00 00       	mov    $0x0,%eax
  800a06:	49 b8 e4 34 80 00 00 	movabs $0x8034e4,%r8
  800a0d:	00 00 00 
  800a10:	41 ff d0             	callq  *%r8
	assert(!va_is_dirty(diskaddr(1)));
  800a13:	bf 01 00 00 00       	mov    $0x1,%edi
  800a18:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800a1f:	00 00 00 
  800a22:	ff d0                	callq  *%rax
  800a24:	48 89 c7             	mov    %rax,%rdi
  800a27:	48 b8 c3 05 80 00 00 	movabs $0x8005c3,%rax
  800a2e:	00 00 00 
  800a31:	ff d0                	callq  *%rax
  800a33:	84 c0                	test   %al,%al
  800a35:	74 35                	je     800a6c <check_bc+0x13c>
  800a37:	48 b9 46 6d 80 00 00 	movabs $0x806d46,%rcx
  800a3e:	00 00 00 
  800a41:	48 ba 31 6d 80 00 00 	movabs $0x806d31,%rdx
  800a48:	00 00 00 
  800a4b:	be 69 00 00 00       	mov    $0x69,%esi
  800a50:	48 bf 1a 6c 80 00 00 	movabs $0x806c1a,%rdi
  800a57:	00 00 00 
  800a5a:	b8 00 00 00 00       	mov    $0x0,%eax
  800a5f:	49 b8 e4 34 80 00 00 	movabs $0x8034e4,%r8
  800a66:	00 00 00 
  800a69:	41 ff d0             	callq  *%r8

	// clear it out
	sys_page_unmap(0, diskaddr(1));
  800a6c:	bf 01 00 00 00       	mov    $0x1,%edi
  800a71:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800a78:	00 00 00 
  800a7b:	ff d0                	callq  *%rax
  800a7d:	48 89 c6             	mov    %rax,%rsi
  800a80:	bf 00 00 00 00       	mov    $0x0,%edi
  800a85:	48 b8 ed 4c 80 00 00 	movabs $0x804ced,%rax
  800a8c:	00 00 00 
  800a8f:	ff d0                	callq  *%rax
	assert(!va_is_mapped(diskaddr(1)));
  800a91:	bf 01 00 00 00       	mov    $0x1,%edi
  800a96:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800a9d:	00 00 00 
  800aa0:	ff d0                	callq  *%rax
  800aa2:	48 89 c7             	mov    %rax,%rdi
  800aa5:	48 b8 22 05 80 00 00 	movabs $0x800522,%rax
  800aac:	00 00 00 
  800aaf:	ff d0                	callq  *%rax
  800ab1:	84 c0                	test   %al,%al
  800ab3:	74 35                	je     800aea <check_bc+0x1ba>
  800ab5:	48 b9 60 6d 80 00 00 	movabs $0x806d60,%rcx
  800abc:	00 00 00 
  800abf:	48 ba 31 6d 80 00 00 	movabs $0x806d31,%rdx
  800ac6:	00 00 00 
  800ac9:	be 6d 00 00 00       	mov    $0x6d,%esi
  800ace:	48 bf 1a 6c 80 00 00 	movabs $0x806c1a,%rdi
  800ad5:	00 00 00 
  800ad8:	b8 00 00 00 00       	mov    $0x0,%eax
  800add:	49 b8 e4 34 80 00 00 	movabs $0x8034e4,%r8
  800ae4:	00 00 00 
  800ae7:	41 ff d0             	callq  *%r8

	// read it back in
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  800aea:	bf 01 00 00 00       	mov    $0x1,%edi
  800aef:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800af6:	00 00 00 
  800af9:	ff d0                	callq  *%rax
  800afb:	48 be 10 6d 80 00 00 	movabs $0x806d10,%rsi
  800b02:	00 00 00 
  800b05:	48 89 c7             	mov    %rax,%rdi
  800b08:	48 b8 75 44 80 00 00 	movabs $0x804475,%rax
  800b0f:	00 00 00 
  800b12:	ff d0                	callq  *%rax
  800b14:	85 c0                	test   %eax,%eax
  800b16:	74 35                	je     800b4d <check_bc+0x21d>
  800b18:	48 b9 80 6d 80 00 00 	movabs $0x806d80,%rcx
  800b1f:	00 00 00 
  800b22:	48 ba 31 6d 80 00 00 	movabs $0x806d31,%rdx
  800b29:	00 00 00 
  800b2c:	be 70 00 00 00       	mov    $0x70,%esi
  800b31:	48 bf 1a 6c 80 00 00 	movabs $0x806c1a,%rdi
  800b38:	00 00 00 
  800b3b:	b8 00 00 00 00       	mov    $0x0,%eax
  800b40:	49 b8 e4 34 80 00 00 	movabs $0x8034e4,%r8
  800b47:	00 00 00 
  800b4a:	41 ff d0             	callq  *%r8

	// fix it
	memmove(diskaddr(1), &backup, sizeof backup);
  800b4d:	bf 01 00 00 00       	mov    $0x1,%edi
  800b52:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800b59:	00 00 00 
  800b5c:	ff d0                	callq  *%rax
  800b5e:	48 8d 8d f0 fe ff ff 	lea    -0x110(%rbp),%rcx
  800b65:	ba 08 01 00 00       	mov    $0x108,%edx
  800b6a:	48 89 ce             	mov    %rcx,%rsi
  800b6d:	48 89 c7             	mov    %rax,%rdi
  800b70:	48 b8 37 46 80 00 00 	movabs $0x804637,%rax
  800b77:	00 00 00 
  800b7a:	ff d0                	callq  *%rax
	flush_block(diskaddr(1));
  800b7c:	bf 01 00 00 00       	mov    $0x1,%edi
  800b81:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800b88:	00 00 00 
  800b8b:	ff d0                	callq  *%rax
  800b8d:	48 89 c7             	mov    %rax,%rdi
  800b90:	48 b8 04 08 80 00 00 	movabs $0x800804,%rax
  800b97:	00 00 00 
  800b9a:	ff d0                	callq  *%rax

	cprintf("block cache is good\n");
  800b9c:	48 bf a4 6d 80 00 00 	movabs $0x806da4,%rdi
  800ba3:	00 00 00 
  800ba6:	b8 00 00 00 00       	mov    $0x0,%eax
  800bab:	48 ba 1d 37 80 00 00 	movabs $0x80371d,%rdx
  800bb2:	00 00 00 
  800bb5:	ff d2                	callq  *%rdx
}
  800bb7:	c9                   	leaveq 
  800bb8:	c3                   	retq   

0000000000800bb9 <bc_init>:

void
bc_init(void)
{
  800bb9:	55                   	push   %rbp
  800bba:	48 89 e5             	mov    %rsp,%rbp
  800bbd:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
	struct Super super;
	set_pgfault_handler(bc_pgfault);
  800bc4:	48 bf f3 05 80 00 00 	movabs $0x8005f3,%rdi
  800bcb:	00 00 00 
  800bce:	48 b8 dd 4f 80 00 00 	movabs $0x804fdd,%rax
  800bd5:	00 00 00 
  800bd8:	ff d0                	callq  *%rax
	check_bc();
  800bda:	48 b8 30 09 80 00 00 	movabs $0x800930,%rax
  800be1:	00 00 00 
  800be4:	ff d0                	callq  *%rax

	// cache the super block by reading it once
	memmove(&super, diskaddr(1), sizeof super);
  800be6:	bf 01 00 00 00       	mov    $0x1,%edi
  800beb:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800bf2:	00 00 00 
  800bf5:	ff d0                	callq  *%rax
  800bf7:	48 89 c1             	mov    %rax,%rcx
  800bfa:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800c01:	ba 08 01 00 00       	mov    $0x108,%edx
  800c06:	48 89 ce             	mov    %rcx,%rsi
  800c09:	48 89 c7             	mov    %rax,%rdi
  800c0c:	48 b8 37 46 80 00 00 	movabs $0x804637,%rax
  800c13:	00 00 00 
  800c16:	ff d0                	callq  *%rax
}
  800c18:	c9                   	leaveq 
  800c19:	c3                   	retq   

0000000000800c1a <check_super>:
// --------------------------------------------------------------

// Validate the file system super-block.
void
check_super(void)
{
  800c1a:	55                   	push   %rbp
  800c1b:	48 89 e5             	mov    %rsp,%rbp
	if (super->s_magic != FS_MAGIC)
  800c1e:	48 b8 18 40 81 00 00 	movabs $0x814018,%rax
  800c25:	00 00 00 
  800c28:	48 8b 00             	mov    (%rax),%rax
  800c2b:	8b 00                	mov    (%rax),%eax
  800c2d:	3d ae 30 05 4a       	cmp    $0x4a0530ae,%eax
  800c32:	74 2a                	je     800c5e <check_super+0x44>
		panic("bad file system magic number");
  800c34:	48 ba b9 6d 80 00 00 	movabs $0x806db9,%rdx
  800c3b:	00 00 00 
  800c3e:	be 0e 00 00 00       	mov    $0xe,%esi
  800c43:	48 bf d6 6d 80 00 00 	movabs $0x806dd6,%rdi
  800c4a:	00 00 00 
  800c4d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c52:	48 b9 e4 34 80 00 00 	movabs $0x8034e4,%rcx
  800c59:	00 00 00 
  800c5c:	ff d1                	callq  *%rcx

	if (super->s_nblocks > DISKSIZE/BLKSIZE)
  800c5e:	48 b8 18 40 81 00 00 	movabs $0x814018,%rax
  800c65:	00 00 00 
  800c68:	48 8b 00             	mov    (%rax),%rax
  800c6b:	8b 40 04             	mov    0x4(%rax),%eax
  800c6e:	3d 00 00 0c 00       	cmp    $0xc0000,%eax
  800c73:	76 2a                	jbe    800c9f <check_super+0x85>
		panic("file system is too large");
  800c75:	48 ba de 6d 80 00 00 	movabs $0x806dde,%rdx
  800c7c:	00 00 00 
  800c7f:	be 11 00 00 00       	mov    $0x11,%esi
  800c84:	48 bf d6 6d 80 00 00 	movabs $0x806dd6,%rdi
  800c8b:	00 00 00 
  800c8e:	b8 00 00 00 00       	mov    $0x0,%eax
  800c93:	48 b9 e4 34 80 00 00 	movabs $0x8034e4,%rcx
  800c9a:	00 00 00 
  800c9d:	ff d1                	callq  *%rcx

	cprintf("superblock is good\n");
  800c9f:	48 bf f7 6d 80 00 00 	movabs $0x806df7,%rdi
  800ca6:	00 00 00 
  800ca9:	b8 00 00 00 00       	mov    $0x0,%eax
  800cae:	48 ba 1d 37 80 00 00 	movabs $0x80371d,%rdx
  800cb5:	00 00 00 
  800cb8:	ff d2                	callq  *%rdx
}
  800cba:	5d                   	pop    %rbp
  800cbb:	c3                   	retq   

0000000000800cbc <block_is_free>:

// Check to see if the block bitmap indicates that block 'blockno' is free.
// Return 1 if the block is free, 0 if not.
bool
block_is_free(uint32_t blockno)
{
  800cbc:	55                   	push   %rbp
  800cbd:	48 89 e5             	mov    %rsp,%rbp
  800cc0:	48 83 ec 04          	sub    $0x4,%rsp
  800cc4:	89 7d fc             	mov    %edi,-0x4(%rbp)
	if (super == 0 || blockno >= super->s_nblocks)
  800cc7:	48 b8 18 40 81 00 00 	movabs $0x814018,%rax
  800cce:	00 00 00 
  800cd1:	48 8b 00             	mov    (%rax),%rax
  800cd4:	48 85 c0             	test   %rax,%rax
  800cd7:	74 15                	je     800cee <block_is_free+0x32>
  800cd9:	48 b8 18 40 81 00 00 	movabs $0x814018,%rax
  800ce0:	00 00 00 
  800ce3:	48 8b 00             	mov    (%rax),%rax
  800ce6:	8b 40 04             	mov    0x4(%rax),%eax
  800ce9:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  800cec:	77 07                	ja     800cf5 <block_is_free+0x39>
		return 0;
  800cee:	b8 00 00 00 00       	mov    $0x0,%eax
  800cf3:	eb 41                	jmp    800d36 <block_is_free+0x7a>
	if (bitmap[blockno / 32] & (1 << (blockno % 32)))
  800cf5:	48 b8 10 40 81 00 00 	movabs $0x814010,%rax
  800cfc:	00 00 00 
  800cff:	48 8b 00             	mov    (%rax),%rax
  800d02:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800d05:	c1 ea 05             	shr    $0x5,%edx
  800d08:	89 d2                	mov    %edx,%edx
  800d0a:	48 c1 e2 02          	shl    $0x2,%rdx
  800d0e:	48 01 d0             	add    %rdx,%rax
  800d11:	8b 10                	mov    (%rax),%edx
  800d13:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d16:	83 e0 1f             	and    $0x1f,%eax
  800d19:	be 01 00 00 00       	mov    $0x1,%esi
  800d1e:	89 c1                	mov    %eax,%ecx
  800d20:	d3 e6                	shl    %cl,%esi
  800d22:	89 f0                	mov    %esi,%eax
  800d24:	21 d0                	and    %edx,%eax
  800d26:	85 c0                	test   %eax,%eax
  800d28:	74 07                	je     800d31 <block_is_free+0x75>
		return 1;
  800d2a:	b8 01 00 00 00       	mov    $0x1,%eax
  800d2f:	eb 05                	jmp    800d36 <block_is_free+0x7a>
	return 0;
  800d31:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d36:	c9                   	leaveq 
  800d37:	c3                   	retq   

0000000000800d38 <free_block>:

// Mark a block free in the bitmap
void
free_block(uint32_t blockno)
{
  800d38:	55                   	push   %rbp
  800d39:	48 89 e5             	mov    %rsp,%rbp
  800d3c:	48 83 ec 10          	sub    $0x10,%rsp
  800d40:	89 7d fc             	mov    %edi,-0x4(%rbp)
	// Blockno zero is the null pointer of block numbers.
	if (blockno == 0)
  800d43:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d47:	75 2a                	jne    800d73 <free_block+0x3b>
		panic("attempt to free zero block");
  800d49:	48 ba 0b 6e 80 00 00 	movabs $0x806e0b,%rdx
  800d50:	00 00 00 
  800d53:	be 2c 00 00 00       	mov    $0x2c,%esi
  800d58:	48 bf d6 6d 80 00 00 	movabs $0x806dd6,%rdi
  800d5f:	00 00 00 
  800d62:	b8 00 00 00 00       	mov    $0x0,%eax
  800d67:	48 b9 e4 34 80 00 00 	movabs $0x8034e4,%rcx
  800d6e:	00 00 00 
  800d71:	ff d1                	callq  *%rcx
	bitmap[blockno/32] |= 1<<(blockno%32);
  800d73:	48 b8 10 40 81 00 00 	movabs $0x814010,%rax
  800d7a:	00 00 00 
  800d7d:	48 8b 10             	mov    (%rax),%rdx
  800d80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d83:	c1 e8 05             	shr    $0x5,%eax
  800d86:	89 c1                	mov    %eax,%ecx
  800d88:	48 c1 e1 02          	shl    $0x2,%rcx
  800d8c:	48 8d 34 0a          	lea    (%rdx,%rcx,1),%rsi
  800d90:	48 ba 10 40 81 00 00 	movabs $0x814010,%rdx
  800d97:	00 00 00 
  800d9a:	48 8b 12             	mov    (%rdx),%rdx
  800d9d:	89 c0                	mov    %eax,%eax
  800d9f:	48 c1 e0 02          	shl    $0x2,%rax
  800da3:	48 01 d0             	add    %rdx,%rax
  800da6:	8b 10                	mov    (%rax),%edx
  800da8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800dab:	83 e0 1f             	and    $0x1f,%eax
  800dae:	bf 01 00 00 00       	mov    $0x1,%edi
  800db3:	89 c1                	mov    %eax,%ecx
  800db5:	d3 e7                	shl    %cl,%edi
  800db7:	89 f8                	mov    %edi,%eax
  800db9:	09 d0                	or     %edx,%eax
  800dbb:	89 06                	mov    %eax,(%rsi)
}
  800dbd:	c9                   	leaveq 
  800dbe:	c3                   	retq   

0000000000800dbf <alloc_block>:
// -E_NO_DISK if we are out of blocks.
//
// Hint: use free_block as an example for manipulating the bitmap.
int
alloc_block(void)
{
  800dbf:	55                   	push   %rbp
  800dc0:	48 89 e5             	mov    %rsp,%rbp
  800dc3:	48 83 ec 10          	sub    $0x10,%rsp
	// contains the in-use bits for BLKBITSIZE blocks.  There are
	// super->s_nblocks blocks in the disk altogether.

	// LAB 5: Your code here.
	uint32_t i;
	for(i = 1; i < super->s_nblocks; i++)
  800dc7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  800dce:	e9 88 00 00 00       	jmpq   800e5b <alloc_block+0x9c>
	{
		if(block_is_free(i))
  800dd3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800dd6:	89 c7                	mov    %eax,%edi
  800dd8:	48 b8 bc 0c 80 00 00 	movabs $0x800cbc,%rax
  800ddf:	00 00 00 
  800de2:	ff d0                	callq  *%rax
  800de4:	84 c0                	test   %al,%al
  800de6:	74 6f                	je     800e57 <alloc_block+0x98>
		{
			bitmap[i/32] ^= (1 << (i%32));
  800de8:	48 b8 10 40 81 00 00 	movabs $0x814010,%rax
  800def:	00 00 00 
  800df2:	48 8b 10             	mov    (%rax),%rdx
  800df5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800df8:	c1 e8 05             	shr    $0x5,%eax
  800dfb:	89 c1                	mov    %eax,%ecx
  800dfd:	48 c1 e1 02          	shl    $0x2,%rcx
  800e01:	48 8d 34 0a          	lea    (%rdx,%rcx,1),%rsi
  800e05:	48 ba 10 40 81 00 00 	movabs $0x814010,%rdx
  800e0c:	00 00 00 
  800e0f:	48 8b 12             	mov    (%rdx),%rdx
  800e12:	89 c0                	mov    %eax,%eax
  800e14:	48 c1 e0 02          	shl    $0x2,%rax
  800e18:	48 01 d0             	add    %rdx,%rax
  800e1b:	8b 10                	mov    (%rax),%edx
  800e1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e20:	83 e0 1f             	and    $0x1f,%eax
  800e23:	bf 01 00 00 00       	mov    $0x1,%edi
  800e28:	89 c1                	mov    %eax,%ecx
  800e2a:	d3 e7                	shl    %cl,%edi
  800e2c:	89 f8                	mov    %edi,%eax
  800e2e:	31 d0                	xor    %edx,%eax
  800e30:	89 06                	mov    %eax,(%rsi)
			flush_block(diskaddr(2));
  800e32:	bf 02 00 00 00       	mov    $0x2,%edi
  800e37:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800e3e:	00 00 00 
  800e41:	ff d0                	callq  *%rax
  800e43:	48 89 c7             	mov    %rax,%rdi
  800e46:	48 b8 04 08 80 00 00 	movabs $0x800804,%rax
  800e4d:	00 00 00 
  800e50:	ff d0                	callq  *%rax
			return i;
  800e52:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e55:	eb 22                	jmp    800e79 <alloc_block+0xba>
	// contains the in-use bits for BLKBITSIZE blocks.  There are
	// super->s_nblocks blocks in the disk altogether.

	// LAB 5: Your code here.
	uint32_t i;
	for(i = 1; i < super->s_nblocks; i++)
  800e57:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800e5b:	48 b8 18 40 81 00 00 	movabs $0x814018,%rax
  800e62:	00 00 00 
  800e65:	48 8b 00             	mov    (%rax),%rax
  800e68:	8b 40 04             	mov    0x4(%rax),%eax
  800e6b:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  800e6e:	0f 87 5f ff ff ff    	ja     800dd3 <alloc_block+0x14>
			flush_block(diskaddr(2));
			return i;
		}
	} 
	// //panic("alloc_block not implemented");
	return -E_NO_DISK;
  800e74:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800e79:	c9                   	leaveq 
  800e7a:	c3                   	retq   

0000000000800e7b <check_bitmap>:
//
// Check that all reserved blocks -- 0, 1, and the bitmap blocks themselves --
// are all marked as in-use.
void
check_bitmap(void)
{
  800e7b:	55                   	push   %rbp
  800e7c:	48 89 e5             	mov    %rsp,%rbp
  800e7f:	48 83 ec 10          	sub    $0x10,%rsp
	uint32_t i;

	// Make sure all bitmap blocks are marked in-use
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  800e83:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e8a:	eb 51                	jmp    800edd <check_bitmap+0x62>
		assert(!block_is_free(2+i));
  800e8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e8f:	83 c0 02             	add    $0x2,%eax
  800e92:	89 c7                	mov    %eax,%edi
  800e94:	48 b8 bc 0c 80 00 00 	movabs $0x800cbc,%rax
  800e9b:	00 00 00 
  800e9e:	ff d0                	callq  *%rax
  800ea0:	84 c0                	test   %al,%al
  800ea2:	74 35                	je     800ed9 <check_bitmap+0x5e>
  800ea4:	48 b9 26 6e 80 00 00 	movabs $0x806e26,%rcx
  800eab:	00 00 00 
  800eae:	48 ba 3a 6e 80 00 00 	movabs $0x806e3a,%rdx
  800eb5:	00 00 00 
  800eb8:	be 59 00 00 00       	mov    $0x59,%esi
  800ebd:	48 bf d6 6d 80 00 00 	movabs $0x806dd6,%rdi
  800ec4:	00 00 00 
  800ec7:	b8 00 00 00 00       	mov    $0x0,%eax
  800ecc:	49 b8 e4 34 80 00 00 	movabs $0x8034e4,%r8
  800ed3:	00 00 00 
  800ed6:	41 ff d0             	callq  *%r8
check_bitmap(void)
{
	uint32_t i;

	// Make sure all bitmap blocks are marked in-use
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  800ed9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800edd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800ee0:	c1 e0 0f             	shl    $0xf,%eax
  800ee3:	89 c2                	mov    %eax,%edx
  800ee5:	48 b8 18 40 81 00 00 	movabs $0x814018,%rax
  800eec:	00 00 00 
  800eef:	48 8b 00             	mov    (%rax),%rax
  800ef2:	8b 40 04             	mov    0x4(%rax),%eax
  800ef5:	39 c2                	cmp    %eax,%edx
  800ef7:	72 93                	jb     800e8c <check_bitmap+0x11>
		assert(!block_is_free(2+i));

	// Make sure the reserved and root blocks are marked in-use.
	assert(!block_is_free(0));
  800ef9:	bf 00 00 00 00       	mov    $0x0,%edi
  800efe:	48 b8 bc 0c 80 00 00 	movabs $0x800cbc,%rax
  800f05:	00 00 00 
  800f08:	ff d0                	callq  *%rax
  800f0a:	84 c0                	test   %al,%al
  800f0c:	74 35                	je     800f43 <check_bitmap+0xc8>
  800f0e:	48 b9 4f 6e 80 00 00 	movabs $0x806e4f,%rcx
  800f15:	00 00 00 
  800f18:	48 ba 3a 6e 80 00 00 	movabs $0x806e3a,%rdx
  800f1f:	00 00 00 
  800f22:	be 5c 00 00 00       	mov    $0x5c,%esi
  800f27:	48 bf d6 6d 80 00 00 	movabs $0x806dd6,%rdi
  800f2e:	00 00 00 
  800f31:	b8 00 00 00 00       	mov    $0x0,%eax
  800f36:	49 b8 e4 34 80 00 00 	movabs $0x8034e4,%r8
  800f3d:	00 00 00 
  800f40:	41 ff d0             	callq  *%r8
	assert(!block_is_free(1));
  800f43:	bf 01 00 00 00       	mov    $0x1,%edi
  800f48:	48 b8 bc 0c 80 00 00 	movabs $0x800cbc,%rax
  800f4f:	00 00 00 
  800f52:	ff d0                	callq  *%rax
  800f54:	84 c0                	test   %al,%al
  800f56:	74 35                	je     800f8d <check_bitmap+0x112>
  800f58:	48 b9 61 6e 80 00 00 	movabs $0x806e61,%rcx
  800f5f:	00 00 00 
  800f62:	48 ba 3a 6e 80 00 00 	movabs $0x806e3a,%rdx
  800f69:	00 00 00 
  800f6c:	be 5d 00 00 00       	mov    $0x5d,%esi
  800f71:	48 bf d6 6d 80 00 00 	movabs $0x806dd6,%rdi
  800f78:	00 00 00 
  800f7b:	b8 00 00 00 00       	mov    $0x0,%eax
  800f80:	49 b8 e4 34 80 00 00 	movabs $0x8034e4,%r8
  800f87:	00 00 00 
  800f8a:	41 ff d0             	callq  *%r8

	cprintf("bitmap is good\n");
  800f8d:	48 bf 73 6e 80 00 00 	movabs $0x806e73,%rdi
  800f94:	00 00 00 
  800f97:	b8 00 00 00 00       	mov    $0x0,%eax
  800f9c:	48 ba 1d 37 80 00 00 	movabs $0x80371d,%rdx
  800fa3:	00 00 00 
  800fa6:	ff d2                	callq  *%rdx
}
  800fa8:	c9                   	leaveq 
  800fa9:	c3                   	retq   

0000000000800faa <fs_init>:
// --------------------------------------------------------------

// Initialize the file system
void
fs_init(void)
{
  800faa:	55                   	push   %rbp
  800fab:	48 89 e5             	mov    %rsp,%rbp
	if (ide_probe_disk1())
		ide_set_disk(1);
	else
		ide_set_disk(0);
#else
	host_ipc_init();
  800fae:	b8 00 00 00 00       	mov    $0x0,%eax
  800fb3:	48 ba 0d 33 80 00 00 	movabs $0x80330d,%rdx
  800fba:	00 00 00 
  800fbd:	ff d2                	callq  *%rdx
#endif
	bc_init();
  800fbf:	48 b8 b9 0b 80 00 00 	movabs $0x800bb9,%rax
  800fc6:	00 00 00 
  800fc9:	ff d0                	callq  *%rax
	// Set "super" to point to the super block.
	super = diskaddr(1);
  800fcb:	bf 01 00 00 00       	mov    $0x1,%edi
  800fd0:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  800fd7:	00 00 00 
  800fda:	ff d0                	callq  *%rax
  800fdc:	48 ba 18 40 81 00 00 	movabs $0x814018,%rdx
  800fe3:	00 00 00 
  800fe6:	48 89 02             	mov    %rax,(%rdx)
	check_super();
  800fe9:	48 b8 1a 0c 80 00 00 	movabs $0x800c1a,%rax
  800ff0:	00 00 00 
  800ff3:	ff d0                	callq  *%rax

	// Set "bitmap" to the beginning of the first bitmap block.
	bitmap = diskaddr(2);
  800ff5:	bf 02 00 00 00       	mov    $0x2,%edi
  800ffa:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  801001:	00 00 00 
  801004:	ff d0                	callq  *%rax
  801006:	48 ba 10 40 81 00 00 	movabs $0x814010,%rdx
  80100d:	00 00 00 
  801010:	48 89 02             	mov    %rax,(%rdx)
	check_bitmap();
  801013:	48 b8 7b 0e 80 00 00 	movabs $0x800e7b,%rax
  80101a:	00 00 00 
  80101d:	ff d0                	callq  *%rax
}
  80101f:	5d                   	pop    %rbp
  801020:	c3                   	retq   

0000000000801021 <file_block_walk>:
//
// Analogy: This is like pgdir_walk for files.
// Hint: Don't forget to clear any block you allocate.
int
file_block_walk(struct File *f, uint32_t filebno, uint32_t **ppdiskbno, bool alloc)
{
  801021:	55                   	push   %rbp
  801022:	48 89 e5             	mov    %rsp,%rbp
  801025:	48 83 ec 30          	sub    $0x30,%rsp
  801029:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80102d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801030:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801034:	89 c8                	mov    %ecx,%eax
  801036:	88 45 e0             	mov    %al,-0x20(%rbp)
        // LAB 5: Your code here.
	if (filebno>=NDIRECT + NINDIRECT)
  801039:	81 7d e4 09 04 00 00 	cmpl   $0x409,-0x1c(%rbp)
  801040:	76 0a                	jbe    80104c <file_block_walk+0x2b>
		return -E_INVAL;
  801042:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801047:	e9 25 01 00 00       	jmpq   801171 <file_block_walk+0x150>
	if (filebno<NDIRECT){
  80104c:	83 7d e4 09          	cmpl   $0x9,-0x1c(%rbp)
  801050:	77 2b                	ja     80107d <file_block_walk+0x5c>
		*ppdiskbno = f->f_direct + filebno;
  801052:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801055:	48 83 c0 20          	add    $0x20,%rax
  801059:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
  801060:	00 
  801061:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801065:	48 01 d0             	add    %rdx,%rax
  801068:	48 8d 50 08          	lea    0x8(%rax),%rdx
  80106c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801070:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  801073:	b8 00 00 00 00       	mov    $0x0,%eax
  801078:	e9 f4 00 00 00       	jmpq   801171 <file_block_walk+0x150>
	}
	if (!alloc && !f->f_indirect)
  80107d:	0f b6 45 e0          	movzbl -0x20(%rbp),%eax
  801081:	83 f0 01             	xor    $0x1,%eax
  801084:	84 c0                	test   %al,%al
  801086:	74 18                	je     8010a0 <file_block_walk+0x7f>
  801088:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80108c:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801092:	85 c0                	test   %eax,%eax
  801094:	75 0a                	jne    8010a0 <file_block_walk+0x7f>
		return -E_NOT_FOUND;
  801096:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  80109b:	e9 d1 00 00 00       	jmpq   801171 <file_block_walk+0x150>
	int ret;
	if (!f->f_indirect)
  8010a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a4:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  8010aa:	85 c0                	test   %eax,%eax
  8010ac:	0f 85 8a 00 00 00    	jne    80113c <file_block_walk+0x11b>
	{
		if ((ret=alloc_block())<0)
  8010b2:	48 b8 bf 0d 80 00 00 	movabs $0x800dbf,%rax
  8010b9:	00 00 00 
  8010bc:	ff d0                	callq  *%rax
  8010be:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8010c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8010c5:	79 0a                	jns    8010d1 <file_block_walk+0xb0>
			return -E_NO_DISK;
  8010c7:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8010cc:	e9 a0 00 00 00       	jmpq   801171 <file_block_walk+0x150>
		f->f_indirect=ret;
  8010d1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8010d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010d8:	89 90 b0 00 00 00    	mov    %edx,0xb0(%rax)
		memset(diskaddr(f->f_indirect),0,BLKSIZE);
  8010de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010e2:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  8010e8:	89 c0                	mov    %eax,%eax
  8010ea:	48 89 c7             	mov    %rax,%rdi
  8010ed:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  8010f4:	00 00 00 
  8010f7:	ff d0                	callq  *%rax
  8010f9:	ba 00 10 00 00       	mov    $0x1000,%edx
  8010fe:	be 00 00 00 00       	mov    $0x0,%esi
  801103:	48 89 c7             	mov    %rax,%rdi
  801106:	48 b8 ac 45 80 00 00 	movabs $0x8045ac,%rax
  80110d:	00 00 00 
  801110:	ff d0                	callq  *%rax
		flush_block(diskaddr(f->f_indirect));
  801112:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801116:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  80111c:	89 c0                	mov    %eax,%eax
  80111e:	48 89 c7             	mov    %rax,%rdi
  801121:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  801128:	00 00 00 
  80112b:	ff d0                	callq  *%rax
  80112d:	48 89 c7             	mov    %rax,%rdi
  801130:	48 b8 04 08 80 00 00 	movabs $0x800804,%rax
  801137:	00 00 00 
  80113a:	ff d0                	callq  *%rax
	}

	*ppdiskbno = (uint32_t *) diskaddr (f->f_indirect) + filebno - NDIRECT;
  80113c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801140:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801146:	89 c0                	mov    %eax,%eax
  801148:	48 89 c7             	mov    %rax,%rdi
  80114b:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  801152:	00 00 00 
  801155:	ff d0                	callq  *%rax
  801157:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80115a:	48 c1 e2 02          	shl    $0x2,%rdx
  80115e:	48 83 ea 28          	sub    $0x28,%rdx
  801162:	48 01 c2             	add    %rax,%rdx
  801165:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801169:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80116c:	b8 00 00 00 00       	mov    $0x0,%eax
	panic("file_block_walk not implemented");
}
  801171:	c9                   	leaveq 
  801172:	c3                   	retq   

0000000000801173 <file_get_block>:
//	-E_NO_DISK if a block needed to be allocated but the disk is full.
//	-E_INVAL if filebno is out of range.
//
int
file_get_block(struct File *f, uint32_t filebno, char **blk)
{
  801173:	55                   	push   %rbp
  801174:	48 89 e5             	mov    %rsp,%rbp
  801177:	48 83 ec 30          	sub    $0x30,%rsp
  80117b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80117f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801182:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// LAB 5: Your code here.
	int ret;
	uint32_t *pdiskbno;
	if ((ret=file_block_walk(f,filebno,&pdiskbno,1))<0)
  801186:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80118a:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  80118d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801191:	b9 01 00 00 00       	mov    $0x1,%ecx
  801196:	48 89 c7             	mov    %rax,%rdi
  801199:	48 b8 21 10 80 00 00 	movabs $0x801021,%rax
  8011a0:	00 00 00 
  8011a3:	ff d0                	callq  *%rax
  8011a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8011a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8011ac:	79 08                	jns    8011b6 <file_get_block+0x43>
		return ret;
  8011ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011b1:	e9 ab 00 00 00       	jmpq   801261 <file_get_block+0xee>
	if (!*pdiskbno){
  8011b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011ba:	8b 00                	mov    (%rax),%eax
  8011bc:	85 c0                	test   %eax,%eax
  8011be:	75 7e                	jne    80123e <file_get_block+0xcb>
		if ((ret=alloc_block())<0)
  8011c0:	48 b8 bf 0d 80 00 00 	movabs $0x800dbf,%rax
  8011c7:	00 00 00 
  8011ca:	ff d0                	callq  *%rax
  8011cc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8011cf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8011d3:	79 0a                	jns    8011df <file_get_block+0x6c>
			return -E_NO_DISK;
  8011d5:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8011da:	e9 82 00 00 00       	jmpq   801261 <file_get_block+0xee>
		*pdiskbno=ret;
  8011df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011e3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8011e6:	89 10                	mov    %edx,(%rax)
		memset(diskaddr(*pdiskbno),0,BLKSIZE);
  8011e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011ec:	8b 00                	mov    (%rax),%eax
  8011ee:	89 c0                	mov    %eax,%eax
  8011f0:	48 89 c7             	mov    %rax,%rdi
  8011f3:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  8011fa:	00 00 00 
  8011fd:	ff d0                	callq  *%rax
  8011ff:	ba 00 10 00 00       	mov    $0x1000,%edx
  801204:	be 00 00 00 00       	mov    $0x0,%esi
  801209:	48 89 c7             	mov    %rax,%rdi
  80120c:	48 b8 ac 45 80 00 00 	movabs $0x8045ac,%rax
  801213:	00 00 00 
  801216:	ff d0                	callq  *%rax
		flush_block(diskaddr(*pdiskbno));
  801218:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80121c:	8b 00                	mov    (%rax),%eax
  80121e:	89 c0                	mov    %eax,%eax
  801220:	48 89 c7             	mov    %rax,%rdi
  801223:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  80122a:	00 00 00 
  80122d:	ff d0                	callq  *%rax
  80122f:	48 89 c7             	mov    %rax,%rdi
  801232:	48 b8 04 08 80 00 00 	movabs $0x800804,%rax
  801239:	00 00 00 
  80123c:	ff d0                	callq  *%rax
	}
	*blk = diskaddr (*pdiskbno);
  80123e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801242:	8b 00                	mov    (%rax),%eax
  801244:	89 c0                	mov    %eax,%eax
  801246:	48 89 c7             	mov    %rax,%rdi
  801249:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  801250:	00 00 00 
  801253:	ff d0                	callq  *%rax
  801255:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801259:	48 89 02             	mov    %rax,(%rdx)
	return 0;
  80125c:	b8 00 00 00 00       	mov    $0x0,%eax
		//panic("file_block_walk not implemented");
}
  801261:	c9                   	leaveq 
  801262:	c3                   	retq   

0000000000801263 <dir_lookup>:
//
// Returns 0 and sets *file on success, < 0 on error.  Errors are:
//	-E_NOT_FOUND if the file is not found
static int
dir_lookup(struct File *dir, const char *name, struct File **file)
{
  801263:	55                   	push   %rbp
  801264:	48 89 e5             	mov    %rsp,%rbp
  801267:	48 83 ec 40          	sub    $0x40,%rsp
  80126b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80126f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801273:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	struct File *f;

	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
  801277:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80127b:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801281:	25 ff 0f 00 00       	and    $0xfff,%eax
  801286:	85 c0                	test   %eax,%eax
  801288:	74 35                	je     8012bf <dir_lookup+0x5c>
  80128a:	48 b9 83 6e 80 00 00 	movabs $0x806e83,%rcx
  801291:	00 00 00 
  801294:	48 ba 3a 6e 80 00 00 	movabs $0x806e3a,%rdx
  80129b:	00 00 00 
  80129e:	be d7 00 00 00       	mov    $0xd7,%esi
  8012a3:	48 bf d6 6d 80 00 00 	movabs $0x806dd6,%rdi
  8012aa:	00 00 00 
  8012ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8012b2:	49 b8 e4 34 80 00 00 	movabs $0x8034e4,%r8
  8012b9:	00 00 00 
  8012bc:	41 ff d0             	callq  *%r8
	nblock = dir->f_size / BLKSIZE;
  8012bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012c3:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  8012c9:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  8012cf:	85 c0                	test   %eax,%eax
  8012d1:	0f 48 c2             	cmovs  %edx,%eax
  8012d4:	c1 f8 0c             	sar    $0xc,%eax
  8012d7:	89 45 f4             	mov    %eax,-0xc(%rbp)
	for (i = 0; i < nblock; i++) {
  8012da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012e1:	e9 93 00 00 00       	jmpq   801379 <dir_lookup+0x116>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  8012e6:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  8012ea:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  8012ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012f1:	89 ce                	mov    %ecx,%esi
  8012f3:	48 89 c7             	mov    %rax,%rdi
  8012f6:	48 b8 73 11 80 00 00 	movabs $0x801173,%rax
  8012fd:	00 00 00 
  801300:	ff d0                	callq  *%rax
  801302:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801305:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801309:	79 05                	jns    801310 <dir_lookup+0xad>
			return r;
  80130b:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80130e:	eb 7a                	jmp    80138a <dir_lookup+0x127>
		f = (struct File*) blk;
  801310:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801314:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		for (j = 0; j < BLKFILES; j++)
  801318:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  80131f:	eb 4e                	jmp    80136f <dir_lookup+0x10c>
			if (strcmp(f[j].f_name, name) == 0) {
  801321:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801324:	48 c1 e0 08          	shl    $0x8,%rax
  801328:	48 89 c2             	mov    %rax,%rdx
  80132b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80132f:	48 01 d0             	add    %rdx,%rax
  801332:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801336:	48 89 d6             	mov    %rdx,%rsi
  801339:	48 89 c7             	mov    %rax,%rdi
  80133c:	48 b8 75 44 80 00 00 	movabs $0x804475,%rax
  801343:	00 00 00 
  801346:	ff d0                	callq  *%rax
  801348:	85 c0                	test   %eax,%eax
  80134a:	75 1f                	jne    80136b <dir_lookup+0x108>
				*file = &f[j];
  80134c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80134f:	48 c1 e0 08          	shl    $0x8,%rax
  801353:	48 89 c2             	mov    %rax,%rdx
  801356:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80135a:	48 01 c2             	add    %rax,%rdx
  80135d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801361:	48 89 10             	mov    %rdx,(%rax)
				return 0;
  801364:	b8 00 00 00 00       	mov    $0x0,%eax
  801369:	eb 1f                	jmp    80138a <dir_lookup+0x127>
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
  80136b:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  80136f:	83 7d f8 0f          	cmpl   $0xf,-0x8(%rbp)
  801373:	76 ac                	jbe    801321 <dir_lookup+0xbe>
	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
  801375:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801379:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80137c:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80137f:	0f 82 61 ff ff ff    	jb     8012e6 <dir_lookup+0x83>
			if (strcmp(f[j].f_name, name) == 0) {
				*file = &f[j];
				return 0;
			}
		}
		return -E_NOT_FOUND;
  801385:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
	}
  80138a:	c9                   	leaveq 
  80138b:	c3                   	retq   

000000000080138c <dir_alloc_file>:

// Set *file to point at a free File structure in dir.  The caller is
// responsible for filling in the File fields.
	static int
	dir_alloc_file(struct File *dir, struct File **file)
	{
  80138c:	55                   	push   %rbp
  80138d:	48 89 e5             	mov    %rsp,%rbp
  801390:	48 83 ec 30          	sub    $0x30,%rsp
  801394:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801398:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
		int r;
		uint32_t nblock, i, j;
		char *blk;
		struct File *f;

		assert((dir->f_size % BLKSIZE) == 0);
  80139c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013a0:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  8013a6:	25 ff 0f 00 00       	and    $0xfff,%eax
  8013ab:	85 c0                	test   %eax,%eax
  8013ad:	74 35                	je     8013e4 <dir_alloc_file+0x58>
  8013af:	48 b9 83 6e 80 00 00 	movabs $0x806e83,%rcx
  8013b6:	00 00 00 
  8013b9:	48 ba 3a 6e 80 00 00 	movabs $0x806e3a,%rdx
  8013c0:	00 00 00 
  8013c3:	be f0 00 00 00       	mov    $0xf0,%esi
  8013c8:	48 bf d6 6d 80 00 00 	movabs $0x806dd6,%rdi
  8013cf:	00 00 00 
  8013d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8013d7:	49 b8 e4 34 80 00 00 	movabs $0x8034e4,%r8
  8013de:	00 00 00 
  8013e1:	41 ff d0             	callq  *%r8
		nblock = dir->f_size / BLKSIZE;
  8013e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013e8:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  8013ee:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  8013f4:	85 c0                	test   %eax,%eax
  8013f6:	0f 48 c2             	cmovs  %edx,%eax
  8013f9:	c1 f8 0c             	sar    $0xc,%eax
  8013fc:	89 45 f4             	mov    %eax,-0xc(%rbp)
		for (i = 0; i < nblock; i++) {
  8013ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801406:	e9 83 00 00 00       	jmpq   80148e <dir_alloc_file+0x102>
			if ((r = file_get_block(dir, i, &blk)) < 0)
  80140b:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  80140f:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801412:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801416:	89 ce                	mov    %ecx,%esi
  801418:	48 89 c7             	mov    %rax,%rdi
  80141b:	48 b8 73 11 80 00 00 	movabs $0x801173,%rax
  801422:	00 00 00 
  801425:	ff d0                	callq  *%rax
  801427:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80142a:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80142e:	79 08                	jns    801438 <dir_alloc_file+0xac>
				return r;
  801430:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801433:	e9 be 00 00 00       	jmpq   8014f6 <dir_alloc_file+0x16a>
			f = (struct File*) blk;
  801438:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80143c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			for (j = 0; j < BLKFILES; j++)
  801440:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  801447:	eb 3b                	jmp    801484 <dir_alloc_file+0xf8>
				if (f[j].f_name[0] == '\0') {
  801449:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80144c:	48 c1 e0 08          	shl    $0x8,%rax
  801450:	48 89 c2             	mov    %rax,%rdx
  801453:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801457:	48 01 d0             	add    %rdx,%rax
  80145a:	0f b6 00             	movzbl (%rax),%eax
  80145d:	84 c0                	test   %al,%al
  80145f:	75 1f                	jne    801480 <dir_alloc_file+0xf4>
					*file = &f[j];
  801461:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801464:	48 c1 e0 08          	shl    $0x8,%rax
  801468:	48 89 c2             	mov    %rax,%rdx
  80146b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80146f:	48 01 c2             	add    %rax,%rdx
  801472:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801476:	48 89 10             	mov    %rdx,(%rax)
					return 0;
  801479:	b8 00 00 00 00       	mov    $0x0,%eax
  80147e:	eb 76                	jmp    8014f6 <dir_alloc_file+0x16a>
		nblock = dir->f_size / BLKSIZE;
		for (i = 0; i < nblock; i++) {
			if ((r = file_get_block(dir, i, &blk)) < 0)
				return r;
			f = (struct File*) blk;
			for (j = 0; j < BLKFILES; j++)
  801480:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  801484:	83 7d f8 0f          	cmpl   $0xf,-0x8(%rbp)
  801488:	76 bf                	jbe    801449 <dir_alloc_file+0xbd>
		char *blk;
		struct File *f;

		assert((dir->f_size % BLKSIZE) == 0);
		nblock = dir->f_size / BLKSIZE;
		for (i = 0; i < nblock; i++) {
  80148a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80148e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801491:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  801494:	0f 82 71 ff ff ff    	jb     80140b <dir_alloc_file+0x7f>
				if (f[j].f_name[0] == '\0') {
					*file = &f[j];
					return 0;
				}
			}
			dir->f_size += BLKSIZE;
  80149a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80149e:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  8014a4:	8d 90 00 10 00 00    	lea    0x1000(%rax),%edx
  8014aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ae:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
			if ((r = file_get_block(dir, i, &blk)) < 0)
  8014b4:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  8014b8:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  8014bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014bf:	89 ce                	mov    %ecx,%esi
  8014c1:	48 89 c7             	mov    %rax,%rdi
  8014c4:	48 b8 73 11 80 00 00 	movabs $0x801173,%rax
  8014cb:	00 00 00 
  8014ce:	ff d0                	callq  *%rax
  8014d0:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8014d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8014d7:	79 05                	jns    8014de <dir_alloc_file+0x152>
				return r;
  8014d9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8014dc:	eb 18                	jmp    8014f6 <dir_alloc_file+0x16a>
			f = (struct File*) blk;
  8014de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014e2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			*file = &f[0];
  8014e6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014ea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014ee:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8014f1:	b8 00 00 00 00       	mov    $0x0,%eax
		}
  8014f6:	c9                   	leaveq 
  8014f7:	c3                   	retq   

00000000008014f8 <skip_slash>:

// Skip over slashes.
		static const char*
		skip_slash(const char *p)
		{
  8014f8:	55                   	push   %rbp
  8014f9:	48 89 e5             	mov    %rsp,%rbp
  8014fc:	48 83 ec 08          	sub    $0x8,%rsp
  801500:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
			while (*p == '/')
  801504:	eb 05                	jmp    80150b <skip_slash+0x13>
				p++;
  801506:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)

// Skip over slashes.
		static const char*
		skip_slash(const char *p)
		{
			while (*p == '/')
  80150b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80150f:	0f b6 00             	movzbl (%rax),%eax
  801512:	3c 2f                	cmp    $0x2f,%al
  801514:	74 f0                	je     801506 <skip_slash+0xe>
				p++;
			return p;
  801516:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
		}
  80151a:	c9                   	leaveq 
  80151b:	c3                   	retq   

000000000080151c <walk_path>:
// If we cannot find the file but find the directory
// it should be in, set *pdir and copy the final path
// element into lastelem.
		static int
		walk_path(const char *path, struct File **pdir, struct File **pf, char *lastelem)
		{
  80151c:	55                   	push   %rbp
  80151d:	48 89 e5             	mov    %rsp,%rbp
  801520:	48 81 ec d0 00 00 00 	sub    $0xd0,%rsp
  801527:	48 89 bd 48 ff ff ff 	mov    %rdi,-0xb8(%rbp)
  80152e:	48 89 b5 40 ff ff ff 	mov    %rsi,-0xc0(%rbp)
  801535:	48 89 95 38 ff ff ff 	mov    %rdx,-0xc8(%rbp)
  80153c:	48 89 8d 30 ff ff ff 	mov    %rcx,-0xd0(%rbp)
			struct File *dir, *f;
			int r;

	// if (*path != '/')
	//	return -E_BAD_PATH;
			path = skip_slash(path);
  801543:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  80154a:	48 89 c7             	mov    %rax,%rdi
  80154d:	48 b8 f8 14 80 00 00 	movabs $0x8014f8,%rax
  801554:	00 00 00 
  801557:	ff d0                	callq  *%rax
  801559:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
			f = &super->s_root;
  801560:	48 b8 18 40 81 00 00 	movabs $0x814018,%rax
  801567:	00 00 00 
  80156a:	48 8b 00             	mov    (%rax),%rax
  80156d:	48 83 c0 08          	add    $0x8,%rax
  801571:	48 89 85 58 ff ff ff 	mov    %rax,-0xa8(%rbp)
			dir = 0;
  801578:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80157f:	00 
			name[0] = 0;
  801580:	c6 85 60 ff ff ff 00 	movb   $0x0,-0xa0(%rbp)

			if (pdir)
  801587:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
  80158e:	00 
  80158f:	74 0e                	je     80159f <walk_path+0x83>
				*pdir = 0;
  801591:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
  801598:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
			*pf = 0;
  80159f:	48 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%rax
  8015a6:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
			while (*path != '\0') {
  8015ad:	e9 73 01 00 00       	jmpq   801725 <walk_path+0x209>
				dir = f;
  8015b2:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8015b9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
				p = path;
  8015bd:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  8015c4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
				while (*path != '/' && *path != '\0')
  8015c8:	eb 08                	jmp    8015d2 <walk_path+0xb6>
					path++;
  8015ca:	48 83 85 48 ff ff ff 	addq   $0x1,-0xb8(%rbp)
  8015d1:	01 
				*pdir = 0;
			*pf = 0;
			while (*path != '\0') {
				dir = f;
				p = path;
				while (*path != '/' && *path != '\0')
  8015d2:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  8015d9:	0f b6 00             	movzbl (%rax),%eax
  8015dc:	3c 2f                	cmp    $0x2f,%al
  8015de:	74 0e                	je     8015ee <walk_path+0xd2>
  8015e0:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  8015e7:	0f b6 00             	movzbl (%rax),%eax
  8015ea:	84 c0                	test   %al,%al
  8015ec:	75 dc                	jne    8015ca <walk_path+0xae>
					path++;
				if (path - p >= MAXNAMELEN)
  8015ee:	48 8b 95 48 ff ff ff 	mov    -0xb8(%rbp),%rdx
  8015f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015f9:	48 29 c2             	sub    %rax,%rdx
  8015fc:	48 89 d0             	mov    %rdx,%rax
  8015ff:	48 83 f8 7f          	cmp    $0x7f,%rax
  801603:	7e 0a                	jle    80160f <walk_path+0xf3>
					return -E_BAD_PATH;
  801605:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80160a:	e9 56 01 00 00       	jmpq   801765 <walk_path+0x249>
				memmove(name, p, path - p);
  80160f:	48 8b 95 48 ff ff ff 	mov    -0xb8(%rbp),%rdx
  801616:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80161a:	48 29 c2             	sub    %rax,%rdx
  80161d:	48 89 d0             	mov    %rdx,%rax
  801620:	48 89 c2             	mov    %rax,%rdx
  801623:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801627:	48 8d 85 60 ff ff ff 	lea    -0xa0(%rbp),%rax
  80162e:	48 89 ce             	mov    %rcx,%rsi
  801631:	48 89 c7             	mov    %rax,%rdi
  801634:	48 b8 37 46 80 00 00 	movabs $0x804637,%rax
  80163b:	00 00 00 
  80163e:	ff d0                	callq  *%rax
				name[path - p] = '\0';
  801640:	48 8b 95 48 ff ff ff 	mov    -0xb8(%rbp),%rdx
  801647:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80164b:	48 29 c2             	sub    %rax,%rdx
  80164e:	48 89 d0             	mov    %rdx,%rax
  801651:	c6 84 05 60 ff ff ff 	movb   $0x0,-0xa0(%rbp,%rax,1)
  801658:	00 
				path = skip_slash(path);
  801659:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801660:	48 89 c7             	mov    %rax,%rdi
  801663:	48 b8 f8 14 80 00 00 	movabs $0x8014f8,%rax
  80166a:	00 00 00 
  80166d:	ff d0                	callq  *%rax
  80166f:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)

				if (dir->f_type != FTYPE_DIR)
  801676:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80167a:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  801680:	83 f8 01             	cmp    $0x1,%eax
  801683:	74 0a                	je     80168f <walk_path+0x173>
					return -E_NOT_FOUND;
  801685:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  80168a:	e9 d6 00 00 00       	jmpq   801765 <walk_path+0x249>

				if ((r = dir_lookup(dir, name, &f)) < 0) {
  80168f:	48 8d 95 58 ff ff ff 	lea    -0xa8(%rbp),%rdx
  801696:	48 8d 8d 60 ff ff ff 	lea    -0xa0(%rbp),%rcx
  80169d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016a1:	48 89 ce             	mov    %rcx,%rsi
  8016a4:	48 89 c7             	mov    %rax,%rdi
  8016a7:	48 b8 63 12 80 00 00 	movabs $0x801263,%rax
  8016ae:	00 00 00 
  8016b1:	ff d0                	callq  *%rax
  8016b3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8016b6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8016ba:	79 69                	jns    801725 <walk_path+0x209>
					if (r == -E_NOT_FOUND && *path == '\0') {
  8016bc:	83 7d ec f4          	cmpl   $0xfffffff4,-0x14(%rbp)
  8016c0:	75 5e                	jne    801720 <walk_path+0x204>
  8016c2:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  8016c9:	0f b6 00             	movzbl (%rax),%eax
  8016cc:	84 c0                	test   %al,%al
  8016ce:	75 50                	jne    801720 <walk_path+0x204>
						if (pdir)
  8016d0:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
  8016d7:	00 
  8016d8:	74 0e                	je     8016e8 <walk_path+0x1cc>
							*pdir = dir;
  8016da:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
  8016e1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016e5:	48 89 10             	mov    %rdx,(%rax)
						if (lastelem)
  8016e8:	48 83 bd 30 ff ff ff 	cmpq   $0x0,-0xd0(%rbp)
  8016ef:	00 
  8016f0:	74 20                	je     801712 <walk_path+0x1f6>
							strcpy(lastelem, name);
  8016f2:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  8016f9:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
  801700:	48 89 d6             	mov    %rdx,%rsi
  801703:	48 89 c7             	mov    %rax,%rdi
  801706:	48 b8 13 43 80 00 00 	movabs $0x804313,%rax
  80170d:	00 00 00 
  801710:	ff d0                	callq  *%rax
						*pf = 0;
  801712:	48 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%rax
  801719:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
					}
					return r;
  801720:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801723:	eb 40                	jmp    801765 <walk_path+0x249>
			name[0] = 0;

			if (pdir)
				*pdir = 0;
			*pf = 0;
			while (*path != '\0') {
  801725:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  80172c:	0f b6 00             	movzbl (%rax),%eax
  80172f:	84 c0                	test   %al,%al
  801731:	0f 85 7b fe ff ff    	jne    8015b2 <walk_path+0x96>
					}
					return r;
				}
			}

			if (pdir)
  801737:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
  80173e:	00 
  80173f:	74 0e                	je     80174f <walk_path+0x233>
				*pdir = dir;
  801741:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
  801748:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80174c:	48 89 10             	mov    %rdx,(%rax)
			*pf = f;
  80174f:	48 8b 95 58 ff ff ff 	mov    -0xa8(%rbp),%rdx
  801756:	48 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%rax
  80175d:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801760:	b8 00 00 00 00       	mov    $0x0,%eax
		}
  801765:	c9                   	leaveq 
  801766:	c3                   	retq   

0000000000801767 <file_create>:

// Create "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
		int
		file_create(const char *path, struct File **pf)
		{
  801767:	55                   	push   %rbp
  801768:	48 89 e5             	mov    %rsp,%rbp
  80176b:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  801772:	48 89 bd 58 ff ff ff 	mov    %rdi,-0xa8(%rbp)
  801779:	48 89 b5 50 ff ff ff 	mov    %rsi,-0xb0(%rbp)
			char name[MAXNAMELEN];
			int r;
			struct File *dir, *f;

			if ((r = walk_path(path, &dir, &f, name)) == 0)
  801780:	48 8d 8d 70 ff ff ff 	lea    -0x90(%rbp),%rcx
  801787:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  80178e:	48 8d b5 68 ff ff ff 	lea    -0x98(%rbp),%rsi
  801795:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80179c:	48 89 c7             	mov    %rax,%rdi
  80179f:	48 b8 1c 15 80 00 00 	movabs $0x80151c,%rax
  8017a6:	00 00 00 
  8017a9:	ff d0                	callq  *%rax
  8017ab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8017ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8017b2:	75 0a                	jne    8017be <file_create+0x57>
				return -E_FILE_EXISTS;
  8017b4:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  8017b9:	e9 91 00 00 00       	jmpq   80184f <file_create+0xe8>
			if (r != -E_NOT_FOUND || dir == 0)
  8017be:	83 7d fc f4          	cmpl   $0xfffffff4,-0x4(%rbp)
  8017c2:	75 0c                	jne    8017d0 <file_create+0x69>
  8017c4:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  8017cb:	48 85 c0             	test   %rax,%rax
  8017ce:	75 05                	jne    8017d5 <file_create+0x6e>
				return r;
  8017d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017d3:	eb 7a                	jmp    80184f <file_create+0xe8>
			if ((r = dir_alloc_file(dir, &f)) < 0)
  8017d5:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  8017dc:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  8017e3:	48 89 d6             	mov    %rdx,%rsi
  8017e6:	48 89 c7             	mov    %rax,%rdi
  8017e9:	48 b8 8c 13 80 00 00 	movabs $0x80138c,%rax
  8017f0:	00 00 00 
  8017f3:	ff d0                	callq  *%rax
  8017f5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8017f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8017fc:	79 05                	jns    801803 <file_create+0x9c>
				return r;
  8017fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801801:	eb 4c                	jmp    80184f <file_create+0xe8>
			strcpy(f->f_name, name);
  801803:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80180a:	48 8d 95 70 ff ff ff 	lea    -0x90(%rbp),%rdx
  801811:	48 89 d6             	mov    %rdx,%rsi
  801814:	48 89 c7             	mov    %rax,%rdi
  801817:	48 b8 13 43 80 00 00 	movabs $0x804313,%rax
  80181e:	00 00 00 
  801821:	ff d0                	callq  *%rax
			*pf = f;
  801823:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  80182a:	48 8b 85 50 ff ff ff 	mov    -0xb0(%rbp),%rax
  801831:	48 89 10             	mov    %rdx,(%rax)
			file_flush(dir);
  801834:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  80183b:	48 89 c7             	mov    %rax,%rdi
  80183e:	48 b8 dd 1c 80 00 00 	movabs $0x801cdd,%rax
  801845:	00 00 00 
  801848:	ff d0                	callq  *%rax
			return 0;
  80184a:	b8 00 00 00 00       	mov    $0x0,%eax
		}
  80184f:	c9                   	leaveq 
  801850:	c3                   	retq   

0000000000801851 <file_open>:

// Open "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
		int
		file_open(const char *path, struct File **pf)
		{
  801851:	55                   	push   %rbp
  801852:	48 89 e5             	mov    %rsp,%rbp
  801855:	48 83 ec 10          	sub    $0x10,%rsp
  801859:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80185d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
			return walk_path(path, 0, pf, 0);
  801861:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801865:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801869:	b9 00 00 00 00       	mov    $0x0,%ecx
  80186e:	be 00 00 00 00       	mov    $0x0,%esi
  801873:	48 89 c7             	mov    %rax,%rdi
  801876:	48 b8 1c 15 80 00 00 	movabs $0x80151c,%rax
  80187d:	00 00 00 
  801880:	ff d0                	callq  *%rax
		}
  801882:	c9                   	leaveq 
  801883:	c3                   	retq   

0000000000801884 <file_read>:
// Read count bytes from f into buf, starting from seek position
// offset.  This meant to mimic the standard pread function.
// Returns the number of bytes read, < 0 on error.
		ssize_t
		file_read(struct File *f, void *buf, size_t count, off_t offset)
		{
  801884:	55                   	push   %rbp
  801885:	48 89 e5             	mov    %rsp,%rbp
  801888:	48 83 ec 60          	sub    $0x60,%rsp
  80188c:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
  801890:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
  801894:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  801898:	89 4d a4             	mov    %ecx,-0x5c(%rbp)
			int r, bn;
			off_t pos;
			char *blk;

			if (offset >= f->f_size)
  80189b:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  80189f:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  8018a5:	3b 45 a4             	cmp    -0x5c(%rbp),%eax
  8018a8:	7f 0a                	jg     8018b4 <file_read+0x30>
				return 0;
  8018aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8018af:	e9 24 01 00 00       	jmpq   8019d8 <file_read+0x154>

			count = MIN(count, f->f_size - offset);
  8018b4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8018b8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  8018bc:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8018c0:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  8018c6:	2b 45 a4             	sub    -0x5c(%rbp),%eax
  8018c9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8018cc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8018cf:	48 63 d0             	movslq %eax,%rdx
  8018d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018d6:	48 39 c2             	cmp    %rax,%rdx
  8018d9:	48 0f 46 c2          	cmovbe %rdx,%rax
  8018dd:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

			for (pos = offset; pos < offset + count; ) {
  8018e1:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  8018e4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8018e7:	e9 cd 00 00 00       	jmpq   8019b9 <file_read+0x135>
				if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  8018ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018ef:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  8018f5:	85 c0                	test   %eax,%eax
  8018f7:	0f 48 c2             	cmovs  %edx,%eax
  8018fa:	c1 f8 0c             	sar    $0xc,%eax
  8018fd:	89 c1                	mov    %eax,%ecx
  8018ff:	48 8d 55 c8          	lea    -0x38(%rbp),%rdx
  801903:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801907:	89 ce                	mov    %ecx,%esi
  801909:	48 89 c7             	mov    %rax,%rdi
  80190c:	48 b8 73 11 80 00 00 	movabs $0x801173,%rax
  801913:	00 00 00 
  801916:	ff d0                	callq  *%rax
  801918:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80191b:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80191f:	79 08                	jns    801929 <file_read+0xa5>
					return r;
  801921:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801924:	e9 af 00 00 00       	jmpq   8019d8 <file_read+0x154>
				bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  801929:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80192c:	99                   	cltd   
  80192d:	c1 ea 14             	shr    $0x14,%edx
  801930:	01 d0                	add    %edx,%eax
  801932:	25 ff 0f 00 00       	and    $0xfff,%eax
  801937:	29 d0                	sub    %edx,%eax
  801939:	ba 00 10 00 00       	mov    $0x1000,%edx
  80193e:	29 c2                	sub    %eax,%edx
  801940:	89 d0                	mov    %edx,%eax
  801942:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  801945:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  801948:	48 63 d0             	movslq %eax,%rdx
  80194b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80194f:	48 01 c2             	add    %rax,%rdx
  801952:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801955:	48 98                	cltq   
  801957:	48 29 c2             	sub    %rax,%rdx
  80195a:	48 89 d0             	mov    %rdx,%rax
  80195d:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801961:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801964:	48 63 d0             	movslq %eax,%rdx
  801967:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80196b:	48 39 c2             	cmp    %rax,%rdx
  80196e:	48 0f 46 c2          	cmovbe %rdx,%rax
  801972:	89 45 d4             	mov    %eax,-0x2c(%rbp)
				memmove(buf, blk + pos % BLKSIZE, bn);
  801975:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801978:	48 63 c8             	movslq %eax,%rcx
  80197b:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  80197f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801982:	99                   	cltd   
  801983:	c1 ea 14             	shr    $0x14,%edx
  801986:	01 d0                	add    %edx,%eax
  801988:	25 ff 0f 00 00       	and    $0xfff,%eax
  80198d:	29 d0                	sub    %edx,%eax
  80198f:	48 98                	cltq   
  801991:	48 01 c6             	add    %rax,%rsi
  801994:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  801998:	48 89 ca             	mov    %rcx,%rdx
  80199b:	48 89 c7             	mov    %rax,%rdi
  80199e:	48 b8 37 46 80 00 00 	movabs $0x804637,%rax
  8019a5:	00 00 00 
  8019a8:	ff d0                	callq  *%rax
				pos += bn;
  8019aa:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8019ad:	01 45 fc             	add    %eax,-0x4(%rbp)
				buf += bn;
  8019b0:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8019b3:	48 98                	cltq   
  8019b5:	48 01 45 b0          	add    %rax,-0x50(%rbp)
			if (offset >= f->f_size)
				return 0;

			count = MIN(count, f->f_size - offset);

			for (pos = offset; pos < offset + count; ) {
  8019b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019bc:	48 98                	cltq   
  8019be:	8b 55 a4             	mov    -0x5c(%rbp),%edx
  8019c1:	48 63 ca             	movslq %edx,%rcx
  8019c4:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8019c8:	48 01 ca             	add    %rcx,%rdx
  8019cb:	48 39 d0             	cmp    %rdx,%rax
  8019ce:	0f 82 18 ff ff ff    	jb     8018ec <file_read+0x68>
				memmove(buf, blk + pos % BLKSIZE, bn);
				pos += bn;
				buf += bn;
			}

			return count;
  8019d4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
		}
  8019d8:	c9                   	leaveq 
  8019d9:	c3                   	retq   

00000000008019da <file_write>:
// offset.  This is meant to mimic the standard pwrite function.
// Extends the file if necessary.
// Returns the number of bytes written, < 0 on error.
		int
		file_write(struct File *f, const void *buf, size_t count, off_t offset)
		{
  8019da:	55                   	push   %rbp
  8019db:	48 89 e5             	mov    %rsp,%rbp
  8019de:	48 83 ec 50          	sub    $0x50,%rsp
  8019e2:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8019e6:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  8019ea:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8019ee:	89 4d b4             	mov    %ecx,-0x4c(%rbp)
			int r, bn;
			off_t pos;
			char *blk;

	// Extend file if necessary
			if (offset + count > f->f_size)
  8019f1:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  8019f4:	48 63 d0             	movslq %eax,%rdx
  8019f7:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8019fb:	48 01 c2             	add    %rax,%rdx
  8019fe:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801a02:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801a08:	48 98                	cltq   
  801a0a:	48 39 c2             	cmp    %rax,%rdx
  801a0d:	76 33                	jbe    801a42 <file_write+0x68>
				if ((r = file_set_size(f, offset + count)) < 0)
  801a0f:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801a13:	89 c2                	mov    %eax,%edx
  801a15:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  801a18:	01 d0                	add    %edx,%eax
  801a1a:	89 c2                	mov    %eax,%edx
  801a1c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801a20:	89 d6                	mov    %edx,%esi
  801a22:	48 89 c7             	mov    %rax,%rdi
  801a25:	48 b8 80 1c 80 00 00 	movabs $0x801c80,%rax
  801a2c:	00 00 00 
  801a2f:	ff d0                	callq  *%rax
  801a31:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801a34:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801a38:	79 08                	jns    801a42 <file_write+0x68>
					return r;
  801a3a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a3d:	e9 f8 00 00 00       	jmpq   801b3a <file_write+0x160>

				for (pos = offset; pos < offset + count; ) {
  801a42:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  801a45:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801a48:	e9 ce 00 00 00       	jmpq   801b1b <file_write+0x141>
					if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  801a4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a50:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801a56:	85 c0                	test   %eax,%eax
  801a58:	0f 48 c2             	cmovs  %edx,%eax
  801a5b:	c1 f8 0c             	sar    $0xc,%eax
  801a5e:	89 c1                	mov    %eax,%ecx
  801a60:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801a64:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801a68:	89 ce                	mov    %ecx,%esi
  801a6a:	48 89 c7             	mov    %rax,%rdi
  801a6d:	48 b8 73 11 80 00 00 	movabs $0x801173,%rax
  801a74:	00 00 00 
  801a77:	ff d0                	callq  *%rax
  801a79:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801a7c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801a80:	79 08                	jns    801a8a <file_write+0xb0>
						return r;
  801a82:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a85:	e9 b0 00 00 00       	jmpq   801b3a <file_write+0x160>
					bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  801a8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a8d:	99                   	cltd   
  801a8e:	c1 ea 14             	shr    $0x14,%edx
  801a91:	01 d0                	add    %edx,%eax
  801a93:	25 ff 0f 00 00       	and    $0xfff,%eax
  801a98:	29 d0                	sub    %edx,%eax
  801a9a:	ba 00 10 00 00       	mov    $0x1000,%edx
  801a9f:	29 c2                	sub    %eax,%edx
  801aa1:	89 d0                	mov    %edx,%eax
  801aa3:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801aa6:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  801aa9:	48 63 d0             	movslq %eax,%rdx
  801aac:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801ab0:	48 01 c2             	add    %rax,%rdx
  801ab3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ab6:	48 98                	cltq   
  801ab8:	48 29 c2             	sub    %rax,%rdx
  801abb:	48 89 d0             	mov    %rdx,%rax
  801abe:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801ac2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801ac5:	48 63 d0             	movslq %eax,%rdx
  801ac8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801acc:	48 39 c2             	cmp    %rax,%rdx
  801acf:	48 0f 46 c2          	cmovbe %rdx,%rax
  801ad3:	89 45 e4             	mov    %eax,-0x1c(%rbp)
					memmove(blk + pos % BLKSIZE, buf, bn);
  801ad6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801ad9:	48 63 c8             	movslq %eax,%rcx
  801adc:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801ae0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ae3:	99                   	cltd   
  801ae4:	c1 ea 14             	shr    $0x14,%edx
  801ae7:	01 d0                	add    %edx,%eax
  801ae9:	25 ff 0f 00 00       	and    $0xfff,%eax
  801aee:	29 d0                	sub    %edx,%eax
  801af0:	48 98                	cltq   
  801af2:	48 8d 3c 06          	lea    (%rsi,%rax,1),%rdi
  801af6:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801afa:	48 89 ca             	mov    %rcx,%rdx
  801afd:	48 89 c6             	mov    %rax,%rsi
  801b00:	48 b8 37 46 80 00 00 	movabs $0x804637,%rax
  801b07:	00 00 00 
  801b0a:	ff d0                	callq  *%rax
					pos += bn;
  801b0c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b0f:	01 45 fc             	add    %eax,-0x4(%rbp)
					buf += bn;
  801b12:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b15:	48 98                	cltq   
  801b17:	48 01 45 c0          	add    %rax,-0x40(%rbp)
	// Extend file if necessary
			if (offset + count > f->f_size)
				if ((r = file_set_size(f, offset + count)) < 0)
					return r;

				for (pos = offset; pos < offset + count; ) {
  801b1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b1e:	48 98                	cltq   
  801b20:	8b 55 b4             	mov    -0x4c(%rbp),%edx
  801b23:	48 63 ca             	movslq %edx,%rcx
  801b26:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801b2a:	48 01 ca             	add    %rcx,%rdx
  801b2d:	48 39 d0             	cmp    %rdx,%rax
  801b30:	0f 82 17 ff ff ff    	jb     801a4d <file_write+0x73>
					memmove(blk + pos % BLKSIZE, buf, bn);
					pos += bn;
					buf += bn;
				}

				return count;
  801b36:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
			}
  801b3a:	c9                   	leaveq 
  801b3b:	c3                   	retq   

0000000000801b3c <file_free_block>:

// Remove a block from file f.  If it's not there, just silently succeed.
// Returns 0 on success, < 0 on error.
			static int
			file_free_block(struct File *f, uint32_t filebno)
			{
  801b3c:	55                   	push   %rbp
  801b3d:	48 89 e5             	mov    %rsp,%rbp
  801b40:	48 83 ec 20          	sub    $0x20,%rsp
  801b44:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b48:	89 75 e4             	mov    %esi,-0x1c(%rbp)
				int r;
				uint32_t *ptr;

				if ((r = file_block_walk(f, filebno, &ptr, 0)) < 0)
  801b4b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801b4f:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  801b52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b56:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b5b:	48 89 c7             	mov    %rax,%rdi
  801b5e:	48 b8 21 10 80 00 00 	movabs $0x801021,%rax
  801b65:	00 00 00 
  801b68:	ff d0                	callq  *%rax
  801b6a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801b6d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b71:	79 05                	jns    801b78 <file_free_block+0x3c>
					return r;
  801b73:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b76:	eb 2d                	jmp    801ba5 <file_free_block+0x69>
				if (*ptr) {
  801b78:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b7c:	8b 00                	mov    (%rax),%eax
  801b7e:	85 c0                	test   %eax,%eax
  801b80:	74 1e                	je     801ba0 <file_free_block+0x64>
					free_block(*ptr);
  801b82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b86:	8b 00                	mov    (%rax),%eax
  801b88:	89 c7                	mov    %eax,%edi
  801b8a:	48 b8 38 0d 80 00 00 	movabs $0x800d38,%rax
  801b91:	00 00 00 
  801b94:	ff d0                	callq  *%rax
					*ptr = 0;
  801b96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b9a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
				}
				return 0;
  801ba0:	b8 00 00 00 00       	mov    $0x0,%eax
			}
  801ba5:	c9                   	leaveq 
  801ba6:	c3                   	retq   

0000000000801ba7 <file_truncate_blocks>:
// (Remember to clear the f->f_indirect pointer so you'll know
// whether it's valid!)
// Do not change f->f_size.
			static void
			file_truncate_blocks(struct File *f, off_t newsize)
			{
  801ba7:	55                   	push   %rbp
  801ba8:	48 89 e5             	mov    %rsp,%rbp
  801bab:	48 83 ec 20          	sub    $0x20,%rsp
  801baf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801bb3:	89 75 e4             	mov    %esi,-0x1c(%rbp)
				int r;
				uint32_t bno, old_nblocks, new_nblocks;

				old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
  801bb6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bba:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801bc0:	05 ff 0f 00 00       	add    $0xfff,%eax
  801bc5:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801bcb:	85 c0                	test   %eax,%eax
  801bcd:	0f 48 c2             	cmovs  %edx,%eax
  801bd0:	c1 f8 0c             	sar    $0xc,%eax
  801bd3:	89 45 f8             	mov    %eax,-0x8(%rbp)
				new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
  801bd6:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801bd9:	05 ff 0f 00 00       	add    $0xfff,%eax
  801bde:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801be4:	85 c0                	test   %eax,%eax
  801be6:	0f 48 c2             	cmovs  %edx,%eax
  801be9:	c1 f8 0c             	sar    $0xc,%eax
  801bec:	89 45 f4             	mov    %eax,-0xc(%rbp)
				for (bno = new_nblocks; bno < old_nblocks; bno++)
  801bef:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bf2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801bf5:	eb 45                	jmp    801c3c <file_truncate_blocks+0x95>
					if ((r = file_free_block(f, bno)) < 0)
  801bf7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801bfa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bfe:	89 d6                	mov    %edx,%esi
  801c00:	48 89 c7             	mov    %rax,%rdi
  801c03:	48 b8 3c 1b 80 00 00 	movabs $0x801b3c,%rax
  801c0a:	00 00 00 
  801c0d:	ff d0                	callq  *%rax
  801c0f:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801c12:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801c16:	79 20                	jns    801c38 <file_truncate_blocks+0x91>
						cprintf("warning: file_free_block: %e", r);
  801c18:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801c1b:	89 c6                	mov    %eax,%esi
  801c1d:	48 bf a0 6e 80 00 00 	movabs $0x806ea0,%rdi
  801c24:	00 00 00 
  801c27:	b8 00 00 00 00       	mov    $0x0,%eax
  801c2c:	48 ba 1d 37 80 00 00 	movabs $0x80371d,%rdx
  801c33:	00 00 00 
  801c36:	ff d2                	callq  *%rdx
				int r;
				uint32_t bno, old_nblocks, new_nblocks;

				old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
				new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
				for (bno = new_nblocks; bno < old_nblocks; bno++)
  801c38:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801c3c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c3f:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  801c42:	72 b3                	jb     801bf7 <file_truncate_blocks+0x50>
					if ((r = file_free_block(f, bno)) < 0)
						cprintf("warning: file_free_block: %e", r);

					if (new_nblocks <= NDIRECT && f->f_indirect) {
  801c44:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  801c48:	77 34                	ja     801c7e <file_truncate_blocks+0xd7>
  801c4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c4e:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801c54:	85 c0                	test   %eax,%eax
  801c56:	74 26                	je     801c7e <file_truncate_blocks+0xd7>
						free_block(f->f_indirect);
  801c58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c5c:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801c62:	89 c7                	mov    %eax,%edi
  801c64:	48 b8 38 0d 80 00 00 	movabs $0x800d38,%rax
  801c6b:	00 00 00 
  801c6e:	ff d0                	callq  *%rax
						f->f_indirect = 0;
  801c70:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c74:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%rax)
  801c7b:	00 00 00 
					}
				}
  801c7e:	c9                   	leaveq 
  801c7f:	c3                   	retq   

0000000000801c80 <file_set_size>:

// Set the size of file f, truncating or extending as necessary.
				int
				file_set_size(struct File *f, off_t newsize)
				{
  801c80:	55                   	push   %rbp
  801c81:	48 89 e5             	mov    %rsp,%rbp
  801c84:	48 83 ec 10          	sub    $0x10,%rsp
  801c88:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c8c:	89 75 f4             	mov    %esi,-0xc(%rbp)
					if (f->f_size > newsize)
  801c8f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c93:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801c99:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  801c9c:	7e 18                	jle    801cb6 <file_set_size+0x36>
						file_truncate_blocks(f, newsize);
  801c9e:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801ca1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ca5:	89 d6                	mov    %edx,%esi
  801ca7:	48 89 c7             	mov    %rax,%rdi
  801caa:	48 b8 a7 1b 80 00 00 	movabs $0x801ba7,%rax
  801cb1:	00 00 00 
  801cb4:	ff d0                	callq  *%rax
					f->f_size = newsize;
  801cb6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cba:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801cbd:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
					flush_block(f);
  801cc3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cc7:	48 89 c7             	mov    %rax,%rdi
  801cca:	48 b8 04 08 80 00 00 	movabs $0x800804,%rax
  801cd1:	00 00 00 
  801cd4:	ff d0                	callq  *%rax
					return 0;
  801cd6:	b8 00 00 00 00       	mov    $0x0,%eax
				}
  801cdb:	c9                   	leaveq 
  801cdc:	c3                   	retq   

0000000000801cdd <file_flush>:
// Loop over all the blocks in file.
// Translate the file block number into a disk block number
// and then check whether that disk block is dirty.  If so, write it out.
				void
				file_flush(struct File *f)
				{
  801cdd:	55                   	push   %rbp
  801cde:	48 89 e5             	mov    %rsp,%rbp
  801ce1:	48 83 ec 20          	sub    $0x20,%rsp
  801ce5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
					int i;
					uint32_t *pdiskbno;

					for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  801ce9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801cf0:	eb 62                	jmp    801d54 <file_flush+0x77>
						if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  801cf2:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801cf5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801cf9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cfd:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d02:	48 89 c7             	mov    %rax,%rdi
  801d05:	48 b8 21 10 80 00 00 	movabs $0x801021,%rax
  801d0c:	00 00 00 
  801d0f:	ff d0                	callq  *%rax
  801d11:	85 c0                	test   %eax,%eax
  801d13:	78 13                	js     801d28 <file_flush+0x4b>
							pdiskbno == NULL || *pdiskbno == 0)
  801d15:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
				{
					int i;
					uint32_t *pdiskbno;

					for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
						if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  801d19:	48 85 c0             	test   %rax,%rax
  801d1c:	74 0a                	je     801d28 <file_flush+0x4b>
							pdiskbno == NULL || *pdiskbno == 0)
  801d1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d22:	8b 00                	mov    (%rax),%eax
  801d24:	85 c0                	test   %eax,%eax
  801d26:	75 02                	jne    801d2a <file_flush+0x4d>
							continue;
  801d28:	eb 26                	jmp    801d50 <file_flush+0x73>
						flush_block(diskaddr(*pdiskbno));
  801d2a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d2e:	8b 00                	mov    (%rax),%eax
  801d30:	89 c0                	mov    %eax,%eax
  801d32:	48 89 c7             	mov    %rax,%rdi
  801d35:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  801d3c:	00 00 00 
  801d3f:	ff d0                	callq  *%rax
  801d41:	48 89 c7             	mov    %rax,%rdi
  801d44:	48 b8 04 08 80 00 00 	movabs $0x800804,%rax
  801d4b:	00 00 00 
  801d4e:	ff d0                	callq  *%rax
				file_flush(struct File *f)
				{
					int i;
					uint32_t *pdiskbno;

					for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  801d50:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801d54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d58:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801d5e:	05 ff 0f 00 00       	add    $0xfff,%eax
  801d63:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801d69:	85 c0                	test   %eax,%eax
  801d6b:	0f 48 c2             	cmovs  %edx,%eax
  801d6e:	c1 f8 0c             	sar    $0xc,%eax
  801d71:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  801d74:	0f 8f 78 ff ff ff    	jg     801cf2 <file_flush+0x15>
						if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
							pdiskbno == NULL || *pdiskbno == 0)
							continue;
						flush_block(diskaddr(*pdiskbno));
					}
					flush_block(f);
  801d7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d7e:	48 89 c7             	mov    %rax,%rdi
  801d81:	48 b8 04 08 80 00 00 	movabs $0x800804,%rax
  801d88:	00 00 00 
  801d8b:	ff d0                	callq  *%rax
					if (f->f_indirect)
  801d8d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d91:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801d97:	85 c0                	test   %eax,%eax
  801d99:	74 2a                	je     801dc5 <file_flush+0xe8>
						flush_block(diskaddr(f->f_indirect));
  801d9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d9f:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801da5:	89 c0                	mov    %eax,%eax
  801da7:	48 89 c7             	mov    %rax,%rdi
  801daa:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  801db1:	00 00 00 
  801db4:	ff d0                	callq  *%rax
  801db6:	48 89 c7             	mov    %rax,%rdi
  801db9:	48 b8 04 08 80 00 00 	movabs $0x800804,%rax
  801dc0:	00 00 00 
  801dc3:	ff d0                	callq  *%rax
				}
  801dc5:	c9                   	leaveq 
  801dc6:	c3                   	retq   

0000000000801dc7 <file_remove>:

// Remove a file by truncating it and then zeroing the name.
				int
				file_remove(const char *path)
				{
  801dc7:	55                   	push   %rbp
  801dc8:	48 89 e5             	mov    %rsp,%rbp
  801dcb:	48 83 ec 20          	sub    $0x20,%rsp
  801dcf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
					int r;
					struct File *f;

					if ((r = walk_path(path, 0, &f, 0)) < 0)
  801dd3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801dd7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ddb:	b9 00 00 00 00       	mov    $0x0,%ecx
  801de0:	be 00 00 00 00       	mov    $0x0,%esi
  801de5:	48 89 c7             	mov    %rax,%rdi
  801de8:	48 b8 1c 15 80 00 00 	movabs $0x80151c,%rax
  801def:	00 00 00 
  801df2:	ff d0                	callq  *%rax
  801df4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801df7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801dfb:	79 05                	jns    801e02 <file_remove+0x3b>
						return r;
  801dfd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e00:	eb 45                	jmp    801e47 <file_remove+0x80>

					file_truncate_blocks(f, 0);
  801e02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e06:	be 00 00 00 00       	mov    $0x0,%esi
  801e0b:	48 89 c7             	mov    %rax,%rdi
  801e0e:	48 b8 a7 1b 80 00 00 	movabs $0x801ba7,%rax
  801e15:	00 00 00 
  801e18:	ff d0                	callq  *%rax
					f->f_name[0] = '\0';
  801e1a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e1e:	c6 00 00             	movb   $0x0,(%rax)
					f->f_size = 0;
  801e21:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e25:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  801e2c:	00 00 00 
					flush_block(f);
  801e2f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e33:	48 89 c7             	mov    %rax,%rdi
  801e36:	48 b8 04 08 80 00 00 	movabs $0x800804,%rax
  801e3d:	00 00 00 
  801e40:	ff d0                	callq  *%rax

					return 0;
  801e42:	b8 00 00 00 00       	mov    $0x0,%eax
				}
  801e47:	c9                   	leaveq 
  801e48:	c3                   	retq   

0000000000801e49 <fs_sync>:

// Sync the entire file system.  A big hammer.
				void
				fs_sync(void)
				{
  801e49:	55                   	push   %rbp
  801e4a:	48 89 e5             	mov    %rsp,%rbp
  801e4d:	48 83 ec 10          	sub    $0x10,%rsp
					int i;
					for (i = 1; i < super->s_nblocks; i++)
  801e51:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  801e58:	eb 27                	jmp    801e81 <fs_sync+0x38>
						flush_block(diskaddr(i));
  801e5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e5d:	48 98                	cltq   
  801e5f:	48 89 c7             	mov    %rax,%rdi
  801e62:	48 b8 a3 04 80 00 00 	movabs $0x8004a3,%rax
  801e69:	00 00 00 
  801e6c:	ff d0                	callq  *%rax
  801e6e:	48 89 c7             	mov    %rax,%rdi
  801e71:	48 b8 04 08 80 00 00 	movabs $0x800804,%rax
  801e78:	00 00 00 
  801e7b:	ff d0                	callq  *%rax
// Sync the entire file system.  A big hammer.
				void
				fs_sync(void)
				{
					int i;
					for (i = 1; i < super->s_nblocks; i++)
  801e7d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e81:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801e84:	48 b8 18 40 81 00 00 	movabs $0x814018,%rax
  801e8b:	00 00 00 
  801e8e:	48 8b 00             	mov    (%rax),%rax
  801e91:	8b 40 04             	mov    0x4(%rax),%eax
  801e94:	39 c2                	cmp    %eax,%edx
  801e96:	72 c2                	jb     801e5a <fs_sync+0x11>
						flush_block(diskaddr(i));
				}
  801e98:	c9                   	leaveq 
  801e99:	c3                   	retq   

0000000000801e9a <serve_init>:
// Virtual address at which to receive page mappings containing client requests.
union Fsipc *fsreq = (union Fsipc *)0x0ffff000;

void
serve_init(void)
{
  801e9a:	55                   	push   %rbp
  801e9b:	48 89 e5             	mov    %rsp,%rbp
  801e9e:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	uintptr_t va = FILEVA;
  801ea2:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
  801ea7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < MAXOPEN; i++) {
  801eab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801eb2:	eb 4b                	jmp    801eff <serve_init+0x65>
		opentab[i].o_fileid = i;
  801eb4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801eb7:	48 ba 20 90 80 00 00 	movabs $0x809020,%rdx
  801ebe:	00 00 00 
  801ec1:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801ec4:	48 63 c9             	movslq %ecx,%rcx
  801ec7:	48 c1 e1 05          	shl    $0x5,%rcx
  801ecb:	48 01 ca             	add    %rcx,%rdx
  801ece:	89 02                	mov    %eax,(%rdx)
		opentab[i].o_fd = (struct Fd*) va;
  801ed0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ed4:	48 ba 20 90 80 00 00 	movabs $0x809020,%rdx
  801edb:	00 00 00 
  801ede:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801ee1:	48 63 c9             	movslq %ecx,%rcx
  801ee4:	48 c1 e1 05          	shl    $0x5,%rcx
  801ee8:	48 01 ca             	add    %rcx,%rdx
  801eeb:	48 83 c2 10          	add    $0x10,%rdx
  801eef:	48 89 42 08          	mov    %rax,0x8(%rdx)
		va += PGSIZE;
  801ef3:	48 81 45 f0 00 10 00 	addq   $0x1000,-0x10(%rbp)
  801efa:	00 
void
serve_init(void)
{
	int i;
	uintptr_t va = FILEVA;
	for (i = 0; i < MAXOPEN; i++) {
  801efb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801eff:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  801f06:	7e ac                	jle    801eb4 <serve_init+0x1a>
		opentab[i].o_fileid = i;
		opentab[i].o_fd = (struct Fd*) va;
		va += PGSIZE;
	}
}
  801f08:	c9                   	leaveq 
  801f09:	c3                   	retq   

0000000000801f0a <openfile_alloc>:

// Allocate an open file.
int
openfile_alloc(struct OpenFile **o)
{
  801f0a:	55                   	push   %rbp
  801f0b:	48 89 e5             	mov    %rsp,%rbp
  801f0e:	53                   	push   %rbx
  801f0f:	48 83 ec 28          	sub    $0x28,%rsp
  801f13:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
  801f17:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  801f1e:	e9 02 02 00 00       	jmpq   802125 <openfile_alloc+0x21b>
		switch (pageref(opentab[i].o_fd)) {
  801f23:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  801f2a:	00 00 00 
  801f2d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801f30:	48 63 d2             	movslq %edx,%rdx
  801f33:	48 c1 e2 05          	shl    $0x5,%rdx
  801f37:	48 01 d0             	add    %rdx,%rax
  801f3a:	48 83 c0 10          	add    $0x10,%rax
  801f3e:	48 8b 40 08          	mov    0x8(%rax),%rax
  801f42:	48 89 c7             	mov    %rax,%rdi
  801f45:	48 b8 80 62 80 00 00 	movabs $0x806280,%rax
  801f4c:	00 00 00 
  801f4f:	ff d0                	callq  *%rax
  801f51:	85 c0                	test   %eax,%eax
  801f53:	74 0e                	je     801f63 <openfile_alloc+0x59>
  801f55:	83 f8 01             	cmp    $0x1,%eax
  801f58:	0f 84 ec 00 00 00    	je     80204a <openfile_alloc+0x140>
  801f5e:	e9 be 01 00 00       	jmpq   802121 <openfile_alloc+0x217>
			*o = &opentab[i];
			memset(opentab[i].o_fd, 0, PGSIZE);
			return (*o)->o_fileid;
		#else
		case 0:
			if ((r = sys_page_alloc(0, opentab[i].o_fd, PTE_P|PTE_U|PTE_W)) < 0)
  801f63:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  801f6a:	00 00 00 
  801f6d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801f70:	48 63 d2             	movslq %edx,%rdx
  801f73:	48 c1 e2 05          	shl    $0x5,%rdx
  801f77:	48 01 d0             	add    %rdx,%rax
  801f7a:	48 83 c0 10          	add    $0x10,%rax
  801f7e:	48 8b 40 08          	mov    0x8(%rax),%rax
  801f82:	ba 07 00 00 00       	mov    $0x7,%edx
  801f87:	48 89 c6             	mov    %rax,%rsi
  801f8a:	bf 00 00 00 00       	mov    $0x0,%edi
  801f8f:	48 b8 42 4c 80 00 00 	movabs $0x804c42,%rax
  801f96:	00 00 00 
  801f99:	ff d0                	callq  *%rax
  801f9b:	89 45 e8             	mov    %eax,-0x18(%rbp)
  801f9e:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  801fa2:	79 08                	jns    801fac <openfile_alloc+0xa2>
				return r;
  801fa4:	8b 45 e8             	mov    -0x18(%rbp),%eax
  801fa7:	e9 8b 01 00 00       	jmpq   802137 <openfile_alloc+0x22d>
			opentab[i].o_fileid += MAXOPEN;
  801fac:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  801fb3:	00 00 00 
  801fb6:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801fb9:	48 63 d2             	movslq %edx,%rdx
  801fbc:	48 c1 e2 05          	shl    $0x5,%rdx
  801fc0:	48 01 d0             	add    %rdx,%rax
  801fc3:	8b 00                	mov    (%rax),%eax
  801fc5:	8d 90 00 04 00 00    	lea    0x400(%rax),%edx
  801fcb:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  801fd2:	00 00 00 
  801fd5:	8b 4d ec             	mov    -0x14(%rbp),%ecx
  801fd8:	48 63 c9             	movslq %ecx,%rcx
  801fdb:	48 c1 e1 05          	shl    $0x5,%rcx
  801fdf:	48 01 c8             	add    %rcx,%rax
  801fe2:	89 10                	mov    %edx,(%rax)
			*o = &opentab[i];
  801fe4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801fe7:	48 98                	cltq   
  801fe9:	48 c1 e0 05          	shl    $0x5,%rax
  801fed:	48 89 c2             	mov    %rax,%rdx
  801ff0:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  801ff7:	00 00 00 
  801ffa:	48 01 c2             	add    %rax,%rdx
  801ffd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802001:	48 89 10             	mov    %rdx,(%rax)
			memset(opentab[i].o_fd, 0, PGSIZE);
  802004:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  80200b:	00 00 00 
  80200e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802011:	48 63 d2             	movslq %edx,%rdx
  802014:	48 c1 e2 05          	shl    $0x5,%rdx
  802018:	48 01 d0             	add    %rdx,%rax
  80201b:	48 83 c0 10          	add    $0x10,%rax
  80201f:	48 8b 40 08          	mov    0x8(%rax),%rax
  802023:	ba 00 10 00 00       	mov    $0x1000,%edx
  802028:	be 00 00 00 00       	mov    $0x0,%esi
  80202d:	48 89 c7             	mov    %rax,%rdi
  802030:	48 b8 ac 45 80 00 00 	movabs $0x8045ac,%rax
  802037:	00 00 00 
  80203a:	ff d0                	callq  *%rax
			return (*o)->o_fileid;
  80203c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802040:	48 8b 00             	mov    (%rax),%rax
  802043:	8b 00                	mov    (%rax),%eax
  802045:	e9 ed 00 00 00       	jmpq   802137 <openfile_alloc+0x22d>
			break;
		case 1:
			if ((uint64_t) opentab[i].o_fd != get_host_fd()) {				
  80204a:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802051:	00 00 00 
  802054:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802057:	48 63 d2             	movslq %edx,%rdx
  80205a:	48 c1 e2 05          	shl    $0x5,%rdx
  80205e:	48 01 d0             	add    %rdx,%rax
  802061:	48 83 c0 10          	add    $0x10,%rax
  802065:	48 8b 40 08          	mov    0x8(%rax),%rax
  802069:	48 89 c3             	mov    %rax,%rbx
  80206c:	b8 00 00 00 00       	mov    $0x0,%eax
  802071:	48 ba 0d 31 80 00 00 	movabs $0x80310d,%rdx
  802078:	00 00 00 
  80207b:	ff d2                	callq  *%rdx
  80207d:	48 39 c3             	cmp    %rax,%rbx
  802080:	0f 84 9b 00 00 00    	je     802121 <openfile_alloc+0x217>
				opentab[i].o_fileid += MAXOPEN;
  802086:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  80208d:	00 00 00 
  802090:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802093:	48 63 d2             	movslq %edx,%rdx
  802096:	48 c1 e2 05          	shl    $0x5,%rdx
  80209a:	48 01 d0             	add    %rdx,%rax
  80209d:	8b 00                	mov    (%rax),%eax
  80209f:	8d 90 00 04 00 00    	lea    0x400(%rax),%edx
  8020a5:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  8020ac:	00 00 00 
  8020af:	8b 4d ec             	mov    -0x14(%rbp),%ecx
  8020b2:	48 63 c9             	movslq %ecx,%rcx
  8020b5:	48 c1 e1 05          	shl    $0x5,%rcx
  8020b9:	48 01 c8             	add    %rcx,%rax
  8020bc:	89 10                	mov    %edx,(%rax)
				*o = &opentab[i];
  8020be:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020c1:	48 98                	cltq   
  8020c3:	48 c1 e0 05          	shl    $0x5,%rax
  8020c7:	48 89 c2             	mov    %rax,%rdx
  8020ca:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  8020d1:	00 00 00 
  8020d4:	48 01 c2             	add    %rax,%rdx
  8020d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020db:	48 89 10             	mov    %rdx,(%rax)
				memset(opentab[i].o_fd, 0, PGSIZE);
  8020de:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  8020e5:	00 00 00 
  8020e8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8020eb:	48 63 d2             	movslq %edx,%rdx
  8020ee:	48 c1 e2 05          	shl    $0x5,%rdx
  8020f2:	48 01 d0             	add    %rdx,%rax
  8020f5:	48 83 c0 10          	add    $0x10,%rax
  8020f9:	48 8b 40 08          	mov    0x8(%rax),%rax
  8020fd:	ba 00 10 00 00       	mov    $0x1000,%edx
  802102:	be 00 00 00 00       	mov    $0x0,%esi
  802107:	48 89 c7             	mov    %rax,%rdi
  80210a:	48 b8 ac 45 80 00 00 	movabs $0x8045ac,%rax
  802111:	00 00 00 
  802114:	ff d0                	callq  *%rax
				return (*o)->o_fileid;
  802116:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80211a:	48 8b 00             	mov    (%rax),%rax
  80211d:	8b 00                	mov    (%rax),%eax
  80211f:	eb 16                	jmp    802137 <openfile_alloc+0x22d>
openfile_alloc(struct OpenFile **o)
{
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
  802121:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  802125:	81 7d ec ff 03 00 00 	cmpl   $0x3ff,-0x14(%rbp)
  80212c:	0f 8e f1 fd ff ff    	jle    801f23 <openfile_alloc+0x19>
				return (*o)->o_fileid;
			}
		#endif
		}
	}
	return -E_MAX_OPEN;
  802132:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802137:	48 83 c4 28          	add    $0x28,%rsp
  80213b:	5b                   	pop    %rbx
  80213c:	5d                   	pop    %rbp
  80213d:	c3                   	retq   

000000000080213e <openfile_lookup>:

// Look up an open file for envid.
int
openfile_lookup(envid_t envid, uint32_t fileid, struct OpenFile **po)
{
  80213e:	55                   	push   %rbp
  80213f:	48 89 e5             	mov    %rsp,%rbp
  802142:	48 83 ec 20          	sub    $0x20,%rsp
  802146:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802149:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80214c:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
	struct OpenFile *o;

	o = &opentab[fileid % MAXOPEN];
  802150:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802153:	25 ff 03 00 00       	and    $0x3ff,%eax
  802158:	89 c0                	mov    %eax,%eax
  80215a:	48 c1 e0 05          	shl    $0x5,%rax
  80215e:	48 89 c2             	mov    %rax,%rdx
  802161:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802168:	00 00 00 
  80216b:	48 01 d0             	add    %rdx,%rax
  80216e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (pageref(o->o_fd) == 1 || o->o_fileid != fileid)
  802172:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802176:	48 8b 40 18          	mov    0x18(%rax),%rax
  80217a:	48 89 c7             	mov    %rax,%rdi
  80217d:	48 b8 80 62 80 00 00 	movabs $0x806280,%rax
  802184:	00 00 00 
  802187:	ff d0                	callq  *%rax
  802189:	83 f8 01             	cmp    $0x1,%eax
  80218c:	74 0b                	je     802199 <openfile_lookup+0x5b>
  80218e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802192:	8b 00                	mov    (%rax),%eax
  802194:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  802197:	74 07                	je     8021a0 <openfile_lookup+0x62>
		return -E_INVAL;
  802199:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80219e:	eb 10                	jmp    8021b0 <openfile_lookup+0x72>
	*po = o;
  8021a0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021a4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8021a8:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8021ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021b0:	c9                   	leaveq 
  8021b1:	c3                   	retq   

00000000008021b2 <serve_open>:
// permissions to return to the calling environment in *pg_store and
// *perm_store respectively.
int
serve_open(envid_t envid, struct Fsreq_open *req,
	   void **pg_store, int *perm_store)
{
  8021b2:	55                   	push   %rbp
  8021b3:	48 89 e5             	mov    %rsp,%rbp
  8021b6:	48 81 ec 40 04 00 00 	sub    $0x440,%rsp
  8021bd:	89 bd dc fb ff ff    	mov    %edi,-0x424(%rbp)
  8021c3:	48 89 b5 d0 fb ff ff 	mov    %rsi,-0x430(%rbp)
  8021ca:	48 89 95 c8 fb ff ff 	mov    %rdx,-0x438(%rbp)
  8021d1:	48 89 8d c0 fb ff ff 	mov    %rcx,-0x440(%rbp)

	if (debug)
		cprintf("serve_open %08x %s 0x%x\n", envid, req->req_path, req->req_omode);

	// Copy in the path, making sure it's null-terminated
	memmove(path, req->req_path, MAXPATHLEN);
  8021d8:	48 8b 8d d0 fb ff ff 	mov    -0x430(%rbp),%rcx
  8021df:	48 8d 85 f0 fb ff ff 	lea    -0x410(%rbp),%rax
  8021e6:	ba 00 04 00 00       	mov    $0x400,%edx
  8021eb:	48 89 ce             	mov    %rcx,%rsi
  8021ee:	48 89 c7             	mov    %rax,%rdi
  8021f1:	48 b8 37 46 80 00 00 	movabs $0x804637,%rax
  8021f8:	00 00 00 
  8021fb:	ff d0                	callq  *%rax
	path[MAXPATHLEN-1] = 0;
  8021fd:	c6 45 ef 00          	movb   $0x0,-0x11(%rbp)

	// Find an open file ID
	if ((r = openfile_alloc(&o)) < 0) {
  802201:	48 8d 85 e0 fb ff ff 	lea    -0x420(%rbp),%rax
  802208:	48 89 c7             	mov    %rax,%rdi
  80220b:	48 b8 0a 1f 80 00 00 	movabs $0x801f0a,%rax
  802212:	00 00 00 
  802215:	ff d0                	callq  *%rax
  802217:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80221a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80221e:	79 08                	jns    802228 <serve_open+0x76>
		if (debug)
			cprintf("openfile_alloc failed: %e", r);
		return r;
  802220:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802223:	e9 7c 01 00 00       	jmpq   8023a4 <serve_open+0x1f2>
	}
	fileid = r;
  802228:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80222b:	89 45 f8             	mov    %eax,-0x8(%rbp)

	// Open the file
	if (req->req_omode & O_CREAT) {
  80222e:	48 8b 85 d0 fb ff ff 	mov    -0x430(%rbp),%rax
  802235:	8b 80 00 04 00 00    	mov    0x400(%rax),%eax
  80223b:	25 00 01 00 00       	and    $0x100,%eax
  802240:	85 c0                	test   %eax,%eax
  802242:	74 4f                	je     802293 <serve_open+0xe1>
		if ((r = file_create(path, &f)) < 0) {
  802244:	48 8d 95 e8 fb ff ff 	lea    -0x418(%rbp),%rdx
  80224b:	48 8d 85 f0 fb ff ff 	lea    -0x410(%rbp),%rax
  802252:	48 89 d6             	mov    %rdx,%rsi
  802255:	48 89 c7             	mov    %rax,%rdi
  802258:	48 b8 67 17 80 00 00 	movabs $0x801767,%rax
  80225f:	00 00 00 
  802262:	ff d0                	callq  *%rax
  802264:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802267:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80226b:	79 57                	jns    8022c4 <serve_open+0x112>
			if (!(req->req_omode & O_EXCL) && r == -E_FILE_EXISTS)
  80226d:	48 8b 85 d0 fb ff ff 	mov    -0x430(%rbp),%rax
  802274:	8b 80 00 04 00 00    	mov    0x400(%rax),%eax
  80227a:	25 00 04 00 00       	and    $0x400,%eax
  80227f:	85 c0                	test   %eax,%eax
  802281:	75 08                	jne    80228b <serve_open+0xd9>
  802283:	83 7d fc f2          	cmpl   $0xfffffff2,-0x4(%rbp)
  802287:	75 02                	jne    80228b <serve_open+0xd9>
				goto try_open;
  802289:	eb 08                	jmp    802293 <serve_open+0xe1>
			if (debug)
				cprintf("file_create failed: %e", r);
			return r;
  80228b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80228e:	e9 11 01 00 00       	jmpq   8023a4 <serve_open+0x1f2>
		}
	} else {
	try_open:
		if ((r = file_open(path, &f)) < 0) {
  802293:	48 8d 95 e8 fb ff ff 	lea    -0x418(%rbp),%rdx
  80229a:	48 8d 85 f0 fb ff ff 	lea    -0x410(%rbp),%rax
  8022a1:	48 89 d6             	mov    %rdx,%rsi
  8022a4:	48 89 c7             	mov    %rax,%rdi
  8022a7:	48 b8 51 18 80 00 00 	movabs $0x801851,%rax
  8022ae:	00 00 00 
  8022b1:	ff d0                	callq  *%rax
  8022b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022ba:	79 08                	jns    8022c4 <serve_open+0x112>
			if (debug)
				cprintf("file_open failed: %e", r);
			return r;
  8022bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022bf:	e9 e0 00 00 00       	jmpq   8023a4 <serve_open+0x1f2>
		}
	}

	// Truncate
	if (req->req_omode & O_TRUNC) {
  8022c4:	48 8b 85 d0 fb ff ff 	mov    -0x430(%rbp),%rax
  8022cb:	8b 80 00 04 00 00    	mov    0x400(%rax),%eax
  8022d1:	25 00 02 00 00       	and    $0x200,%eax
  8022d6:	85 c0                	test   %eax,%eax
  8022d8:	74 2c                	je     802306 <serve_open+0x154>
		if ((r = file_set_size(f, 0)) < 0) {
  8022da:	48 8b 85 e8 fb ff ff 	mov    -0x418(%rbp),%rax
  8022e1:	be 00 00 00 00       	mov    $0x0,%esi
  8022e6:	48 89 c7             	mov    %rax,%rdi
  8022e9:	48 b8 80 1c 80 00 00 	movabs $0x801c80,%rax
  8022f0:	00 00 00 
  8022f3:	ff d0                	callq  *%rax
  8022f5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022fc:	79 08                	jns    802306 <serve_open+0x154>
			if (debug)
				cprintf("file_set_size failed: %e", r);
			return r;
  8022fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802301:	e9 9e 00 00 00       	jmpq   8023a4 <serve_open+0x1f2>
		}
	}

	// Save the file pointer
	o->o_file = f;
  802306:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  80230d:	48 8b 95 e8 fb ff ff 	mov    -0x418(%rbp),%rdx
  802314:	48 89 50 08          	mov    %rdx,0x8(%rax)

	// Fill out the Fd structure
	o->o_fd->fd_file.id = o->o_fileid;
  802318:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  80231f:	48 8b 40 18          	mov    0x18(%rax),%rax
  802323:	48 8b 95 e0 fb ff ff 	mov    -0x420(%rbp),%rdx
  80232a:	8b 12                	mov    (%rdx),%edx
  80232c:	89 50 0c             	mov    %edx,0xc(%rax)
	o->o_fd->fd_omode = req->req_omode & O_ACCMODE;
  80232f:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  802336:	48 8b 40 18          	mov    0x18(%rax),%rax
  80233a:	48 8b 95 d0 fb ff ff 	mov    -0x430(%rbp),%rdx
  802341:	8b 92 00 04 00 00    	mov    0x400(%rdx),%edx
  802347:	83 e2 03             	and    $0x3,%edx
  80234a:	89 50 08             	mov    %edx,0x8(%rax)
	o->o_fd->fd_dev_id = devfile.dev_id;
  80234d:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  802354:	48 8b 40 18          	mov    0x18(%rax),%rax
  802358:	48 ba e0 10 81 00 00 	movabs $0x8110e0,%rdx
  80235f:	00 00 00 
  802362:	8b 12                	mov    (%rdx),%edx
  802364:	89 10                	mov    %edx,(%rax)
	o->o_mode = req->req_omode;
  802366:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  80236d:	48 8b 95 d0 fb ff ff 	mov    -0x430(%rbp),%rdx
  802374:	8b 92 00 04 00 00    	mov    0x400(%rdx),%edx
  80237a:	89 50 10             	mov    %edx,0x10(%rax)
	if (debug)
		cprintf("sending success, page %08x\n", (uintptr_t) o->o_fd);

	// Share the FD page with the caller by setting *pg_store,
	// store its permission in *perm_store
	*pg_store = o->o_fd;
  80237d:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  802384:	48 8b 50 18          	mov    0x18(%rax),%rdx
  802388:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  80238f:	48 89 10             	mov    %rdx,(%rax)
	*perm_store = PTE_P|PTE_U|PTE_W|PTE_SHARE;
  802392:	48 8b 85 c0 fb ff ff 	mov    -0x440(%rbp),%rax
  802399:	c7 00 07 04 00 00    	movl   $0x407,(%rax)

	return 0;
  80239f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023a4:	c9                   	leaveq 
  8023a5:	c3                   	retq   

00000000008023a6 <serve_set_size>:

// Set the size of req->req_fileid to req->req_size bytes, truncating
// or extending the file as necessary.
int
serve_set_size(envid_t envid, struct Fsreq_set_size *req)
{
  8023a6:	55                   	push   %rbp
  8023a7:	48 89 e5             	mov    %rsp,%rbp
  8023aa:	48 83 ec 20          	sub    $0x20,%rsp
  8023ae:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023b1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// Every file system IPC call has the same general structure.
	// Here's how it goes.

	// First, use openfile_lookup to find the relevant open file.
	// On failure, return the error code to the client with ipc_send.
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8023b5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023b9:	8b 00                	mov    (%rax),%eax
  8023bb:	89 c1                	mov    %eax,%ecx
  8023bd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8023c1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023c4:	89 ce                	mov    %ecx,%esi
  8023c6:	89 c7                	mov    %eax,%edi
  8023c8:	48 b8 3e 21 80 00 00 	movabs $0x80213e,%rax
  8023cf:	00 00 00 
  8023d2:	ff d0                	callq  *%rax
  8023d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023db:	79 05                	jns    8023e2 <serve_set_size+0x3c>
		return r;
  8023dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023e0:	eb 20                	jmp    802402 <serve_set_size+0x5c>

	// Second, call the relevant file system function (from fs/fs.c).
	// On failure, return the error code to the client.
	return file_set_size(o->o_file, req->req_size);
  8023e2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023e6:	8b 50 04             	mov    0x4(%rax),%edx
  8023e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023ed:	48 8b 40 08          	mov    0x8(%rax),%rax
  8023f1:	89 d6                	mov    %edx,%esi
  8023f3:	48 89 c7             	mov    %rax,%rdi
  8023f6:	48 b8 80 1c 80 00 00 	movabs $0x801c80,%rax
  8023fd:	00 00 00 
  802400:	ff d0                	callq  *%rax
}
  802402:	c9                   	leaveq 
  802403:	c3                   	retq   

0000000000802404 <serve_read>:
// in ipc->read.req_fileid.  Return the bytes read from the file to
// the caller in ipc->readRet, then update the seek position.  Returns
// the number of bytes successfully read, or < 0 on error.
int
serve_read(envid_t envid, union Fsipc *ipc)
{
  802404:	55                   	push   %rbp
  802405:	48 89 e5             	mov    %rsp,%rbp
  802408:	48 83 ec 30          	sub    $0x30,%rsp
  80240c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80240f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	struct Fsreq_read *req = &ipc->read;
  802413:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802417:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	struct Fsret_read *ret = &ipc->readRet;
  80241b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80241f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	struct OpenFile *f;
	int r;
	if (debug)
		cprintf("serve_read %08x %08x %08x\n", envid, req->req_fileid, req->req_n);

	if ((r=openfile_lookup(envid,req->req_fileid,&f))<0)
  802423:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802427:	8b 00                	mov    (%rax),%eax
  802429:	89 c1                	mov    %eax,%ecx
  80242b:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  80242f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802432:	89 ce                	mov    %ecx,%esi
  802434:	89 c7                	mov    %eax,%edi
  802436:	48 b8 3e 21 80 00 00 	movabs $0x80213e,%rax
  80243d:	00 00 00 
  802440:	ff d0                	callq  *%rax
  802442:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802445:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802449:	79 05                	jns    802450 <serve_read+0x4c>
		return r;
  80244b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80244e:	eb 69                	jmp    8024b9 <serve_read+0xb5>
	if ((r=file_read(f->o_file,ret->ret_buf,req->req_n > PGSIZE ? PGSIZE : req->req_n,f->o_fd->fd_offset))<0)
  802450:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802454:	48 8b 40 18          	mov    0x18(%rax),%rax
  802458:	8b 48 04             	mov    0x4(%rax),%ecx
  80245b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80245f:	48 8b 40 08          	mov    0x8(%rax),%rax
  802463:	ba 00 10 00 00       	mov    $0x1000,%edx
  802468:	48 3d 00 10 00 00    	cmp    $0x1000,%rax
  80246e:	48 0f 46 d0          	cmovbe %rax,%rdx
  802472:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802476:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80247a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80247e:	48 89 c7             	mov    %rax,%rdi
  802481:	48 b8 84 18 80 00 00 	movabs $0x801884,%rax
  802488:	00 00 00 
  80248b:	ff d0                	callq  *%rax
  80248d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802490:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802494:	79 05                	jns    80249b <serve_read+0x97>
		return r;
  802496:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802499:	eb 1e                	jmp    8024b9 <serve_read+0xb5>
	f->o_fd->fd_offset+=r;
  80249b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80249f:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024a3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8024a7:	48 8b 52 18          	mov    0x18(%rdx),%rdx
  8024ab:	8b 4a 04             	mov    0x4(%rdx),%ecx
  8024ae:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8024b1:	01 ca                	add    %ecx,%edx
  8024b3:	89 50 04             	mov    %edx,0x4(%rax)
	return r;
  8024b6:	8b 45 ec             	mov    -0x14(%rbp),%eax
	// than requested).  Also, be careful because ipc is a union,
	// so filling in ret will overwrite req.
	//
	// LAB 5: Your code here
	panic("serve_read not implemented");
}
  8024b9:	c9                   	leaveq 
  8024ba:	c3                   	retq   

00000000008024bb <serve_write>:
// the current seek position, and update the seek position
// accordingly.  Extend the file if necessary.  Returns the number of
// bytes written, or < 0 on error.
int
serve_write(envid_t envid, struct Fsreq_write *req)
{
  8024bb:	55                   	push   %rbp
  8024bc:	48 89 e5             	mov    %rsp,%rbp
  8024bf:	48 83 ec 20          	sub    $0x20,%rsp
  8024c3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8024c6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	if (debug)
		cprintf("serve_write %08x %08x %08x\n", envid, req->req_fileid, req->req_n);
	struct OpenFile *f;
	int r;
	if ((r=openfile_lookup(envid,req->req_fileid,&f))<0)
  8024ca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024ce:	8b 00                	mov    (%rax),%eax
  8024d0:	89 c1                	mov    %eax,%ecx
  8024d2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8024d6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024d9:	89 ce                	mov    %ecx,%esi
  8024db:	89 c7                	mov    %eax,%edi
  8024dd:	48 b8 3e 21 80 00 00 	movabs $0x80213e,%rax
  8024e4:	00 00 00 
  8024e7:	ff d0                	callq  *%rax
  8024e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024f0:	79 05                	jns    8024f7 <serve_write+0x3c>
		return r;
  8024f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024f5:	eb 6d                	jmp    802564 <serve_write+0xa9>
	if ((r=file_write(f->o_file,req->req_buf,req->req_n > PGSIZE ? PGSIZE : req->req_n,f->o_fd->fd_offset))<0)
  8024f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024fb:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024ff:	8b 48 04             	mov    0x4(%rax),%ecx
  802502:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802506:	48 8b 40 08          	mov    0x8(%rax),%rax
  80250a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80250f:	48 3d 00 10 00 00    	cmp    $0x1000,%rax
  802515:	48 0f 46 d0          	cmovbe %rax,%rdx
  802519:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80251d:	48 8d 70 10          	lea    0x10(%rax),%rsi
  802521:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802525:	48 8b 40 08          	mov    0x8(%rax),%rax
  802529:	48 89 c7             	mov    %rax,%rdi
  80252c:	48 b8 da 19 80 00 00 	movabs $0x8019da,%rax
  802533:	00 00 00 
  802536:	ff d0                	callq  *%rax
  802538:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80253b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80253f:	79 05                	jns    802546 <serve_write+0x8b>
		return r;
  802541:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802544:	eb 1e                	jmp    802564 <serve_write+0xa9>
	f->o_fd->fd_offset+=r;
  802546:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80254a:	48 8b 40 18          	mov    0x18(%rax),%rax
  80254e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802552:	48 8b 52 18          	mov    0x18(%rdx),%rdx
  802556:	8b 4a 04             	mov    0x4(%rdx),%ecx
  802559:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80255c:	01 ca                	add    %ecx,%edx
  80255e:	89 50 04             	mov    %edx,0x4(%rax)
	return r;
  802561:	8b 45 fc             	mov    -0x4(%rbp),%eax

	// LAB 5: Your code here.
	panic("serve_write not implemented");
}
  802564:	c9                   	leaveq 
  802565:	c3                   	retq   

0000000000802566 <serve_stat>:

// Stat ipc->stat.req_fileid.  Return the file's struct Stat to the
// caller in ipc->statRet.
int
serve_stat(envid_t envid, union Fsipc *ipc)
{
  802566:	55                   	push   %rbp
  802567:	48 89 e5             	mov    %rsp,%rbp
  80256a:	48 83 ec 30          	sub    $0x30,%rsp
  80256e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802571:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	struct Fsreq_stat *req = &ipc->stat;
  802575:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802579:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	struct Fsret_stat *ret = &ipc->statRet;
  80257d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802581:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	int r;

	if (debug)
		cprintf("serve_stat %08x %08x\n", envid, req->req_fileid);

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  802585:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802589:	8b 00                	mov    (%rax),%eax
  80258b:	89 c1                	mov    %eax,%ecx
  80258d:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  802591:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802594:	89 ce                	mov    %ecx,%esi
  802596:	89 c7                	mov    %eax,%edi
  802598:	48 b8 3e 21 80 00 00 	movabs $0x80213e,%rax
  80259f:	00 00 00 
  8025a2:	ff d0                	callq  *%rax
  8025a4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8025a7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8025ab:	79 05                	jns    8025b2 <serve_stat+0x4c>
		return r;
  8025ad:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025b0:	eb 5f                	jmp    802611 <serve_stat+0xab>

	strcpy(ret->ret_name, o->o_file->f_name);
  8025b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025b6:	48 8b 40 08          	mov    0x8(%rax),%rax
  8025ba:	48 89 c2             	mov    %rax,%rdx
  8025bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025c1:	48 89 d6             	mov    %rdx,%rsi
  8025c4:	48 89 c7             	mov    %rax,%rdi
  8025c7:	48 b8 13 43 80 00 00 	movabs $0x804313,%rax
  8025ce:	00 00 00 
  8025d1:	ff d0                	callq  *%rax
	ret->ret_size = o->o_file->f_size;
  8025d3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025d7:	48 8b 40 08          	mov    0x8(%rax),%rax
  8025db:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8025e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025e5:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	ret->ret_isdir = (o->o_file->f_type == FTYPE_DIR);
  8025eb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025ef:	48 8b 40 08          	mov    0x8(%rax),%rax
  8025f3:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  8025f9:	83 f8 01             	cmp    $0x1,%eax
  8025fc:	0f 94 c0             	sete   %al
  8025ff:	0f b6 d0             	movzbl %al,%edx
  802602:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802606:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80260c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802611:	c9                   	leaveq 
  802612:	c3                   	retq   

0000000000802613 <serve_flush>:

// Flush all data and metadata of req->req_fileid to disk.
int
serve_flush(envid_t envid, struct Fsreq_flush *req)
{
  802613:	55                   	push   %rbp
  802614:	48 89 e5             	mov    %rsp,%rbp
  802617:	48 83 ec 20          	sub    $0x20,%rsp
  80261b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80261e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	if (debug)
		cprintf("serve_flush %08x %08x\n", envid, req->req_fileid);

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  802622:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802626:	8b 00                	mov    (%rax),%eax
  802628:	89 c1                	mov    %eax,%ecx
  80262a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80262e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802631:	89 ce                	mov    %ecx,%esi
  802633:	89 c7                	mov    %eax,%edi
  802635:	48 b8 3e 21 80 00 00 	movabs $0x80213e,%rax
  80263c:	00 00 00 
  80263f:	ff d0                	callq  *%rax
  802641:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802644:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802648:	79 05                	jns    80264f <serve_flush+0x3c>
		return r;
  80264a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80264d:	eb 1c                	jmp    80266b <serve_flush+0x58>
	file_flush(o->o_file);
  80264f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802653:	48 8b 40 08          	mov    0x8(%rax),%rax
  802657:	48 89 c7             	mov    %rax,%rdi
  80265a:	48 b8 dd 1c 80 00 00 	movabs $0x801cdd,%rax
  802661:	00 00 00 
  802664:	ff d0                	callq  *%rax
	return 0;
  802666:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80266b:	c9                   	leaveq 
  80266c:	c3                   	retq   

000000000080266d <serve_remove>:

// Remove the file req->req_path.
int
serve_remove(envid_t envid, struct Fsreq_remove *req)
{
  80266d:	55                   	push   %rbp
  80266e:	48 89 e5             	mov    %rsp,%rbp
  802671:	48 81 ec 10 04 00 00 	sub    $0x410,%rsp
  802678:	89 bd fc fb ff ff    	mov    %edi,-0x404(%rbp)
  80267e:	48 89 b5 f0 fb ff ff 	mov    %rsi,-0x410(%rbp)

	// Delete the named file.
	// Note: This request doesn't refer to an open file.

	// Copy in the path, making sure it's null-terminated
	memmove(path, req->req_path, MAXPATHLEN);
  802685:	48 8b 8d f0 fb ff ff 	mov    -0x410(%rbp),%rcx
  80268c:	48 8d 85 00 fc ff ff 	lea    -0x400(%rbp),%rax
  802693:	ba 00 04 00 00       	mov    $0x400,%edx
  802698:	48 89 ce             	mov    %rcx,%rsi
  80269b:	48 89 c7             	mov    %rax,%rdi
  80269e:	48 b8 37 46 80 00 00 	movabs $0x804637,%rax
  8026a5:	00 00 00 
  8026a8:	ff d0                	callq  *%rax
	path[MAXPATHLEN-1] = 0;
  8026aa:	c6 45 ff 00          	movb   $0x0,-0x1(%rbp)

	// Delete the specified file
	return file_remove(path);
  8026ae:	48 8d 85 00 fc ff ff 	lea    -0x400(%rbp),%rax
  8026b5:	48 89 c7             	mov    %rax,%rdi
  8026b8:	48 b8 c7 1d 80 00 00 	movabs $0x801dc7,%rax
  8026bf:	00 00 00 
  8026c2:	ff d0                	callq  *%rax
}
  8026c4:	c9                   	leaveq 
  8026c5:	c3                   	retq   

00000000008026c6 <serve_sync>:

// Sync the file system.
int
serve_sync(envid_t envid, union Fsipc *req)
{
  8026c6:	55                   	push   %rbp
  8026c7:	48 89 e5             	mov    %rsp,%rbp
  8026ca:	48 83 ec 10          	sub    $0x10,%rsp
  8026ce:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8026d1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	fs_sync();
  8026d5:	48 b8 49 1e 80 00 00 	movabs $0x801e49,%rax
  8026dc:	00 00 00 
  8026df:	ff d0                	callq  *%rax
	return 0;
  8026e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026e6:	c9                   	leaveq 
  8026e7:	c3                   	retq   

00000000008026e8 <serve>:
};
#define NHANDLERS (sizeof(handlers)/sizeof(handlers[0]))

void
serve(void)
{
  8026e8:	55                   	push   %rbp
  8026e9:	48 89 e5             	mov    %rsp,%rbp
  8026ec:	48 83 ec 20          	sub    $0x20,%rsp
	uint32_t req, whom;
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
  8026f0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  8026f7:	48 b8 20 10 81 00 00 	movabs $0x811020,%rax
  8026fe:	00 00 00 
  802701:	48 8b 08             	mov    (%rax),%rcx
  802704:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802708:	48 8d 45 f4          	lea    -0xc(%rbp),%rax
  80270c:	48 89 ce             	mov    %rcx,%rsi
  80270f:	48 89 c7             	mov    %rax,%rdi
  802712:	48 b8 f8 50 80 00 00 	movabs $0x8050f8,%rax
  802719:	00 00 00 
  80271c:	ff d0                	callq  *%rax
  80271e:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (debug)
			cprintf("fs req %d from %08x [page %08x: %s]\n",
				req, whom, uvpt[PGNUM(fsreq)], fsreq);

		// All requests must contain an argument page
		if (!(perm & PTE_P)) {
  802721:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802724:	83 e0 01             	and    $0x1,%eax
  802727:	85 c0                	test   %eax,%eax
  802729:	75 23                	jne    80274e <serve+0x66>
			cprintf("Invalid request from %08x: no argument page\n",
  80272b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80272e:	89 c6                	mov    %eax,%esi
  802730:	48 bf c0 6e 80 00 00 	movabs $0x806ec0,%rdi
  802737:	00 00 00 
  80273a:	b8 00 00 00 00       	mov    $0x0,%eax
  80273f:	48 ba 1d 37 80 00 00 	movabs $0x80371d,%rdx
  802746:	00 00 00 
  802749:	ff d2                	callq  *%rdx
				whom);
			continue; // just leave it hanging...
  80274b:	90                   	nop
		}
		ipc_send(whom, r, pg, perm);
		if(debug)
			cprintf("FS: Sent response %d to %x\n", r, whom);
		sys_page_unmap(0, fsreq);
	}
  80274c:	eb a2                	jmp    8026f0 <serve+0x8>
			cprintf("Invalid request from %08x: no argument page\n",
				whom);
			continue; // just leave it hanging...
		}

		pg = NULL;
  80274e:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802755:	00 
		if (req == FSREQ_OPEN) {
  802756:	83 7d f8 01          	cmpl   $0x1,-0x8(%rbp)
  80275a:	75 2b                	jne    802787 <serve+0x9f>
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
  80275c:	48 b8 20 10 81 00 00 	movabs $0x811020,%rax
  802763:	00 00 00 
  802766:	48 8b 30             	mov    (%rax),%rsi
  802769:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80276c:	48 8d 4d f0          	lea    -0x10(%rbp),%rcx
  802770:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802774:	89 c7                	mov    %eax,%edi
  802776:	48 b8 b2 21 80 00 00 	movabs $0x8021b2,%rax
  80277d:	00 00 00 
  802780:	ff d0                	callq  *%rax
  802782:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802785:	eb 73                	jmp    8027fa <serve+0x112>
		} else if (req < NHANDLERS && handlers[req]) {
  802787:	83 7d f8 08          	cmpl   $0x8,-0x8(%rbp)
  80278b:	77 43                	ja     8027d0 <serve+0xe8>
  80278d:	48 b8 40 10 81 00 00 	movabs $0x811040,%rax
  802794:	00 00 00 
  802797:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80279a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80279e:	48 85 c0             	test   %rax,%rax
  8027a1:	74 2d                	je     8027d0 <serve+0xe8>
			r = handlers[req](whom, fsreq);
  8027a3:	48 b8 40 10 81 00 00 	movabs $0x811040,%rax
  8027aa:	00 00 00 
  8027ad:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8027b0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027b4:	48 ba 20 10 81 00 00 	movabs $0x811020,%rdx
  8027bb:	00 00 00 
  8027be:	48 8b 0a             	mov    (%rdx),%rcx
  8027c1:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8027c4:	48 89 ce             	mov    %rcx,%rsi
  8027c7:	89 d7                	mov    %edx,%edi
  8027c9:	ff d0                	callq  *%rax
  8027cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027ce:	eb 2a                	jmp    8027fa <serve+0x112>
		} else {
			cprintf("Invalid request code %d from %08x\n", req, whom);
  8027d0:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8027d3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8027d6:	89 c6                	mov    %eax,%esi
  8027d8:	48 bf f0 6e 80 00 00 	movabs $0x806ef0,%rdi
  8027df:	00 00 00 
  8027e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e7:	48 b9 1d 37 80 00 00 	movabs $0x80371d,%rcx
  8027ee:	00 00 00 
  8027f1:	ff d1                	callq  *%rcx
			r = -E_INVAL;
  8027f3:	c7 45 fc fd ff ff ff 	movl   $0xfffffffd,-0x4(%rbp)
		}
		ipc_send(whom, r, pg, perm);
  8027fa:	8b 4d f0             	mov    -0x10(%rbp),%ecx
  8027fd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802801:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802804:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802807:	89 c7                	mov    %eax,%edi
  802809:	48 b8 ab 51 80 00 00 	movabs $0x8051ab,%rax
  802810:	00 00 00 
  802813:	ff d0                	callq  *%rax
		if(debug)
			cprintf("FS: Sent response %d to %x\n", r, whom);
		sys_page_unmap(0, fsreq);
  802815:	48 b8 20 10 81 00 00 	movabs $0x811020,%rax
  80281c:	00 00 00 
  80281f:	48 8b 00             	mov    (%rax),%rax
  802822:	48 89 c6             	mov    %rax,%rsi
  802825:	bf 00 00 00 00       	mov    $0x0,%edi
  80282a:	48 b8 ed 4c 80 00 00 	movabs $0x804ced,%rax
  802831:	00 00 00 
  802834:	ff d0                	callq  *%rax
	}
  802836:	e9 b5 fe ff ff       	jmpq   8026f0 <serve+0x8>

000000000080283b <umain>:
}

void
umain(int argc, char **argv)
{
  80283b:	55                   	push   %rbp
  80283c:	48 89 e5             	mov    %rsp,%rbp
  80283f:	48 83 ec 20          	sub    $0x20,%rsp
  802843:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802846:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	static_assert(sizeof(struct File) == 256);
	binaryname = "fs";
  80284a:	48 b8 90 10 81 00 00 	movabs $0x811090,%rax
  802851:	00 00 00 
  802854:	48 b9 13 6f 80 00 00 	movabs $0x806f13,%rcx
  80285b:	00 00 00 
  80285e:	48 89 08             	mov    %rcx,(%rax)
	cprintf("FS is running\n");
  802861:	48 bf 16 6f 80 00 00 	movabs $0x806f16,%rdi
  802868:	00 00 00 
  80286b:	b8 00 00 00 00       	mov    $0x0,%eax
  802870:	48 ba 1d 37 80 00 00 	movabs $0x80371d,%rdx
  802877:	00 00 00 
  80287a:	ff d2                	callq  *%rdx
  80287c:	c7 45 fc 00 8a 00 00 	movl   $0x8a00,-0x4(%rbp)
  802883:	66 c7 45 fa 00 8a    	movw   $0x8a00,-0x6(%rbp)
}

    static __inline void
outw(int port, uint16_t data)
{
    __asm __volatile("outw %0,%w1" : : "a" (data), "d" (port));
  802889:	0f b7 45 fa          	movzwl -0x6(%rbp),%eax
  80288d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802890:	66 ef                	out    %ax,(%dx)

	// Check that we are able to do I/O
	outw(0x8A00, 0x8A00);
	cprintf("FS can do I/O\n");
  802892:	48 bf 25 6f 80 00 00 	movabs $0x806f25,%rdi
  802899:	00 00 00 
  80289c:	b8 00 00 00 00       	mov    $0x0,%eax
  8028a1:	48 ba 1d 37 80 00 00 	movabs $0x80371d,%rdx
  8028a8:	00 00 00 
  8028ab:	ff d2                	callq  *%rdx

	serve_init();
  8028ad:	48 b8 9a 1e 80 00 00 	movabs $0x801e9a,%rax
  8028b4:	00 00 00 
  8028b7:	ff d0                	callq  *%rax
	fs_init();
  8028b9:	48 b8 aa 0f 80 00 00 	movabs $0x800faa,%rax
  8028c0:	00 00 00 
  8028c3:	ff d0                	callq  *%rax
	serve();
  8028c5:	48 b8 e8 26 80 00 00 	movabs $0x8026e8,%rax
  8028cc:	00 00 00 
  8028cf:	ff d0                	callq  *%rax
}
  8028d1:	c9                   	leaveq 
  8028d2:	c3                   	retq   

00000000008028d3 <fs_test>:

static char *msg = "This is the NEW message of the day!\n\n";

void
fs_test(void)
{
  8028d3:	55                   	push   %rbp
  8028d4:	48 89 e5             	mov    %rsp,%rbp
  8028d7:	48 83 ec 20          	sub    $0x20,%rsp
	int r;
	char *blk;
	uint32_t *bits;

	// back up bitmap
	if ((r = sys_page_alloc(0, (void*) PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  8028db:	ba 07 00 00 00       	mov    $0x7,%edx
  8028e0:	be 00 10 00 00       	mov    $0x1000,%esi
  8028e5:	bf 00 00 00 00       	mov    $0x0,%edi
  8028ea:	48 b8 42 4c 80 00 00 	movabs $0x804c42,%rax
  8028f1:	00 00 00 
  8028f4:	ff d0                	callq  *%rax
  8028f6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028fd:	79 30                	jns    80292f <fs_test+0x5c>
		panic("sys_page_alloc: %e", r);
  8028ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802902:	89 c1                	mov    %eax,%ecx
  802904:	48 ba 5e 6f 80 00 00 	movabs $0x806f5e,%rdx
  80290b:	00 00 00 
  80290e:	be 13 00 00 00       	mov    $0x13,%esi
  802913:	48 bf 71 6f 80 00 00 	movabs $0x806f71,%rdi
  80291a:	00 00 00 
  80291d:	b8 00 00 00 00       	mov    $0x0,%eax
  802922:	49 b8 e4 34 80 00 00 	movabs $0x8034e4,%r8
  802929:	00 00 00 
  80292c:	41 ff d0             	callq  *%r8
	bits = (uint32_t*) PGSIZE;
  80292f:	48 c7 45 f0 00 10 00 	movq   $0x1000,-0x10(%rbp)
  802936:	00 
	memmove(bits, bitmap, PGSIZE);
  802937:	48 b8 10 40 81 00 00 	movabs $0x814010,%rax
  80293e:	00 00 00 
  802941:	48 8b 08             	mov    (%rax),%rcx
  802944:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802948:	ba 00 10 00 00       	mov    $0x1000,%edx
  80294d:	48 89 ce             	mov    %rcx,%rsi
  802950:	48 89 c7             	mov    %rax,%rdi
  802953:	48 b8 37 46 80 00 00 	movabs $0x804637,%rax
  80295a:	00 00 00 
  80295d:	ff d0                	callq  *%rax
	// allocate block
	if ((r = alloc_block()) < 0)
  80295f:	48 b8 bf 0d 80 00 00 	movabs $0x800dbf,%rax
  802966:	00 00 00 
  802969:	ff d0                	callq  *%rax
  80296b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80296e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802972:	79 30                	jns    8029a4 <fs_test+0xd1>
		panic("alloc_block: %e", r);
  802974:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802977:	89 c1                	mov    %eax,%ecx
  802979:	48 ba 7b 6f 80 00 00 	movabs $0x806f7b,%rdx
  802980:	00 00 00 
  802983:	be 18 00 00 00       	mov    $0x18,%esi
  802988:	48 bf 71 6f 80 00 00 	movabs $0x806f71,%rdi
  80298f:	00 00 00 
  802992:	b8 00 00 00 00       	mov    $0x0,%eax
  802997:	49 b8 e4 34 80 00 00 	movabs $0x8034e4,%r8
  80299e:	00 00 00 
  8029a1:	41 ff d0             	callq  *%r8
	// check that block was free
	assert(bits[r/32] & (1 << (r%32)));
  8029a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029a7:	8d 50 1f             	lea    0x1f(%rax),%edx
  8029aa:	85 c0                	test   %eax,%eax
  8029ac:	0f 48 c2             	cmovs  %edx,%eax
  8029af:	c1 f8 05             	sar    $0x5,%eax
  8029b2:	48 98                	cltq   
  8029b4:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
  8029bb:	00 
  8029bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029c0:	48 01 d0             	add    %rdx,%rax
  8029c3:	8b 30                	mov    (%rax),%esi
  8029c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029c8:	99                   	cltd   
  8029c9:	c1 ea 1b             	shr    $0x1b,%edx
  8029cc:	01 d0                	add    %edx,%eax
  8029ce:	83 e0 1f             	and    $0x1f,%eax
  8029d1:	29 d0                	sub    %edx,%eax
  8029d3:	ba 01 00 00 00       	mov    $0x1,%edx
  8029d8:	89 c1                	mov    %eax,%ecx
  8029da:	d3 e2                	shl    %cl,%edx
  8029dc:	89 d0                	mov    %edx,%eax
  8029de:	21 f0                	and    %esi,%eax
  8029e0:	85 c0                	test   %eax,%eax
  8029e2:	75 35                	jne    802a19 <fs_test+0x146>
  8029e4:	48 b9 8b 6f 80 00 00 	movabs $0x806f8b,%rcx
  8029eb:	00 00 00 
  8029ee:	48 ba a6 6f 80 00 00 	movabs $0x806fa6,%rdx
  8029f5:	00 00 00 
  8029f8:	be 1a 00 00 00       	mov    $0x1a,%esi
  8029fd:	48 bf 71 6f 80 00 00 	movabs $0x806f71,%rdi
  802a04:	00 00 00 
  802a07:	b8 00 00 00 00       	mov    $0x0,%eax
  802a0c:	49 b8 e4 34 80 00 00 	movabs $0x8034e4,%r8
  802a13:	00 00 00 
  802a16:	41 ff d0             	callq  *%r8
	// and is not free any more
	assert(!(bitmap[r/32] & (1 << (r%32))));
  802a19:	48 b8 10 40 81 00 00 	movabs $0x814010,%rax
  802a20:	00 00 00 
  802a23:	48 8b 10             	mov    (%rax),%rdx
  802a26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a29:	8d 48 1f             	lea    0x1f(%rax),%ecx
  802a2c:	85 c0                	test   %eax,%eax
  802a2e:	0f 48 c1             	cmovs  %ecx,%eax
  802a31:	c1 f8 05             	sar    $0x5,%eax
  802a34:	48 98                	cltq   
  802a36:	48 c1 e0 02          	shl    $0x2,%rax
  802a3a:	48 01 d0             	add    %rdx,%rax
  802a3d:	8b 30                	mov    (%rax),%esi
  802a3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a42:	99                   	cltd   
  802a43:	c1 ea 1b             	shr    $0x1b,%edx
  802a46:	01 d0                	add    %edx,%eax
  802a48:	83 e0 1f             	and    $0x1f,%eax
  802a4b:	29 d0                	sub    %edx,%eax
  802a4d:	ba 01 00 00 00       	mov    $0x1,%edx
  802a52:	89 c1                	mov    %eax,%ecx
  802a54:	d3 e2                	shl    %cl,%edx
  802a56:	89 d0                	mov    %edx,%eax
  802a58:	21 f0                	and    %esi,%eax
  802a5a:	85 c0                	test   %eax,%eax
  802a5c:	74 35                	je     802a93 <fs_test+0x1c0>
  802a5e:	48 b9 c0 6f 80 00 00 	movabs $0x806fc0,%rcx
  802a65:	00 00 00 
  802a68:	48 ba a6 6f 80 00 00 	movabs $0x806fa6,%rdx
  802a6f:	00 00 00 
  802a72:	be 1c 00 00 00       	mov    $0x1c,%esi
  802a77:	48 bf 71 6f 80 00 00 	movabs $0x806f71,%rdi
  802a7e:	00 00 00 
  802a81:	b8 00 00 00 00       	mov    $0x0,%eax
  802a86:	49 b8 e4 34 80 00 00 	movabs $0x8034e4,%r8
  802a8d:	00 00 00 
  802a90:	41 ff d0             	callq  *%r8
	cprintf("alloc_block is good\n");
  802a93:	48 bf e0 6f 80 00 00 	movabs $0x806fe0,%rdi
  802a9a:	00 00 00 
  802a9d:	b8 00 00 00 00       	mov    $0x0,%eax
  802aa2:	48 ba 1d 37 80 00 00 	movabs $0x80371d,%rdx
  802aa9:	00 00 00 
  802aac:	ff d2                	callq  *%rdx

	if ((r = file_open("/not-found", &f)) < 0 && r != -E_NOT_FOUND)
  802aae:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802ab2:	48 89 c6             	mov    %rax,%rsi
  802ab5:	48 bf f5 6f 80 00 00 	movabs $0x806ff5,%rdi
  802abc:	00 00 00 
  802abf:	48 b8 51 18 80 00 00 	movabs $0x801851,%rax
  802ac6:	00 00 00 
  802ac9:	ff d0                	callq  *%rax
  802acb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ace:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ad2:	79 36                	jns    802b0a <fs_test+0x237>
  802ad4:	83 7d fc f4          	cmpl   $0xfffffff4,-0x4(%rbp)
  802ad8:	74 30                	je     802b0a <fs_test+0x237>
		panic("file_open /not-found: %e", r);
  802ada:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802add:	89 c1                	mov    %eax,%ecx
  802adf:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  802ae6:	00 00 00 
  802ae9:	be 20 00 00 00       	mov    $0x20,%esi
  802aee:	48 bf 71 6f 80 00 00 	movabs $0x806f71,%rdi
  802af5:	00 00 00 
  802af8:	b8 00 00 00 00       	mov    $0x0,%eax
  802afd:	49 b8 e4 34 80 00 00 	movabs $0x8034e4,%r8
  802b04:	00 00 00 
  802b07:	41 ff d0             	callq  *%r8
	else if (r == 0)
  802b0a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b0e:	75 2a                	jne    802b3a <fs_test+0x267>
		panic("file_open /not-found succeeded!");
  802b10:	48 ba 20 70 80 00 00 	movabs $0x807020,%rdx
  802b17:	00 00 00 
  802b1a:	be 22 00 00 00       	mov    $0x22,%esi
  802b1f:	48 bf 71 6f 80 00 00 	movabs $0x806f71,%rdi
  802b26:	00 00 00 
  802b29:	b8 00 00 00 00       	mov    $0x0,%eax
  802b2e:	48 b9 e4 34 80 00 00 	movabs $0x8034e4,%rcx
  802b35:	00 00 00 
  802b38:	ff d1                	callq  *%rcx
	if ((r = file_open("/newmotd", &f)) < 0)
  802b3a:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802b3e:	48 89 c6             	mov    %rax,%rsi
  802b41:	48 bf 40 70 80 00 00 	movabs $0x807040,%rdi
  802b48:	00 00 00 
  802b4b:	48 b8 51 18 80 00 00 	movabs $0x801851,%rax
  802b52:	00 00 00 
  802b55:	ff d0                	callq  *%rax
  802b57:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b5a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b5e:	79 30                	jns    802b90 <fs_test+0x2bd>
		panic("file_open /newmotd: %e", r);
  802b60:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b63:	89 c1                	mov    %eax,%ecx
  802b65:	48 ba 49 70 80 00 00 	movabs $0x807049,%rdx
  802b6c:	00 00 00 
  802b6f:	be 24 00 00 00       	mov    $0x24,%esi
  802b74:	48 bf 71 6f 80 00 00 	movabs $0x806f71,%rdi
  802b7b:	00 00 00 
  802b7e:	b8 00 00 00 00       	mov    $0x0,%eax
  802b83:	49 b8 e4 34 80 00 00 	movabs $0x8034e4,%r8
  802b8a:	00 00 00 
  802b8d:	41 ff d0             	callq  *%r8
	cprintf("file_open is good\n");
  802b90:	48 bf 60 70 80 00 00 	movabs $0x807060,%rdi
  802b97:	00 00 00 
  802b9a:	b8 00 00 00 00       	mov    $0x0,%eax
  802b9f:	48 ba 1d 37 80 00 00 	movabs $0x80371d,%rdx
  802ba6:	00 00 00 
  802ba9:	ff d2                	callq  *%rdx

	if ((r = file_get_block(f, 0, &blk)) < 0)
  802bab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802baf:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  802bb3:	be 00 00 00 00       	mov    $0x0,%esi
  802bb8:	48 89 c7             	mov    %rax,%rdi
  802bbb:	48 b8 73 11 80 00 00 	movabs $0x801173,%rax
  802bc2:	00 00 00 
  802bc5:	ff d0                	callq  *%rax
  802bc7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bce:	79 30                	jns    802c00 <fs_test+0x32d>
		panic("file_get_block: %e", r);
  802bd0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bd3:	89 c1                	mov    %eax,%ecx
  802bd5:	48 ba 73 70 80 00 00 	movabs $0x807073,%rdx
  802bdc:	00 00 00 
  802bdf:	be 28 00 00 00       	mov    $0x28,%esi
  802be4:	48 bf 71 6f 80 00 00 	movabs $0x806f71,%rdi
  802beb:	00 00 00 
  802bee:	b8 00 00 00 00       	mov    $0x0,%eax
  802bf3:	49 b8 e4 34 80 00 00 	movabs $0x8034e4,%r8
  802bfa:	00 00 00 
  802bfd:	41 ff d0             	callq  *%r8
	if (strcmp(blk, msg) != 0)
  802c00:	48 b8 88 10 81 00 00 	movabs $0x811088,%rax
  802c07:	00 00 00 
  802c0a:	48 8b 10             	mov    (%rax),%rdx
  802c0d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c11:	48 89 d6             	mov    %rdx,%rsi
  802c14:	48 89 c7             	mov    %rax,%rdi
  802c17:	48 b8 75 44 80 00 00 	movabs $0x804475,%rax
  802c1e:	00 00 00 
  802c21:	ff d0                	callq  *%rax
  802c23:	85 c0                	test   %eax,%eax
  802c25:	74 2a                	je     802c51 <fs_test+0x37e>
		panic("file_get_block returned wrong data");
  802c27:	48 ba 88 70 80 00 00 	movabs $0x807088,%rdx
  802c2e:	00 00 00 
  802c31:	be 2a 00 00 00       	mov    $0x2a,%esi
  802c36:	48 bf 71 6f 80 00 00 	movabs $0x806f71,%rdi
  802c3d:	00 00 00 
  802c40:	b8 00 00 00 00       	mov    $0x0,%eax
  802c45:	48 b9 e4 34 80 00 00 	movabs $0x8034e4,%rcx
  802c4c:	00 00 00 
  802c4f:	ff d1                	callq  *%rcx
	cprintf("file_get_block is good\n");
  802c51:	48 bf ab 70 80 00 00 	movabs $0x8070ab,%rdi
  802c58:	00 00 00 
  802c5b:	b8 00 00 00 00       	mov    $0x0,%eax
  802c60:	48 ba 1d 37 80 00 00 	movabs $0x80371d,%rdx
  802c67:	00 00 00 
  802c6a:	ff d2                	callq  *%rdx

	*(volatile char*)blk = *(volatile char*)blk;
  802c6c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c70:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c74:	0f b6 12             	movzbl (%rdx),%edx
  802c77:	88 10                	mov    %dl,(%rax)
	assert((uvpt[PGNUM(blk)] & PTE_D));
  802c79:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c7d:	48 c1 e8 0c          	shr    $0xc,%rax
  802c81:	48 89 c2             	mov    %rax,%rdx
  802c84:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802c8b:	01 00 00 
  802c8e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c92:	83 e0 40             	and    $0x40,%eax
  802c95:	48 85 c0             	test   %rax,%rax
  802c98:	75 35                	jne    802ccf <fs_test+0x3fc>
  802c9a:	48 b9 c3 70 80 00 00 	movabs $0x8070c3,%rcx
  802ca1:	00 00 00 
  802ca4:	48 ba a6 6f 80 00 00 	movabs $0x806fa6,%rdx
  802cab:	00 00 00 
  802cae:	be 2e 00 00 00       	mov    $0x2e,%esi
  802cb3:	48 bf 71 6f 80 00 00 	movabs $0x806f71,%rdi
  802cba:	00 00 00 
  802cbd:	b8 00 00 00 00       	mov    $0x0,%eax
  802cc2:	49 b8 e4 34 80 00 00 	movabs $0x8034e4,%r8
  802cc9:	00 00 00 
  802ccc:	41 ff d0             	callq  *%r8
	file_flush(f);
  802ccf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cd3:	48 89 c7             	mov    %rax,%rdi
  802cd6:	48 b8 dd 1c 80 00 00 	movabs $0x801cdd,%rax
  802cdd:	00 00 00 
  802ce0:	ff d0                	callq  *%rax
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  802ce2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ce6:	48 c1 e8 0c          	shr    $0xc,%rax
  802cea:	48 89 c2             	mov    %rax,%rdx
  802ced:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802cf4:	01 00 00 
  802cf7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802cfb:	83 e0 40             	and    $0x40,%eax
  802cfe:	48 85 c0             	test   %rax,%rax
  802d01:	74 35                	je     802d38 <fs_test+0x465>
  802d03:	48 b9 de 70 80 00 00 	movabs $0x8070de,%rcx
  802d0a:	00 00 00 
  802d0d:	48 ba a6 6f 80 00 00 	movabs $0x806fa6,%rdx
  802d14:	00 00 00 
  802d17:	be 30 00 00 00       	mov    $0x30,%esi
  802d1c:	48 bf 71 6f 80 00 00 	movabs $0x806f71,%rdi
  802d23:	00 00 00 
  802d26:	b8 00 00 00 00       	mov    $0x0,%eax
  802d2b:	49 b8 e4 34 80 00 00 	movabs $0x8034e4,%r8
  802d32:	00 00 00 
  802d35:	41 ff d0             	callq  *%r8
	cprintf("file_flush is good\n");
  802d38:	48 bf fa 70 80 00 00 	movabs $0x8070fa,%rdi
  802d3f:	00 00 00 
  802d42:	b8 00 00 00 00       	mov    $0x0,%eax
  802d47:	48 ba 1d 37 80 00 00 	movabs $0x80371d,%rdx
  802d4e:	00 00 00 
  802d51:	ff d2                	callq  *%rdx

	if ((r = file_set_size(f, 0)) < 0)
  802d53:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d57:	be 00 00 00 00       	mov    $0x0,%esi
  802d5c:	48 89 c7             	mov    %rax,%rdi
  802d5f:	48 b8 80 1c 80 00 00 	movabs $0x801c80,%rax
  802d66:	00 00 00 
  802d69:	ff d0                	callq  *%rax
  802d6b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d6e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d72:	79 30                	jns    802da4 <fs_test+0x4d1>
		panic("file_set_size: %e", r);
  802d74:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d77:	89 c1                	mov    %eax,%ecx
  802d79:	48 ba 0e 71 80 00 00 	movabs $0x80710e,%rdx
  802d80:	00 00 00 
  802d83:	be 34 00 00 00       	mov    $0x34,%esi
  802d88:	48 bf 71 6f 80 00 00 	movabs $0x806f71,%rdi
  802d8f:	00 00 00 
  802d92:	b8 00 00 00 00       	mov    $0x0,%eax
  802d97:	49 b8 e4 34 80 00 00 	movabs $0x8034e4,%r8
  802d9e:	00 00 00 
  802da1:	41 ff d0             	callq  *%r8
	assert(f->f_direct[0] == 0);
  802da4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802da8:	8b 80 88 00 00 00    	mov    0x88(%rax),%eax
  802dae:	85 c0                	test   %eax,%eax
  802db0:	74 35                	je     802de7 <fs_test+0x514>
  802db2:	48 b9 20 71 80 00 00 	movabs $0x807120,%rcx
  802db9:	00 00 00 
  802dbc:	48 ba a6 6f 80 00 00 	movabs $0x806fa6,%rdx
  802dc3:	00 00 00 
  802dc6:	be 35 00 00 00       	mov    $0x35,%esi
  802dcb:	48 bf 71 6f 80 00 00 	movabs $0x806f71,%rdi
  802dd2:	00 00 00 
  802dd5:	b8 00 00 00 00       	mov    $0x0,%eax
  802dda:	49 b8 e4 34 80 00 00 	movabs $0x8034e4,%r8
  802de1:	00 00 00 
  802de4:	41 ff d0             	callq  *%r8
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  802de7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802deb:	48 c1 e8 0c          	shr    $0xc,%rax
  802def:	48 89 c2             	mov    %rax,%rdx
  802df2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802df9:	01 00 00 
  802dfc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e00:	83 e0 40             	and    $0x40,%eax
  802e03:	48 85 c0             	test   %rax,%rax
  802e06:	74 35                	je     802e3d <fs_test+0x56a>
  802e08:	48 b9 34 71 80 00 00 	movabs $0x807134,%rcx
  802e0f:	00 00 00 
  802e12:	48 ba a6 6f 80 00 00 	movabs $0x806fa6,%rdx
  802e19:	00 00 00 
  802e1c:	be 36 00 00 00       	mov    $0x36,%esi
  802e21:	48 bf 71 6f 80 00 00 	movabs $0x806f71,%rdi
  802e28:	00 00 00 
  802e2b:	b8 00 00 00 00       	mov    $0x0,%eax
  802e30:	49 b8 e4 34 80 00 00 	movabs $0x8034e4,%r8
  802e37:	00 00 00 
  802e3a:	41 ff d0             	callq  *%r8
	cprintf("file_truncate is good\n");
  802e3d:	48 bf 4e 71 80 00 00 	movabs $0x80714e,%rdi
  802e44:	00 00 00 
  802e47:	b8 00 00 00 00       	mov    $0x0,%eax
  802e4c:	48 ba 1d 37 80 00 00 	movabs $0x80371d,%rdx
  802e53:	00 00 00 
  802e56:	ff d2                	callq  *%rdx

	if ((r = file_set_size(f, strlen(msg))) < 0)
  802e58:	48 b8 88 10 81 00 00 	movabs $0x811088,%rax
  802e5f:	00 00 00 
  802e62:	48 8b 00             	mov    (%rax),%rax
  802e65:	48 89 c7             	mov    %rax,%rdi
  802e68:	48 b8 a7 42 80 00 00 	movabs $0x8042a7,%rax
  802e6f:	00 00 00 
  802e72:	ff d0                	callq  *%rax
  802e74:	89 c2                	mov    %eax,%edx
  802e76:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e7a:	89 d6                	mov    %edx,%esi
  802e7c:	48 89 c7             	mov    %rax,%rdi
  802e7f:	48 b8 80 1c 80 00 00 	movabs $0x801c80,%rax
  802e86:	00 00 00 
  802e89:	ff d0                	callq  *%rax
  802e8b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e8e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e92:	79 30                	jns    802ec4 <fs_test+0x5f1>
		panic("file_set_size 2: %e", r);
  802e94:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e97:	89 c1                	mov    %eax,%ecx
  802e99:	48 ba 65 71 80 00 00 	movabs $0x807165,%rdx
  802ea0:	00 00 00 
  802ea3:	be 3a 00 00 00       	mov    $0x3a,%esi
  802ea8:	48 bf 71 6f 80 00 00 	movabs $0x806f71,%rdi
  802eaf:	00 00 00 
  802eb2:	b8 00 00 00 00       	mov    $0x0,%eax
  802eb7:	49 b8 e4 34 80 00 00 	movabs $0x8034e4,%r8
  802ebe:	00 00 00 
  802ec1:	41 ff d0             	callq  *%r8
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  802ec4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ec8:	48 c1 e8 0c          	shr    $0xc,%rax
  802ecc:	48 89 c2             	mov    %rax,%rdx
  802ecf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802ed6:	01 00 00 
  802ed9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802edd:	83 e0 40             	and    $0x40,%eax
  802ee0:	48 85 c0             	test   %rax,%rax
  802ee3:	74 35                	je     802f1a <fs_test+0x647>
  802ee5:	48 b9 34 71 80 00 00 	movabs $0x807134,%rcx
  802eec:	00 00 00 
  802eef:	48 ba a6 6f 80 00 00 	movabs $0x806fa6,%rdx
  802ef6:	00 00 00 
  802ef9:	be 3b 00 00 00       	mov    $0x3b,%esi
  802efe:	48 bf 71 6f 80 00 00 	movabs $0x806f71,%rdi
  802f05:	00 00 00 
  802f08:	b8 00 00 00 00       	mov    $0x0,%eax
  802f0d:	49 b8 e4 34 80 00 00 	movabs $0x8034e4,%r8
  802f14:	00 00 00 
  802f17:	41 ff d0             	callq  *%r8
	if ((r = file_get_block(f, 0, &blk)) < 0)
  802f1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f1e:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  802f22:	be 00 00 00 00       	mov    $0x0,%esi
  802f27:	48 89 c7             	mov    %rax,%rdi
  802f2a:	48 b8 73 11 80 00 00 	movabs $0x801173,%rax
  802f31:	00 00 00 
  802f34:	ff d0                	callq  *%rax
  802f36:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f39:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f3d:	79 30                	jns    802f6f <fs_test+0x69c>
		panic("file_get_block 2: %e", r);
  802f3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f42:	89 c1                	mov    %eax,%ecx
  802f44:	48 ba 79 71 80 00 00 	movabs $0x807179,%rdx
  802f4b:	00 00 00 
  802f4e:	be 3d 00 00 00       	mov    $0x3d,%esi
  802f53:	48 bf 71 6f 80 00 00 	movabs $0x806f71,%rdi
  802f5a:	00 00 00 
  802f5d:	b8 00 00 00 00       	mov    $0x0,%eax
  802f62:	49 b8 e4 34 80 00 00 	movabs $0x8034e4,%r8
  802f69:	00 00 00 
  802f6c:	41 ff d0             	callq  *%r8
	strcpy(blk, msg);
  802f6f:	48 b8 88 10 81 00 00 	movabs $0x811088,%rax
  802f76:	00 00 00 
  802f79:	48 8b 10             	mov    (%rax),%rdx
  802f7c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f80:	48 89 d6             	mov    %rdx,%rsi
  802f83:	48 89 c7             	mov    %rax,%rdi
  802f86:	48 b8 13 43 80 00 00 	movabs $0x804313,%rax
  802f8d:	00 00 00 
  802f90:	ff d0                	callq  *%rax
	assert((uvpt[PGNUM(blk)] & PTE_D));
  802f92:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f96:	48 c1 e8 0c          	shr    $0xc,%rax
  802f9a:	48 89 c2             	mov    %rax,%rdx
  802f9d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802fa4:	01 00 00 
  802fa7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802fab:	83 e0 40             	and    $0x40,%eax
  802fae:	48 85 c0             	test   %rax,%rax
  802fb1:	75 35                	jne    802fe8 <fs_test+0x715>
  802fb3:	48 b9 c3 70 80 00 00 	movabs $0x8070c3,%rcx
  802fba:	00 00 00 
  802fbd:	48 ba a6 6f 80 00 00 	movabs $0x806fa6,%rdx
  802fc4:	00 00 00 
  802fc7:	be 3f 00 00 00       	mov    $0x3f,%esi
  802fcc:	48 bf 71 6f 80 00 00 	movabs $0x806f71,%rdi
  802fd3:	00 00 00 
  802fd6:	b8 00 00 00 00       	mov    $0x0,%eax
  802fdb:	49 b8 e4 34 80 00 00 	movabs $0x8034e4,%r8
  802fe2:	00 00 00 
  802fe5:	41 ff d0             	callq  *%r8
	file_flush(f);
  802fe8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fec:	48 89 c7             	mov    %rax,%rdi
  802fef:	48 b8 dd 1c 80 00 00 	movabs $0x801cdd,%rax
  802ff6:	00 00 00 
  802ff9:	ff d0                	callq  *%rax
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  802ffb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fff:	48 c1 e8 0c          	shr    $0xc,%rax
  803003:	48 89 c2             	mov    %rax,%rdx
  803006:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80300d:	01 00 00 
  803010:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803014:	83 e0 40             	and    $0x40,%eax
  803017:	48 85 c0             	test   %rax,%rax
  80301a:	74 35                	je     803051 <fs_test+0x77e>
  80301c:	48 b9 de 70 80 00 00 	movabs $0x8070de,%rcx
  803023:	00 00 00 
  803026:	48 ba a6 6f 80 00 00 	movabs $0x806fa6,%rdx
  80302d:	00 00 00 
  803030:	be 41 00 00 00       	mov    $0x41,%esi
  803035:	48 bf 71 6f 80 00 00 	movabs $0x806f71,%rdi
  80303c:	00 00 00 
  80303f:	b8 00 00 00 00       	mov    $0x0,%eax
  803044:	49 b8 e4 34 80 00 00 	movabs $0x8034e4,%r8
  80304b:	00 00 00 
  80304e:	41 ff d0             	callq  *%r8
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  803051:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803055:	48 c1 e8 0c          	shr    $0xc,%rax
  803059:	48 89 c2             	mov    %rax,%rdx
  80305c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803063:	01 00 00 
  803066:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80306a:	83 e0 40             	and    $0x40,%eax
  80306d:	48 85 c0             	test   %rax,%rax
  803070:	74 35                	je     8030a7 <fs_test+0x7d4>
  803072:	48 b9 34 71 80 00 00 	movabs $0x807134,%rcx
  803079:	00 00 00 
  80307c:	48 ba a6 6f 80 00 00 	movabs $0x806fa6,%rdx
  803083:	00 00 00 
  803086:	be 42 00 00 00       	mov    $0x42,%esi
  80308b:	48 bf 71 6f 80 00 00 	movabs $0x806f71,%rdi
  803092:	00 00 00 
  803095:	b8 00 00 00 00       	mov    $0x0,%eax
  80309a:	49 b8 e4 34 80 00 00 	movabs $0x8034e4,%r8
  8030a1:	00 00 00 
  8030a4:	41 ff d0             	callq  *%r8
	cprintf("file rewrite is good\n");
  8030a7:	48 bf 8e 71 80 00 00 	movabs $0x80718e,%rdi
  8030ae:	00 00 00 
  8030b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8030b6:	48 ba 1d 37 80 00 00 	movabs $0x80371d,%rdx
  8030bd:	00 00 00 
  8030c0:	ff d2                	callq  *%rdx
}
  8030c2:	c9                   	leaveq 
  8030c3:	c3                   	retq   

00000000008030c4 <host_fsipc>:
static struct Fd *host_fd;
static union Fsipc host_fsipcbuf __attribute__((aligned(PGSIZE)));

static int
host_fsipc(unsigned type, void *dstva)
{
  8030c4:	55                   	push   %rbp
  8030c5:	48 89 e5             	mov    %rsp,%rbp
  8030c8:	48 83 ec 10          	sub    $0x10,%rsp
  8030cc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8030cf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	ipc_host_send(VMX_HOST_FS_ENV, type, &host_fsipcbuf, PTE_P | PTE_W | PTE_U);
  8030d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030d6:	b9 07 00 00 00       	mov    $0x7,%ecx
  8030db:	48 ba 00 30 81 00 00 	movabs $0x813000,%rdx
  8030e2:	00 00 00 
  8030e5:	89 c6                	mov    %eax,%esi
  8030e7:	bf 01 00 00 00       	mov    $0x1,%edi
  8030ec:	48 b8 6b 52 80 00 00 	movabs $0x80526b,%rax
  8030f3:	00 00 00 
  8030f6:	ff d0                	callq  *%rax
	return ipc_host_recv(dstva);
  8030f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030fc:	48 89 c7             	mov    %rax,%rdi
  8030ff:	48 b8 35 52 80 00 00 	movabs $0x805235,%rax
  803106:	00 00 00 
  803109:	ff d0                	callq  *%rax
}
  80310b:	c9                   	leaveq 
  80310c:	c3                   	retq   

000000000080310d <get_host_fd>:


uint64_t
get_host_fd() 
{
  80310d:	55                   	push   %rbp
  80310e:	48 89 e5             	mov    %rsp,%rbp
	return (uint64_t) host_fd;
  803111:	48 b8 00 20 81 00 00 	movabs $0x812000,%rax
  803118:	00 00 00 
  80311b:	48 8b 00             	mov    (%rax),%rax
}
  80311e:	5d                   	pop    %rbp
  80311f:	c3                   	retq   

0000000000803120 <host_read>:

int
host_read(uint32_t secno, void *dst, size_t nsecs)
{
  803120:	55                   	push   %rbp
  803121:	48 89 e5             	mov    %rsp,%rbp
  803124:	48 83 ec 30          	sub    $0x30,%rsp
  803128:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80312b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80312f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r, read = 0;
  803133:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)

	if(host_fd->fd_file.id == 0) {
  80313a:	48 b8 00 20 81 00 00 	movabs $0x812000,%rax
  803141:	00 00 00 
  803144:	48 8b 00             	mov    (%rax),%rax
  803147:	8b 40 0c             	mov    0xc(%rax),%eax
  80314a:	85 c0                	test   %eax,%eax
  80314c:	75 11                	jne    80315f <host_read+0x3f>
		host_ipc_init();
  80314e:	b8 00 00 00 00       	mov    $0x0,%eax
  803153:	48 ba 0d 33 80 00 00 	movabs $0x80330d,%rdx
  80315a:	00 00 00 
  80315d:	ff d2                	callq  *%rdx
	}

	host_fd->fd_offset = secno * SECTSIZE;
  80315f:	48 b8 00 20 81 00 00 	movabs $0x812000,%rax
  803166:	00 00 00 
  803169:	48 8b 00             	mov    (%rax),%rax
  80316c:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80316f:	c1 e2 09             	shl    $0x9,%edx
  803172:	89 50 04             	mov    %edx,0x4(%rax)
	// read from the host, 2 sectors at a time.
	for(; nsecs > 0; nsecs-=2) {
  803175:	e9 8c 00 00 00       	jmpq   803206 <host_read+0xe6>

		host_fsipcbuf.read.req_fileid = host_fd->fd_file.id;
  80317a:	48 b8 00 20 81 00 00 	movabs $0x812000,%rax
  803181:	00 00 00 
  803184:	48 8b 00             	mov    (%rax),%rax
  803187:	8b 50 0c             	mov    0xc(%rax),%edx
  80318a:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  803191:	00 00 00 
  803194:	89 10                	mov    %edx,(%rax)
		host_fsipcbuf.read.req_n = SECTSIZE * 2;
  803196:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  80319d:	00 00 00 
  8031a0:	48 c7 40 08 00 04 00 	movq   $0x400,0x8(%rax)
  8031a7:	00 
		if ((r = host_fsipc(FSREQ_READ, NULL)) < 0)
  8031a8:	be 00 00 00 00       	mov    $0x0,%esi
  8031ad:	bf 03 00 00 00       	mov    $0x3,%edi
  8031b2:	48 b8 c4 30 80 00 00 	movabs $0x8030c4,%rax
  8031b9:	00 00 00 
  8031bc:	ff d0                	callq  *%rax
  8031be:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8031c1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8031c5:	79 05                	jns    8031cc <host_read+0xac>
			return r;
  8031c7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031ca:	eb 4a                	jmp    803216 <host_read+0xf6>
		// FIXME: Handle case where r < SECTSIZE * 2;
		memmove(dst+read, &host_fsipcbuf, r);
  8031cc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031cf:	48 98                	cltq   
  8031d1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8031d4:	48 63 ca             	movslq %edx,%rcx
  8031d7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8031db:	48 01 d1             	add    %rdx,%rcx
  8031de:	48 89 c2             	mov    %rax,%rdx
  8031e1:	48 be 00 30 81 00 00 	movabs $0x813000,%rsi
  8031e8:	00 00 00 
  8031eb:	48 89 cf             	mov    %rcx,%rdi
  8031ee:	48 b8 37 46 80 00 00 	movabs $0x804637,%rax
  8031f5:	00 00 00 
  8031f8:	ff d0                	callq  *%rax
		read += SECTSIZE * 2;
  8031fa:	81 45 fc 00 04 00 00 	addl   $0x400,-0x4(%rbp)
		host_ipc_init();
	}

	host_fd->fd_offset = secno * SECTSIZE;
	// read from the host, 2 sectors at a time.
	for(; nsecs > 0; nsecs-=2) {
  803201:	48 83 6d d8 02       	subq   $0x2,-0x28(%rbp)
  803206:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80320b:	0f 85 69 ff ff ff    	jne    80317a <host_read+0x5a>
		// FIXME: Handle case where r < SECTSIZE * 2;
		memmove(dst+read, &host_fsipcbuf, r);
		read += SECTSIZE * 2;
	}

	return 0;
  803211:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803216:	c9                   	leaveq 
  803217:	c3                   	retq   

0000000000803218 <host_write>:

int
host_write(uint32_t secno, const void *src, size_t nsecs)
{
  803218:	55                   	push   %rbp
  803219:	48 89 e5             	mov    %rsp,%rbp
  80321c:	48 83 ec 30          	sub    $0x30,%rsp
  803220:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803223:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803227:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r, written = 0;
  80322b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    
	if(host_fd->fd_file.id == 0) {
  803232:	48 b8 00 20 81 00 00 	movabs $0x812000,%rax
  803239:	00 00 00 
  80323c:	48 8b 00             	mov    (%rax),%rax
  80323f:	8b 40 0c             	mov    0xc(%rax),%eax
  803242:	85 c0                	test   %eax,%eax
  803244:	75 11                	jne    803257 <host_write+0x3f>
		host_ipc_init();
  803246:	b8 00 00 00 00       	mov    $0x0,%eax
  80324b:	48 ba 0d 33 80 00 00 	movabs $0x80330d,%rdx
  803252:	00 00 00 
  803255:	ff d2                	callq  *%rdx
	}

	host_fd->fd_offset = secno * SECTSIZE;
  803257:	48 b8 00 20 81 00 00 	movabs $0x812000,%rax
  80325e:	00 00 00 
  803261:	48 8b 00             	mov    (%rax),%rax
  803264:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803267:	c1 e2 09             	shl    $0x9,%edx
  80326a:	89 50 04             	mov    %edx,0x4(%rax)
	for(; nsecs > 0; nsecs-=2) {
  80326d:	e9 89 00 00 00       	jmpq   8032fb <host_write+0xe3>
		host_fsipcbuf.write.req_fileid = host_fd->fd_file.id;
  803272:	48 b8 00 20 81 00 00 	movabs $0x812000,%rax
  803279:	00 00 00 
  80327c:	48 8b 00             	mov    (%rax),%rax
  80327f:	8b 50 0c             	mov    0xc(%rax),%edx
  803282:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  803289:	00 00 00 
  80328c:	89 10                	mov    %edx,(%rax)
		host_fsipcbuf.write.req_n = SECTSIZE * 2;
  80328e:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  803295:	00 00 00 
  803298:	48 c7 40 08 00 04 00 	movq   $0x400,0x8(%rax)
  80329f:	00 
		memmove(host_fsipcbuf.write.req_buf, src+written, SECTSIZE * 2);
  8032a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032a3:	48 63 d0             	movslq %eax,%rdx
  8032a6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032aa:	48 01 d0             	add    %rdx,%rax
  8032ad:	ba 00 04 00 00       	mov    $0x400,%edx
  8032b2:	48 89 c6             	mov    %rax,%rsi
  8032b5:	48 bf 10 30 81 00 00 	movabs $0x813010,%rdi
  8032bc:	00 00 00 
  8032bf:	48 b8 37 46 80 00 00 	movabs $0x804637,%rax
  8032c6:	00 00 00 
  8032c9:	ff d0                	callq  *%rax
		if ((r = host_fsipc(FSREQ_WRITE, NULL)) < 0)
  8032cb:	be 00 00 00 00       	mov    $0x0,%esi
  8032d0:	bf 04 00 00 00       	mov    $0x4,%edi
  8032d5:	48 b8 c4 30 80 00 00 	movabs $0x8030c4,%rax
  8032dc:	00 00 00 
  8032df:	ff d0                	callq  *%rax
  8032e1:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8032e4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8032e8:	79 05                	jns    8032ef <host_write+0xd7>
			return r;
  8032ea:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8032ed:	eb 1c                	jmp    80330b <host_write+0xf3>
		written += SECTSIZE * 2;
  8032ef:	81 45 fc 00 04 00 00 	addl   $0x400,-0x4(%rbp)
	if(host_fd->fd_file.id == 0) {
		host_ipc_init();
	}

	host_fd->fd_offset = secno * SECTSIZE;
	for(; nsecs > 0; nsecs-=2) {
  8032f6:	48 83 6d d8 02       	subq   $0x2,-0x28(%rbp)
  8032fb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803300:	0f 85 6c ff ff ff    	jne    803272 <host_write+0x5a>
		memmove(host_fsipcbuf.write.req_buf, src+written, SECTSIZE * 2);
		if ((r = host_fsipc(FSREQ_WRITE, NULL)) < 0)
			return r;
		written += SECTSIZE * 2;
	}
	return 0;
  803306:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80330b:	c9                   	leaveq 
  80330c:	c3                   	retq   

000000000080330d <host_ipc_init>:

void
host_ipc_init()
{
  80330d:	55                   	push   %rbp
  80330e:	48 89 e5             	mov    %rsp,%rbp
  803311:	48 83 ec 40          	sub    $0x40,%rsp
	int r;
	int vmdisk_number;
	char path_string[50];
	if ((r = fd_alloc(&host_fd)) < 0)
  803315:	48 bf 00 20 81 00 00 	movabs $0x812000,%rdi
  80331c:	00 00 00 
  80331f:	48 b8 6a 53 80 00 00 	movabs $0x80536a,%rax
  803326:	00 00 00 
  803329:	ff d0                	callq  *%rax
  80332b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80332e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803332:	79 2a                	jns    80335e <host_ipc_init+0x51>
		panic("Couldn't allocate an fd!");
  803334:	48 ba a4 71 80 00 00 	movabs $0x8071a4,%rdx
  80333b:	00 00 00 
  80333e:	be 52 00 00 00       	mov    $0x52,%esi
  803343:	48 bf bd 71 80 00 00 	movabs $0x8071bd,%rdi
  80334a:	00 00 00 
  80334d:	b8 00 00 00 00       	mov    $0x0,%eax
  803352:	48 b9 e4 34 80 00 00 	movabs $0x8034e4,%rcx
  803359:	00 00 00 
  80335c:	ff d1                	callq  *%rcx
	asm("vmcall":"=a"(vmdisk_number): "0"(VMX_VMCALL_GETDISKIMGNUM));
  80335e:	b8 06 00 00 00       	mov    $0x6,%eax
  803363:	0f 01 c1             	vmcall 
  803366:	89 45 f8             	mov    %eax,-0x8(%rbp)
	snprintf(path_string, 50, "/vmm/fs%d.img", vmdisk_number);
  803369:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80336c:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  803370:	89 d1                	mov    %edx,%ecx
  803372:	48 ba cb 71 80 00 00 	movabs $0x8071cb,%rdx
  803379:	00 00 00 
  80337c:	be 32 00 00 00       	mov    $0x32,%esi
  803381:	48 89 c7             	mov    %rax,%rdi
  803384:	b8 00 00 00 00       	mov    $0x0,%eax
  803389:	49 b8 c6 41 80 00 00 	movabs $0x8041c6,%r8
  803390:	00 00 00 
  803393:	41 ff d0             	callq  *%r8
	strcpy(host_fsipcbuf.open.req_path, path_string);
  803396:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  80339a:	48 89 c6             	mov    %rax,%rsi
  80339d:	48 bf 00 30 81 00 00 	movabs $0x813000,%rdi
  8033a4:	00 00 00 
  8033a7:	48 b8 13 43 80 00 00 	movabs $0x804313,%rax
  8033ae:	00 00 00 
  8033b1:	ff d0                	callq  *%rax
	host_fsipcbuf.open.req_omode = O_RDWR;
  8033b3:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  8033ba:	00 00 00 
  8033bd:	c7 80 00 04 00 00 02 	movl   $0x2,0x400(%rax)
  8033c4:	00 00 00 

	if ((r = host_fsipc(FSREQ_OPEN, host_fd)) < 0) {
  8033c7:	48 b8 00 20 81 00 00 	movabs $0x812000,%rax
  8033ce:	00 00 00 
  8033d1:	48 8b 00             	mov    (%rax),%rax
  8033d4:	48 89 c6             	mov    %rax,%rsi
  8033d7:	bf 01 00 00 00       	mov    $0x1,%edi
  8033dc:	48 b8 c4 30 80 00 00 	movabs $0x8030c4,%rax
  8033e3:	00 00 00 
  8033e6:	ff d0                	callq  *%rax
  8033e8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033ef:	79 4b                	jns    80343c <host_ipc_init+0x12f>
		fd_close(host_fd, 0);
  8033f1:	48 b8 00 20 81 00 00 	movabs $0x812000,%rax
  8033f8:	00 00 00 
  8033fb:	48 8b 00             	mov    (%rax),%rax
  8033fe:	be 00 00 00 00       	mov    $0x0,%esi
  803403:	48 89 c7             	mov    %rax,%rdi
  803406:	48 b8 92 54 80 00 00 	movabs $0x805492,%rax
  80340d:	00 00 00 
  803410:	ff d0                	callq  *%rax
		panic("Couldn't open host file!");
  803412:	48 ba d9 71 80 00 00 	movabs $0x8071d9,%rdx
  803419:	00 00 00 
  80341c:	be 5a 00 00 00       	mov    $0x5a,%esi
  803421:	48 bf bd 71 80 00 00 	movabs $0x8071bd,%rdi
  803428:	00 00 00 
  80342b:	b8 00 00 00 00       	mov    $0x0,%eax
  803430:	48 b9 e4 34 80 00 00 	movabs $0x8034e4,%rcx
  803437:	00 00 00 
  80343a:	ff d1                	callq  *%rcx
	}

}
  80343c:	c9                   	leaveq 
  80343d:	c3                   	retq   

000000000080343e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80343e:	55                   	push   %rbp
  80343f:	48 89 e5             	mov    %rsp,%rbp
  803442:	48 83 ec 10          	sub    $0x10,%rsp
  803446:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803449:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = envs+ENVX(sys_getenvid ());
  80344d:	48 b8 c6 4b 80 00 00 	movabs $0x804bc6,%rax
  803454:	00 00 00 
  803457:	ff d0                	callq  *%rax
  803459:	48 98                	cltq   
  80345b:	25 ff 03 00 00       	and    $0x3ff,%eax
  803460:	48 69 d0 70 01 00 00 	imul   $0x170,%rax,%rdx
  803467:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80346e:	00 00 00 
  803471:	48 01 c2             	add    %rax,%rdx
  803474:	48 b8 20 40 81 00 00 	movabs $0x814020,%rax
  80347b:	00 00 00 
  80347e:	48 89 10             	mov    %rdx,(%rax)
	// thisenv = 0;


	// save the name of the program so that panic() can use it
	if (argc > 0)
  803481:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803485:	7e 14                	jle    80349b <libmain+0x5d>
		binaryname = argv[0];
  803487:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80348b:	48 8b 10             	mov    (%rax),%rdx
  80348e:	48 b8 90 10 81 00 00 	movabs $0x811090,%rax
  803495:	00 00 00 
  803498:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80349b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80349f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034a2:	48 89 d6             	mov    %rdx,%rsi
  8034a5:	89 c7                	mov    %eax,%edi
  8034a7:	48 b8 3b 28 80 00 00 	movabs $0x80283b,%rax
  8034ae:	00 00 00 
  8034b1:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8034b3:	48 b8 c1 34 80 00 00 	movabs $0x8034c1,%rax
  8034ba:	00 00 00 
  8034bd:	ff d0                	callq  *%rax
}
  8034bf:	c9                   	leaveq 
  8034c0:	c3                   	retq   

00000000008034c1 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8034c1:	55                   	push   %rbp
  8034c2:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  8034c5:	48 b8 5d 56 80 00 00 	movabs $0x80565d,%rax
  8034cc:	00 00 00 
  8034cf:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  8034d1:	bf 00 00 00 00       	mov    $0x0,%edi
  8034d6:	48 b8 82 4b 80 00 00 	movabs $0x804b82,%rax
  8034dd:	00 00 00 
  8034e0:	ff d0                	callq  *%rax
}
  8034e2:	5d                   	pop    %rbp
  8034e3:	c3                   	retq   

00000000008034e4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8034e4:	55                   	push   %rbp
  8034e5:	48 89 e5             	mov    %rsp,%rbp
  8034e8:	53                   	push   %rbx
  8034e9:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8034f0:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8034f7:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8034fd:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803504:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80350b:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803512:	84 c0                	test   %al,%al
  803514:	74 23                	je     803539 <_panic+0x55>
  803516:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80351d:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803521:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803525:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803529:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80352d:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803531:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803535:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  803539:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803540:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803547:	00 00 00 
  80354a:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803551:	00 00 00 
  803554:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803558:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80355f:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803566:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80356d:	48 b8 90 10 81 00 00 	movabs $0x811090,%rax
  803574:	00 00 00 
  803577:	48 8b 18             	mov    (%rax),%rbx
  80357a:	48 b8 c6 4b 80 00 00 	movabs $0x804bc6,%rax
  803581:	00 00 00 
  803584:	ff d0                	callq  *%rax
  803586:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80358c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803593:	41 89 c8             	mov    %ecx,%r8d
  803596:	48 89 d1             	mov    %rdx,%rcx
  803599:	48 89 da             	mov    %rbx,%rdx
  80359c:	89 c6                	mov    %eax,%esi
  80359e:	48 bf 00 72 80 00 00 	movabs $0x807200,%rdi
  8035a5:	00 00 00 
  8035a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8035ad:	49 b9 1d 37 80 00 00 	movabs $0x80371d,%r9
  8035b4:	00 00 00 
  8035b7:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8035ba:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8035c1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8035c8:	48 89 d6             	mov    %rdx,%rsi
  8035cb:	48 89 c7             	mov    %rax,%rdi
  8035ce:	48 b8 71 36 80 00 00 	movabs $0x803671,%rax
  8035d5:	00 00 00 
  8035d8:	ff d0                	callq  *%rax
	cprintf("\n");
  8035da:	48 bf 23 72 80 00 00 	movabs $0x807223,%rdi
  8035e1:	00 00 00 
  8035e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8035e9:	48 ba 1d 37 80 00 00 	movabs $0x80371d,%rdx
  8035f0:	00 00 00 
  8035f3:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8035f5:	cc                   	int3   
  8035f6:	eb fd                	jmp    8035f5 <_panic+0x111>

00000000008035f8 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8035f8:	55                   	push   %rbp
  8035f9:	48 89 e5             	mov    %rsp,%rbp
  8035fc:	48 83 ec 10          	sub    $0x10,%rsp
  803600:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803603:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  803607:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80360b:	8b 00                	mov    (%rax),%eax
  80360d:	8d 48 01             	lea    0x1(%rax),%ecx
  803610:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803614:	89 0a                	mov    %ecx,(%rdx)
  803616:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803619:	89 d1                	mov    %edx,%ecx
  80361b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80361f:	48 98                	cltq   
  803621:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  803625:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803629:	8b 00                	mov    (%rax),%eax
  80362b:	3d ff 00 00 00       	cmp    $0xff,%eax
  803630:	75 2c                	jne    80365e <putch+0x66>
        sys_cputs(b->buf, b->idx);
  803632:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803636:	8b 00                	mov    (%rax),%eax
  803638:	48 98                	cltq   
  80363a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80363e:	48 83 c2 08          	add    $0x8,%rdx
  803642:	48 89 c6             	mov    %rax,%rsi
  803645:	48 89 d7             	mov    %rdx,%rdi
  803648:	48 b8 fa 4a 80 00 00 	movabs $0x804afa,%rax
  80364f:	00 00 00 
  803652:	ff d0                	callq  *%rax
        b->idx = 0;
  803654:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803658:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80365e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803662:	8b 40 04             	mov    0x4(%rax),%eax
  803665:	8d 50 01             	lea    0x1(%rax),%edx
  803668:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80366c:	89 50 04             	mov    %edx,0x4(%rax)
}
  80366f:	c9                   	leaveq 
  803670:	c3                   	retq   

0000000000803671 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  803671:	55                   	push   %rbp
  803672:	48 89 e5             	mov    %rsp,%rbp
  803675:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80367c:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  803683:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80368a:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  803691:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  803698:	48 8b 0a             	mov    (%rdx),%rcx
  80369b:	48 89 08             	mov    %rcx,(%rax)
  80369e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8036a2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8036a6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8036aa:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8036ae:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8036b5:	00 00 00 
    b.cnt = 0;
  8036b8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8036bf:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8036c2:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8036c9:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8036d0:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8036d7:	48 89 c6             	mov    %rax,%rsi
  8036da:	48 bf f8 35 80 00 00 	movabs $0x8035f8,%rdi
  8036e1:	00 00 00 
  8036e4:	48 b8 d0 3a 80 00 00 	movabs $0x803ad0,%rax
  8036eb:	00 00 00 
  8036ee:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8036f0:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8036f6:	48 98                	cltq   
  8036f8:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8036ff:	48 83 c2 08          	add    $0x8,%rdx
  803703:	48 89 c6             	mov    %rax,%rsi
  803706:	48 89 d7             	mov    %rdx,%rdi
  803709:	48 b8 fa 4a 80 00 00 	movabs $0x804afa,%rax
  803710:	00 00 00 
  803713:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  803715:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80371b:	c9                   	leaveq 
  80371c:	c3                   	retq   

000000000080371d <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80371d:	55                   	push   %rbp
  80371e:	48 89 e5             	mov    %rsp,%rbp
  803721:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  803728:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80372f:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  803736:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80373d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803744:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80374b:	84 c0                	test   %al,%al
  80374d:	74 20                	je     80376f <cprintf+0x52>
  80374f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803753:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803757:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80375b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80375f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803763:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803767:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80376b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80376f:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  803776:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80377d:	00 00 00 
  803780:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803787:	00 00 00 
  80378a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80378e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803795:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80379c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8037a3:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8037aa:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8037b1:	48 8b 0a             	mov    (%rdx),%rcx
  8037b4:	48 89 08             	mov    %rcx,(%rax)
  8037b7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8037bb:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8037bf:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8037c3:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8037c7:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8037ce:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8037d5:	48 89 d6             	mov    %rdx,%rsi
  8037d8:	48 89 c7             	mov    %rax,%rdi
  8037db:	48 b8 71 36 80 00 00 	movabs $0x803671,%rax
  8037e2:	00 00 00 
  8037e5:	ff d0                	callq  *%rax
  8037e7:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8037ed:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8037f3:	c9                   	leaveq 
  8037f4:	c3                   	retq   

00000000008037f5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8037f5:	55                   	push   %rbp
  8037f6:	48 89 e5             	mov    %rsp,%rbp
  8037f9:	53                   	push   %rbx
  8037fa:	48 83 ec 38          	sub    $0x38,%rsp
  8037fe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803802:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803806:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80380a:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80380d:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  803811:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  803815:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  803818:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80381c:	77 3b                	ja     803859 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80381e:	8b 45 d0             	mov    -0x30(%rbp),%eax
  803821:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  803825:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  803828:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80382c:	ba 00 00 00 00       	mov    $0x0,%edx
  803831:	48 f7 f3             	div    %rbx
  803834:	48 89 c2             	mov    %rax,%rdx
  803837:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80383a:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80383d:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  803841:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803845:	41 89 f9             	mov    %edi,%r9d
  803848:	48 89 c7             	mov    %rax,%rdi
  80384b:	48 b8 f5 37 80 00 00 	movabs $0x8037f5,%rax
  803852:	00 00 00 
  803855:	ff d0                	callq  *%rax
  803857:	eb 1e                	jmp    803877 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  803859:	eb 12                	jmp    80386d <printnum+0x78>
			putch(padc, putdat);
  80385b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80385f:	8b 55 cc             	mov    -0x34(%rbp),%edx
  803862:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803866:	48 89 ce             	mov    %rcx,%rsi
  803869:	89 d7                	mov    %edx,%edi
  80386b:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80386d:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  803871:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  803875:	7f e4                	jg     80385b <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  803877:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80387a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80387e:	ba 00 00 00 00       	mov    $0x0,%edx
  803883:	48 f7 f1             	div    %rcx
  803886:	48 89 d0             	mov    %rdx,%rax
  803889:	48 ba 30 74 80 00 00 	movabs $0x807430,%rdx
  803890:	00 00 00 
  803893:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  803897:	0f be d0             	movsbl %al,%edx
  80389a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80389e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038a2:	48 89 ce             	mov    %rcx,%rsi
  8038a5:	89 d7                	mov    %edx,%edi
  8038a7:	ff d0                	callq  *%rax
}
  8038a9:	48 83 c4 38          	add    $0x38,%rsp
  8038ad:	5b                   	pop    %rbx
  8038ae:	5d                   	pop    %rbp
  8038af:	c3                   	retq   

00000000008038b0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8038b0:	55                   	push   %rbp
  8038b1:	48 89 e5             	mov    %rsp,%rbp
  8038b4:	48 83 ec 1c          	sub    $0x1c,%rsp
  8038b8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8038bc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8038bf:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8038c3:	7e 52                	jle    803917 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8038c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038c9:	8b 00                	mov    (%rax),%eax
  8038cb:	83 f8 30             	cmp    $0x30,%eax
  8038ce:	73 24                	jae    8038f4 <getuint+0x44>
  8038d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038d4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8038d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038dc:	8b 00                	mov    (%rax),%eax
  8038de:	89 c0                	mov    %eax,%eax
  8038e0:	48 01 d0             	add    %rdx,%rax
  8038e3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8038e7:	8b 12                	mov    (%rdx),%edx
  8038e9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8038ec:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8038f0:	89 0a                	mov    %ecx,(%rdx)
  8038f2:	eb 17                	jmp    80390b <getuint+0x5b>
  8038f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038f8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8038fc:	48 89 d0             	mov    %rdx,%rax
  8038ff:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  803903:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803907:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80390b:	48 8b 00             	mov    (%rax),%rax
  80390e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803912:	e9 a3 00 00 00       	jmpq   8039ba <getuint+0x10a>
	else if (lflag)
  803917:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80391b:	74 4f                	je     80396c <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80391d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803921:	8b 00                	mov    (%rax),%eax
  803923:	83 f8 30             	cmp    $0x30,%eax
  803926:	73 24                	jae    80394c <getuint+0x9c>
  803928:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80392c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803930:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803934:	8b 00                	mov    (%rax),%eax
  803936:	89 c0                	mov    %eax,%eax
  803938:	48 01 d0             	add    %rdx,%rax
  80393b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80393f:	8b 12                	mov    (%rdx),%edx
  803941:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803944:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803948:	89 0a                	mov    %ecx,(%rdx)
  80394a:	eb 17                	jmp    803963 <getuint+0xb3>
  80394c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803950:	48 8b 50 08          	mov    0x8(%rax),%rdx
  803954:	48 89 d0             	mov    %rdx,%rax
  803957:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80395b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80395f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  803963:	48 8b 00             	mov    (%rax),%rax
  803966:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80396a:	eb 4e                	jmp    8039ba <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  80396c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803970:	8b 00                	mov    (%rax),%eax
  803972:	83 f8 30             	cmp    $0x30,%eax
  803975:	73 24                	jae    80399b <getuint+0xeb>
  803977:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80397b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80397f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803983:	8b 00                	mov    (%rax),%eax
  803985:	89 c0                	mov    %eax,%eax
  803987:	48 01 d0             	add    %rdx,%rax
  80398a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80398e:	8b 12                	mov    (%rdx),%edx
  803990:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803993:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803997:	89 0a                	mov    %ecx,(%rdx)
  803999:	eb 17                	jmp    8039b2 <getuint+0x102>
  80399b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80399f:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8039a3:	48 89 d0             	mov    %rdx,%rax
  8039a6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8039aa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8039ae:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8039b2:	8b 00                	mov    (%rax),%eax
  8039b4:	89 c0                	mov    %eax,%eax
  8039b6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8039ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8039be:	c9                   	leaveq 
  8039bf:	c3                   	retq   

00000000008039c0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8039c0:	55                   	push   %rbp
  8039c1:	48 89 e5             	mov    %rsp,%rbp
  8039c4:	48 83 ec 1c          	sub    $0x1c,%rsp
  8039c8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8039cc:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8039cf:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8039d3:	7e 52                	jle    803a27 <getint+0x67>
		x=va_arg(*ap, long long);
  8039d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039d9:	8b 00                	mov    (%rax),%eax
  8039db:	83 f8 30             	cmp    $0x30,%eax
  8039de:	73 24                	jae    803a04 <getint+0x44>
  8039e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039e4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8039e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039ec:	8b 00                	mov    (%rax),%eax
  8039ee:	89 c0                	mov    %eax,%eax
  8039f0:	48 01 d0             	add    %rdx,%rax
  8039f3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8039f7:	8b 12                	mov    (%rdx),%edx
  8039f9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8039fc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803a00:	89 0a                	mov    %ecx,(%rdx)
  803a02:	eb 17                	jmp    803a1b <getint+0x5b>
  803a04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a08:	48 8b 50 08          	mov    0x8(%rax),%rdx
  803a0c:	48 89 d0             	mov    %rdx,%rax
  803a0f:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  803a13:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803a17:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  803a1b:	48 8b 00             	mov    (%rax),%rax
  803a1e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803a22:	e9 a3 00 00 00       	jmpq   803aca <getint+0x10a>
	else if (lflag)
  803a27:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  803a2b:	74 4f                	je     803a7c <getint+0xbc>
		x=va_arg(*ap, long);
  803a2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a31:	8b 00                	mov    (%rax),%eax
  803a33:	83 f8 30             	cmp    $0x30,%eax
  803a36:	73 24                	jae    803a5c <getint+0x9c>
  803a38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a3c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803a40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a44:	8b 00                	mov    (%rax),%eax
  803a46:	89 c0                	mov    %eax,%eax
  803a48:	48 01 d0             	add    %rdx,%rax
  803a4b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803a4f:	8b 12                	mov    (%rdx),%edx
  803a51:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803a54:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803a58:	89 0a                	mov    %ecx,(%rdx)
  803a5a:	eb 17                	jmp    803a73 <getint+0xb3>
  803a5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a60:	48 8b 50 08          	mov    0x8(%rax),%rdx
  803a64:	48 89 d0             	mov    %rdx,%rax
  803a67:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  803a6b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803a6f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  803a73:	48 8b 00             	mov    (%rax),%rax
  803a76:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803a7a:	eb 4e                	jmp    803aca <getint+0x10a>
	else
		x=va_arg(*ap, int);
  803a7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a80:	8b 00                	mov    (%rax),%eax
  803a82:	83 f8 30             	cmp    $0x30,%eax
  803a85:	73 24                	jae    803aab <getint+0xeb>
  803a87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a8b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803a8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a93:	8b 00                	mov    (%rax),%eax
  803a95:	89 c0                	mov    %eax,%eax
  803a97:	48 01 d0             	add    %rdx,%rax
  803a9a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803a9e:	8b 12                	mov    (%rdx),%edx
  803aa0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803aa3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803aa7:	89 0a                	mov    %ecx,(%rdx)
  803aa9:	eb 17                	jmp    803ac2 <getint+0x102>
  803aab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803aaf:	48 8b 50 08          	mov    0x8(%rax),%rdx
  803ab3:	48 89 d0             	mov    %rdx,%rax
  803ab6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  803aba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803abe:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  803ac2:	8b 00                	mov    (%rax),%eax
  803ac4:	48 98                	cltq   
  803ac6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  803aca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803ace:	c9                   	leaveq 
  803acf:	c3                   	retq   

0000000000803ad0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  803ad0:	55                   	push   %rbp
  803ad1:	48 89 e5             	mov    %rsp,%rbp
  803ad4:	41 54                	push   %r12
  803ad6:	53                   	push   %rbx
  803ad7:	48 83 ec 60          	sub    $0x60,%rsp
  803adb:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  803adf:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  803ae3:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  803ae7:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  803aeb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803aef:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  803af3:	48 8b 0a             	mov    (%rdx),%rcx
  803af6:	48 89 08             	mov    %rcx,(%rax)
  803af9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803afd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803b01:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803b05:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  803b09:	eb 28                	jmp    803b33 <vprintfmt+0x63>
			if (ch == '\0'){
  803b0b:	85 db                	test   %ebx,%ebx
  803b0d:	75 15                	jne    803b24 <vprintfmt+0x54>
				current_color=WHITE;
  803b0f:	48 b8 28 40 81 00 00 	movabs $0x814028,%rax
  803b16:	00 00 00 
  803b19:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  803b1f:	e9 fc 04 00 00       	jmpq   804020 <vprintfmt+0x550>
				return;
			}
				
			putch(ch, putdat);
  803b24:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803b28:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803b2c:	48 89 d6             	mov    %rdx,%rsi
  803b2f:	89 df                	mov    %ebx,%edi
  803b31:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  803b33:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803b37:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803b3b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  803b3f:	0f b6 00             	movzbl (%rax),%eax
  803b42:	0f b6 d8             	movzbl %al,%ebx
  803b45:	83 fb 25             	cmp    $0x25,%ebx
  803b48:	75 c1                	jne    803b0b <vprintfmt+0x3b>
				
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  803b4a:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  803b4e:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  803b55:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  803b5c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  803b63:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  803b6a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803b6e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803b72:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  803b76:	0f b6 00             	movzbl (%rax),%eax
  803b79:	0f b6 d8             	movzbl %al,%ebx
  803b7c:	8d 43 dd             	lea    -0x23(%rbx),%eax
  803b7f:	83 f8 55             	cmp    $0x55,%eax
  803b82:	0f 87 64 04 00 00    	ja     803fec <vprintfmt+0x51c>
  803b88:	89 c0                	mov    %eax,%eax
  803b8a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803b91:	00 
  803b92:	48 b8 58 74 80 00 00 	movabs $0x807458,%rax
  803b99:	00 00 00 
  803b9c:	48 01 d0             	add    %rdx,%rax
  803b9f:	48 8b 00             	mov    (%rax),%rax
  803ba2:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  803ba4:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  803ba8:	eb c0                	jmp    803b6a <vprintfmt+0x9a>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  803baa:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  803bae:	eb ba                	jmp    803b6a <vprintfmt+0x9a>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  803bb0:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  803bb7:	8b 55 d8             	mov    -0x28(%rbp),%edx
  803bba:	89 d0                	mov    %edx,%eax
  803bbc:	c1 e0 02             	shl    $0x2,%eax
  803bbf:	01 d0                	add    %edx,%eax
  803bc1:	01 c0                	add    %eax,%eax
  803bc3:	01 d8                	add    %ebx,%eax
  803bc5:	83 e8 30             	sub    $0x30,%eax
  803bc8:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  803bcb:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803bcf:	0f b6 00             	movzbl (%rax),%eax
  803bd2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  803bd5:	83 fb 2f             	cmp    $0x2f,%ebx
  803bd8:	7e 0c                	jle    803be6 <vprintfmt+0x116>
  803bda:	83 fb 39             	cmp    $0x39,%ebx
  803bdd:	7f 07                	jg     803be6 <vprintfmt+0x116>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  803bdf:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  803be4:	eb d1                	jmp    803bb7 <vprintfmt+0xe7>
			goto process_precision;
  803be6:	eb 58                	jmp    803c40 <vprintfmt+0x170>

		case '*':
			precision = va_arg(aq, int);
  803be8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803beb:	83 f8 30             	cmp    $0x30,%eax
  803bee:	73 17                	jae    803c07 <vprintfmt+0x137>
  803bf0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803bf4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803bf7:	89 c0                	mov    %eax,%eax
  803bf9:	48 01 d0             	add    %rdx,%rax
  803bfc:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803bff:	83 c2 08             	add    $0x8,%edx
  803c02:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803c05:	eb 0f                	jmp    803c16 <vprintfmt+0x146>
  803c07:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803c0b:	48 89 d0             	mov    %rdx,%rax
  803c0e:	48 83 c2 08          	add    $0x8,%rdx
  803c12:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803c16:	8b 00                	mov    (%rax),%eax
  803c18:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  803c1b:	eb 23                	jmp    803c40 <vprintfmt+0x170>

		case '.':
			if (width < 0)
  803c1d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803c21:	79 0c                	jns    803c2f <vprintfmt+0x15f>
				width = 0;
  803c23:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  803c2a:	e9 3b ff ff ff       	jmpq   803b6a <vprintfmt+0x9a>
  803c2f:	e9 36 ff ff ff       	jmpq   803b6a <vprintfmt+0x9a>

		case '#':
			altflag = 1;
  803c34:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  803c3b:	e9 2a ff ff ff       	jmpq   803b6a <vprintfmt+0x9a>

		process_precision:
			if (width < 0)
  803c40:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803c44:	79 12                	jns    803c58 <vprintfmt+0x188>
				width = precision, precision = -1;
  803c46:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803c49:	89 45 dc             	mov    %eax,-0x24(%rbp)
  803c4c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  803c53:	e9 12 ff ff ff       	jmpq   803b6a <vprintfmt+0x9a>
  803c58:	e9 0d ff ff ff       	jmpq   803b6a <vprintfmt+0x9a>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  803c5d:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  803c61:	e9 04 ff ff ff       	jmpq   803b6a <vprintfmt+0x9a>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  803c66:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803c69:	83 f8 30             	cmp    $0x30,%eax
  803c6c:	73 17                	jae    803c85 <vprintfmt+0x1b5>
  803c6e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803c72:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803c75:	89 c0                	mov    %eax,%eax
  803c77:	48 01 d0             	add    %rdx,%rax
  803c7a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803c7d:	83 c2 08             	add    $0x8,%edx
  803c80:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803c83:	eb 0f                	jmp    803c94 <vprintfmt+0x1c4>
  803c85:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803c89:	48 89 d0             	mov    %rdx,%rax
  803c8c:	48 83 c2 08          	add    $0x8,%rdx
  803c90:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803c94:	8b 10                	mov    (%rax),%edx
  803c96:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  803c9a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803c9e:	48 89 ce             	mov    %rcx,%rsi
  803ca1:	89 d7                	mov    %edx,%edi
  803ca3:	ff d0                	callq  *%rax
			break;
  803ca5:	e9 70 03 00 00       	jmpq   80401a <vprintfmt+0x54a>

			// error message
		case 'e':
			err = va_arg(aq, int);
  803caa:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803cad:	83 f8 30             	cmp    $0x30,%eax
  803cb0:	73 17                	jae    803cc9 <vprintfmt+0x1f9>
  803cb2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803cb6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803cb9:	89 c0                	mov    %eax,%eax
  803cbb:	48 01 d0             	add    %rdx,%rax
  803cbe:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803cc1:	83 c2 08             	add    $0x8,%edx
  803cc4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803cc7:	eb 0f                	jmp    803cd8 <vprintfmt+0x208>
  803cc9:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803ccd:	48 89 d0             	mov    %rdx,%rax
  803cd0:	48 83 c2 08          	add    $0x8,%rdx
  803cd4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803cd8:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  803cda:	85 db                	test   %ebx,%ebx
  803cdc:	79 02                	jns    803ce0 <vprintfmt+0x210>
				err = -err;
  803cde:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  803ce0:	83 fb 15             	cmp    $0x15,%ebx
  803ce3:	7f 16                	jg     803cfb <vprintfmt+0x22b>
  803ce5:	48 b8 80 73 80 00 00 	movabs $0x807380,%rax
  803cec:	00 00 00 
  803cef:	48 63 d3             	movslq %ebx,%rdx
  803cf2:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  803cf6:	4d 85 e4             	test   %r12,%r12
  803cf9:	75 2e                	jne    803d29 <vprintfmt+0x259>
				printfmt(putch, putdat, "error %d", err);
  803cfb:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  803cff:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803d03:	89 d9                	mov    %ebx,%ecx
  803d05:	48 ba 41 74 80 00 00 	movabs $0x807441,%rdx
  803d0c:	00 00 00 
  803d0f:	48 89 c7             	mov    %rax,%rdi
  803d12:	b8 00 00 00 00       	mov    $0x0,%eax
  803d17:	49 b8 29 40 80 00 00 	movabs $0x804029,%r8
  803d1e:	00 00 00 
  803d21:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  803d24:	e9 f1 02 00 00       	jmpq   80401a <vprintfmt+0x54a>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  803d29:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  803d2d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803d31:	4c 89 e1             	mov    %r12,%rcx
  803d34:	48 ba 4a 74 80 00 00 	movabs $0x80744a,%rdx
  803d3b:	00 00 00 
  803d3e:	48 89 c7             	mov    %rax,%rdi
  803d41:	b8 00 00 00 00       	mov    $0x0,%eax
  803d46:	49 b8 29 40 80 00 00 	movabs $0x804029,%r8
  803d4d:	00 00 00 
  803d50:	41 ff d0             	callq  *%r8
			break;
  803d53:	e9 c2 02 00 00       	jmpq   80401a <vprintfmt+0x54a>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  803d58:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803d5b:	83 f8 30             	cmp    $0x30,%eax
  803d5e:	73 17                	jae    803d77 <vprintfmt+0x2a7>
  803d60:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803d64:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803d67:	89 c0                	mov    %eax,%eax
  803d69:	48 01 d0             	add    %rdx,%rax
  803d6c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803d6f:	83 c2 08             	add    $0x8,%edx
  803d72:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803d75:	eb 0f                	jmp    803d86 <vprintfmt+0x2b6>
  803d77:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803d7b:	48 89 d0             	mov    %rdx,%rax
  803d7e:	48 83 c2 08          	add    $0x8,%rdx
  803d82:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803d86:	4c 8b 20             	mov    (%rax),%r12
  803d89:	4d 85 e4             	test   %r12,%r12
  803d8c:	75 0a                	jne    803d98 <vprintfmt+0x2c8>
				p = "(null)";
  803d8e:	49 bc 4d 74 80 00 00 	movabs $0x80744d,%r12
  803d95:	00 00 00 
			if (width > 0 && padc != '-')
  803d98:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803d9c:	7e 3f                	jle    803ddd <vprintfmt+0x30d>
  803d9e:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  803da2:	74 39                	je     803ddd <vprintfmt+0x30d>
				for (width -= strnlen(p, precision); width > 0; width--)
  803da4:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803da7:	48 98                	cltq   
  803da9:	48 89 c6             	mov    %rax,%rsi
  803dac:	4c 89 e7             	mov    %r12,%rdi
  803daf:	48 b8 d5 42 80 00 00 	movabs $0x8042d5,%rax
  803db6:	00 00 00 
  803db9:	ff d0                	callq  *%rax
  803dbb:	29 45 dc             	sub    %eax,-0x24(%rbp)
  803dbe:	eb 17                	jmp    803dd7 <vprintfmt+0x307>
					putch(padc, putdat);
  803dc0:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  803dc4:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  803dc8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803dcc:	48 89 ce             	mov    %rcx,%rsi
  803dcf:	89 d7                	mov    %edx,%edi
  803dd1:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  803dd3:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803dd7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803ddb:	7f e3                	jg     803dc0 <vprintfmt+0x2f0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  803ddd:	eb 37                	jmp    803e16 <vprintfmt+0x346>
				if (altflag && (ch < ' ' || ch > '~'))
  803ddf:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  803de3:	74 1e                	je     803e03 <vprintfmt+0x333>
  803de5:	83 fb 1f             	cmp    $0x1f,%ebx
  803de8:	7e 05                	jle    803def <vprintfmt+0x31f>
  803dea:	83 fb 7e             	cmp    $0x7e,%ebx
  803ded:	7e 14                	jle    803e03 <vprintfmt+0x333>
					putch('?', putdat);
  803def:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803df3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803df7:	48 89 d6             	mov    %rdx,%rsi
  803dfa:	bf 3f 00 00 00       	mov    $0x3f,%edi
  803dff:	ff d0                	callq  *%rax
  803e01:	eb 0f                	jmp    803e12 <vprintfmt+0x342>
				else
					putch(ch, putdat);
  803e03:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803e07:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803e0b:	48 89 d6             	mov    %rdx,%rsi
  803e0e:	89 df                	mov    %ebx,%edi
  803e10:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  803e12:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803e16:	4c 89 e0             	mov    %r12,%rax
  803e19:	4c 8d 60 01          	lea    0x1(%rax),%r12
  803e1d:	0f b6 00             	movzbl (%rax),%eax
  803e20:	0f be d8             	movsbl %al,%ebx
  803e23:	85 db                	test   %ebx,%ebx
  803e25:	74 10                	je     803e37 <vprintfmt+0x367>
  803e27:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803e2b:	78 b2                	js     803ddf <vprintfmt+0x30f>
  803e2d:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  803e31:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803e35:	79 a8                	jns    803ddf <vprintfmt+0x30f>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  803e37:	eb 16                	jmp    803e4f <vprintfmt+0x37f>
				putch(' ', putdat);
  803e39:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803e3d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803e41:	48 89 d6             	mov    %rdx,%rsi
  803e44:	bf 20 00 00 00       	mov    $0x20,%edi
  803e49:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  803e4b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803e4f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803e53:	7f e4                	jg     803e39 <vprintfmt+0x369>
				putch(' ', putdat);
			break;
  803e55:	e9 c0 01 00 00       	jmpq   80401a <vprintfmt+0x54a>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  803e5a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803e5e:	be 03 00 00 00       	mov    $0x3,%esi
  803e63:	48 89 c7             	mov    %rax,%rdi
  803e66:	48 b8 c0 39 80 00 00 	movabs $0x8039c0,%rax
  803e6d:	00 00 00 
  803e70:	ff d0                	callq  *%rax
  803e72:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  803e76:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e7a:	48 85 c0             	test   %rax,%rax
  803e7d:	79 1d                	jns    803e9c <vprintfmt+0x3cc>
				putch('-', putdat);
  803e7f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803e83:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803e87:	48 89 d6             	mov    %rdx,%rsi
  803e8a:	bf 2d 00 00 00       	mov    $0x2d,%edi
  803e8f:	ff d0                	callq  *%rax
				num = -(long long) num;
  803e91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e95:	48 f7 d8             	neg    %rax
  803e98:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  803e9c:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  803ea3:	e9 d5 00 00 00       	jmpq   803f7d <vprintfmt+0x4ad>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  803ea8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803eac:	be 03 00 00 00       	mov    $0x3,%esi
  803eb1:	48 89 c7             	mov    %rax,%rdi
  803eb4:	48 b8 b0 38 80 00 00 	movabs $0x8038b0,%rax
  803ebb:	00 00 00 
  803ebe:	ff d0                	callq  *%rax
  803ec0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  803ec4:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  803ecb:	e9 ad 00 00 00       	jmpq   803f7d <vprintfmt+0x4ad>
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			// break;
			num = getuint(&aq, 3);
  803ed0:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803ed4:	be 03 00 00 00       	mov    $0x3,%esi
  803ed9:	48 89 c7             	mov    %rax,%rdi
  803edc:	48 b8 b0 38 80 00 00 	movabs $0x8038b0,%rax
  803ee3:	00 00 00 
  803ee6:	ff d0                	callq  *%rax
  803ee8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  803eec:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  803ef3:	e9 85 00 00 00       	jmpq   803f7d <vprintfmt+0x4ad>

			// pointer
		case 'p':
			putch('0', putdat);
  803ef8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803efc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803f00:	48 89 d6             	mov    %rdx,%rsi
  803f03:	bf 30 00 00 00       	mov    $0x30,%edi
  803f08:	ff d0                	callq  *%rax
			putch('x', putdat);
  803f0a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803f0e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803f12:	48 89 d6             	mov    %rdx,%rsi
  803f15:	bf 78 00 00 00       	mov    $0x78,%edi
  803f1a:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  803f1c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803f1f:	83 f8 30             	cmp    $0x30,%eax
  803f22:	73 17                	jae    803f3b <vprintfmt+0x46b>
  803f24:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803f28:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803f2b:	89 c0                	mov    %eax,%eax
  803f2d:	48 01 d0             	add    %rdx,%rax
  803f30:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803f33:	83 c2 08             	add    $0x8,%edx
  803f36:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  803f39:	eb 0f                	jmp    803f4a <vprintfmt+0x47a>
				(uintptr_t) va_arg(aq, void *);
  803f3b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  803f3f:	48 89 d0             	mov    %rdx,%rax
  803f42:	48 83 c2 08          	add    $0x8,%rdx
  803f46:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803f4a:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  803f4d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  803f51:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  803f58:	eb 23                	jmp    803f7d <vprintfmt+0x4ad>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  803f5a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803f5e:	be 03 00 00 00       	mov    $0x3,%esi
  803f63:	48 89 c7             	mov    %rax,%rdi
  803f66:	48 b8 b0 38 80 00 00 	movabs $0x8038b0,%rax
  803f6d:	00 00 00 
  803f70:	ff d0                	callq  *%rax
  803f72:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  803f76:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  803f7d:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  803f82:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  803f85:	8b 7d dc             	mov    -0x24(%rbp),%edi
  803f88:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803f8c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  803f90:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803f94:	45 89 c1             	mov    %r8d,%r9d
  803f97:	41 89 f8             	mov    %edi,%r8d
  803f9a:	48 89 c7             	mov    %rax,%rdi
  803f9d:	48 b8 f5 37 80 00 00 	movabs $0x8037f5,%rax
  803fa4:	00 00 00 
  803fa7:	ff d0                	callq  *%rax
			break;
  803fa9:	eb 6f                	jmp    80401a <vprintfmt+0x54a>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  803fab:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803faf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803fb3:	48 89 d6             	mov    %rdx,%rsi
  803fb6:	89 df                	mov    %ebx,%edi
  803fb8:	ff d0                	callq  *%rax
			break;
  803fba:	eb 5e                	jmp    80401a <vprintfmt+0x54a>
		
		case 'C':
		    num=getuint(&aq,3);		
  803fbc:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803fc0:	be 03 00 00 00       	mov    $0x3,%esi
  803fc5:	48 89 c7             	mov    %rax,%rdi
  803fc8:	48 b8 b0 38 80 00 00 	movabs $0x8038b0,%rax
  803fcf:	00 00 00 
  803fd2:	ff d0                	callq  *%rax
  803fd4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			current_color=num;
  803fd8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fdc:	89 c2                	mov    %eax,%edx
  803fde:	48 b8 28 40 81 00 00 	movabs $0x814028,%rax
  803fe5:	00 00 00 
  803fe8:	89 10                	mov    %edx,(%rax)
			break;
  803fea:	eb 2e                	jmp    80401a <vprintfmt+0x54a>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  803fec:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803ff0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803ff4:	48 89 d6             	mov    %rdx,%rsi
  803ff7:	bf 25 00 00 00       	mov    $0x25,%edi
  803ffc:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  803ffe:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  804003:	eb 05                	jmp    80400a <vprintfmt+0x53a>
  804005:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80400a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80400e:	48 83 e8 01          	sub    $0x1,%rax
  804012:	0f b6 00             	movzbl (%rax),%eax
  804015:	3c 25                	cmp    $0x25,%al
  804017:	75 ec                	jne    804005 <vprintfmt+0x535>
				/* do nothing */;
			break;
  804019:	90                   	nop
		}
	}
  80401a:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80401b:	e9 13 fb ff ff       	jmpq   803b33 <vprintfmt+0x63>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  804020:	48 83 c4 60          	add    $0x60,%rsp
  804024:	5b                   	pop    %rbx
  804025:	41 5c                	pop    %r12
  804027:	5d                   	pop    %rbp
  804028:	c3                   	retq   

0000000000804029 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  804029:	55                   	push   %rbp
  80402a:	48 89 e5             	mov    %rsp,%rbp
  80402d:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  804034:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80403b:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  804042:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  804049:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  804050:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  804057:	84 c0                	test   %al,%al
  804059:	74 20                	je     80407b <printfmt+0x52>
  80405b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80405f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  804063:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  804067:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80406b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80406f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  804073:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  804077:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80407b:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  804082:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  804089:	00 00 00 
  80408c:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  804093:	00 00 00 
  804096:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80409a:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8040a1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8040a8:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8040af:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8040b6:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8040bd:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8040c4:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8040cb:	48 89 c7             	mov    %rax,%rdi
  8040ce:	48 b8 d0 3a 80 00 00 	movabs $0x803ad0,%rax
  8040d5:	00 00 00 
  8040d8:	ff d0                	callq  *%rax
	va_end(ap);
}
  8040da:	c9                   	leaveq 
  8040db:	c3                   	retq   

00000000008040dc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8040dc:	55                   	push   %rbp
  8040dd:	48 89 e5             	mov    %rsp,%rbp
  8040e0:	48 83 ec 10          	sub    $0x10,%rsp
  8040e4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8040e7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8040eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040ef:	8b 40 10             	mov    0x10(%rax),%eax
  8040f2:	8d 50 01             	lea    0x1(%rax),%edx
  8040f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040f9:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8040fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804100:	48 8b 10             	mov    (%rax),%rdx
  804103:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804107:	48 8b 40 08          	mov    0x8(%rax),%rax
  80410b:	48 39 c2             	cmp    %rax,%rdx
  80410e:	73 17                	jae    804127 <sprintputch+0x4b>
		*b->buf++ = ch;
  804110:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804114:	48 8b 00             	mov    (%rax),%rax
  804117:	48 8d 48 01          	lea    0x1(%rax),%rcx
  80411b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80411f:	48 89 0a             	mov    %rcx,(%rdx)
  804122:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804125:	88 10                	mov    %dl,(%rax)
}
  804127:	c9                   	leaveq 
  804128:	c3                   	retq   

0000000000804129 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  804129:	55                   	push   %rbp
  80412a:	48 89 e5             	mov    %rsp,%rbp
  80412d:	48 83 ec 50          	sub    $0x50,%rsp
  804131:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  804135:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  804138:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80413c:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  804140:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  804144:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  804148:	48 8b 0a             	mov    (%rdx),%rcx
  80414b:	48 89 08             	mov    %rcx,(%rax)
  80414e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  804152:	48 89 48 08          	mov    %rcx,0x8(%rax)
  804156:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80415a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80415e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804162:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  804166:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  804169:	48 98                	cltq   
  80416b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80416f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804173:	48 01 d0             	add    %rdx,%rax
  804176:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80417a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  804181:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  804186:	74 06                	je     80418e <vsnprintf+0x65>
  804188:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80418c:	7f 07                	jg     804195 <vsnprintf+0x6c>
		return -E_INVAL;
  80418e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  804193:	eb 2f                	jmp    8041c4 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  804195:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  804199:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80419d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8041a1:	48 89 c6             	mov    %rax,%rsi
  8041a4:	48 bf dc 40 80 00 00 	movabs $0x8040dc,%rdi
  8041ab:	00 00 00 
  8041ae:	48 b8 d0 3a 80 00 00 	movabs $0x803ad0,%rax
  8041b5:	00 00 00 
  8041b8:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8041ba:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041be:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8041c1:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8041c4:	c9                   	leaveq 
  8041c5:	c3                   	retq   

00000000008041c6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8041c6:	55                   	push   %rbp
  8041c7:	48 89 e5             	mov    %rsp,%rbp
  8041ca:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8041d1:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8041d8:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8041de:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8041e5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8041ec:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8041f3:	84 c0                	test   %al,%al
  8041f5:	74 20                	je     804217 <snprintf+0x51>
  8041f7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8041fb:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8041ff:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  804203:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  804207:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80420b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80420f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  804213:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  804217:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  80421e:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  804225:	00 00 00 
  804228:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80422f:	00 00 00 
  804232:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804236:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80423d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  804244:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80424b:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  804252:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  804259:	48 8b 0a             	mov    (%rdx),%rcx
  80425c:	48 89 08             	mov    %rcx,(%rax)
  80425f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  804263:	48 89 48 08          	mov    %rcx,0x8(%rax)
  804267:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80426b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80426f:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  804276:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80427d:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  804283:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80428a:	48 89 c7             	mov    %rax,%rdi
  80428d:	48 b8 29 41 80 00 00 	movabs $0x804129,%rax
  804294:	00 00 00 
  804297:	ff d0                	callq  *%rax
  804299:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80429f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8042a5:	c9                   	leaveq 
  8042a6:	c3                   	retq   

00000000008042a7 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8042a7:	55                   	push   %rbp
  8042a8:	48 89 e5             	mov    %rsp,%rbp
  8042ab:	48 83 ec 18          	sub    $0x18,%rsp
  8042af:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8042b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8042ba:	eb 09                	jmp    8042c5 <strlen+0x1e>
		n++;
  8042bc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8042c0:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8042c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042c9:	0f b6 00             	movzbl (%rax),%eax
  8042cc:	84 c0                	test   %al,%al
  8042ce:	75 ec                	jne    8042bc <strlen+0x15>
		n++;
	return n;
  8042d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8042d3:	c9                   	leaveq 
  8042d4:	c3                   	retq   

00000000008042d5 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8042d5:	55                   	push   %rbp
  8042d6:	48 89 e5             	mov    %rsp,%rbp
  8042d9:	48 83 ec 20          	sub    $0x20,%rsp
  8042dd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8042e1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8042e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8042ec:	eb 0e                	jmp    8042fc <strnlen+0x27>
		n++;
  8042ee:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8042f2:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8042f7:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8042fc:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804301:	74 0b                	je     80430e <strnlen+0x39>
  804303:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804307:	0f b6 00             	movzbl (%rax),%eax
  80430a:	84 c0                	test   %al,%al
  80430c:	75 e0                	jne    8042ee <strnlen+0x19>
		n++;
	return n;
  80430e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804311:	c9                   	leaveq 
  804312:	c3                   	retq   

0000000000804313 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  804313:	55                   	push   %rbp
  804314:	48 89 e5             	mov    %rsp,%rbp
  804317:	48 83 ec 20          	sub    $0x20,%rsp
  80431b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80431f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  804323:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804327:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80432b:	90                   	nop
  80432c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804330:	48 8d 50 01          	lea    0x1(%rax),%rdx
  804334:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  804338:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80433c:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  804340:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  804344:	0f b6 12             	movzbl (%rdx),%edx
  804347:	88 10                	mov    %dl,(%rax)
  804349:	0f b6 00             	movzbl (%rax),%eax
  80434c:	84 c0                	test   %al,%al
  80434e:	75 dc                	jne    80432c <strcpy+0x19>
		/* do nothing */;
	return ret;
  804350:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804354:	c9                   	leaveq 
  804355:	c3                   	retq   

0000000000804356 <strcat>:

char *
strcat(char *dst, const char *src)
{
  804356:	55                   	push   %rbp
  804357:	48 89 e5             	mov    %rsp,%rbp
  80435a:	48 83 ec 20          	sub    $0x20,%rsp
  80435e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804362:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  804366:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80436a:	48 89 c7             	mov    %rax,%rdi
  80436d:	48 b8 a7 42 80 00 00 	movabs $0x8042a7,%rax
  804374:	00 00 00 
  804377:	ff d0                	callq  *%rax
  804379:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80437c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80437f:	48 63 d0             	movslq %eax,%rdx
  804382:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804386:	48 01 c2             	add    %rax,%rdx
  804389:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80438d:	48 89 c6             	mov    %rax,%rsi
  804390:	48 89 d7             	mov    %rdx,%rdi
  804393:	48 b8 13 43 80 00 00 	movabs $0x804313,%rax
  80439a:	00 00 00 
  80439d:	ff d0                	callq  *%rax
	return dst;
  80439f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8043a3:	c9                   	leaveq 
  8043a4:	c3                   	retq   

00000000008043a5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8043a5:	55                   	push   %rbp
  8043a6:	48 89 e5             	mov    %rsp,%rbp
  8043a9:	48 83 ec 28          	sub    $0x28,%rsp
  8043ad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8043b1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8043b5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8043b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8043bd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8043c1:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8043c8:	00 
  8043c9:	eb 2a                	jmp    8043f5 <strncpy+0x50>
		*dst++ = *src;
  8043cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8043cf:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8043d3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8043d7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8043db:	0f b6 12             	movzbl (%rdx),%edx
  8043de:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8043e0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043e4:	0f b6 00             	movzbl (%rax),%eax
  8043e7:	84 c0                	test   %al,%al
  8043e9:	74 05                	je     8043f0 <strncpy+0x4b>
			src++;
  8043eb:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8043f0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8043f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043f9:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8043fd:	72 cc                	jb     8043cb <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8043ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  804403:	c9                   	leaveq 
  804404:	c3                   	retq   

0000000000804405 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  804405:	55                   	push   %rbp
  804406:	48 89 e5             	mov    %rsp,%rbp
  804409:	48 83 ec 28          	sub    $0x28,%rsp
  80440d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804411:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804415:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  804419:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80441d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  804421:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804426:	74 3d                	je     804465 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  804428:	eb 1d                	jmp    804447 <strlcpy+0x42>
			*dst++ = *src++;
  80442a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80442e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  804432:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  804436:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80443a:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80443e:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  804442:	0f b6 12             	movzbl (%rdx),%edx
  804445:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  804447:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80444c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804451:	74 0b                	je     80445e <strlcpy+0x59>
  804453:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804457:	0f b6 00             	movzbl (%rax),%eax
  80445a:	84 c0                	test   %al,%al
  80445c:	75 cc                	jne    80442a <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80445e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804462:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  804465:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804469:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80446d:	48 29 c2             	sub    %rax,%rdx
  804470:	48 89 d0             	mov    %rdx,%rax
}
  804473:	c9                   	leaveq 
  804474:	c3                   	retq   

0000000000804475 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  804475:	55                   	push   %rbp
  804476:	48 89 e5             	mov    %rsp,%rbp
  804479:	48 83 ec 10          	sub    $0x10,%rsp
  80447d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804481:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  804485:	eb 0a                	jmp    804491 <strcmp+0x1c>
		p++, q++;
  804487:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80448c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  804491:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804495:	0f b6 00             	movzbl (%rax),%eax
  804498:	84 c0                	test   %al,%al
  80449a:	74 12                	je     8044ae <strcmp+0x39>
  80449c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044a0:	0f b6 10             	movzbl (%rax),%edx
  8044a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044a7:	0f b6 00             	movzbl (%rax),%eax
  8044aa:	38 c2                	cmp    %al,%dl
  8044ac:	74 d9                	je     804487 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8044ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044b2:	0f b6 00             	movzbl (%rax),%eax
  8044b5:	0f b6 d0             	movzbl %al,%edx
  8044b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044bc:	0f b6 00             	movzbl (%rax),%eax
  8044bf:	0f b6 c0             	movzbl %al,%eax
  8044c2:	29 c2                	sub    %eax,%edx
  8044c4:	89 d0                	mov    %edx,%eax
}
  8044c6:	c9                   	leaveq 
  8044c7:	c3                   	retq   

00000000008044c8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8044c8:	55                   	push   %rbp
  8044c9:	48 89 e5             	mov    %rsp,%rbp
  8044cc:	48 83 ec 18          	sub    $0x18,%rsp
  8044d0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8044d4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8044d8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8044dc:	eb 0f                	jmp    8044ed <strncmp+0x25>
		n--, p++, q++;
  8044de:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8044e3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8044e8:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8044ed:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8044f2:	74 1d                	je     804511 <strncmp+0x49>
  8044f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044f8:	0f b6 00             	movzbl (%rax),%eax
  8044fb:	84 c0                	test   %al,%al
  8044fd:	74 12                	je     804511 <strncmp+0x49>
  8044ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804503:	0f b6 10             	movzbl (%rax),%edx
  804506:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80450a:	0f b6 00             	movzbl (%rax),%eax
  80450d:	38 c2                	cmp    %al,%dl
  80450f:	74 cd                	je     8044de <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  804511:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804516:	75 07                	jne    80451f <strncmp+0x57>
		return 0;
  804518:	b8 00 00 00 00       	mov    $0x0,%eax
  80451d:	eb 18                	jmp    804537 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80451f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804523:	0f b6 00             	movzbl (%rax),%eax
  804526:	0f b6 d0             	movzbl %al,%edx
  804529:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80452d:	0f b6 00             	movzbl (%rax),%eax
  804530:	0f b6 c0             	movzbl %al,%eax
  804533:	29 c2                	sub    %eax,%edx
  804535:	89 d0                	mov    %edx,%eax
}
  804537:	c9                   	leaveq 
  804538:	c3                   	retq   

0000000000804539 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  804539:	55                   	push   %rbp
  80453a:	48 89 e5             	mov    %rsp,%rbp
  80453d:	48 83 ec 0c          	sub    $0xc,%rsp
  804541:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804545:	89 f0                	mov    %esi,%eax
  804547:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80454a:	eb 17                	jmp    804563 <strchr+0x2a>
		if (*s == c)
  80454c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804550:	0f b6 00             	movzbl (%rax),%eax
  804553:	3a 45 f4             	cmp    -0xc(%rbp),%al
  804556:	75 06                	jne    80455e <strchr+0x25>
			return (char *) s;
  804558:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80455c:	eb 15                	jmp    804573 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80455e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804563:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804567:	0f b6 00             	movzbl (%rax),%eax
  80456a:	84 c0                	test   %al,%al
  80456c:	75 de                	jne    80454c <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80456e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804573:	c9                   	leaveq 
  804574:	c3                   	retq   

0000000000804575 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  804575:	55                   	push   %rbp
  804576:	48 89 e5             	mov    %rsp,%rbp
  804579:	48 83 ec 0c          	sub    $0xc,%rsp
  80457d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804581:	89 f0                	mov    %esi,%eax
  804583:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  804586:	eb 13                	jmp    80459b <strfind+0x26>
		if (*s == c)
  804588:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80458c:	0f b6 00             	movzbl (%rax),%eax
  80458f:	3a 45 f4             	cmp    -0xc(%rbp),%al
  804592:	75 02                	jne    804596 <strfind+0x21>
			break;
  804594:	eb 10                	jmp    8045a6 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  804596:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80459b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80459f:	0f b6 00             	movzbl (%rax),%eax
  8045a2:	84 c0                	test   %al,%al
  8045a4:	75 e2                	jne    804588 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8045a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8045aa:	c9                   	leaveq 
  8045ab:	c3                   	retq   

00000000008045ac <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8045ac:	55                   	push   %rbp
  8045ad:	48 89 e5             	mov    %rsp,%rbp
  8045b0:	48 83 ec 18          	sub    $0x18,%rsp
  8045b4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8045b8:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8045bb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8045bf:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8045c4:	75 06                	jne    8045cc <memset+0x20>
		return v;
  8045c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8045ca:	eb 69                	jmp    804635 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8045cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8045d0:	83 e0 03             	and    $0x3,%eax
  8045d3:	48 85 c0             	test   %rax,%rax
  8045d6:	75 48                	jne    804620 <memset+0x74>
  8045d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8045dc:	83 e0 03             	and    $0x3,%eax
  8045df:	48 85 c0             	test   %rax,%rax
  8045e2:	75 3c                	jne    804620 <memset+0x74>
		c &= 0xFF;
  8045e4:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8045eb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8045ee:	c1 e0 18             	shl    $0x18,%eax
  8045f1:	89 c2                	mov    %eax,%edx
  8045f3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8045f6:	c1 e0 10             	shl    $0x10,%eax
  8045f9:	09 c2                	or     %eax,%edx
  8045fb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8045fe:	c1 e0 08             	shl    $0x8,%eax
  804601:	09 d0                	or     %edx,%eax
  804603:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  804606:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80460a:	48 c1 e8 02          	shr    $0x2,%rax
  80460e:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  804611:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804615:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804618:	48 89 d7             	mov    %rdx,%rdi
  80461b:	fc                   	cld    
  80461c:	f3 ab                	rep stos %eax,%es:(%rdi)
  80461e:	eb 11                	jmp    804631 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  804620:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804624:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804627:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80462b:	48 89 d7             	mov    %rdx,%rdi
  80462e:	fc                   	cld    
  80462f:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  804631:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804635:	c9                   	leaveq 
  804636:	c3                   	retq   

0000000000804637 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  804637:	55                   	push   %rbp
  804638:	48 89 e5             	mov    %rsp,%rbp
  80463b:	48 83 ec 28          	sub    $0x28,%rsp
  80463f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804643:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804647:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80464b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80464f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  804653:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804657:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80465b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80465f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  804663:	0f 83 88 00 00 00    	jae    8046f1 <memmove+0xba>
  804669:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80466d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804671:	48 01 d0             	add    %rdx,%rax
  804674:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  804678:	76 77                	jbe    8046f1 <memmove+0xba>
		s += n;
  80467a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80467e:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  804682:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804686:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80468a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80468e:	83 e0 03             	and    $0x3,%eax
  804691:	48 85 c0             	test   %rax,%rax
  804694:	75 3b                	jne    8046d1 <memmove+0x9a>
  804696:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80469a:	83 e0 03             	and    $0x3,%eax
  80469d:	48 85 c0             	test   %rax,%rax
  8046a0:	75 2f                	jne    8046d1 <memmove+0x9a>
  8046a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046a6:	83 e0 03             	and    $0x3,%eax
  8046a9:	48 85 c0             	test   %rax,%rax
  8046ac:	75 23                	jne    8046d1 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8046ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046b2:	48 83 e8 04          	sub    $0x4,%rax
  8046b6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8046ba:	48 83 ea 04          	sub    $0x4,%rdx
  8046be:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8046c2:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8046c6:	48 89 c7             	mov    %rax,%rdi
  8046c9:	48 89 d6             	mov    %rdx,%rsi
  8046cc:	fd                   	std    
  8046cd:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8046cf:	eb 1d                	jmp    8046ee <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8046d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046d5:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8046d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046dd:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8046e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046e5:	48 89 d7             	mov    %rdx,%rdi
  8046e8:	48 89 c1             	mov    %rax,%rcx
  8046eb:	fd                   	std    
  8046ec:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8046ee:	fc                   	cld    
  8046ef:	eb 57                	jmp    804748 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8046f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046f5:	83 e0 03             	and    $0x3,%eax
  8046f8:	48 85 c0             	test   %rax,%rax
  8046fb:	75 36                	jne    804733 <memmove+0xfc>
  8046fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804701:	83 e0 03             	and    $0x3,%eax
  804704:	48 85 c0             	test   %rax,%rax
  804707:	75 2a                	jne    804733 <memmove+0xfc>
  804709:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80470d:	83 e0 03             	and    $0x3,%eax
  804710:	48 85 c0             	test   %rax,%rax
  804713:	75 1e                	jne    804733 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  804715:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804719:	48 c1 e8 02          	shr    $0x2,%rax
  80471d:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  804720:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804724:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804728:	48 89 c7             	mov    %rax,%rdi
  80472b:	48 89 d6             	mov    %rdx,%rsi
  80472e:	fc                   	cld    
  80472f:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  804731:	eb 15                	jmp    804748 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  804733:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804737:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80473b:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80473f:	48 89 c7             	mov    %rax,%rdi
  804742:	48 89 d6             	mov    %rdx,%rsi
  804745:	fc                   	cld    
  804746:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  804748:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80474c:	c9                   	leaveq 
  80474d:	c3                   	retq   

000000000080474e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80474e:	55                   	push   %rbp
  80474f:	48 89 e5             	mov    %rsp,%rbp
  804752:	48 83 ec 18          	sub    $0x18,%rsp
  804756:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80475a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80475e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  804762:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804766:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80476a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80476e:	48 89 ce             	mov    %rcx,%rsi
  804771:	48 89 c7             	mov    %rax,%rdi
  804774:	48 b8 37 46 80 00 00 	movabs $0x804637,%rax
  80477b:	00 00 00 
  80477e:	ff d0                	callq  *%rax
}
  804780:	c9                   	leaveq 
  804781:	c3                   	retq   

0000000000804782 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  804782:	55                   	push   %rbp
  804783:	48 89 e5             	mov    %rsp,%rbp
  804786:	48 83 ec 28          	sub    $0x28,%rsp
  80478a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80478e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804792:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  804796:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80479a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80479e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8047a2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8047a6:	eb 36                	jmp    8047de <memcmp+0x5c>
		if (*s1 != *s2)
  8047a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8047ac:	0f b6 10             	movzbl (%rax),%edx
  8047af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047b3:	0f b6 00             	movzbl (%rax),%eax
  8047b6:	38 c2                	cmp    %al,%dl
  8047b8:	74 1a                	je     8047d4 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8047ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8047be:	0f b6 00             	movzbl (%rax),%eax
  8047c1:	0f b6 d0             	movzbl %al,%edx
  8047c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047c8:	0f b6 00             	movzbl (%rax),%eax
  8047cb:	0f b6 c0             	movzbl %al,%eax
  8047ce:	29 c2                	sub    %eax,%edx
  8047d0:	89 d0                	mov    %edx,%eax
  8047d2:	eb 20                	jmp    8047f4 <memcmp+0x72>
		s1++, s2++;
  8047d4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8047d9:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8047de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8047e2:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8047e6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8047ea:	48 85 c0             	test   %rax,%rax
  8047ed:	75 b9                	jne    8047a8 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8047ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8047f4:	c9                   	leaveq 
  8047f5:	c3                   	retq   

00000000008047f6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8047f6:	55                   	push   %rbp
  8047f7:	48 89 e5             	mov    %rsp,%rbp
  8047fa:	48 83 ec 28          	sub    $0x28,%rsp
  8047fe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804802:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  804805:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  804809:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80480d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804811:	48 01 d0             	add    %rdx,%rax
  804814:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  804818:	eb 15                	jmp    80482f <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80481a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80481e:	0f b6 10             	movzbl (%rax),%edx
  804821:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804824:	38 c2                	cmp    %al,%dl
  804826:	75 02                	jne    80482a <memfind+0x34>
			break;
  804828:	eb 0f                	jmp    804839 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80482a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80482f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804833:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  804837:	72 e1                	jb     80481a <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  804839:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80483d:	c9                   	leaveq 
  80483e:	c3                   	retq   

000000000080483f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80483f:	55                   	push   %rbp
  804840:	48 89 e5             	mov    %rsp,%rbp
  804843:	48 83 ec 34          	sub    $0x34,%rsp
  804847:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80484b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80484f:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  804852:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  804859:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  804860:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  804861:	eb 05                	jmp    804868 <strtol+0x29>
		s++;
  804863:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  804868:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80486c:	0f b6 00             	movzbl (%rax),%eax
  80486f:	3c 20                	cmp    $0x20,%al
  804871:	74 f0                	je     804863 <strtol+0x24>
  804873:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804877:	0f b6 00             	movzbl (%rax),%eax
  80487a:	3c 09                	cmp    $0x9,%al
  80487c:	74 e5                	je     804863 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80487e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804882:	0f b6 00             	movzbl (%rax),%eax
  804885:	3c 2b                	cmp    $0x2b,%al
  804887:	75 07                	jne    804890 <strtol+0x51>
		s++;
  804889:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80488e:	eb 17                	jmp    8048a7 <strtol+0x68>
	else if (*s == '-')
  804890:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804894:	0f b6 00             	movzbl (%rax),%eax
  804897:	3c 2d                	cmp    $0x2d,%al
  804899:	75 0c                	jne    8048a7 <strtol+0x68>
		s++, neg = 1;
  80489b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8048a0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8048a7:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8048ab:	74 06                	je     8048b3 <strtol+0x74>
  8048ad:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8048b1:	75 28                	jne    8048db <strtol+0x9c>
  8048b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048b7:	0f b6 00             	movzbl (%rax),%eax
  8048ba:	3c 30                	cmp    $0x30,%al
  8048bc:	75 1d                	jne    8048db <strtol+0x9c>
  8048be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048c2:	48 83 c0 01          	add    $0x1,%rax
  8048c6:	0f b6 00             	movzbl (%rax),%eax
  8048c9:	3c 78                	cmp    $0x78,%al
  8048cb:	75 0e                	jne    8048db <strtol+0x9c>
		s += 2, base = 16;
  8048cd:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8048d2:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8048d9:	eb 2c                	jmp    804907 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8048db:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8048df:	75 19                	jne    8048fa <strtol+0xbb>
  8048e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048e5:	0f b6 00             	movzbl (%rax),%eax
  8048e8:	3c 30                	cmp    $0x30,%al
  8048ea:	75 0e                	jne    8048fa <strtol+0xbb>
		s++, base = 8;
  8048ec:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8048f1:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8048f8:	eb 0d                	jmp    804907 <strtol+0xc8>
	else if (base == 0)
  8048fa:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8048fe:	75 07                	jne    804907 <strtol+0xc8>
		base = 10;
  804900:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  804907:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80490b:	0f b6 00             	movzbl (%rax),%eax
  80490e:	3c 2f                	cmp    $0x2f,%al
  804910:	7e 1d                	jle    80492f <strtol+0xf0>
  804912:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804916:	0f b6 00             	movzbl (%rax),%eax
  804919:	3c 39                	cmp    $0x39,%al
  80491b:	7f 12                	jg     80492f <strtol+0xf0>
			dig = *s - '0';
  80491d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804921:	0f b6 00             	movzbl (%rax),%eax
  804924:	0f be c0             	movsbl %al,%eax
  804927:	83 e8 30             	sub    $0x30,%eax
  80492a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80492d:	eb 4e                	jmp    80497d <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80492f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804933:	0f b6 00             	movzbl (%rax),%eax
  804936:	3c 60                	cmp    $0x60,%al
  804938:	7e 1d                	jle    804957 <strtol+0x118>
  80493a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80493e:	0f b6 00             	movzbl (%rax),%eax
  804941:	3c 7a                	cmp    $0x7a,%al
  804943:	7f 12                	jg     804957 <strtol+0x118>
			dig = *s - 'a' + 10;
  804945:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804949:	0f b6 00             	movzbl (%rax),%eax
  80494c:	0f be c0             	movsbl %al,%eax
  80494f:	83 e8 57             	sub    $0x57,%eax
  804952:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804955:	eb 26                	jmp    80497d <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  804957:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80495b:	0f b6 00             	movzbl (%rax),%eax
  80495e:	3c 40                	cmp    $0x40,%al
  804960:	7e 48                	jle    8049aa <strtol+0x16b>
  804962:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804966:	0f b6 00             	movzbl (%rax),%eax
  804969:	3c 5a                	cmp    $0x5a,%al
  80496b:	7f 3d                	jg     8049aa <strtol+0x16b>
			dig = *s - 'A' + 10;
  80496d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804971:	0f b6 00             	movzbl (%rax),%eax
  804974:	0f be c0             	movsbl %al,%eax
  804977:	83 e8 37             	sub    $0x37,%eax
  80497a:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80497d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804980:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  804983:	7c 02                	jl     804987 <strtol+0x148>
			break;
  804985:	eb 23                	jmp    8049aa <strtol+0x16b>
		s++, val = (val * base) + dig;
  804987:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80498c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80498f:	48 98                	cltq   
  804991:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  804996:	48 89 c2             	mov    %rax,%rdx
  804999:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80499c:	48 98                	cltq   
  80499e:	48 01 d0             	add    %rdx,%rax
  8049a1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8049a5:	e9 5d ff ff ff       	jmpq   804907 <strtol+0xc8>

	if (endptr)
  8049aa:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8049af:	74 0b                	je     8049bc <strtol+0x17d>
		*endptr = (char *) s;
  8049b1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8049b5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8049b9:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8049bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8049c0:	74 09                	je     8049cb <strtol+0x18c>
  8049c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8049c6:	48 f7 d8             	neg    %rax
  8049c9:	eb 04                	jmp    8049cf <strtol+0x190>
  8049cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8049cf:	c9                   	leaveq 
  8049d0:	c3                   	retq   

00000000008049d1 <strstr>:

char * strstr(const char *in, const char *str)
{
  8049d1:	55                   	push   %rbp
  8049d2:	48 89 e5             	mov    %rsp,%rbp
  8049d5:	48 83 ec 30          	sub    $0x30,%rsp
  8049d9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8049dd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8049e1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8049e5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8049e9:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8049ed:	0f b6 00             	movzbl (%rax),%eax
  8049f0:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8049f3:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8049f7:	75 06                	jne    8049ff <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8049f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8049fd:	eb 6b                	jmp    804a6a <strstr+0x99>

	len = strlen(str);
  8049ff:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804a03:	48 89 c7             	mov    %rax,%rdi
  804a06:	48 b8 a7 42 80 00 00 	movabs $0x8042a7,%rax
  804a0d:	00 00 00 
  804a10:	ff d0                	callq  *%rax
  804a12:	48 98                	cltq   
  804a14:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  804a18:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a1c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  804a20:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  804a24:	0f b6 00             	movzbl (%rax),%eax
  804a27:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  804a2a:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  804a2e:	75 07                	jne    804a37 <strstr+0x66>
				return (char *) 0;
  804a30:	b8 00 00 00 00       	mov    $0x0,%eax
  804a35:	eb 33                	jmp    804a6a <strstr+0x99>
		} while (sc != c);
  804a37:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  804a3b:	3a 45 ff             	cmp    -0x1(%rbp),%al
  804a3e:	75 d8                	jne    804a18 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  804a40:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804a44:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  804a48:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a4c:	48 89 ce             	mov    %rcx,%rsi
  804a4f:	48 89 c7             	mov    %rax,%rdi
  804a52:	48 b8 c8 44 80 00 00 	movabs $0x8044c8,%rax
  804a59:	00 00 00 
  804a5c:	ff d0                	callq  *%rax
  804a5e:	85 c0                	test   %eax,%eax
  804a60:	75 b6                	jne    804a18 <strstr+0x47>

	return (char *) (in - 1);
  804a62:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a66:	48 83 e8 01          	sub    $0x1,%rax
}
  804a6a:	c9                   	leaveq 
  804a6b:	c3                   	retq   

0000000000804a6c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  804a6c:	55                   	push   %rbp
  804a6d:	48 89 e5             	mov    %rsp,%rbp
  804a70:	53                   	push   %rbx
  804a71:	48 83 ec 48          	sub    $0x48,%rsp
  804a75:	89 7d dc             	mov    %edi,-0x24(%rbp)
  804a78:	89 75 d8             	mov    %esi,-0x28(%rbp)
  804a7b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  804a7f:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  804a83:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  804a87:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  804a8b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804a8e:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  804a92:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  804a96:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  804a9a:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  804a9e:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  804aa2:	4c 89 c3             	mov    %r8,%rbx
  804aa5:	cd 30                	int    $0x30
  804aa7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  804aab:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  804aaf:	74 3e                	je     804aef <syscall+0x83>
  804ab1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804ab6:	7e 37                	jle    804aef <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  804ab8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804abc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804abf:	49 89 d0             	mov    %rdx,%r8
  804ac2:	89 c1                	mov    %eax,%ecx
  804ac4:	48 ba 08 77 80 00 00 	movabs $0x807708,%rdx
  804acb:	00 00 00 
  804ace:	be 23 00 00 00       	mov    $0x23,%esi
  804ad3:	48 bf 25 77 80 00 00 	movabs $0x807725,%rdi
  804ada:	00 00 00 
  804add:	b8 00 00 00 00       	mov    $0x0,%eax
  804ae2:	49 b9 e4 34 80 00 00 	movabs $0x8034e4,%r9
  804ae9:	00 00 00 
  804aec:	41 ff d1             	callq  *%r9

	return ret;
  804aef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  804af3:	48 83 c4 48          	add    $0x48,%rsp
  804af7:	5b                   	pop    %rbx
  804af8:	5d                   	pop    %rbp
  804af9:	c3                   	retq   

0000000000804afa <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  804afa:	55                   	push   %rbp
  804afb:	48 89 e5             	mov    %rsp,%rbp
  804afe:	48 83 ec 20          	sub    $0x20,%rsp
  804b02:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804b06:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  804b0a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b0e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804b12:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804b19:	00 
  804b1a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804b20:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804b26:	48 89 d1             	mov    %rdx,%rcx
  804b29:	48 89 c2             	mov    %rax,%rdx
  804b2c:	be 00 00 00 00       	mov    $0x0,%esi
  804b31:	bf 00 00 00 00       	mov    $0x0,%edi
  804b36:	48 b8 6c 4a 80 00 00 	movabs $0x804a6c,%rax
  804b3d:	00 00 00 
  804b40:	ff d0                	callq  *%rax
}
  804b42:	c9                   	leaveq 
  804b43:	c3                   	retq   

0000000000804b44 <sys_cgetc>:

int
sys_cgetc(void)
{
  804b44:	55                   	push   %rbp
  804b45:	48 89 e5             	mov    %rsp,%rbp
  804b48:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  804b4c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804b53:	00 
  804b54:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804b5a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804b60:	b9 00 00 00 00       	mov    $0x0,%ecx
  804b65:	ba 00 00 00 00       	mov    $0x0,%edx
  804b6a:	be 00 00 00 00       	mov    $0x0,%esi
  804b6f:	bf 01 00 00 00       	mov    $0x1,%edi
  804b74:	48 b8 6c 4a 80 00 00 	movabs $0x804a6c,%rax
  804b7b:	00 00 00 
  804b7e:	ff d0                	callq  *%rax
}
  804b80:	c9                   	leaveq 
  804b81:	c3                   	retq   

0000000000804b82 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  804b82:	55                   	push   %rbp
  804b83:	48 89 e5             	mov    %rsp,%rbp
  804b86:	48 83 ec 10          	sub    $0x10,%rsp
  804b8a:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  804b8d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804b90:	48 98                	cltq   
  804b92:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804b99:	00 
  804b9a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804ba0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804ba6:	b9 00 00 00 00       	mov    $0x0,%ecx
  804bab:	48 89 c2             	mov    %rax,%rdx
  804bae:	be 01 00 00 00       	mov    $0x1,%esi
  804bb3:	bf 03 00 00 00       	mov    $0x3,%edi
  804bb8:	48 b8 6c 4a 80 00 00 	movabs $0x804a6c,%rax
  804bbf:	00 00 00 
  804bc2:	ff d0                	callq  *%rax
}
  804bc4:	c9                   	leaveq 
  804bc5:	c3                   	retq   

0000000000804bc6 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  804bc6:	55                   	push   %rbp
  804bc7:	48 89 e5             	mov    %rsp,%rbp
  804bca:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  804bce:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804bd5:	00 
  804bd6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804bdc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804be2:	b9 00 00 00 00       	mov    $0x0,%ecx
  804be7:	ba 00 00 00 00       	mov    $0x0,%edx
  804bec:	be 00 00 00 00       	mov    $0x0,%esi
  804bf1:	bf 02 00 00 00       	mov    $0x2,%edi
  804bf6:	48 b8 6c 4a 80 00 00 	movabs $0x804a6c,%rax
  804bfd:	00 00 00 
  804c00:	ff d0                	callq  *%rax
}
  804c02:	c9                   	leaveq 
  804c03:	c3                   	retq   

0000000000804c04 <sys_yield>:

void
sys_yield(void)
{
  804c04:	55                   	push   %rbp
  804c05:	48 89 e5             	mov    %rsp,%rbp
  804c08:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  804c0c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804c13:	00 
  804c14:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804c1a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804c20:	b9 00 00 00 00       	mov    $0x0,%ecx
  804c25:	ba 00 00 00 00       	mov    $0x0,%edx
  804c2a:	be 00 00 00 00       	mov    $0x0,%esi
  804c2f:	bf 0b 00 00 00       	mov    $0xb,%edi
  804c34:	48 b8 6c 4a 80 00 00 	movabs $0x804a6c,%rax
  804c3b:	00 00 00 
  804c3e:	ff d0                	callq  *%rax
}
  804c40:	c9                   	leaveq 
  804c41:	c3                   	retq   

0000000000804c42 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  804c42:	55                   	push   %rbp
  804c43:	48 89 e5             	mov    %rsp,%rbp
  804c46:	48 83 ec 20          	sub    $0x20,%rsp
  804c4a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804c4d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804c51:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  804c54:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804c57:	48 63 c8             	movslq %eax,%rcx
  804c5a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804c5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c61:	48 98                	cltq   
  804c63:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804c6a:	00 
  804c6b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804c71:	49 89 c8             	mov    %rcx,%r8
  804c74:	48 89 d1             	mov    %rdx,%rcx
  804c77:	48 89 c2             	mov    %rax,%rdx
  804c7a:	be 01 00 00 00       	mov    $0x1,%esi
  804c7f:	bf 04 00 00 00       	mov    $0x4,%edi
  804c84:	48 b8 6c 4a 80 00 00 	movabs $0x804a6c,%rax
  804c8b:	00 00 00 
  804c8e:	ff d0                	callq  *%rax
}
  804c90:	c9                   	leaveq 
  804c91:	c3                   	retq   

0000000000804c92 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  804c92:	55                   	push   %rbp
  804c93:	48 89 e5             	mov    %rsp,%rbp
  804c96:	48 83 ec 30          	sub    $0x30,%rsp
  804c9a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804c9d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804ca1:	89 55 f8             	mov    %edx,-0x8(%rbp)
  804ca4:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  804ca8:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  804cac:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804caf:	48 63 c8             	movslq %eax,%rcx
  804cb2:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  804cb6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804cb9:	48 63 f0             	movslq %eax,%rsi
  804cbc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804cc0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804cc3:	48 98                	cltq   
  804cc5:	48 89 0c 24          	mov    %rcx,(%rsp)
  804cc9:	49 89 f9             	mov    %rdi,%r9
  804ccc:	49 89 f0             	mov    %rsi,%r8
  804ccf:	48 89 d1             	mov    %rdx,%rcx
  804cd2:	48 89 c2             	mov    %rax,%rdx
  804cd5:	be 01 00 00 00       	mov    $0x1,%esi
  804cda:	bf 05 00 00 00       	mov    $0x5,%edi
  804cdf:	48 b8 6c 4a 80 00 00 	movabs $0x804a6c,%rax
  804ce6:	00 00 00 
  804ce9:	ff d0                	callq  *%rax
}
  804ceb:	c9                   	leaveq 
  804cec:	c3                   	retq   

0000000000804ced <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  804ced:	55                   	push   %rbp
  804cee:	48 89 e5             	mov    %rsp,%rbp
  804cf1:	48 83 ec 20          	sub    $0x20,%rsp
  804cf5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804cf8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  804cfc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804d00:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804d03:	48 98                	cltq   
  804d05:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804d0c:	00 
  804d0d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804d13:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804d19:	48 89 d1             	mov    %rdx,%rcx
  804d1c:	48 89 c2             	mov    %rax,%rdx
  804d1f:	be 01 00 00 00       	mov    $0x1,%esi
  804d24:	bf 06 00 00 00       	mov    $0x6,%edi
  804d29:	48 b8 6c 4a 80 00 00 	movabs $0x804a6c,%rax
  804d30:	00 00 00 
  804d33:	ff d0                	callq  *%rax
}
  804d35:	c9                   	leaveq 
  804d36:	c3                   	retq   

0000000000804d37 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  804d37:	55                   	push   %rbp
  804d38:	48 89 e5             	mov    %rsp,%rbp
  804d3b:	48 83 ec 10          	sub    $0x10,%rsp
  804d3f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804d42:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  804d45:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804d48:	48 63 d0             	movslq %eax,%rdx
  804d4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804d4e:	48 98                	cltq   
  804d50:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804d57:	00 
  804d58:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804d5e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804d64:	48 89 d1             	mov    %rdx,%rcx
  804d67:	48 89 c2             	mov    %rax,%rdx
  804d6a:	be 01 00 00 00       	mov    $0x1,%esi
  804d6f:	bf 08 00 00 00       	mov    $0x8,%edi
  804d74:	48 b8 6c 4a 80 00 00 	movabs $0x804a6c,%rax
  804d7b:	00 00 00 
  804d7e:	ff d0                	callq  *%rax
}
  804d80:	c9                   	leaveq 
  804d81:	c3                   	retq   

0000000000804d82 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  804d82:	55                   	push   %rbp
  804d83:	48 89 e5             	mov    %rsp,%rbp
  804d86:	48 83 ec 20          	sub    $0x20,%rsp
  804d8a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804d8d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  804d91:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804d95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804d98:	48 98                	cltq   
  804d9a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804da1:	00 
  804da2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804da8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804dae:	48 89 d1             	mov    %rdx,%rcx
  804db1:	48 89 c2             	mov    %rax,%rdx
  804db4:	be 01 00 00 00       	mov    $0x1,%esi
  804db9:	bf 09 00 00 00       	mov    $0x9,%edi
  804dbe:	48 b8 6c 4a 80 00 00 	movabs $0x804a6c,%rax
  804dc5:	00 00 00 
  804dc8:	ff d0                	callq  *%rax
}
  804dca:	c9                   	leaveq 
  804dcb:	c3                   	retq   

0000000000804dcc <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  804dcc:	55                   	push   %rbp
  804dcd:	48 89 e5             	mov    %rsp,%rbp
  804dd0:	48 83 ec 20          	sub    $0x20,%rsp
  804dd4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804dd7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  804ddb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804ddf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804de2:	48 98                	cltq   
  804de4:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804deb:	00 
  804dec:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804df2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804df8:	48 89 d1             	mov    %rdx,%rcx
  804dfb:	48 89 c2             	mov    %rax,%rdx
  804dfe:	be 01 00 00 00       	mov    $0x1,%esi
  804e03:	bf 0a 00 00 00       	mov    $0xa,%edi
  804e08:	48 b8 6c 4a 80 00 00 	movabs $0x804a6c,%rax
  804e0f:	00 00 00 
  804e12:	ff d0                	callq  *%rax
}
  804e14:	c9                   	leaveq 
  804e15:	c3                   	retq   

0000000000804e16 <sys_set_priority>:

void
sys_set_priority(envid_t envid, int priority)
{
  804e16:	55                   	push   %rbp
  804e17:	48 89 e5             	mov    %rsp,%rbp
  804e1a:	48 83 ec 10          	sub    $0x10,%rsp
  804e1e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804e21:	89 75 f8             	mov    %esi,-0x8(%rbp)
	syscall(SYS_set_priority,1,envid,priority,0,0,0);
  804e24:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804e27:	48 63 d0             	movslq %eax,%rdx
  804e2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804e2d:	48 98                	cltq   
  804e2f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804e36:	00 
  804e37:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804e3d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804e43:	48 89 d1             	mov    %rdx,%rcx
  804e46:	48 89 c2             	mov    %rax,%rdx
  804e49:	be 01 00 00 00       	mov    $0x1,%esi
  804e4e:	bf 11 00 00 00       	mov    $0x11,%edi
  804e53:	48 b8 6c 4a 80 00 00 	movabs $0x804a6c,%rax
  804e5a:	00 00 00 
  804e5d:	ff d0                	callq  *%rax

}
  804e5f:	c9                   	leaveq 
  804e60:	c3                   	retq   

0000000000804e61 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  804e61:	55                   	push   %rbp
  804e62:	48 89 e5             	mov    %rsp,%rbp
  804e65:	48 83 ec 20          	sub    $0x20,%rsp
  804e69:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804e6c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804e70:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  804e74:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  804e77:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804e7a:	48 63 f0             	movslq %eax,%rsi
  804e7d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804e81:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804e84:	48 98                	cltq   
  804e86:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804e8a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804e91:	00 
  804e92:	49 89 f1             	mov    %rsi,%r9
  804e95:	49 89 c8             	mov    %rcx,%r8
  804e98:	48 89 d1             	mov    %rdx,%rcx
  804e9b:	48 89 c2             	mov    %rax,%rdx
  804e9e:	be 00 00 00 00       	mov    $0x0,%esi
  804ea3:	bf 0c 00 00 00       	mov    $0xc,%edi
  804ea8:	48 b8 6c 4a 80 00 00 	movabs $0x804a6c,%rax
  804eaf:	00 00 00 
  804eb2:	ff d0                	callq  *%rax
}
  804eb4:	c9                   	leaveq 
  804eb5:	c3                   	retq   

0000000000804eb6 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  804eb6:	55                   	push   %rbp
  804eb7:	48 89 e5             	mov    %rsp,%rbp
  804eba:	48 83 ec 10          	sub    $0x10,%rsp
  804ebe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  804ec2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804ec6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804ecd:	00 
  804ece:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804ed4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804eda:	b9 00 00 00 00       	mov    $0x0,%ecx
  804edf:	48 89 c2             	mov    %rax,%rdx
  804ee2:	be 01 00 00 00       	mov    $0x1,%esi
  804ee7:	bf 0d 00 00 00       	mov    $0xd,%edi
  804eec:	48 b8 6c 4a 80 00 00 	movabs $0x804a6c,%rax
  804ef3:	00 00 00 
  804ef6:	ff d0                	callq  *%rax
}
  804ef8:	c9                   	leaveq 
  804ef9:	c3                   	retq   

0000000000804efa <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  804efa:	55                   	push   %rbp
  804efb:	48 89 e5             	mov    %rsp,%rbp
  804efe:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  804f02:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804f09:	00 
  804f0a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804f10:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804f16:	b9 00 00 00 00       	mov    $0x0,%ecx
  804f1b:	ba 00 00 00 00       	mov    $0x0,%edx
  804f20:	be 00 00 00 00       	mov    $0x0,%esi
  804f25:	bf 0e 00 00 00       	mov    $0xe,%edi
  804f2a:	48 b8 6c 4a 80 00 00 	movabs $0x804a6c,%rax
  804f31:	00 00 00 
  804f34:	ff d0                	callq  *%rax
}
  804f36:	c9                   	leaveq 
  804f37:	c3                   	retq   

0000000000804f38 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  804f38:	55                   	push   %rbp
  804f39:	48 89 e5             	mov    %rsp,%rbp
  804f3c:	48 83 ec 30          	sub    $0x30,%rsp
  804f40:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804f43:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804f47:	89 55 f8             	mov    %edx,-0x8(%rbp)
  804f4a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  804f4e:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  804f52:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804f55:	48 63 c8             	movslq %eax,%rcx
  804f58:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  804f5c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804f5f:	48 63 f0             	movslq %eax,%rsi
  804f62:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804f66:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804f69:	48 98                	cltq   
  804f6b:	48 89 0c 24          	mov    %rcx,(%rsp)
  804f6f:	49 89 f9             	mov    %rdi,%r9
  804f72:	49 89 f0             	mov    %rsi,%r8
  804f75:	48 89 d1             	mov    %rdx,%rcx
  804f78:	48 89 c2             	mov    %rax,%rdx
  804f7b:	be 00 00 00 00       	mov    $0x0,%esi
  804f80:	bf 0f 00 00 00       	mov    $0xf,%edi
  804f85:	48 b8 6c 4a 80 00 00 	movabs $0x804a6c,%rax
  804f8c:	00 00 00 
  804f8f:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  804f91:	c9                   	leaveq 
  804f92:	c3                   	retq   

0000000000804f93 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  804f93:	55                   	push   %rbp
  804f94:	48 89 e5             	mov    %rsp,%rbp
  804f97:	48 83 ec 20          	sub    $0x20,%rsp
  804f9b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804f9f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  804fa3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804fa7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804fab:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  804fb2:	00 
  804fb3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804fb9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804fbf:	48 89 d1             	mov    %rdx,%rcx
  804fc2:	48 89 c2             	mov    %rax,%rdx
  804fc5:	be 00 00 00 00       	mov    $0x0,%esi
  804fca:	bf 10 00 00 00       	mov    $0x10,%edi
  804fcf:	48 b8 6c 4a 80 00 00 	movabs $0x804a6c,%rax
  804fd6:	00 00 00 
  804fd9:	ff d0                	callq  *%rax
}
  804fdb:	c9                   	leaveq 
  804fdc:	c3                   	retq   

0000000000804fdd <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  804fdd:	55                   	push   %rbp
  804fde:	48 89 e5             	mov    %rsp,%rbp
  804fe1:	48 83 ec 20          	sub    $0x20,%rsp
  804fe5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  804fe9:	48 b8 30 40 81 00 00 	movabs $0x814030,%rax
  804ff0:	00 00 00 
  804ff3:	48 8b 00             	mov    (%rax),%rax
  804ff6:	48 85 c0             	test   %rax,%rax
  804ff9:	75 6f                	jne    80506a <set_pgfault_handler+0x8d>
		// First time through!
		// LAB 4: Your code here.

		if ((r = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0)
  804ffb:	ba 07 00 00 00       	mov    $0x7,%edx
  805000:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  805005:	bf 00 00 00 00       	mov    $0x0,%edi
  80500a:	48 b8 42 4c 80 00 00 	movabs $0x804c42,%rax
  805011:	00 00 00 
  805014:	ff d0                	callq  *%rax
  805016:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805019:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80501d:	79 30                	jns    80504f <set_pgfault_handler+0x72>
            panic("set_pgfault_handler: %d\n", r);
  80501f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805022:	89 c1                	mov    %eax,%ecx
  805024:	48 ba 33 77 80 00 00 	movabs $0x807733,%rdx
  80502b:	00 00 00 
  80502e:	be 22 00 00 00       	mov    $0x22,%esi
  805033:	48 bf 4c 77 80 00 00 	movabs $0x80774c,%rdi
  80503a:	00 00 00 
  80503d:	b8 00 00 00 00       	mov    $0x0,%eax
  805042:	49 b8 e4 34 80 00 00 	movabs $0x8034e4,%r8
  805049:	00 00 00 
  80504c:	41 ff d0             	callq  *%r8
        sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  80504f:	48 be 7d 50 80 00 00 	movabs $0x80507d,%rsi
  805056:	00 00 00 
  805059:	bf 00 00 00 00       	mov    $0x0,%edi
  80505e:	48 b8 cc 4d 80 00 00 	movabs $0x804dcc,%rax
  805065:	00 00 00 
  805068:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80506a:	48 b8 30 40 81 00 00 	movabs $0x814030,%rax
  805071:	00 00 00 
  805074:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  805078:	48 89 10             	mov    %rdx,(%rax)
}
  80507b:	c9                   	leaveq 
  80507c:	c3                   	retq   

000000000080507d <_pgfault_upcall>:
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF


	movq %rsp, %rdi;	
  80507d:	48 89 e7             	mov    %rsp,%rdi
	movq 136(%rsp), %rbx;
  805080:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  805087:	00 
	movq 152(%rsp), %rsp;// Going to another stack for storing rip	
  805088:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  80508f:	00 
	pushq %rbx;
  805090:	53                   	push   %rbx
	movq %rsp, %rbx;	
  805091:	48 89 e3             	mov    %rsp,%rbx
	movq %rdi, %rsp;	
  805094:	48 89 fc             	mov    %rdi,%rsp
	movq %rbx, 152(%rsp)	
  805097:	48 89 9c 24 98 00 00 	mov    %rbx,0x98(%rsp)
  80509e:	00 
   
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16, %rsp;	
  80509f:	48 83 c4 10          	add    $0x10,%rsp
	POPA_;  // getting all register values back
  8050a3:	4c 8b 3c 24          	mov    (%rsp),%r15
  8050a7:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8050ac:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8050b1:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8050b6:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8050bb:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8050c0:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8050c5:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8050ca:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8050cf:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  8050d4:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8050d9:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8050de:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8050e3:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8050e8:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8050ed:	48 83 c4 78          	add    $0x78,%rsp
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.


	add $8, %rsp; //Jump rip field  
  8050f1:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  8050f5:	9d                   	popfq  

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp   //USTACK
  8050f6:	5c                   	pop    %rsp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret   
  8050f7:	c3                   	retq   

00000000008050f8 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8050f8:	55                   	push   %rbp
  8050f9:	48 89 e5             	mov    %rsp,%rbp
  8050fc:	48 83 ec 30          	sub    $0x30,%rsp
  805100:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805104:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805108:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	//LAB 4: Your code here.
	if (!pg) pg=(void*)-1;
  80510c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  805111:	75 08                	jne    80511b <ipc_recv+0x23>
  805113:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  80511a:	ff 
	int res=sys_ipc_recv(pg);
  80511b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80511f:	48 89 c7             	mov    %rax,%rdi
  805122:	48 b8 b6 4e 80 00 00 	movabs $0x804eb6,%rax
  805129:	00 00 00 
  80512c:	ff d0                	callq  *%rax
  80512e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	
	if (from_env_store) *from_env_store=res==0?thisenv->env_ipc_from:0;
  805131:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  805136:	74 26                	je     80515e <ipc_recv+0x66>
  805138:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80513c:	75 15                	jne    805153 <ipc_recv+0x5b>
  80513e:	48 b8 20 40 81 00 00 	movabs $0x814020,%rax
  805145:	00 00 00 
  805148:	48 8b 00             	mov    (%rax),%rax
  80514b:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  805151:	eb 05                	jmp    805158 <ipc_recv+0x60>
  805153:	b8 00 00 00 00       	mov    $0x0,%eax
  805158:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80515c:	89 02                	mov    %eax,(%rdx)
	if (perm_store) *perm_store=res==0?thisenv->env_ipc_perm:0;
  80515e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  805163:	74 26                	je     80518b <ipc_recv+0x93>
  805165:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805169:	75 15                	jne    805180 <ipc_recv+0x88>
  80516b:	48 b8 20 40 81 00 00 	movabs $0x814020,%rax
  805172:	00 00 00 
  805175:	48 8b 00             	mov    (%rax),%rax
  805178:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  80517e:	eb 05                	jmp    805185 <ipc_recv+0x8d>
  805180:	b8 00 00 00 00       	mov    $0x0,%eax
  805185:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  805189:	89 02                	mov    %eax,(%rdx)
	return res!=0?res:thisenv->env_ipc_value;
  80518b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80518f:	75 15                	jne    8051a6 <ipc_recv+0xae>
  805191:	48 b8 20 40 81 00 00 	movabs $0x814020,%rax
  805198:	00 00 00 
  80519b:	48 8b 00             	mov    (%rax),%rax
  80519e:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  8051a4:	eb 03                	jmp    8051a9 <ipc_recv+0xb1>
  8051a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
	

}
  8051a9:	c9                   	leaveq 
  8051aa:	c3                   	retq   

00000000008051ab <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8051ab:	55                   	push   %rbp
  8051ac:	48 89 e5             	mov    %rsp,%rbp
  8051af:	48 83 ec 30          	sub    $0x30,%rsp
  8051b3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8051b6:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8051b9:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8051bd:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.

	if (!pg) pg=(void*)-1;
  8051c0:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8051c5:	75 0a                	jne    8051d1 <ipc_send+0x26>
  8051c7:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  8051ce:	ff 
	int res;
	while ((res=sys_ipc_try_send(to_env, val, pg, perm))<0){
  8051cf:	eb 3e                	jmp    80520f <ipc_send+0x64>
  8051d1:	eb 3c                	jmp    80520f <ipc_send+0x64>
		if(res!=-E_IPC_NOT_RECV)
  8051d3:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8051d7:	74 2a                	je     805203 <ipc_send+0x58>
			panic("ipc_send:error other than -E_IPC_NOT_RECV\n");
  8051d9:	48 ba 60 77 80 00 00 	movabs $0x807760,%rdx
  8051e0:	00 00 00 
  8051e3:	be 39 00 00 00       	mov    $0x39,%esi
  8051e8:	48 bf 8b 77 80 00 00 	movabs $0x80778b,%rdi
  8051ef:	00 00 00 
  8051f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8051f7:	48 b9 e4 34 80 00 00 	movabs $0x8034e4,%rcx
  8051fe:	00 00 00 
  805201:	ff d1                	callq  *%rcx
		sys_yield();  
  805203:	48 b8 04 4c 80 00 00 	movabs $0x804c04,%rax
  80520a:	00 00 00 
  80520d:	ff d0                	callq  *%rax
{
	// LAB 4: Your code here.

	if (!pg) pg=(void*)-1;
	int res;
	while ((res=sys_ipc_try_send(to_env, val, pg, perm))<0){
  80520f:	8b 75 e8             	mov    -0x18(%rbp),%esi
  805212:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  805215:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  805219:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80521c:	89 c7                	mov    %eax,%edi
  80521e:	48 b8 61 4e 80 00 00 	movabs $0x804e61,%rax
  805225:	00 00 00 
  805228:	ff d0                	callq  *%rax
  80522a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80522d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805231:	78 a0                	js     8051d3 <ipc_send+0x28>
			panic("ipc_send:error other than -E_IPC_NOT_RECV\n");
		sys_yield();  
	}
	//panic("ipc_send not implemented");

}
  805233:	c9                   	leaveq 
  805234:	c3                   	retq   

0000000000805235 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  805235:	55                   	push   %rbp
  805236:	48 89 e5             	mov    %rsp,%rbp
  805239:	48 83 ec 10          	sub    $0x10,%rsp
  80523d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	// LAB 8: Your code here.
	panic("ipc_recv not implemented in VM guest");
  805241:	48 ba 98 77 80 00 00 	movabs $0x807798,%rdx
  805248:	00 00 00 
  80524b:	be 47 00 00 00       	mov    $0x47,%esi
  805250:	48 bf 8b 77 80 00 00 	movabs $0x80778b,%rdi
  805257:	00 00 00 
  80525a:	b8 00 00 00 00       	mov    $0x0,%eax
  80525f:	48 b9 e4 34 80 00 00 	movabs $0x8034e4,%rcx
  805266:	00 00 00 
  805269:	ff d1                	callq  *%rcx

000000000080526b <ipc_host_send>:

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80526b:	55                   	push   %rbp
  80526c:	48 89 e5             	mov    %rsp,%rbp
  80526f:	48 83 ec 20          	sub    $0x20,%rsp
  805273:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805276:	89 75 f8             	mov    %esi,-0x8(%rbp)
  805279:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  80527d:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 8: Your code here.
	panic("ipc_send not implemented in VM guest");
  805280:	48 ba c0 77 80 00 00 	movabs $0x8077c0,%rdx
  805287:	00 00 00 
  80528a:	be 50 00 00 00       	mov    $0x50,%esi
  80528f:	48 bf 8b 77 80 00 00 	movabs $0x80778b,%rdi
  805296:	00 00 00 
  805299:	b8 00 00 00 00       	mov    $0x0,%eax
  80529e:	48 b9 e4 34 80 00 00 	movabs $0x8034e4,%rcx
  8052a5:	00 00 00 
  8052a8:	ff d1                	callq  *%rcx

00000000008052aa <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8052aa:	55                   	push   %rbp
  8052ab:	48 89 e5             	mov    %rsp,%rbp
  8052ae:	48 83 ec 14          	sub    $0x14,%rsp
  8052b2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8052b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8052bc:	eb 4e                	jmp    80530c <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  8052be:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8052c5:	00 00 00 
  8052c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8052cb:	48 98                	cltq   
  8052cd:	48 69 c0 70 01 00 00 	imul   $0x170,%rax,%rax
  8052d4:	48 01 d0             	add    %rdx,%rax
  8052d7:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8052dd:	8b 00                	mov    (%rax),%eax
  8052df:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8052e2:	75 24                	jne    805308 <ipc_find_env+0x5e>
			return envs[i].env_id;
  8052e4:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8052eb:	00 00 00 
  8052ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8052f1:	48 98                	cltq   
  8052f3:	48 69 c0 70 01 00 00 	imul   $0x170,%rax,%rax
  8052fa:	48 01 d0             	add    %rdx,%rax
  8052fd:	48 05 c0 00 00 00    	add    $0xc0,%rax
  805303:	8b 40 08             	mov    0x8(%rax),%eax
  805306:	eb 12                	jmp    80531a <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  805308:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80530c:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  805313:	7e a9                	jle    8052be <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;

	}
	return 0;
  805315:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80531a:	c9                   	leaveq 
  80531b:	c3                   	retq   

000000000080531c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80531c:	55                   	push   %rbp
  80531d:	48 89 e5             	mov    %rsp,%rbp
  805320:	48 83 ec 08          	sub    $0x8,%rsp
  805324:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  805328:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80532c:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  805333:	ff ff ff 
  805336:	48 01 d0             	add    %rdx,%rax
  805339:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80533d:	c9                   	leaveq 
  80533e:	c3                   	retq   

000000000080533f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80533f:	55                   	push   %rbp
  805340:	48 89 e5             	mov    %rsp,%rbp
  805343:	48 83 ec 08          	sub    $0x8,%rsp
  805347:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80534b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80534f:	48 89 c7             	mov    %rax,%rdi
  805352:	48 b8 1c 53 80 00 00 	movabs $0x80531c,%rax
  805359:	00 00 00 
  80535c:	ff d0                	callq  *%rax
  80535e:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  805364:	48 c1 e0 0c          	shl    $0xc,%rax
}
  805368:	c9                   	leaveq 
  805369:	c3                   	retq   

000000000080536a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80536a:	55                   	push   %rbp
  80536b:	48 89 e5             	mov    %rsp,%rbp
  80536e:	48 83 ec 18          	sub    $0x18,%rsp
  805372:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  805376:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80537d:	eb 6b                	jmp    8053ea <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80537f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805382:	48 98                	cltq   
  805384:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80538a:	48 c1 e0 0c          	shl    $0xc,%rax
  80538e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  805392:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805396:	48 c1 e8 15          	shr    $0x15,%rax
  80539a:	48 89 c2             	mov    %rax,%rdx
  80539d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8053a4:	01 00 00 
  8053a7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8053ab:	83 e0 01             	and    $0x1,%eax
  8053ae:	48 85 c0             	test   %rax,%rax
  8053b1:	74 21                	je     8053d4 <fd_alloc+0x6a>
  8053b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8053b7:	48 c1 e8 0c          	shr    $0xc,%rax
  8053bb:	48 89 c2             	mov    %rax,%rdx
  8053be:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8053c5:	01 00 00 
  8053c8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8053cc:	83 e0 01             	and    $0x1,%eax
  8053cf:	48 85 c0             	test   %rax,%rax
  8053d2:	75 12                	jne    8053e6 <fd_alloc+0x7c>
			*fd_store = fd;
  8053d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8053d8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8053dc:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8053df:	b8 00 00 00 00       	mov    $0x0,%eax
  8053e4:	eb 1a                	jmp    805400 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8053e6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8053ea:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8053ee:	7e 8f                	jle    80537f <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8053f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8053f4:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8053fb:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  805400:	c9                   	leaveq 
  805401:	c3                   	retq   

0000000000805402 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  805402:	55                   	push   %rbp
  805403:	48 89 e5             	mov    %rsp,%rbp
  805406:	48 83 ec 20          	sub    $0x20,%rsp
  80540a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80540d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  805411:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805415:	78 06                	js     80541d <fd_lookup+0x1b>
  805417:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80541b:	7e 07                	jle    805424 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80541d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  805422:	eb 6c                	jmp    805490 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  805424:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805427:	48 98                	cltq   
  805429:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80542f:	48 c1 e0 0c          	shl    $0xc,%rax
  805433:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  805437:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80543b:	48 c1 e8 15          	shr    $0x15,%rax
  80543f:	48 89 c2             	mov    %rax,%rdx
  805442:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  805449:	01 00 00 
  80544c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805450:	83 e0 01             	and    $0x1,%eax
  805453:	48 85 c0             	test   %rax,%rax
  805456:	74 21                	je     805479 <fd_lookup+0x77>
  805458:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80545c:	48 c1 e8 0c          	shr    $0xc,%rax
  805460:	48 89 c2             	mov    %rax,%rdx
  805463:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80546a:	01 00 00 
  80546d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805471:	83 e0 01             	and    $0x1,%eax
  805474:	48 85 c0             	test   %rax,%rax
  805477:	75 07                	jne    805480 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  805479:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80547e:	eb 10                	jmp    805490 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  805480:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805484:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  805488:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80548b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805490:	c9                   	leaveq 
  805491:	c3                   	retq   

0000000000805492 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  805492:	55                   	push   %rbp
  805493:	48 89 e5             	mov    %rsp,%rbp
  805496:	48 83 ec 30          	sub    $0x30,%rsp
  80549a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80549e:	89 f0                	mov    %esi,%eax
  8054a0:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8054a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8054a7:	48 89 c7             	mov    %rax,%rdi
  8054aa:	48 b8 1c 53 80 00 00 	movabs $0x80531c,%rax
  8054b1:	00 00 00 
  8054b4:	ff d0                	callq  *%rax
  8054b6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8054ba:	48 89 d6             	mov    %rdx,%rsi
  8054bd:	89 c7                	mov    %eax,%edi
  8054bf:	48 b8 02 54 80 00 00 	movabs $0x805402,%rax
  8054c6:	00 00 00 
  8054c9:	ff d0                	callq  *%rax
  8054cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8054ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8054d2:	78 0a                	js     8054de <fd_close+0x4c>
	    || fd != fd2)
  8054d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8054d8:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8054dc:	74 12                	je     8054f0 <fd_close+0x5e>
		return (must_exist ? r : 0);
  8054de:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8054e2:	74 05                	je     8054e9 <fd_close+0x57>
  8054e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8054e7:	eb 05                	jmp    8054ee <fd_close+0x5c>
  8054e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8054ee:	eb 69                	jmp    805559 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8054f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8054f4:	8b 00                	mov    (%rax),%eax
  8054f6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8054fa:	48 89 d6             	mov    %rdx,%rsi
  8054fd:	89 c7                	mov    %eax,%edi
  8054ff:	48 b8 5b 55 80 00 00 	movabs $0x80555b,%rax
  805506:	00 00 00 
  805509:	ff d0                	callq  *%rax
  80550b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80550e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805512:	78 2a                	js     80553e <fd_close+0xac>
		if (dev->dev_close)
  805514:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805518:	48 8b 40 20          	mov    0x20(%rax),%rax
  80551c:	48 85 c0             	test   %rax,%rax
  80551f:	74 16                	je     805537 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  805521:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805525:	48 8b 40 20          	mov    0x20(%rax),%rax
  805529:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80552d:	48 89 d7             	mov    %rdx,%rdi
  805530:	ff d0                	callq  *%rax
  805532:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805535:	eb 07                	jmp    80553e <fd_close+0xac>
		else
			r = 0;
  805537:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80553e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805542:	48 89 c6             	mov    %rax,%rsi
  805545:	bf 00 00 00 00       	mov    $0x0,%edi
  80554a:	48 b8 ed 4c 80 00 00 	movabs $0x804ced,%rax
  805551:	00 00 00 
  805554:	ff d0                	callq  *%rax
	return r;
  805556:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  805559:	c9                   	leaveq 
  80555a:	c3                   	retq   

000000000080555b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80555b:	55                   	push   %rbp
  80555c:	48 89 e5             	mov    %rsp,%rbp
  80555f:	48 83 ec 20          	sub    $0x20,%rsp
  805563:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805566:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80556a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  805571:	eb 41                	jmp    8055b4 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  805573:	48 b8 a0 10 81 00 00 	movabs $0x8110a0,%rax
  80557a:	00 00 00 
  80557d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805580:	48 63 d2             	movslq %edx,%rdx
  805583:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805587:	8b 00                	mov    (%rax),%eax
  805589:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80558c:	75 22                	jne    8055b0 <dev_lookup+0x55>
			*dev = devtab[i];
  80558e:	48 b8 a0 10 81 00 00 	movabs $0x8110a0,%rax
  805595:	00 00 00 
  805598:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80559b:	48 63 d2             	movslq %edx,%rdx
  80559e:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8055a2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8055a6:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8055a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8055ae:	eb 60                	jmp    805610 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8055b0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8055b4:	48 b8 a0 10 81 00 00 	movabs $0x8110a0,%rax
  8055bb:	00 00 00 
  8055be:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8055c1:	48 63 d2             	movslq %edx,%rdx
  8055c4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8055c8:	48 85 c0             	test   %rax,%rax
  8055cb:	75 a6                	jne    805573 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8055cd:	48 b8 20 40 81 00 00 	movabs $0x814020,%rax
  8055d4:	00 00 00 
  8055d7:	48 8b 00             	mov    (%rax),%rax
  8055da:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8055e0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8055e3:	89 c6                	mov    %eax,%esi
  8055e5:	48 bf e8 77 80 00 00 	movabs $0x8077e8,%rdi
  8055ec:	00 00 00 
  8055ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8055f4:	48 b9 1d 37 80 00 00 	movabs $0x80371d,%rcx
  8055fb:	00 00 00 
  8055fe:	ff d1                	callq  *%rcx
	*dev = 0;
  805600:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805604:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80560b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  805610:	c9                   	leaveq 
  805611:	c3                   	retq   

0000000000805612 <close>:

int
close(int fdnum)
{
  805612:	55                   	push   %rbp
  805613:	48 89 e5             	mov    %rsp,%rbp
  805616:	48 83 ec 20          	sub    $0x20,%rsp
  80561a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80561d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  805621:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805624:	48 89 d6             	mov    %rdx,%rsi
  805627:	89 c7                	mov    %eax,%edi
  805629:	48 b8 02 54 80 00 00 	movabs $0x805402,%rax
  805630:	00 00 00 
  805633:	ff d0                	callq  *%rax
  805635:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805638:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80563c:	79 05                	jns    805643 <close+0x31>
		return r;
  80563e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805641:	eb 18                	jmp    80565b <close+0x49>
	else
		return fd_close(fd, 1);
  805643:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805647:	be 01 00 00 00       	mov    $0x1,%esi
  80564c:	48 89 c7             	mov    %rax,%rdi
  80564f:	48 b8 92 54 80 00 00 	movabs $0x805492,%rax
  805656:	00 00 00 
  805659:	ff d0                	callq  *%rax
}
  80565b:	c9                   	leaveq 
  80565c:	c3                   	retq   

000000000080565d <close_all>:

void
close_all(void)
{
  80565d:	55                   	push   %rbp
  80565e:	48 89 e5             	mov    %rsp,%rbp
  805661:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  805665:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80566c:	eb 15                	jmp    805683 <close_all+0x26>
		close(i);
  80566e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805671:	89 c7                	mov    %eax,%edi
  805673:	48 b8 12 56 80 00 00 	movabs $0x805612,%rax
  80567a:	00 00 00 
  80567d:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80567f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  805683:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  805687:	7e e5                	jle    80566e <close_all+0x11>
		close(i);
}
  805689:	c9                   	leaveq 
  80568a:	c3                   	retq   

000000000080568b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80568b:	55                   	push   %rbp
  80568c:	48 89 e5             	mov    %rsp,%rbp
  80568f:	48 83 ec 40          	sub    $0x40,%rsp
  805693:	89 7d cc             	mov    %edi,-0x34(%rbp)
  805696:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  805699:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80569d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8056a0:	48 89 d6             	mov    %rdx,%rsi
  8056a3:	89 c7                	mov    %eax,%edi
  8056a5:	48 b8 02 54 80 00 00 	movabs $0x805402,%rax
  8056ac:	00 00 00 
  8056af:	ff d0                	callq  *%rax
  8056b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8056b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8056b8:	79 08                	jns    8056c2 <dup+0x37>
		return r;
  8056ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8056bd:	e9 70 01 00 00       	jmpq   805832 <dup+0x1a7>
	close(newfdnum);
  8056c2:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8056c5:	89 c7                	mov    %eax,%edi
  8056c7:	48 b8 12 56 80 00 00 	movabs $0x805612,%rax
  8056ce:	00 00 00 
  8056d1:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8056d3:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8056d6:	48 98                	cltq   
  8056d8:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8056de:	48 c1 e0 0c          	shl    $0xc,%rax
  8056e2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8056e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8056ea:	48 89 c7             	mov    %rax,%rdi
  8056ed:	48 b8 3f 53 80 00 00 	movabs $0x80533f,%rax
  8056f4:	00 00 00 
  8056f7:	ff d0                	callq  *%rax
  8056f9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8056fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805701:	48 89 c7             	mov    %rax,%rdi
  805704:	48 b8 3f 53 80 00 00 	movabs $0x80533f,%rax
  80570b:	00 00 00 
  80570e:	ff d0                	callq  *%rax
  805710:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  805714:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805718:	48 c1 e8 15          	shr    $0x15,%rax
  80571c:	48 89 c2             	mov    %rax,%rdx
  80571f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  805726:	01 00 00 
  805729:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80572d:	83 e0 01             	and    $0x1,%eax
  805730:	48 85 c0             	test   %rax,%rax
  805733:	74 73                	je     8057a8 <dup+0x11d>
  805735:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805739:	48 c1 e8 0c          	shr    $0xc,%rax
  80573d:	48 89 c2             	mov    %rax,%rdx
  805740:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805747:	01 00 00 
  80574a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80574e:	83 e0 01             	and    $0x1,%eax
  805751:	48 85 c0             	test   %rax,%rax
  805754:	74 52                	je     8057a8 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  805756:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80575a:	48 c1 e8 0c          	shr    $0xc,%rax
  80575e:	48 89 c2             	mov    %rax,%rdx
  805761:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805768:	01 00 00 
  80576b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80576f:	25 07 0e 00 00       	and    $0xe07,%eax
  805774:	89 c1                	mov    %eax,%ecx
  805776:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80577a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80577e:	41 89 c8             	mov    %ecx,%r8d
  805781:	48 89 d1             	mov    %rdx,%rcx
  805784:	ba 00 00 00 00       	mov    $0x0,%edx
  805789:	48 89 c6             	mov    %rax,%rsi
  80578c:	bf 00 00 00 00       	mov    $0x0,%edi
  805791:	48 b8 92 4c 80 00 00 	movabs $0x804c92,%rax
  805798:	00 00 00 
  80579b:	ff d0                	callq  *%rax
  80579d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8057a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8057a4:	79 02                	jns    8057a8 <dup+0x11d>
			goto err;
  8057a6:	eb 57                	jmp    8057ff <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8057a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8057ac:	48 c1 e8 0c          	shr    $0xc,%rax
  8057b0:	48 89 c2             	mov    %rax,%rdx
  8057b3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8057ba:	01 00 00 
  8057bd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8057c1:	25 07 0e 00 00       	and    $0xe07,%eax
  8057c6:	89 c1                	mov    %eax,%ecx
  8057c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8057cc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8057d0:	41 89 c8             	mov    %ecx,%r8d
  8057d3:	48 89 d1             	mov    %rdx,%rcx
  8057d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8057db:	48 89 c6             	mov    %rax,%rsi
  8057de:	bf 00 00 00 00       	mov    $0x0,%edi
  8057e3:	48 b8 92 4c 80 00 00 	movabs $0x804c92,%rax
  8057ea:	00 00 00 
  8057ed:	ff d0                	callq  *%rax
  8057ef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8057f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8057f6:	79 02                	jns    8057fa <dup+0x16f>
		goto err;
  8057f8:	eb 05                	jmp    8057ff <dup+0x174>

	return newfdnum;
  8057fa:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8057fd:	eb 33                	jmp    805832 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  8057ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805803:	48 89 c6             	mov    %rax,%rsi
  805806:	bf 00 00 00 00       	mov    $0x0,%edi
  80580b:	48 b8 ed 4c 80 00 00 	movabs $0x804ced,%rax
  805812:	00 00 00 
  805815:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  805817:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80581b:	48 89 c6             	mov    %rax,%rsi
  80581e:	bf 00 00 00 00       	mov    $0x0,%edi
  805823:	48 b8 ed 4c 80 00 00 	movabs $0x804ced,%rax
  80582a:	00 00 00 
  80582d:	ff d0                	callq  *%rax
	return r;
  80582f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  805832:	c9                   	leaveq 
  805833:	c3                   	retq   

0000000000805834 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  805834:	55                   	push   %rbp
  805835:	48 89 e5             	mov    %rsp,%rbp
  805838:	48 83 ec 40          	sub    $0x40,%rsp
  80583c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80583f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  805843:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  805847:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80584b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80584e:	48 89 d6             	mov    %rdx,%rsi
  805851:	89 c7                	mov    %eax,%edi
  805853:	48 b8 02 54 80 00 00 	movabs $0x805402,%rax
  80585a:	00 00 00 
  80585d:	ff d0                	callq  *%rax
  80585f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805862:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805866:	78 24                	js     80588c <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  805868:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80586c:	8b 00                	mov    (%rax),%eax
  80586e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  805872:	48 89 d6             	mov    %rdx,%rsi
  805875:	89 c7                	mov    %eax,%edi
  805877:	48 b8 5b 55 80 00 00 	movabs $0x80555b,%rax
  80587e:	00 00 00 
  805881:	ff d0                	callq  *%rax
  805883:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805886:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80588a:	79 05                	jns    805891 <read+0x5d>
		return r;
  80588c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80588f:	eb 76                	jmp    805907 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  805891:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805895:	8b 40 08             	mov    0x8(%rax),%eax
  805898:	83 e0 03             	and    $0x3,%eax
  80589b:	83 f8 01             	cmp    $0x1,%eax
  80589e:	75 3a                	jne    8058da <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8058a0:	48 b8 20 40 81 00 00 	movabs $0x814020,%rax
  8058a7:	00 00 00 
  8058aa:	48 8b 00             	mov    (%rax),%rax
  8058ad:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8058b3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8058b6:	89 c6                	mov    %eax,%esi
  8058b8:	48 bf 07 78 80 00 00 	movabs $0x807807,%rdi
  8058bf:	00 00 00 
  8058c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8058c7:	48 b9 1d 37 80 00 00 	movabs $0x80371d,%rcx
  8058ce:	00 00 00 
  8058d1:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8058d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8058d8:	eb 2d                	jmp    805907 <read+0xd3>
	}
	if (!dev->dev_read)
  8058da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8058de:	48 8b 40 10          	mov    0x10(%rax),%rax
  8058e2:	48 85 c0             	test   %rax,%rax
  8058e5:	75 07                	jne    8058ee <read+0xba>
		return -E_NOT_SUPP;
  8058e7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8058ec:	eb 19                	jmp    805907 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8058ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8058f2:	48 8b 40 10          	mov    0x10(%rax),%rax
  8058f6:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8058fa:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8058fe:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  805902:	48 89 cf             	mov    %rcx,%rdi
  805905:	ff d0                	callq  *%rax
}
  805907:	c9                   	leaveq 
  805908:	c3                   	retq   

0000000000805909 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  805909:	55                   	push   %rbp
  80590a:	48 89 e5             	mov    %rsp,%rbp
  80590d:	48 83 ec 30          	sub    $0x30,%rsp
  805911:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805914:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805918:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80591c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  805923:	eb 49                	jmp    80596e <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  805925:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805928:	48 98                	cltq   
  80592a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80592e:	48 29 c2             	sub    %rax,%rdx
  805931:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805934:	48 63 c8             	movslq %eax,%rcx
  805937:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80593b:	48 01 c1             	add    %rax,%rcx
  80593e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805941:	48 89 ce             	mov    %rcx,%rsi
  805944:	89 c7                	mov    %eax,%edi
  805946:	48 b8 34 58 80 00 00 	movabs $0x805834,%rax
  80594d:	00 00 00 
  805950:	ff d0                	callq  *%rax
  805952:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  805955:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  805959:	79 05                	jns    805960 <readn+0x57>
			return m;
  80595b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80595e:	eb 1c                	jmp    80597c <readn+0x73>
		if (m == 0)
  805960:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  805964:	75 02                	jne    805968 <readn+0x5f>
			break;
  805966:	eb 11                	jmp    805979 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  805968:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80596b:	01 45 fc             	add    %eax,-0x4(%rbp)
  80596e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805971:	48 98                	cltq   
  805973:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  805977:	72 ac                	jb     805925 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  805979:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80597c:	c9                   	leaveq 
  80597d:	c3                   	retq   

000000000080597e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80597e:	55                   	push   %rbp
  80597f:	48 89 e5             	mov    %rsp,%rbp
  805982:	48 83 ec 40          	sub    $0x40,%rsp
  805986:	89 7d dc             	mov    %edi,-0x24(%rbp)
  805989:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80598d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  805991:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  805995:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805998:	48 89 d6             	mov    %rdx,%rsi
  80599b:	89 c7                	mov    %eax,%edi
  80599d:	48 b8 02 54 80 00 00 	movabs $0x805402,%rax
  8059a4:	00 00 00 
  8059a7:	ff d0                	callq  *%rax
  8059a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8059ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8059b0:	78 24                	js     8059d6 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8059b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8059b6:	8b 00                	mov    (%rax),%eax
  8059b8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8059bc:	48 89 d6             	mov    %rdx,%rsi
  8059bf:	89 c7                	mov    %eax,%edi
  8059c1:	48 b8 5b 55 80 00 00 	movabs $0x80555b,%rax
  8059c8:	00 00 00 
  8059cb:	ff d0                	callq  *%rax
  8059cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8059d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8059d4:	79 05                	jns    8059db <write+0x5d>
		return r;
  8059d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8059d9:	eb 75                	jmp    805a50 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8059db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8059df:	8b 40 08             	mov    0x8(%rax),%eax
  8059e2:	83 e0 03             	and    $0x3,%eax
  8059e5:	85 c0                	test   %eax,%eax
  8059e7:	75 3a                	jne    805a23 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8059e9:	48 b8 20 40 81 00 00 	movabs $0x814020,%rax
  8059f0:	00 00 00 
  8059f3:	48 8b 00             	mov    (%rax),%rax
  8059f6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8059fc:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8059ff:	89 c6                	mov    %eax,%esi
  805a01:	48 bf 23 78 80 00 00 	movabs $0x807823,%rdi
  805a08:	00 00 00 
  805a0b:	b8 00 00 00 00       	mov    $0x0,%eax
  805a10:	48 b9 1d 37 80 00 00 	movabs $0x80371d,%rcx
  805a17:	00 00 00 
  805a1a:	ff d1                	callq  *%rcx
		return -E_INVAL;
  805a1c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  805a21:	eb 2d                	jmp    805a50 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  805a23:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805a27:	48 8b 40 18          	mov    0x18(%rax),%rax
  805a2b:	48 85 c0             	test   %rax,%rax
  805a2e:	75 07                	jne    805a37 <write+0xb9>
		return -E_NOT_SUPP;
  805a30:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  805a35:	eb 19                	jmp    805a50 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  805a37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805a3b:	48 8b 40 18          	mov    0x18(%rax),%rax
  805a3f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  805a43:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  805a47:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  805a4b:	48 89 cf             	mov    %rcx,%rdi
  805a4e:	ff d0                	callq  *%rax
}
  805a50:	c9                   	leaveq 
  805a51:	c3                   	retq   

0000000000805a52 <seek>:

int
seek(int fdnum, off_t offset)
{
  805a52:	55                   	push   %rbp
  805a53:	48 89 e5             	mov    %rsp,%rbp
  805a56:	48 83 ec 18          	sub    $0x18,%rsp
  805a5a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805a5d:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  805a60:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  805a64:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805a67:	48 89 d6             	mov    %rdx,%rsi
  805a6a:	89 c7                	mov    %eax,%edi
  805a6c:	48 b8 02 54 80 00 00 	movabs $0x805402,%rax
  805a73:	00 00 00 
  805a76:	ff d0                	callq  *%rax
  805a78:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805a7b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805a7f:	79 05                	jns    805a86 <seek+0x34>
		return r;
  805a81:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805a84:	eb 0f                	jmp    805a95 <seek+0x43>
	fd->fd_offset = offset;
  805a86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805a8a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  805a8d:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  805a90:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805a95:	c9                   	leaveq 
  805a96:	c3                   	retq   

0000000000805a97 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  805a97:	55                   	push   %rbp
  805a98:	48 89 e5             	mov    %rsp,%rbp
  805a9b:	48 83 ec 30          	sub    $0x30,%rsp
  805a9f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  805aa2:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  805aa5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  805aa9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805aac:	48 89 d6             	mov    %rdx,%rsi
  805aaf:	89 c7                	mov    %eax,%edi
  805ab1:	48 b8 02 54 80 00 00 	movabs $0x805402,%rax
  805ab8:	00 00 00 
  805abb:	ff d0                	callq  *%rax
  805abd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805ac0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805ac4:	78 24                	js     805aea <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  805ac6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805aca:	8b 00                	mov    (%rax),%eax
  805acc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  805ad0:	48 89 d6             	mov    %rdx,%rsi
  805ad3:	89 c7                	mov    %eax,%edi
  805ad5:	48 b8 5b 55 80 00 00 	movabs $0x80555b,%rax
  805adc:	00 00 00 
  805adf:	ff d0                	callq  *%rax
  805ae1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805ae4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805ae8:	79 05                	jns    805aef <ftruncate+0x58>
		return r;
  805aea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805aed:	eb 72                	jmp    805b61 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  805aef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805af3:	8b 40 08             	mov    0x8(%rax),%eax
  805af6:	83 e0 03             	and    $0x3,%eax
  805af9:	85 c0                	test   %eax,%eax
  805afb:	75 3a                	jne    805b37 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  805afd:	48 b8 20 40 81 00 00 	movabs $0x814020,%rax
  805b04:	00 00 00 
  805b07:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  805b0a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  805b10:	8b 55 dc             	mov    -0x24(%rbp),%edx
  805b13:	89 c6                	mov    %eax,%esi
  805b15:	48 bf 40 78 80 00 00 	movabs $0x807840,%rdi
  805b1c:	00 00 00 
  805b1f:	b8 00 00 00 00       	mov    $0x0,%eax
  805b24:	48 b9 1d 37 80 00 00 	movabs $0x80371d,%rcx
  805b2b:	00 00 00 
  805b2e:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  805b30:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  805b35:	eb 2a                	jmp    805b61 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  805b37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805b3b:	48 8b 40 30          	mov    0x30(%rax),%rax
  805b3f:	48 85 c0             	test   %rax,%rax
  805b42:	75 07                	jne    805b4b <ftruncate+0xb4>
		return -E_NOT_SUPP;
  805b44:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  805b49:	eb 16                	jmp    805b61 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  805b4b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805b4f:	48 8b 40 30          	mov    0x30(%rax),%rax
  805b53:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  805b57:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  805b5a:	89 ce                	mov    %ecx,%esi
  805b5c:	48 89 d7             	mov    %rdx,%rdi
  805b5f:	ff d0                	callq  *%rax
}
  805b61:	c9                   	leaveq 
  805b62:	c3                   	retq   

0000000000805b63 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  805b63:	55                   	push   %rbp
  805b64:	48 89 e5             	mov    %rsp,%rbp
  805b67:	48 83 ec 30          	sub    $0x30,%rsp
  805b6b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  805b6e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  805b72:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  805b76:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805b79:	48 89 d6             	mov    %rdx,%rsi
  805b7c:	89 c7                	mov    %eax,%edi
  805b7e:	48 b8 02 54 80 00 00 	movabs $0x805402,%rax
  805b85:	00 00 00 
  805b88:	ff d0                	callq  *%rax
  805b8a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805b8d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805b91:	78 24                	js     805bb7 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  805b93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805b97:	8b 00                	mov    (%rax),%eax
  805b99:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  805b9d:	48 89 d6             	mov    %rdx,%rsi
  805ba0:	89 c7                	mov    %eax,%edi
  805ba2:	48 b8 5b 55 80 00 00 	movabs $0x80555b,%rax
  805ba9:	00 00 00 
  805bac:	ff d0                	callq  *%rax
  805bae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805bb1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805bb5:	79 05                	jns    805bbc <fstat+0x59>
		return r;
  805bb7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805bba:	eb 5e                	jmp    805c1a <fstat+0xb7>
	if (!dev->dev_stat)
  805bbc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805bc0:	48 8b 40 28          	mov    0x28(%rax),%rax
  805bc4:	48 85 c0             	test   %rax,%rax
  805bc7:	75 07                	jne    805bd0 <fstat+0x6d>
		return -E_NOT_SUPP;
  805bc9:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  805bce:	eb 4a                	jmp    805c1a <fstat+0xb7>
	stat->st_name[0] = 0;
  805bd0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805bd4:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  805bd7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805bdb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  805be2:	00 00 00 
	stat->st_isdir = 0;
  805be5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805be9:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  805bf0:	00 00 00 
	stat->st_dev = dev;
  805bf3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805bf7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805bfb:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  805c02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805c06:	48 8b 40 28          	mov    0x28(%rax),%rax
  805c0a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  805c0e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  805c12:	48 89 ce             	mov    %rcx,%rsi
  805c15:	48 89 d7             	mov    %rdx,%rdi
  805c18:	ff d0                	callq  *%rax
}
  805c1a:	c9                   	leaveq 
  805c1b:	c3                   	retq   

0000000000805c1c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  805c1c:	55                   	push   %rbp
  805c1d:	48 89 e5             	mov    %rsp,%rbp
  805c20:	48 83 ec 20          	sub    $0x20,%rsp
  805c24:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805c28:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  805c2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805c30:	be 00 00 00 00       	mov    $0x0,%esi
  805c35:	48 89 c7             	mov    %rax,%rdi
  805c38:	48 b8 0a 5d 80 00 00 	movabs $0x805d0a,%rax
  805c3f:	00 00 00 
  805c42:	ff d0                	callq  *%rax
  805c44:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805c47:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805c4b:	79 05                	jns    805c52 <stat+0x36>
		return fd;
  805c4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805c50:	eb 2f                	jmp    805c81 <stat+0x65>
	r = fstat(fd, stat);
  805c52:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  805c56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805c59:	48 89 d6             	mov    %rdx,%rsi
  805c5c:	89 c7                	mov    %eax,%edi
  805c5e:	48 b8 63 5b 80 00 00 	movabs $0x805b63,%rax
  805c65:	00 00 00 
  805c68:	ff d0                	callq  *%rax
  805c6a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  805c6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805c70:	89 c7                	mov    %eax,%edi
  805c72:	48 b8 12 56 80 00 00 	movabs $0x805612,%rax
  805c79:	00 00 00 
  805c7c:	ff d0                	callq  *%rax
	return r;
  805c7e:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  805c81:	c9                   	leaveq 
  805c82:	c3                   	retq   

0000000000805c83 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  805c83:	55                   	push   %rbp
  805c84:	48 89 e5             	mov    %rsp,%rbp
  805c87:	48 83 ec 10          	sub    $0x10,%rsp
  805c8b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805c8e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  805c92:	48 b8 08 40 81 00 00 	movabs $0x814008,%rax
  805c99:	00 00 00 
  805c9c:	8b 00                	mov    (%rax),%eax
  805c9e:	85 c0                	test   %eax,%eax
  805ca0:	75 1d                	jne    805cbf <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  805ca2:	bf 01 00 00 00       	mov    $0x1,%edi
  805ca7:	48 b8 aa 52 80 00 00 	movabs $0x8052aa,%rax
  805cae:	00 00 00 
  805cb1:	ff d0                	callq  *%rax
  805cb3:	48 ba 08 40 81 00 00 	movabs $0x814008,%rdx
  805cba:	00 00 00 
  805cbd:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  805cbf:	48 b8 08 40 81 00 00 	movabs $0x814008,%rax
  805cc6:	00 00 00 
  805cc9:	8b 00                	mov    (%rax),%eax
  805ccb:	8b 75 fc             	mov    -0x4(%rbp),%esi
  805cce:	b9 07 00 00 00       	mov    $0x7,%ecx
  805cd3:	48 ba 00 50 81 00 00 	movabs $0x815000,%rdx
  805cda:	00 00 00 
  805cdd:	89 c7                	mov    %eax,%edi
  805cdf:	48 b8 ab 51 80 00 00 	movabs $0x8051ab,%rax
  805ce6:	00 00 00 
  805ce9:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  805ceb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805cef:	ba 00 00 00 00       	mov    $0x0,%edx
  805cf4:	48 89 c6             	mov    %rax,%rsi
  805cf7:	bf 00 00 00 00       	mov    $0x0,%edi
  805cfc:	48 b8 f8 50 80 00 00 	movabs $0x8050f8,%rax
  805d03:	00 00 00 
  805d06:	ff d0                	callq  *%rax
}
  805d08:	c9                   	leaveq 
  805d09:	c3                   	retq   

0000000000805d0a <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  805d0a:	55                   	push   %rbp
  805d0b:	48 89 e5             	mov    %rsp,%rbp
  805d0e:	48 83 ec 20          	sub    $0x20,%rsp
  805d12:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805d16:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here

	struct Fd *fd;
	int ret;
	if (strlen(path)>=MAXPATHLEN)
  805d19:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805d1d:	48 89 c7             	mov    %rax,%rdi
  805d20:	48 b8 a7 42 80 00 00 	movabs $0x8042a7,%rax
  805d27:	00 00 00 
  805d2a:	ff d0                	callq  *%rax
  805d2c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  805d31:	7e 0a                	jle    805d3d <open+0x33>
		return -E_BAD_PATH;
  805d33:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  805d38:	e9 a5 00 00 00       	jmpq   805de2 <open+0xd8>
	if ((ret=fd_alloc(&fd))<0)
  805d3d:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  805d41:	48 89 c7             	mov    %rax,%rdi
  805d44:	48 b8 6a 53 80 00 00 	movabs $0x80536a,%rax
  805d4b:	00 00 00 
  805d4e:	ff d0                	callq  *%rax
  805d50:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805d53:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805d57:	79 08                	jns    805d61 <open+0x57>
		return ret;
  805d59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805d5c:	e9 81 00 00 00       	jmpq   805de2 <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  805d61:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  805d68:	00 00 00 
  805d6b:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  805d6e:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy (fsipcbuf.open.req_path, path);
  805d74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805d78:	48 89 c6             	mov    %rax,%rsi
  805d7b:	48 bf 00 50 81 00 00 	movabs $0x815000,%rdi
  805d82:	00 00 00 
  805d85:	48 b8 13 43 80 00 00 	movabs $0x804313,%rax
  805d8c:	00 00 00 
  805d8f:	ff d0                	callq  *%rax
	if ((ret=fsipc (FSREQ_OPEN, (void *) fd)) < 0)
  805d91:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805d95:	48 89 c6             	mov    %rax,%rsi
  805d98:	bf 01 00 00 00       	mov    $0x1,%edi
  805d9d:	48 b8 83 5c 80 00 00 	movabs $0x805c83,%rax
  805da4:	00 00 00 
  805da7:	ff d0                	callq  *%rax
  805da9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805dac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805db0:	79 1d                	jns    805dcf <open+0xc5>
	{
		fd_close(fd,0);
  805db2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805db6:	be 00 00 00 00       	mov    $0x0,%esi
  805dbb:	48 89 c7             	mov    %rax,%rdi
  805dbe:	48 b8 92 54 80 00 00 	movabs $0x805492,%rax
  805dc5:	00 00 00 
  805dc8:	ff d0                	callq  *%rax
		return ret;
  805dca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805dcd:	eb 13                	jmp    805de2 <open+0xd8>
	}
	return fd2num (fd);
  805dcf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805dd3:	48 89 c7             	mov    %rax,%rdi
  805dd6:	48 b8 1c 53 80 00 00 	movabs $0x80531c,%rax
  805ddd:	00 00 00 
  805de0:	ff d0                	callq  *%rax
	panic ("open not implemented");
}
  805de2:	c9                   	leaveq 
  805de3:	c3                   	retq   

0000000000805de4 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  805de4:	55                   	push   %rbp
  805de5:	48 89 e5             	mov    %rsp,%rbp
  805de8:	48 83 ec 10          	sub    $0x10,%rsp
  805dec:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  805df0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805df4:	8b 50 0c             	mov    0xc(%rax),%edx
  805df7:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  805dfe:	00 00 00 
  805e01:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  805e03:	be 00 00 00 00       	mov    $0x0,%esi
  805e08:	bf 06 00 00 00       	mov    $0x6,%edi
  805e0d:	48 b8 83 5c 80 00 00 	movabs $0x805c83,%rax
  805e14:	00 00 00 
  805e17:	ff d0                	callq  *%rax
}
  805e19:	c9                   	leaveq 
  805e1a:	c3                   	retq   

0000000000805e1b <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  805e1b:	55                   	push   %rbp
  805e1c:	48 89 e5             	mov    %rsp,%rbp
  805e1f:	48 83 ec 30          	sub    $0x30,%rsp
  805e23:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805e27:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805e2b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int ret;
	fsipcbuf.read.req_fileid=fd->fd_file.id;
  805e2f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805e33:	8b 50 0c             	mov    0xc(%rax),%edx
  805e36:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  805e3d:	00 00 00 
  805e40:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n=n;
  805e42:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  805e49:	00 00 00 
  805e4c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  805e50:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	if ((ret=fsipc(FSREQ_READ,NULL))<0)
  805e54:	be 00 00 00 00       	mov    $0x0,%esi
  805e59:	bf 03 00 00 00       	mov    $0x3,%edi
  805e5e:	48 b8 83 5c 80 00 00 	movabs $0x805c83,%rax
  805e65:	00 00 00 
  805e68:	ff d0                	callq  *%rax
  805e6a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805e6d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805e71:	79 05                	jns    805e78 <devfile_read+0x5d>
		return ret;
  805e73:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805e76:	eb 26                	jmp    805e9e <devfile_read+0x83>
	memmove (buf, fsipcbuf.readRet.ret_buf, ret);
  805e78:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805e7b:	48 63 d0             	movslq %eax,%rdx
  805e7e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805e82:	48 be 00 50 81 00 00 	movabs $0x815000,%rsi
  805e89:	00 00 00 
  805e8c:	48 89 c7             	mov    %rax,%rdi
  805e8f:	48 b8 37 46 80 00 00 	movabs $0x804637,%rax
  805e96:	00 00 00 
  805e99:	ff d0                	callq  *%rax
	return ret;
  805e9b:	8b 45 fc             	mov    -0x4(%rbp),%eax
	panic("devfile_read not implemented");
}
  805e9e:	c9                   	leaveq 
  805e9f:	c3                   	retq   

0000000000805ea0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  805ea0:	55                   	push   %rbp
  805ea1:	48 89 e5             	mov    %rsp,%rbp
  805ea4:	48 83 ec 30          	sub    $0x30,%rsp
  805ea8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805eac:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805eb0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here

	int ret;
	fsipcbuf.write.req_fileid=fd->fd_file.id;
  805eb4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805eb8:	8b 50 0c             	mov    0xc(%rax),%edx
  805ebb:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  805ec2:	00 00 00 
  805ec5:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n=n>sizeof(fsipcbuf.write.req_buf)?sizeof(fsipcbuf.write.req_buf):n;
  805ec7:	b8 f4 0f 00 00       	mov    $0xff4,%eax
  805ecc:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  805ed3:	00 
  805ed4:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  805ed9:	48 89 c2             	mov    %rax,%rdx
  805edc:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  805ee3:	00 00 00 
  805ee6:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove (fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  805eea:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  805ef1:	00 00 00 
  805ef4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  805ef8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805efc:	48 89 c6             	mov    %rax,%rsi
  805eff:	48 bf 10 50 81 00 00 	movabs $0x815010,%rdi
  805f06:	00 00 00 
  805f09:	48 b8 37 46 80 00 00 	movabs $0x804637,%rax
  805f10:	00 00 00 
  805f13:	ff d0                	callq  *%rax
	if ((ret=fsipc(FSREQ_WRITE,NULL))<0)
  805f15:	be 00 00 00 00       	mov    $0x0,%esi
  805f1a:	bf 04 00 00 00       	mov    $0x4,%edi
  805f1f:	48 b8 83 5c 80 00 00 	movabs $0x805c83,%rax
  805f26:	00 00 00 
  805f29:	ff d0                	callq  *%rax
  805f2b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805f2e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805f32:	79 05                	jns    805f39 <devfile_write+0x99>
		return ret;
  805f34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805f37:	eb 03                	jmp    805f3c <devfile_write+0x9c>
	
	return ret;
  805f39:	8b 45 fc             	mov    -0x4(%rbp),%eax


	panic("devfile_write not implemented");
}
  805f3c:	c9                   	leaveq 
  805f3d:	c3                   	retq   

0000000000805f3e <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  805f3e:	55                   	push   %rbp
  805f3f:	48 89 e5             	mov    %rsp,%rbp
  805f42:	48 83 ec 20          	sub    $0x20,%rsp
  805f46:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805f4a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  805f4e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805f52:	8b 50 0c             	mov    0xc(%rax),%edx
  805f55:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  805f5c:	00 00 00 
  805f5f:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  805f61:	be 00 00 00 00       	mov    $0x0,%esi
  805f66:	bf 05 00 00 00       	mov    $0x5,%edi
  805f6b:	48 b8 83 5c 80 00 00 	movabs $0x805c83,%rax
  805f72:	00 00 00 
  805f75:	ff d0                	callq  *%rax
  805f77:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805f7a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805f7e:	79 05                	jns    805f85 <devfile_stat+0x47>
		return r;
  805f80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805f83:	eb 56                	jmp    805fdb <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  805f85:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805f89:	48 be 00 50 81 00 00 	movabs $0x815000,%rsi
  805f90:	00 00 00 
  805f93:	48 89 c7             	mov    %rax,%rdi
  805f96:	48 b8 13 43 80 00 00 	movabs $0x804313,%rax
  805f9d:	00 00 00 
  805fa0:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  805fa2:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  805fa9:	00 00 00 
  805fac:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  805fb2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805fb6:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  805fbc:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  805fc3:	00 00 00 
  805fc6:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  805fcc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805fd0:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  805fd6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805fdb:	c9                   	leaveq 
  805fdc:	c3                   	retq   

0000000000805fdd <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  805fdd:	55                   	push   %rbp
  805fde:	48 89 e5             	mov    %rsp,%rbp
  805fe1:	48 83 ec 10          	sub    $0x10,%rsp
  805fe5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  805fe9:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  805fec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805ff0:	8b 50 0c             	mov    0xc(%rax),%edx
  805ff3:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  805ffa:	00 00 00 
  805ffd:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  805fff:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  806006:	00 00 00 
  806009:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80600c:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80600f:	be 00 00 00 00       	mov    $0x0,%esi
  806014:	bf 02 00 00 00       	mov    $0x2,%edi
  806019:	48 b8 83 5c 80 00 00 	movabs $0x805c83,%rax
  806020:	00 00 00 
  806023:	ff d0                	callq  *%rax
}
  806025:	c9                   	leaveq 
  806026:	c3                   	retq   

0000000000806027 <remove>:

// Delete a file
int
remove(const char *path)
{
  806027:	55                   	push   %rbp
  806028:	48 89 e5             	mov    %rsp,%rbp
  80602b:	48 83 ec 10          	sub    $0x10,%rsp
  80602f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  806033:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806037:	48 89 c7             	mov    %rax,%rdi
  80603a:	48 b8 a7 42 80 00 00 	movabs $0x8042a7,%rax
  806041:	00 00 00 
  806044:	ff d0                	callq  *%rax
  806046:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80604b:	7e 07                	jle    806054 <remove+0x2d>
		return -E_BAD_PATH;
  80604d:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  806052:	eb 33                	jmp    806087 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  806054:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806058:	48 89 c6             	mov    %rax,%rsi
  80605b:	48 bf 00 50 81 00 00 	movabs $0x815000,%rdi
  806062:	00 00 00 
  806065:	48 b8 13 43 80 00 00 	movabs $0x804313,%rax
  80606c:	00 00 00 
  80606f:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  806071:	be 00 00 00 00       	mov    $0x0,%esi
  806076:	bf 07 00 00 00       	mov    $0x7,%edi
  80607b:	48 b8 83 5c 80 00 00 	movabs $0x805c83,%rax
  806082:	00 00 00 
  806085:	ff d0                	callq  *%rax
}
  806087:	c9                   	leaveq 
  806088:	c3                   	retq   

0000000000806089 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  806089:	55                   	push   %rbp
  80608a:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80608d:	be 00 00 00 00       	mov    $0x0,%esi
  806092:	bf 08 00 00 00       	mov    $0x8,%edi
  806097:	48 b8 83 5c 80 00 00 	movabs $0x805c83,%rax
  80609e:	00 00 00 
  8060a1:	ff d0                	callq  *%rax
}
  8060a3:	5d                   	pop    %rbp
  8060a4:	c3                   	retq   

00000000008060a5 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8060a5:	55                   	push   %rbp
  8060a6:	48 89 e5             	mov    %rsp,%rbp
  8060a9:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8060b0:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8060b7:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8060be:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8060c5:	be 00 00 00 00       	mov    $0x0,%esi
  8060ca:	48 89 c7             	mov    %rax,%rdi
  8060cd:	48 b8 0a 5d 80 00 00 	movabs $0x805d0a,%rax
  8060d4:	00 00 00 
  8060d7:	ff d0                	callq  *%rax
  8060d9:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8060dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8060e0:	79 28                	jns    80610a <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8060e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8060e5:	89 c6                	mov    %eax,%esi
  8060e7:	48 bf 66 78 80 00 00 	movabs $0x807866,%rdi
  8060ee:	00 00 00 
  8060f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8060f6:	48 ba 1d 37 80 00 00 	movabs $0x80371d,%rdx
  8060fd:	00 00 00 
  806100:	ff d2                	callq  *%rdx
		return fd_src;
  806102:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806105:	e9 74 01 00 00       	jmpq   80627e <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80610a:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  806111:	be 01 01 00 00       	mov    $0x101,%esi
  806116:	48 89 c7             	mov    %rax,%rdi
  806119:	48 b8 0a 5d 80 00 00 	movabs $0x805d0a,%rax
  806120:	00 00 00 
  806123:	ff d0                	callq  *%rax
  806125:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  806128:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80612c:	79 39                	jns    806167 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  80612e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  806131:	89 c6                	mov    %eax,%esi
  806133:	48 bf 7c 78 80 00 00 	movabs $0x80787c,%rdi
  80613a:	00 00 00 
  80613d:	b8 00 00 00 00       	mov    $0x0,%eax
  806142:	48 ba 1d 37 80 00 00 	movabs $0x80371d,%rdx
  806149:	00 00 00 
  80614c:	ff d2                	callq  *%rdx
		close(fd_src);
  80614e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806151:	89 c7                	mov    %eax,%edi
  806153:	48 b8 12 56 80 00 00 	movabs $0x805612,%rax
  80615a:	00 00 00 
  80615d:	ff d0                	callq  *%rax
		return fd_dest;
  80615f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  806162:	e9 17 01 00 00       	jmpq   80627e <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  806167:	eb 74                	jmp    8061dd <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  806169:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80616c:	48 63 d0             	movslq %eax,%rdx
  80616f:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  806176:	8b 45 f8             	mov    -0x8(%rbp),%eax
  806179:	48 89 ce             	mov    %rcx,%rsi
  80617c:	89 c7                	mov    %eax,%edi
  80617e:	48 b8 7e 59 80 00 00 	movabs $0x80597e,%rax
  806185:	00 00 00 
  806188:	ff d0                	callq  *%rax
  80618a:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  80618d:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  806191:	79 4a                	jns    8061dd <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  806193:	8b 45 f0             	mov    -0x10(%rbp),%eax
  806196:	89 c6                	mov    %eax,%esi
  806198:	48 bf 96 78 80 00 00 	movabs $0x807896,%rdi
  80619f:	00 00 00 
  8061a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8061a7:	48 ba 1d 37 80 00 00 	movabs $0x80371d,%rdx
  8061ae:	00 00 00 
  8061b1:	ff d2                	callq  *%rdx
			close(fd_src);
  8061b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8061b6:	89 c7                	mov    %eax,%edi
  8061b8:	48 b8 12 56 80 00 00 	movabs $0x805612,%rax
  8061bf:	00 00 00 
  8061c2:	ff d0                	callq  *%rax
			close(fd_dest);
  8061c4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8061c7:	89 c7                	mov    %eax,%edi
  8061c9:	48 b8 12 56 80 00 00 	movabs $0x805612,%rax
  8061d0:	00 00 00 
  8061d3:	ff d0                	callq  *%rax
			return write_size;
  8061d5:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8061d8:	e9 a1 00 00 00       	jmpq   80627e <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8061dd:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8061e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8061e7:	ba 00 02 00 00       	mov    $0x200,%edx
  8061ec:	48 89 ce             	mov    %rcx,%rsi
  8061ef:	89 c7                	mov    %eax,%edi
  8061f1:	48 b8 34 58 80 00 00 	movabs $0x805834,%rax
  8061f8:	00 00 00 
  8061fb:	ff d0                	callq  *%rax
  8061fd:	89 45 f4             	mov    %eax,-0xc(%rbp)
  806200:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  806204:	0f 8f 5f ff ff ff    	jg     806169 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  80620a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80620e:	79 47                	jns    806257 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  806210:	8b 45 f4             	mov    -0xc(%rbp),%eax
  806213:	89 c6                	mov    %eax,%esi
  806215:	48 bf a9 78 80 00 00 	movabs $0x8078a9,%rdi
  80621c:	00 00 00 
  80621f:	b8 00 00 00 00       	mov    $0x0,%eax
  806224:	48 ba 1d 37 80 00 00 	movabs $0x80371d,%rdx
  80622b:	00 00 00 
  80622e:	ff d2                	callq  *%rdx
		close(fd_src);
  806230:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806233:	89 c7                	mov    %eax,%edi
  806235:	48 b8 12 56 80 00 00 	movabs $0x805612,%rax
  80623c:	00 00 00 
  80623f:	ff d0                	callq  *%rax
		close(fd_dest);
  806241:	8b 45 f8             	mov    -0x8(%rbp),%eax
  806244:	89 c7                	mov    %eax,%edi
  806246:	48 b8 12 56 80 00 00 	movabs $0x805612,%rax
  80624d:	00 00 00 
  806250:	ff d0                	callq  *%rax
		return read_size;
  806252:	8b 45 f4             	mov    -0xc(%rbp),%eax
  806255:	eb 27                	jmp    80627e <copy+0x1d9>
	}
	close(fd_src);
  806257:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80625a:	89 c7                	mov    %eax,%edi
  80625c:	48 b8 12 56 80 00 00 	movabs $0x805612,%rax
  806263:	00 00 00 
  806266:	ff d0                	callq  *%rax
	close(fd_dest);
  806268:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80626b:	89 c7                	mov    %eax,%edi
  80626d:	48 b8 12 56 80 00 00 	movabs $0x805612,%rax
  806274:	00 00 00 
  806277:	ff d0                	callq  *%rax
	return 0;
  806279:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  80627e:	c9                   	leaveq 
  80627f:	c3                   	retq   

0000000000806280 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  806280:	55                   	push   %rbp
  806281:	48 89 e5             	mov    %rsp,%rbp
  806284:	48 83 ec 18          	sub    $0x18,%rsp
  806288:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80628c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806290:	48 c1 e8 15          	shr    $0x15,%rax
  806294:	48 89 c2             	mov    %rax,%rdx
  806297:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80629e:	01 00 00 
  8062a1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8062a5:	83 e0 01             	and    $0x1,%eax
  8062a8:	48 85 c0             	test   %rax,%rax
  8062ab:	75 07                	jne    8062b4 <pageref+0x34>
		return 0;
  8062ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8062b2:	eb 53                	jmp    806307 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  8062b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8062b8:	48 c1 e8 0c          	shr    $0xc,%rax
  8062bc:	48 89 c2             	mov    %rax,%rdx
  8062bf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8062c6:	01 00 00 
  8062c9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8062cd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8062d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8062d5:	83 e0 01             	and    $0x1,%eax
  8062d8:	48 85 c0             	test   %rax,%rax
  8062db:	75 07                	jne    8062e4 <pageref+0x64>
		return 0;
  8062dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8062e2:	eb 23                	jmp    806307 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  8062e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8062e8:	48 c1 e8 0c          	shr    $0xc,%rax
  8062ec:	48 89 c2             	mov    %rax,%rdx
  8062ef:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8062f6:	00 00 00 
  8062f9:	48 c1 e2 04          	shl    $0x4,%rdx
  8062fd:	48 01 d0             	add    %rdx,%rax
  806300:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  806304:	0f b7 c0             	movzwl %ax,%eax
}
  806307:	c9                   	leaveq 
  806308:	c3                   	retq   

0000000000806309 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  806309:	55                   	push   %rbp
  80630a:	48 89 e5             	mov    %rsp,%rbp
  80630d:	53                   	push   %rbx
  80630e:	48 83 ec 38          	sub    $0x38,%rsp
  806312:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  806316:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80631a:	48 89 c7             	mov    %rax,%rdi
  80631d:	48 b8 6a 53 80 00 00 	movabs $0x80536a,%rax
  806324:	00 00 00 
  806327:	ff d0                	callq  *%rax
  806329:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80632c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  806330:	0f 88 bf 01 00 00    	js     8064f5 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  806336:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80633a:	ba 07 04 00 00       	mov    $0x407,%edx
  80633f:	48 89 c6             	mov    %rax,%rsi
  806342:	bf 00 00 00 00       	mov    $0x0,%edi
  806347:	48 b8 42 4c 80 00 00 	movabs $0x804c42,%rax
  80634e:	00 00 00 
  806351:	ff d0                	callq  *%rax
  806353:	89 45 ec             	mov    %eax,-0x14(%rbp)
  806356:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80635a:	0f 88 95 01 00 00    	js     8064f5 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  806360:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  806364:	48 89 c7             	mov    %rax,%rdi
  806367:	48 b8 6a 53 80 00 00 	movabs $0x80536a,%rax
  80636e:	00 00 00 
  806371:	ff d0                	callq  *%rax
  806373:	89 45 ec             	mov    %eax,-0x14(%rbp)
  806376:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80637a:	0f 88 5d 01 00 00    	js     8064dd <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  806380:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806384:	ba 07 04 00 00       	mov    $0x407,%edx
  806389:	48 89 c6             	mov    %rax,%rsi
  80638c:	bf 00 00 00 00       	mov    $0x0,%edi
  806391:	48 b8 42 4c 80 00 00 	movabs $0x804c42,%rax
  806398:	00 00 00 
  80639b:	ff d0                	callq  *%rax
  80639d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8063a0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8063a4:	0f 88 33 01 00 00    	js     8064dd <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8063aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8063ae:	48 89 c7             	mov    %rax,%rdi
  8063b1:	48 b8 3f 53 80 00 00 	movabs $0x80533f,%rax
  8063b8:	00 00 00 
  8063bb:	ff d0                	callq  *%rax
  8063bd:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8063c1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8063c5:	ba 07 04 00 00       	mov    $0x407,%edx
  8063ca:	48 89 c6             	mov    %rax,%rsi
  8063cd:	bf 00 00 00 00       	mov    $0x0,%edi
  8063d2:	48 b8 42 4c 80 00 00 	movabs $0x804c42,%rax
  8063d9:	00 00 00 
  8063dc:	ff d0                	callq  *%rax
  8063de:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8063e1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8063e5:	79 05                	jns    8063ec <pipe+0xe3>
		goto err2;
  8063e7:	e9 d9 00 00 00       	jmpq   8064c5 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8063ec:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8063f0:	48 89 c7             	mov    %rax,%rdi
  8063f3:	48 b8 3f 53 80 00 00 	movabs $0x80533f,%rax
  8063fa:	00 00 00 
  8063fd:	ff d0                	callq  *%rax
  8063ff:	48 89 c2             	mov    %rax,%rdx
  806402:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806406:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80640c:	48 89 d1             	mov    %rdx,%rcx
  80640f:	ba 00 00 00 00       	mov    $0x0,%edx
  806414:	48 89 c6             	mov    %rax,%rsi
  806417:	bf 00 00 00 00       	mov    $0x0,%edi
  80641c:	48 b8 92 4c 80 00 00 	movabs $0x804c92,%rax
  806423:	00 00 00 
  806426:	ff d0                	callq  *%rax
  806428:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80642b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80642f:	79 1b                	jns    80644c <pipe+0x143>
		goto err3;
  806431:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  806432:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806436:	48 89 c6             	mov    %rax,%rsi
  806439:	bf 00 00 00 00       	mov    $0x0,%edi
  80643e:	48 b8 ed 4c 80 00 00 	movabs $0x804ced,%rax
  806445:	00 00 00 
  806448:	ff d0                	callq  *%rax
  80644a:	eb 79                	jmp    8064c5 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80644c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806450:	48 ba 60 11 81 00 00 	movabs $0x811160,%rdx
  806457:	00 00 00 
  80645a:	8b 12                	mov    (%rdx),%edx
  80645c:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80645e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806462:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  806469:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80646d:	48 ba 60 11 81 00 00 	movabs $0x811160,%rdx
  806474:	00 00 00 
  806477:	8b 12                	mov    (%rdx),%edx
  806479:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80647b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80647f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  806486:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80648a:	48 89 c7             	mov    %rax,%rdi
  80648d:	48 b8 1c 53 80 00 00 	movabs $0x80531c,%rax
  806494:	00 00 00 
  806497:	ff d0                	callq  *%rax
  806499:	89 c2                	mov    %eax,%edx
  80649b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80649f:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8064a1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8064a5:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8064a9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8064ad:	48 89 c7             	mov    %rax,%rdi
  8064b0:	48 b8 1c 53 80 00 00 	movabs $0x80531c,%rax
  8064b7:	00 00 00 
  8064ba:	ff d0                	callq  *%rax
  8064bc:	89 03                	mov    %eax,(%rbx)
	return 0;
  8064be:	b8 00 00 00 00       	mov    $0x0,%eax
  8064c3:	eb 33                	jmp    8064f8 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8064c5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8064c9:	48 89 c6             	mov    %rax,%rsi
  8064cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8064d1:	48 b8 ed 4c 80 00 00 	movabs $0x804ced,%rax
  8064d8:	00 00 00 
  8064db:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8064dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8064e1:	48 89 c6             	mov    %rax,%rsi
  8064e4:	bf 00 00 00 00       	mov    $0x0,%edi
  8064e9:	48 b8 ed 4c 80 00 00 	movabs $0x804ced,%rax
  8064f0:	00 00 00 
  8064f3:	ff d0                	callq  *%rax
err:
	return r;
  8064f5:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8064f8:	48 83 c4 38          	add    $0x38,%rsp
  8064fc:	5b                   	pop    %rbx
  8064fd:	5d                   	pop    %rbp
  8064fe:	c3                   	retq   

00000000008064ff <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8064ff:	55                   	push   %rbp
  806500:	48 89 e5             	mov    %rsp,%rbp
  806503:	53                   	push   %rbx
  806504:	48 83 ec 28          	sub    $0x28,%rsp
  806508:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80650c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  806510:	48 b8 20 40 81 00 00 	movabs $0x814020,%rax
  806517:	00 00 00 
  80651a:	48 8b 00             	mov    (%rax),%rax
  80651d:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  806523:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  806526:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80652a:	48 89 c7             	mov    %rax,%rdi
  80652d:	48 b8 80 62 80 00 00 	movabs $0x806280,%rax
  806534:	00 00 00 
  806537:	ff d0                	callq  *%rax
  806539:	89 c3                	mov    %eax,%ebx
  80653b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80653f:	48 89 c7             	mov    %rax,%rdi
  806542:	48 b8 80 62 80 00 00 	movabs $0x806280,%rax
  806549:	00 00 00 
  80654c:	ff d0                	callq  *%rax
  80654e:	39 c3                	cmp    %eax,%ebx
  806550:	0f 94 c0             	sete   %al
  806553:	0f b6 c0             	movzbl %al,%eax
  806556:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  806559:	48 b8 20 40 81 00 00 	movabs $0x814020,%rax
  806560:	00 00 00 
  806563:	48 8b 00             	mov    (%rax),%rax
  806566:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80656c:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80656f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806572:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  806575:	75 05                	jne    80657c <_pipeisclosed+0x7d>
			return ret;
  806577:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80657a:	eb 4f                	jmp    8065cb <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80657c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80657f:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  806582:	74 42                	je     8065c6 <_pipeisclosed+0xc7>
  806584:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  806588:	75 3c                	jne    8065c6 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80658a:	48 b8 20 40 81 00 00 	movabs $0x814020,%rax
  806591:	00 00 00 
  806594:	48 8b 00             	mov    (%rax),%rax
  806597:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80659d:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8065a0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8065a3:	89 c6                	mov    %eax,%esi
  8065a5:	48 bf c9 78 80 00 00 	movabs $0x8078c9,%rdi
  8065ac:	00 00 00 
  8065af:	b8 00 00 00 00       	mov    $0x0,%eax
  8065b4:	49 b8 1d 37 80 00 00 	movabs $0x80371d,%r8
  8065bb:	00 00 00 
  8065be:	41 ff d0             	callq  *%r8
	}
  8065c1:	e9 4a ff ff ff       	jmpq   806510 <_pipeisclosed+0x11>
  8065c6:	e9 45 ff ff ff       	jmpq   806510 <_pipeisclosed+0x11>
}
  8065cb:	48 83 c4 28          	add    $0x28,%rsp
  8065cf:	5b                   	pop    %rbx
  8065d0:	5d                   	pop    %rbp
  8065d1:	c3                   	retq   

00000000008065d2 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8065d2:	55                   	push   %rbp
  8065d3:	48 89 e5             	mov    %rsp,%rbp
  8065d6:	48 83 ec 30          	sub    $0x30,%rsp
  8065da:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8065dd:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8065e1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8065e4:	48 89 d6             	mov    %rdx,%rsi
  8065e7:	89 c7                	mov    %eax,%edi
  8065e9:	48 b8 02 54 80 00 00 	movabs $0x805402,%rax
  8065f0:	00 00 00 
  8065f3:	ff d0                	callq  *%rax
  8065f5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8065f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8065fc:	79 05                	jns    806603 <pipeisclosed+0x31>
		return r;
  8065fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806601:	eb 31                	jmp    806634 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  806603:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806607:	48 89 c7             	mov    %rax,%rdi
  80660a:	48 b8 3f 53 80 00 00 	movabs $0x80533f,%rax
  806611:	00 00 00 
  806614:	ff d0                	callq  *%rax
  806616:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80661a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80661e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  806622:	48 89 d6             	mov    %rdx,%rsi
  806625:	48 89 c7             	mov    %rax,%rdi
  806628:	48 b8 ff 64 80 00 00 	movabs $0x8064ff,%rax
  80662f:	00 00 00 
  806632:	ff d0                	callq  *%rax
}
  806634:	c9                   	leaveq 
  806635:	c3                   	retq   

0000000000806636 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  806636:	55                   	push   %rbp
  806637:	48 89 e5             	mov    %rsp,%rbp
  80663a:	48 83 ec 40          	sub    $0x40,%rsp
  80663e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  806642:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  806646:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80664a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80664e:	48 89 c7             	mov    %rax,%rdi
  806651:	48 b8 3f 53 80 00 00 	movabs $0x80533f,%rax
  806658:	00 00 00 
  80665b:	ff d0                	callq  *%rax
  80665d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  806661:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806665:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  806669:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  806670:	00 
  806671:	e9 92 00 00 00       	jmpq   806708 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  806676:	eb 41                	jmp    8066b9 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  806678:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80667d:	74 09                	je     806688 <devpipe_read+0x52>
				return i;
  80667f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806683:	e9 92 00 00 00       	jmpq   80671a <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  806688:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80668c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806690:	48 89 d6             	mov    %rdx,%rsi
  806693:	48 89 c7             	mov    %rax,%rdi
  806696:	48 b8 ff 64 80 00 00 	movabs $0x8064ff,%rax
  80669d:	00 00 00 
  8066a0:	ff d0                	callq  *%rax
  8066a2:	85 c0                	test   %eax,%eax
  8066a4:	74 07                	je     8066ad <devpipe_read+0x77>
				return 0;
  8066a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8066ab:	eb 6d                	jmp    80671a <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8066ad:	48 b8 04 4c 80 00 00 	movabs $0x804c04,%rax
  8066b4:	00 00 00 
  8066b7:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8066b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8066bd:	8b 10                	mov    (%rax),%edx
  8066bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8066c3:	8b 40 04             	mov    0x4(%rax),%eax
  8066c6:	39 c2                	cmp    %eax,%edx
  8066c8:	74 ae                	je     806678 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8066ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8066ce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8066d2:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8066d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8066da:	8b 00                	mov    (%rax),%eax
  8066dc:	99                   	cltd   
  8066dd:	c1 ea 1b             	shr    $0x1b,%edx
  8066e0:	01 d0                	add    %edx,%eax
  8066e2:	83 e0 1f             	and    $0x1f,%eax
  8066e5:	29 d0                	sub    %edx,%eax
  8066e7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8066eb:	48 98                	cltq   
  8066ed:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8066f2:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8066f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8066f8:	8b 00                	mov    (%rax),%eax
  8066fa:	8d 50 01             	lea    0x1(%rax),%edx
  8066fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806701:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  806703:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  806708:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80670c:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  806710:	0f 82 60 ff ff ff    	jb     806676 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  806716:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80671a:	c9                   	leaveq 
  80671b:	c3                   	retq   

000000000080671c <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80671c:	55                   	push   %rbp
  80671d:	48 89 e5             	mov    %rsp,%rbp
  806720:	48 83 ec 40          	sub    $0x40,%rsp
  806724:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  806728:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80672c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  806730:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806734:	48 89 c7             	mov    %rax,%rdi
  806737:	48 b8 3f 53 80 00 00 	movabs $0x80533f,%rax
  80673e:	00 00 00 
  806741:	ff d0                	callq  *%rax
  806743:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  806747:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80674b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80674f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  806756:	00 
  806757:	e9 8e 00 00 00       	jmpq   8067ea <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80675c:	eb 31                	jmp    80678f <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80675e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  806762:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806766:	48 89 d6             	mov    %rdx,%rsi
  806769:	48 89 c7             	mov    %rax,%rdi
  80676c:	48 b8 ff 64 80 00 00 	movabs $0x8064ff,%rax
  806773:	00 00 00 
  806776:	ff d0                	callq  *%rax
  806778:	85 c0                	test   %eax,%eax
  80677a:	74 07                	je     806783 <devpipe_write+0x67>
				return 0;
  80677c:	b8 00 00 00 00       	mov    $0x0,%eax
  806781:	eb 79                	jmp    8067fc <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  806783:	48 b8 04 4c 80 00 00 	movabs $0x804c04,%rax
  80678a:	00 00 00 
  80678d:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80678f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806793:	8b 40 04             	mov    0x4(%rax),%eax
  806796:	48 63 d0             	movslq %eax,%rdx
  806799:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80679d:	8b 00                	mov    (%rax),%eax
  80679f:	48 98                	cltq   
  8067a1:	48 83 c0 20          	add    $0x20,%rax
  8067a5:	48 39 c2             	cmp    %rax,%rdx
  8067a8:	73 b4                	jae    80675e <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8067aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8067ae:	8b 40 04             	mov    0x4(%rax),%eax
  8067b1:	99                   	cltd   
  8067b2:	c1 ea 1b             	shr    $0x1b,%edx
  8067b5:	01 d0                	add    %edx,%eax
  8067b7:	83 e0 1f             	and    $0x1f,%eax
  8067ba:	29 d0                	sub    %edx,%eax
  8067bc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8067c0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8067c4:	48 01 ca             	add    %rcx,%rdx
  8067c7:	0f b6 0a             	movzbl (%rdx),%ecx
  8067ca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8067ce:	48 98                	cltq   
  8067d0:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8067d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8067d8:	8b 40 04             	mov    0x4(%rax),%eax
  8067db:	8d 50 01             	lea    0x1(%rax),%edx
  8067de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8067e2:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8067e5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8067ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8067ee:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8067f2:	0f 82 64 ff ff ff    	jb     80675c <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8067f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8067fc:	c9                   	leaveq 
  8067fd:	c3                   	retq   

00000000008067fe <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8067fe:	55                   	push   %rbp
  8067ff:	48 89 e5             	mov    %rsp,%rbp
  806802:	48 83 ec 20          	sub    $0x20,%rsp
  806806:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80680a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80680e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806812:	48 89 c7             	mov    %rax,%rdi
  806815:	48 b8 3f 53 80 00 00 	movabs $0x80533f,%rax
  80681c:	00 00 00 
  80681f:	ff d0                	callq  *%rax
  806821:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  806825:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806829:	48 be dc 78 80 00 00 	movabs $0x8078dc,%rsi
  806830:	00 00 00 
  806833:	48 89 c7             	mov    %rax,%rdi
  806836:	48 b8 13 43 80 00 00 	movabs $0x804313,%rax
  80683d:	00 00 00 
  806840:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  806842:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806846:	8b 50 04             	mov    0x4(%rax),%edx
  806849:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80684d:	8b 00                	mov    (%rax),%eax
  80684f:	29 c2                	sub    %eax,%edx
  806851:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806855:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80685b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80685f:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  806866:	00 00 00 
	stat->st_dev = &devpipe;
  806869:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80686d:	48 b9 60 11 81 00 00 	movabs $0x811160,%rcx
  806874:	00 00 00 
  806877:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80687e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  806883:	c9                   	leaveq 
  806884:	c3                   	retq   

0000000000806885 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  806885:	55                   	push   %rbp
  806886:	48 89 e5             	mov    %rsp,%rbp
  806889:	48 83 ec 10          	sub    $0x10,%rsp
  80688d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  806891:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806895:	48 89 c6             	mov    %rax,%rsi
  806898:	bf 00 00 00 00       	mov    $0x0,%edi
  80689d:	48 b8 ed 4c 80 00 00 	movabs $0x804ced,%rax
  8068a4:	00 00 00 
  8068a7:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  8068a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8068ad:	48 89 c7             	mov    %rax,%rdi
  8068b0:	48 b8 3f 53 80 00 00 	movabs $0x80533f,%rax
  8068b7:	00 00 00 
  8068ba:	ff d0                	callq  *%rax
  8068bc:	48 89 c6             	mov    %rax,%rsi
  8068bf:	bf 00 00 00 00       	mov    $0x0,%edi
  8068c4:	48 b8 ed 4c 80 00 00 	movabs $0x804ced,%rax
  8068cb:	00 00 00 
  8068ce:	ff d0                	callq  *%rax
}
  8068d0:	c9                   	leaveq 
  8068d1:	c3                   	retq   

00000000008068d2 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8068d2:	55                   	push   %rbp
  8068d3:	48 89 e5             	mov    %rsp,%rbp
  8068d6:	48 83 ec 20          	sub    $0x20,%rsp
  8068da:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8068dd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8068e0:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8068e3:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8068e7:	be 01 00 00 00       	mov    $0x1,%esi
  8068ec:	48 89 c7             	mov    %rax,%rdi
  8068ef:	48 b8 fa 4a 80 00 00 	movabs $0x804afa,%rax
  8068f6:	00 00 00 
  8068f9:	ff d0                	callq  *%rax
}
  8068fb:	c9                   	leaveq 
  8068fc:	c3                   	retq   

00000000008068fd <getchar>:

int
getchar(void)
{
  8068fd:	55                   	push   %rbp
  8068fe:	48 89 e5             	mov    %rsp,%rbp
  806901:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  806905:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  806909:	ba 01 00 00 00       	mov    $0x1,%edx
  80690e:	48 89 c6             	mov    %rax,%rsi
  806911:	bf 00 00 00 00       	mov    $0x0,%edi
  806916:	48 b8 34 58 80 00 00 	movabs $0x805834,%rax
  80691d:	00 00 00 
  806920:	ff d0                	callq  *%rax
  806922:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  806925:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806929:	79 05                	jns    806930 <getchar+0x33>
		return r;
  80692b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80692e:	eb 14                	jmp    806944 <getchar+0x47>
	if (r < 1)
  806930:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806934:	7f 07                	jg     80693d <getchar+0x40>
		return -E_EOF;
  806936:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80693b:	eb 07                	jmp    806944 <getchar+0x47>
	return c;
  80693d:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  806941:	0f b6 c0             	movzbl %al,%eax
}
  806944:	c9                   	leaveq 
  806945:	c3                   	retq   

0000000000806946 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  806946:	55                   	push   %rbp
  806947:	48 89 e5             	mov    %rsp,%rbp
  80694a:	48 83 ec 20          	sub    $0x20,%rsp
  80694e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  806951:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  806955:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806958:	48 89 d6             	mov    %rdx,%rsi
  80695b:	89 c7                	mov    %eax,%edi
  80695d:	48 b8 02 54 80 00 00 	movabs $0x805402,%rax
  806964:	00 00 00 
  806967:	ff d0                	callq  *%rax
  806969:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80696c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806970:	79 05                	jns    806977 <iscons+0x31>
		return r;
  806972:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806975:	eb 1a                	jmp    806991 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  806977:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80697b:	8b 10                	mov    (%rax),%edx
  80697d:	48 b8 a0 11 81 00 00 	movabs $0x8111a0,%rax
  806984:	00 00 00 
  806987:	8b 00                	mov    (%rax),%eax
  806989:	39 c2                	cmp    %eax,%edx
  80698b:	0f 94 c0             	sete   %al
  80698e:	0f b6 c0             	movzbl %al,%eax
}
  806991:	c9                   	leaveq 
  806992:	c3                   	retq   

0000000000806993 <opencons>:

int
opencons(void)
{
  806993:	55                   	push   %rbp
  806994:	48 89 e5             	mov    %rsp,%rbp
  806997:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80699b:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80699f:	48 89 c7             	mov    %rax,%rdi
  8069a2:	48 b8 6a 53 80 00 00 	movabs $0x80536a,%rax
  8069a9:	00 00 00 
  8069ac:	ff d0                	callq  *%rax
  8069ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8069b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8069b5:	79 05                	jns    8069bc <opencons+0x29>
		return r;
  8069b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8069ba:	eb 5b                	jmp    806a17 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8069bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8069c0:	ba 07 04 00 00       	mov    $0x407,%edx
  8069c5:	48 89 c6             	mov    %rax,%rsi
  8069c8:	bf 00 00 00 00       	mov    $0x0,%edi
  8069cd:	48 b8 42 4c 80 00 00 	movabs $0x804c42,%rax
  8069d4:	00 00 00 
  8069d7:	ff d0                	callq  *%rax
  8069d9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8069dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8069e0:	79 05                	jns    8069e7 <opencons+0x54>
		return r;
  8069e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8069e5:	eb 30                	jmp    806a17 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8069e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8069eb:	48 ba a0 11 81 00 00 	movabs $0x8111a0,%rdx
  8069f2:	00 00 00 
  8069f5:	8b 12                	mov    (%rdx),%edx
  8069f7:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8069f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8069fd:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  806a04:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806a08:	48 89 c7             	mov    %rax,%rdi
  806a0b:	48 b8 1c 53 80 00 00 	movabs $0x80531c,%rax
  806a12:	00 00 00 
  806a15:	ff d0                	callq  *%rax
}
  806a17:	c9                   	leaveq 
  806a18:	c3                   	retq   

0000000000806a19 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  806a19:	55                   	push   %rbp
  806a1a:	48 89 e5             	mov    %rsp,%rbp
  806a1d:	48 83 ec 30          	sub    $0x30,%rsp
  806a21:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  806a25:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  806a29:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  806a2d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  806a32:	75 07                	jne    806a3b <devcons_read+0x22>
		return 0;
  806a34:	b8 00 00 00 00       	mov    $0x0,%eax
  806a39:	eb 4b                	jmp    806a86 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  806a3b:	eb 0c                	jmp    806a49 <devcons_read+0x30>
		sys_yield();
  806a3d:	48 b8 04 4c 80 00 00 	movabs $0x804c04,%rax
  806a44:	00 00 00 
  806a47:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  806a49:	48 b8 44 4b 80 00 00 	movabs $0x804b44,%rax
  806a50:	00 00 00 
  806a53:	ff d0                	callq  *%rax
  806a55:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806a58:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806a5c:	74 df                	je     806a3d <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  806a5e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806a62:	79 05                	jns    806a69 <devcons_read+0x50>
		return c;
  806a64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806a67:	eb 1d                	jmp    806a86 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  806a69:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  806a6d:	75 07                	jne    806a76 <devcons_read+0x5d>
		return 0;
  806a6f:	b8 00 00 00 00       	mov    $0x0,%eax
  806a74:	eb 10                	jmp    806a86 <devcons_read+0x6d>
	*(char*)vbuf = c;
  806a76:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806a79:	89 c2                	mov    %eax,%edx
  806a7b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806a7f:	88 10                	mov    %dl,(%rax)
	return 1;
  806a81:	b8 01 00 00 00       	mov    $0x1,%eax
}
  806a86:	c9                   	leaveq 
  806a87:	c3                   	retq   

0000000000806a88 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  806a88:	55                   	push   %rbp
  806a89:	48 89 e5             	mov    %rsp,%rbp
  806a8c:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  806a93:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  806a9a:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  806aa1:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  806aa8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  806aaf:	eb 76                	jmp    806b27 <devcons_write+0x9f>
		m = n - tot;
  806ab1:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  806ab8:	89 c2                	mov    %eax,%edx
  806aba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806abd:	29 c2                	sub    %eax,%edx
  806abf:	89 d0                	mov    %edx,%eax
  806ac1:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  806ac4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  806ac7:	83 f8 7f             	cmp    $0x7f,%eax
  806aca:	76 07                	jbe    806ad3 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  806acc:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  806ad3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  806ad6:	48 63 d0             	movslq %eax,%rdx
  806ad9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806adc:	48 63 c8             	movslq %eax,%rcx
  806adf:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  806ae6:	48 01 c1             	add    %rax,%rcx
  806ae9:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  806af0:	48 89 ce             	mov    %rcx,%rsi
  806af3:	48 89 c7             	mov    %rax,%rdi
  806af6:	48 b8 37 46 80 00 00 	movabs $0x804637,%rax
  806afd:	00 00 00 
  806b00:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  806b02:	8b 45 f8             	mov    -0x8(%rbp),%eax
  806b05:	48 63 d0             	movslq %eax,%rdx
  806b08:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  806b0f:	48 89 d6             	mov    %rdx,%rsi
  806b12:	48 89 c7             	mov    %rax,%rdi
  806b15:	48 b8 fa 4a 80 00 00 	movabs $0x804afa,%rax
  806b1c:	00 00 00 
  806b1f:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  806b21:	8b 45 f8             	mov    -0x8(%rbp),%eax
  806b24:	01 45 fc             	add    %eax,-0x4(%rbp)
  806b27:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806b2a:	48 98                	cltq   
  806b2c:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  806b33:	0f 82 78 ff ff ff    	jb     806ab1 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  806b39:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  806b3c:	c9                   	leaveq 
  806b3d:	c3                   	retq   

0000000000806b3e <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  806b3e:	55                   	push   %rbp
  806b3f:	48 89 e5             	mov    %rsp,%rbp
  806b42:	48 83 ec 08          	sub    $0x8,%rsp
  806b46:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  806b4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  806b4f:	c9                   	leaveq 
  806b50:	c3                   	retq   

0000000000806b51 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  806b51:	55                   	push   %rbp
  806b52:	48 89 e5             	mov    %rsp,%rbp
  806b55:	48 83 ec 10          	sub    $0x10,%rsp
  806b59:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  806b5d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  806b61:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806b65:	48 be e8 78 80 00 00 	movabs $0x8078e8,%rsi
  806b6c:	00 00 00 
  806b6f:	48 89 c7             	mov    %rax,%rdi
  806b72:	48 b8 13 43 80 00 00 	movabs $0x804313,%rax
  806b79:	00 00 00 
  806b7c:	ff d0                	callq  *%rax
	return 0;
  806b7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  806b83:	c9                   	leaveq 
  806b84:	c3                   	retq   
