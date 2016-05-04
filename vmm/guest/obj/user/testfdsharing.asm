
vmm/guest/obj/user/testfdsharing:     file format elf64-x86-64


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
  80003c:	e8 fa 02 00 00       	callq  80033b <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

char buf[512], buf2[512];

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r, n, n2;

	if ((fd = open("motd", O_RDONLY)) < 0)
  800052:	be 00 00 00 00       	mov    $0x0,%esi
  800057:	48 bf 60 44 80 00 00 	movabs $0x804460,%rdi
  80005e:	00 00 00 
  800061:	48 b8 06 32 80 00 00 	movabs $0x803206,%rax
  800068:	00 00 00 
  80006b:	ff d0                	callq  *%rax
  80006d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800070:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800074:	79 30                	jns    8000a6 <umain+0x63>
		panic("open motd: %e", fd);
  800076:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800079:	89 c1                	mov    %eax,%ecx
  80007b:	48 ba 65 44 80 00 00 	movabs $0x804465,%rdx
  800082:	00 00 00 
  800085:	be 0c 00 00 00       	mov    $0xc,%esi
  80008a:	48 bf 73 44 80 00 00 	movabs $0x804473,%rdi
  800091:	00 00 00 
  800094:	b8 00 00 00 00       	mov    $0x0,%eax
  800099:	49 b8 e1 03 80 00 00 	movabs $0x8003e1,%r8
  8000a0:	00 00 00 
  8000a3:	41 ff d0             	callq  *%r8
	seek(fd, 0);
  8000a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000a9:	be 00 00 00 00       	mov    $0x0,%esi
  8000ae:	89 c7                	mov    %eax,%edi
  8000b0:	48 b8 4e 2f 80 00 00 	movabs $0x802f4e,%rax
  8000b7:	00 00 00 
  8000ba:	ff d0                	callq  *%rax
	if ((n = readn(fd, buf, sizeof buf)) <= 0)
  8000bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000bf:	ba 00 02 00 00       	mov    $0x200,%edx
  8000c4:	48 be 20 72 80 00 00 	movabs $0x807220,%rsi
  8000cb:	00 00 00 
  8000ce:	89 c7                	mov    %eax,%edi
  8000d0:	48 b8 05 2e 80 00 00 	movabs $0x802e05,%rax
  8000d7:	00 00 00 
  8000da:	ff d0                	callq  *%rax
  8000dc:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000df:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000e3:	7f 30                	jg     800115 <umain+0xd2>
		panic("readn: %e", n);
  8000e5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000e8:	89 c1                	mov    %eax,%ecx
  8000ea:	48 ba 88 44 80 00 00 	movabs $0x804488,%rdx
  8000f1:	00 00 00 
  8000f4:	be 0f 00 00 00       	mov    $0xf,%esi
  8000f9:	48 bf 73 44 80 00 00 	movabs $0x804473,%rdi
  800100:	00 00 00 
  800103:	b8 00 00 00 00       	mov    $0x0,%eax
  800108:	49 b8 e1 03 80 00 00 	movabs $0x8003e1,%r8
  80010f:	00 00 00 
  800112:	41 ff d0             	callq  *%r8

	if ((r = fork()) < 0)
  800115:	48 b8 0c 24 80 00 00 	movabs $0x80240c,%rax
  80011c:	00 00 00 
  80011f:	ff d0                	callq  *%rax
  800121:	89 45 f4             	mov    %eax,-0xc(%rbp)
  800124:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800128:	79 30                	jns    80015a <umain+0x117>
		panic("fork: %e", r);
  80012a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80012d:	89 c1                	mov    %eax,%ecx
  80012f:	48 ba 92 44 80 00 00 	movabs $0x804492,%rdx
  800136:	00 00 00 
  800139:	be 12 00 00 00       	mov    $0x12,%esi
  80013e:	48 bf 73 44 80 00 00 	movabs $0x804473,%rdi
  800145:	00 00 00 
  800148:	b8 00 00 00 00       	mov    $0x0,%eax
  80014d:	49 b8 e1 03 80 00 00 	movabs $0x8003e1,%r8
  800154:	00 00 00 
  800157:	41 ff d0             	callq  *%r8
	if (r == 0) {
  80015a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80015e:	0f 85 36 01 00 00    	jne    80029a <umain+0x257>
		seek(fd, 0);
  800164:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800167:	be 00 00 00 00       	mov    $0x0,%esi
  80016c:	89 c7                	mov    %eax,%edi
  80016e:	48 b8 4e 2f 80 00 00 	movabs $0x802f4e,%rax
  800175:	00 00 00 
  800178:	ff d0                	callq  *%rax
		cprintf("going to read in child (might page fault if your sharing is buggy)\n");
  80017a:	48 bf a0 44 80 00 00 	movabs $0x8044a0,%rdi
  800181:	00 00 00 
  800184:	b8 00 00 00 00       	mov    $0x0,%eax
  800189:	48 ba 1a 06 80 00 00 	movabs $0x80061a,%rdx
  800190:	00 00 00 
  800193:	ff d2                	callq  *%rdx
		if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  800195:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800198:	ba 00 02 00 00       	mov    $0x200,%edx
  80019d:	48 be 20 70 80 00 00 	movabs $0x807020,%rsi
  8001a4:	00 00 00 
  8001a7:	89 c7                	mov    %eax,%edi
  8001a9:	48 b8 05 2e 80 00 00 	movabs $0x802e05,%rax
  8001b0:	00 00 00 
  8001b3:	ff d0                	callq  *%rax
  8001b5:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8001b8:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8001bb:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  8001be:	74 36                	je     8001f6 <umain+0x1b3>
			panic("read in parent got %d, read in child got %d", n, n2);
  8001c0:	8b 55 f0             	mov    -0x10(%rbp),%edx
  8001c3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001c6:	41 89 d0             	mov    %edx,%r8d
  8001c9:	89 c1                	mov    %eax,%ecx
  8001cb:	48 ba e8 44 80 00 00 	movabs $0x8044e8,%rdx
  8001d2:	00 00 00 
  8001d5:	be 17 00 00 00       	mov    $0x17,%esi
  8001da:	48 bf 73 44 80 00 00 	movabs $0x804473,%rdi
  8001e1:	00 00 00 
  8001e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e9:	49 b9 e1 03 80 00 00 	movabs $0x8003e1,%r9
  8001f0:	00 00 00 
  8001f3:	41 ff d1             	callq  *%r9
		if (memcmp(buf, buf2, n) != 0)
  8001f6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8001f9:	48 98                	cltq   
  8001fb:	48 89 c2             	mov    %rax,%rdx
  8001fe:	48 be 20 70 80 00 00 	movabs $0x807020,%rsi
  800205:	00 00 00 
  800208:	48 bf 20 72 80 00 00 	movabs $0x807220,%rdi
  80020f:	00 00 00 
  800212:	48 b8 7f 16 80 00 00 	movabs $0x80167f,%rax
  800219:	00 00 00 
  80021c:	ff d0                	callq  *%rax
  80021e:	85 c0                	test   %eax,%eax
  800220:	74 2a                	je     80024c <umain+0x209>
			panic("read in parent got different bytes from read in child");
  800222:	48 ba 18 45 80 00 00 	movabs $0x804518,%rdx
  800229:	00 00 00 
  80022c:	be 19 00 00 00       	mov    $0x19,%esi
  800231:	48 bf 73 44 80 00 00 	movabs $0x804473,%rdi
  800238:	00 00 00 
  80023b:	b8 00 00 00 00       	mov    $0x0,%eax
  800240:	48 b9 e1 03 80 00 00 	movabs $0x8003e1,%rcx
  800247:	00 00 00 
  80024a:	ff d1                	callq  *%rcx
		cprintf("read in child succeeded\n");
  80024c:	48 bf 4e 45 80 00 00 	movabs $0x80454e,%rdi
  800253:	00 00 00 
  800256:	b8 00 00 00 00       	mov    $0x0,%eax
  80025b:	48 ba 1a 06 80 00 00 	movabs $0x80061a,%rdx
  800262:	00 00 00 
  800265:	ff d2                	callq  *%rdx
		seek(fd, 0);
  800267:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80026a:	be 00 00 00 00       	mov    $0x0,%esi
  80026f:	89 c7                	mov    %eax,%edi
  800271:	48 b8 4e 2f 80 00 00 	movabs $0x802f4e,%rax
  800278:	00 00 00 
  80027b:	ff d0                	callq  *%rax
		close(fd);
  80027d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800280:	89 c7                	mov    %eax,%edi
  800282:	48 b8 0e 2b 80 00 00 	movabs $0x802b0e,%rax
  800289:	00 00 00 
  80028c:	ff d0                	callq  *%rax
		exit();
  80028e:	48 b8 be 03 80 00 00 	movabs $0x8003be,%rax
  800295:	00 00 00 
  800298:	ff d0                	callq  *%rax
	}
	wait(r);
  80029a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80029d:	89 c7                	mov    %eax,%edi
  80029f:	48 b8 45 3d 80 00 00 	movabs $0x803d45,%rax
  8002a6:	00 00 00 
  8002a9:	ff d0                	callq  *%rax
	if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  8002ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002ae:	ba 00 02 00 00       	mov    $0x200,%edx
  8002b3:	48 be 20 70 80 00 00 	movabs $0x807020,%rsi
  8002ba:	00 00 00 
  8002bd:	89 c7                	mov    %eax,%edi
  8002bf:	48 b8 05 2e 80 00 00 	movabs $0x802e05,%rax
  8002c6:	00 00 00 
  8002c9:	ff d0                	callq  *%rax
  8002cb:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8002ce:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8002d1:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  8002d4:	74 36                	je     80030c <umain+0x2c9>
		panic("read in parent got %d, then got %d", n, n2);
  8002d6:	8b 55 f0             	mov    -0x10(%rbp),%edx
  8002d9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002dc:	41 89 d0             	mov    %edx,%r8d
  8002df:	89 c1                	mov    %eax,%ecx
  8002e1:	48 ba 68 45 80 00 00 	movabs $0x804568,%rdx
  8002e8:	00 00 00 
  8002eb:	be 21 00 00 00       	mov    $0x21,%esi
  8002f0:	48 bf 73 44 80 00 00 	movabs $0x804473,%rdi
  8002f7:	00 00 00 
  8002fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8002ff:	49 b9 e1 03 80 00 00 	movabs $0x8003e1,%r9
  800306:	00 00 00 
  800309:	41 ff d1             	callq  *%r9
	cprintf("read in parent succeeded\n");
  80030c:	48 bf 8b 45 80 00 00 	movabs $0x80458b,%rdi
  800313:	00 00 00 
  800316:	b8 00 00 00 00       	mov    $0x0,%eax
  80031b:	48 ba 1a 06 80 00 00 	movabs $0x80061a,%rdx
  800322:	00 00 00 
  800325:	ff d2                	callq  *%rdx
	close(fd);
  800327:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80032a:	89 c7                	mov    %eax,%edi
  80032c:	48 b8 0e 2b 80 00 00 	movabs $0x802b0e,%rax
  800333:	00 00 00 
  800336:	ff d0                	callq  *%rax


    static __inline void
breakpoint(void)
{
    __asm __volatile("int3");
  800338:	cc                   	int3   

	breakpoint();
}
  800339:	c9                   	leaveq 
  80033a:	c3                   	retq   

000000000080033b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80033b:	55                   	push   %rbp
  80033c:	48 89 e5             	mov    %rsp,%rbp
  80033f:	48 83 ec 10          	sub    $0x10,%rsp
  800343:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800346:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = envs+ENVX(sys_getenvid ());
  80034a:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  800351:	00 00 00 
  800354:	ff d0                	callq  *%rax
  800356:	48 98                	cltq   
  800358:	25 ff 03 00 00       	and    $0x3ff,%eax
  80035d:	48 69 d0 70 01 00 00 	imul   $0x170,%rax,%rdx
  800364:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80036b:	00 00 00 
  80036e:	48 01 c2             	add    %rax,%rdx
  800371:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  800378:	00 00 00 
  80037b:	48 89 10             	mov    %rdx,(%rax)
	// thisenv = 0;


	// save the name of the program so that panic() can use it
	if (argc > 0)
  80037e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800382:	7e 14                	jle    800398 <libmain+0x5d>
		binaryname = argv[0];
  800384:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800388:	48 8b 10             	mov    (%rax),%rdx
  80038b:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800392:	00 00 00 
  800395:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800398:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80039c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80039f:	48 89 d6             	mov    %rdx,%rsi
  8003a2:	89 c7                	mov    %eax,%edi
  8003a4:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8003ab:	00 00 00 
  8003ae:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8003b0:	48 b8 be 03 80 00 00 	movabs $0x8003be,%rax
  8003b7:	00 00 00 
  8003ba:	ff d0                	callq  *%rax
}
  8003bc:	c9                   	leaveq 
  8003bd:	c3                   	retq   

00000000008003be <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003be:	55                   	push   %rbp
  8003bf:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  8003c2:	48 b8 59 2b 80 00 00 	movabs $0x802b59,%rax
  8003c9:	00 00 00 
  8003cc:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  8003ce:	bf 00 00 00 00       	mov    $0x0,%edi
  8003d3:	48 b8 7f 1a 80 00 00 	movabs $0x801a7f,%rax
  8003da:	00 00 00 
  8003dd:	ff d0                	callq  *%rax
}
  8003df:	5d                   	pop    %rbp
  8003e0:	c3                   	retq   

00000000008003e1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003e1:	55                   	push   %rbp
  8003e2:	48 89 e5             	mov    %rsp,%rbp
  8003e5:	53                   	push   %rbx
  8003e6:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8003ed:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8003f4:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8003fa:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800401:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800408:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80040f:	84 c0                	test   %al,%al
  800411:	74 23                	je     800436 <_panic+0x55>
  800413:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80041a:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80041e:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800422:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800426:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80042a:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80042e:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800432:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800436:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80043d:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800444:	00 00 00 
  800447:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80044e:	00 00 00 
  800451:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800455:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80045c:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800463:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80046a:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800471:	00 00 00 
  800474:	48 8b 18             	mov    (%rax),%rbx
  800477:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  80047e:	00 00 00 
  800481:	ff d0                	callq  *%rax
  800483:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800489:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800490:	41 89 c8             	mov    %ecx,%r8d
  800493:	48 89 d1             	mov    %rdx,%rcx
  800496:	48 89 da             	mov    %rbx,%rdx
  800499:	89 c6                	mov    %eax,%esi
  80049b:	48 bf b0 45 80 00 00 	movabs $0x8045b0,%rdi
  8004a2:	00 00 00 
  8004a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8004aa:	49 b9 1a 06 80 00 00 	movabs $0x80061a,%r9
  8004b1:	00 00 00 
  8004b4:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8004b7:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8004be:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8004c5:	48 89 d6             	mov    %rdx,%rsi
  8004c8:	48 89 c7             	mov    %rax,%rdi
  8004cb:	48 b8 6e 05 80 00 00 	movabs $0x80056e,%rax
  8004d2:	00 00 00 
  8004d5:	ff d0                	callq  *%rax
	cprintf("\n");
  8004d7:	48 bf d3 45 80 00 00 	movabs $0x8045d3,%rdi
  8004de:	00 00 00 
  8004e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e6:	48 ba 1a 06 80 00 00 	movabs $0x80061a,%rdx
  8004ed:	00 00 00 
  8004f0:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8004f2:	cc                   	int3   
  8004f3:	eb fd                	jmp    8004f2 <_panic+0x111>

00000000008004f5 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8004f5:	55                   	push   %rbp
  8004f6:	48 89 e5             	mov    %rsp,%rbp
  8004f9:	48 83 ec 10          	sub    $0x10,%rsp
  8004fd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800500:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800504:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800508:	8b 00                	mov    (%rax),%eax
  80050a:	8d 48 01             	lea    0x1(%rax),%ecx
  80050d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800511:	89 0a                	mov    %ecx,(%rdx)
  800513:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800516:	89 d1                	mov    %edx,%ecx
  800518:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80051c:	48 98                	cltq   
  80051e:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800522:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800526:	8b 00                	mov    (%rax),%eax
  800528:	3d ff 00 00 00       	cmp    $0xff,%eax
  80052d:	75 2c                	jne    80055b <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80052f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800533:	8b 00                	mov    (%rax),%eax
  800535:	48 98                	cltq   
  800537:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80053b:	48 83 c2 08          	add    $0x8,%rdx
  80053f:	48 89 c6             	mov    %rax,%rsi
  800542:	48 89 d7             	mov    %rdx,%rdi
  800545:	48 b8 f7 19 80 00 00 	movabs $0x8019f7,%rax
  80054c:	00 00 00 
  80054f:	ff d0                	callq  *%rax
        b->idx = 0;
  800551:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800555:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80055b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80055f:	8b 40 04             	mov    0x4(%rax),%eax
  800562:	8d 50 01             	lea    0x1(%rax),%edx
  800565:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800569:	89 50 04             	mov    %edx,0x4(%rax)
}
  80056c:	c9                   	leaveq 
  80056d:	c3                   	retq   

000000000080056e <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80056e:	55                   	push   %rbp
  80056f:	48 89 e5             	mov    %rsp,%rbp
  800572:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800579:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800580:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800587:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80058e:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800595:	48 8b 0a             	mov    (%rdx),%rcx
  800598:	48 89 08             	mov    %rcx,(%rax)
  80059b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80059f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8005a3:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8005a7:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8005ab:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8005b2:	00 00 00 
    b.cnt = 0;
  8005b5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8005bc:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8005bf:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8005c6:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8005cd:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8005d4:	48 89 c6             	mov    %rax,%rsi
  8005d7:	48 bf f5 04 80 00 00 	movabs $0x8004f5,%rdi
  8005de:	00 00 00 
  8005e1:	48 b8 cd 09 80 00 00 	movabs $0x8009cd,%rax
  8005e8:	00 00 00 
  8005eb:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8005ed:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8005f3:	48 98                	cltq   
  8005f5:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8005fc:	48 83 c2 08          	add    $0x8,%rdx
  800600:	48 89 c6             	mov    %rax,%rsi
  800603:	48 89 d7             	mov    %rdx,%rdi
  800606:	48 b8 f7 19 80 00 00 	movabs $0x8019f7,%rax
  80060d:	00 00 00 
  800610:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800612:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800618:	c9                   	leaveq 
  800619:	c3                   	retq   

000000000080061a <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80061a:	55                   	push   %rbp
  80061b:	48 89 e5             	mov    %rsp,%rbp
  80061e:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800625:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80062c:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800633:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80063a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800641:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800648:	84 c0                	test   %al,%al
  80064a:	74 20                	je     80066c <cprintf+0x52>
  80064c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800650:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800654:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800658:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80065c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800660:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800664:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800668:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80066c:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800673:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80067a:	00 00 00 
  80067d:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800684:	00 00 00 
  800687:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80068b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800692:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800699:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8006a0:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8006a7:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8006ae:	48 8b 0a             	mov    (%rdx),%rcx
  8006b1:	48 89 08             	mov    %rcx,(%rax)
  8006b4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006b8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006bc:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006c0:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8006c4:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8006cb:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8006d2:	48 89 d6             	mov    %rdx,%rsi
  8006d5:	48 89 c7             	mov    %rax,%rdi
  8006d8:	48 b8 6e 05 80 00 00 	movabs $0x80056e,%rax
  8006df:	00 00 00 
  8006e2:	ff d0                	callq  *%rax
  8006e4:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8006ea:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8006f0:	c9                   	leaveq 
  8006f1:	c3                   	retq   

00000000008006f2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006f2:	55                   	push   %rbp
  8006f3:	48 89 e5             	mov    %rsp,%rbp
  8006f6:	53                   	push   %rbx
  8006f7:	48 83 ec 38          	sub    $0x38,%rsp
  8006fb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006ff:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800703:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800707:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80070a:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80070e:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800712:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800715:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800719:	77 3b                	ja     800756 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80071b:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80071e:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800722:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800725:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800729:	ba 00 00 00 00       	mov    $0x0,%edx
  80072e:	48 f7 f3             	div    %rbx
  800731:	48 89 c2             	mov    %rax,%rdx
  800734:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800737:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80073a:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80073e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800742:	41 89 f9             	mov    %edi,%r9d
  800745:	48 89 c7             	mov    %rax,%rdi
  800748:	48 b8 f2 06 80 00 00 	movabs $0x8006f2,%rax
  80074f:	00 00 00 
  800752:	ff d0                	callq  *%rax
  800754:	eb 1e                	jmp    800774 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800756:	eb 12                	jmp    80076a <printnum+0x78>
			putch(padc, putdat);
  800758:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80075c:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80075f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800763:	48 89 ce             	mov    %rcx,%rsi
  800766:	89 d7                	mov    %edx,%edi
  800768:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80076a:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80076e:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800772:	7f e4                	jg     800758 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800774:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  800777:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80077b:	ba 00 00 00 00       	mov    $0x0,%edx
  800780:	48 f7 f1             	div    %rcx
  800783:	48 89 d0             	mov    %rdx,%rax
  800786:	48 ba d0 47 80 00 00 	movabs $0x8047d0,%rdx
  80078d:	00 00 00 
  800790:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800794:	0f be d0             	movsbl %al,%edx
  800797:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80079b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80079f:	48 89 ce             	mov    %rcx,%rsi
  8007a2:	89 d7                	mov    %edx,%edi
  8007a4:	ff d0                	callq  *%rax
}
  8007a6:	48 83 c4 38          	add    $0x38,%rsp
  8007aa:	5b                   	pop    %rbx
  8007ab:	5d                   	pop    %rbp
  8007ac:	c3                   	retq   

00000000008007ad <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007ad:	55                   	push   %rbp
  8007ae:	48 89 e5             	mov    %rsp,%rbp
  8007b1:	48 83 ec 1c          	sub    $0x1c,%rsp
  8007b5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8007b9:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8007bc:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8007c0:	7e 52                	jle    800814 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8007c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007c6:	8b 00                	mov    (%rax),%eax
  8007c8:	83 f8 30             	cmp    $0x30,%eax
  8007cb:	73 24                	jae    8007f1 <getuint+0x44>
  8007cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8007d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007d9:	8b 00                	mov    (%rax),%eax
  8007db:	89 c0                	mov    %eax,%eax
  8007dd:	48 01 d0             	add    %rdx,%rax
  8007e0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007e4:	8b 12                	mov    (%rdx),%edx
  8007e6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8007e9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8007ed:	89 0a                	mov    %ecx,(%rdx)
  8007ef:	eb 17                	jmp    800808 <getuint+0x5b>
  8007f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8007f5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8007f9:	48 89 d0             	mov    %rdx,%rax
  8007fc:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800800:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800804:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800808:	48 8b 00             	mov    (%rax),%rax
  80080b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80080f:	e9 a3 00 00 00       	jmpq   8008b7 <getuint+0x10a>
	else if (lflag)
  800814:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800818:	74 4f                	je     800869 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80081a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80081e:	8b 00                	mov    (%rax),%eax
  800820:	83 f8 30             	cmp    $0x30,%eax
  800823:	73 24                	jae    800849 <getuint+0x9c>
  800825:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800829:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80082d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800831:	8b 00                	mov    (%rax),%eax
  800833:	89 c0                	mov    %eax,%eax
  800835:	48 01 d0             	add    %rdx,%rax
  800838:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80083c:	8b 12                	mov    (%rdx),%edx
  80083e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800841:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800845:	89 0a                	mov    %ecx,(%rdx)
  800847:	eb 17                	jmp    800860 <getuint+0xb3>
  800849:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80084d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800851:	48 89 d0             	mov    %rdx,%rax
  800854:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800858:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80085c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800860:	48 8b 00             	mov    (%rax),%rax
  800863:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800867:	eb 4e                	jmp    8008b7 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800869:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80086d:	8b 00                	mov    (%rax),%eax
  80086f:	83 f8 30             	cmp    $0x30,%eax
  800872:	73 24                	jae    800898 <getuint+0xeb>
  800874:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800878:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80087c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800880:	8b 00                	mov    (%rax),%eax
  800882:	89 c0                	mov    %eax,%eax
  800884:	48 01 d0             	add    %rdx,%rax
  800887:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80088b:	8b 12                	mov    (%rdx),%edx
  80088d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800890:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800894:	89 0a                	mov    %ecx,(%rdx)
  800896:	eb 17                	jmp    8008af <getuint+0x102>
  800898:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80089c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8008a0:	48 89 d0             	mov    %rdx,%rax
  8008a3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8008a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ab:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008af:	8b 00                	mov    (%rax),%eax
  8008b1:	89 c0                	mov    %eax,%eax
  8008b3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8008b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8008bb:	c9                   	leaveq 
  8008bc:	c3                   	retq   

00000000008008bd <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008bd:	55                   	push   %rbp
  8008be:	48 89 e5             	mov    %rsp,%rbp
  8008c1:	48 83 ec 1c          	sub    $0x1c,%rsp
  8008c5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008c9:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8008cc:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008d0:	7e 52                	jle    800924 <getint+0x67>
		x=va_arg(*ap, long long);
  8008d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d6:	8b 00                	mov    (%rax),%eax
  8008d8:	83 f8 30             	cmp    $0x30,%eax
  8008db:	73 24                	jae    800901 <getint+0x44>
  8008dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e9:	8b 00                	mov    (%rax),%eax
  8008eb:	89 c0                	mov    %eax,%eax
  8008ed:	48 01 d0             	add    %rdx,%rax
  8008f0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008f4:	8b 12                	mov    (%rdx),%edx
  8008f6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008f9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008fd:	89 0a                	mov    %ecx,(%rdx)
  8008ff:	eb 17                	jmp    800918 <getint+0x5b>
  800901:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800905:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800909:	48 89 d0             	mov    %rdx,%rax
  80090c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800910:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800914:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800918:	48 8b 00             	mov    (%rax),%rax
  80091b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80091f:	e9 a3 00 00 00       	jmpq   8009c7 <getint+0x10a>
	else if (lflag)
  800924:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800928:	74 4f                	je     800979 <getint+0xbc>
		x=va_arg(*ap, long);
  80092a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80092e:	8b 00                	mov    (%rax),%eax
  800930:	83 f8 30             	cmp    $0x30,%eax
  800933:	73 24                	jae    800959 <getint+0x9c>
  800935:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800939:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80093d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800941:	8b 00                	mov    (%rax),%eax
  800943:	89 c0                	mov    %eax,%eax
  800945:	48 01 d0             	add    %rdx,%rax
  800948:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80094c:	8b 12                	mov    (%rdx),%edx
  80094e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800951:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800955:	89 0a                	mov    %ecx,(%rdx)
  800957:	eb 17                	jmp    800970 <getint+0xb3>
  800959:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80095d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800961:	48 89 d0             	mov    %rdx,%rax
  800964:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800968:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80096c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800970:	48 8b 00             	mov    (%rax),%rax
  800973:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800977:	eb 4e                	jmp    8009c7 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800979:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80097d:	8b 00                	mov    (%rax),%eax
  80097f:	83 f8 30             	cmp    $0x30,%eax
  800982:	73 24                	jae    8009a8 <getint+0xeb>
  800984:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800988:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80098c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800990:	8b 00                	mov    (%rax),%eax
  800992:	89 c0                	mov    %eax,%eax
  800994:	48 01 d0             	add    %rdx,%rax
  800997:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80099b:	8b 12                	mov    (%rdx),%edx
  80099d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009a0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009a4:	89 0a                	mov    %ecx,(%rdx)
  8009a6:	eb 17                	jmp    8009bf <getint+0x102>
  8009a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ac:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009b0:	48 89 d0             	mov    %rdx,%rax
  8009b3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009b7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009bb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009bf:	8b 00                	mov    (%rax),%eax
  8009c1:	48 98                	cltq   
  8009c3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009cb:	c9                   	leaveq 
  8009cc:	c3                   	retq   

00000000008009cd <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009cd:	55                   	push   %rbp
  8009ce:	48 89 e5             	mov    %rsp,%rbp
  8009d1:	41 54                	push   %r12
  8009d3:	53                   	push   %rbx
  8009d4:	48 83 ec 60          	sub    $0x60,%rsp
  8009d8:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8009dc:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8009e0:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8009e4:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8009e8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8009ec:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8009f0:	48 8b 0a             	mov    (%rdx),%rcx
  8009f3:	48 89 08             	mov    %rcx,(%rax)
  8009f6:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8009fa:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8009fe:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800a02:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a06:	eb 28                	jmp    800a30 <vprintfmt+0x63>
			if (ch == '\0'){
  800a08:	85 db                	test   %ebx,%ebx
  800a0a:	75 15                	jne    800a21 <vprintfmt+0x54>
				current_color=WHITE;
  800a0c:	48 b8 28 74 80 00 00 	movabs $0x807428,%rax
  800a13:	00 00 00 
  800a16:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  800a1c:	e9 fc 04 00 00       	jmpq   800f1d <vprintfmt+0x550>
				return;
			}
				
			putch(ch, putdat);
  800a21:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a25:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a29:	48 89 d6             	mov    %rdx,%rsi
  800a2c:	89 df                	mov    %ebx,%edi
  800a2e:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a30:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a34:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a38:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a3c:	0f b6 00             	movzbl (%rax),%eax
  800a3f:	0f b6 d8             	movzbl %al,%ebx
  800a42:	83 fb 25             	cmp    $0x25,%ebx
  800a45:	75 c1                	jne    800a08 <vprintfmt+0x3b>
				
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a47:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800a4b:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800a52:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800a59:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800a60:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a67:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800a6b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800a6f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800a73:	0f b6 00             	movzbl (%rax),%eax
  800a76:	0f b6 d8             	movzbl %al,%ebx
  800a79:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800a7c:	83 f8 55             	cmp    $0x55,%eax
  800a7f:	0f 87 64 04 00 00    	ja     800ee9 <vprintfmt+0x51c>
  800a85:	89 c0                	mov    %eax,%eax
  800a87:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800a8e:	00 
  800a8f:	48 b8 f8 47 80 00 00 	movabs $0x8047f8,%rax
  800a96:	00 00 00 
  800a99:	48 01 d0             	add    %rdx,%rax
  800a9c:	48 8b 00             	mov    (%rax),%rax
  800a9f:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800aa1:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800aa5:	eb c0                	jmp    800a67 <vprintfmt+0x9a>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800aa7:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800aab:	eb ba                	jmp    800a67 <vprintfmt+0x9a>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800aad:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800ab4:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800ab7:	89 d0                	mov    %edx,%eax
  800ab9:	c1 e0 02             	shl    $0x2,%eax
  800abc:	01 d0                	add    %edx,%eax
  800abe:	01 c0                	add    %eax,%eax
  800ac0:	01 d8                	add    %ebx,%eax
  800ac2:	83 e8 30             	sub    $0x30,%eax
  800ac5:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800ac8:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800acc:	0f b6 00             	movzbl (%rax),%eax
  800acf:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ad2:	83 fb 2f             	cmp    $0x2f,%ebx
  800ad5:	7e 0c                	jle    800ae3 <vprintfmt+0x116>
  800ad7:	83 fb 39             	cmp    $0x39,%ebx
  800ada:	7f 07                	jg     800ae3 <vprintfmt+0x116>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800adc:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ae1:	eb d1                	jmp    800ab4 <vprintfmt+0xe7>
			goto process_precision;
  800ae3:	eb 58                	jmp    800b3d <vprintfmt+0x170>

		case '*':
			precision = va_arg(aq, int);
  800ae5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ae8:	83 f8 30             	cmp    $0x30,%eax
  800aeb:	73 17                	jae    800b04 <vprintfmt+0x137>
  800aed:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800af1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800af4:	89 c0                	mov    %eax,%eax
  800af6:	48 01 d0             	add    %rdx,%rax
  800af9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800afc:	83 c2 08             	add    $0x8,%edx
  800aff:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b02:	eb 0f                	jmp    800b13 <vprintfmt+0x146>
  800b04:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b08:	48 89 d0             	mov    %rdx,%rax
  800b0b:	48 83 c2 08          	add    $0x8,%rdx
  800b0f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b13:	8b 00                	mov    (%rax),%eax
  800b15:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800b18:	eb 23                	jmp    800b3d <vprintfmt+0x170>

		case '.':
			if (width < 0)
  800b1a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b1e:	79 0c                	jns    800b2c <vprintfmt+0x15f>
				width = 0;
  800b20:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800b27:	e9 3b ff ff ff       	jmpq   800a67 <vprintfmt+0x9a>
  800b2c:	e9 36 ff ff ff       	jmpq   800a67 <vprintfmt+0x9a>

		case '#':
			altflag = 1;
  800b31:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800b38:	e9 2a ff ff ff       	jmpq   800a67 <vprintfmt+0x9a>

		process_precision:
			if (width < 0)
  800b3d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800b41:	79 12                	jns    800b55 <vprintfmt+0x188>
				width = precision, precision = -1;
  800b43:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800b46:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800b49:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800b50:	e9 12 ff ff ff       	jmpq   800a67 <vprintfmt+0x9a>
  800b55:	e9 0d ff ff ff       	jmpq   800a67 <vprintfmt+0x9a>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b5a:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800b5e:	e9 04 ff ff ff       	jmpq   800a67 <vprintfmt+0x9a>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800b63:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b66:	83 f8 30             	cmp    $0x30,%eax
  800b69:	73 17                	jae    800b82 <vprintfmt+0x1b5>
  800b6b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800b6f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b72:	89 c0                	mov    %eax,%eax
  800b74:	48 01 d0             	add    %rdx,%rax
  800b77:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b7a:	83 c2 08             	add    $0x8,%edx
  800b7d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800b80:	eb 0f                	jmp    800b91 <vprintfmt+0x1c4>
  800b82:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800b86:	48 89 d0             	mov    %rdx,%rax
  800b89:	48 83 c2 08          	add    $0x8,%rdx
  800b8d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b91:	8b 10                	mov    (%rax),%edx
  800b93:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800b97:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b9b:	48 89 ce             	mov    %rcx,%rsi
  800b9e:	89 d7                	mov    %edx,%edi
  800ba0:	ff d0                	callq  *%rax
			break;
  800ba2:	e9 70 03 00 00       	jmpq   800f17 <vprintfmt+0x54a>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800ba7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800baa:	83 f8 30             	cmp    $0x30,%eax
  800bad:	73 17                	jae    800bc6 <vprintfmt+0x1f9>
  800baf:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800bb3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800bb6:	89 c0                	mov    %eax,%eax
  800bb8:	48 01 d0             	add    %rdx,%rax
  800bbb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bbe:	83 c2 08             	add    $0x8,%edx
  800bc1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bc4:	eb 0f                	jmp    800bd5 <vprintfmt+0x208>
  800bc6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800bca:	48 89 d0             	mov    %rdx,%rax
  800bcd:	48 83 c2 08          	add    $0x8,%rdx
  800bd1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bd5:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800bd7:	85 db                	test   %ebx,%ebx
  800bd9:	79 02                	jns    800bdd <vprintfmt+0x210>
				err = -err;
  800bdb:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800bdd:	83 fb 15             	cmp    $0x15,%ebx
  800be0:	7f 16                	jg     800bf8 <vprintfmt+0x22b>
  800be2:	48 b8 20 47 80 00 00 	movabs $0x804720,%rax
  800be9:	00 00 00 
  800bec:	48 63 d3             	movslq %ebx,%rdx
  800bef:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800bf3:	4d 85 e4             	test   %r12,%r12
  800bf6:	75 2e                	jne    800c26 <vprintfmt+0x259>
				printfmt(putch, putdat, "error %d", err);
  800bf8:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800bfc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c00:	89 d9                	mov    %ebx,%ecx
  800c02:	48 ba e1 47 80 00 00 	movabs $0x8047e1,%rdx
  800c09:	00 00 00 
  800c0c:	48 89 c7             	mov    %rax,%rdi
  800c0f:	b8 00 00 00 00       	mov    $0x0,%eax
  800c14:	49 b8 26 0f 80 00 00 	movabs $0x800f26,%r8
  800c1b:	00 00 00 
  800c1e:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c21:	e9 f1 02 00 00       	jmpq   800f17 <vprintfmt+0x54a>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c26:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800c2a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c2e:	4c 89 e1             	mov    %r12,%rcx
  800c31:	48 ba ea 47 80 00 00 	movabs $0x8047ea,%rdx
  800c38:	00 00 00 
  800c3b:	48 89 c7             	mov    %rax,%rdi
  800c3e:	b8 00 00 00 00       	mov    $0x0,%eax
  800c43:	49 b8 26 0f 80 00 00 	movabs $0x800f26,%r8
  800c4a:	00 00 00 
  800c4d:	41 ff d0             	callq  *%r8
			break;
  800c50:	e9 c2 02 00 00       	jmpq   800f17 <vprintfmt+0x54a>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800c55:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c58:	83 f8 30             	cmp    $0x30,%eax
  800c5b:	73 17                	jae    800c74 <vprintfmt+0x2a7>
  800c5d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c61:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c64:	89 c0                	mov    %eax,%eax
  800c66:	48 01 d0             	add    %rdx,%rax
  800c69:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c6c:	83 c2 08             	add    $0x8,%edx
  800c6f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c72:	eb 0f                	jmp    800c83 <vprintfmt+0x2b6>
  800c74:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c78:	48 89 d0             	mov    %rdx,%rax
  800c7b:	48 83 c2 08          	add    $0x8,%rdx
  800c7f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c83:	4c 8b 20             	mov    (%rax),%r12
  800c86:	4d 85 e4             	test   %r12,%r12
  800c89:	75 0a                	jne    800c95 <vprintfmt+0x2c8>
				p = "(null)";
  800c8b:	49 bc ed 47 80 00 00 	movabs $0x8047ed,%r12
  800c92:	00 00 00 
			if (width > 0 && padc != '-')
  800c95:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c99:	7e 3f                	jle    800cda <vprintfmt+0x30d>
  800c9b:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800c9f:	74 39                	je     800cda <vprintfmt+0x30d>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ca1:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ca4:	48 98                	cltq   
  800ca6:	48 89 c6             	mov    %rax,%rsi
  800ca9:	4c 89 e7             	mov    %r12,%rdi
  800cac:	48 b8 d2 11 80 00 00 	movabs $0x8011d2,%rax
  800cb3:	00 00 00 
  800cb6:	ff d0                	callq  *%rax
  800cb8:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800cbb:	eb 17                	jmp    800cd4 <vprintfmt+0x307>
					putch(padc, putdat);
  800cbd:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800cc1:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800cc5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cc9:	48 89 ce             	mov    %rcx,%rsi
  800ccc:	89 d7                	mov    %edx,%edi
  800cce:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800cd0:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800cd4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cd8:	7f e3                	jg     800cbd <vprintfmt+0x2f0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cda:	eb 37                	jmp    800d13 <vprintfmt+0x346>
				if (altflag && (ch < ' ' || ch > '~'))
  800cdc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800ce0:	74 1e                	je     800d00 <vprintfmt+0x333>
  800ce2:	83 fb 1f             	cmp    $0x1f,%ebx
  800ce5:	7e 05                	jle    800cec <vprintfmt+0x31f>
  800ce7:	83 fb 7e             	cmp    $0x7e,%ebx
  800cea:	7e 14                	jle    800d00 <vprintfmt+0x333>
					putch('?', putdat);
  800cec:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800cf0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cf4:	48 89 d6             	mov    %rdx,%rsi
  800cf7:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800cfc:	ff d0                	callq  *%rax
  800cfe:	eb 0f                	jmp    800d0f <vprintfmt+0x342>
				else
					putch(ch, putdat);
  800d00:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d04:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d08:	48 89 d6             	mov    %rdx,%rsi
  800d0b:	89 df                	mov    %ebx,%edi
  800d0d:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d0f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d13:	4c 89 e0             	mov    %r12,%rax
  800d16:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800d1a:	0f b6 00             	movzbl (%rax),%eax
  800d1d:	0f be d8             	movsbl %al,%ebx
  800d20:	85 db                	test   %ebx,%ebx
  800d22:	74 10                	je     800d34 <vprintfmt+0x367>
  800d24:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d28:	78 b2                	js     800cdc <vprintfmt+0x30f>
  800d2a:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800d2e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800d32:	79 a8                	jns    800cdc <vprintfmt+0x30f>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d34:	eb 16                	jmp    800d4c <vprintfmt+0x37f>
				putch(' ', putdat);
  800d36:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d3a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d3e:	48 89 d6             	mov    %rdx,%rsi
  800d41:	bf 20 00 00 00       	mov    $0x20,%edi
  800d46:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d48:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d4c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d50:	7f e4                	jg     800d36 <vprintfmt+0x369>
				putch(' ', putdat);
			break;
  800d52:	e9 c0 01 00 00       	jmpq   800f17 <vprintfmt+0x54a>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800d57:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800d5b:	be 03 00 00 00       	mov    $0x3,%esi
  800d60:	48 89 c7             	mov    %rax,%rdi
  800d63:	48 b8 bd 08 80 00 00 	movabs $0x8008bd,%rax
  800d6a:	00 00 00 
  800d6d:	ff d0                	callq  *%rax
  800d6f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800d73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d77:	48 85 c0             	test   %rax,%rax
  800d7a:	79 1d                	jns    800d99 <vprintfmt+0x3cc>
				putch('-', putdat);
  800d7c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d80:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d84:	48 89 d6             	mov    %rdx,%rsi
  800d87:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800d8c:	ff d0                	callq  *%rax
				num = -(long long) num;
  800d8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d92:	48 f7 d8             	neg    %rax
  800d95:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800d99:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800da0:	e9 d5 00 00 00       	jmpq   800e7a <vprintfmt+0x4ad>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800da5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800da9:	be 03 00 00 00       	mov    $0x3,%esi
  800dae:	48 89 c7             	mov    %rax,%rdi
  800db1:	48 b8 ad 07 80 00 00 	movabs $0x8007ad,%rax
  800db8:	00 00 00 
  800dbb:	ff d0                	callq  *%rax
  800dbd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800dc1:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800dc8:	e9 ad 00 00 00       	jmpq   800e7a <vprintfmt+0x4ad>
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			// break;
			num = getuint(&aq, 3);
  800dcd:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800dd1:	be 03 00 00 00       	mov    $0x3,%esi
  800dd6:	48 89 c7             	mov    %rax,%rdi
  800dd9:	48 b8 ad 07 80 00 00 	movabs $0x8007ad,%rax
  800de0:	00 00 00 
  800de3:	ff d0                	callq  *%rax
  800de5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800de9:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800df0:	e9 85 00 00 00       	jmpq   800e7a <vprintfmt+0x4ad>

			// pointer
		case 'p':
			putch('0', putdat);
  800df5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800df9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dfd:	48 89 d6             	mov    %rdx,%rsi
  800e00:	bf 30 00 00 00       	mov    $0x30,%edi
  800e05:	ff d0                	callq  *%rax
			putch('x', putdat);
  800e07:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e0b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e0f:	48 89 d6             	mov    %rdx,%rsi
  800e12:	bf 78 00 00 00       	mov    $0x78,%edi
  800e17:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800e19:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e1c:	83 f8 30             	cmp    $0x30,%eax
  800e1f:	73 17                	jae    800e38 <vprintfmt+0x46b>
  800e21:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e25:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e28:	89 c0                	mov    %eax,%eax
  800e2a:	48 01 d0             	add    %rdx,%rax
  800e2d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e30:	83 c2 08             	add    $0x8,%edx
  800e33:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e36:	eb 0f                	jmp    800e47 <vprintfmt+0x47a>
				(uintptr_t) va_arg(aq, void *);
  800e38:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e3c:	48 89 d0             	mov    %rdx,%rax
  800e3f:	48 83 c2 08          	add    $0x8,%rdx
  800e43:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e47:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e4a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800e4e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800e55:	eb 23                	jmp    800e7a <vprintfmt+0x4ad>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800e57:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e5b:	be 03 00 00 00       	mov    $0x3,%esi
  800e60:	48 89 c7             	mov    %rax,%rdi
  800e63:	48 b8 ad 07 80 00 00 	movabs $0x8007ad,%rax
  800e6a:	00 00 00 
  800e6d:	ff d0                	callq  *%rax
  800e6f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800e73:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e7a:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800e7f:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800e82:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800e85:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800e89:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e8d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e91:	45 89 c1             	mov    %r8d,%r9d
  800e94:	41 89 f8             	mov    %edi,%r8d
  800e97:	48 89 c7             	mov    %rax,%rdi
  800e9a:	48 b8 f2 06 80 00 00 	movabs $0x8006f2,%rax
  800ea1:	00 00 00 
  800ea4:	ff d0                	callq  *%rax
			break;
  800ea6:	eb 6f                	jmp    800f17 <vprintfmt+0x54a>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ea8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800eac:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eb0:	48 89 d6             	mov    %rdx,%rsi
  800eb3:	89 df                	mov    %ebx,%edi
  800eb5:	ff d0                	callq  *%rax
			break;
  800eb7:	eb 5e                	jmp    800f17 <vprintfmt+0x54a>
		
		case 'C':
		    num=getuint(&aq,3);		
  800eb9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ebd:	be 03 00 00 00       	mov    $0x3,%esi
  800ec2:	48 89 c7             	mov    %rax,%rdi
  800ec5:	48 b8 ad 07 80 00 00 	movabs $0x8007ad,%rax
  800ecc:	00 00 00 
  800ecf:	ff d0                	callq  *%rax
  800ed1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			current_color=num;
  800ed5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ed9:	89 c2                	mov    %eax,%edx
  800edb:	48 b8 28 74 80 00 00 	movabs $0x807428,%rax
  800ee2:	00 00 00 
  800ee5:	89 10                	mov    %edx,(%rax)
			break;
  800ee7:	eb 2e                	jmp    800f17 <vprintfmt+0x54a>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ee9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800eed:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ef1:	48 89 d6             	mov    %rdx,%rsi
  800ef4:	bf 25 00 00 00       	mov    $0x25,%edi
  800ef9:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800efb:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f00:	eb 05                	jmp    800f07 <vprintfmt+0x53a>
  800f02:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f07:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f0b:	48 83 e8 01          	sub    $0x1,%rax
  800f0f:	0f b6 00             	movzbl (%rax),%eax
  800f12:	3c 25                	cmp    $0x25,%al
  800f14:	75 ec                	jne    800f02 <vprintfmt+0x535>
				/* do nothing */;
			break;
  800f16:	90                   	nop
		}
	}
  800f17:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f18:	e9 13 fb ff ff       	jmpq   800a30 <vprintfmt+0x63>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800f1d:	48 83 c4 60          	add    $0x60,%rsp
  800f21:	5b                   	pop    %rbx
  800f22:	41 5c                	pop    %r12
  800f24:	5d                   	pop    %rbp
  800f25:	c3                   	retq   

0000000000800f26 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f26:	55                   	push   %rbp
  800f27:	48 89 e5             	mov    %rsp,%rbp
  800f2a:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800f31:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800f38:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800f3f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f46:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f4d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f54:	84 c0                	test   %al,%al
  800f56:	74 20                	je     800f78 <printfmt+0x52>
  800f58:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f5c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f60:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f64:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f68:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f6c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800f70:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800f74:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800f78:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800f7f:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800f86:	00 00 00 
  800f89:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800f90:	00 00 00 
  800f93:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800f97:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800f9e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fa5:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800fac:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800fb3:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800fba:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800fc1:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800fc8:	48 89 c7             	mov    %rax,%rdi
  800fcb:	48 b8 cd 09 80 00 00 	movabs $0x8009cd,%rax
  800fd2:	00 00 00 
  800fd5:	ff d0                	callq  *%rax
	va_end(ap);
}
  800fd7:	c9                   	leaveq 
  800fd8:	c3                   	retq   

0000000000800fd9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fd9:	55                   	push   %rbp
  800fda:	48 89 e5             	mov    %rsp,%rbp
  800fdd:	48 83 ec 10          	sub    $0x10,%rsp
  800fe1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800fe4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800fe8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800fec:	8b 40 10             	mov    0x10(%rax),%eax
  800fef:	8d 50 01             	lea    0x1(%rax),%edx
  800ff2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ff6:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800ff9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ffd:	48 8b 10             	mov    (%rax),%rdx
  801000:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801004:	48 8b 40 08          	mov    0x8(%rax),%rax
  801008:	48 39 c2             	cmp    %rax,%rdx
  80100b:	73 17                	jae    801024 <sprintputch+0x4b>
		*b->buf++ = ch;
  80100d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801011:	48 8b 00             	mov    (%rax),%rax
  801014:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801018:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80101c:	48 89 0a             	mov    %rcx,(%rdx)
  80101f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801022:	88 10                	mov    %dl,(%rax)
}
  801024:	c9                   	leaveq 
  801025:	c3                   	retq   

0000000000801026 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801026:	55                   	push   %rbp
  801027:	48 89 e5             	mov    %rsp,%rbp
  80102a:	48 83 ec 50          	sub    $0x50,%rsp
  80102e:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801032:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801035:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801039:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80103d:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801041:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801045:	48 8b 0a             	mov    (%rdx),%rcx
  801048:	48 89 08             	mov    %rcx,(%rax)
  80104b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80104f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801053:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801057:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80105b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80105f:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801063:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801066:	48 98                	cltq   
  801068:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80106c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801070:	48 01 d0             	add    %rdx,%rax
  801073:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801077:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80107e:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801083:	74 06                	je     80108b <vsnprintf+0x65>
  801085:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801089:	7f 07                	jg     801092 <vsnprintf+0x6c>
		return -E_INVAL;
  80108b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801090:	eb 2f                	jmp    8010c1 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801092:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801096:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80109a:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80109e:	48 89 c6             	mov    %rax,%rsi
  8010a1:	48 bf d9 0f 80 00 00 	movabs $0x800fd9,%rdi
  8010a8:	00 00 00 
  8010ab:	48 b8 cd 09 80 00 00 	movabs $0x8009cd,%rax
  8010b2:	00 00 00 
  8010b5:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8010b7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8010bb:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8010be:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8010c1:	c9                   	leaveq 
  8010c2:	c3                   	retq   

00000000008010c3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010c3:	55                   	push   %rbp
  8010c4:	48 89 e5             	mov    %rsp,%rbp
  8010c7:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8010ce:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8010d5:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8010db:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8010e2:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8010e9:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8010f0:	84 c0                	test   %al,%al
  8010f2:	74 20                	je     801114 <snprintf+0x51>
  8010f4:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8010f8:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8010fc:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801100:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801104:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801108:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80110c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801110:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801114:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  80111b:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801122:	00 00 00 
  801125:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80112c:	00 00 00 
  80112f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801133:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80113a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801141:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801148:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80114f:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801156:	48 8b 0a             	mov    (%rdx),%rcx
  801159:	48 89 08             	mov    %rcx,(%rax)
  80115c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801160:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801164:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801168:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80116c:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801173:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80117a:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801180:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801187:	48 89 c7             	mov    %rax,%rdi
  80118a:	48 b8 26 10 80 00 00 	movabs $0x801026,%rax
  801191:	00 00 00 
  801194:	ff d0                	callq  *%rax
  801196:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80119c:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8011a2:	c9                   	leaveq 
  8011a3:	c3                   	retq   

00000000008011a4 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8011a4:	55                   	push   %rbp
  8011a5:	48 89 e5             	mov    %rsp,%rbp
  8011a8:	48 83 ec 18          	sub    $0x18,%rsp
  8011ac:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8011b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011b7:	eb 09                	jmp    8011c2 <strlen+0x1e>
		n++;
  8011b9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8011bd:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011c6:	0f b6 00             	movzbl (%rax),%eax
  8011c9:	84 c0                	test   %al,%al
  8011cb:	75 ec                	jne    8011b9 <strlen+0x15>
		n++;
	return n;
  8011cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8011d0:	c9                   	leaveq 
  8011d1:	c3                   	retq   

00000000008011d2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8011d2:	55                   	push   %rbp
  8011d3:	48 89 e5             	mov    %rsp,%rbp
  8011d6:	48 83 ec 20          	sub    $0x20,%rsp
  8011da:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011de:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011e2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011e9:	eb 0e                	jmp    8011f9 <strnlen+0x27>
		n++;
  8011eb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011ef:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8011f4:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8011f9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8011fe:	74 0b                	je     80120b <strnlen+0x39>
  801200:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801204:	0f b6 00             	movzbl (%rax),%eax
  801207:	84 c0                	test   %al,%al
  801209:	75 e0                	jne    8011eb <strnlen+0x19>
		n++;
	return n;
  80120b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80120e:	c9                   	leaveq 
  80120f:	c3                   	retq   

0000000000801210 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801210:	55                   	push   %rbp
  801211:	48 89 e5             	mov    %rsp,%rbp
  801214:	48 83 ec 20          	sub    $0x20,%rsp
  801218:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80121c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801220:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801224:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801228:	90                   	nop
  801229:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80122d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801231:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801235:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801239:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80123d:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801241:	0f b6 12             	movzbl (%rdx),%edx
  801244:	88 10                	mov    %dl,(%rax)
  801246:	0f b6 00             	movzbl (%rax),%eax
  801249:	84 c0                	test   %al,%al
  80124b:	75 dc                	jne    801229 <strcpy+0x19>
		/* do nothing */;
	return ret;
  80124d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801251:	c9                   	leaveq 
  801252:	c3                   	retq   

0000000000801253 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801253:	55                   	push   %rbp
  801254:	48 89 e5             	mov    %rsp,%rbp
  801257:	48 83 ec 20          	sub    $0x20,%rsp
  80125b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80125f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801263:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801267:	48 89 c7             	mov    %rax,%rdi
  80126a:	48 b8 a4 11 80 00 00 	movabs $0x8011a4,%rax
  801271:	00 00 00 
  801274:	ff d0                	callq  *%rax
  801276:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801279:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80127c:	48 63 d0             	movslq %eax,%rdx
  80127f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801283:	48 01 c2             	add    %rax,%rdx
  801286:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80128a:	48 89 c6             	mov    %rax,%rsi
  80128d:	48 89 d7             	mov    %rdx,%rdi
  801290:	48 b8 10 12 80 00 00 	movabs $0x801210,%rax
  801297:	00 00 00 
  80129a:	ff d0                	callq  *%rax
	return dst;
  80129c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8012a0:	c9                   	leaveq 
  8012a1:	c3                   	retq   

00000000008012a2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8012a2:	55                   	push   %rbp
  8012a3:	48 89 e5             	mov    %rsp,%rbp
  8012a6:	48 83 ec 28          	sub    $0x28,%rsp
  8012aa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012ae:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8012b2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8012b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012ba:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8012be:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8012c5:	00 
  8012c6:	eb 2a                	jmp    8012f2 <strncpy+0x50>
		*dst++ = *src;
  8012c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012cc:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012d0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012d4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012d8:	0f b6 12             	movzbl (%rdx),%edx
  8012db:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012dd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8012e1:	0f b6 00             	movzbl (%rax),%eax
  8012e4:	84 c0                	test   %al,%al
  8012e6:	74 05                	je     8012ed <strncpy+0x4b>
			src++;
  8012e8:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012ed:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8012f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012f6:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8012fa:	72 cc                	jb     8012c8 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8012fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801300:	c9                   	leaveq 
  801301:	c3                   	retq   

0000000000801302 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801302:	55                   	push   %rbp
  801303:	48 89 e5             	mov    %rsp,%rbp
  801306:	48 83 ec 28          	sub    $0x28,%rsp
  80130a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80130e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801312:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801316:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80131a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80131e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801323:	74 3d                	je     801362 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801325:	eb 1d                	jmp    801344 <strlcpy+0x42>
			*dst++ = *src++;
  801327:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80132b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80132f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801333:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801337:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80133b:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80133f:	0f b6 12             	movzbl (%rdx),%edx
  801342:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801344:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801349:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80134e:	74 0b                	je     80135b <strlcpy+0x59>
  801350:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801354:	0f b6 00             	movzbl (%rax),%eax
  801357:	84 c0                	test   %al,%al
  801359:	75 cc                	jne    801327 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80135b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80135f:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801362:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801366:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80136a:	48 29 c2             	sub    %rax,%rdx
  80136d:	48 89 d0             	mov    %rdx,%rax
}
  801370:	c9                   	leaveq 
  801371:	c3                   	retq   

0000000000801372 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801372:	55                   	push   %rbp
  801373:	48 89 e5             	mov    %rsp,%rbp
  801376:	48 83 ec 10          	sub    $0x10,%rsp
  80137a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80137e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801382:	eb 0a                	jmp    80138e <strcmp+0x1c>
		p++, q++;
  801384:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801389:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80138e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801392:	0f b6 00             	movzbl (%rax),%eax
  801395:	84 c0                	test   %al,%al
  801397:	74 12                	je     8013ab <strcmp+0x39>
  801399:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80139d:	0f b6 10             	movzbl (%rax),%edx
  8013a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013a4:	0f b6 00             	movzbl (%rax),%eax
  8013a7:	38 c2                	cmp    %al,%dl
  8013a9:	74 d9                	je     801384 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013af:	0f b6 00             	movzbl (%rax),%eax
  8013b2:	0f b6 d0             	movzbl %al,%edx
  8013b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013b9:	0f b6 00             	movzbl (%rax),%eax
  8013bc:	0f b6 c0             	movzbl %al,%eax
  8013bf:	29 c2                	sub    %eax,%edx
  8013c1:	89 d0                	mov    %edx,%eax
}
  8013c3:	c9                   	leaveq 
  8013c4:	c3                   	retq   

00000000008013c5 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8013c5:	55                   	push   %rbp
  8013c6:	48 89 e5             	mov    %rsp,%rbp
  8013c9:	48 83 ec 18          	sub    $0x18,%rsp
  8013cd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013d1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8013d5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8013d9:	eb 0f                	jmp    8013ea <strncmp+0x25>
		n--, p++, q++;
  8013db:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8013e0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013e5:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8013ea:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8013ef:	74 1d                	je     80140e <strncmp+0x49>
  8013f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013f5:	0f b6 00             	movzbl (%rax),%eax
  8013f8:	84 c0                	test   %al,%al
  8013fa:	74 12                	je     80140e <strncmp+0x49>
  8013fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801400:	0f b6 10             	movzbl (%rax),%edx
  801403:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801407:	0f b6 00             	movzbl (%rax),%eax
  80140a:	38 c2                	cmp    %al,%dl
  80140c:	74 cd                	je     8013db <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80140e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801413:	75 07                	jne    80141c <strncmp+0x57>
		return 0;
  801415:	b8 00 00 00 00       	mov    $0x0,%eax
  80141a:	eb 18                	jmp    801434 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80141c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801420:	0f b6 00             	movzbl (%rax),%eax
  801423:	0f b6 d0             	movzbl %al,%edx
  801426:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80142a:	0f b6 00             	movzbl (%rax),%eax
  80142d:	0f b6 c0             	movzbl %al,%eax
  801430:	29 c2                	sub    %eax,%edx
  801432:	89 d0                	mov    %edx,%eax
}
  801434:	c9                   	leaveq 
  801435:	c3                   	retq   

0000000000801436 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801436:	55                   	push   %rbp
  801437:	48 89 e5             	mov    %rsp,%rbp
  80143a:	48 83 ec 0c          	sub    $0xc,%rsp
  80143e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801442:	89 f0                	mov    %esi,%eax
  801444:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801447:	eb 17                	jmp    801460 <strchr+0x2a>
		if (*s == c)
  801449:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80144d:	0f b6 00             	movzbl (%rax),%eax
  801450:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801453:	75 06                	jne    80145b <strchr+0x25>
			return (char *) s;
  801455:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801459:	eb 15                	jmp    801470 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80145b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801460:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801464:	0f b6 00             	movzbl (%rax),%eax
  801467:	84 c0                	test   %al,%al
  801469:	75 de                	jne    801449 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80146b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801470:	c9                   	leaveq 
  801471:	c3                   	retq   

0000000000801472 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801472:	55                   	push   %rbp
  801473:	48 89 e5             	mov    %rsp,%rbp
  801476:	48 83 ec 0c          	sub    $0xc,%rsp
  80147a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80147e:	89 f0                	mov    %esi,%eax
  801480:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801483:	eb 13                	jmp    801498 <strfind+0x26>
		if (*s == c)
  801485:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801489:	0f b6 00             	movzbl (%rax),%eax
  80148c:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80148f:	75 02                	jne    801493 <strfind+0x21>
			break;
  801491:	eb 10                	jmp    8014a3 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801493:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801498:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80149c:	0f b6 00             	movzbl (%rax),%eax
  80149f:	84 c0                	test   %al,%al
  8014a1:	75 e2                	jne    801485 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8014a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014a7:	c9                   	leaveq 
  8014a8:	c3                   	retq   

00000000008014a9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8014a9:	55                   	push   %rbp
  8014aa:	48 89 e5             	mov    %rsp,%rbp
  8014ad:	48 83 ec 18          	sub    $0x18,%rsp
  8014b1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014b5:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8014b8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8014bc:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8014c1:	75 06                	jne    8014c9 <memset+0x20>
		return v;
  8014c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c7:	eb 69                	jmp    801532 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8014c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014cd:	83 e0 03             	and    $0x3,%eax
  8014d0:	48 85 c0             	test   %rax,%rax
  8014d3:	75 48                	jne    80151d <memset+0x74>
  8014d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014d9:	83 e0 03             	and    $0x3,%eax
  8014dc:	48 85 c0             	test   %rax,%rax
  8014df:	75 3c                	jne    80151d <memset+0x74>
		c &= 0xFF;
  8014e1:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8014e8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014eb:	c1 e0 18             	shl    $0x18,%eax
  8014ee:	89 c2                	mov    %eax,%edx
  8014f0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014f3:	c1 e0 10             	shl    $0x10,%eax
  8014f6:	09 c2                	or     %eax,%edx
  8014f8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8014fb:	c1 e0 08             	shl    $0x8,%eax
  8014fe:	09 d0                	or     %edx,%eax
  801500:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801503:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801507:	48 c1 e8 02          	shr    $0x2,%rax
  80150b:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80150e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801512:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801515:	48 89 d7             	mov    %rdx,%rdi
  801518:	fc                   	cld    
  801519:	f3 ab                	rep stos %eax,%es:(%rdi)
  80151b:	eb 11                	jmp    80152e <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80151d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801521:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801524:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801528:	48 89 d7             	mov    %rdx,%rdi
  80152b:	fc                   	cld    
  80152c:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80152e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801532:	c9                   	leaveq 
  801533:	c3                   	retq   

0000000000801534 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801534:	55                   	push   %rbp
  801535:	48 89 e5             	mov    %rsp,%rbp
  801538:	48 83 ec 28          	sub    $0x28,%rsp
  80153c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801540:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801544:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801548:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80154c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801550:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801554:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801558:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80155c:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801560:	0f 83 88 00 00 00    	jae    8015ee <memmove+0xba>
  801566:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80156a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80156e:	48 01 d0             	add    %rdx,%rax
  801571:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801575:	76 77                	jbe    8015ee <memmove+0xba>
		s += n;
  801577:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157b:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80157f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801583:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801587:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80158b:	83 e0 03             	and    $0x3,%eax
  80158e:	48 85 c0             	test   %rax,%rax
  801591:	75 3b                	jne    8015ce <memmove+0x9a>
  801593:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801597:	83 e0 03             	and    $0x3,%eax
  80159a:	48 85 c0             	test   %rax,%rax
  80159d:	75 2f                	jne    8015ce <memmove+0x9a>
  80159f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015a3:	83 e0 03             	and    $0x3,%eax
  8015a6:	48 85 c0             	test   %rax,%rax
  8015a9:	75 23                	jne    8015ce <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8015ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015af:	48 83 e8 04          	sub    $0x4,%rax
  8015b3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015b7:	48 83 ea 04          	sub    $0x4,%rdx
  8015bb:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8015bf:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8015c3:	48 89 c7             	mov    %rax,%rdi
  8015c6:	48 89 d6             	mov    %rdx,%rsi
  8015c9:	fd                   	std    
  8015ca:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8015cc:	eb 1d                	jmp    8015eb <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8015ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015d2:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8015d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015da:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8015de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e2:	48 89 d7             	mov    %rdx,%rdi
  8015e5:	48 89 c1             	mov    %rax,%rcx
  8015e8:	fd                   	std    
  8015e9:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8015eb:	fc                   	cld    
  8015ec:	eb 57                	jmp    801645 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8015ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015f2:	83 e0 03             	and    $0x3,%eax
  8015f5:	48 85 c0             	test   %rax,%rax
  8015f8:	75 36                	jne    801630 <memmove+0xfc>
  8015fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015fe:	83 e0 03             	and    $0x3,%eax
  801601:	48 85 c0             	test   %rax,%rax
  801604:	75 2a                	jne    801630 <memmove+0xfc>
  801606:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80160a:	83 e0 03             	and    $0x3,%eax
  80160d:	48 85 c0             	test   %rax,%rax
  801610:	75 1e                	jne    801630 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801612:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801616:	48 c1 e8 02          	shr    $0x2,%rax
  80161a:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80161d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801621:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801625:	48 89 c7             	mov    %rax,%rdi
  801628:	48 89 d6             	mov    %rdx,%rsi
  80162b:	fc                   	cld    
  80162c:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80162e:	eb 15                	jmp    801645 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801630:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801634:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801638:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80163c:	48 89 c7             	mov    %rax,%rdi
  80163f:	48 89 d6             	mov    %rdx,%rsi
  801642:	fc                   	cld    
  801643:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801645:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801649:	c9                   	leaveq 
  80164a:	c3                   	retq   

000000000080164b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80164b:	55                   	push   %rbp
  80164c:	48 89 e5             	mov    %rsp,%rbp
  80164f:	48 83 ec 18          	sub    $0x18,%rsp
  801653:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801657:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80165b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80165f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801663:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801667:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80166b:	48 89 ce             	mov    %rcx,%rsi
  80166e:	48 89 c7             	mov    %rax,%rdi
  801671:	48 b8 34 15 80 00 00 	movabs $0x801534,%rax
  801678:	00 00 00 
  80167b:	ff d0                	callq  *%rax
}
  80167d:	c9                   	leaveq 
  80167e:	c3                   	retq   

000000000080167f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80167f:	55                   	push   %rbp
  801680:	48 89 e5             	mov    %rsp,%rbp
  801683:	48 83 ec 28          	sub    $0x28,%rsp
  801687:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80168b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80168f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801693:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801697:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80169b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80169f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8016a3:	eb 36                	jmp    8016db <memcmp+0x5c>
		if (*s1 != *s2)
  8016a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016a9:	0f b6 10             	movzbl (%rax),%edx
  8016ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016b0:	0f b6 00             	movzbl (%rax),%eax
  8016b3:	38 c2                	cmp    %al,%dl
  8016b5:	74 1a                	je     8016d1 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8016b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016bb:	0f b6 00             	movzbl (%rax),%eax
  8016be:	0f b6 d0             	movzbl %al,%edx
  8016c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016c5:	0f b6 00             	movzbl (%rax),%eax
  8016c8:	0f b6 c0             	movzbl %al,%eax
  8016cb:	29 c2                	sub    %eax,%edx
  8016cd:	89 d0                	mov    %edx,%eax
  8016cf:	eb 20                	jmp    8016f1 <memcmp+0x72>
		s1++, s2++;
  8016d1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016d6:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8016db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016df:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8016e3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8016e7:	48 85 c0             	test   %rax,%rax
  8016ea:	75 b9                	jne    8016a5 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016f1:	c9                   	leaveq 
  8016f2:	c3                   	retq   

00000000008016f3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8016f3:	55                   	push   %rbp
  8016f4:	48 89 e5             	mov    %rsp,%rbp
  8016f7:	48 83 ec 28          	sub    $0x28,%rsp
  8016fb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016ff:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801702:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801706:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80170a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80170e:	48 01 d0             	add    %rdx,%rax
  801711:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801715:	eb 15                	jmp    80172c <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  801717:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80171b:	0f b6 10             	movzbl (%rax),%edx
  80171e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801721:	38 c2                	cmp    %al,%dl
  801723:	75 02                	jne    801727 <memfind+0x34>
			break;
  801725:	eb 0f                	jmp    801736 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801727:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80172c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801730:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801734:	72 e1                	jb     801717 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  801736:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80173a:	c9                   	leaveq 
  80173b:	c3                   	retq   

000000000080173c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80173c:	55                   	push   %rbp
  80173d:	48 89 e5             	mov    %rsp,%rbp
  801740:	48 83 ec 34          	sub    $0x34,%rsp
  801744:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801748:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80174c:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80174f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801756:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80175d:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80175e:	eb 05                	jmp    801765 <strtol+0x29>
		s++;
  801760:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801765:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801769:	0f b6 00             	movzbl (%rax),%eax
  80176c:	3c 20                	cmp    $0x20,%al
  80176e:	74 f0                	je     801760 <strtol+0x24>
  801770:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801774:	0f b6 00             	movzbl (%rax),%eax
  801777:	3c 09                	cmp    $0x9,%al
  801779:	74 e5                	je     801760 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80177b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177f:	0f b6 00             	movzbl (%rax),%eax
  801782:	3c 2b                	cmp    $0x2b,%al
  801784:	75 07                	jne    80178d <strtol+0x51>
		s++;
  801786:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80178b:	eb 17                	jmp    8017a4 <strtol+0x68>
	else if (*s == '-')
  80178d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801791:	0f b6 00             	movzbl (%rax),%eax
  801794:	3c 2d                	cmp    $0x2d,%al
  801796:	75 0c                	jne    8017a4 <strtol+0x68>
		s++, neg = 1;
  801798:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80179d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017a4:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017a8:	74 06                	je     8017b0 <strtol+0x74>
  8017aa:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8017ae:	75 28                	jne    8017d8 <strtol+0x9c>
  8017b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017b4:	0f b6 00             	movzbl (%rax),%eax
  8017b7:	3c 30                	cmp    $0x30,%al
  8017b9:	75 1d                	jne    8017d8 <strtol+0x9c>
  8017bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017bf:	48 83 c0 01          	add    $0x1,%rax
  8017c3:	0f b6 00             	movzbl (%rax),%eax
  8017c6:	3c 78                	cmp    $0x78,%al
  8017c8:	75 0e                	jne    8017d8 <strtol+0x9c>
		s += 2, base = 16;
  8017ca:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8017cf:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8017d6:	eb 2c                	jmp    801804 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8017d8:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017dc:	75 19                	jne    8017f7 <strtol+0xbb>
  8017de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e2:	0f b6 00             	movzbl (%rax),%eax
  8017e5:	3c 30                	cmp    $0x30,%al
  8017e7:	75 0e                	jne    8017f7 <strtol+0xbb>
		s++, base = 8;
  8017e9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8017ee:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8017f5:	eb 0d                	jmp    801804 <strtol+0xc8>
	else if (base == 0)
  8017f7:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8017fb:	75 07                	jne    801804 <strtol+0xc8>
		base = 10;
  8017fd:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801804:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801808:	0f b6 00             	movzbl (%rax),%eax
  80180b:	3c 2f                	cmp    $0x2f,%al
  80180d:	7e 1d                	jle    80182c <strtol+0xf0>
  80180f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801813:	0f b6 00             	movzbl (%rax),%eax
  801816:	3c 39                	cmp    $0x39,%al
  801818:	7f 12                	jg     80182c <strtol+0xf0>
			dig = *s - '0';
  80181a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80181e:	0f b6 00             	movzbl (%rax),%eax
  801821:	0f be c0             	movsbl %al,%eax
  801824:	83 e8 30             	sub    $0x30,%eax
  801827:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80182a:	eb 4e                	jmp    80187a <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80182c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801830:	0f b6 00             	movzbl (%rax),%eax
  801833:	3c 60                	cmp    $0x60,%al
  801835:	7e 1d                	jle    801854 <strtol+0x118>
  801837:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80183b:	0f b6 00             	movzbl (%rax),%eax
  80183e:	3c 7a                	cmp    $0x7a,%al
  801840:	7f 12                	jg     801854 <strtol+0x118>
			dig = *s - 'a' + 10;
  801842:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801846:	0f b6 00             	movzbl (%rax),%eax
  801849:	0f be c0             	movsbl %al,%eax
  80184c:	83 e8 57             	sub    $0x57,%eax
  80184f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801852:	eb 26                	jmp    80187a <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801854:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801858:	0f b6 00             	movzbl (%rax),%eax
  80185b:	3c 40                	cmp    $0x40,%al
  80185d:	7e 48                	jle    8018a7 <strtol+0x16b>
  80185f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801863:	0f b6 00             	movzbl (%rax),%eax
  801866:	3c 5a                	cmp    $0x5a,%al
  801868:	7f 3d                	jg     8018a7 <strtol+0x16b>
			dig = *s - 'A' + 10;
  80186a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80186e:	0f b6 00             	movzbl (%rax),%eax
  801871:	0f be c0             	movsbl %al,%eax
  801874:	83 e8 37             	sub    $0x37,%eax
  801877:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80187a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80187d:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801880:	7c 02                	jl     801884 <strtol+0x148>
			break;
  801882:	eb 23                	jmp    8018a7 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801884:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801889:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80188c:	48 98                	cltq   
  80188e:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801893:	48 89 c2             	mov    %rax,%rdx
  801896:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801899:	48 98                	cltq   
  80189b:	48 01 d0             	add    %rdx,%rax
  80189e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8018a2:	e9 5d ff ff ff       	jmpq   801804 <strtol+0xc8>

	if (endptr)
  8018a7:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8018ac:	74 0b                	je     8018b9 <strtol+0x17d>
		*endptr = (char *) s;
  8018ae:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018b2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8018b6:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8018b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8018bd:	74 09                	je     8018c8 <strtol+0x18c>
  8018bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018c3:	48 f7 d8             	neg    %rax
  8018c6:	eb 04                	jmp    8018cc <strtol+0x190>
  8018c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8018cc:	c9                   	leaveq 
  8018cd:	c3                   	retq   

00000000008018ce <strstr>:

char * strstr(const char *in, const char *str)
{
  8018ce:	55                   	push   %rbp
  8018cf:	48 89 e5             	mov    %rsp,%rbp
  8018d2:	48 83 ec 30          	sub    $0x30,%rsp
  8018d6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018da:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8018de:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8018e2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018e6:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8018ea:	0f b6 00             	movzbl (%rax),%eax
  8018ed:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8018f0:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8018f4:	75 06                	jne    8018fc <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8018f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018fa:	eb 6b                	jmp    801967 <strstr+0x99>

	len = strlen(str);
  8018fc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801900:	48 89 c7             	mov    %rax,%rdi
  801903:	48 b8 a4 11 80 00 00 	movabs $0x8011a4,%rax
  80190a:	00 00 00 
  80190d:	ff d0                	callq  *%rax
  80190f:	48 98                	cltq   
  801911:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801915:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801919:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80191d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801921:	0f b6 00             	movzbl (%rax),%eax
  801924:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801927:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80192b:	75 07                	jne    801934 <strstr+0x66>
				return (char *) 0;
  80192d:	b8 00 00 00 00       	mov    $0x0,%eax
  801932:	eb 33                	jmp    801967 <strstr+0x99>
		} while (sc != c);
  801934:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801938:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80193b:	75 d8                	jne    801915 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80193d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801941:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801945:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801949:	48 89 ce             	mov    %rcx,%rsi
  80194c:	48 89 c7             	mov    %rax,%rdi
  80194f:	48 b8 c5 13 80 00 00 	movabs $0x8013c5,%rax
  801956:	00 00 00 
  801959:	ff d0                	callq  *%rax
  80195b:	85 c0                	test   %eax,%eax
  80195d:	75 b6                	jne    801915 <strstr+0x47>

	return (char *) (in - 1);
  80195f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801963:	48 83 e8 01          	sub    $0x1,%rax
}
  801967:	c9                   	leaveq 
  801968:	c3                   	retq   

0000000000801969 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801969:	55                   	push   %rbp
  80196a:	48 89 e5             	mov    %rsp,%rbp
  80196d:	53                   	push   %rbx
  80196e:	48 83 ec 48          	sub    $0x48,%rsp
  801972:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801975:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801978:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80197c:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801980:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801984:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801988:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80198b:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80198f:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801993:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801997:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80199b:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  80199f:	4c 89 c3             	mov    %r8,%rbx
  8019a2:	cd 30                	int    $0x30
  8019a4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8019a8:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8019ac:	74 3e                	je     8019ec <syscall+0x83>
  8019ae:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8019b3:	7e 37                	jle    8019ec <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8019b5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8019b9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8019bc:	49 89 d0             	mov    %rdx,%r8
  8019bf:	89 c1                	mov    %eax,%ecx
  8019c1:	48 ba a8 4a 80 00 00 	movabs $0x804aa8,%rdx
  8019c8:	00 00 00 
  8019cb:	be 23 00 00 00       	mov    $0x23,%esi
  8019d0:	48 bf c5 4a 80 00 00 	movabs $0x804ac5,%rdi
  8019d7:	00 00 00 
  8019da:	b8 00 00 00 00       	mov    $0x0,%eax
  8019df:	49 b9 e1 03 80 00 00 	movabs $0x8003e1,%r9
  8019e6:	00 00 00 
  8019e9:	41 ff d1             	callq  *%r9

	return ret;
  8019ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8019f0:	48 83 c4 48          	add    $0x48,%rsp
  8019f4:	5b                   	pop    %rbx
  8019f5:	5d                   	pop    %rbp
  8019f6:	c3                   	retq   

00000000008019f7 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8019f7:	55                   	push   %rbp
  8019f8:	48 89 e5             	mov    %rsp,%rbp
  8019fb:	48 83 ec 20          	sub    $0x20,%rsp
  8019ff:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a03:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801a07:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a0b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a0f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a16:	00 
  801a17:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a1d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a23:	48 89 d1             	mov    %rdx,%rcx
  801a26:	48 89 c2             	mov    %rax,%rdx
  801a29:	be 00 00 00 00       	mov    $0x0,%esi
  801a2e:	bf 00 00 00 00       	mov    $0x0,%edi
  801a33:	48 b8 69 19 80 00 00 	movabs $0x801969,%rax
  801a3a:	00 00 00 
  801a3d:	ff d0                	callq  *%rax
}
  801a3f:	c9                   	leaveq 
  801a40:	c3                   	retq   

0000000000801a41 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a41:	55                   	push   %rbp
  801a42:	48 89 e5             	mov    %rsp,%rbp
  801a45:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801a49:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a50:	00 
  801a51:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a57:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a5d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a62:	ba 00 00 00 00       	mov    $0x0,%edx
  801a67:	be 00 00 00 00       	mov    $0x0,%esi
  801a6c:	bf 01 00 00 00       	mov    $0x1,%edi
  801a71:	48 b8 69 19 80 00 00 	movabs $0x801969,%rax
  801a78:	00 00 00 
  801a7b:	ff d0                	callq  *%rax
}
  801a7d:	c9                   	leaveq 
  801a7e:	c3                   	retq   

0000000000801a7f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801a7f:	55                   	push   %rbp
  801a80:	48 89 e5             	mov    %rsp,%rbp
  801a83:	48 83 ec 10          	sub    $0x10,%rsp
  801a87:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801a8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a8d:	48 98                	cltq   
  801a8f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801a96:	00 
  801a97:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a9d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aa3:	b9 00 00 00 00       	mov    $0x0,%ecx
  801aa8:	48 89 c2             	mov    %rax,%rdx
  801aab:	be 01 00 00 00       	mov    $0x1,%esi
  801ab0:	bf 03 00 00 00       	mov    $0x3,%edi
  801ab5:	48 b8 69 19 80 00 00 	movabs $0x801969,%rax
  801abc:	00 00 00 
  801abf:	ff d0                	callq  *%rax
}
  801ac1:	c9                   	leaveq 
  801ac2:	c3                   	retq   

0000000000801ac3 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801ac3:	55                   	push   %rbp
  801ac4:	48 89 e5             	mov    %rsp,%rbp
  801ac7:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801acb:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ad2:	00 
  801ad3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ad9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801adf:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ae4:	ba 00 00 00 00       	mov    $0x0,%edx
  801ae9:	be 00 00 00 00       	mov    $0x0,%esi
  801aee:	bf 02 00 00 00       	mov    $0x2,%edi
  801af3:	48 b8 69 19 80 00 00 	movabs $0x801969,%rax
  801afa:	00 00 00 
  801afd:	ff d0                	callq  *%rax
}
  801aff:	c9                   	leaveq 
  801b00:	c3                   	retq   

0000000000801b01 <sys_yield>:

void
sys_yield(void)
{
  801b01:	55                   	push   %rbp
  801b02:	48 89 e5             	mov    %rsp,%rbp
  801b05:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801b09:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b10:	00 
  801b11:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b17:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b1d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b22:	ba 00 00 00 00       	mov    $0x0,%edx
  801b27:	be 00 00 00 00       	mov    $0x0,%esi
  801b2c:	bf 0b 00 00 00       	mov    $0xb,%edi
  801b31:	48 b8 69 19 80 00 00 	movabs $0x801969,%rax
  801b38:	00 00 00 
  801b3b:	ff d0                	callq  *%rax
}
  801b3d:	c9                   	leaveq 
  801b3e:	c3                   	retq   

0000000000801b3f <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801b3f:	55                   	push   %rbp
  801b40:	48 89 e5             	mov    %rsp,%rbp
  801b43:	48 83 ec 20          	sub    $0x20,%rsp
  801b47:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b4a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b4e:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801b51:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b54:	48 63 c8             	movslq %eax,%rcx
  801b57:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b5b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b5e:	48 98                	cltq   
  801b60:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801b67:	00 
  801b68:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b6e:	49 89 c8             	mov    %rcx,%r8
  801b71:	48 89 d1             	mov    %rdx,%rcx
  801b74:	48 89 c2             	mov    %rax,%rdx
  801b77:	be 01 00 00 00       	mov    $0x1,%esi
  801b7c:	bf 04 00 00 00       	mov    $0x4,%edi
  801b81:	48 b8 69 19 80 00 00 	movabs $0x801969,%rax
  801b88:	00 00 00 
  801b8b:	ff d0                	callq  *%rax
}
  801b8d:	c9                   	leaveq 
  801b8e:	c3                   	retq   

0000000000801b8f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801b8f:	55                   	push   %rbp
  801b90:	48 89 e5             	mov    %rsp,%rbp
  801b93:	48 83 ec 30          	sub    $0x30,%rsp
  801b97:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801b9a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b9e:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801ba1:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801ba5:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801ba9:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801bac:	48 63 c8             	movslq %eax,%rcx
  801baf:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801bb3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bb6:	48 63 f0             	movslq %eax,%rsi
  801bb9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bbd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bc0:	48 98                	cltq   
  801bc2:	48 89 0c 24          	mov    %rcx,(%rsp)
  801bc6:	49 89 f9             	mov    %rdi,%r9
  801bc9:	49 89 f0             	mov    %rsi,%r8
  801bcc:	48 89 d1             	mov    %rdx,%rcx
  801bcf:	48 89 c2             	mov    %rax,%rdx
  801bd2:	be 01 00 00 00       	mov    $0x1,%esi
  801bd7:	bf 05 00 00 00       	mov    $0x5,%edi
  801bdc:	48 b8 69 19 80 00 00 	movabs $0x801969,%rax
  801be3:	00 00 00 
  801be6:	ff d0                	callq  *%rax
}
  801be8:	c9                   	leaveq 
  801be9:	c3                   	retq   

0000000000801bea <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801bea:	55                   	push   %rbp
  801beb:	48 89 e5             	mov    %rsp,%rbp
  801bee:	48 83 ec 20          	sub    $0x20,%rsp
  801bf2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bf5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801bf9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bfd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c00:	48 98                	cltq   
  801c02:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c09:	00 
  801c0a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c10:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c16:	48 89 d1             	mov    %rdx,%rcx
  801c19:	48 89 c2             	mov    %rax,%rdx
  801c1c:	be 01 00 00 00       	mov    $0x1,%esi
  801c21:	bf 06 00 00 00       	mov    $0x6,%edi
  801c26:	48 b8 69 19 80 00 00 	movabs $0x801969,%rax
  801c2d:	00 00 00 
  801c30:	ff d0                	callq  *%rax
}
  801c32:	c9                   	leaveq 
  801c33:	c3                   	retq   

0000000000801c34 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801c34:	55                   	push   %rbp
  801c35:	48 89 e5             	mov    %rsp,%rbp
  801c38:	48 83 ec 10          	sub    $0x10,%rsp
  801c3c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c3f:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801c42:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c45:	48 63 d0             	movslq %eax,%rdx
  801c48:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c4b:	48 98                	cltq   
  801c4d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c54:	00 
  801c55:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c5b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c61:	48 89 d1             	mov    %rdx,%rcx
  801c64:	48 89 c2             	mov    %rax,%rdx
  801c67:	be 01 00 00 00       	mov    $0x1,%esi
  801c6c:	bf 08 00 00 00       	mov    $0x8,%edi
  801c71:	48 b8 69 19 80 00 00 	movabs $0x801969,%rax
  801c78:	00 00 00 
  801c7b:	ff d0                	callq  *%rax
}
  801c7d:	c9                   	leaveq 
  801c7e:	c3                   	retq   

0000000000801c7f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801c7f:	55                   	push   %rbp
  801c80:	48 89 e5             	mov    %rsp,%rbp
  801c83:	48 83 ec 20          	sub    $0x20,%rsp
  801c87:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c8a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801c8e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c92:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c95:	48 98                	cltq   
  801c97:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c9e:	00 
  801c9f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ca5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cab:	48 89 d1             	mov    %rdx,%rcx
  801cae:	48 89 c2             	mov    %rax,%rdx
  801cb1:	be 01 00 00 00       	mov    $0x1,%esi
  801cb6:	bf 09 00 00 00       	mov    $0x9,%edi
  801cbb:	48 b8 69 19 80 00 00 	movabs $0x801969,%rax
  801cc2:	00 00 00 
  801cc5:	ff d0                	callq  *%rax
}
  801cc7:	c9                   	leaveq 
  801cc8:	c3                   	retq   

0000000000801cc9 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801cc9:	55                   	push   %rbp
  801cca:	48 89 e5             	mov    %rsp,%rbp
  801ccd:	48 83 ec 20          	sub    $0x20,%rsp
  801cd1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cd4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801cd8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cdc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cdf:	48 98                	cltq   
  801ce1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ce8:	00 
  801ce9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cef:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cf5:	48 89 d1             	mov    %rdx,%rcx
  801cf8:	48 89 c2             	mov    %rax,%rdx
  801cfb:	be 01 00 00 00       	mov    $0x1,%esi
  801d00:	bf 0a 00 00 00       	mov    $0xa,%edi
  801d05:	48 b8 69 19 80 00 00 	movabs $0x801969,%rax
  801d0c:	00 00 00 
  801d0f:	ff d0                	callq  *%rax
}
  801d11:	c9                   	leaveq 
  801d12:	c3                   	retq   

0000000000801d13 <sys_set_priority>:

void
sys_set_priority(envid_t envid, int priority)
{
  801d13:	55                   	push   %rbp
  801d14:	48 89 e5             	mov    %rsp,%rbp
  801d17:	48 83 ec 10          	sub    $0x10,%rsp
  801d1b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d1e:	89 75 f8             	mov    %esi,-0x8(%rbp)
	syscall(SYS_set_priority,1,envid,priority,0,0,0);
  801d21:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d24:	48 63 d0             	movslq %eax,%rdx
  801d27:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d2a:	48 98                	cltq   
  801d2c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d33:	00 
  801d34:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d3a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d40:	48 89 d1             	mov    %rdx,%rcx
  801d43:	48 89 c2             	mov    %rax,%rdx
  801d46:	be 01 00 00 00       	mov    $0x1,%esi
  801d4b:	bf 11 00 00 00       	mov    $0x11,%edi
  801d50:	48 b8 69 19 80 00 00 	movabs $0x801969,%rax
  801d57:	00 00 00 
  801d5a:	ff d0                	callq  *%rax

}
  801d5c:	c9                   	leaveq 
  801d5d:	c3                   	retq   

0000000000801d5e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801d5e:	55                   	push   %rbp
  801d5f:	48 89 e5             	mov    %rsp,%rbp
  801d62:	48 83 ec 20          	sub    $0x20,%rsp
  801d66:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d69:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d6d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801d71:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801d74:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d77:	48 63 f0             	movslq %eax,%rsi
  801d7a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801d7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d81:	48 98                	cltq   
  801d83:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d87:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d8e:	00 
  801d8f:	49 89 f1             	mov    %rsi,%r9
  801d92:	49 89 c8             	mov    %rcx,%r8
  801d95:	48 89 d1             	mov    %rdx,%rcx
  801d98:	48 89 c2             	mov    %rax,%rdx
  801d9b:	be 00 00 00 00       	mov    $0x0,%esi
  801da0:	bf 0c 00 00 00       	mov    $0xc,%edi
  801da5:	48 b8 69 19 80 00 00 	movabs $0x801969,%rax
  801dac:	00 00 00 
  801daf:	ff d0                	callq  *%rax
}
  801db1:	c9                   	leaveq 
  801db2:	c3                   	retq   

0000000000801db3 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801db3:	55                   	push   %rbp
  801db4:	48 89 e5             	mov    %rsp,%rbp
  801db7:	48 83 ec 10          	sub    $0x10,%rsp
  801dbb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801dbf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dc3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801dca:	00 
  801dcb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dd1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dd7:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ddc:	48 89 c2             	mov    %rax,%rdx
  801ddf:	be 01 00 00 00       	mov    $0x1,%esi
  801de4:	bf 0d 00 00 00       	mov    $0xd,%edi
  801de9:	48 b8 69 19 80 00 00 	movabs $0x801969,%rax
  801df0:	00 00 00 
  801df3:	ff d0                	callq  *%rax
}
  801df5:	c9                   	leaveq 
  801df6:	c3                   	retq   

0000000000801df7 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801df7:	55                   	push   %rbp
  801df8:	48 89 e5             	mov    %rsp,%rbp
  801dfb:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801dff:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e06:	00 
  801e07:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e0d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e13:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e18:	ba 00 00 00 00       	mov    $0x0,%edx
  801e1d:	be 00 00 00 00       	mov    $0x0,%esi
  801e22:	bf 0e 00 00 00       	mov    $0xe,%edi
  801e27:	48 b8 69 19 80 00 00 	movabs $0x801969,%rax
  801e2e:	00 00 00 
  801e31:	ff d0                	callq  *%rax
}
  801e33:	c9                   	leaveq 
  801e34:	c3                   	retq   

0000000000801e35 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801e35:	55                   	push   %rbp
  801e36:	48 89 e5             	mov    %rsp,%rbp
  801e39:	48 83 ec 30          	sub    $0x30,%rsp
  801e3d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e40:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e44:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801e47:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801e4b:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801e4f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801e52:	48 63 c8             	movslq %eax,%rcx
  801e55:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801e59:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e5c:	48 63 f0             	movslq %eax,%rsi
  801e5f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e66:	48 98                	cltq   
  801e68:	48 89 0c 24          	mov    %rcx,(%rsp)
  801e6c:	49 89 f9             	mov    %rdi,%r9
  801e6f:	49 89 f0             	mov    %rsi,%r8
  801e72:	48 89 d1             	mov    %rdx,%rcx
  801e75:	48 89 c2             	mov    %rax,%rdx
  801e78:	be 00 00 00 00       	mov    $0x0,%esi
  801e7d:	bf 0f 00 00 00       	mov    $0xf,%edi
  801e82:	48 b8 69 19 80 00 00 	movabs $0x801969,%rax
  801e89:	00 00 00 
  801e8c:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801e8e:	c9                   	leaveq 
  801e8f:	c3                   	retq   

0000000000801e90 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801e90:	55                   	push   %rbp
  801e91:	48 89 e5             	mov    %rsp,%rbp
  801e94:	48 83 ec 20          	sub    $0x20,%rsp
  801e98:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e9c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801ea0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ea4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ea8:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801eaf:	00 
  801eb0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801eb6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ebc:	48 89 d1             	mov    %rdx,%rcx
  801ebf:	48 89 c2             	mov    %rax,%rdx
  801ec2:	be 00 00 00 00       	mov    $0x0,%esi
  801ec7:	bf 10 00 00 00       	mov    $0x10,%edi
  801ecc:	48 b8 69 19 80 00 00 	movabs $0x801969,%rax
  801ed3:	00 00 00 
  801ed6:	ff d0                	callq  *%rax
}
  801ed8:	c9                   	leaveq 
  801ed9:	c3                   	retq   

0000000000801eda <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801eda:	55                   	push   %rbp
  801edb:	48 89 e5             	mov    %rsp,%rbp
  801ede:	48 83 ec 30          	sub    $0x30,%rsp
  801ee2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)



	void *addr = (void *) utf->utf_fault_va;
  801ee6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eea:	48 8b 00             	mov    (%rax),%rax
  801eed:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  801ef1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ef5:	48 8b 40 08          	mov    0x8(%rax),%rax
  801ef9:	89 45 f4             	mov    %eax,-0xc(%rbp)
        // Hint:
        //   Use the read-only page table mappings at vpt
        //   (see <inc/memlayout.h>).

        // LAB 4: Your code here.
	if (!(err&FEC_WR))
  801efc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801eff:	83 e0 02             	and    $0x2,%eax
  801f02:	85 c0                	test   %eax,%eax
  801f04:	75 2a                	jne    801f30 <pgfault+0x56>
		panic("pgfault:FEC_WR check\n");
  801f06:	48 ba d8 4a 80 00 00 	movabs $0x804ad8,%rdx
  801f0d:	00 00 00 
  801f10:	be 21 00 00 00       	mov    $0x21,%esi
  801f15:	48 bf ee 4a 80 00 00 	movabs $0x804aee,%rdi
  801f1c:	00 00 00 
  801f1f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f24:	48 b9 e1 03 80 00 00 	movabs $0x8003e1,%rcx
  801f2b:	00 00 00 
  801f2e:	ff d1                	callq  *%rcx
	if (!(uvpt[((uint64_t)addr) / PGSIZE] & PTE_COW))
  801f30:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f34:	48 c1 e8 0c          	shr    $0xc,%rax
  801f38:	48 89 c2             	mov    %rax,%rdx
  801f3b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f42:	01 00 00 
  801f45:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f49:	25 00 08 00 00       	and    $0x800,%eax
  801f4e:	48 85 c0             	test   %rax,%rax
  801f51:	75 2a                	jne    801f7d <pgfault+0xa3>
		panic("pgfault:PTE_COW check\n");
  801f53:	48 ba f9 4a 80 00 00 	movabs $0x804af9,%rdx
  801f5a:	00 00 00 
  801f5d:	be 23 00 00 00       	mov    $0x23,%esi
  801f62:	48 bf ee 4a 80 00 00 	movabs $0x804aee,%rdi
  801f69:	00 00 00 
  801f6c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f71:	48 b9 e1 03 80 00 00 	movabs $0x8003e1,%rcx
  801f78:	00 00 00 
  801f7b:	ff d1                	callq  *%rcx
        // Hint:
        //   You should make three system calls.
        //   No need to explicitly delete the old page's mapping.

        // LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  801f7d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f81:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801f85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801f89:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  801f8f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (sys_page_alloc(0, (void*)PFTEMP, PTE_P|PTE_W|PTE_U)<0)
  801f93:	ba 07 00 00 00       	mov    $0x7,%edx
  801f98:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  801f9d:	bf 00 00 00 00       	mov    $0x0,%edi
  801fa2:	48 b8 3f 1b 80 00 00 	movabs $0x801b3f,%rax
  801fa9:	00 00 00 
  801fac:	ff d0                	callq  *%rax
  801fae:	85 c0                	test   %eax,%eax
  801fb0:	79 2a                	jns    801fdc <pgfault+0x102>
		panic("pgfault: sys_page_alloc error\n");
  801fb2:	48 ba 10 4b 80 00 00 	movabs $0x804b10,%rdx
  801fb9:	00 00 00 
  801fbc:	be 2f 00 00 00       	mov    $0x2f,%esi
  801fc1:	48 bf ee 4a 80 00 00 	movabs $0x804aee,%rdi
  801fc8:	00 00 00 
  801fcb:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd0:	48 b9 e1 03 80 00 00 	movabs $0x8003e1,%rcx
  801fd7:	00 00 00 
  801fda:	ff d1                	callq  *%rcx
	memcpy(PFTEMP, addr, PGSIZE);
  801fdc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fe0:	ba 00 10 00 00       	mov    $0x1000,%edx
  801fe5:	48 89 c6             	mov    %rax,%rsi
  801fe8:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  801fed:	48 b8 4b 16 80 00 00 	movabs $0x80164b,%rax
  801ff4:	00 00 00 
  801ff7:	ff d0                	callq  *%rax
	if (sys_page_map(0, (void*)PFTEMP, 0, addr, PTE_P|PTE_W|PTE_U) < 0)
  801ff9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ffd:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802003:	48 89 c1             	mov    %rax,%rcx
  802006:	ba 00 00 00 00       	mov    $0x0,%edx
  80200b:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802010:	bf 00 00 00 00       	mov    $0x0,%edi
  802015:	48 b8 8f 1b 80 00 00 	movabs $0x801b8f,%rax
  80201c:	00 00 00 
  80201f:	ff d0                	callq  *%rax
  802021:	85 c0                	test   %eax,%eax
  802023:	79 2a                	jns    80204f <pgfault+0x175>
		panic("pgfault: sys_page_map error\n");
  802025:	48 ba 2f 4b 80 00 00 	movabs $0x804b2f,%rdx
  80202c:	00 00 00 
  80202f:	be 32 00 00 00       	mov    $0x32,%esi
  802034:	48 bf ee 4a 80 00 00 	movabs $0x804aee,%rdi
  80203b:	00 00 00 
  80203e:	b8 00 00 00 00       	mov    $0x0,%eax
  802043:	48 b9 e1 03 80 00 00 	movabs $0x8003e1,%rcx
  80204a:	00 00 00 
  80204d:	ff d1                	callq  *%rcx

	if (sys_page_unmap(0, (void *)PFTEMP)<0)
  80204f:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802054:	bf 00 00 00 00       	mov    $0x0,%edi
  802059:	48 b8 ea 1b 80 00 00 	movabs $0x801bea,%rax
  802060:	00 00 00 
  802063:	ff d0                	callq  *%rax
  802065:	85 c0                	test   %eax,%eax
  802067:	79 2a                	jns    802093 <pgfault+0x1b9>
		panic("pgfault: sys_page_unmap error\n");
  802069:	48 ba 50 4b 80 00 00 	movabs $0x804b50,%rdx
  802070:	00 00 00 
  802073:	be 35 00 00 00       	mov    $0x35,%esi
  802078:	48 bf ee 4a 80 00 00 	movabs $0x804aee,%rdi
  80207f:	00 00 00 
  802082:	b8 00 00 00 00       	mov    $0x0,%eax
  802087:	48 b9 e1 03 80 00 00 	movabs $0x8003e1,%rcx
  80208e:	00 00 00 
  802091:	ff d1                	callq  *%rcx
	


}
  802093:	c9                   	leaveq 
  802094:	c3                   	retq   

0000000000802095 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  802095:	55                   	push   %rbp
  802096:	48 89 e5             	mov    %rsp,%rbp
  802099:	48 83 ec 10          	sub    $0x10,%rsp
  80209d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8020a0:	89 75 f8             	mov    %esi,-0x8(%rbp)

	if (uvpt[pn] & PTE_SHARE){
  8020a3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020aa:	01 00 00 
  8020ad:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8020b0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020b4:	25 00 04 00 00       	and    $0x400,%eax
  8020b9:	48 85 c0             	test   %rax,%rax
  8020bc:	74 75                	je     802133 <duppage+0x9e>
		if (sys_page_map (0, (void*) ((uint64_t)pn * PGSIZE), envid, (void*) ((uint64_t)pn * PGSIZE), uvpt[pn] & PTE_SYSCALL)<0)
  8020be:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020c5:	01 00 00 
  8020c8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8020cb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020cf:	25 07 0e 00 00       	and    $0xe07,%eax
  8020d4:	89 c6                	mov    %eax,%esi
  8020d6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8020d9:	48 c1 e0 0c          	shl    $0xc,%rax
  8020dd:	48 89 c1             	mov    %rax,%rcx
  8020e0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8020e3:	48 c1 e0 0c          	shl    $0xc,%rax
  8020e7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8020ea:	41 89 f0             	mov    %esi,%r8d
  8020ed:	48 89 c6             	mov    %rax,%rsi
  8020f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8020f5:	48 b8 8f 1b 80 00 00 	movabs $0x801b8f,%rax
  8020fc:	00 00 00 
  8020ff:	ff d0                	callq  *%rax
  802101:	85 c0                	test   %eax,%eax
  802103:	0f 89 82 01 00 00    	jns    80228b <duppage+0x1f6>
			panic("duppage:sys_page_map error\n");	
  802109:	48 ba 6f 4b 80 00 00 	movabs $0x804b6f,%rdx
  802110:	00 00 00 
  802113:	be 4c 00 00 00       	mov    $0x4c,%esi
  802118:	48 bf ee 4a 80 00 00 	movabs $0x804aee,%rdi
  80211f:	00 00 00 
  802122:	b8 00 00 00 00       	mov    $0x0,%eax
  802127:	48 b9 e1 03 80 00 00 	movabs $0x8003e1,%rcx
  80212e:	00 00 00 
  802131:	ff d1                	callq  *%rcx
	}
	else
	if (!(uvpt[pn] & PTE_W) && !(uvpt[pn] & PTE_COW)) {
  802133:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80213a:	01 00 00 
  80213d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802140:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802144:	83 e0 02             	and    $0x2,%eax
  802147:	48 85 c0             	test   %rax,%rax
  80214a:	75 7e                	jne    8021ca <duppage+0x135>
  80214c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802153:	01 00 00 
  802156:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802159:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80215d:	25 00 08 00 00       	and    $0x800,%eax
  802162:	48 85 c0             	test   %rax,%rax
  802165:	75 63                	jne    8021ca <duppage+0x135>
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P)< 0) 
  802167:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80216a:	c1 e0 0c             	shl    $0xc,%eax
  80216d:	89 c0                	mov    %eax,%eax
  80216f:	48 89 c1             	mov    %rax,%rcx
  802172:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802175:	c1 e0 0c             	shl    $0xc,%eax
  802178:	89 c0                	mov    %eax,%eax
  80217a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80217d:	41 b8 05 00 00 00    	mov    $0x5,%r8d
  802183:	48 89 c6             	mov    %rax,%rsi
  802186:	bf 00 00 00 00       	mov    $0x0,%edi
  80218b:	48 b8 8f 1b 80 00 00 	movabs $0x801b8f,%rax
  802192:	00 00 00 
  802195:	ff d0                	callq  *%rax
  802197:	85 c0                	test   %eax,%eax
  802199:	79 2a                	jns    8021c5 <duppage+0x130>
			panic("duppage:sys_page_map error\n");
  80219b:	48 ba 6f 4b 80 00 00 	movabs $0x804b6f,%rdx
  8021a2:	00 00 00 
  8021a5:	be 51 00 00 00       	mov    $0x51,%esi
  8021aa:	48 bf ee 4a 80 00 00 	movabs $0x804aee,%rdi
  8021b1:	00 00 00 
  8021b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b9:	48 b9 e1 03 80 00 00 	movabs $0x8003e1,%rcx
  8021c0:	00 00 00 
  8021c3:	ff d1                	callq  *%rcx
		if (sys_page_map (0, (void*) ((uint64_t)pn * PGSIZE), envid, (void*) ((uint64_t)pn * PGSIZE), uvpt[pn] & PTE_SYSCALL)<0)
			panic("duppage:sys_page_map error\n");	
	}
	else
	if (!(uvpt[pn] & PTE_W) && !(uvpt[pn] & PTE_COW)) {
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P)< 0) 
  8021c5:	e9 c1 00 00 00       	jmpq   80228b <duppage+0x1f6>
			panic("duppage:sys_page_map error\n");
	}
	else {
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P | PTE_COW)< 0) 
  8021ca:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8021cd:	c1 e0 0c             	shl    $0xc,%eax
  8021d0:	89 c0                	mov    %eax,%eax
  8021d2:	48 89 c1             	mov    %rax,%rcx
  8021d5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8021d8:	c1 e0 0c             	shl    $0xc,%eax
  8021db:	89 c0                	mov    %eax,%eax
  8021dd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8021e0:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  8021e6:	48 89 c6             	mov    %rax,%rsi
  8021e9:	bf 00 00 00 00       	mov    $0x0,%edi
  8021ee:	48 b8 8f 1b 80 00 00 	movabs $0x801b8f,%rax
  8021f5:	00 00 00 
  8021f8:	ff d0                	callq  *%rax
  8021fa:	85 c0                	test   %eax,%eax
  8021fc:	79 2a                	jns    802228 <duppage+0x193>
			panic("duppage:sys_page_map error\n");
  8021fe:	48 ba 6f 4b 80 00 00 	movabs $0x804b6f,%rdx
  802205:	00 00 00 
  802208:	be 55 00 00 00       	mov    $0x55,%esi
  80220d:	48 bf ee 4a 80 00 00 	movabs $0x804aee,%rdi
  802214:	00 00 00 
  802217:	b8 00 00 00 00       	mov    $0x0,%eax
  80221c:	48 b9 e1 03 80 00 00 	movabs $0x8003e1,%rcx
  802223:	00 00 00 
  802226:	ff d1                	callq  *%rcx
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), 0, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P | PTE_COW)< 0) 
  802228:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80222b:	c1 e0 0c             	shl    $0xc,%eax
  80222e:	89 c0                	mov    %eax,%eax
  802230:	48 89 c2             	mov    %rax,%rdx
  802233:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802236:	c1 e0 0c             	shl    $0xc,%eax
  802239:	89 c0                	mov    %eax,%eax
  80223b:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  802241:	48 89 d1             	mov    %rdx,%rcx
  802244:	ba 00 00 00 00       	mov    $0x0,%edx
  802249:	48 89 c6             	mov    %rax,%rsi
  80224c:	bf 00 00 00 00       	mov    $0x0,%edi
  802251:	48 b8 8f 1b 80 00 00 	movabs $0x801b8f,%rax
  802258:	00 00 00 
  80225b:	ff d0                	callq  *%rax
  80225d:	85 c0                	test   %eax,%eax
  80225f:	79 2a                	jns    80228b <duppage+0x1f6>
			panic("duppage:sys_page_map error\n");
  802261:	48 ba 6f 4b 80 00 00 	movabs $0x804b6f,%rdx
  802268:	00 00 00 
  80226b:	be 57 00 00 00       	mov    $0x57,%esi
  802270:	48 bf ee 4a 80 00 00 	movabs $0x804aee,%rdi
  802277:	00 00 00 
  80227a:	b8 00 00 00 00       	mov    $0x0,%eax
  80227f:	48 b9 e1 03 80 00 00 	movabs $0x8003e1,%rcx
  802286:	00 00 00 
  802289:	ff d1                	callq  *%rcx
	}
	return 0;	   	
  80228b:	b8 00 00 00 00       	mov    $0x0,%eax

}
  802290:	c9                   	leaveq 
  802291:	c3                   	retq   

0000000000802292 <new_duppage>:


static int
new_duppage(envid_t envid, unsigned pn,int flag)
{
  802292:	55                   	push   %rbp
  802293:	48 89 e5             	mov    %rsp,%rbp
  802296:	48 83 ec 10          	sub    $0x10,%rsp
  80229a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80229d:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8022a0:	89 55 f4             	mov    %edx,-0xc(%rbp)
	
	if (!(uvpt[pn] & PTE_W) && !(uvpt[pn] & PTE_COW) && !flag) {
  8022a3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022aa:	01 00 00 
  8022ad:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8022b0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022b4:	83 e0 02             	and    $0x2,%eax
  8022b7:	48 85 c0             	test   %rax,%rax
  8022ba:	0f 85 84 00 00 00    	jne    802344 <new_duppage+0xb2>
  8022c0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022c7:	01 00 00 
  8022ca:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8022cd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022d1:	25 00 08 00 00       	and    $0x800,%eax
  8022d6:	48 85 c0             	test   %rax,%rax
  8022d9:	75 69                	jne    802344 <new_duppage+0xb2>
  8022db:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8022df:	75 63                	jne    802344 <new_duppage+0xb2>
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P)< 0) 
  8022e1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022e4:	c1 e0 0c             	shl    $0xc,%eax
  8022e7:	89 c0                	mov    %eax,%eax
  8022e9:	48 89 c1             	mov    %rax,%rcx
  8022ec:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022ef:	c1 e0 0c             	shl    $0xc,%eax
  8022f2:	89 c0                	mov    %eax,%eax
  8022f4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8022f7:	41 b8 05 00 00 00    	mov    $0x5,%r8d
  8022fd:	48 89 c6             	mov    %rax,%rsi
  802300:	bf 00 00 00 00       	mov    $0x0,%edi
  802305:	48 b8 8f 1b 80 00 00 	movabs $0x801b8f,%rax
  80230c:	00 00 00 
  80230f:	ff d0                	callq  *%rax
  802311:	85 c0                	test   %eax,%eax
  802313:	79 2a                	jns    80233f <new_duppage+0xad>
			panic("duppage:sys_page_map error\n");
  802315:	48 ba 6f 4b 80 00 00 	movabs $0x804b6f,%rdx
  80231c:	00 00 00 
  80231f:	be 64 00 00 00       	mov    $0x64,%esi
  802324:	48 bf ee 4a 80 00 00 	movabs $0x804aee,%rdi
  80232b:	00 00 00 
  80232e:	b8 00 00 00 00       	mov    $0x0,%eax
  802333:	48 b9 e1 03 80 00 00 	movabs $0x8003e1,%rcx
  80233a:	00 00 00 
  80233d:	ff d1                	callq  *%rcx
static int
new_duppage(envid_t envid, unsigned pn,int flag)
{
	
	if (!(uvpt[pn] & PTE_W) && !(uvpt[pn] & PTE_COW) && !flag) {
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P)< 0) 
  80233f:	e9 c1 00 00 00       	jmpq   802405 <new_duppage+0x173>
			panic("duppage:sys_page_map error\n");
	}
	else {
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P | PTE_COW)< 0) 
  802344:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802347:	c1 e0 0c             	shl    $0xc,%eax
  80234a:	89 c0                	mov    %eax,%eax
  80234c:	48 89 c1             	mov    %rax,%rcx
  80234f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802352:	c1 e0 0c             	shl    $0xc,%eax
  802355:	89 c0                	mov    %eax,%eax
  802357:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80235a:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  802360:	48 89 c6             	mov    %rax,%rsi
  802363:	bf 00 00 00 00       	mov    $0x0,%edi
  802368:	48 b8 8f 1b 80 00 00 	movabs $0x801b8f,%rax
  80236f:	00 00 00 
  802372:	ff d0                	callq  *%rax
  802374:	85 c0                	test   %eax,%eax
  802376:	79 2a                	jns    8023a2 <new_duppage+0x110>
			panic("duppage:sys_page_map error\n");
  802378:	48 ba 6f 4b 80 00 00 	movabs $0x804b6f,%rdx
  80237f:	00 00 00 
  802382:	be 68 00 00 00       	mov    $0x68,%esi
  802387:	48 bf ee 4a 80 00 00 	movabs $0x804aee,%rdi
  80238e:	00 00 00 
  802391:	b8 00 00 00 00       	mov    $0x0,%eax
  802396:	48 b9 e1 03 80 00 00 	movabs $0x8003e1,%rcx
  80239d:	00 00 00 
  8023a0:	ff d1                	callq  *%rcx
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), 0, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P | PTE_COW)< 0) 
  8023a2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023a5:	c1 e0 0c             	shl    $0xc,%eax
  8023a8:	89 c0                	mov    %eax,%eax
  8023aa:	48 89 c2             	mov    %rax,%rdx
  8023ad:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023b0:	c1 e0 0c             	shl    $0xc,%eax
  8023b3:	89 c0                	mov    %eax,%eax
  8023b5:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  8023bb:	48 89 d1             	mov    %rdx,%rcx
  8023be:	ba 00 00 00 00       	mov    $0x0,%edx
  8023c3:	48 89 c6             	mov    %rax,%rsi
  8023c6:	bf 00 00 00 00       	mov    $0x0,%edi
  8023cb:	48 b8 8f 1b 80 00 00 	movabs $0x801b8f,%rax
  8023d2:	00 00 00 
  8023d5:	ff d0                	callq  *%rax
  8023d7:	85 c0                	test   %eax,%eax
  8023d9:	79 2a                	jns    802405 <new_duppage+0x173>
			panic("duppage:sys_page_map error\n");
  8023db:	48 ba 6f 4b 80 00 00 	movabs $0x804b6f,%rdx
  8023e2:	00 00 00 
  8023e5:	be 6a 00 00 00       	mov    $0x6a,%esi
  8023ea:	48 bf ee 4a 80 00 00 	movabs $0x804aee,%rdi
  8023f1:	00 00 00 
  8023f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f9:	48 b9 e1 03 80 00 00 	movabs $0x8003e1,%rcx
  802400:	00 00 00 
  802403:	ff d1                	callq  *%rcx
	}
	return 0;	   	
  802405:	b8 00 00 00 00       	mov    $0x0,%eax

}
  80240a:	c9                   	leaveq 
  80240b:	c3                   	retq   

000000000080240c <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80240c:	55                   	push   %rbp
  80240d:	48 89 e5             	mov    %rsp,%rbp
  802410:	48 83 ec 10          	sub    $0x10,%rsp


	
	int envid;  
	//extern unsigned char end[];      
	set_pgfault_handler(pgfault);
  802414:	48 bf da 1e 80 00 00 	movabs $0x801eda,%rdi
  80241b:	00 00 00 
  80241e:	48 b8 8d 40 80 00 00 	movabs $0x80408d,%rax
  802425:	00 00 00 
  802428:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80242a:	b8 07 00 00 00       	mov    $0x7,%eax
  80242f:	cd 30                	int    $0x30
  802431:	89 45 f0             	mov    %eax,-0x10(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802434:	8b 45 f0             	mov    -0x10(%rbp),%eax


	if ((envid=sys_exofork())<0)
  802437:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80243a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80243e:	79 2a                	jns    80246a <fork+0x5e>
		panic("fork: sys_exofork error!\n"); 
  802440:	48 ba 8b 4b 80 00 00 	movabs $0x804b8b,%rdx
  802447:	00 00 00 
  80244a:	be 90 00 00 00       	mov    $0x90,%esi
  80244f:	48 bf ee 4a 80 00 00 	movabs $0x804aee,%rdi
  802456:	00 00 00 
  802459:	b8 00 00 00 00       	mov    $0x0,%eax
  80245e:	48 b9 e1 03 80 00 00 	movabs $0x8003e1,%rcx
  802465:	00 00 00 
  802468:	ff d1                	callq  *%rcx

	if(envid>0){
  80246a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80246e:	0f 8e e1 01 00 00    	jle    802655 <fork+0x249>
		
		
		uintptr_t i;
    for (i = UTEXT; i < (uintptr_t)USTACKTOP-PGSIZE/*USTACKTOP-PGSIZE*/; i += PGSIZE) 
  802474:	48 c7 45 f8 00 00 80 	movq   $0x800000,-0x8(%rbp)
  80247b:	00 
  80247c:	e9 d4 00 00 00       	jmpq   802555 <fork+0x149>
		{
			

               if(!(uvpml4e[VPML4E(i)]))
  802481:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802485:	48 c1 e8 27          	shr    $0x27,%rax
  802489:	48 89 c2             	mov    %rax,%rdx
  80248c:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802493:	01 00 00 
  802496:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80249a:	48 85 c0             	test   %rax,%rax
  80249d:	75 05                	jne    8024a4 <fork+0x98>
		 continue;
  80249f:	e9 a9 00 00 00       	jmpq   80254d <fork+0x141>
		
		if(!(uvpde[VPDPE(i)]))
  8024a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024a8:	48 c1 e8 1e          	shr    $0x1e,%rax
  8024ac:	48 89 c2             	mov    %rax,%rdx
  8024af:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8024b6:	01 00 00 
  8024b9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024bd:	48 85 c0             	test   %rax,%rax
  8024c0:	75 05                	jne    8024c7 <fork+0xbb>
	          continue;
  8024c2:	e9 86 00 00 00       	jmpq   80254d <fork+0x141>
	

			if(!(uvpd[VPD(i)] & PTE_P))
  8024c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024cb:	48 c1 e8 15          	shr    $0x15,%rax
  8024cf:	48 89 c2             	mov    %rax,%rdx
  8024d2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8024d9:	01 00 00 
  8024dc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024e0:	83 e0 01             	and    $0x1,%eax
  8024e3:	48 85 c0             	test   %rax,%rax
  8024e6:	75 02                	jne    8024ea <fork+0xde>
				continue;
  8024e8:	eb 63                	jmp    80254d <fork+0x141>
			if(!(uvpt[VPN(i)] & PTE_P))
  8024ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024ee:	48 c1 e8 0c          	shr    $0xc,%rax
  8024f2:	48 89 c2             	mov    %rax,%rdx
  8024f5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024fc:	01 00 00 
  8024ff:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802503:	83 e0 01             	and    $0x1,%eax
  802506:	48 85 c0             	test   %rax,%rax
  802509:	75 02                	jne    80250d <fork+0x101>
				continue; 
  80250b:	eb 40                	jmp    80254d <fork+0x141>
			if(!(uvpt[VPN(i)] & PTE_U))
  80250d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802511:	48 c1 e8 0c          	shr    $0xc,%rax
  802515:	48 89 c2             	mov    %rax,%rdx
  802518:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80251f:	01 00 00 
  802522:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802526:	83 e0 04             	and    $0x4,%eax
  802529:	48 85 c0             	test   %rax,%rax
  80252c:	75 02                	jne    802530 <fork+0x124>
				continue; 
  80252e:	eb 1d                	jmp    80254d <fork+0x141>
			duppage(envid, VPN(i)); 
  802530:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802534:	48 c1 e8 0c          	shr    $0xc,%rax
  802538:	89 c2                	mov    %eax,%edx
  80253a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80253d:	89 d6                	mov    %edx,%esi
  80253f:	89 c7                	mov    %eax,%edi
  802541:	48 b8 95 20 80 00 00 	movabs $0x802095,%rax
  802548:	00 00 00 
  80254b:	ff d0                	callq  *%rax

	if(envid>0){
		
		
		uintptr_t i;
    for (i = UTEXT; i < (uintptr_t)USTACKTOP-PGSIZE/*USTACKTOP-PGSIZE*/; i += PGSIZE) 
  80254d:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  802554:	00 
  802555:	b8 ff cf 7f ef       	mov    $0xef7fcfff,%eax
  80255a:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  80255e:	0f 86 1d ff ff ff    	jbe    802481 <fork+0x75>
			if(!(uvpt[VPN(i)] & PTE_U))
				continue; 
			duppage(envid, VPN(i)); 
		}

		if (sys_page_alloc(envid,(void*)UXSTACKTOP-PGSIZE, PTE_U|PTE_W|PTE_P)<0)
  802564:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802567:	ba 07 00 00 00       	mov    $0x7,%edx
  80256c:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802571:	89 c7                	mov    %eax,%edi
  802573:	48 b8 3f 1b 80 00 00 	movabs $0x801b3f,%rax
  80257a:	00 00 00 
  80257d:	ff d0                	callq  *%rax
  80257f:	85 c0                	test   %eax,%eax
  802581:	79 2a                	jns    8025ad <fork+0x1a1>
			panic("fork: sys_page_alloc error!\n");
  802583:	48 ba a5 4b 80 00 00 	movabs $0x804ba5,%rdx
  80258a:	00 00 00 
  80258d:	be ab 00 00 00       	mov    $0xab,%esi
  802592:	48 bf ee 4a 80 00 00 	movabs $0x804aee,%rdi
  802599:	00 00 00 
  80259c:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a1:	48 b9 e1 03 80 00 00 	movabs $0x8003e1,%rcx
  8025a8:	00 00 00 
  8025ab:	ff d1                	callq  *%rcx

		duppage(envid, VPN(USTACKTOP-PGSIZE));
  8025ad:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8025b0:	be fd f7 0e 00       	mov    $0xef7fd,%esi
  8025b5:	89 c7                	mov    %eax,%edi
  8025b7:	48 b8 95 20 80 00 00 	movabs $0x802095,%rax
  8025be:	00 00 00 
  8025c1:	ff d0                	callq  *%rax
		extern void _pgfault_upcall(void);
		if (sys_env_set_pgfault_upcall(envid, _pgfault_upcall)<0)
  8025c3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8025c6:	48 be 2d 41 80 00 00 	movabs $0x80412d,%rsi
  8025cd:	00 00 00 
  8025d0:	89 c7                	mov    %eax,%edi
  8025d2:	48 b8 c9 1c 80 00 00 	movabs $0x801cc9,%rax
  8025d9:	00 00 00 
  8025dc:	ff d0                	callq  *%rax
  8025de:	85 c0                	test   %eax,%eax
  8025e0:	79 2a                	jns    80260c <fork+0x200>
			panic("fork: sys_env_set_status error!\n");
  8025e2:	48 ba c8 4b 80 00 00 	movabs $0x804bc8,%rdx
  8025e9:	00 00 00 
  8025ec:	be b0 00 00 00       	mov    $0xb0,%esi
  8025f1:	48 bf ee 4a 80 00 00 	movabs $0x804aee,%rdi
  8025f8:	00 00 00 
  8025fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802600:	48 b9 e1 03 80 00 00 	movabs $0x8003e1,%rcx
  802607:	00 00 00 
  80260a:	ff d1                	callq  *%rcx
		if (sys_env_set_status(envid, ENV_RUNNABLE)<0)
  80260c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80260f:	be 02 00 00 00       	mov    $0x2,%esi
  802614:	89 c7                	mov    %eax,%edi
  802616:	48 b8 34 1c 80 00 00 	movabs $0x801c34,%rax
  80261d:	00 00 00 
  802620:	ff d0                	callq  *%rax
  802622:	85 c0                	test   %eax,%eax
  802624:	79 2a                	jns    802650 <fork+0x244>
			panic("fork: sys_env_set_status error!\n");
  802626:	48 ba c8 4b 80 00 00 	movabs $0x804bc8,%rdx
  80262d:	00 00 00 
  802630:	be b2 00 00 00       	mov    $0xb2,%esi
  802635:	48 bf ee 4a 80 00 00 	movabs $0x804aee,%rdi
  80263c:	00 00 00 
  80263f:	b8 00 00 00 00       	mov    $0x0,%eax
  802644:	48 b9 e1 03 80 00 00 	movabs $0x8003e1,%rcx
  80264b:	00 00 00 
  80264e:	ff d1                	callq  *%rcx

		return envid;
  802650:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802653:	eb 39                	jmp    80268e <fork+0x282>
	}
	else
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  802655:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  80265c:	00 00 00 
  80265f:	ff d0                	callq  *%rax
  802661:	25 ff 03 00 00       	and    $0x3ff,%eax
  802666:	48 98                	cltq   
  802668:	48 69 d0 70 01 00 00 	imul   $0x170,%rax,%rdx
  80266f:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802676:	00 00 00 
  802679:	48 01 c2             	add    %rax,%rdx
  80267c:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  802683:	00 00 00 
  802686:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  802689:	b8 00 00 00 00       	mov    $0x0,%eax
	}

}
  80268e:	c9                   	leaveq 
  80268f:	c3                   	retq   

0000000000802690 <sfork>:

// Challenge!
envid_t
sfork(void)
{
  802690:	55                   	push   %rbp
  802691:	48 89 e5             	mov    %rsp,%rbp
  802694:	48 83 ec 20          	sub    $0x20,%rsp

	
	int envid;  
	extern unsigned char end[];      
	set_pgfault_handler(pgfault);
  802698:	48 bf da 1e 80 00 00 	movabs $0x801eda,%rdi
  80269f:	00 00 00 
  8026a2:	48 b8 8d 40 80 00 00 	movabs $0x80408d,%rax
  8026a9:	00 00 00 
  8026ac:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8026ae:	b8 07 00 00 00       	mov    $0x7,%eax
  8026b3:	cd 30                	int    $0x30
  8026b5:	89 45 ec             	mov    %eax,-0x14(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8026b8:	8b 45 ec             	mov    -0x14(%rbp),%eax
	

	if ((envid=sys_exofork())<0)
  8026bb:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8026be:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8026c2:	79 2a                	jns    8026ee <sfork+0x5e>
		panic("fork: sys_exofork error!\n"); 
  8026c4:	48 ba 8b 4b 80 00 00 	movabs $0x804b8b,%rdx
  8026cb:	00 00 00 
  8026ce:	be ca 00 00 00       	mov    $0xca,%esi
  8026d3:	48 bf ee 4a 80 00 00 	movabs $0x804aee,%rdi
  8026da:	00 00 00 
  8026dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e2:	48 b9 e1 03 80 00 00 	movabs $0x8003e1,%rcx
  8026e9:	00 00 00 
  8026ec:	ff d1                	callq  *%rcx

	if(envid>0){
  8026ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8026f2:	0f 8e e5 00 00 00    	jle    8027dd <sfork+0x14d>
		
		
		uintptr_t i;
		int flag=1;
  8026f8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%rbp)

		for (i = 0; i < (uintptr_t)end/*USTACKTOP-PGSIZE*/; i += PGSIZE) ;
  8026ff:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802706:	00 
  802707:	eb 08                	jmp    802711 <sfork+0x81>
  802709:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  802710:	00 
  802711:	48 b8 10 90 80 00 00 	movabs $0x809010,%rax
  802718:	00 00 00 
  80271b:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  80271f:	72 e8                	jb     802709 <sfork+0x79>
	


		//new_duppage(envid, PPN(USTACKTOP-PGSIZE),flag);
		i-=PGSIZE;
  802721:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  802728:	00 
    for (;i>=0; i -= PGSIZE) 
		{
			cprintf("23\n");
  802729:	48 bf e9 4b 80 00 00 	movabs $0x804be9,%rdi
  802730:	00 00 00 
  802733:	b8 00 00 00 00       	mov    $0x0,%eax
  802738:	48 ba 1a 06 80 00 00 	movabs $0x80061a,%rdx
  80273f:	00 00 00 
  802742:	ff d2                	callq  *%rdx
			if(!(uvpd[VPD(i)] & PTE_P) || !(uvpt[VPN(i)] & PTE_P) || !(uvpt[VPN(i)] & PTE_U))
  802744:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802748:	48 c1 e8 15          	shr    $0x15,%rax
  80274c:	48 89 c2             	mov    %rax,%rdx
  80274f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802756:	01 00 00 
  802759:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80275d:	83 e0 01             	and    $0x1,%eax
  802760:	48 85 c0             	test   %rax,%rax
  802763:	74 42                	je     8027a7 <sfork+0x117>
  802765:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802769:	48 c1 e8 0c          	shr    $0xc,%rax
  80276d:	48 89 c2             	mov    %rax,%rdx
  802770:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802777:	01 00 00 
  80277a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80277e:	83 e0 01             	and    $0x1,%eax
  802781:	48 85 c0             	test   %rax,%rax
  802784:	74 21                	je     8027a7 <sfork+0x117>
  802786:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80278a:	48 c1 e8 0c          	shr    $0xc,%rax
  80278e:	48 89 c2             	mov    %rax,%rdx
  802791:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802798:	01 00 00 
  80279b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80279f:	83 e0 04             	and    $0x4,%eax
  8027a2:	48 85 c0             	test   %rax,%rax
  8027a5:	75 09                	jne    8027b0 <sfork+0x120>
				flag=0;
  8027a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  8027ae:	eb 20                	jmp    8027d0 <sfork+0x140>
			else
				new_duppage(envid, VPN(i),flag); 
  8027b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027b4:	48 c1 e8 0c          	shr    $0xc,%rax
  8027b8:	89 c1                	mov    %eax,%ecx
  8027ba:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8027bd:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8027c0:	89 ce                	mov    %ecx,%esi
  8027c2:	89 c7                	mov    %eax,%edi
  8027c4:	48 b8 92 22 80 00 00 	movabs $0x802292,%rax
  8027cb:	00 00 00 
  8027ce:	ff d0                	callq  *%rax
	


		//new_duppage(envid, PPN(USTACKTOP-PGSIZE),flag);
		i-=PGSIZE;
    for (;i>=0; i -= PGSIZE) 
  8027d0:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  8027d7:	00 
			if(!(uvpd[VPD(i)] & PTE_P) || !(uvpt[VPN(i)] & PTE_P) || !(uvpt[VPN(i)] & PTE_U))
				flag=0;
			else
				new_duppage(envid, VPN(i),flag); 

		}
  8027d8:	e9 4c ff ff ff       	jmpq   802729 <sfork+0x99>

		return envid;
	}
	else
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  8027dd:	48 b8 c3 1a 80 00 00 	movabs $0x801ac3,%rax
  8027e4:	00 00 00 
  8027e7:	ff d0                	callq  *%rax
  8027e9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8027ee:	48 98                	cltq   
  8027f0:	48 69 d0 70 01 00 00 	imul   $0x170,%rax,%rdx
  8027f7:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8027fe:	00 00 00 
  802801:	48 01 c2             	add    %rax,%rdx
  802804:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  80280b:	00 00 00 
  80280e:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  802811:	b8 00 00 00 00       	mov    $0x0,%eax
	}

}
  802816:	c9                   	leaveq 
  802817:	c3                   	retq   

0000000000802818 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802818:	55                   	push   %rbp
  802819:	48 89 e5             	mov    %rsp,%rbp
  80281c:	48 83 ec 08          	sub    $0x8,%rsp
  802820:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802824:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802828:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80282f:	ff ff ff 
  802832:	48 01 d0             	add    %rdx,%rax
  802835:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802839:	c9                   	leaveq 
  80283a:	c3                   	retq   

000000000080283b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80283b:	55                   	push   %rbp
  80283c:	48 89 e5             	mov    %rsp,%rbp
  80283f:	48 83 ec 08          	sub    $0x8,%rsp
  802843:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802847:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80284b:	48 89 c7             	mov    %rax,%rdi
  80284e:	48 b8 18 28 80 00 00 	movabs $0x802818,%rax
  802855:	00 00 00 
  802858:	ff d0                	callq  *%rax
  80285a:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802860:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802864:	c9                   	leaveq 
  802865:	c3                   	retq   

0000000000802866 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802866:	55                   	push   %rbp
  802867:	48 89 e5             	mov    %rsp,%rbp
  80286a:	48 83 ec 18          	sub    $0x18,%rsp
  80286e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802872:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802879:	eb 6b                	jmp    8028e6 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80287b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80287e:	48 98                	cltq   
  802880:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802886:	48 c1 e0 0c          	shl    $0xc,%rax
  80288a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80288e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802892:	48 c1 e8 15          	shr    $0x15,%rax
  802896:	48 89 c2             	mov    %rax,%rdx
  802899:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8028a0:	01 00 00 
  8028a3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028a7:	83 e0 01             	and    $0x1,%eax
  8028aa:	48 85 c0             	test   %rax,%rax
  8028ad:	74 21                	je     8028d0 <fd_alloc+0x6a>
  8028af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028b3:	48 c1 e8 0c          	shr    $0xc,%rax
  8028b7:	48 89 c2             	mov    %rax,%rdx
  8028ba:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8028c1:	01 00 00 
  8028c4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028c8:	83 e0 01             	and    $0x1,%eax
  8028cb:	48 85 c0             	test   %rax,%rax
  8028ce:	75 12                	jne    8028e2 <fd_alloc+0x7c>
			*fd_store = fd;
  8028d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028d4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8028d8:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8028db:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e0:	eb 1a                	jmp    8028fc <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8028e2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8028e6:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8028ea:	7e 8f                	jle    80287b <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8028ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028f0:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8028f7:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8028fc:	c9                   	leaveq 
  8028fd:	c3                   	retq   

00000000008028fe <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8028fe:	55                   	push   %rbp
  8028ff:	48 89 e5             	mov    %rsp,%rbp
  802902:	48 83 ec 20          	sub    $0x20,%rsp
  802906:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802909:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80290d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802911:	78 06                	js     802919 <fd_lookup+0x1b>
  802913:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802917:	7e 07                	jle    802920 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802919:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80291e:	eb 6c                	jmp    80298c <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802920:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802923:	48 98                	cltq   
  802925:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80292b:	48 c1 e0 0c          	shl    $0xc,%rax
  80292f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802933:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802937:	48 c1 e8 15          	shr    $0x15,%rax
  80293b:	48 89 c2             	mov    %rax,%rdx
  80293e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802945:	01 00 00 
  802948:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80294c:	83 e0 01             	and    $0x1,%eax
  80294f:	48 85 c0             	test   %rax,%rax
  802952:	74 21                	je     802975 <fd_lookup+0x77>
  802954:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802958:	48 c1 e8 0c          	shr    $0xc,%rax
  80295c:	48 89 c2             	mov    %rax,%rdx
  80295f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802966:	01 00 00 
  802969:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80296d:	83 e0 01             	and    $0x1,%eax
  802970:	48 85 c0             	test   %rax,%rax
  802973:	75 07                	jne    80297c <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802975:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80297a:	eb 10                	jmp    80298c <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80297c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802980:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802984:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802987:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80298c:	c9                   	leaveq 
  80298d:	c3                   	retq   

000000000080298e <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80298e:	55                   	push   %rbp
  80298f:	48 89 e5             	mov    %rsp,%rbp
  802992:	48 83 ec 30          	sub    $0x30,%rsp
  802996:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80299a:	89 f0                	mov    %esi,%eax
  80299c:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80299f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029a3:	48 89 c7             	mov    %rax,%rdi
  8029a6:	48 b8 18 28 80 00 00 	movabs $0x802818,%rax
  8029ad:	00 00 00 
  8029b0:	ff d0                	callq  *%rax
  8029b2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029b6:	48 89 d6             	mov    %rdx,%rsi
  8029b9:	89 c7                	mov    %eax,%edi
  8029bb:	48 b8 fe 28 80 00 00 	movabs $0x8028fe,%rax
  8029c2:	00 00 00 
  8029c5:	ff d0                	callq  *%rax
  8029c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029ce:	78 0a                	js     8029da <fd_close+0x4c>
	    || fd != fd2)
  8029d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029d4:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8029d8:	74 12                	je     8029ec <fd_close+0x5e>
		return (must_exist ? r : 0);
  8029da:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8029de:	74 05                	je     8029e5 <fd_close+0x57>
  8029e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029e3:	eb 05                	jmp    8029ea <fd_close+0x5c>
  8029e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8029ea:	eb 69                	jmp    802a55 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8029ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029f0:	8b 00                	mov    (%rax),%eax
  8029f2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8029f6:	48 89 d6             	mov    %rdx,%rsi
  8029f9:	89 c7                	mov    %eax,%edi
  8029fb:	48 b8 57 2a 80 00 00 	movabs $0x802a57,%rax
  802a02:	00 00 00 
  802a05:	ff d0                	callq  *%rax
  802a07:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a0a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a0e:	78 2a                	js     802a3a <fd_close+0xac>
		if (dev->dev_close)
  802a10:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a14:	48 8b 40 20          	mov    0x20(%rax),%rax
  802a18:	48 85 c0             	test   %rax,%rax
  802a1b:	74 16                	je     802a33 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802a1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a21:	48 8b 40 20          	mov    0x20(%rax),%rax
  802a25:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802a29:	48 89 d7             	mov    %rdx,%rdi
  802a2c:	ff d0                	callq  *%rax
  802a2e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a31:	eb 07                	jmp    802a3a <fd_close+0xac>
		else
			r = 0;
  802a33:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802a3a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a3e:	48 89 c6             	mov    %rax,%rsi
  802a41:	bf 00 00 00 00       	mov    $0x0,%edi
  802a46:	48 b8 ea 1b 80 00 00 	movabs $0x801bea,%rax
  802a4d:	00 00 00 
  802a50:	ff d0                	callq  *%rax
	return r;
  802a52:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802a55:	c9                   	leaveq 
  802a56:	c3                   	retq   

0000000000802a57 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802a57:	55                   	push   %rbp
  802a58:	48 89 e5             	mov    %rsp,%rbp
  802a5b:	48 83 ec 20          	sub    $0x20,%rsp
  802a5f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a62:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802a66:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a6d:	eb 41                	jmp    802ab0 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802a6f:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802a76:	00 00 00 
  802a79:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802a7c:	48 63 d2             	movslq %edx,%rdx
  802a7f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a83:	8b 00                	mov    (%rax),%eax
  802a85:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802a88:	75 22                	jne    802aac <dev_lookup+0x55>
			*dev = devtab[i];
  802a8a:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802a91:	00 00 00 
  802a94:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802a97:	48 63 d2             	movslq %edx,%rdx
  802a9a:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802a9e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802aa2:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802aa5:	b8 00 00 00 00       	mov    $0x0,%eax
  802aaa:	eb 60                	jmp    802b0c <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802aac:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802ab0:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802ab7:	00 00 00 
  802aba:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802abd:	48 63 d2             	movslq %edx,%rdx
  802ac0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ac4:	48 85 c0             	test   %rax,%rax
  802ac7:	75 a6                	jne    802a6f <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802ac9:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  802ad0:	00 00 00 
  802ad3:	48 8b 00             	mov    (%rax),%rax
  802ad6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802adc:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802adf:	89 c6                	mov    %eax,%esi
  802ae1:	48 bf f0 4b 80 00 00 	movabs $0x804bf0,%rdi
  802ae8:	00 00 00 
  802aeb:	b8 00 00 00 00       	mov    $0x0,%eax
  802af0:	48 b9 1a 06 80 00 00 	movabs $0x80061a,%rcx
  802af7:	00 00 00 
  802afa:	ff d1                	callq  *%rcx
	*dev = 0;
  802afc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b00:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802b07:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802b0c:	c9                   	leaveq 
  802b0d:	c3                   	retq   

0000000000802b0e <close>:

int
close(int fdnum)
{
  802b0e:	55                   	push   %rbp
  802b0f:	48 89 e5             	mov    %rsp,%rbp
  802b12:	48 83 ec 20          	sub    $0x20,%rsp
  802b16:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b19:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b1d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b20:	48 89 d6             	mov    %rdx,%rsi
  802b23:	89 c7                	mov    %eax,%edi
  802b25:	48 b8 fe 28 80 00 00 	movabs $0x8028fe,%rax
  802b2c:	00 00 00 
  802b2f:	ff d0                	callq  *%rax
  802b31:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b34:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b38:	79 05                	jns    802b3f <close+0x31>
		return r;
  802b3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b3d:	eb 18                	jmp    802b57 <close+0x49>
	else
		return fd_close(fd, 1);
  802b3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b43:	be 01 00 00 00       	mov    $0x1,%esi
  802b48:	48 89 c7             	mov    %rax,%rdi
  802b4b:	48 b8 8e 29 80 00 00 	movabs $0x80298e,%rax
  802b52:	00 00 00 
  802b55:	ff d0                	callq  *%rax
}
  802b57:	c9                   	leaveq 
  802b58:	c3                   	retq   

0000000000802b59 <close_all>:

void
close_all(void)
{
  802b59:	55                   	push   %rbp
  802b5a:	48 89 e5             	mov    %rsp,%rbp
  802b5d:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802b61:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802b68:	eb 15                	jmp    802b7f <close_all+0x26>
		close(i);
  802b6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b6d:	89 c7                	mov    %eax,%edi
  802b6f:	48 b8 0e 2b 80 00 00 	movabs $0x802b0e,%rax
  802b76:	00 00 00 
  802b79:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802b7b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802b7f:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802b83:	7e e5                	jle    802b6a <close_all+0x11>
		close(i);
}
  802b85:	c9                   	leaveq 
  802b86:	c3                   	retq   

0000000000802b87 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802b87:	55                   	push   %rbp
  802b88:	48 89 e5             	mov    %rsp,%rbp
  802b8b:	48 83 ec 40          	sub    $0x40,%rsp
  802b8f:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802b92:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802b95:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802b99:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802b9c:	48 89 d6             	mov    %rdx,%rsi
  802b9f:	89 c7                	mov    %eax,%edi
  802ba1:	48 b8 fe 28 80 00 00 	movabs $0x8028fe,%rax
  802ba8:	00 00 00 
  802bab:	ff d0                	callq  *%rax
  802bad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bb0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bb4:	79 08                	jns    802bbe <dup+0x37>
		return r;
  802bb6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bb9:	e9 70 01 00 00       	jmpq   802d2e <dup+0x1a7>
	close(newfdnum);
  802bbe:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802bc1:	89 c7                	mov    %eax,%edi
  802bc3:	48 b8 0e 2b 80 00 00 	movabs $0x802b0e,%rax
  802bca:	00 00 00 
  802bcd:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802bcf:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802bd2:	48 98                	cltq   
  802bd4:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802bda:	48 c1 e0 0c          	shl    $0xc,%rax
  802bde:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802be2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802be6:	48 89 c7             	mov    %rax,%rdi
  802be9:	48 b8 3b 28 80 00 00 	movabs $0x80283b,%rax
  802bf0:	00 00 00 
  802bf3:	ff d0                	callq  *%rax
  802bf5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802bf9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bfd:	48 89 c7             	mov    %rax,%rdi
  802c00:	48 b8 3b 28 80 00 00 	movabs $0x80283b,%rax
  802c07:	00 00 00 
  802c0a:	ff d0                	callq  *%rax
  802c0c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802c10:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c14:	48 c1 e8 15          	shr    $0x15,%rax
  802c18:	48 89 c2             	mov    %rax,%rdx
  802c1b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802c22:	01 00 00 
  802c25:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c29:	83 e0 01             	and    $0x1,%eax
  802c2c:	48 85 c0             	test   %rax,%rax
  802c2f:	74 73                	je     802ca4 <dup+0x11d>
  802c31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c35:	48 c1 e8 0c          	shr    $0xc,%rax
  802c39:	48 89 c2             	mov    %rax,%rdx
  802c3c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802c43:	01 00 00 
  802c46:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c4a:	83 e0 01             	and    $0x1,%eax
  802c4d:	48 85 c0             	test   %rax,%rax
  802c50:	74 52                	je     802ca4 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802c52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c56:	48 c1 e8 0c          	shr    $0xc,%rax
  802c5a:	48 89 c2             	mov    %rax,%rdx
  802c5d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802c64:	01 00 00 
  802c67:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c6b:	25 07 0e 00 00       	and    $0xe07,%eax
  802c70:	89 c1                	mov    %eax,%ecx
  802c72:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c76:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c7a:	41 89 c8             	mov    %ecx,%r8d
  802c7d:	48 89 d1             	mov    %rdx,%rcx
  802c80:	ba 00 00 00 00       	mov    $0x0,%edx
  802c85:	48 89 c6             	mov    %rax,%rsi
  802c88:	bf 00 00 00 00       	mov    $0x0,%edi
  802c8d:	48 b8 8f 1b 80 00 00 	movabs $0x801b8f,%rax
  802c94:	00 00 00 
  802c97:	ff d0                	callq  *%rax
  802c99:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c9c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ca0:	79 02                	jns    802ca4 <dup+0x11d>
			goto err;
  802ca2:	eb 57                	jmp    802cfb <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802ca4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ca8:	48 c1 e8 0c          	shr    $0xc,%rax
  802cac:	48 89 c2             	mov    %rax,%rdx
  802caf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802cb6:	01 00 00 
  802cb9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802cbd:	25 07 0e 00 00       	and    $0xe07,%eax
  802cc2:	89 c1                	mov    %eax,%ecx
  802cc4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802cc8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ccc:	41 89 c8             	mov    %ecx,%r8d
  802ccf:	48 89 d1             	mov    %rdx,%rcx
  802cd2:	ba 00 00 00 00       	mov    $0x0,%edx
  802cd7:	48 89 c6             	mov    %rax,%rsi
  802cda:	bf 00 00 00 00       	mov    $0x0,%edi
  802cdf:	48 b8 8f 1b 80 00 00 	movabs $0x801b8f,%rax
  802ce6:	00 00 00 
  802ce9:	ff d0                	callq  *%rax
  802ceb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cf2:	79 02                	jns    802cf6 <dup+0x16f>
		goto err;
  802cf4:	eb 05                	jmp    802cfb <dup+0x174>

	return newfdnum;
  802cf6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802cf9:	eb 33                	jmp    802d2e <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802cfb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cff:	48 89 c6             	mov    %rax,%rsi
  802d02:	bf 00 00 00 00       	mov    $0x0,%edi
  802d07:	48 b8 ea 1b 80 00 00 	movabs $0x801bea,%rax
  802d0e:	00 00 00 
  802d11:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802d13:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d17:	48 89 c6             	mov    %rax,%rsi
  802d1a:	bf 00 00 00 00       	mov    $0x0,%edi
  802d1f:	48 b8 ea 1b 80 00 00 	movabs $0x801bea,%rax
  802d26:	00 00 00 
  802d29:	ff d0                	callq  *%rax
	return r;
  802d2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802d2e:	c9                   	leaveq 
  802d2f:	c3                   	retq   

0000000000802d30 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802d30:	55                   	push   %rbp
  802d31:	48 89 e5             	mov    %rsp,%rbp
  802d34:	48 83 ec 40          	sub    $0x40,%rsp
  802d38:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d3b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802d3f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d43:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d47:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d4a:	48 89 d6             	mov    %rdx,%rsi
  802d4d:	89 c7                	mov    %eax,%edi
  802d4f:	48 b8 fe 28 80 00 00 	movabs $0x8028fe,%rax
  802d56:	00 00 00 
  802d59:	ff d0                	callq  *%rax
  802d5b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d5e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d62:	78 24                	js     802d88 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d68:	8b 00                	mov    (%rax),%eax
  802d6a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d6e:	48 89 d6             	mov    %rdx,%rsi
  802d71:	89 c7                	mov    %eax,%edi
  802d73:	48 b8 57 2a 80 00 00 	movabs $0x802a57,%rax
  802d7a:	00 00 00 
  802d7d:	ff d0                	callq  *%rax
  802d7f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d82:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d86:	79 05                	jns    802d8d <read+0x5d>
		return r;
  802d88:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d8b:	eb 76                	jmp    802e03 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802d8d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d91:	8b 40 08             	mov    0x8(%rax),%eax
  802d94:	83 e0 03             	and    $0x3,%eax
  802d97:	83 f8 01             	cmp    $0x1,%eax
  802d9a:	75 3a                	jne    802dd6 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802d9c:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  802da3:	00 00 00 
  802da6:	48 8b 00             	mov    (%rax),%rax
  802da9:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802daf:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802db2:	89 c6                	mov    %eax,%esi
  802db4:	48 bf 0f 4c 80 00 00 	movabs $0x804c0f,%rdi
  802dbb:	00 00 00 
  802dbe:	b8 00 00 00 00       	mov    $0x0,%eax
  802dc3:	48 b9 1a 06 80 00 00 	movabs $0x80061a,%rcx
  802dca:	00 00 00 
  802dcd:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802dcf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802dd4:	eb 2d                	jmp    802e03 <read+0xd3>
	}
	if (!dev->dev_read)
  802dd6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dda:	48 8b 40 10          	mov    0x10(%rax),%rax
  802dde:	48 85 c0             	test   %rax,%rax
  802de1:	75 07                	jne    802dea <read+0xba>
		return -E_NOT_SUPP;
  802de3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802de8:	eb 19                	jmp    802e03 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802dea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dee:	48 8b 40 10          	mov    0x10(%rax),%rax
  802df2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802df6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802dfa:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802dfe:	48 89 cf             	mov    %rcx,%rdi
  802e01:	ff d0                	callq  *%rax
}
  802e03:	c9                   	leaveq 
  802e04:	c3                   	retq   

0000000000802e05 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802e05:	55                   	push   %rbp
  802e06:	48 89 e5             	mov    %rsp,%rbp
  802e09:	48 83 ec 30          	sub    $0x30,%rsp
  802e0d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e10:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802e14:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802e18:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802e1f:	eb 49                	jmp    802e6a <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802e21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e24:	48 98                	cltq   
  802e26:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e2a:	48 29 c2             	sub    %rax,%rdx
  802e2d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e30:	48 63 c8             	movslq %eax,%rcx
  802e33:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e37:	48 01 c1             	add    %rax,%rcx
  802e3a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e3d:	48 89 ce             	mov    %rcx,%rsi
  802e40:	89 c7                	mov    %eax,%edi
  802e42:	48 b8 30 2d 80 00 00 	movabs $0x802d30,%rax
  802e49:	00 00 00 
  802e4c:	ff d0                	callq  *%rax
  802e4e:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802e51:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802e55:	79 05                	jns    802e5c <readn+0x57>
			return m;
  802e57:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e5a:	eb 1c                	jmp    802e78 <readn+0x73>
		if (m == 0)
  802e5c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802e60:	75 02                	jne    802e64 <readn+0x5f>
			break;
  802e62:	eb 11                	jmp    802e75 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802e64:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e67:	01 45 fc             	add    %eax,-0x4(%rbp)
  802e6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e6d:	48 98                	cltq   
  802e6f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802e73:	72 ac                	jb     802e21 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  802e75:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802e78:	c9                   	leaveq 
  802e79:	c3                   	retq   

0000000000802e7a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802e7a:	55                   	push   %rbp
  802e7b:	48 89 e5             	mov    %rsp,%rbp
  802e7e:	48 83 ec 40          	sub    $0x40,%rsp
  802e82:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e85:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802e89:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e8d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e91:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e94:	48 89 d6             	mov    %rdx,%rsi
  802e97:	89 c7                	mov    %eax,%edi
  802e99:	48 b8 fe 28 80 00 00 	movabs $0x8028fe,%rax
  802ea0:	00 00 00 
  802ea3:	ff d0                	callq  *%rax
  802ea5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ea8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802eac:	78 24                	js     802ed2 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802eae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eb2:	8b 00                	mov    (%rax),%eax
  802eb4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802eb8:	48 89 d6             	mov    %rdx,%rsi
  802ebb:	89 c7                	mov    %eax,%edi
  802ebd:	48 b8 57 2a 80 00 00 	movabs $0x802a57,%rax
  802ec4:	00 00 00 
  802ec7:	ff d0                	callq  *%rax
  802ec9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ecc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ed0:	79 05                	jns    802ed7 <write+0x5d>
		return r;
  802ed2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ed5:	eb 75                	jmp    802f4c <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802ed7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802edb:	8b 40 08             	mov    0x8(%rax),%eax
  802ede:	83 e0 03             	and    $0x3,%eax
  802ee1:	85 c0                	test   %eax,%eax
  802ee3:	75 3a                	jne    802f1f <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802ee5:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  802eec:	00 00 00 
  802eef:	48 8b 00             	mov    (%rax),%rax
  802ef2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ef8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802efb:	89 c6                	mov    %eax,%esi
  802efd:	48 bf 2b 4c 80 00 00 	movabs $0x804c2b,%rdi
  802f04:	00 00 00 
  802f07:	b8 00 00 00 00       	mov    $0x0,%eax
  802f0c:	48 b9 1a 06 80 00 00 	movabs $0x80061a,%rcx
  802f13:	00 00 00 
  802f16:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802f18:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802f1d:	eb 2d                	jmp    802f4c <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802f1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f23:	48 8b 40 18          	mov    0x18(%rax),%rax
  802f27:	48 85 c0             	test   %rax,%rax
  802f2a:	75 07                	jne    802f33 <write+0xb9>
		return -E_NOT_SUPP;
  802f2c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802f31:	eb 19                	jmp    802f4c <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802f33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f37:	48 8b 40 18          	mov    0x18(%rax),%rax
  802f3b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802f3f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802f43:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802f47:	48 89 cf             	mov    %rcx,%rdi
  802f4a:	ff d0                	callq  *%rax
}
  802f4c:	c9                   	leaveq 
  802f4d:	c3                   	retq   

0000000000802f4e <seek>:

int
seek(int fdnum, off_t offset)
{
  802f4e:	55                   	push   %rbp
  802f4f:	48 89 e5             	mov    %rsp,%rbp
  802f52:	48 83 ec 18          	sub    $0x18,%rsp
  802f56:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f59:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802f5c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f60:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f63:	48 89 d6             	mov    %rdx,%rsi
  802f66:	89 c7                	mov    %eax,%edi
  802f68:	48 b8 fe 28 80 00 00 	movabs $0x8028fe,%rax
  802f6f:	00 00 00 
  802f72:	ff d0                	callq  *%rax
  802f74:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f77:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f7b:	79 05                	jns    802f82 <seek+0x34>
		return r;
  802f7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f80:	eb 0f                	jmp    802f91 <seek+0x43>
	fd->fd_offset = offset;
  802f82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f86:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f89:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802f8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f91:	c9                   	leaveq 
  802f92:	c3                   	retq   

0000000000802f93 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802f93:	55                   	push   %rbp
  802f94:	48 89 e5             	mov    %rsp,%rbp
  802f97:	48 83 ec 30          	sub    $0x30,%rsp
  802f9b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802f9e:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802fa1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802fa5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802fa8:	48 89 d6             	mov    %rdx,%rsi
  802fab:	89 c7                	mov    %eax,%edi
  802fad:	48 b8 fe 28 80 00 00 	movabs $0x8028fe,%rax
  802fb4:	00 00 00 
  802fb7:	ff d0                	callq  *%rax
  802fb9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fbc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fc0:	78 24                	js     802fe6 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802fc2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fc6:	8b 00                	mov    (%rax),%eax
  802fc8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802fcc:	48 89 d6             	mov    %rdx,%rsi
  802fcf:	89 c7                	mov    %eax,%edi
  802fd1:	48 b8 57 2a 80 00 00 	movabs $0x802a57,%rax
  802fd8:	00 00 00 
  802fdb:	ff d0                	callq  *%rax
  802fdd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fe0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fe4:	79 05                	jns    802feb <ftruncate+0x58>
		return r;
  802fe6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fe9:	eb 72                	jmp    80305d <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802feb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fef:	8b 40 08             	mov    0x8(%rax),%eax
  802ff2:	83 e0 03             	and    $0x3,%eax
  802ff5:	85 c0                	test   %eax,%eax
  802ff7:	75 3a                	jne    803033 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802ff9:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803000:	00 00 00 
  803003:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  803006:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80300c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80300f:	89 c6                	mov    %eax,%esi
  803011:	48 bf 48 4c 80 00 00 	movabs $0x804c48,%rdi
  803018:	00 00 00 
  80301b:	b8 00 00 00 00       	mov    $0x0,%eax
  803020:	48 b9 1a 06 80 00 00 	movabs $0x80061a,%rcx
  803027:	00 00 00 
  80302a:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80302c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803031:	eb 2a                	jmp    80305d <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  803033:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803037:	48 8b 40 30          	mov    0x30(%rax),%rax
  80303b:	48 85 c0             	test   %rax,%rax
  80303e:	75 07                	jne    803047 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  803040:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803045:	eb 16                	jmp    80305d <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  803047:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80304b:	48 8b 40 30          	mov    0x30(%rax),%rax
  80304f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803053:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  803056:	89 ce                	mov    %ecx,%esi
  803058:	48 89 d7             	mov    %rdx,%rdi
  80305b:	ff d0                	callq  *%rax
}
  80305d:	c9                   	leaveq 
  80305e:	c3                   	retq   

000000000080305f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80305f:	55                   	push   %rbp
  803060:	48 89 e5             	mov    %rsp,%rbp
  803063:	48 83 ec 30          	sub    $0x30,%rsp
  803067:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80306a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80306e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803072:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803075:	48 89 d6             	mov    %rdx,%rsi
  803078:	89 c7                	mov    %eax,%edi
  80307a:	48 b8 fe 28 80 00 00 	movabs $0x8028fe,%rax
  803081:	00 00 00 
  803084:	ff d0                	callq  *%rax
  803086:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803089:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80308d:	78 24                	js     8030b3 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80308f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803093:	8b 00                	mov    (%rax),%eax
  803095:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803099:	48 89 d6             	mov    %rdx,%rsi
  80309c:	89 c7                	mov    %eax,%edi
  80309e:	48 b8 57 2a 80 00 00 	movabs $0x802a57,%rax
  8030a5:	00 00 00 
  8030a8:	ff d0                	callq  *%rax
  8030aa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030b1:	79 05                	jns    8030b8 <fstat+0x59>
		return r;
  8030b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030b6:	eb 5e                	jmp    803116 <fstat+0xb7>
	if (!dev->dev_stat)
  8030b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030bc:	48 8b 40 28          	mov    0x28(%rax),%rax
  8030c0:	48 85 c0             	test   %rax,%rax
  8030c3:	75 07                	jne    8030cc <fstat+0x6d>
		return -E_NOT_SUPP;
  8030c5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8030ca:	eb 4a                	jmp    803116 <fstat+0xb7>
	stat->st_name[0] = 0;
  8030cc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030d0:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8030d3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030d7:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8030de:	00 00 00 
	stat->st_isdir = 0;
  8030e1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030e5:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8030ec:	00 00 00 
	stat->st_dev = dev;
  8030ef:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8030f3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030f7:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8030fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803102:	48 8b 40 28          	mov    0x28(%rax),%rax
  803106:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80310a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80310e:	48 89 ce             	mov    %rcx,%rsi
  803111:	48 89 d7             	mov    %rdx,%rdi
  803114:	ff d0                	callq  *%rax
}
  803116:	c9                   	leaveq 
  803117:	c3                   	retq   

0000000000803118 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  803118:	55                   	push   %rbp
  803119:	48 89 e5             	mov    %rsp,%rbp
  80311c:	48 83 ec 20          	sub    $0x20,%rsp
  803120:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803124:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  803128:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80312c:	be 00 00 00 00       	mov    $0x0,%esi
  803131:	48 89 c7             	mov    %rax,%rdi
  803134:	48 b8 06 32 80 00 00 	movabs $0x803206,%rax
  80313b:	00 00 00 
  80313e:	ff d0                	callq  *%rax
  803140:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803143:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803147:	79 05                	jns    80314e <stat+0x36>
		return fd;
  803149:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80314c:	eb 2f                	jmp    80317d <stat+0x65>
	r = fstat(fd, stat);
  80314e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803152:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803155:	48 89 d6             	mov    %rdx,%rsi
  803158:	89 c7                	mov    %eax,%edi
  80315a:	48 b8 5f 30 80 00 00 	movabs $0x80305f,%rax
  803161:	00 00 00 
  803164:	ff d0                	callq  *%rax
  803166:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  803169:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80316c:	89 c7                	mov    %eax,%edi
  80316e:	48 b8 0e 2b 80 00 00 	movabs $0x802b0e,%rax
  803175:	00 00 00 
  803178:	ff d0                	callq  *%rax
	return r;
  80317a:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  80317d:	c9                   	leaveq 
  80317e:	c3                   	retq   

000000000080317f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80317f:	55                   	push   %rbp
  803180:	48 89 e5             	mov    %rsp,%rbp
  803183:	48 83 ec 10          	sub    $0x10,%rsp
  803187:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80318a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80318e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  803195:	00 00 00 
  803198:	8b 00                	mov    (%rax),%eax
  80319a:	85 c0                	test   %eax,%eax
  80319c:	75 1d                	jne    8031bb <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80319e:	bf 01 00 00 00       	mov    $0x1,%edi
  8031a3:	48 b8 5a 43 80 00 00 	movabs $0x80435a,%rax
  8031aa:	00 00 00 
  8031ad:	ff d0                	callq  *%rax
  8031af:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8031b6:	00 00 00 
  8031b9:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8031bb:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8031c2:	00 00 00 
  8031c5:	8b 00                	mov    (%rax),%eax
  8031c7:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8031ca:	b9 07 00 00 00       	mov    $0x7,%ecx
  8031cf:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8031d6:	00 00 00 
  8031d9:	89 c7                	mov    %eax,%edi
  8031db:	48 b8 5b 42 80 00 00 	movabs $0x80425b,%rax
  8031e2:	00 00 00 
  8031e5:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8031e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8031f0:	48 89 c6             	mov    %rax,%rsi
  8031f3:	bf 00 00 00 00       	mov    $0x0,%edi
  8031f8:	48 b8 a8 41 80 00 00 	movabs $0x8041a8,%rax
  8031ff:	00 00 00 
  803202:	ff d0                	callq  *%rax
}
  803204:	c9                   	leaveq 
  803205:	c3                   	retq   

0000000000803206 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  803206:	55                   	push   %rbp
  803207:	48 89 e5             	mov    %rsp,%rbp
  80320a:	48 83 ec 20          	sub    $0x20,%rsp
  80320e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803212:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here

	struct Fd *fd;
	int ret;
	if (strlen(path)>=MAXPATHLEN)
  803215:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803219:	48 89 c7             	mov    %rax,%rdi
  80321c:	48 b8 a4 11 80 00 00 	movabs $0x8011a4,%rax
  803223:	00 00 00 
  803226:	ff d0                	callq  *%rax
  803228:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80322d:	7e 0a                	jle    803239 <open+0x33>
		return -E_BAD_PATH;
  80322f:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803234:	e9 a5 00 00 00       	jmpq   8032de <open+0xd8>
	if ((ret=fd_alloc(&fd))<0)
  803239:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80323d:	48 89 c7             	mov    %rax,%rdi
  803240:	48 b8 66 28 80 00 00 	movabs $0x802866,%rax
  803247:	00 00 00 
  80324a:	ff d0                	callq  *%rax
  80324c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80324f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803253:	79 08                	jns    80325d <open+0x57>
		return ret;
  803255:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803258:	e9 81 00 00 00       	jmpq   8032de <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  80325d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803264:	00 00 00 
  803267:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80326a:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy (fsipcbuf.open.req_path, path);
  803270:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803274:	48 89 c6             	mov    %rax,%rsi
  803277:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80327e:	00 00 00 
  803281:	48 b8 10 12 80 00 00 	movabs $0x801210,%rax
  803288:	00 00 00 
  80328b:	ff d0                	callq  *%rax
	if ((ret=fsipc (FSREQ_OPEN, (void *) fd)) < 0)
  80328d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803291:	48 89 c6             	mov    %rax,%rsi
  803294:	bf 01 00 00 00       	mov    $0x1,%edi
  803299:	48 b8 7f 31 80 00 00 	movabs $0x80317f,%rax
  8032a0:	00 00 00 
  8032a3:	ff d0                	callq  *%rax
  8032a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032ac:	79 1d                	jns    8032cb <open+0xc5>
	{
		fd_close(fd,0);
  8032ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032b2:	be 00 00 00 00       	mov    $0x0,%esi
  8032b7:	48 89 c7             	mov    %rax,%rdi
  8032ba:	48 b8 8e 29 80 00 00 	movabs $0x80298e,%rax
  8032c1:	00 00 00 
  8032c4:	ff d0                	callq  *%rax
		return ret;
  8032c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032c9:	eb 13                	jmp    8032de <open+0xd8>
	}
	return fd2num (fd);
  8032cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032cf:	48 89 c7             	mov    %rax,%rdi
  8032d2:	48 b8 18 28 80 00 00 	movabs $0x802818,%rax
  8032d9:	00 00 00 
  8032dc:	ff d0                	callq  *%rax
	panic ("open not implemented");
}
  8032de:	c9                   	leaveq 
  8032df:	c3                   	retq   

00000000008032e0 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8032e0:	55                   	push   %rbp
  8032e1:	48 89 e5             	mov    %rsp,%rbp
  8032e4:	48 83 ec 10          	sub    $0x10,%rsp
  8032e8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8032ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032f0:	8b 50 0c             	mov    0xc(%rax),%edx
  8032f3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8032fa:	00 00 00 
  8032fd:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8032ff:	be 00 00 00 00       	mov    $0x0,%esi
  803304:	bf 06 00 00 00       	mov    $0x6,%edi
  803309:	48 b8 7f 31 80 00 00 	movabs $0x80317f,%rax
  803310:	00 00 00 
  803313:	ff d0                	callq  *%rax
}
  803315:	c9                   	leaveq 
  803316:	c3                   	retq   

0000000000803317 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803317:	55                   	push   %rbp
  803318:	48 89 e5             	mov    %rsp,%rbp
  80331b:	48 83 ec 30          	sub    $0x30,%rsp
  80331f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803323:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803327:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int ret;
	fsipcbuf.read.req_fileid=fd->fd_file.id;
  80332b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80332f:	8b 50 0c             	mov    0xc(%rax),%edx
  803332:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803339:	00 00 00 
  80333c:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n=n;
  80333e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803345:	00 00 00 
  803348:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80334c:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	if ((ret=fsipc(FSREQ_READ,NULL))<0)
  803350:	be 00 00 00 00       	mov    $0x0,%esi
  803355:	bf 03 00 00 00       	mov    $0x3,%edi
  80335a:	48 b8 7f 31 80 00 00 	movabs $0x80317f,%rax
  803361:	00 00 00 
  803364:	ff d0                	callq  *%rax
  803366:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803369:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80336d:	79 05                	jns    803374 <devfile_read+0x5d>
		return ret;
  80336f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803372:	eb 26                	jmp    80339a <devfile_read+0x83>
	memmove (buf, fsipcbuf.readRet.ret_buf, ret);
  803374:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803377:	48 63 d0             	movslq %eax,%rdx
  80337a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80337e:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803385:	00 00 00 
  803388:	48 89 c7             	mov    %rax,%rdi
  80338b:	48 b8 34 15 80 00 00 	movabs $0x801534,%rax
  803392:	00 00 00 
  803395:	ff d0                	callq  *%rax
	return ret;
  803397:	8b 45 fc             	mov    -0x4(%rbp),%eax
	panic("devfile_read not implemented");
}
  80339a:	c9                   	leaveq 
  80339b:	c3                   	retq   

000000000080339c <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80339c:	55                   	push   %rbp
  80339d:	48 89 e5             	mov    %rsp,%rbp
  8033a0:	48 83 ec 30          	sub    $0x30,%rsp
  8033a4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8033a8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8033ac:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here

	int ret;
	fsipcbuf.write.req_fileid=fd->fd_file.id;
  8033b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033b4:	8b 50 0c             	mov    0xc(%rax),%edx
  8033b7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8033be:	00 00 00 
  8033c1:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n=n>sizeof(fsipcbuf.write.req_buf)?sizeof(fsipcbuf.write.req_buf):n;
  8033c3:	b8 f4 0f 00 00       	mov    $0xff4,%eax
  8033c8:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8033cf:	00 
  8033d0:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  8033d5:	48 89 c2             	mov    %rax,%rdx
  8033d8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8033df:	00 00 00 
  8033e2:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove (fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  8033e6:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8033ed:	00 00 00 
  8033f0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8033f4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033f8:	48 89 c6             	mov    %rax,%rsi
  8033fb:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  803402:	00 00 00 
  803405:	48 b8 34 15 80 00 00 	movabs $0x801534,%rax
  80340c:	00 00 00 
  80340f:	ff d0                	callq  *%rax
	if ((ret=fsipc(FSREQ_WRITE,NULL))<0)
  803411:	be 00 00 00 00       	mov    $0x0,%esi
  803416:	bf 04 00 00 00       	mov    $0x4,%edi
  80341b:	48 b8 7f 31 80 00 00 	movabs $0x80317f,%rax
  803422:	00 00 00 
  803425:	ff d0                	callq  *%rax
  803427:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80342a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80342e:	79 05                	jns    803435 <devfile_write+0x99>
		return ret;
  803430:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803433:	eb 03                	jmp    803438 <devfile_write+0x9c>
	
	return ret;
  803435:	8b 45 fc             	mov    -0x4(%rbp),%eax


	panic("devfile_write not implemented");
}
  803438:	c9                   	leaveq 
  803439:	c3                   	retq   

000000000080343a <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80343a:	55                   	push   %rbp
  80343b:	48 89 e5             	mov    %rsp,%rbp
  80343e:	48 83 ec 20          	sub    $0x20,%rsp
  803442:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803446:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80344a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80344e:	8b 50 0c             	mov    0xc(%rax),%edx
  803451:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803458:	00 00 00 
  80345b:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80345d:	be 00 00 00 00       	mov    $0x0,%esi
  803462:	bf 05 00 00 00       	mov    $0x5,%edi
  803467:	48 b8 7f 31 80 00 00 	movabs $0x80317f,%rax
  80346e:	00 00 00 
  803471:	ff d0                	callq  *%rax
  803473:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803476:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80347a:	79 05                	jns    803481 <devfile_stat+0x47>
		return r;
  80347c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80347f:	eb 56                	jmp    8034d7 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803481:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803485:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80348c:	00 00 00 
  80348f:	48 89 c7             	mov    %rax,%rdi
  803492:	48 b8 10 12 80 00 00 	movabs $0x801210,%rax
  803499:	00 00 00 
  80349c:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80349e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8034a5:	00 00 00 
  8034a8:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8034ae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034b2:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8034b8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8034bf:	00 00 00 
  8034c2:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8034c8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034cc:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8034d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8034d7:	c9                   	leaveq 
  8034d8:	c3                   	retq   

00000000008034d9 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8034d9:	55                   	push   %rbp
  8034da:	48 89 e5             	mov    %rsp,%rbp
  8034dd:	48 83 ec 10          	sub    $0x10,%rsp
  8034e1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8034e5:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8034e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034ec:	8b 50 0c             	mov    0xc(%rax),%edx
  8034ef:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8034f6:	00 00 00 
  8034f9:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8034fb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803502:	00 00 00 
  803505:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803508:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80350b:	be 00 00 00 00       	mov    $0x0,%esi
  803510:	bf 02 00 00 00       	mov    $0x2,%edi
  803515:	48 b8 7f 31 80 00 00 	movabs $0x80317f,%rax
  80351c:	00 00 00 
  80351f:	ff d0                	callq  *%rax
}
  803521:	c9                   	leaveq 
  803522:	c3                   	retq   

0000000000803523 <remove>:

// Delete a file
int
remove(const char *path)
{
  803523:	55                   	push   %rbp
  803524:	48 89 e5             	mov    %rsp,%rbp
  803527:	48 83 ec 10          	sub    $0x10,%rsp
  80352b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  80352f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803533:	48 89 c7             	mov    %rax,%rdi
  803536:	48 b8 a4 11 80 00 00 	movabs $0x8011a4,%rax
  80353d:	00 00 00 
  803540:	ff d0                	callq  *%rax
  803542:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803547:	7e 07                	jle    803550 <remove+0x2d>
		return -E_BAD_PATH;
  803549:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80354e:	eb 33                	jmp    803583 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803550:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803554:	48 89 c6             	mov    %rax,%rsi
  803557:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  80355e:	00 00 00 
  803561:	48 b8 10 12 80 00 00 	movabs $0x801210,%rax
  803568:	00 00 00 
  80356b:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80356d:	be 00 00 00 00       	mov    $0x0,%esi
  803572:	bf 07 00 00 00       	mov    $0x7,%edi
  803577:	48 b8 7f 31 80 00 00 	movabs $0x80317f,%rax
  80357e:	00 00 00 
  803581:	ff d0                	callq  *%rax
}
  803583:	c9                   	leaveq 
  803584:	c3                   	retq   

0000000000803585 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803585:	55                   	push   %rbp
  803586:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803589:	be 00 00 00 00       	mov    $0x0,%esi
  80358e:	bf 08 00 00 00       	mov    $0x8,%edi
  803593:	48 b8 7f 31 80 00 00 	movabs $0x80317f,%rax
  80359a:	00 00 00 
  80359d:	ff d0                	callq  *%rax
}
  80359f:	5d                   	pop    %rbp
  8035a0:	c3                   	retq   

00000000008035a1 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8035a1:	55                   	push   %rbp
  8035a2:	48 89 e5             	mov    %rsp,%rbp
  8035a5:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8035ac:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8035b3:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8035ba:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8035c1:	be 00 00 00 00       	mov    $0x0,%esi
  8035c6:	48 89 c7             	mov    %rax,%rdi
  8035c9:	48 b8 06 32 80 00 00 	movabs $0x803206,%rax
  8035d0:	00 00 00 
  8035d3:	ff d0                	callq  *%rax
  8035d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8035d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035dc:	79 28                	jns    803606 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8035de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035e1:	89 c6                	mov    %eax,%esi
  8035e3:	48 bf 6e 4c 80 00 00 	movabs $0x804c6e,%rdi
  8035ea:	00 00 00 
  8035ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8035f2:	48 ba 1a 06 80 00 00 	movabs $0x80061a,%rdx
  8035f9:	00 00 00 
  8035fc:	ff d2                	callq  *%rdx
		return fd_src;
  8035fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803601:	e9 74 01 00 00       	jmpq   80377a <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803606:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  80360d:	be 01 01 00 00       	mov    $0x101,%esi
  803612:	48 89 c7             	mov    %rax,%rdi
  803615:	48 b8 06 32 80 00 00 	movabs $0x803206,%rax
  80361c:	00 00 00 
  80361f:	ff d0                	callq  *%rax
  803621:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803624:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803628:	79 39                	jns    803663 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  80362a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80362d:	89 c6                	mov    %eax,%esi
  80362f:	48 bf 84 4c 80 00 00 	movabs $0x804c84,%rdi
  803636:	00 00 00 
  803639:	b8 00 00 00 00       	mov    $0x0,%eax
  80363e:	48 ba 1a 06 80 00 00 	movabs $0x80061a,%rdx
  803645:	00 00 00 
  803648:	ff d2                	callq  *%rdx
		close(fd_src);
  80364a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80364d:	89 c7                	mov    %eax,%edi
  80364f:	48 b8 0e 2b 80 00 00 	movabs $0x802b0e,%rax
  803656:	00 00 00 
  803659:	ff d0                	callq  *%rax
		return fd_dest;
  80365b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80365e:	e9 17 01 00 00       	jmpq   80377a <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803663:	eb 74                	jmp    8036d9 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  803665:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803668:	48 63 d0             	movslq %eax,%rdx
  80366b:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803672:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803675:	48 89 ce             	mov    %rcx,%rsi
  803678:	89 c7                	mov    %eax,%edi
  80367a:	48 b8 7a 2e 80 00 00 	movabs $0x802e7a,%rax
  803681:	00 00 00 
  803684:	ff d0                	callq  *%rax
  803686:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803689:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80368d:	79 4a                	jns    8036d9 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  80368f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803692:	89 c6                	mov    %eax,%esi
  803694:	48 bf 9e 4c 80 00 00 	movabs $0x804c9e,%rdi
  80369b:	00 00 00 
  80369e:	b8 00 00 00 00       	mov    $0x0,%eax
  8036a3:	48 ba 1a 06 80 00 00 	movabs $0x80061a,%rdx
  8036aa:	00 00 00 
  8036ad:	ff d2                	callq  *%rdx
			close(fd_src);
  8036af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036b2:	89 c7                	mov    %eax,%edi
  8036b4:	48 b8 0e 2b 80 00 00 	movabs $0x802b0e,%rax
  8036bb:	00 00 00 
  8036be:	ff d0                	callq  *%rax
			close(fd_dest);
  8036c0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036c3:	89 c7                	mov    %eax,%edi
  8036c5:	48 b8 0e 2b 80 00 00 	movabs $0x802b0e,%rax
  8036cc:	00 00 00 
  8036cf:	ff d0                	callq  *%rax
			return write_size;
  8036d1:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8036d4:	e9 a1 00 00 00       	jmpq   80377a <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8036d9:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8036e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036e3:	ba 00 02 00 00       	mov    $0x200,%edx
  8036e8:	48 89 ce             	mov    %rcx,%rsi
  8036eb:	89 c7                	mov    %eax,%edi
  8036ed:	48 b8 30 2d 80 00 00 	movabs $0x802d30,%rax
  8036f4:	00 00 00 
  8036f7:	ff d0                	callq  *%rax
  8036f9:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8036fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803700:	0f 8f 5f ff ff ff    	jg     803665 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803706:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80370a:	79 47                	jns    803753 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  80370c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80370f:	89 c6                	mov    %eax,%esi
  803711:	48 bf b1 4c 80 00 00 	movabs $0x804cb1,%rdi
  803718:	00 00 00 
  80371b:	b8 00 00 00 00       	mov    $0x0,%eax
  803720:	48 ba 1a 06 80 00 00 	movabs $0x80061a,%rdx
  803727:	00 00 00 
  80372a:	ff d2                	callq  *%rdx
		close(fd_src);
  80372c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80372f:	89 c7                	mov    %eax,%edi
  803731:	48 b8 0e 2b 80 00 00 	movabs $0x802b0e,%rax
  803738:	00 00 00 
  80373b:	ff d0                	callq  *%rax
		close(fd_dest);
  80373d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803740:	89 c7                	mov    %eax,%edi
  803742:	48 b8 0e 2b 80 00 00 	movabs $0x802b0e,%rax
  803749:	00 00 00 
  80374c:	ff d0                	callq  *%rax
		return read_size;
  80374e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803751:	eb 27                	jmp    80377a <copy+0x1d9>
	}
	close(fd_src);
  803753:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803756:	89 c7                	mov    %eax,%edi
  803758:	48 b8 0e 2b 80 00 00 	movabs $0x802b0e,%rax
  80375f:	00 00 00 
  803762:	ff d0                	callq  *%rax
	close(fd_dest);
  803764:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803767:	89 c7                	mov    %eax,%edi
  803769:	48 b8 0e 2b 80 00 00 	movabs $0x802b0e,%rax
  803770:	00 00 00 
  803773:	ff d0                	callq  *%rax
	return 0;
  803775:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  80377a:	c9                   	leaveq 
  80377b:	c3                   	retq   

000000000080377c <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80377c:	55                   	push   %rbp
  80377d:	48 89 e5             	mov    %rsp,%rbp
  803780:	53                   	push   %rbx
  803781:	48 83 ec 38          	sub    $0x38,%rsp
  803785:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803789:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80378d:	48 89 c7             	mov    %rax,%rdi
  803790:	48 b8 66 28 80 00 00 	movabs $0x802866,%rax
  803797:	00 00 00 
  80379a:	ff d0                	callq  *%rax
  80379c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80379f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8037a3:	0f 88 bf 01 00 00    	js     803968 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8037a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037ad:	ba 07 04 00 00       	mov    $0x407,%edx
  8037b2:	48 89 c6             	mov    %rax,%rsi
  8037b5:	bf 00 00 00 00       	mov    $0x0,%edi
  8037ba:	48 b8 3f 1b 80 00 00 	movabs $0x801b3f,%rax
  8037c1:	00 00 00 
  8037c4:	ff d0                	callq  *%rax
  8037c6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8037c9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8037cd:	0f 88 95 01 00 00    	js     803968 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8037d3:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8037d7:	48 89 c7             	mov    %rax,%rdi
  8037da:	48 b8 66 28 80 00 00 	movabs $0x802866,%rax
  8037e1:	00 00 00 
  8037e4:	ff d0                	callq  *%rax
  8037e6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8037e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8037ed:	0f 88 5d 01 00 00    	js     803950 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8037f3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037f7:	ba 07 04 00 00       	mov    $0x407,%edx
  8037fc:	48 89 c6             	mov    %rax,%rsi
  8037ff:	bf 00 00 00 00       	mov    $0x0,%edi
  803804:	48 b8 3f 1b 80 00 00 	movabs $0x801b3f,%rax
  80380b:	00 00 00 
  80380e:	ff d0                	callq  *%rax
  803810:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803813:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803817:	0f 88 33 01 00 00    	js     803950 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80381d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803821:	48 89 c7             	mov    %rax,%rdi
  803824:	48 b8 3b 28 80 00 00 	movabs $0x80283b,%rax
  80382b:	00 00 00 
  80382e:	ff d0                	callq  *%rax
  803830:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803834:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803838:	ba 07 04 00 00       	mov    $0x407,%edx
  80383d:	48 89 c6             	mov    %rax,%rsi
  803840:	bf 00 00 00 00       	mov    $0x0,%edi
  803845:	48 b8 3f 1b 80 00 00 	movabs $0x801b3f,%rax
  80384c:	00 00 00 
  80384f:	ff d0                	callq  *%rax
  803851:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803854:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803858:	79 05                	jns    80385f <pipe+0xe3>
		goto err2;
  80385a:	e9 d9 00 00 00       	jmpq   803938 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80385f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803863:	48 89 c7             	mov    %rax,%rdi
  803866:	48 b8 3b 28 80 00 00 	movabs $0x80283b,%rax
  80386d:	00 00 00 
  803870:	ff d0                	callq  *%rax
  803872:	48 89 c2             	mov    %rax,%rdx
  803875:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803879:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80387f:	48 89 d1             	mov    %rdx,%rcx
  803882:	ba 00 00 00 00       	mov    $0x0,%edx
  803887:	48 89 c6             	mov    %rax,%rsi
  80388a:	bf 00 00 00 00       	mov    $0x0,%edi
  80388f:	48 b8 8f 1b 80 00 00 	movabs $0x801b8f,%rax
  803896:	00 00 00 
  803899:	ff d0                	callq  *%rax
  80389b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80389e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8038a2:	79 1b                	jns    8038bf <pipe+0x143>
		goto err3;
  8038a4:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8038a5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038a9:	48 89 c6             	mov    %rax,%rsi
  8038ac:	bf 00 00 00 00       	mov    $0x0,%edi
  8038b1:	48 b8 ea 1b 80 00 00 	movabs $0x801bea,%rax
  8038b8:	00 00 00 
  8038bb:	ff d0                	callq  *%rax
  8038bd:	eb 79                	jmp    803938 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8038bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038c3:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8038ca:	00 00 00 
  8038cd:	8b 12                	mov    (%rdx),%edx
  8038cf:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8038d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038d5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8038dc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038e0:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  8038e7:	00 00 00 
  8038ea:	8b 12                	mov    (%rdx),%edx
  8038ec:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8038ee:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8038f2:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8038f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8038fd:	48 89 c7             	mov    %rax,%rdi
  803900:	48 b8 18 28 80 00 00 	movabs $0x802818,%rax
  803907:	00 00 00 
  80390a:	ff d0                	callq  *%rax
  80390c:	89 c2                	mov    %eax,%edx
  80390e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803912:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803914:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803918:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80391c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803920:	48 89 c7             	mov    %rax,%rdi
  803923:	48 b8 18 28 80 00 00 	movabs $0x802818,%rax
  80392a:	00 00 00 
  80392d:	ff d0                	callq  *%rax
  80392f:	89 03                	mov    %eax,(%rbx)
	return 0;
  803931:	b8 00 00 00 00       	mov    $0x0,%eax
  803936:	eb 33                	jmp    80396b <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803938:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80393c:	48 89 c6             	mov    %rax,%rsi
  80393f:	bf 00 00 00 00       	mov    $0x0,%edi
  803944:	48 b8 ea 1b 80 00 00 	movabs $0x801bea,%rax
  80394b:	00 00 00 
  80394e:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803950:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803954:	48 89 c6             	mov    %rax,%rsi
  803957:	bf 00 00 00 00       	mov    $0x0,%edi
  80395c:	48 b8 ea 1b 80 00 00 	movabs $0x801bea,%rax
  803963:	00 00 00 
  803966:	ff d0                	callq  *%rax
err:
	return r;
  803968:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80396b:	48 83 c4 38          	add    $0x38,%rsp
  80396f:	5b                   	pop    %rbx
  803970:	5d                   	pop    %rbp
  803971:	c3                   	retq   

0000000000803972 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803972:	55                   	push   %rbp
  803973:	48 89 e5             	mov    %rsp,%rbp
  803976:	53                   	push   %rbx
  803977:	48 83 ec 28          	sub    $0x28,%rsp
  80397b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80397f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803983:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  80398a:	00 00 00 
  80398d:	48 8b 00             	mov    (%rax),%rax
  803990:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803996:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803999:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80399d:	48 89 c7             	mov    %rax,%rdi
  8039a0:	48 b8 cc 43 80 00 00 	movabs $0x8043cc,%rax
  8039a7:	00 00 00 
  8039aa:	ff d0                	callq  *%rax
  8039ac:	89 c3                	mov    %eax,%ebx
  8039ae:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039b2:	48 89 c7             	mov    %rax,%rdi
  8039b5:	48 b8 cc 43 80 00 00 	movabs $0x8043cc,%rax
  8039bc:	00 00 00 
  8039bf:	ff d0                	callq  *%rax
  8039c1:	39 c3                	cmp    %eax,%ebx
  8039c3:	0f 94 c0             	sete   %al
  8039c6:	0f b6 c0             	movzbl %al,%eax
  8039c9:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8039cc:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  8039d3:	00 00 00 
  8039d6:	48 8b 00             	mov    (%rax),%rax
  8039d9:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8039df:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8039e2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039e5:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8039e8:	75 05                	jne    8039ef <_pipeisclosed+0x7d>
			return ret;
  8039ea:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8039ed:	eb 4f                	jmp    803a3e <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  8039ef:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039f2:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8039f5:	74 42                	je     803a39 <_pipeisclosed+0xc7>
  8039f7:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8039fb:	75 3c                	jne    803a39 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8039fd:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  803a04:	00 00 00 
  803a07:	48 8b 00             	mov    (%rax),%rax
  803a0a:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803a10:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803a13:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a16:	89 c6                	mov    %eax,%esi
  803a18:	48 bf d1 4c 80 00 00 	movabs $0x804cd1,%rdi
  803a1f:	00 00 00 
  803a22:	b8 00 00 00 00       	mov    $0x0,%eax
  803a27:	49 b8 1a 06 80 00 00 	movabs $0x80061a,%r8
  803a2e:	00 00 00 
  803a31:	41 ff d0             	callq  *%r8
	}
  803a34:	e9 4a ff ff ff       	jmpq   803983 <_pipeisclosed+0x11>
  803a39:	e9 45 ff ff ff       	jmpq   803983 <_pipeisclosed+0x11>
}
  803a3e:	48 83 c4 28          	add    $0x28,%rsp
  803a42:	5b                   	pop    %rbx
  803a43:	5d                   	pop    %rbp
  803a44:	c3                   	retq   

0000000000803a45 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803a45:	55                   	push   %rbp
  803a46:	48 89 e5             	mov    %rsp,%rbp
  803a49:	48 83 ec 30          	sub    $0x30,%rsp
  803a4d:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803a50:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803a54:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803a57:	48 89 d6             	mov    %rdx,%rsi
  803a5a:	89 c7                	mov    %eax,%edi
  803a5c:	48 b8 fe 28 80 00 00 	movabs $0x8028fe,%rax
  803a63:	00 00 00 
  803a66:	ff d0                	callq  *%rax
  803a68:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a6b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a6f:	79 05                	jns    803a76 <pipeisclosed+0x31>
		return r;
  803a71:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a74:	eb 31                	jmp    803aa7 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803a76:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a7a:	48 89 c7             	mov    %rax,%rdi
  803a7d:	48 b8 3b 28 80 00 00 	movabs $0x80283b,%rax
  803a84:	00 00 00 
  803a87:	ff d0                	callq  *%rax
  803a89:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803a8d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a91:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a95:	48 89 d6             	mov    %rdx,%rsi
  803a98:	48 89 c7             	mov    %rax,%rdi
  803a9b:	48 b8 72 39 80 00 00 	movabs $0x803972,%rax
  803aa2:	00 00 00 
  803aa5:	ff d0                	callq  *%rax
}
  803aa7:	c9                   	leaveq 
  803aa8:	c3                   	retq   

0000000000803aa9 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803aa9:	55                   	push   %rbp
  803aaa:	48 89 e5             	mov    %rsp,%rbp
  803aad:	48 83 ec 40          	sub    $0x40,%rsp
  803ab1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803ab5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803ab9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803abd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ac1:	48 89 c7             	mov    %rax,%rdi
  803ac4:	48 b8 3b 28 80 00 00 	movabs $0x80283b,%rax
  803acb:	00 00 00 
  803ace:	ff d0                	callq  *%rax
  803ad0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803ad4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ad8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803adc:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803ae3:	00 
  803ae4:	e9 92 00 00 00       	jmpq   803b7b <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803ae9:	eb 41                	jmp    803b2c <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803aeb:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803af0:	74 09                	je     803afb <devpipe_read+0x52>
				return i;
  803af2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803af6:	e9 92 00 00 00       	jmpq   803b8d <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803afb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803aff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b03:	48 89 d6             	mov    %rdx,%rsi
  803b06:	48 89 c7             	mov    %rax,%rdi
  803b09:	48 b8 72 39 80 00 00 	movabs $0x803972,%rax
  803b10:	00 00 00 
  803b13:	ff d0                	callq  *%rax
  803b15:	85 c0                	test   %eax,%eax
  803b17:	74 07                	je     803b20 <devpipe_read+0x77>
				return 0;
  803b19:	b8 00 00 00 00       	mov    $0x0,%eax
  803b1e:	eb 6d                	jmp    803b8d <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803b20:	48 b8 01 1b 80 00 00 	movabs $0x801b01,%rax
  803b27:	00 00 00 
  803b2a:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803b2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b30:	8b 10                	mov    (%rax),%edx
  803b32:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b36:	8b 40 04             	mov    0x4(%rax),%eax
  803b39:	39 c2                	cmp    %eax,%edx
  803b3b:	74 ae                	je     803aeb <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803b3d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b41:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803b45:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803b49:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b4d:	8b 00                	mov    (%rax),%eax
  803b4f:	99                   	cltd   
  803b50:	c1 ea 1b             	shr    $0x1b,%edx
  803b53:	01 d0                	add    %edx,%eax
  803b55:	83 e0 1f             	and    $0x1f,%eax
  803b58:	29 d0                	sub    %edx,%eax
  803b5a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803b5e:	48 98                	cltq   
  803b60:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803b65:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803b67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b6b:	8b 00                	mov    (%rax),%eax
  803b6d:	8d 50 01             	lea    0x1(%rax),%edx
  803b70:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b74:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803b76:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803b7b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b7f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803b83:	0f 82 60 ff ff ff    	jb     803ae9 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803b89:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803b8d:	c9                   	leaveq 
  803b8e:	c3                   	retq   

0000000000803b8f <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803b8f:	55                   	push   %rbp
  803b90:	48 89 e5             	mov    %rsp,%rbp
  803b93:	48 83 ec 40          	sub    $0x40,%rsp
  803b97:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803b9b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803b9f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803ba3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ba7:	48 89 c7             	mov    %rax,%rdi
  803baa:	48 b8 3b 28 80 00 00 	movabs $0x80283b,%rax
  803bb1:	00 00 00 
  803bb4:	ff d0                	callq  *%rax
  803bb6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803bba:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bbe:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803bc2:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803bc9:	00 
  803bca:	e9 8e 00 00 00       	jmpq   803c5d <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803bcf:	eb 31                	jmp    803c02 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803bd1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803bd5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bd9:	48 89 d6             	mov    %rdx,%rsi
  803bdc:	48 89 c7             	mov    %rax,%rdi
  803bdf:	48 b8 72 39 80 00 00 	movabs $0x803972,%rax
  803be6:	00 00 00 
  803be9:	ff d0                	callq  *%rax
  803beb:	85 c0                	test   %eax,%eax
  803bed:	74 07                	je     803bf6 <devpipe_write+0x67>
				return 0;
  803bef:	b8 00 00 00 00       	mov    $0x0,%eax
  803bf4:	eb 79                	jmp    803c6f <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803bf6:	48 b8 01 1b 80 00 00 	movabs $0x801b01,%rax
  803bfd:	00 00 00 
  803c00:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803c02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c06:	8b 40 04             	mov    0x4(%rax),%eax
  803c09:	48 63 d0             	movslq %eax,%rdx
  803c0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c10:	8b 00                	mov    (%rax),%eax
  803c12:	48 98                	cltq   
  803c14:	48 83 c0 20          	add    $0x20,%rax
  803c18:	48 39 c2             	cmp    %rax,%rdx
  803c1b:	73 b4                	jae    803bd1 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803c1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c21:	8b 40 04             	mov    0x4(%rax),%eax
  803c24:	99                   	cltd   
  803c25:	c1 ea 1b             	shr    $0x1b,%edx
  803c28:	01 d0                	add    %edx,%eax
  803c2a:	83 e0 1f             	and    $0x1f,%eax
  803c2d:	29 d0                	sub    %edx,%eax
  803c2f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803c33:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803c37:	48 01 ca             	add    %rcx,%rdx
  803c3a:	0f b6 0a             	movzbl (%rdx),%ecx
  803c3d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803c41:	48 98                	cltq   
  803c43:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803c47:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c4b:	8b 40 04             	mov    0x4(%rax),%eax
  803c4e:	8d 50 01             	lea    0x1(%rax),%edx
  803c51:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c55:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803c58:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803c5d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c61:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803c65:	0f 82 64 ff ff ff    	jb     803bcf <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803c6b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803c6f:	c9                   	leaveq 
  803c70:	c3                   	retq   

0000000000803c71 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803c71:	55                   	push   %rbp
  803c72:	48 89 e5             	mov    %rsp,%rbp
  803c75:	48 83 ec 20          	sub    $0x20,%rsp
  803c79:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803c7d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803c81:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c85:	48 89 c7             	mov    %rax,%rdi
  803c88:	48 b8 3b 28 80 00 00 	movabs $0x80283b,%rax
  803c8f:	00 00 00 
  803c92:	ff d0                	callq  *%rax
  803c94:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803c98:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c9c:	48 be e4 4c 80 00 00 	movabs $0x804ce4,%rsi
  803ca3:	00 00 00 
  803ca6:	48 89 c7             	mov    %rax,%rdi
  803ca9:	48 b8 10 12 80 00 00 	movabs $0x801210,%rax
  803cb0:	00 00 00 
  803cb3:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803cb5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cb9:	8b 50 04             	mov    0x4(%rax),%edx
  803cbc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cc0:	8b 00                	mov    (%rax),%eax
  803cc2:	29 c2                	sub    %eax,%edx
  803cc4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cc8:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803cce:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cd2:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803cd9:	00 00 00 
	stat->st_dev = &devpipe;
  803cdc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ce0:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803ce7:	00 00 00 
  803cea:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803cf1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803cf6:	c9                   	leaveq 
  803cf7:	c3                   	retq   

0000000000803cf8 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803cf8:	55                   	push   %rbp
  803cf9:	48 89 e5             	mov    %rsp,%rbp
  803cfc:	48 83 ec 10          	sub    $0x10,%rsp
  803d00:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803d04:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d08:	48 89 c6             	mov    %rax,%rsi
  803d0b:	bf 00 00 00 00       	mov    $0x0,%edi
  803d10:	48 b8 ea 1b 80 00 00 	movabs $0x801bea,%rax
  803d17:	00 00 00 
  803d1a:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803d1c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d20:	48 89 c7             	mov    %rax,%rdi
  803d23:	48 b8 3b 28 80 00 00 	movabs $0x80283b,%rax
  803d2a:	00 00 00 
  803d2d:	ff d0                	callq  *%rax
  803d2f:	48 89 c6             	mov    %rax,%rsi
  803d32:	bf 00 00 00 00       	mov    $0x0,%edi
  803d37:	48 b8 ea 1b 80 00 00 	movabs $0x801bea,%rax
  803d3e:	00 00 00 
  803d41:	ff d0                	callq  *%rax
}
  803d43:	c9                   	leaveq 
  803d44:	c3                   	retq   

0000000000803d45 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  803d45:	55                   	push   %rbp
  803d46:	48 89 e5             	mov    %rsp,%rbp
  803d49:	48 83 ec 20          	sub    $0x20,%rsp
  803d4d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  803d50:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803d54:	75 35                	jne    803d8b <wait+0x46>
  803d56:	48 b9 eb 4c 80 00 00 	movabs $0x804ceb,%rcx
  803d5d:	00 00 00 
  803d60:	48 ba f6 4c 80 00 00 	movabs $0x804cf6,%rdx
  803d67:	00 00 00 
  803d6a:	be 09 00 00 00       	mov    $0x9,%esi
  803d6f:	48 bf 0b 4d 80 00 00 	movabs $0x804d0b,%rdi
  803d76:	00 00 00 
  803d79:	b8 00 00 00 00       	mov    $0x0,%eax
  803d7e:	49 b8 e1 03 80 00 00 	movabs $0x8003e1,%r8
  803d85:	00 00 00 
  803d88:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  803d8b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d8e:	25 ff 03 00 00       	and    $0x3ff,%eax
  803d93:	48 98                	cltq   
  803d95:	48 69 d0 70 01 00 00 	imul   $0x170,%rax,%rdx
  803d9c:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803da3:	00 00 00 
  803da6:	48 01 d0             	add    %rdx,%rax
  803da9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803dad:	eb 0c                	jmp    803dbb <wait+0x76>
		sys_yield();
  803daf:	48 b8 01 1b 80 00 00 	movabs $0x801b01,%rax
  803db6:	00 00 00 
  803db9:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803dbb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803dbf:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803dc5:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803dc8:	75 0e                	jne    803dd8 <wait+0x93>
  803dca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803dce:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803dd4:	85 c0                	test   %eax,%eax
  803dd6:	75 d7                	jne    803daf <wait+0x6a>
		sys_yield();
}
  803dd8:	c9                   	leaveq 
  803dd9:	c3                   	retq   

0000000000803dda <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803dda:	55                   	push   %rbp
  803ddb:	48 89 e5             	mov    %rsp,%rbp
  803dde:	48 83 ec 20          	sub    $0x20,%rsp
  803de2:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803de5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803de8:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803deb:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803def:	be 01 00 00 00       	mov    $0x1,%esi
  803df4:	48 89 c7             	mov    %rax,%rdi
  803df7:	48 b8 f7 19 80 00 00 	movabs $0x8019f7,%rax
  803dfe:	00 00 00 
  803e01:	ff d0                	callq  *%rax
}
  803e03:	c9                   	leaveq 
  803e04:	c3                   	retq   

0000000000803e05 <getchar>:

int
getchar(void)
{
  803e05:	55                   	push   %rbp
  803e06:	48 89 e5             	mov    %rsp,%rbp
  803e09:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803e0d:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803e11:	ba 01 00 00 00       	mov    $0x1,%edx
  803e16:	48 89 c6             	mov    %rax,%rsi
  803e19:	bf 00 00 00 00       	mov    $0x0,%edi
  803e1e:	48 b8 30 2d 80 00 00 	movabs $0x802d30,%rax
  803e25:	00 00 00 
  803e28:	ff d0                	callq  *%rax
  803e2a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803e2d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e31:	79 05                	jns    803e38 <getchar+0x33>
		return r;
  803e33:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e36:	eb 14                	jmp    803e4c <getchar+0x47>
	if (r < 1)
  803e38:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e3c:	7f 07                	jg     803e45 <getchar+0x40>
		return -E_EOF;
  803e3e:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803e43:	eb 07                	jmp    803e4c <getchar+0x47>
	return c;
  803e45:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803e49:	0f b6 c0             	movzbl %al,%eax
}
  803e4c:	c9                   	leaveq 
  803e4d:	c3                   	retq   

0000000000803e4e <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803e4e:	55                   	push   %rbp
  803e4f:	48 89 e5             	mov    %rsp,%rbp
  803e52:	48 83 ec 20          	sub    $0x20,%rsp
  803e56:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803e59:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803e5d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e60:	48 89 d6             	mov    %rdx,%rsi
  803e63:	89 c7                	mov    %eax,%edi
  803e65:	48 b8 fe 28 80 00 00 	movabs $0x8028fe,%rax
  803e6c:	00 00 00 
  803e6f:	ff d0                	callq  *%rax
  803e71:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e74:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e78:	79 05                	jns    803e7f <iscons+0x31>
		return r;
  803e7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e7d:	eb 1a                	jmp    803e99 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803e7f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e83:	8b 10                	mov    (%rax),%edx
  803e85:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  803e8c:	00 00 00 
  803e8f:	8b 00                	mov    (%rax),%eax
  803e91:	39 c2                	cmp    %eax,%edx
  803e93:	0f 94 c0             	sete   %al
  803e96:	0f b6 c0             	movzbl %al,%eax
}
  803e99:	c9                   	leaveq 
  803e9a:	c3                   	retq   

0000000000803e9b <opencons>:

int
opencons(void)
{
  803e9b:	55                   	push   %rbp
  803e9c:	48 89 e5             	mov    %rsp,%rbp
  803e9f:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803ea3:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803ea7:	48 89 c7             	mov    %rax,%rdi
  803eaa:	48 b8 66 28 80 00 00 	movabs $0x802866,%rax
  803eb1:	00 00 00 
  803eb4:	ff d0                	callq  *%rax
  803eb6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803eb9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ebd:	79 05                	jns    803ec4 <opencons+0x29>
		return r;
  803ebf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ec2:	eb 5b                	jmp    803f1f <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803ec4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ec8:	ba 07 04 00 00       	mov    $0x407,%edx
  803ecd:	48 89 c6             	mov    %rax,%rsi
  803ed0:	bf 00 00 00 00       	mov    $0x0,%edi
  803ed5:	48 b8 3f 1b 80 00 00 	movabs $0x801b3f,%rax
  803edc:	00 00 00 
  803edf:	ff d0                	callq  *%rax
  803ee1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ee4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ee8:	79 05                	jns    803eef <opencons+0x54>
		return r;
  803eea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803eed:	eb 30                	jmp    803f1f <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803eef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ef3:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  803efa:	00 00 00 
  803efd:	8b 12                	mov    (%rdx),%edx
  803eff:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803f01:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f05:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803f0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f10:	48 89 c7             	mov    %rax,%rdi
  803f13:	48 b8 18 28 80 00 00 	movabs $0x802818,%rax
  803f1a:	00 00 00 
  803f1d:	ff d0                	callq  *%rax
}
  803f1f:	c9                   	leaveq 
  803f20:	c3                   	retq   

0000000000803f21 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803f21:	55                   	push   %rbp
  803f22:	48 89 e5             	mov    %rsp,%rbp
  803f25:	48 83 ec 30          	sub    $0x30,%rsp
  803f29:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803f2d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803f31:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803f35:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803f3a:	75 07                	jne    803f43 <devcons_read+0x22>
		return 0;
  803f3c:	b8 00 00 00 00       	mov    $0x0,%eax
  803f41:	eb 4b                	jmp    803f8e <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  803f43:	eb 0c                	jmp    803f51 <devcons_read+0x30>
		sys_yield();
  803f45:	48 b8 01 1b 80 00 00 	movabs $0x801b01,%rax
  803f4c:	00 00 00 
  803f4f:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803f51:	48 b8 41 1a 80 00 00 	movabs $0x801a41,%rax
  803f58:	00 00 00 
  803f5b:	ff d0                	callq  *%rax
  803f5d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f60:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f64:	74 df                	je     803f45 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  803f66:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f6a:	79 05                	jns    803f71 <devcons_read+0x50>
		return c;
  803f6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f6f:	eb 1d                	jmp    803f8e <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  803f71:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803f75:	75 07                	jne    803f7e <devcons_read+0x5d>
		return 0;
  803f77:	b8 00 00 00 00       	mov    $0x0,%eax
  803f7c:	eb 10                	jmp    803f8e <devcons_read+0x6d>
	*(char*)vbuf = c;
  803f7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f81:	89 c2                	mov    %eax,%edx
  803f83:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f87:	88 10                	mov    %dl,(%rax)
	return 1;
  803f89:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803f8e:	c9                   	leaveq 
  803f8f:	c3                   	retq   

0000000000803f90 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803f90:	55                   	push   %rbp
  803f91:	48 89 e5             	mov    %rsp,%rbp
  803f94:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803f9b:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803fa2:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803fa9:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803fb0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803fb7:	eb 76                	jmp    80402f <devcons_write+0x9f>
		m = n - tot;
  803fb9:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803fc0:	89 c2                	mov    %eax,%edx
  803fc2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fc5:	29 c2                	sub    %eax,%edx
  803fc7:	89 d0                	mov    %edx,%eax
  803fc9:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803fcc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803fcf:	83 f8 7f             	cmp    $0x7f,%eax
  803fd2:	76 07                	jbe    803fdb <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803fd4:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803fdb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803fde:	48 63 d0             	movslq %eax,%rdx
  803fe1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fe4:	48 63 c8             	movslq %eax,%rcx
  803fe7:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803fee:	48 01 c1             	add    %rax,%rcx
  803ff1:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803ff8:	48 89 ce             	mov    %rcx,%rsi
  803ffb:	48 89 c7             	mov    %rax,%rdi
  803ffe:	48 b8 34 15 80 00 00 	movabs $0x801534,%rax
  804005:	00 00 00 
  804008:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80400a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80400d:	48 63 d0             	movslq %eax,%rdx
  804010:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804017:	48 89 d6             	mov    %rdx,%rsi
  80401a:	48 89 c7             	mov    %rax,%rdi
  80401d:	48 b8 f7 19 80 00 00 	movabs $0x8019f7,%rax
  804024:	00 00 00 
  804027:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804029:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80402c:	01 45 fc             	add    %eax,-0x4(%rbp)
  80402f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804032:	48 98                	cltq   
  804034:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80403b:	0f 82 78 ff ff ff    	jb     803fb9 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804041:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804044:	c9                   	leaveq 
  804045:	c3                   	retq   

0000000000804046 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804046:	55                   	push   %rbp
  804047:	48 89 e5             	mov    %rsp,%rbp
  80404a:	48 83 ec 08          	sub    $0x8,%rsp
  80404e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804052:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804057:	c9                   	leaveq 
  804058:	c3                   	retq   

0000000000804059 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804059:	55                   	push   %rbp
  80405a:	48 89 e5             	mov    %rsp,%rbp
  80405d:	48 83 ec 10          	sub    $0x10,%rsp
  804061:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804065:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804069:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80406d:	48 be 1b 4d 80 00 00 	movabs $0x804d1b,%rsi
  804074:	00 00 00 
  804077:	48 89 c7             	mov    %rax,%rdi
  80407a:	48 b8 10 12 80 00 00 	movabs $0x801210,%rax
  804081:	00 00 00 
  804084:	ff d0                	callq  *%rax
	return 0;
  804086:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80408b:	c9                   	leaveq 
  80408c:	c3                   	retq   

000000000080408d <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80408d:	55                   	push   %rbp
  80408e:	48 89 e5             	mov    %rsp,%rbp
  804091:	48 83 ec 20          	sub    $0x20,%rsp
  804095:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  804099:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8040a0:	00 00 00 
  8040a3:	48 8b 00             	mov    (%rax),%rax
  8040a6:	48 85 c0             	test   %rax,%rax
  8040a9:	75 6f                	jne    80411a <set_pgfault_handler+0x8d>
		// First time through!
		// LAB 4: Your code here.

		if ((r = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0)
  8040ab:	ba 07 00 00 00       	mov    $0x7,%edx
  8040b0:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8040b5:	bf 00 00 00 00       	mov    $0x0,%edi
  8040ba:	48 b8 3f 1b 80 00 00 	movabs $0x801b3f,%rax
  8040c1:	00 00 00 
  8040c4:	ff d0                	callq  *%rax
  8040c6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040cd:	79 30                	jns    8040ff <set_pgfault_handler+0x72>
            panic("set_pgfault_handler: %d\n", r);
  8040cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040d2:	89 c1                	mov    %eax,%ecx
  8040d4:	48 ba 22 4d 80 00 00 	movabs $0x804d22,%rdx
  8040db:	00 00 00 
  8040de:	be 22 00 00 00       	mov    $0x22,%esi
  8040e3:	48 bf 3b 4d 80 00 00 	movabs $0x804d3b,%rdi
  8040ea:	00 00 00 
  8040ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8040f2:	49 b8 e1 03 80 00 00 	movabs $0x8003e1,%r8
  8040f9:	00 00 00 
  8040fc:	41 ff d0             	callq  *%r8
        sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  8040ff:	48 be 2d 41 80 00 00 	movabs $0x80412d,%rsi
  804106:	00 00 00 
  804109:	bf 00 00 00 00       	mov    $0x0,%edi
  80410e:	48 b8 c9 1c 80 00 00 	movabs $0x801cc9,%rax
  804115:	00 00 00 
  804118:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80411a:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  804121:	00 00 00 
  804124:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804128:	48 89 10             	mov    %rdx,(%rax)
}
  80412b:	c9                   	leaveq 
  80412c:	c3                   	retq   

000000000080412d <_pgfault_upcall>:
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF


	movq %rsp, %rdi;	
  80412d:	48 89 e7             	mov    %rsp,%rdi
	movq 136(%rsp), %rbx;
  804130:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  804137:	00 
	movq 152(%rsp), %rsp;// Going to another stack for storing rip	
  804138:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  80413f:	00 
	pushq %rbx;
  804140:	53                   	push   %rbx
	movq %rsp, %rbx;	
  804141:	48 89 e3             	mov    %rsp,%rbx
	movq %rdi, %rsp;	
  804144:	48 89 fc             	mov    %rdi,%rsp
	movq %rbx, 152(%rsp)	
  804147:	48 89 9c 24 98 00 00 	mov    %rbx,0x98(%rsp)
  80414e:	00 
   
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16, %rsp;	
  80414f:	48 83 c4 10          	add    $0x10,%rsp
	POPA_;  // getting all register values back
  804153:	4c 8b 3c 24          	mov    (%rsp),%r15
  804157:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  80415c:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804161:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804166:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  80416b:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804170:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804175:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80417a:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  80417f:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804184:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804189:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  80418e:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804193:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804198:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  80419d:	48 83 c4 78          	add    $0x78,%rsp
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.


	add $8, %rsp; //Jump rip field  
  8041a1:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  8041a5:	9d                   	popfq  

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp   //USTACK
  8041a6:	5c                   	pop    %rsp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret   
  8041a7:	c3                   	retq   

00000000008041a8 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8041a8:	55                   	push   %rbp
  8041a9:	48 89 e5             	mov    %rsp,%rbp
  8041ac:	48 83 ec 30          	sub    $0x30,%rsp
  8041b0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8041b4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8041b8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	//LAB 4: Your code here.
	if (!pg) pg=(void*)-1;
  8041bc:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8041c1:	75 08                	jne    8041cb <ipc_recv+0x23>
  8041c3:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  8041ca:	ff 
	int res=sys_ipc_recv(pg);
  8041cb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041cf:	48 89 c7             	mov    %rax,%rdi
  8041d2:	48 b8 b3 1d 80 00 00 	movabs $0x801db3,%rax
  8041d9:	00 00 00 
  8041dc:	ff d0                	callq  *%rax
  8041de:	89 45 fc             	mov    %eax,-0x4(%rbp)
	
	if (from_env_store) *from_env_store=res==0?thisenv->env_ipc_from:0;
  8041e1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8041e6:	74 26                	je     80420e <ipc_recv+0x66>
  8041e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041ec:	75 15                	jne    804203 <ipc_recv+0x5b>
  8041ee:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  8041f5:	00 00 00 
  8041f8:	48 8b 00             	mov    (%rax),%rax
  8041fb:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  804201:	eb 05                	jmp    804208 <ipc_recv+0x60>
  804203:	b8 00 00 00 00       	mov    $0x0,%eax
  804208:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80420c:	89 02                	mov    %eax,(%rdx)
	if (perm_store) *perm_store=res==0?thisenv->env_ipc_perm:0;
  80420e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804213:	74 26                	je     80423b <ipc_recv+0x93>
  804215:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804219:	75 15                	jne    804230 <ipc_recv+0x88>
  80421b:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  804222:	00 00 00 
  804225:	48 8b 00             	mov    (%rax),%rax
  804228:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  80422e:	eb 05                	jmp    804235 <ipc_recv+0x8d>
  804230:	b8 00 00 00 00       	mov    $0x0,%eax
  804235:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  804239:	89 02                	mov    %eax,(%rdx)
	return res!=0?res:thisenv->env_ipc_value;
  80423b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80423f:	75 15                	jne    804256 <ipc_recv+0xae>
  804241:	48 b8 20 74 80 00 00 	movabs $0x807420,%rax
  804248:	00 00 00 
  80424b:	48 8b 00             	mov    (%rax),%rax
  80424e:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  804254:	eb 03                	jmp    804259 <ipc_recv+0xb1>
  804256:	8b 45 fc             	mov    -0x4(%rbp),%eax
	

}
  804259:	c9                   	leaveq 
  80425a:	c3                   	retq   

000000000080425b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80425b:	55                   	push   %rbp
  80425c:	48 89 e5             	mov    %rsp,%rbp
  80425f:	48 83 ec 30          	sub    $0x30,%rsp
  804263:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804266:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804269:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80426d:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.

	if (!pg) pg=(void*)-1;
  804270:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804275:	75 0a                	jne    804281 <ipc_send+0x26>
  804277:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  80427e:	ff 
	int res;
	while ((res=sys_ipc_try_send(to_env, val, pg, perm))<0){
  80427f:	eb 3e                	jmp    8042bf <ipc_send+0x64>
  804281:	eb 3c                	jmp    8042bf <ipc_send+0x64>
		if(res!=-E_IPC_NOT_RECV)
  804283:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804287:	74 2a                	je     8042b3 <ipc_send+0x58>
			panic("ipc_send:error other than -E_IPC_NOT_RECV\n");
  804289:	48 ba 50 4d 80 00 00 	movabs $0x804d50,%rdx
  804290:	00 00 00 
  804293:	be 39 00 00 00       	mov    $0x39,%esi
  804298:	48 bf 7b 4d 80 00 00 	movabs $0x804d7b,%rdi
  80429f:	00 00 00 
  8042a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8042a7:	48 b9 e1 03 80 00 00 	movabs $0x8003e1,%rcx
  8042ae:	00 00 00 
  8042b1:	ff d1                	callq  *%rcx
		sys_yield();  
  8042b3:	48 b8 01 1b 80 00 00 	movabs $0x801b01,%rax
  8042ba:	00 00 00 
  8042bd:	ff d0                	callq  *%rax
{
	// LAB 4: Your code here.

	if (!pg) pg=(void*)-1;
	int res;
	while ((res=sys_ipc_try_send(to_env, val, pg, perm))<0){
  8042bf:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8042c2:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8042c5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8042c9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8042cc:	89 c7                	mov    %eax,%edi
  8042ce:	48 b8 5e 1d 80 00 00 	movabs $0x801d5e,%rax
  8042d5:	00 00 00 
  8042d8:	ff d0                	callq  *%rax
  8042da:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8042dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042e1:	78 a0                	js     804283 <ipc_send+0x28>
			panic("ipc_send:error other than -E_IPC_NOT_RECV\n");
		sys_yield();  
	}
	//panic("ipc_send not implemented");

}
  8042e3:	c9                   	leaveq 
  8042e4:	c3                   	retq   

00000000008042e5 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  8042e5:	55                   	push   %rbp
  8042e6:	48 89 e5             	mov    %rsp,%rbp
  8042e9:	48 83 ec 10          	sub    $0x10,%rsp
  8042ed:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	// LAB 8: Your code here.
	panic("ipc_recv not implemented in VM guest");
  8042f1:	48 ba 88 4d 80 00 00 	movabs $0x804d88,%rdx
  8042f8:	00 00 00 
  8042fb:	be 47 00 00 00       	mov    $0x47,%esi
  804300:	48 bf 7b 4d 80 00 00 	movabs $0x804d7b,%rdi
  804307:	00 00 00 
  80430a:	b8 00 00 00 00       	mov    $0x0,%eax
  80430f:	48 b9 e1 03 80 00 00 	movabs $0x8003e1,%rcx
  804316:	00 00 00 
  804319:	ff d1                	callq  *%rcx

000000000080431b <ipc_host_send>:

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80431b:	55                   	push   %rbp
  80431c:	48 89 e5             	mov    %rsp,%rbp
  80431f:	48 83 ec 20          	sub    $0x20,%rsp
  804323:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804326:	89 75 f8             	mov    %esi,-0x8(%rbp)
  804329:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  80432d:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 8: Your code here.
	panic("ipc_send not implemented in VM guest");
  804330:	48 ba b0 4d 80 00 00 	movabs $0x804db0,%rdx
  804337:	00 00 00 
  80433a:	be 50 00 00 00       	mov    $0x50,%esi
  80433f:	48 bf 7b 4d 80 00 00 	movabs $0x804d7b,%rdi
  804346:	00 00 00 
  804349:	b8 00 00 00 00       	mov    $0x0,%eax
  80434e:	48 b9 e1 03 80 00 00 	movabs $0x8003e1,%rcx
  804355:	00 00 00 
  804358:	ff d1                	callq  *%rcx

000000000080435a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80435a:	55                   	push   %rbp
  80435b:	48 89 e5             	mov    %rsp,%rbp
  80435e:	48 83 ec 14          	sub    $0x14,%rsp
  804362:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804365:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80436c:	eb 4e                	jmp    8043bc <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  80436e:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804375:	00 00 00 
  804378:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80437b:	48 98                	cltq   
  80437d:	48 69 c0 70 01 00 00 	imul   $0x170,%rax,%rax
  804384:	48 01 d0             	add    %rdx,%rax
  804387:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80438d:	8b 00                	mov    (%rax),%eax
  80438f:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804392:	75 24                	jne    8043b8 <ipc_find_env+0x5e>
			return envs[i].env_id;
  804394:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80439b:	00 00 00 
  80439e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043a1:	48 98                	cltq   
  8043a3:	48 69 c0 70 01 00 00 	imul   $0x170,%rax,%rax
  8043aa:	48 01 d0             	add    %rdx,%rax
  8043ad:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8043b3:	8b 40 08             	mov    0x8(%rax),%eax
  8043b6:	eb 12                	jmp    8043ca <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8043b8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8043bc:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8043c3:	7e a9                	jle    80436e <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;

	}
	return 0;
  8043c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8043ca:	c9                   	leaveq 
  8043cb:	c3                   	retq   

00000000008043cc <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8043cc:	55                   	push   %rbp
  8043cd:	48 89 e5             	mov    %rsp,%rbp
  8043d0:	48 83 ec 18          	sub    $0x18,%rsp
  8043d4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8043d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8043dc:	48 c1 e8 15          	shr    $0x15,%rax
  8043e0:	48 89 c2             	mov    %rax,%rdx
  8043e3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8043ea:	01 00 00 
  8043ed:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8043f1:	83 e0 01             	and    $0x1,%eax
  8043f4:	48 85 c0             	test   %rax,%rax
  8043f7:	75 07                	jne    804400 <pageref+0x34>
		return 0;
  8043f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8043fe:	eb 53                	jmp    804453 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804400:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804404:	48 c1 e8 0c          	shr    $0xc,%rax
  804408:	48 89 c2             	mov    %rax,%rdx
  80440b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804412:	01 00 00 
  804415:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804419:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80441d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804421:	83 e0 01             	and    $0x1,%eax
  804424:	48 85 c0             	test   %rax,%rax
  804427:	75 07                	jne    804430 <pageref+0x64>
		return 0;
  804429:	b8 00 00 00 00       	mov    $0x0,%eax
  80442e:	eb 23                	jmp    804453 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804430:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804434:	48 c1 e8 0c          	shr    $0xc,%rax
  804438:	48 89 c2             	mov    %rax,%rdx
  80443b:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804442:	00 00 00 
  804445:	48 c1 e2 04          	shl    $0x4,%rdx
  804449:	48 01 d0             	add    %rdx,%rax
  80444c:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804450:	0f b7 c0             	movzwl %ax,%eax
}
  804453:	c9                   	leaveq 
  804454:	c3                   	retq   
