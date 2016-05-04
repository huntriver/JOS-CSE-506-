
vmm/guest/obj/user/testpipe:     file format elf64-x86-64


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
  80003c:	e8 fe 04 00 00       	callq  80053f <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

char *msg = "Now is the time for all good men to come to the aid of their party.";

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	53                   	push   %rbx
  800048:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  80004f:	89 bd 6c ff ff ff    	mov    %edi,-0x94(%rbp)
  800055:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
	char buf[100];
	int i, pid, p[2];

	binaryname = "pipereadeof";
  80005c:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800063:	00 00 00 
  800066:	48 bb a4 46 80 00 00 	movabs $0x8046a4,%rbx
  80006d:	00 00 00 
  800070:	48 89 18             	mov    %rbx,(%rax)

	if ((i = pipe(p)) < 0)
  800073:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80007a:	48 89 c7             	mov    %rax,%rdi
  80007d:	48 b8 80 39 80 00 00 	movabs $0x803980,%rax
  800084:	00 00 00 
  800087:	ff d0                	callq  *%rax
  800089:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80008c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800090:	79 30                	jns    8000c2 <umain+0x7f>
		panic("pipe: %e", i);
  800092:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800095:	89 c1                	mov    %eax,%ecx
  800097:	48 ba b0 46 80 00 00 	movabs $0x8046b0,%rdx
  80009e:	00 00 00 
  8000a1:	be 0e 00 00 00       	mov    $0xe,%esi
  8000a6:	48 bf b9 46 80 00 00 	movabs $0x8046b9,%rdi
  8000ad:	00 00 00 
  8000b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b5:	49 b8 e5 05 80 00 00 	movabs $0x8005e5,%r8
  8000bc:	00 00 00 
  8000bf:	41 ff d0             	callq  *%r8

	if ((pid = fork()) < 0)
  8000c2:	48 b8 10 26 80 00 00 	movabs $0x802610,%rax
  8000c9:	00 00 00 
  8000cc:	ff d0                	callq  *%rax
  8000ce:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8000d1:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8000d5:	79 30                	jns    800107 <umain+0xc4>
		panic("fork: %e", i);
  8000d7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000da:	89 c1                	mov    %eax,%ecx
  8000dc:	48 ba c9 46 80 00 00 	movabs $0x8046c9,%rdx
  8000e3:	00 00 00 
  8000e6:	be 11 00 00 00       	mov    $0x11,%esi
  8000eb:	48 bf b9 46 80 00 00 	movabs $0x8046b9,%rdi
  8000f2:	00 00 00 
  8000f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000fa:	49 b8 e5 05 80 00 00 	movabs $0x8005e5,%r8
  800101:	00 00 00 
  800104:	41 ff d0             	callq  *%r8

	if (pid == 0) {
  800107:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80010b:	0f 85 5c 01 00 00    	jne    80026d <umain+0x22a>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[1]);
  800111:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  800117:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80011e:	00 00 00 
  800121:	48 8b 00             	mov    (%rax),%rax
  800124:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80012a:	89 c6                	mov    %eax,%esi
  80012c:	48 bf d2 46 80 00 00 	movabs $0x8046d2,%rdi
  800133:	00 00 00 
  800136:	b8 00 00 00 00       	mov    $0x0,%eax
  80013b:	48 b9 1e 08 80 00 00 	movabs $0x80081e,%rcx
  800142:	00 00 00 
  800145:	ff d1                	callq  *%rcx
		close(p[1]);
  800147:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  80014d:	89 c7                	mov    %eax,%edi
  80014f:	48 b8 12 2d 80 00 00 	movabs $0x802d12,%rax
  800156:	00 00 00 
  800159:	ff d0                	callq  *%rax
		cprintf("[%08x] pipereadeof readn %d\n", thisenv->env_id, p[0]);
  80015b:	8b 95 70 ff ff ff    	mov    -0x90(%rbp),%edx
  800161:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800168:	00 00 00 
  80016b:	48 8b 00             	mov    (%rax),%rax
  80016e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800174:	89 c6                	mov    %eax,%esi
  800176:	48 bf ef 46 80 00 00 	movabs $0x8046ef,%rdi
  80017d:	00 00 00 
  800180:	b8 00 00 00 00       	mov    $0x0,%eax
  800185:	48 b9 1e 08 80 00 00 	movabs $0x80081e,%rcx
  80018c:	00 00 00 
  80018f:	ff d1                	callq  *%rcx
		i = readn(p[0], buf, sizeof buf-1);
  800191:	8b 85 70 ff ff ff    	mov    -0x90(%rbp),%eax
  800197:	48 8d 4d 80          	lea    -0x80(%rbp),%rcx
  80019b:	ba 63 00 00 00       	mov    $0x63,%edx
  8001a0:	48 89 ce             	mov    %rcx,%rsi
  8001a3:	89 c7                	mov    %eax,%edi
  8001a5:	48 b8 09 30 80 00 00 	movabs $0x803009,%rax
  8001ac:	00 00 00 
  8001af:	ff d0                	callq  *%rax
  8001b1:	89 45 ec             	mov    %eax,-0x14(%rbp)
		if (i < 0)
  8001b4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8001b8:	79 30                	jns    8001ea <umain+0x1a7>
			panic("read: %e", i);
  8001ba:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001bd:	89 c1                	mov    %eax,%ecx
  8001bf:	48 ba 0c 47 80 00 00 	movabs $0x80470c,%rdx
  8001c6:	00 00 00 
  8001c9:	be 19 00 00 00       	mov    $0x19,%esi
  8001ce:	48 bf b9 46 80 00 00 	movabs $0x8046b9,%rdi
  8001d5:	00 00 00 
  8001d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8001dd:	49 b8 e5 05 80 00 00 	movabs $0x8005e5,%r8
  8001e4:	00 00 00 
  8001e7:	41 ff d0             	callq  *%r8
		buf[i] = 0;
  8001ea:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001ed:	48 98                	cltq   
  8001ef:	c6 44 05 80 00       	movb   $0x0,-0x80(%rbp,%rax,1)
		if (strcmp(buf, msg) == 0)
  8001f4:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8001fb:	00 00 00 
  8001fe:	48 8b 10             	mov    (%rax),%rdx
  800201:	48 8d 45 80          	lea    -0x80(%rbp),%rax
  800205:	48 89 d6             	mov    %rdx,%rsi
  800208:	48 89 c7             	mov    %rax,%rdi
  80020b:	48 b8 76 15 80 00 00 	movabs $0x801576,%rax
  800212:	00 00 00 
  800215:	ff d0                	callq  *%rax
  800217:	85 c0                	test   %eax,%eax
  800219:	75 1d                	jne    800238 <umain+0x1f5>
			cprintf("\npipe read closed properly\n");
  80021b:	48 bf 15 47 80 00 00 	movabs $0x804715,%rdi
  800222:	00 00 00 
  800225:	b8 00 00 00 00       	mov    $0x0,%eax
  80022a:	48 ba 1e 08 80 00 00 	movabs $0x80081e,%rdx
  800231:	00 00 00 
  800234:	ff d2                	callq  *%rdx
  800236:	eb 24                	jmp    80025c <umain+0x219>
		else
			cprintf("\ngot %d bytes: %s\n", i, buf);
  800238:	48 8d 55 80          	lea    -0x80(%rbp),%rdx
  80023c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80023f:	89 c6                	mov    %eax,%esi
  800241:	48 bf 31 47 80 00 00 	movabs $0x804731,%rdi
  800248:	00 00 00 
  80024b:	b8 00 00 00 00       	mov    $0x0,%eax
  800250:	48 b9 1e 08 80 00 00 	movabs $0x80081e,%rcx
  800257:	00 00 00 
  80025a:	ff d1                	callq  *%rcx
		exit();
  80025c:	48 b8 c2 05 80 00 00 	movabs $0x8005c2,%rax
  800263:	00 00 00 
  800266:	ff d0                	callq  *%rax
  800268:	e9 2b 01 00 00       	jmpq   800398 <umain+0x355>
	} else {
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[0]);
  80026d:	8b 95 70 ff ff ff    	mov    -0x90(%rbp),%edx
  800273:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80027a:	00 00 00 
  80027d:	48 8b 00             	mov    (%rax),%rax
  800280:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800286:	89 c6                	mov    %eax,%esi
  800288:	48 bf d2 46 80 00 00 	movabs $0x8046d2,%rdi
  80028f:	00 00 00 
  800292:	b8 00 00 00 00       	mov    $0x0,%eax
  800297:	48 b9 1e 08 80 00 00 	movabs $0x80081e,%rcx
  80029e:	00 00 00 
  8002a1:	ff d1                	callq  *%rcx
		close(p[0]);
  8002a3:	8b 85 70 ff ff ff    	mov    -0x90(%rbp),%eax
  8002a9:	89 c7                	mov    %eax,%edi
  8002ab:	48 b8 12 2d 80 00 00 	movabs $0x802d12,%rax
  8002b2:	00 00 00 
  8002b5:	ff d0                	callq  *%rax
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
  8002b7:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  8002bd:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8002c4:	00 00 00 
  8002c7:	48 8b 00             	mov    (%rax),%rax
  8002ca:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8002d0:	89 c6                	mov    %eax,%esi
  8002d2:	48 bf 44 47 80 00 00 	movabs $0x804744,%rdi
  8002d9:	00 00 00 
  8002dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8002e1:	48 b9 1e 08 80 00 00 	movabs $0x80081e,%rcx
  8002e8:	00 00 00 
  8002eb:	ff d1                	callq  *%rcx
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
  8002ed:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002f4:	00 00 00 
  8002f7:	48 8b 00             	mov    (%rax),%rax
  8002fa:	48 89 c7             	mov    %rax,%rdi
  8002fd:	48 b8 a8 13 80 00 00 	movabs $0x8013a8,%rax
  800304:	00 00 00 
  800307:	ff d0                	callq  *%rax
  800309:	48 63 d0             	movslq %eax,%rdx
  80030c:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800313:	00 00 00 
  800316:	48 8b 08             	mov    (%rax),%rcx
  800319:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  80031f:	48 89 ce             	mov    %rcx,%rsi
  800322:	89 c7                	mov    %eax,%edi
  800324:	48 b8 7e 30 80 00 00 	movabs $0x80307e,%rax
  80032b:	00 00 00 
  80032e:	ff d0                	callq  *%rax
  800330:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800333:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80033a:	00 00 00 
  80033d:	48 8b 00             	mov    (%rax),%rax
  800340:	48 89 c7             	mov    %rax,%rdi
  800343:	48 b8 a8 13 80 00 00 	movabs $0x8013a8,%rax
  80034a:	00 00 00 
  80034d:	ff d0                	callq  *%rax
  80034f:	39 45 ec             	cmp    %eax,-0x14(%rbp)
  800352:	74 30                	je     800384 <umain+0x341>
			panic("write: %e", i);
  800354:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800357:	89 c1                	mov    %eax,%ecx
  800359:	48 ba 61 47 80 00 00 	movabs $0x804761,%rdx
  800360:	00 00 00 
  800363:	be 25 00 00 00       	mov    $0x25,%esi
  800368:	48 bf b9 46 80 00 00 	movabs $0x8046b9,%rdi
  80036f:	00 00 00 
  800372:	b8 00 00 00 00       	mov    $0x0,%eax
  800377:	49 b8 e5 05 80 00 00 	movabs $0x8005e5,%r8
  80037e:	00 00 00 
  800381:	41 ff d0             	callq  *%r8
		close(p[1]);
  800384:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  80038a:	89 c7                	mov    %eax,%edi
  80038c:	48 b8 12 2d 80 00 00 	movabs $0x802d12,%rax
  800393:	00 00 00 
  800396:	ff d0                	callq  *%rax
	}
	wait(pid);
  800398:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80039b:	89 c7                	mov    %eax,%edi
  80039d:	48 b8 49 3f 80 00 00 	movabs $0x803f49,%rax
  8003a4:	00 00 00 
  8003a7:	ff d0                	callq  *%rax

	binaryname = "pipewriteeof";
  8003a9:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  8003b0:	00 00 00 
  8003b3:	48 bb 6b 47 80 00 00 	movabs $0x80476b,%rbx
  8003ba:	00 00 00 
  8003bd:	48 89 18             	mov    %rbx,(%rax)
	if ((i = pipe(p)) < 0)
  8003c0:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8003c7:	48 89 c7             	mov    %rax,%rdi
  8003ca:	48 b8 80 39 80 00 00 	movabs $0x803980,%rax
  8003d1:	00 00 00 
  8003d4:	ff d0                	callq  *%rax
  8003d6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8003d9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8003dd:	79 30                	jns    80040f <umain+0x3cc>
		panic("pipe: %e", i);
  8003df:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8003e2:	89 c1                	mov    %eax,%ecx
  8003e4:	48 ba b0 46 80 00 00 	movabs $0x8046b0,%rdx
  8003eb:	00 00 00 
  8003ee:	be 2c 00 00 00       	mov    $0x2c,%esi
  8003f3:	48 bf b9 46 80 00 00 	movabs $0x8046b9,%rdi
  8003fa:	00 00 00 
  8003fd:	b8 00 00 00 00       	mov    $0x0,%eax
  800402:	49 b8 e5 05 80 00 00 	movabs $0x8005e5,%r8
  800409:	00 00 00 
  80040c:	41 ff d0             	callq  *%r8

	if ((pid = fork()) < 0)
  80040f:	48 b8 10 26 80 00 00 	movabs $0x802610,%rax
  800416:	00 00 00 
  800419:	ff d0                	callq  *%rax
  80041b:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80041e:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800422:	79 30                	jns    800454 <umain+0x411>
		panic("fork: %e", i);
  800424:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800427:	89 c1                	mov    %eax,%ecx
  800429:	48 ba c9 46 80 00 00 	movabs $0x8046c9,%rdx
  800430:	00 00 00 
  800433:	be 2f 00 00 00       	mov    $0x2f,%esi
  800438:	48 bf b9 46 80 00 00 	movabs $0x8046b9,%rdi
  80043f:	00 00 00 
  800442:	b8 00 00 00 00       	mov    $0x0,%eax
  800447:	49 b8 e5 05 80 00 00 	movabs $0x8005e5,%r8
  80044e:	00 00 00 
  800451:	41 ff d0             	callq  *%r8

	if (pid == 0) {
  800454:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800458:	0f 85 83 00 00 00    	jne    8004e1 <umain+0x49e>
		close(p[0]);
  80045e:	8b 85 70 ff ff ff    	mov    -0x90(%rbp),%eax
  800464:	89 c7                	mov    %eax,%edi
  800466:	48 b8 12 2d 80 00 00 	movabs $0x802d12,%rax
  80046d:	00 00 00 
  800470:	ff d0                	callq  *%rax
		while (1) {
			cprintf(".");
  800472:	48 bf 78 47 80 00 00 	movabs $0x804778,%rdi
  800479:	00 00 00 
  80047c:	b8 00 00 00 00       	mov    $0x0,%eax
  800481:	48 ba 1e 08 80 00 00 	movabs $0x80081e,%rdx
  800488:	00 00 00 
  80048b:	ff d2                	callq  *%rdx
			if (write(p[1], "x", 1) != 1)
  80048d:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  800493:	ba 01 00 00 00       	mov    $0x1,%edx
  800498:	48 be 7a 47 80 00 00 	movabs $0x80477a,%rsi
  80049f:	00 00 00 
  8004a2:	89 c7                	mov    %eax,%edi
  8004a4:	48 b8 7e 30 80 00 00 	movabs $0x80307e,%rax
  8004ab:	00 00 00 
  8004ae:	ff d0                	callq  *%rax
  8004b0:	83 f8 01             	cmp    $0x1,%eax
  8004b3:	74 2a                	je     8004df <umain+0x49c>
				break;
  8004b5:	90                   	nop
		}
		cprintf("\npipe write closed properly\n");
  8004b6:	48 bf 7c 47 80 00 00 	movabs $0x80477c,%rdi
  8004bd:	00 00 00 
  8004c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c5:	48 ba 1e 08 80 00 00 	movabs $0x80081e,%rdx
  8004cc:	00 00 00 
  8004cf:	ff d2                	callq  *%rdx
		exit();
  8004d1:	48 b8 c2 05 80 00 00 	movabs $0x8005c2,%rax
  8004d8:	00 00 00 
  8004db:	ff d0                	callq  *%rax
  8004dd:	eb 02                	jmp    8004e1 <umain+0x49e>
		close(p[0]);
		while (1) {
			cprintf(".");
			if (write(p[1], "x", 1) != 1)
				break;
		}
  8004df:	eb 91                	jmp    800472 <umain+0x42f>
		cprintf("\npipe write closed properly\n");
		exit();
	}
	close(p[0]);
  8004e1:	8b 85 70 ff ff ff    	mov    -0x90(%rbp),%eax
  8004e7:	89 c7                	mov    %eax,%edi
  8004e9:	48 b8 12 2d 80 00 00 	movabs $0x802d12,%rax
  8004f0:	00 00 00 
  8004f3:	ff d0                	callq  *%rax
	close(p[1]);
  8004f5:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  8004fb:	89 c7                	mov    %eax,%edi
  8004fd:	48 b8 12 2d 80 00 00 	movabs $0x802d12,%rax
  800504:	00 00 00 
  800507:	ff d0                	callq  *%rax
	wait(pid);
  800509:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80050c:	89 c7                	mov    %eax,%edi
  80050e:	48 b8 49 3f 80 00 00 	movabs $0x803f49,%rax
  800515:	00 00 00 
  800518:	ff d0                	callq  *%rax

	cprintf("pipe tests passed\n");
  80051a:	48 bf 99 47 80 00 00 	movabs $0x804799,%rdi
  800521:	00 00 00 
  800524:	b8 00 00 00 00       	mov    $0x0,%eax
  800529:	48 ba 1e 08 80 00 00 	movabs $0x80081e,%rdx
  800530:	00 00 00 
  800533:	ff d2                	callq  *%rdx
}
  800535:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  80053c:	5b                   	pop    %rbx
  80053d:	5d                   	pop    %rbp
  80053e:	c3                   	retq   

000000000080053f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80053f:	55                   	push   %rbp
  800540:	48 89 e5             	mov    %rsp,%rbp
  800543:	48 83 ec 10          	sub    $0x10,%rsp
  800547:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80054a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = envs+ENVX(sys_getenvid ());
  80054e:	48 b8 c7 1c 80 00 00 	movabs $0x801cc7,%rax
  800555:	00 00 00 
  800558:	ff d0                	callq  *%rax
  80055a:	48 98                	cltq   
  80055c:	25 ff 03 00 00       	and    $0x3ff,%eax
  800561:	48 69 d0 70 01 00 00 	imul   $0x170,%rax,%rdx
  800568:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80056f:	00 00 00 
  800572:	48 01 c2             	add    %rax,%rdx
  800575:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80057c:	00 00 00 
  80057f:	48 89 10             	mov    %rdx,(%rax)
	// thisenv = 0;


	// save the name of the program so that panic() can use it
	if (argc > 0)
  800582:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800586:	7e 14                	jle    80059c <libmain+0x5d>
		binaryname = argv[0];
  800588:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80058c:	48 8b 10             	mov    (%rax),%rdx
  80058f:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800596:	00 00 00 
  800599:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  80059c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8005a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005a3:	48 89 d6             	mov    %rdx,%rsi
  8005a6:	89 c7                	mov    %eax,%edi
  8005a8:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8005af:	00 00 00 
  8005b2:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8005b4:	48 b8 c2 05 80 00 00 	movabs $0x8005c2,%rax
  8005bb:	00 00 00 
  8005be:	ff d0                	callq  *%rax
}
  8005c0:	c9                   	leaveq 
  8005c1:	c3                   	retq   

00000000008005c2 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8005c2:	55                   	push   %rbp
  8005c3:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  8005c6:	48 b8 5d 2d 80 00 00 	movabs $0x802d5d,%rax
  8005cd:	00 00 00 
  8005d0:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  8005d2:	bf 00 00 00 00       	mov    $0x0,%edi
  8005d7:	48 b8 83 1c 80 00 00 	movabs $0x801c83,%rax
  8005de:	00 00 00 
  8005e1:	ff d0                	callq  *%rax
}
  8005e3:	5d                   	pop    %rbp
  8005e4:	c3                   	retq   

00000000008005e5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8005e5:	55                   	push   %rbp
  8005e6:	48 89 e5             	mov    %rsp,%rbp
  8005e9:	53                   	push   %rbx
  8005ea:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8005f1:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8005f8:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8005fe:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800605:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80060c:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800613:	84 c0                	test   %al,%al
  800615:	74 23                	je     80063a <_panic+0x55>
  800617:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80061e:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800622:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800626:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80062a:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80062e:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800632:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800636:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  80063a:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800641:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800648:	00 00 00 
  80064b:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800652:	00 00 00 
  800655:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800659:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800660:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800667:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80066e:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800675:	00 00 00 
  800678:	48 8b 18             	mov    (%rax),%rbx
  80067b:	48 b8 c7 1c 80 00 00 	movabs $0x801cc7,%rax
  800682:	00 00 00 
  800685:	ff d0                	callq  *%rax
  800687:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  80068d:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800694:	41 89 c8             	mov    %ecx,%r8d
  800697:	48 89 d1             	mov    %rdx,%rcx
  80069a:	48 89 da             	mov    %rbx,%rdx
  80069d:	89 c6                	mov    %eax,%esi
  80069f:	48 bf b8 47 80 00 00 	movabs $0x8047b8,%rdi
  8006a6:	00 00 00 
  8006a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8006ae:	49 b9 1e 08 80 00 00 	movabs $0x80081e,%r9
  8006b5:	00 00 00 
  8006b8:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8006bb:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8006c2:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8006c9:	48 89 d6             	mov    %rdx,%rsi
  8006cc:	48 89 c7             	mov    %rax,%rdi
  8006cf:	48 b8 72 07 80 00 00 	movabs $0x800772,%rax
  8006d6:	00 00 00 
  8006d9:	ff d0                	callq  *%rax
	cprintf("\n");
  8006db:	48 bf db 47 80 00 00 	movabs $0x8047db,%rdi
  8006e2:	00 00 00 
  8006e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8006ea:	48 ba 1e 08 80 00 00 	movabs $0x80081e,%rdx
  8006f1:	00 00 00 
  8006f4:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8006f6:	cc                   	int3   
  8006f7:	eb fd                	jmp    8006f6 <_panic+0x111>

00000000008006f9 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8006f9:	55                   	push   %rbp
  8006fa:	48 89 e5             	mov    %rsp,%rbp
  8006fd:	48 83 ec 10          	sub    $0x10,%rsp
  800701:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800704:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800708:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80070c:	8b 00                	mov    (%rax),%eax
  80070e:	8d 48 01             	lea    0x1(%rax),%ecx
  800711:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800715:	89 0a                	mov    %ecx,(%rdx)
  800717:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80071a:	89 d1                	mov    %edx,%ecx
  80071c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800720:	48 98                	cltq   
  800722:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800726:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80072a:	8b 00                	mov    (%rax),%eax
  80072c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800731:	75 2c                	jne    80075f <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800733:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800737:	8b 00                	mov    (%rax),%eax
  800739:	48 98                	cltq   
  80073b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80073f:	48 83 c2 08          	add    $0x8,%rdx
  800743:	48 89 c6             	mov    %rax,%rsi
  800746:	48 89 d7             	mov    %rdx,%rdi
  800749:	48 b8 fb 1b 80 00 00 	movabs $0x801bfb,%rax
  800750:	00 00 00 
  800753:	ff d0                	callq  *%rax
        b->idx = 0;
  800755:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800759:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80075f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800763:	8b 40 04             	mov    0x4(%rax),%eax
  800766:	8d 50 01             	lea    0x1(%rax),%edx
  800769:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80076d:	89 50 04             	mov    %edx,0x4(%rax)
}
  800770:	c9                   	leaveq 
  800771:	c3                   	retq   

0000000000800772 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800772:	55                   	push   %rbp
  800773:	48 89 e5             	mov    %rsp,%rbp
  800776:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80077d:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800784:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80078b:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800792:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800799:	48 8b 0a             	mov    (%rdx),%rcx
  80079c:	48 89 08             	mov    %rcx,(%rax)
  80079f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007a3:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007a7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007ab:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8007af:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8007b6:	00 00 00 
    b.cnt = 0;
  8007b9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8007c0:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8007c3:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8007ca:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8007d1:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8007d8:	48 89 c6             	mov    %rax,%rsi
  8007db:	48 bf f9 06 80 00 00 	movabs $0x8006f9,%rdi
  8007e2:	00 00 00 
  8007e5:	48 b8 d1 0b 80 00 00 	movabs $0x800bd1,%rax
  8007ec:	00 00 00 
  8007ef:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8007f1:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8007f7:	48 98                	cltq   
  8007f9:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800800:	48 83 c2 08          	add    $0x8,%rdx
  800804:	48 89 c6             	mov    %rax,%rsi
  800807:	48 89 d7             	mov    %rdx,%rdi
  80080a:	48 b8 fb 1b 80 00 00 	movabs $0x801bfb,%rax
  800811:	00 00 00 
  800814:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800816:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80081c:	c9                   	leaveq 
  80081d:	c3                   	retq   

000000000080081e <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80081e:	55                   	push   %rbp
  80081f:	48 89 e5             	mov    %rsp,%rbp
  800822:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800829:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800830:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800837:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80083e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800845:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80084c:	84 c0                	test   %al,%al
  80084e:	74 20                	je     800870 <cprintf+0x52>
  800850:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800854:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800858:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80085c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800860:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800864:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800868:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80086c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800870:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800877:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80087e:	00 00 00 
  800881:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800888:	00 00 00 
  80088b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80088f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800896:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80089d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8008a4:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8008ab:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8008b2:	48 8b 0a             	mov    (%rdx),%rcx
  8008b5:	48 89 08             	mov    %rcx,(%rax)
  8008b8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8008bc:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8008c0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8008c4:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8008c8:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8008cf:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8008d6:	48 89 d6             	mov    %rdx,%rsi
  8008d9:	48 89 c7             	mov    %rax,%rdi
  8008dc:	48 b8 72 07 80 00 00 	movabs $0x800772,%rax
  8008e3:	00 00 00 
  8008e6:	ff d0                	callq  *%rax
  8008e8:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8008ee:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8008f4:	c9                   	leaveq 
  8008f5:	c3                   	retq   

00000000008008f6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008f6:	55                   	push   %rbp
  8008f7:	48 89 e5             	mov    %rsp,%rbp
  8008fa:	53                   	push   %rbx
  8008fb:	48 83 ec 38          	sub    $0x38,%rsp
  8008ff:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800903:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800907:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80090b:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80090e:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  800912:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800916:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800919:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80091d:	77 3b                	ja     80095a <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80091f:	8b 45 d0             	mov    -0x30(%rbp),%eax
  800922:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800926:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800929:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80092d:	ba 00 00 00 00       	mov    $0x0,%edx
  800932:	48 f7 f3             	div    %rbx
  800935:	48 89 c2             	mov    %rax,%rdx
  800938:	8b 7d cc             	mov    -0x34(%rbp),%edi
  80093b:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80093e:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  800942:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800946:	41 89 f9             	mov    %edi,%r9d
  800949:	48 89 c7             	mov    %rax,%rdi
  80094c:	48 b8 f6 08 80 00 00 	movabs $0x8008f6,%rax
  800953:	00 00 00 
  800956:	ff d0                	callq  *%rax
  800958:	eb 1e                	jmp    800978 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80095a:	eb 12                	jmp    80096e <printnum+0x78>
			putch(padc, putdat);
  80095c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  800960:	8b 55 cc             	mov    -0x34(%rbp),%edx
  800963:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800967:	48 89 ce             	mov    %rcx,%rsi
  80096a:	89 d7                	mov    %edx,%edi
  80096c:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80096e:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  800972:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  800976:	7f e4                	jg     80095c <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800978:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80097b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80097f:	ba 00 00 00 00       	mov    $0x0,%edx
  800984:	48 f7 f1             	div    %rcx
  800987:	48 89 d0             	mov    %rdx,%rax
  80098a:	48 ba d0 49 80 00 00 	movabs $0x8049d0,%rdx
  800991:	00 00 00 
  800994:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  800998:	0f be d0             	movsbl %al,%edx
  80099b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80099f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a3:	48 89 ce             	mov    %rcx,%rsi
  8009a6:	89 d7                	mov    %edx,%edi
  8009a8:	ff d0                	callq  *%rax
}
  8009aa:	48 83 c4 38          	add    $0x38,%rsp
  8009ae:	5b                   	pop    %rbx
  8009af:	5d                   	pop    %rbp
  8009b0:	c3                   	retq   

00000000008009b1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8009b1:	55                   	push   %rbp
  8009b2:	48 89 e5             	mov    %rsp,%rbp
  8009b5:	48 83 ec 1c          	sub    $0x1c,%rsp
  8009b9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8009bd:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8009c0:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8009c4:	7e 52                	jle    800a18 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8009c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ca:	8b 00                	mov    (%rax),%eax
  8009cc:	83 f8 30             	cmp    $0x30,%eax
  8009cf:	73 24                	jae    8009f5 <getuint+0x44>
  8009d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009dd:	8b 00                	mov    (%rax),%eax
  8009df:	89 c0                	mov    %eax,%eax
  8009e1:	48 01 d0             	add    %rdx,%rax
  8009e4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009e8:	8b 12                	mov    (%rdx),%edx
  8009ea:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009ed:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009f1:	89 0a                	mov    %ecx,(%rdx)
  8009f3:	eb 17                	jmp    800a0c <getuint+0x5b>
  8009f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009f9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009fd:	48 89 d0             	mov    %rdx,%rax
  800a00:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a04:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a08:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a0c:	48 8b 00             	mov    (%rax),%rax
  800a0f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a13:	e9 a3 00 00 00       	jmpq   800abb <getuint+0x10a>
	else if (lflag)
  800a18:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a1c:	74 4f                	je     800a6d <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  800a1e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a22:	8b 00                	mov    (%rax),%eax
  800a24:	83 f8 30             	cmp    $0x30,%eax
  800a27:	73 24                	jae    800a4d <getuint+0x9c>
  800a29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a2d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a35:	8b 00                	mov    (%rax),%eax
  800a37:	89 c0                	mov    %eax,%eax
  800a39:	48 01 d0             	add    %rdx,%rax
  800a3c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a40:	8b 12                	mov    (%rdx),%edx
  800a42:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a45:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a49:	89 0a                	mov    %ecx,(%rdx)
  800a4b:	eb 17                	jmp    800a64 <getuint+0xb3>
  800a4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a51:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a55:	48 89 d0             	mov    %rdx,%rax
  800a58:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a5c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a60:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a64:	48 8b 00             	mov    (%rax),%rax
  800a67:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a6b:	eb 4e                	jmp    800abb <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800a6d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a71:	8b 00                	mov    (%rax),%eax
  800a73:	83 f8 30             	cmp    $0x30,%eax
  800a76:	73 24                	jae    800a9c <getuint+0xeb>
  800a78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a7c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a80:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a84:	8b 00                	mov    (%rax),%eax
  800a86:	89 c0                	mov    %eax,%eax
  800a88:	48 01 d0             	add    %rdx,%rax
  800a8b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a8f:	8b 12                	mov    (%rdx),%edx
  800a91:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a94:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a98:	89 0a                	mov    %ecx,(%rdx)
  800a9a:	eb 17                	jmp    800ab3 <getuint+0x102>
  800a9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aa0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800aa4:	48 89 d0             	mov    %rdx,%rax
  800aa7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800aab:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aaf:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ab3:	8b 00                	mov    (%rax),%eax
  800ab5:	89 c0                	mov    %eax,%eax
  800ab7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800abb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800abf:	c9                   	leaveq 
  800ac0:	c3                   	retq   

0000000000800ac1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ac1:	55                   	push   %rbp
  800ac2:	48 89 e5             	mov    %rsp,%rbp
  800ac5:	48 83 ec 1c          	sub    $0x1c,%rsp
  800ac9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800acd:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800ad0:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800ad4:	7e 52                	jle    800b28 <getint+0x67>
		x=va_arg(*ap, long long);
  800ad6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ada:	8b 00                	mov    (%rax),%eax
  800adc:	83 f8 30             	cmp    $0x30,%eax
  800adf:	73 24                	jae    800b05 <getint+0x44>
  800ae1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ae5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ae9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aed:	8b 00                	mov    (%rax),%eax
  800aef:	89 c0                	mov    %eax,%eax
  800af1:	48 01 d0             	add    %rdx,%rax
  800af4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800af8:	8b 12                	mov    (%rdx),%edx
  800afa:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800afd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b01:	89 0a                	mov    %ecx,(%rdx)
  800b03:	eb 17                	jmp    800b1c <getint+0x5b>
  800b05:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b09:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b0d:	48 89 d0             	mov    %rdx,%rax
  800b10:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b14:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b18:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b1c:	48 8b 00             	mov    (%rax),%rax
  800b1f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b23:	e9 a3 00 00 00       	jmpq   800bcb <getint+0x10a>
	else if (lflag)
  800b28:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800b2c:	74 4f                	je     800b7d <getint+0xbc>
		x=va_arg(*ap, long);
  800b2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b32:	8b 00                	mov    (%rax),%eax
  800b34:	83 f8 30             	cmp    $0x30,%eax
  800b37:	73 24                	jae    800b5d <getint+0x9c>
  800b39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b3d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b41:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b45:	8b 00                	mov    (%rax),%eax
  800b47:	89 c0                	mov    %eax,%eax
  800b49:	48 01 d0             	add    %rdx,%rax
  800b4c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b50:	8b 12                	mov    (%rdx),%edx
  800b52:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b55:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b59:	89 0a                	mov    %ecx,(%rdx)
  800b5b:	eb 17                	jmp    800b74 <getint+0xb3>
  800b5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b61:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800b65:	48 89 d0             	mov    %rdx,%rax
  800b68:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800b6c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b70:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b74:	48 8b 00             	mov    (%rax),%rax
  800b77:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b7b:	eb 4e                	jmp    800bcb <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800b7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b81:	8b 00                	mov    (%rax),%eax
  800b83:	83 f8 30             	cmp    $0x30,%eax
  800b86:	73 24                	jae    800bac <getint+0xeb>
  800b88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b8c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b90:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b94:	8b 00                	mov    (%rax),%eax
  800b96:	89 c0                	mov    %eax,%eax
  800b98:	48 01 d0             	add    %rdx,%rax
  800b9b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b9f:	8b 12                	mov    (%rdx),%edx
  800ba1:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ba4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ba8:	89 0a                	mov    %ecx,(%rdx)
  800baa:	eb 17                	jmp    800bc3 <getint+0x102>
  800bac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bb0:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800bb4:	48 89 d0             	mov    %rdx,%rax
  800bb7:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800bbb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bbf:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800bc3:	8b 00                	mov    (%rax),%eax
  800bc5:	48 98                	cltq   
  800bc7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800bcb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800bcf:	c9                   	leaveq 
  800bd0:	c3                   	retq   

0000000000800bd1 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bd1:	55                   	push   %rbp
  800bd2:	48 89 e5             	mov    %rsp,%rbp
  800bd5:	41 54                	push   %r12
  800bd7:	53                   	push   %rbx
  800bd8:	48 83 ec 60          	sub    $0x60,%rsp
  800bdc:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800be0:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800be4:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800be8:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800bec:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bf0:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800bf4:	48 8b 0a             	mov    (%rdx),%rcx
  800bf7:	48 89 08             	mov    %rcx,(%rax)
  800bfa:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800bfe:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800c02:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800c06:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c0a:	eb 28                	jmp    800c34 <vprintfmt+0x63>
			if (ch == '\0'){
  800c0c:	85 db                	test   %ebx,%ebx
  800c0e:	75 15                	jne    800c25 <vprintfmt+0x54>
				current_color=WHITE;
  800c10:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  800c17:	00 00 00 
  800c1a:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  800c20:	e9 fc 04 00 00       	jmpq   801121 <vprintfmt+0x550>
				return;
			}
				
			putch(ch, putdat);
  800c25:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c29:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c2d:	48 89 d6             	mov    %rdx,%rsi
  800c30:	89 df                	mov    %ebx,%edi
  800c32:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c34:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c38:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800c3c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800c40:	0f b6 00             	movzbl (%rax),%eax
  800c43:	0f b6 d8             	movzbl %al,%ebx
  800c46:	83 fb 25             	cmp    $0x25,%ebx
  800c49:	75 c1                	jne    800c0c <vprintfmt+0x3b>
				
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c4b:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800c4f:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800c56:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800c5d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800c64:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c6b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c6f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800c73:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800c77:	0f b6 00             	movzbl (%rax),%eax
  800c7a:	0f b6 d8             	movzbl %al,%ebx
  800c7d:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800c80:	83 f8 55             	cmp    $0x55,%eax
  800c83:	0f 87 64 04 00 00    	ja     8010ed <vprintfmt+0x51c>
  800c89:	89 c0                	mov    %eax,%eax
  800c8b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800c92:	00 
  800c93:	48 b8 f8 49 80 00 00 	movabs $0x8049f8,%rax
  800c9a:	00 00 00 
  800c9d:	48 01 d0             	add    %rdx,%rax
  800ca0:	48 8b 00             	mov    (%rax),%rax
  800ca3:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800ca5:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800ca9:	eb c0                	jmp    800c6b <vprintfmt+0x9a>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800cab:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800caf:	eb ba                	jmp    800c6b <vprintfmt+0x9a>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cb1:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800cb8:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800cbb:	89 d0                	mov    %edx,%eax
  800cbd:	c1 e0 02             	shl    $0x2,%eax
  800cc0:	01 d0                	add    %edx,%eax
  800cc2:	01 c0                	add    %eax,%eax
  800cc4:	01 d8                	add    %ebx,%eax
  800cc6:	83 e8 30             	sub    $0x30,%eax
  800cc9:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800ccc:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800cd0:	0f b6 00             	movzbl (%rax),%eax
  800cd3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800cd6:	83 fb 2f             	cmp    $0x2f,%ebx
  800cd9:	7e 0c                	jle    800ce7 <vprintfmt+0x116>
  800cdb:	83 fb 39             	cmp    $0x39,%ebx
  800cde:	7f 07                	jg     800ce7 <vprintfmt+0x116>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ce0:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ce5:	eb d1                	jmp    800cb8 <vprintfmt+0xe7>
			goto process_precision;
  800ce7:	eb 58                	jmp    800d41 <vprintfmt+0x170>

		case '*':
			precision = va_arg(aq, int);
  800ce9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cec:	83 f8 30             	cmp    $0x30,%eax
  800cef:	73 17                	jae    800d08 <vprintfmt+0x137>
  800cf1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800cf5:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cf8:	89 c0                	mov    %eax,%eax
  800cfa:	48 01 d0             	add    %rdx,%rax
  800cfd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d00:	83 c2 08             	add    $0x8,%edx
  800d03:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d06:	eb 0f                	jmp    800d17 <vprintfmt+0x146>
  800d08:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d0c:	48 89 d0             	mov    %rdx,%rax
  800d0f:	48 83 c2 08          	add    $0x8,%rdx
  800d13:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d17:	8b 00                	mov    (%rax),%eax
  800d19:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800d1c:	eb 23                	jmp    800d41 <vprintfmt+0x170>

		case '.':
			if (width < 0)
  800d1e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d22:	79 0c                	jns    800d30 <vprintfmt+0x15f>
				width = 0;
  800d24:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800d2b:	e9 3b ff ff ff       	jmpq   800c6b <vprintfmt+0x9a>
  800d30:	e9 36 ff ff ff       	jmpq   800c6b <vprintfmt+0x9a>

		case '#':
			altflag = 1;
  800d35:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800d3c:	e9 2a ff ff ff       	jmpq   800c6b <vprintfmt+0x9a>

		process_precision:
			if (width < 0)
  800d41:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d45:	79 12                	jns    800d59 <vprintfmt+0x188>
				width = precision, precision = -1;
  800d47:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800d4a:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800d4d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800d54:	e9 12 ff ff ff       	jmpq   800c6b <vprintfmt+0x9a>
  800d59:	e9 0d ff ff ff       	jmpq   800c6b <vprintfmt+0x9a>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d5e:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800d62:	e9 04 ff ff ff       	jmpq   800c6b <vprintfmt+0x9a>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800d67:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d6a:	83 f8 30             	cmp    $0x30,%eax
  800d6d:	73 17                	jae    800d86 <vprintfmt+0x1b5>
  800d6f:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d73:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d76:	89 c0                	mov    %eax,%eax
  800d78:	48 01 d0             	add    %rdx,%rax
  800d7b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d7e:	83 c2 08             	add    $0x8,%edx
  800d81:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d84:	eb 0f                	jmp    800d95 <vprintfmt+0x1c4>
  800d86:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800d8a:	48 89 d0             	mov    %rdx,%rax
  800d8d:	48 83 c2 08          	add    $0x8,%rdx
  800d91:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d95:	8b 10                	mov    (%rax),%edx
  800d97:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800d9b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d9f:	48 89 ce             	mov    %rcx,%rsi
  800da2:	89 d7                	mov    %edx,%edi
  800da4:	ff d0                	callq  *%rax
			break;
  800da6:	e9 70 03 00 00       	jmpq   80111b <vprintfmt+0x54a>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800dab:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800dae:	83 f8 30             	cmp    $0x30,%eax
  800db1:	73 17                	jae    800dca <vprintfmt+0x1f9>
  800db3:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800db7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800dba:	89 c0                	mov    %eax,%eax
  800dbc:	48 01 d0             	add    %rdx,%rax
  800dbf:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800dc2:	83 c2 08             	add    $0x8,%edx
  800dc5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800dc8:	eb 0f                	jmp    800dd9 <vprintfmt+0x208>
  800dca:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800dce:	48 89 d0             	mov    %rdx,%rax
  800dd1:	48 83 c2 08          	add    $0x8,%rdx
  800dd5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800dd9:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800ddb:	85 db                	test   %ebx,%ebx
  800ddd:	79 02                	jns    800de1 <vprintfmt+0x210>
				err = -err;
  800ddf:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800de1:	83 fb 15             	cmp    $0x15,%ebx
  800de4:	7f 16                	jg     800dfc <vprintfmt+0x22b>
  800de6:	48 b8 20 49 80 00 00 	movabs $0x804920,%rax
  800ded:	00 00 00 
  800df0:	48 63 d3             	movslq %ebx,%rdx
  800df3:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800df7:	4d 85 e4             	test   %r12,%r12
  800dfa:	75 2e                	jne    800e2a <vprintfmt+0x259>
				printfmt(putch, putdat, "error %d", err);
  800dfc:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e00:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e04:	89 d9                	mov    %ebx,%ecx
  800e06:	48 ba e1 49 80 00 00 	movabs $0x8049e1,%rdx
  800e0d:	00 00 00 
  800e10:	48 89 c7             	mov    %rax,%rdi
  800e13:	b8 00 00 00 00       	mov    $0x0,%eax
  800e18:	49 b8 2a 11 80 00 00 	movabs $0x80112a,%r8
  800e1f:	00 00 00 
  800e22:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e25:	e9 f1 02 00 00       	jmpq   80111b <vprintfmt+0x54a>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e2a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e2e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e32:	4c 89 e1             	mov    %r12,%rcx
  800e35:	48 ba ea 49 80 00 00 	movabs $0x8049ea,%rdx
  800e3c:	00 00 00 
  800e3f:	48 89 c7             	mov    %rax,%rdi
  800e42:	b8 00 00 00 00       	mov    $0x0,%eax
  800e47:	49 b8 2a 11 80 00 00 	movabs $0x80112a,%r8
  800e4e:	00 00 00 
  800e51:	41 ff d0             	callq  *%r8
			break;
  800e54:	e9 c2 02 00 00       	jmpq   80111b <vprintfmt+0x54a>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800e59:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e5c:	83 f8 30             	cmp    $0x30,%eax
  800e5f:	73 17                	jae    800e78 <vprintfmt+0x2a7>
  800e61:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800e65:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e68:	89 c0                	mov    %eax,%eax
  800e6a:	48 01 d0             	add    %rdx,%rax
  800e6d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e70:	83 c2 08             	add    $0x8,%edx
  800e73:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800e76:	eb 0f                	jmp    800e87 <vprintfmt+0x2b6>
  800e78:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800e7c:	48 89 d0             	mov    %rdx,%rax
  800e7f:	48 83 c2 08          	add    $0x8,%rdx
  800e83:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e87:	4c 8b 20             	mov    (%rax),%r12
  800e8a:	4d 85 e4             	test   %r12,%r12
  800e8d:	75 0a                	jne    800e99 <vprintfmt+0x2c8>
				p = "(null)";
  800e8f:	49 bc ed 49 80 00 00 	movabs $0x8049ed,%r12
  800e96:	00 00 00 
			if (width > 0 && padc != '-')
  800e99:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e9d:	7e 3f                	jle    800ede <vprintfmt+0x30d>
  800e9f:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800ea3:	74 39                	je     800ede <vprintfmt+0x30d>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ea5:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ea8:	48 98                	cltq   
  800eaa:	48 89 c6             	mov    %rax,%rsi
  800ead:	4c 89 e7             	mov    %r12,%rdi
  800eb0:	48 b8 d6 13 80 00 00 	movabs $0x8013d6,%rax
  800eb7:	00 00 00 
  800eba:	ff d0                	callq  *%rax
  800ebc:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800ebf:	eb 17                	jmp    800ed8 <vprintfmt+0x307>
					putch(padc, putdat);
  800ec1:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800ec5:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800ec9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ecd:	48 89 ce             	mov    %rcx,%rsi
  800ed0:	89 d7                	mov    %edx,%edi
  800ed2:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ed4:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ed8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800edc:	7f e3                	jg     800ec1 <vprintfmt+0x2f0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ede:	eb 37                	jmp    800f17 <vprintfmt+0x346>
				if (altflag && (ch < ' ' || ch > '~'))
  800ee0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800ee4:	74 1e                	je     800f04 <vprintfmt+0x333>
  800ee6:	83 fb 1f             	cmp    $0x1f,%ebx
  800ee9:	7e 05                	jle    800ef0 <vprintfmt+0x31f>
  800eeb:	83 fb 7e             	cmp    $0x7e,%ebx
  800eee:	7e 14                	jle    800f04 <vprintfmt+0x333>
					putch('?', putdat);
  800ef0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ef4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ef8:	48 89 d6             	mov    %rdx,%rsi
  800efb:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800f00:	ff d0                	callq  *%rax
  800f02:	eb 0f                	jmp    800f13 <vprintfmt+0x342>
				else
					putch(ch, putdat);
  800f04:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f08:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f0c:	48 89 d6             	mov    %rdx,%rsi
  800f0f:	89 df                	mov    %ebx,%edi
  800f11:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f13:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800f17:	4c 89 e0             	mov    %r12,%rax
  800f1a:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800f1e:	0f b6 00             	movzbl (%rax),%eax
  800f21:	0f be d8             	movsbl %al,%ebx
  800f24:	85 db                	test   %ebx,%ebx
  800f26:	74 10                	je     800f38 <vprintfmt+0x367>
  800f28:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800f2c:	78 b2                	js     800ee0 <vprintfmt+0x30f>
  800f2e:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800f32:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800f36:	79 a8                	jns    800ee0 <vprintfmt+0x30f>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f38:	eb 16                	jmp    800f50 <vprintfmt+0x37f>
				putch(' ', putdat);
  800f3a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f3e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f42:	48 89 d6             	mov    %rdx,%rsi
  800f45:	bf 20 00 00 00       	mov    $0x20,%edi
  800f4a:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f4c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800f50:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800f54:	7f e4                	jg     800f3a <vprintfmt+0x369>
				putch(' ', putdat);
			break;
  800f56:	e9 c0 01 00 00       	jmpq   80111b <vprintfmt+0x54a>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800f5b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f5f:	be 03 00 00 00       	mov    $0x3,%esi
  800f64:	48 89 c7             	mov    %rax,%rdi
  800f67:	48 b8 c1 0a 80 00 00 	movabs $0x800ac1,%rax
  800f6e:	00 00 00 
  800f71:	ff d0                	callq  *%rax
  800f73:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800f77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f7b:	48 85 c0             	test   %rax,%rax
  800f7e:	79 1d                	jns    800f9d <vprintfmt+0x3cc>
				putch('-', putdat);
  800f80:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f84:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f88:	48 89 d6             	mov    %rdx,%rsi
  800f8b:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800f90:	ff d0                	callq  *%rax
				num = -(long long) num;
  800f92:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f96:	48 f7 d8             	neg    %rax
  800f99:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800f9d:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800fa4:	e9 d5 00 00 00       	jmpq   80107e <vprintfmt+0x4ad>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800fa9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800fad:	be 03 00 00 00       	mov    $0x3,%esi
  800fb2:	48 89 c7             	mov    %rax,%rdi
  800fb5:	48 b8 b1 09 80 00 00 	movabs $0x8009b1,%rax
  800fbc:	00 00 00 
  800fbf:	ff d0                	callq  *%rax
  800fc1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800fc5:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800fcc:	e9 ad 00 00 00       	jmpq   80107e <vprintfmt+0x4ad>
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			// break;
			num = getuint(&aq, 3);
  800fd1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800fd5:	be 03 00 00 00       	mov    $0x3,%esi
  800fda:	48 89 c7             	mov    %rax,%rdi
  800fdd:	48 b8 b1 09 80 00 00 	movabs $0x8009b1,%rax
  800fe4:	00 00 00 
  800fe7:	ff d0                	callq  *%rax
  800fe9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800fed:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800ff4:	e9 85 00 00 00       	jmpq   80107e <vprintfmt+0x4ad>

			// pointer
		case 'p':
			putch('0', putdat);
  800ff9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ffd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801001:	48 89 d6             	mov    %rdx,%rsi
  801004:	bf 30 00 00 00       	mov    $0x30,%edi
  801009:	ff d0                	callq  *%rax
			putch('x', putdat);
  80100b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80100f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801013:	48 89 d6             	mov    %rdx,%rsi
  801016:	bf 78 00 00 00       	mov    $0x78,%edi
  80101b:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  80101d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801020:	83 f8 30             	cmp    $0x30,%eax
  801023:	73 17                	jae    80103c <vprintfmt+0x46b>
  801025:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801029:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80102c:	89 c0                	mov    %eax,%eax
  80102e:	48 01 d0             	add    %rdx,%rax
  801031:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801034:	83 c2 08             	add    $0x8,%edx
  801037:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80103a:	eb 0f                	jmp    80104b <vprintfmt+0x47a>
				(uintptr_t) va_arg(aq, void *);
  80103c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801040:	48 89 d0             	mov    %rdx,%rax
  801043:	48 83 c2 08          	add    $0x8,%rdx
  801047:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80104b:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80104e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801052:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801059:	eb 23                	jmp    80107e <vprintfmt+0x4ad>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  80105b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80105f:	be 03 00 00 00       	mov    $0x3,%esi
  801064:	48 89 c7             	mov    %rax,%rdi
  801067:	48 b8 b1 09 80 00 00 	movabs $0x8009b1,%rax
  80106e:	00 00 00 
  801071:	ff d0                	callq  *%rax
  801073:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801077:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80107e:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  801083:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801086:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801089:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80108d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801091:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801095:	45 89 c1             	mov    %r8d,%r9d
  801098:	41 89 f8             	mov    %edi,%r8d
  80109b:	48 89 c7             	mov    %rax,%rdi
  80109e:	48 b8 f6 08 80 00 00 	movabs $0x8008f6,%rax
  8010a5:	00 00 00 
  8010a8:	ff d0                	callq  *%rax
			break;
  8010aa:	eb 6f                	jmp    80111b <vprintfmt+0x54a>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010ac:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010b0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010b4:	48 89 d6             	mov    %rdx,%rsi
  8010b7:	89 df                	mov    %ebx,%edi
  8010b9:	ff d0                	callq  *%rax
			break;
  8010bb:	eb 5e                	jmp    80111b <vprintfmt+0x54a>
		
		case 'C':
		    num=getuint(&aq,3);		
  8010bd:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8010c1:	be 03 00 00 00       	mov    $0x3,%esi
  8010c6:	48 89 c7             	mov    %rax,%rdi
  8010c9:	48 b8 b1 09 80 00 00 	movabs $0x8009b1,%rax
  8010d0:	00 00 00 
  8010d3:	ff d0                	callq  *%rax
  8010d5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			current_color=num;
  8010d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010dd:	89 c2                	mov    %eax,%edx
  8010df:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  8010e6:	00 00 00 
  8010e9:	89 10                	mov    %edx,(%rax)
			break;
  8010eb:	eb 2e                	jmp    80111b <vprintfmt+0x54a>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010ed:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010f1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010f5:	48 89 d6             	mov    %rdx,%rsi
  8010f8:	bf 25 00 00 00       	mov    $0x25,%edi
  8010fd:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010ff:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801104:	eb 05                	jmp    80110b <vprintfmt+0x53a>
  801106:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80110b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80110f:	48 83 e8 01          	sub    $0x1,%rax
  801113:	0f b6 00             	movzbl (%rax),%eax
  801116:	3c 25                	cmp    $0x25,%al
  801118:	75 ec                	jne    801106 <vprintfmt+0x535>
				/* do nothing */;
			break;
  80111a:	90                   	nop
		}
	}
  80111b:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80111c:	e9 13 fb ff ff       	jmpq   800c34 <vprintfmt+0x63>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  801121:	48 83 c4 60          	add    $0x60,%rsp
  801125:	5b                   	pop    %rbx
  801126:	41 5c                	pop    %r12
  801128:	5d                   	pop    %rbp
  801129:	c3                   	retq   

000000000080112a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80112a:	55                   	push   %rbp
  80112b:	48 89 e5             	mov    %rsp,%rbp
  80112e:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801135:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80113c:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801143:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80114a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801151:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801158:	84 c0                	test   %al,%al
  80115a:	74 20                	je     80117c <printfmt+0x52>
  80115c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801160:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801164:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801168:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80116c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801170:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801174:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801178:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80117c:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801183:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80118a:	00 00 00 
  80118d:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801194:	00 00 00 
  801197:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80119b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8011a2:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8011a9:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8011b0:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8011b7:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8011be:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8011c5:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8011cc:	48 89 c7             	mov    %rax,%rdi
  8011cf:	48 b8 d1 0b 80 00 00 	movabs $0x800bd1,%rax
  8011d6:	00 00 00 
  8011d9:	ff d0                	callq  *%rax
	va_end(ap);
}
  8011db:	c9                   	leaveq 
  8011dc:	c3                   	retq   

00000000008011dd <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8011dd:	55                   	push   %rbp
  8011de:	48 89 e5             	mov    %rsp,%rbp
  8011e1:	48 83 ec 10          	sub    $0x10,%rsp
  8011e5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8011e8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8011ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011f0:	8b 40 10             	mov    0x10(%rax),%eax
  8011f3:	8d 50 01             	lea    0x1(%rax),%edx
  8011f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011fa:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8011fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801201:	48 8b 10             	mov    (%rax),%rdx
  801204:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801208:	48 8b 40 08          	mov    0x8(%rax),%rax
  80120c:	48 39 c2             	cmp    %rax,%rdx
  80120f:	73 17                	jae    801228 <sprintputch+0x4b>
		*b->buf++ = ch;
  801211:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801215:	48 8b 00             	mov    (%rax),%rax
  801218:	48 8d 48 01          	lea    0x1(%rax),%rcx
  80121c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801220:	48 89 0a             	mov    %rcx,(%rdx)
  801223:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801226:	88 10                	mov    %dl,(%rax)
}
  801228:	c9                   	leaveq 
  801229:	c3                   	retq   

000000000080122a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80122a:	55                   	push   %rbp
  80122b:	48 89 e5             	mov    %rsp,%rbp
  80122e:	48 83 ec 50          	sub    $0x50,%rsp
  801232:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801236:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801239:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80123d:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801241:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801245:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801249:	48 8b 0a             	mov    (%rdx),%rcx
  80124c:	48 89 08             	mov    %rcx,(%rax)
  80124f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801253:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801257:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80125b:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80125f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801263:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801267:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80126a:	48 98                	cltq   
  80126c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801270:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801274:	48 01 d0             	add    %rdx,%rax
  801277:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80127b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801282:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801287:	74 06                	je     80128f <vsnprintf+0x65>
  801289:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80128d:	7f 07                	jg     801296 <vsnprintf+0x6c>
		return -E_INVAL;
  80128f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801294:	eb 2f                	jmp    8012c5 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801296:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  80129a:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80129e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8012a2:	48 89 c6             	mov    %rax,%rsi
  8012a5:	48 bf dd 11 80 00 00 	movabs $0x8011dd,%rdi
  8012ac:	00 00 00 
  8012af:	48 b8 d1 0b 80 00 00 	movabs $0x800bd1,%rax
  8012b6:	00 00 00 
  8012b9:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8012bb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8012bf:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8012c2:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8012c5:	c9                   	leaveq 
  8012c6:	c3                   	retq   

00000000008012c7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8012c7:	55                   	push   %rbp
  8012c8:	48 89 e5             	mov    %rsp,%rbp
  8012cb:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8012d2:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8012d9:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8012df:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8012e6:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8012ed:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8012f4:	84 c0                	test   %al,%al
  8012f6:	74 20                	je     801318 <snprintf+0x51>
  8012f8:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8012fc:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801300:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801304:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801308:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80130c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801310:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801314:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801318:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  80131f:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801326:	00 00 00 
  801329:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801330:	00 00 00 
  801333:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801337:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80133e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801345:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80134c:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801353:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80135a:	48 8b 0a             	mov    (%rdx),%rcx
  80135d:	48 89 08             	mov    %rcx,(%rax)
  801360:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801364:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801368:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80136c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801370:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801377:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80137e:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801384:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80138b:	48 89 c7             	mov    %rax,%rdi
  80138e:	48 b8 2a 12 80 00 00 	movabs $0x80122a,%rax
  801395:	00 00 00 
  801398:	ff d0                	callq  *%rax
  80139a:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8013a0:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8013a6:	c9                   	leaveq 
  8013a7:	c3                   	retq   

00000000008013a8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8013a8:	55                   	push   %rbp
  8013a9:	48 89 e5             	mov    %rsp,%rbp
  8013ac:	48 83 ec 18          	sub    $0x18,%rsp
  8013b0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8013b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8013bb:	eb 09                	jmp    8013c6 <strlen+0x1e>
		n++;
  8013bd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8013c1:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ca:	0f b6 00             	movzbl (%rax),%eax
  8013cd:	84 c0                	test   %al,%al
  8013cf:	75 ec                	jne    8013bd <strlen+0x15>
		n++;
	return n;
  8013d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8013d4:	c9                   	leaveq 
  8013d5:	c3                   	retq   

00000000008013d6 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8013d6:	55                   	push   %rbp
  8013d7:	48 89 e5             	mov    %rsp,%rbp
  8013da:	48 83 ec 20          	sub    $0x20,%rsp
  8013de:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013e2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8013ed:	eb 0e                	jmp    8013fd <strnlen+0x27>
		n++;
  8013ef:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013f3:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013f8:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8013fd:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801402:	74 0b                	je     80140f <strnlen+0x39>
  801404:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801408:	0f b6 00             	movzbl (%rax),%eax
  80140b:	84 c0                	test   %al,%al
  80140d:	75 e0                	jne    8013ef <strnlen+0x19>
		n++;
	return n;
  80140f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801412:	c9                   	leaveq 
  801413:	c3                   	retq   

0000000000801414 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801414:	55                   	push   %rbp
  801415:	48 89 e5             	mov    %rsp,%rbp
  801418:	48 83 ec 20          	sub    $0x20,%rsp
  80141c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801420:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801424:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801428:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80142c:	90                   	nop
  80142d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801431:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801435:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801439:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80143d:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801441:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801445:	0f b6 12             	movzbl (%rdx),%edx
  801448:	88 10                	mov    %dl,(%rax)
  80144a:	0f b6 00             	movzbl (%rax),%eax
  80144d:	84 c0                	test   %al,%al
  80144f:	75 dc                	jne    80142d <strcpy+0x19>
		/* do nothing */;
	return ret;
  801451:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801455:	c9                   	leaveq 
  801456:	c3                   	retq   

0000000000801457 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801457:	55                   	push   %rbp
  801458:	48 89 e5             	mov    %rsp,%rbp
  80145b:	48 83 ec 20          	sub    $0x20,%rsp
  80145f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801463:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801467:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80146b:	48 89 c7             	mov    %rax,%rdi
  80146e:	48 b8 a8 13 80 00 00 	movabs $0x8013a8,%rax
  801475:	00 00 00 
  801478:	ff d0                	callq  *%rax
  80147a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80147d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801480:	48 63 d0             	movslq %eax,%rdx
  801483:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801487:	48 01 c2             	add    %rax,%rdx
  80148a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80148e:	48 89 c6             	mov    %rax,%rsi
  801491:	48 89 d7             	mov    %rdx,%rdi
  801494:	48 b8 14 14 80 00 00 	movabs $0x801414,%rax
  80149b:	00 00 00 
  80149e:	ff d0                	callq  *%rax
	return dst;
  8014a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014a4:	c9                   	leaveq 
  8014a5:	c3                   	retq   

00000000008014a6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8014a6:	55                   	push   %rbp
  8014a7:	48 89 e5             	mov    %rsp,%rbp
  8014aa:	48 83 ec 28          	sub    $0x28,%rsp
  8014ae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014b2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014b6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8014ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014be:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8014c2:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8014c9:	00 
  8014ca:	eb 2a                	jmp    8014f6 <strncpy+0x50>
		*dst++ = *src;
  8014cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014d0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014d4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8014d8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8014dc:	0f b6 12             	movzbl (%rdx),%edx
  8014df:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8014e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014e5:	0f b6 00             	movzbl (%rax),%eax
  8014e8:	84 c0                	test   %al,%al
  8014ea:	74 05                	je     8014f1 <strncpy+0x4b>
			src++;
  8014ec:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8014f1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014fa:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8014fe:	72 cc                	jb     8014cc <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801500:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801504:	c9                   	leaveq 
  801505:	c3                   	retq   

0000000000801506 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801506:	55                   	push   %rbp
  801507:	48 89 e5             	mov    %rsp,%rbp
  80150a:	48 83 ec 28          	sub    $0x28,%rsp
  80150e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801512:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801516:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80151a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80151e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801522:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801527:	74 3d                	je     801566 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801529:	eb 1d                	jmp    801548 <strlcpy+0x42>
			*dst++ = *src++;
  80152b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80152f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801533:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801537:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80153b:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80153f:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801543:	0f b6 12             	movzbl (%rdx),%edx
  801546:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801548:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80154d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801552:	74 0b                	je     80155f <strlcpy+0x59>
  801554:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801558:	0f b6 00             	movzbl (%rax),%eax
  80155b:	84 c0                	test   %al,%al
  80155d:	75 cc                	jne    80152b <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80155f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801563:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801566:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80156a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80156e:	48 29 c2             	sub    %rax,%rdx
  801571:	48 89 d0             	mov    %rdx,%rax
}
  801574:	c9                   	leaveq 
  801575:	c3                   	retq   

0000000000801576 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801576:	55                   	push   %rbp
  801577:	48 89 e5             	mov    %rsp,%rbp
  80157a:	48 83 ec 10          	sub    $0x10,%rsp
  80157e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801582:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801586:	eb 0a                	jmp    801592 <strcmp+0x1c>
		p++, q++;
  801588:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80158d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801592:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801596:	0f b6 00             	movzbl (%rax),%eax
  801599:	84 c0                	test   %al,%al
  80159b:	74 12                	je     8015af <strcmp+0x39>
  80159d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015a1:	0f b6 10             	movzbl (%rax),%edx
  8015a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015a8:	0f b6 00             	movzbl (%rax),%eax
  8015ab:	38 c2                	cmp    %al,%dl
  8015ad:	74 d9                	je     801588 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8015af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015b3:	0f b6 00             	movzbl (%rax),%eax
  8015b6:	0f b6 d0             	movzbl %al,%edx
  8015b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015bd:	0f b6 00             	movzbl (%rax),%eax
  8015c0:	0f b6 c0             	movzbl %al,%eax
  8015c3:	29 c2                	sub    %eax,%edx
  8015c5:	89 d0                	mov    %edx,%eax
}
  8015c7:	c9                   	leaveq 
  8015c8:	c3                   	retq   

00000000008015c9 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8015c9:	55                   	push   %rbp
  8015ca:	48 89 e5             	mov    %rsp,%rbp
  8015cd:	48 83 ec 18          	sub    $0x18,%rsp
  8015d1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015d5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8015d9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8015dd:	eb 0f                	jmp    8015ee <strncmp+0x25>
		n--, p++, q++;
  8015df:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8015e4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015e9:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8015ee:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015f3:	74 1d                	je     801612 <strncmp+0x49>
  8015f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015f9:	0f b6 00             	movzbl (%rax),%eax
  8015fc:	84 c0                	test   %al,%al
  8015fe:	74 12                	je     801612 <strncmp+0x49>
  801600:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801604:	0f b6 10             	movzbl (%rax),%edx
  801607:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80160b:	0f b6 00             	movzbl (%rax),%eax
  80160e:	38 c2                	cmp    %al,%dl
  801610:	74 cd                	je     8015df <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801612:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801617:	75 07                	jne    801620 <strncmp+0x57>
		return 0;
  801619:	b8 00 00 00 00       	mov    $0x0,%eax
  80161e:	eb 18                	jmp    801638 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801620:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801624:	0f b6 00             	movzbl (%rax),%eax
  801627:	0f b6 d0             	movzbl %al,%edx
  80162a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80162e:	0f b6 00             	movzbl (%rax),%eax
  801631:	0f b6 c0             	movzbl %al,%eax
  801634:	29 c2                	sub    %eax,%edx
  801636:	89 d0                	mov    %edx,%eax
}
  801638:	c9                   	leaveq 
  801639:	c3                   	retq   

000000000080163a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80163a:	55                   	push   %rbp
  80163b:	48 89 e5             	mov    %rsp,%rbp
  80163e:	48 83 ec 0c          	sub    $0xc,%rsp
  801642:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801646:	89 f0                	mov    %esi,%eax
  801648:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80164b:	eb 17                	jmp    801664 <strchr+0x2a>
		if (*s == c)
  80164d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801651:	0f b6 00             	movzbl (%rax),%eax
  801654:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801657:	75 06                	jne    80165f <strchr+0x25>
			return (char *) s;
  801659:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80165d:	eb 15                	jmp    801674 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80165f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801664:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801668:	0f b6 00             	movzbl (%rax),%eax
  80166b:	84 c0                	test   %al,%al
  80166d:	75 de                	jne    80164d <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80166f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801674:	c9                   	leaveq 
  801675:	c3                   	retq   

0000000000801676 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801676:	55                   	push   %rbp
  801677:	48 89 e5             	mov    %rsp,%rbp
  80167a:	48 83 ec 0c          	sub    $0xc,%rsp
  80167e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801682:	89 f0                	mov    %esi,%eax
  801684:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801687:	eb 13                	jmp    80169c <strfind+0x26>
		if (*s == c)
  801689:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80168d:	0f b6 00             	movzbl (%rax),%eax
  801690:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801693:	75 02                	jne    801697 <strfind+0x21>
			break;
  801695:	eb 10                	jmp    8016a7 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801697:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80169c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016a0:	0f b6 00             	movzbl (%rax),%eax
  8016a3:	84 c0                	test   %al,%al
  8016a5:	75 e2                	jne    801689 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  8016a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8016ab:	c9                   	leaveq 
  8016ac:	c3                   	retq   

00000000008016ad <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8016ad:	55                   	push   %rbp
  8016ae:	48 89 e5             	mov    %rsp,%rbp
  8016b1:	48 83 ec 18          	sub    $0x18,%rsp
  8016b5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016b9:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8016bc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8016c0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8016c5:	75 06                	jne    8016cd <memset+0x20>
		return v;
  8016c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016cb:	eb 69                	jmp    801736 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8016cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016d1:	83 e0 03             	and    $0x3,%eax
  8016d4:	48 85 c0             	test   %rax,%rax
  8016d7:	75 48                	jne    801721 <memset+0x74>
  8016d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016dd:	83 e0 03             	and    $0x3,%eax
  8016e0:	48 85 c0             	test   %rax,%rax
  8016e3:	75 3c                	jne    801721 <memset+0x74>
		c &= 0xFF;
  8016e5:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8016ec:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016ef:	c1 e0 18             	shl    $0x18,%eax
  8016f2:	89 c2                	mov    %eax,%edx
  8016f4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016f7:	c1 e0 10             	shl    $0x10,%eax
  8016fa:	09 c2                	or     %eax,%edx
  8016fc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016ff:	c1 e0 08             	shl    $0x8,%eax
  801702:	09 d0                	or     %edx,%eax
  801704:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801707:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80170b:	48 c1 e8 02          	shr    $0x2,%rax
  80170f:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801712:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801716:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801719:	48 89 d7             	mov    %rdx,%rdi
  80171c:	fc                   	cld    
  80171d:	f3 ab                	rep stos %eax,%es:(%rdi)
  80171f:	eb 11                	jmp    801732 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801721:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801725:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801728:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80172c:	48 89 d7             	mov    %rdx,%rdi
  80172f:	fc                   	cld    
  801730:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801732:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801736:	c9                   	leaveq 
  801737:	c3                   	retq   

0000000000801738 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801738:	55                   	push   %rbp
  801739:	48 89 e5             	mov    %rsp,%rbp
  80173c:	48 83 ec 28          	sub    $0x28,%rsp
  801740:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801744:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801748:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80174c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801750:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801754:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801758:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80175c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801760:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801764:	0f 83 88 00 00 00    	jae    8017f2 <memmove+0xba>
  80176a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80176e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801772:	48 01 d0             	add    %rdx,%rax
  801775:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801779:	76 77                	jbe    8017f2 <memmove+0xba>
		s += n;
  80177b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177f:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801783:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801787:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80178b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80178f:	83 e0 03             	and    $0x3,%eax
  801792:	48 85 c0             	test   %rax,%rax
  801795:	75 3b                	jne    8017d2 <memmove+0x9a>
  801797:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80179b:	83 e0 03             	and    $0x3,%eax
  80179e:	48 85 c0             	test   %rax,%rax
  8017a1:	75 2f                	jne    8017d2 <memmove+0x9a>
  8017a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a7:	83 e0 03             	and    $0x3,%eax
  8017aa:	48 85 c0             	test   %rax,%rax
  8017ad:	75 23                	jne    8017d2 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8017af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017b3:	48 83 e8 04          	sub    $0x4,%rax
  8017b7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017bb:	48 83 ea 04          	sub    $0x4,%rdx
  8017bf:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8017c3:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8017c7:	48 89 c7             	mov    %rax,%rdi
  8017ca:	48 89 d6             	mov    %rdx,%rsi
  8017cd:	fd                   	std    
  8017ce:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8017d0:	eb 1d                	jmp    8017ef <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8017d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017d6:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8017da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017de:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8017e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e6:	48 89 d7             	mov    %rdx,%rdi
  8017e9:	48 89 c1             	mov    %rax,%rcx
  8017ec:	fd                   	std    
  8017ed:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8017ef:	fc                   	cld    
  8017f0:	eb 57                	jmp    801849 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8017f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017f6:	83 e0 03             	and    $0x3,%eax
  8017f9:	48 85 c0             	test   %rax,%rax
  8017fc:	75 36                	jne    801834 <memmove+0xfc>
  8017fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801802:	83 e0 03             	and    $0x3,%eax
  801805:	48 85 c0             	test   %rax,%rax
  801808:	75 2a                	jne    801834 <memmove+0xfc>
  80180a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80180e:	83 e0 03             	and    $0x3,%eax
  801811:	48 85 c0             	test   %rax,%rax
  801814:	75 1e                	jne    801834 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801816:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80181a:	48 c1 e8 02          	shr    $0x2,%rax
  80181e:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801821:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801825:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801829:	48 89 c7             	mov    %rax,%rdi
  80182c:	48 89 d6             	mov    %rdx,%rsi
  80182f:	fc                   	cld    
  801830:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801832:	eb 15                	jmp    801849 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801834:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801838:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80183c:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801840:	48 89 c7             	mov    %rax,%rdi
  801843:	48 89 d6             	mov    %rdx,%rsi
  801846:	fc                   	cld    
  801847:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801849:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80184d:	c9                   	leaveq 
  80184e:	c3                   	retq   

000000000080184f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80184f:	55                   	push   %rbp
  801850:	48 89 e5             	mov    %rsp,%rbp
  801853:	48 83 ec 18          	sub    $0x18,%rsp
  801857:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80185b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80185f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801863:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801867:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80186b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80186f:	48 89 ce             	mov    %rcx,%rsi
  801872:	48 89 c7             	mov    %rax,%rdi
  801875:	48 b8 38 17 80 00 00 	movabs $0x801738,%rax
  80187c:	00 00 00 
  80187f:	ff d0                	callq  *%rax
}
  801881:	c9                   	leaveq 
  801882:	c3                   	retq   

0000000000801883 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801883:	55                   	push   %rbp
  801884:	48 89 e5             	mov    %rsp,%rbp
  801887:	48 83 ec 28          	sub    $0x28,%rsp
  80188b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80188f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801893:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801897:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80189b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80189f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8018a3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8018a7:	eb 36                	jmp    8018df <memcmp+0x5c>
		if (*s1 != *s2)
  8018a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018ad:	0f b6 10             	movzbl (%rax),%edx
  8018b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018b4:	0f b6 00             	movzbl (%rax),%eax
  8018b7:	38 c2                	cmp    %al,%dl
  8018b9:	74 1a                	je     8018d5 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8018bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018bf:	0f b6 00             	movzbl (%rax),%eax
  8018c2:	0f b6 d0             	movzbl %al,%edx
  8018c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018c9:	0f b6 00             	movzbl (%rax),%eax
  8018cc:	0f b6 c0             	movzbl %al,%eax
  8018cf:	29 c2                	sub    %eax,%edx
  8018d1:	89 d0                	mov    %edx,%eax
  8018d3:	eb 20                	jmp    8018f5 <memcmp+0x72>
		s1++, s2++;
  8018d5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8018da:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8018df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e3:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8018e7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8018eb:	48 85 c0             	test   %rax,%rax
  8018ee:	75 b9                	jne    8018a9 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8018f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018f5:	c9                   	leaveq 
  8018f6:	c3                   	retq   

00000000008018f7 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8018f7:	55                   	push   %rbp
  8018f8:	48 89 e5             	mov    %rsp,%rbp
  8018fb:	48 83 ec 28          	sub    $0x28,%rsp
  8018ff:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801903:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801906:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80190a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80190e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801912:	48 01 d0             	add    %rdx,%rax
  801915:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801919:	eb 15                	jmp    801930 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  80191b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80191f:	0f b6 10             	movzbl (%rax),%edx
  801922:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801925:	38 c2                	cmp    %al,%dl
  801927:	75 02                	jne    80192b <memfind+0x34>
			break;
  801929:	eb 0f                	jmp    80193a <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80192b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801930:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801934:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801938:	72 e1                	jb     80191b <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  80193a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80193e:	c9                   	leaveq 
  80193f:	c3                   	retq   

0000000000801940 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801940:	55                   	push   %rbp
  801941:	48 89 e5             	mov    %rsp,%rbp
  801944:	48 83 ec 34          	sub    $0x34,%rsp
  801948:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80194c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801950:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801953:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  80195a:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801961:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801962:	eb 05                	jmp    801969 <strtol+0x29>
		s++;
  801964:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801969:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80196d:	0f b6 00             	movzbl (%rax),%eax
  801970:	3c 20                	cmp    $0x20,%al
  801972:	74 f0                	je     801964 <strtol+0x24>
  801974:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801978:	0f b6 00             	movzbl (%rax),%eax
  80197b:	3c 09                	cmp    $0x9,%al
  80197d:	74 e5                	je     801964 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80197f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801983:	0f b6 00             	movzbl (%rax),%eax
  801986:	3c 2b                	cmp    $0x2b,%al
  801988:	75 07                	jne    801991 <strtol+0x51>
		s++;
  80198a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80198f:	eb 17                	jmp    8019a8 <strtol+0x68>
	else if (*s == '-')
  801991:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801995:	0f b6 00             	movzbl (%rax),%eax
  801998:	3c 2d                	cmp    $0x2d,%al
  80199a:	75 0c                	jne    8019a8 <strtol+0x68>
		s++, neg = 1;
  80199c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019a1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8019a8:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8019ac:	74 06                	je     8019b4 <strtol+0x74>
  8019ae:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8019b2:	75 28                	jne    8019dc <strtol+0x9c>
  8019b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019b8:	0f b6 00             	movzbl (%rax),%eax
  8019bb:	3c 30                	cmp    $0x30,%al
  8019bd:	75 1d                	jne    8019dc <strtol+0x9c>
  8019bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019c3:	48 83 c0 01          	add    $0x1,%rax
  8019c7:	0f b6 00             	movzbl (%rax),%eax
  8019ca:	3c 78                	cmp    $0x78,%al
  8019cc:	75 0e                	jne    8019dc <strtol+0x9c>
		s += 2, base = 16;
  8019ce:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8019d3:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8019da:	eb 2c                	jmp    801a08 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8019dc:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8019e0:	75 19                	jne    8019fb <strtol+0xbb>
  8019e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019e6:	0f b6 00             	movzbl (%rax),%eax
  8019e9:	3c 30                	cmp    $0x30,%al
  8019eb:	75 0e                	jne    8019fb <strtol+0xbb>
		s++, base = 8;
  8019ed:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019f2:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8019f9:	eb 0d                	jmp    801a08 <strtol+0xc8>
	else if (base == 0)
  8019fb:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8019ff:	75 07                	jne    801a08 <strtol+0xc8>
		base = 10;
  801a01:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801a08:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a0c:	0f b6 00             	movzbl (%rax),%eax
  801a0f:	3c 2f                	cmp    $0x2f,%al
  801a11:	7e 1d                	jle    801a30 <strtol+0xf0>
  801a13:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a17:	0f b6 00             	movzbl (%rax),%eax
  801a1a:	3c 39                	cmp    $0x39,%al
  801a1c:	7f 12                	jg     801a30 <strtol+0xf0>
			dig = *s - '0';
  801a1e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a22:	0f b6 00             	movzbl (%rax),%eax
  801a25:	0f be c0             	movsbl %al,%eax
  801a28:	83 e8 30             	sub    $0x30,%eax
  801a2b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801a2e:	eb 4e                	jmp    801a7e <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801a30:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a34:	0f b6 00             	movzbl (%rax),%eax
  801a37:	3c 60                	cmp    $0x60,%al
  801a39:	7e 1d                	jle    801a58 <strtol+0x118>
  801a3b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a3f:	0f b6 00             	movzbl (%rax),%eax
  801a42:	3c 7a                	cmp    $0x7a,%al
  801a44:	7f 12                	jg     801a58 <strtol+0x118>
			dig = *s - 'a' + 10;
  801a46:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a4a:	0f b6 00             	movzbl (%rax),%eax
  801a4d:	0f be c0             	movsbl %al,%eax
  801a50:	83 e8 57             	sub    $0x57,%eax
  801a53:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801a56:	eb 26                	jmp    801a7e <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801a58:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a5c:	0f b6 00             	movzbl (%rax),%eax
  801a5f:	3c 40                	cmp    $0x40,%al
  801a61:	7e 48                	jle    801aab <strtol+0x16b>
  801a63:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a67:	0f b6 00             	movzbl (%rax),%eax
  801a6a:	3c 5a                	cmp    $0x5a,%al
  801a6c:	7f 3d                	jg     801aab <strtol+0x16b>
			dig = *s - 'A' + 10;
  801a6e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a72:	0f b6 00             	movzbl (%rax),%eax
  801a75:	0f be c0             	movsbl %al,%eax
  801a78:	83 e8 37             	sub    $0x37,%eax
  801a7b:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801a7e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a81:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801a84:	7c 02                	jl     801a88 <strtol+0x148>
			break;
  801a86:	eb 23                	jmp    801aab <strtol+0x16b>
		s++, val = (val * base) + dig;
  801a88:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a8d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801a90:	48 98                	cltq   
  801a92:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801a97:	48 89 c2             	mov    %rax,%rdx
  801a9a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a9d:	48 98                	cltq   
  801a9f:	48 01 d0             	add    %rdx,%rax
  801aa2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801aa6:	e9 5d ff ff ff       	jmpq   801a08 <strtol+0xc8>

	if (endptr)
  801aab:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801ab0:	74 0b                	je     801abd <strtol+0x17d>
		*endptr = (char *) s;
  801ab2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ab6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801aba:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801abd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ac1:	74 09                	je     801acc <strtol+0x18c>
  801ac3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ac7:	48 f7 d8             	neg    %rax
  801aca:	eb 04                	jmp    801ad0 <strtol+0x190>
  801acc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801ad0:	c9                   	leaveq 
  801ad1:	c3                   	retq   

0000000000801ad2 <strstr>:

char * strstr(const char *in, const char *str)
{
  801ad2:	55                   	push   %rbp
  801ad3:	48 89 e5             	mov    %rsp,%rbp
  801ad6:	48 83 ec 30          	sub    $0x30,%rsp
  801ada:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801ade:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801ae2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801ae6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801aea:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801aee:	0f b6 00             	movzbl (%rax),%eax
  801af1:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801af4:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801af8:	75 06                	jne    801b00 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801afa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801afe:	eb 6b                	jmp    801b6b <strstr+0x99>

	len = strlen(str);
  801b00:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b04:	48 89 c7             	mov    %rax,%rdi
  801b07:	48 b8 a8 13 80 00 00 	movabs $0x8013a8,%rax
  801b0e:	00 00 00 
  801b11:	ff d0                	callq  *%rax
  801b13:	48 98                	cltq   
  801b15:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801b19:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b1d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801b21:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801b25:	0f b6 00             	movzbl (%rax),%eax
  801b28:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801b2b:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801b2f:	75 07                	jne    801b38 <strstr+0x66>
				return (char *) 0;
  801b31:	b8 00 00 00 00       	mov    $0x0,%eax
  801b36:	eb 33                	jmp    801b6b <strstr+0x99>
		} while (sc != c);
  801b38:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801b3c:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801b3f:	75 d8                	jne    801b19 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801b41:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b45:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801b49:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b4d:	48 89 ce             	mov    %rcx,%rsi
  801b50:	48 89 c7             	mov    %rax,%rdi
  801b53:	48 b8 c9 15 80 00 00 	movabs $0x8015c9,%rax
  801b5a:	00 00 00 
  801b5d:	ff d0                	callq  *%rax
  801b5f:	85 c0                	test   %eax,%eax
  801b61:	75 b6                	jne    801b19 <strstr+0x47>

	return (char *) (in - 1);
  801b63:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b67:	48 83 e8 01          	sub    $0x1,%rax
}
  801b6b:	c9                   	leaveq 
  801b6c:	c3                   	retq   

0000000000801b6d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801b6d:	55                   	push   %rbp
  801b6e:	48 89 e5             	mov    %rsp,%rbp
  801b71:	53                   	push   %rbx
  801b72:	48 83 ec 48          	sub    $0x48,%rsp
  801b76:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801b79:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801b7c:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801b80:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801b84:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801b88:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b8c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801b8f:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801b93:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801b97:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801b9b:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801b9f:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801ba3:	4c 89 c3             	mov    %r8,%rbx
  801ba6:	cd 30                	int    $0x30
  801ba8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801bac:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801bb0:	74 3e                	je     801bf0 <syscall+0x83>
  801bb2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801bb7:	7e 37                	jle    801bf0 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801bb9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801bbd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801bc0:	49 89 d0             	mov    %rdx,%r8
  801bc3:	89 c1                	mov    %eax,%ecx
  801bc5:	48 ba a8 4c 80 00 00 	movabs $0x804ca8,%rdx
  801bcc:	00 00 00 
  801bcf:	be 23 00 00 00       	mov    $0x23,%esi
  801bd4:	48 bf c5 4c 80 00 00 	movabs $0x804cc5,%rdi
  801bdb:	00 00 00 
  801bde:	b8 00 00 00 00       	mov    $0x0,%eax
  801be3:	49 b9 e5 05 80 00 00 	movabs $0x8005e5,%r9
  801bea:	00 00 00 
  801bed:	41 ff d1             	callq  *%r9

	return ret;
  801bf0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801bf4:	48 83 c4 48          	add    $0x48,%rsp
  801bf8:	5b                   	pop    %rbx
  801bf9:	5d                   	pop    %rbp
  801bfa:	c3                   	retq   

0000000000801bfb <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801bfb:	55                   	push   %rbp
  801bfc:	48 89 e5             	mov    %rsp,%rbp
  801bff:	48 83 ec 20          	sub    $0x20,%rsp
  801c03:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c07:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801c0b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c0f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c13:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c1a:	00 
  801c1b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c21:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c27:	48 89 d1             	mov    %rdx,%rcx
  801c2a:	48 89 c2             	mov    %rax,%rdx
  801c2d:	be 00 00 00 00       	mov    $0x0,%esi
  801c32:	bf 00 00 00 00       	mov    $0x0,%edi
  801c37:	48 b8 6d 1b 80 00 00 	movabs $0x801b6d,%rax
  801c3e:	00 00 00 
  801c41:	ff d0                	callq  *%rax
}
  801c43:	c9                   	leaveq 
  801c44:	c3                   	retq   

0000000000801c45 <sys_cgetc>:

int
sys_cgetc(void)
{
  801c45:	55                   	push   %rbp
  801c46:	48 89 e5             	mov    %rsp,%rbp
  801c49:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801c4d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c54:	00 
  801c55:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c5b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c61:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c66:	ba 00 00 00 00       	mov    $0x0,%edx
  801c6b:	be 00 00 00 00       	mov    $0x0,%esi
  801c70:	bf 01 00 00 00       	mov    $0x1,%edi
  801c75:	48 b8 6d 1b 80 00 00 	movabs $0x801b6d,%rax
  801c7c:	00 00 00 
  801c7f:	ff d0                	callq  *%rax
}
  801c81:	c9                   	leaveq 
  801c82:	c3                   	retq   

0000000000801c83 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801c83:	55                   	push   %rbp
  801c84:	48 89 e5             	mov    %rsp,%rbp
  801c87:	48 83 ec 10          	sub    $0x10,%rsp
  801c8b:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801c8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c91:	48 98                	cltq   
  801c93:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801c9a:	00 
  801c9b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ca1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ca7:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cac:	48 89 c2             	mov    %rax,%rdx
  801caf:	be 01 00 00 00       	mov    $0x1,%esi
  801cb4:	bf 03 00 00 00       	mov    $0x3,%edi
  801cb9:	48 b8 6d 1b 80 00 00 	movabs $0x801b6d,%rax
  801cc0:	00 00 00 
  801cc3:	ff d0                	callq  *%rax
}
  801cc5:	c9                   	leaveq 
  801cc6:	c3                   	retq   

0000000000801cc7 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801cc7:	55                   	push   %rbp
  801cc8:	48 89 e5             	mov    %rsp,%rbp
  801ccb:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801ccf:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cd6:	00 
  801cd7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cdd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ce3:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ce8:	ba 00 00 00 00       	mov    $0x0,%edx
  801ced:	be 00 00 00 00       	mov    $0x0,%esi
  801cf2:	bf 02 00 00 00       	mov    $0x2,%edi
  801cf7:	48 b8 6d 1b 80 00 00 	movabs $0x801b6d,%rax
  801cfe:	00 00 00 
  801d01:	ff d0                	callq  *%rax
}
  801d03:	c9                   	leaveq 
  801d04:	c3                   	retq   

0000000000801d05 <sys_yield>:

void
sys_yield(void)
{
  801d05:	55                   	push   %rbp
  801d06:	48 89 e5             	mov    %rsp,%rbp
  801d09:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801d0d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d14:	00 
  801d15:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d1b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d21:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d26:	ba 00 00 00 00       	mov    $0x0,%edx
  801d2b:	be 00 00 00 00       	mov    $0x0,%esi
  801d30:	bf 0b 00 00 00       	mov    $0xb,%edi
  801d35:	48 b8 6d 1b 80 00 00 	movabs $0x801b6d,%rax
  801d3c:	00 00 00 
  801d3f:	ff d0                	callq  *%rax
}
  801d41:	c9                   	leaveq 
  801d42:	c3                   	retq   

0000000000801d43 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801d43:	55                   	push   %rbp
  801d44:	48 89 e5             	mov    %rsp,%rbp
  801d47:	48 83 ec 20          	sub    $0x20,%rsp
  801d4b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d4e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d52:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801d55:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d58:	48 63 c8             	movslq %eax,%rcx
  801d5b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d62:	48 98                	cltq   
  801d64:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d6b:	00 
  801d6c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d72:	49 89 c8             	mov    %rcx,%r8
  801d75:	48 89 d1             	mov    %rdx,%rcx
  801d78:	48 89 c2             	mov    %rax,%rdx
  801d7b:	be 01 00 00 00       	mov    $0x1,%esi
  801d80:	bf 04 00 00 00       	mov    $0x4,%edi
  801d85:	48 b8 6d 1b 80 00 00 	movabs $0x801b6d,%rax
  801d8c:	00 00 00 
  801d8f:	ff d0                	callq  *%rax
}
  801d91:	c9                   	leaveq 
  801d92:	c3                   	retq   

0000000000801d93 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801d93:	55                   	push   %rbp
  801d94:	48 89 e5             	mov    %rsp,%rbp
  801d97:	48 83 ec 30          	sub    $0x30,%rsp
  801d9b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d9e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801da2:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801da5:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801da9:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801dad:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801db0:	48 63 c8             	movslq %eax,%rcx
  801db3:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801db7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dba:	48 63 f0             	movslq %eax,%rsi
  801dbd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dc1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dc4:	48 98                	cltq   
  801dc6:	48 89 0c 24          	mov    %rcx,(%rsp)
  801dca:	49 89 f9             	mov    %rdi,%r9
  801dcd:	49 89 f0             	mov    %rsi,%r8
  801dd0:	48 89 d1             	mov    %rdx,%rcx
  801dd3:	48 89 c2             	mov    %rax,%rdx
  801dd6:	be 01 00 00 00       	mov    $0x1,%esi
  801ddb:	bf 05 00 00 00       	mov    $0x5,%edi
  801de0:	48 b8 6d 1b 80 00 00 	movabs $0x801b6d,%rax
  801de7:	00 00 00 
  801dea:	ff d0                	callq  *%rax
}
  801dec:	c9                   	leaveq 
  801ded:	c3                   	retq   

0000000000801dee <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801dee:	55                   	push   %rbp
  801def:	48 89 e5             	mov    %rsp,%rbp
  801df2:	48 83 ec 20          	sub    $0x20,%rsp
  801df6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801df9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801dfd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e04:	48 98                	cltq   
  801e06:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e0d:	00 
  801e0e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e14:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e1a:	48 89 d1             	mov    %rdx,%rcx
  801e1d:	48 89 c2             	mov    %rax,%rdx
  801e20:	be 01 00 00 00       	mov    $0x1,%esi
  801e25:	bf 06 00 00 00       	mov    $0x6,%edi
  801e2a:	48 b8 6d 1b 80 00 00 	movabs $0x801b6d,%rax
  801e31:	00 00 00 
  801e34:	ff d0                	callq  *%rax
}
  801e36:	c9                   	leaveq 
  801e37:	c3                   	retq   

0000000000801e38 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801e38:	55                   	push   %rbp
  801e39:	48 89 e5             	mov    %rsp,%rbp
  801e3c:	48 83 ec 10          	sub    $0x10,%rsp
  801e40:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e43:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801e46:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e49:	48 63 d0             	movslq %eax,%rdx
  801e4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e4f:	48 98                	cltq   
  801e51:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e58:	00 
  801e59:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e5f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e65:	48 89 d1             	mov    %rdx,%rcx
  801e68:	48 89 c2             	mov    %rax,%rdx
  801e6b:	be 01 00 00 00       	mov    $0x1,%esi
  801e70:	bf 08 00 00 00       	mov    $0x8,%edi
  801e75:	48 b8 6d 1b 80 00 00 	movabs $0x801b6d,%rax
  801e7c:	00 00 00 
  801e7f:	ff d0                	callq  *%rax
}
  801e81:	c9                   	leaveq 
  801e82:	c3                   	retq   

0000000000801e83 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801e83:	55                   	push   %rbp
  801e84:	48 89 e5             	mov    %rsp,%rbp
  801e87:	48 83 ec 20          	sub    $0x20,%rsp
  801e8b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e8e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801e92:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e96:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e99:	48 98                	cltq   
  801e9b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ea2:	00 
  801ea3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ea9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801eaf:	48 89 d1             	mov    %rdx,%rcx
  801eb2:	48 89 c2             	mov    %rax,%rdx
  801eb5:	be 01 00 00 00       	mov    $0x1,%esi
  801eba:	bf 09 00 00 00       	mov    $0x9,%edi
  801ebf:	48 b8 6d 1b 80 00 00 	movabs $0x801b6d,%rax
  801ec6:	00 00 00 
  801ec9:	ff d0                	callq  *%rax
}
  801ecb:	c9                   	leaveq 
  801ecc:	c3                   	retq   

0000000000801ecd <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801ecd:	55                   	push   %rbp
  801ece:	48 89 e5             	mov    %rsp,%rbp
  801ed1:	48 83 ec 20          	sub    $0x20,%rsp
  801ed5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ed8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801edc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ee0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ee3:	48 98                	cltq   
  801ee5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801eec:	00 
  801eed:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ef3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ef9:	48 89 d1             	mov    %rdx,%rcx
  801efc:	48 89 c2             	mov    %rax,%rdx
  801eff:	be 01 00 00 00       	mov    $0x1,%esi
  801f04:	bf 0a 00 00 00       	mov    $0xa,%edi
  801f09:	48 b8 6d 1b 80 00 00 	movabs $0x801b6d,%rax
  801f10:	00 00 00 
  801f13:	ff d0                	callq  *%rax
}
  801f15:	c9                   	leaveq 
  801f16:	c3                   	retq   

0000000000801f17 <sys_set_priority>:

void
sys_set_priority(envid_t envid, int priority)
{
  801f17:	55                   	push   %rbp
  801f18:	48 89 e5             	mov    %rsp,%rbp
  801f1b:	48 83 ec 10          	sub    $0x10,%rsp
  801f1f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f22:	89 75 f8             	mov    %esi,-0x8(%rbp)
	syscall(SYS_set_priority,1,envid,priority,0,0,0);
  801f25:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f28:	48 63 d0             	movslq %eax,%rdx
  801f2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f2e:	48 98                	cltq   
  801f30:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f37:	00 
  801f38:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f3e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f44:	48 89 d1             	mov    %rdx,%rcx
  801f47:	48 89 c2             	mov    %rax,%rdx
  801f4a:	be 01 00 00 00       	mov    $0x1,%esi
  801f4f:	bf 11 00 00 00       	mov    $0x11,%edi
  801f54:	48 b8 6d 1b 80 00 00 	movabs $0x801b6d,%rax
  801f5b:	00 00 00 
  801f5e:	ff d0                	callq  *%rax

}
  801f60:	c9                   	leaveq 
  801f61:	c3                   	retq   

0000000000801f62 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801f62:	55                   	push   %rbp
  801f63:	48 89 e5             	mov    %rsp,%rbp
  801f66:	48 83 ec 20          	sub    $0x20,%rsp
  801f6a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f6d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801f71:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801f75:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801f78:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f7b:	48 63 f0             	movslq %eax,%rsi
  801f7e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801f82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f85:	48 98                	cltq   
  801f87:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f8b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f92:	00 
  801f93:	49 89 f1             	mov    %rsi,%r9
  801f96:	49 89 c8             	mov    %rcx,%r8
  801f99:	48 89 d1             	mov    %rdx,%rcx
  801f9c:	48 89 c2             	mov    %rax,%rdx
  801f9f:	be 00 00 00 00       	mov    $0x0,%esi
  801fa4:	bf 0c 00 00 00       	mov    $0xc,%edi
  801fa9:	48 b8 6d 1b 80 00 00 	movabs $0x801b6d,%rax
  801fb0:	00 00 00 
  801fb3:	ff d0                	callq  *%rax
}
  801fb5:	c9                   	leaveq 
  801fb6:	c3                   	retq   

0000000000801fb7 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801fb7:	55                   	push   %rbp
  801fb8:	48 89 e5             	mov    %rsp,%rbp
  801fbb:	48 83 ec 10          	sub    $0x10,%rsp
  801fbf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801fc3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fc7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fce:	00 
  801fcf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fd5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fdb:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fe0:	48 89 c2             	mov    %rax,%rdx
  801fe3:	be 01 00 00 00       	mov    $0x1,%esi
  801fe8:	bf 0d 00 00 00       	mov    $0xd,%edi
  801fed:	48 b8 6d 1b 80 00 00 	movabs $0x801b6d,%rax
  801ff4:	00 00 00 
  801ff7:	ff d0                	callq  *%rax
}
  801ff9:	c9                   	leaveq 
  801ffa:	c3                   	retq   

0000000000801ffb <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801ffb:	55                   	push   %rbp
  801ffc:	48 89 e5             	mov    %rsp,%rbp
  801fff:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  802003:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80200a:	00 
  80200b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802011:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802017:	b9 00 00 00 00       	mov    $0x0,%ecx
  80201c:	ba 00 00 00 00       	mov    $0x0,%edx
  802021:	be 00 00 00 00       	mov    $0x0,%esi
  802026:	bf 0e 00 00 00       	mov    $0xe,%edi
  80202b:	48 b8 6d 1b 80 00 00 	movabs $0x801b6d,%rax
  802032:	00 00 00 
  802035:	ff d0                	callq  *%rax
}
  802037:	c9                   	leaveq 
  802038:	c3                   	retq   

0000000000802039 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  802039:	55                   	push   %rbp
  80203a:	48 89 e5             	mov    %rsp,%rbp
  80203d:	48 83 ec 30          	sub    $0x30,%rsp
  802041:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802044:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802048:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80204b:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80204f:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  802053:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802056:	48 63 c8             	movslq %eax,%rcx
  802059:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80205d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802060:	48 63 f0             	movslq %eax,%rsi
  802063:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802067:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80206a:	48 98                	cltq   
  80206c:	48 89 0c 24          	mov    %rcx,(%rsp)
  802070:	49 89 f9             	mov    %rdi,%r9
  802073:	49 89 f0             	mov    %rsi,%r8
  802076:	48 89 d1             	mov    %rdx,%rcx
  802079:	48 89 c2             	mov    %rax,%rdx
  80207c:	be 00 00 00 00       	mov    $0x0,%esi
  802081:	bf 0f 00 00 00       	mov    $0xf,%edi
  802086:	48 b8 6d 1b 80 00 00 	movabs $0x801b6d,%rax
  80208d:	00 00 00 
  802090:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  802092:	c9                   	leaveq 
  802093:	c3                   	retq   

0000000000802094 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  802094:	55                   	push   %rbp
  802095:	48 89 e5             	mov    %rsp,%rbp
  802098:	48 83 ec 20          	sub    $0x20,%rsp
  80209c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8020a0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  8020a4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020ac:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8020b3:	00 
  8020b4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020ba:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020c0:	48 89 d1             	mov    %rdx,%rcx
  8020c3:	48 89 c2             	mov    %rax,%rdx
  8020c6:	be 00 00 00 00       	mov    $0x0,%esi
  8020cb:	bf 10 00 00 00       	mov    $0x10,%edi
  8020d0:	48 b8 6d 1b 80 00 00 	movabs $0x801b6d,%rax
  8020d7:	00 00 00 
  8020da:	ff d0                	callq  *%rax
}
  8020dc:	c9                   	leaveq 
  8020dd:	c3                   	retq   

00000000008020de <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8020de:	55                   	push   %rbp
  8020df:	48 89 e5             	mov    %rsp,%rbp
  8020e2:	48 83 ec 30          	sub    $0x30,%rsp
  8020e6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)



	void *addr = (void *) utf->utf_fault_va;
  8020ea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020ee:	48 8b 00             	mov    (%rax),%rax
  8020f1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint32_t err = utf->utf_err;
  8020f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020f9:	48 8b 40 08          	mov    0x8(%rax),%rax
  8020fd:	89 45 f4             	mov    %eax,-0xc(%rbp)
        // Hint:
        //   Use the read-only page table mappings at vpt
        //   (see <inc/memlayout.h>).

        // LAB 4: Your code here.
	if (!(err&FEC_WR))
  802100:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802103:	83 e0 02             	and    $0x2,%eax
  802106:	85 c0                	test   %eax,%eax
  802108:	75 2a                	jne    802134 <pgfault+0x56>
		panic("pgfault:FEC_WR check\n");
  80210a:	48 ba d8 4c 80 00 00 	movabs $0x804cd8,%rdx
  802111:	00 00 00 
  802114:	be 21 00 00 00       	mov    $0x21,%esi
  802119:	48 bf ee 4c 80 00 00 	movabs $0x804cee,%rdi
  802120:	00 00 00 
  802123:	b8 00 00 00 00       	mov    $0x0,%eax
  802128:	48 b9 e5 05 80 00 00 	movabs $0x8005e5,%rcx
  80212f:	00 00 00 
  802132:	ff d1                	callq  *%rcx
	if (!(uvpt[((uint64_t)addr) / PGSIZE] & PTE_COW))
  802134:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802138:	48 c1 e8 0c          	shr    $0xc,%rax
  80213c:	48 89 c2             	mov    %rax,%rdx
  80213f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802146:	01 00 00 
  802149:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80214d:	25 00 08 00 00       	and    $0x800,%eax
  802152:	48 85 c0             	test   %rax,%rax
  802155:	75 2a                	jne    802181 <pgfault+0xa3>
		panic("pgfault:PTE_COW check\n");
  802157:	48 ba f9 4c 80 00 00 	movabs $0x804cf9,%rdx
  80215e:	00 00 00 
  802161:	be 23 00 00 00       	mov    $0x23,%esi
  802166:	48 bf ee 4c 80 00 00 	movabs $0x804cee,%rdi
  80216d:	00 00 00 
  802170:	b8 00 00 00 00       	mov    $0x0,%eax
  802175:	48 b9 e5 05 80 00 00 	movabs $0x8005e5,%rcx
  80217c:	00 00 00 
  80217f:	ff d1                	callq  *%rcx
        // Hint:
        //   You should make three system calls.
        //   No need to explicitly delete the old page's mapping.

        // LAB 4: Your code here.
	addr = ROUNDDOWN(addr, PGSIZE);
  802181:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802185:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802189:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80218d:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802193:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (sys_page_alloc(0, (void*)PFTEMP, PTE_P|PTE_W|PTE_U)<0)
  802197:	ba 07 00 00 00       	mov    $0x7,%edx
  80219c:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8021a1:	bf 00 00 00 00       	mov    $0x0,%edi
  8021a6:	48 b8 43 1d 80 00 00 	movabs $0x801d43,%rax
  8021ad:	00 00 00 
  8021b0:	ff d0                	callq  *%rax
  8021b2:	85 c0                	test   %eax,%eax
  8021b4:	79 2a                	jns    8021e0 <pgfault+0x102>
		panic("pgfault: sys_page_alloc error\n");
  8021b6:	48 ba 10 4d 80 00 00 	movabs $0x804d10,%rdx
  8021bd:	00 00 00 
  8021c0:	be 2f 00 00 00       	mov    $0x2f,%esi
  8021c5:	48 bf ee 4c 80 00 00 	movabs $0x804cee,%rdi
  8021cc:	00 00 00 
  8021cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d4:	48 b9 e5 05 80 00 00 	movabs $0x8005e5,%rcx
  8021db:	00 00 00 
  8021de:	ff d1                	callq  *%rcx
	memcpy(PFTEMP, addr, PGSIZE);
  8021e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021e4:	ba 00 10 00 00       	mov    $0x1000,%edx
  8021e9:	48 89 c6             	mov    %rax,%rsi
  8021ec:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  8021f1:	48 b8 4f 18 80 00 00 	movabs $0x80184f,%rax
  8021f8:	00 00 00 
  8021fb:	ff d0                	callq  *%rax
	if (sys_page_map(0, (void*)PFTEMP, 0, addr, PTE_P|PTE_W|PTE_U) < 0)
  8021fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802201:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802207:	48 89 c1             	mov    %rax,%rcx
  80220a:	ba 00 00 00 00       	mov    $0x0,%edx
  80220f:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802214:	bf 00 00 00 00       	mov    $0x0,%edi
  802219:	48 b8 93 1d 80 00 00 	movabs $0x801d93,%rax
  802220:	00 00 00 
  802223:	ff d0                	callq  *%rax
  802225:	85 c0                	test   %eax,%eax
  802227:	79 2a                	jns    802253 <pgfault+0x175>
		panic("pgfault: sys_page_map error\n");
  802229:	48 ba 2f 4d 80 00 00 	movabs $0x804d2f,%rdx
  802230:	00 00 00 
  802233:	be 32 00 00 00       	mov    $0x32,%esi
  802238:	48 bf ee 4c 80 00 00 	movabs $0x804cee,%rdi
  80223f:	00 00 00 
  802242:	b8 00 00 00 00       	mov    $0x0,%eax
  802247:	48 b9 e5 05 80 00 00 	movabs $0x8005e5,%rcx
  80224e:	00 00 00 
  802251:	ff d1                	callq  *%rcx

	if (sys_page_unmap(0, (void *)PFTEMP)<0)
  802253:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802258:	bf 00 00 00 00       	mov    $0x0,%edi
  80225d:	48 b8 ee 1d 80 00 00 	movabs $0x801dee,%rax
  802264:	00 00 00 
  802267:	ff d0                	callq  *%rax
  802269:	85 c0                	test   %eax,%eax
  80226b:	79 2a                	jns    802297 <pgfault+0x1b9>
		panic("pgfault: sys_page_unmap error\n");
  80226d:	48 ba 50 4d 80 00 00 	movabs $0x804d50,%rdx
  802274:	00 00 00 
  802277:	be 35 00 00 00       	mov    $0x35,%esi
  80227c:	48 bf ee 4c 80 00 00 	movabs $0x804cee,%rdi
  802283:	00 00 00 
  802286:	b8 00 00 00 00       	mov    $0x0,%eax
  80228b:	48 b9 e5 05 80 00 00 	movabs $0x8005e5,%rcx
  802292:	00 00 00 
  802295:	ff d1                	callq  *%rcx
	


}
  802297:	c9                   	leaveq 
  802298:	c3                   	retq   

0000000000802299 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  802299:	55                   	push   %rbp
  80229a:	48 89 e5             	mov    %rsp,%rbp
  80229d:	48 83 ec 10          	sub    $0x10,%rsp
  8022a1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8022a4:	89 75 f8             	mov    %esi,-0x8(%rbp)

	if (uvpt[pn] & PTE_SHARE){
  8022a7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022ae:	01 00 00 
  8022b1:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8022b4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022b8:	25 00 04 00 00       	and    $0x400,%eax
  8022bd:	48 85 c0             	test   %rax,%rax
  8022c0:	74 75                	je     802337 <duppage+0x9e>
		if (sys_page_map (0, (void*) ((uint64_t)pn * PGSIZE), envid, (void*) ((uint64_t)pn * PGSIZE), uvpt[pn] & PTE_SYSCALL)<0)
  8022c2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022c9:	01 00 00 
  8022cc:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8022cf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022d3:	25 07 0e 00 00       	and    $0xe07,%eax
  8022d8:	89 c6                	mov    %eax,%esi
  8022da:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022dd:	48 c1 e0 0c          	shl    $0xc,%rax
  8022e1:	48 89 c1             	mov    %rax,%rcx
  8022e4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022e7:	48 c1 e0 0c          	shl    $0xc,%rax
  8022eb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8022ee:	41 89 f0             	mov    %esi,%r8d
  8022f1:	48 89 c6             	mov    %rax,%rsi
  8022f4:	bf 00 00 00 00       	mov    $0x0,%edi
  8022f9:	48 b8 93 1d 80 00 00 	movabs $0x801d93,%rax
  802300:	00 00 00 
  802303:	ff d0                	callq  *%rax
  802305:	85 c0                	test   %eax,%eax
  802307:	0f 89 82 01 00 00    	jns    80248f <duppage+0x1f6>
			panic("duppage:sys_page_map error\n");	
  80230d:	48 ba 6f 4d 80 00 00 	movabs $0x804d6f,%rdx
  802314:	00 00 00 
  802317:	be 4c 00 00 00       	mov    $0x4c,%esi
  80231c:	48 bf ee 4c 80 00 00 	movabs $0x804cee,%rdi
  802323:	00 00 00 
  802326:	b8 00 00 00 00       	mov    $0x0,%eax
  80232b:	48 b9 e5 05 80 00 00 	movabs $0x8005e5,%rcx
  802332:	00 00 00 
  802335:	ff d1                	callq  *%rcx
	}
	else
	if (!(uvpt[pn] & PTE_W) && !(uvpt[pn] & PTE_COW)) {
  802337:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80233e:	01 00 00 
  802341:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802344:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802348:	83 e0 02             	and    $0x2,%eax
  80234b:	48 85 c0             	test   %rax,%rax
  80234e:	75 7e                	jne    8023ce <duppage+0x135>
  802350:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802357:	01 00 00 
  80235a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80235d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802361:	25 00 08 00 00       	and    $0x800,%eax
  802366:	48 85 c0             	test   %rax,%rax
  802369:	75 63                	jne    8023ce <duppage+0x135>
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P)< 0) 
  80236b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80236e:	c1 e0 0c             	shl    $0xc,%eax
  802371:	89 c0                	mov    %eax,%eax
  802373:	48 89 c1             	mov    %rax,%rcx
  802376:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802379:	c1 e0 0c             	shl    $0xc,%eax
  80237c:	89 c0                	mov    %eax,%eax
  80237e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802381:	41 b8 05 00 00 00    	mov    $0x5,%r8d
  802387:	48 89 c6             	mov    %rax,%rsi
  80238a:	bf 00 00 00 00       	mov    $0x0,%edi
  80238f:	48 b8 93 1d 80 00 00 	movabs $0x801d93,%rax
  802396:	00 00 00 
  802399:	ff d0                	callq  *%rax
  80239b:	85 c0                	test   %eax,%eax
  80239d:	79 2a                	jns    8023c9 <duppage+0x130>
			panic("duppage:sys_page_map error\n");
  80239f:	48 ba 6f 4d 80 00 00 	movabs $0x804d6f,%rdx
  8023a6:	00 00 00 
  8023a9:	be 51 00 00 00       	mov    $0x51,%esi
  8023ae:	48 bf ee 4c 80 00 00 	movabs $0x804cee,%rdi
  8023b5:	00 00 00 
  8023b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8023bd:	48 b9 e5 05 80 00 00 	movabs $0x8005e5,%rcx
  8023c4:	00 00 00 
  8023c7:	ff d1                	callq  *%rcx
		if (sys_page_map (0, (void*) ((uint64_t)pn * PGSIZE), envid, (void*) ((uint64_t)pn * PGSIZE), uvpt[pn] & PTE_SYSCALL)<0)
			panic("duppage:sys_page_map error\n");	
	}
	else
	if (!(uvpt[pn] & PTE_W) && !(uvpt[pn] & PTE_COW)) {
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P)< 0) 
  8023c9:	e9 c1 00 00 00       	jmpq   80248f <duppage+0x1f6>
			panic("duppage:sys_page_map error\n");
	}
	else {
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P | PTE_COW)< 0) 
  8023ce:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023d1:	c1 e0 0c             	shl    $0xc,%eax
  8023d4:	89 c0                	mov    %eax,%eax
  8023d6:	48 89 c1             	mov    %rax,%rcx
  8023d9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023dc:	c1 e0 0c             	shl    $0xc,%eax
  8023df:	89 c0                	mov    %eax,%eax
  8023e1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8023e4:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  8023ea:	48 89 c6             	mov    %rax,%rsi
  8023ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8023f2:	48 b8 93 1d 80 00 00 	movabs $0x801d93,%rax
  8023f9:	00 00 00 
  8023fc:	ff d0                	callq  *%rax
  8023fe:	85 c0                	test   %eax,%eax
  802400:	79 2a                	jns    80242c <duppage+0x193>
			panic("duppage:sys_page_map error\n");
  802402:	48 ba 6f 4d 80 00 00 	movabs $0x804d6f,%rdx
  802409:	00 00 00 
  80240c:	be 55 00 00 00       	mov    $0x55,%esi
  802411:	48 bf ee 4c 80 00 00 	movabs $0x804cee,%rdi
  802418:	00 00 00 
  80241b:	b8 00 00 00 00       	mov    $0x0,%eax
  802420:	48 b9 e5 05 80 00 00 	movabs $0x8005e5,%rcx
  802427:	00 00 00 
  80242a:	ff d1                	callq  *%rcx
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), 0, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P | PTE_COW)< 0) 
  80242c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80242f:	c1 e0 0c             	shl    $0xc,%eax
  802432:	89 c0                	mov    %eax,%eax
  802434:	48 89 c2             	mov    %rax,%rdx
  802437:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80243a:	c1 e0 0c             	shl    $0xc,%eax
  80243d:	89 c0                	mov    %eax,%eax
  80243f:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  802445:	48 89 d1             	mov    %rdx,%rcx
  802448:	ba 00 00 00 00       	mov    $0x0,%edx
  80244d:	48 89 c6             	mov    %rax,%rsi
  802450:	bf 00 00 00 00       	mov    $0x0,%edi
  802455:	48 b8 93 1d 80 00 00 	movabs $0x801d93,%rax
  80245c:	00 00 00 
  80245f:	ff d0                	callq  *%rax
  802461:	85 c0                	test   %eax,%eax
  802463:	79 2a                	jns    80248f <duppage+0x1f6>
			panic("duppage:sys_page_map error\n");
  802465:	48 ba 6f 4d 80 00 00 	movabs $0x804d6f,%rdx
  80246c:	00 00 00 
  80246f:	be 57 00 00 00       	mov    $0x57,%esi
  802474:	48 bf ee 4c 80 00 00 	movabs $0x804cee,%rdi
  80247b:	00 00 00 
  80247e:	b8 00 00 00 00       	mov    $0x0,%eax
  802483:	48 b9 e5 05 80 00 00 	movabs $0x8005e5,%rcx
  80248a:	00 00 00 
  80248d:	ff d1                	callq  *%rcx
	}
	return 0;	   	
  80248f:	b8 00 00 00 00       	mov    $0x0,%eax

}
  802494:	c9                   	leaveq 
  802495:	c3                   	retq   

0000000000802496 <new_duppage>:


static int
new_duppage(envid_t envid, unsigned pn,int flag)
{
  802496:	55                   	push   %rbp
  802497:	48 89 e5             	mov    %rsp,%rbp
  80249a:	48 83 ec 10          	sub    $0x10,%rsp
  80249e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8024a1:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8024a4:	89 55 f4             	mov    %edx,-0xc(%rbp)
	
	if (!(uvpt[pn] & PTE_W) && !(uvpt[pn] & PTE_COW) && !flag) {
  8024a7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024ae:	01 00 00 
  8024b1:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8024b4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024b8:	83 e0 02             	and    $0x2,%eax
  8024bb:	48 85 c0             	test   %rax,%rax
  8024be:	0f 85 84 00 00 00    	jne    802548 <new_duppage+0xb2>
  8024c4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024cb:	01 00 00 
  8024ce:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8024d1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024d5:	25 00 08 00 00       	and    $0x800,%eax
  8024da:	48 85 c0             	test   %rax,%rax
  8024dd:	75 69                	jne    802548 <new_duppage+0xb2>
  8024df:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8024e3:	75 63                	jne    802548 <new_duppage+0xb2>
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P)< 0) 
  8024e5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024e8:	c1 e0 0c             	shl    $0xc,%eax
  8024eb:	89 c0                	mov    %eax,%eax
  8024ed:	48 89 c1             	mov    %rax,%rcx
  8024f0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024f3:	c1 e0 0c             	shl    $0xc,%eax
  8024f6:	89 c0                	mov    %eax,%eax
  8024f8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8024fb:	41 b8 05 00 00 00    	mov    $0x5,%r8d
  802501:	48 89 c6             	mov    %rax,%rsi
  802504:	bf 00 00 00 00       	mov    $0x0,%edi
  802509:	48 b8 93 1d 80 00 00 	movabs $0x801d93,%rax
  802510:	00 00 00 
  802513:	ff d0                	callq  *%rax
  802515:	85 c0                	test   %eax,%eax
  802517:	79 2a                	jns    802543 <new_duppage+0xad>
			panic("duppage:sys_page_map error\n");
  802519:	48 ba 6f 4d 80 00 00 	movabs $0x804d6f,%rdx
  802520:	00 00 00 
  802523:	be 64 00 00 00       	mov    $0x64,%esi
  802528:	48 bf ee 4c 80 00 00 	movabs $0x804cee,%rdi
  80252f:	00 00 00 
  802532:	b8 00 00 00 00       	mov    $0x0,%eax
  802537:	48 b9 e5 05 80 00 00 	movabs $0x8005e5,%rcx
  80253e:	00 00 00 
  802541:	ff d1                	callq  *%rcx
static int
new_duppage(envid_t envid, unsigned pn,int flag)
{
	
	if (!(uvpt[pn] & PTE_W) && !(uvpt[pn] & PTE_COW) && !flag) {
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P)< 0) 
  802543:	e9 c1 00 00 00       	jmpq   802609 <new_duppage+0x173>
			panic("duppage:sys_page_map error\n");
	}
	else {
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), envid, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P | PTE_COW)< 0) 
  802548:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80254b:	c1 e0 0c             	shl    $0xc,%eax
  80254e:	89 c0                	mov    %eax,%eax
  802550:	48 89 c1             	mov    %rax,%rcx
  802553:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802556:	c1 e0 0c             	shl    $0xc,%eax
  802559:	89 c0                	mov    %eax,%eax
  80255b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80255e:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  802564:	48 89 c6             	mov    %rax,%rsi
  802567:	bf 00 00 00 00       	mov    $0x0,%edi
  80256c:	48 b8 93 1d 80 00 00 	movabs $0x801d93,%rax
  802573:	00 00 00 
  802576:	ff d0                	callq  *%rax
  802578:	85 c0                	test   %eax,%eax
  80257a:	79 2a                	jns    8025a6 <new_duppage+0x110>
			panic("duppage:sys_page_map error\n");
  80257c:	48 ba 6f 4d 80 00 00 	movabs $0x804d6f,%rdx
  802583:	00 00 00 
  802586:	be 68 00 00 00       	mov    $0x68,%esi
  80258b:	48 bf ee 4c 80 00 00 	movabs $0x804cee,%rdi
  802592:	00 00 00 
  802595:	b8 00 00 00 00       	mov    $0x0,%eax
  80259a:	48 b9 e5 05 80 00 00 	movabs $0x8005e5,%rcx
  8025a1:	00 00 00 
  8025a4:	ff d1                	callq  *%rcx
		if (sys_page_map(0, (void*)((uint64_t)(pn * PGSIZE)), 0, (void*)((uint64_t)(pn * PGSIZE)), PTE_U | PTE_P | PTE_COW)< 0) 
  8025a6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8025a9:	c1 e0 0c             	shl    $0xc,%eax
  8025ac:	89 c0                	mov    %eax,%eax
  8025ae:	48 89 c2             	mov    %rax,%rdx
  8025b1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8025b4:	c1 e0 0c             	shl    $0xc,%eax
  8025b7:	89 c0                	mov    %eax,%eax
  8025b9:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  8025bf:	48 89 d1             	mov    %rdx,%rcx
  8025c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8025c7:	48 89 c6             	mov    %rax,%rsi
  8025ca:	bf 00 00 00 00       	mov    $0x0,%edi
  8025cf:	48 b8 93 1d 80 00 00 	movabs $0x801d93,%rax
  8025d6:	00 00 00 
  8025d9:	ff d0                	callq  *%rax
  8025db:	85 c0                	test   %eax,%eax
  8025dd:	79 2a                	jns    802609 <new_duppage+0x173>
			panic("duppage:sys_page_map error\n");
  8025df:	48 ba 6f 4d 80 00 00 	movabs $0x804d6f,%rdx
  8025e6:	00 00 00 
  8025e9:	be 6a 00 00 00       	mov    $0x6a,%esi
  8025ee:	48 bf ee 4c 80 00 00 	movabs $0x804cee,%rdi
  8025f5:	00 00 00 
  8025f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8025fd:	48 b9 e5 05 80 00 00 	movabs $0x8005e5,%rcx
  802604:	00 00 00 
  802607:	ff d1                	callq  *%rcx
	}
	return 0;	   	
  802609:	b8 00 00 00 00       	mov    $0x0,%eax

}
  80260e:	c9                   	leaveq 
  80260f:	c3                   	retq   

0000000000802610 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  802610:	55                   	push   %rbp
  802611:	48 89 e5             	mov    %rsp,%rbp
  802614:	48 83 ec 10          	sub    $0x10,%rsp


	
	int envid;  
	//extern unsigned char end[];      
	set_pgfault_handler(pgfault);
  802618:	48 bf de 20 80 00 00 	movabs $0x8020de,%rdi
  80261f:	00 00 00 
  802622:	48 b8 91 42 80 00 00 	movabs $0x804291,%rax
  802629:	00 00 00 
  80262c:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80262e:	b8 07 00 00 00       	mov    $0x7,%eax
  802633:	cd 30                	int    $0x30
  802635:	89 45 f0             	mov    %eax,-0x10(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802638:	8b 45 f0             	mov    -0x10(%rbp),%eax


	if ((envid=sys_exofork())<0)
  80263b:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80263e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802642:	79 2a                	jns    80266e <fork+0x5e>
		panic("fork: sys_exofork error!\n"); 
  802644:	48 ba 8b 4d 80 00 00 	movabs $0x804d8b,%rdx
  80264b:	00 00 00 
  80264e:	be 90 00 00 00       	mov    $0x90,%esi
  802653:	48 bf ee 4c 80 00 00 	movabs $0x804cee,%rdi
  80265a:	00 00 00 
  80265d:	b8 00 00 00 00       	mov    $0x0,%eax
  802662:	48 b9 e5 05 80 00 00 	movabs $0x8005e5,%rcx
  802669:	00 00 00 
  80266c:	ff d1                	callq  *%rcx

	if(envid>0){
  80266e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802672:	0f 8e e1 01 00 00    	jle    802859 <fork+0x249>
		
		
		uintptr_t i;
    for (i = UTEXT; i < (uintptr_t)USTACKTOP-PGSIZE/*USTACKTOP-PGSIZE*/; i += PGSIZE) 
  802678:	48 c7 45 f8 00 00 80 	movq   $0x800000,-0x8(%rbp)
  80267f:	00 
  802680:	e9 d4 00 00 00       	jmpq   802759 <fork+0x149>
		{
			

               if(!(uvpml4e[VPML4E(i)]))
  802685:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802689:	48 c1 e8 27          	shr    $0x27,%rax
  80268d:	48 89 c2             	mov    %rax,%rdx
  802690:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  802697:	01 00 00 
  80269a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80269e:	48 85 c0             	test   %rax,%rax
  8026a1:	75 05                	jne    8026a8 <fork+0x98>
		 continue;
  8026a3:	e9 a9 00 00 00       	jmpq   802751 <fork+0x141>
		
		if(!(uvpde[VPDPE(i)]))
  8026a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026ac:	48 c1 e8 1e          	shr    $0x1e,%rax
  8026b0:	48 89 c2             	mov    %rax,%rdx
  8026b3:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8026ba:	01 00 00 
  8026bd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026c1:	48 85 c0             	test   %rax,%rax
  8026c4:	75 05                	jne    8026cb <fork+0xbb>
	          continue;
  8026c6:	e9 86 00 00 00       	jmpq   802751 <fork+0x141>
	

			if(!(uvpd[VPD(i)] & PTE_P))
  8026cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026cf:	48 c1 e8 15          	shr    $0x15,%rax
  8026d3:	48 89 c2             	mov    %rax,%rdx
  8026d6:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8026dd:	01 00 00 
  8026e0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026e4:	83 e0 01             	and    $0x1,%eax
  8026e7:	48 85 c0             	test   %rax,%rax
  8026ea:	75 02                	jne    8026ee <fork+0xde>
				continue;
  8026ec:	eb 63                	jmp    802751 <fork+0x141>
			if(!(uvpt[VPN(i)] & PTE_P))
  8026ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026f2:	48 c1 e8 0c          	shr    $0xc,%rax
  8026f6:	48 89 c2             	mov    %rax,%rdx
  8026f9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802700:	01 00 00 
  802703:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802707:	83 e0 01             	and    $0x1,%eax
  80270a:	48 85 c0             	test   %rax,%rax
  80270d:	75 02                	jne    802711 <fork+0x101>
				continue; 
  80270f:	eb 40                	jmp    802751 <fork+0x141>
			if(!(uvpt[VPN(i)] & PTE_U))
  802711:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802715:	48 c1 e8 0c          	shr    $0xc,%rax
  802719:	48 89 c2             	mov    %rax,%rdx
  80271c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802723:	01 00 00 
  802726:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80272a:	83 e0 04             	and    $0x4,%eax
  80272d:	48 85 c0             	test   %rax,%rax
  802730:	75 02                	jne    802734 <fork+0x124>
				continue; 
  802732:	eb 1d                	jmp    802751 <fork+0x141>
			duppage(envid, VPN(i)); 
  802734:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802738:	48 c1 e8 0c          	shr    $0xc,%rax
  80273c:	89 c2                	mov    %eax,%edx
  80273e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802741:	89 d6                	mov    %edx,%esi
  802743:	89 c7                	mov    %eax,%edi
  802745:	48 b8 99 22 80 00 00 	movabs $0x802299,%rax
  80274c:	00 00 00 
  80274f:	ff d0                	callq  *%rax

	if(envid>0){
		
		
		uintptr_t i;
    for (i = UTEXT; i < (uintptr_t)USTACKTOP-PGSIZE/*USTACKTOP-PGSIZE*/; i += PGSIZE) 
  802751:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  802758:	00 
  802759:	b8 ff cf 7f ef       	mov    $0xef7fcfff,%eax
  80275e:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  802762:	0f 86 1d ff ff ff    	jbe    802685 <fork+0x75>
			if(!(uvpt[VPN(i)] & PTE_U))
				continue; 
			duppage(envid, VPN(i)); 
		}

		if (sys_page_alloc(envid,(void*)UXSTACKTOP-PGSIZE, PTE_U|PTE_W|PTE_P)<0)
  802768:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80276b:	ba 07 00 00 00       	mov    $0x7,%edx
  802770:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802775:	89 c7                	mov    %eax,%edi
  802777:	48 b8 43 1d 80 00 00 	movabs $0x801d43,%rax
  80277e:	00 00 00 
  802781:	ff d0                	callq  *%rax
  802783:	85 c0                	test   %eax,%eax
  802785:	79 2a                	jns    8027b1 <fork+0x1a1>
			panic("fork: sys_page_alloc error!\n");
  802787:	48 ba a5 4d 80 00 00 	movabs $0x804da5,%rdx
  80278e:	00 00 00 
  802791:	be ab 00 00 00       	mov    $0xab,%esi
  802796:	48 bf ee 4c 80 00 00 	movabs $0x804cee,%rdi
  80279d:	00 00 00 
  8027a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a5:	48 b9 e5 05 80 00 00 	movabs $0x8005e5,%rcx
  8027ac:	00 00 00 
  8027af:	ff d1                	callq  *%rcx

		duppage(envid, VPN(USTACKTOP-PGSIZE));
  8027b1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8027b4:	be fd f7 0e 00       	mov    $0xef7fd,%esi
  8027b9:	89 c7                	mov    %eax,%edi
  8027bb:	48 b8 99 22 80 00 00 	movabs $0x802299,%rax
  8027c2:	00 00 00 
  8027c5:	ff d0                	callq  *%rax
		extern void _pgfault_upcall(void);
		if (sys_env_set_pgfault_upcall(envid, _pgfault_upcall)<0)
  8027c7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8027ca:	48 be 31 43 80 00 00 	movabs $0x804331,%rsi
  8027d1:	00 00 00 
  8027d4:	89 c7                	mov    %eax,%edi
  8027d6:	48 b8 cd 1e 80 00 00 	movabs $0x801ecd,%rax
  8027dd:	00 00 00 
  8027e0:	ff d0                	callq  *%rax
  8027e2:	85 c0                	test   %eax,%eax
  8027e4:	79 2a                	jns    802810 <fork+0x200>
			panic("fork: sys_env_set_status error!\n");
  8027e6:	48 ba c8 4d 80 00 00 	movabs $0x804dc8,%rdx
  8027ed:	00 00 00 
  8027f0:	be b0 00 00 00       	mov    $0xb0,%esi
  8027f5:	48 bf ee 4c 80 00 00 	movabs $0x804cee,%rdi
  8027fc:	00 00 00 
  8027ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802804:	48 b9 e5 05 80 00 00 	movabs $0x8005e5,%rcx
  80280b:	00 00 00 
  80280e:	ff d1                	callq  *%rcx
		if (sys_env_set_status(envid, ENV_RUNNABLE)<0)
  802810:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802813:	be 02 00 00 00       	mov    $0x2,%esi
  802818:	89 c7                	mov    %eax,%edi
  80281a:	48 b8 38 1e 80 00 00 	movabs $0x801e38,%rax
  802821:	00 00 00 
  802824:	ff d0                	callq  *%rax
  802826:	85 c0                	test   %eax,%eax
  802828:	79 2a                	jns    802854 <fork+0x244>
			panic("fork: sys_env_set_status error!\n");
  80282a:	48 ba c8 4d 80 00 00 	movabs $0x804dc8,%rdx
  802831:	00 00 00 
  802834:	be b2 00 00 00       	mov    $0xb2,%esi
  802839:	48 bf ee 4c 80 00 00 	movabs $0x804cee,%rdi
  802840:	00 00 00 
  802843:	b8 00 00 00 00       	mov    $0x0,%eax
  802848:	48 b9 e5 05 80 00 00 	movabs $0x8005e5,%rcx
  80284f:	00 00 00 
  802852:	ff d1                	callq  *%rcx

		return envid;
  802854:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802857:	eb 39                	jmp    802892 <fork+0x282>
	}
	else
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  802859:	48 b8 c7 1c 80 00 00 	movabs $0x801cc7,%rax
  802860:	00 00 00 
  802863:	ff d0                	callq  *%rax
  802865:	25 ff 03 00 00       	and    $0x3ff,%eax
  80286a:	48 98                	cltq   
  80286c:	48 69 d0 70 01 00 00 	imul   $0x170,%rax,%rdx
  802873:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80287a:	00 00 00 
  80287d:	48 01 c2             	add    %rax,%rdx
  802880:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802887:	00 00 00 
  80288a:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  80288d:	b8 00 00 00 00       	mov    $0x0,%eax
	}

}
  802892:	c9                   	leaveq 
  802893:	c3                   	retq   

0000000000802894 <sfork>:

// Challenge!
envid_t
sfork(void)
{
  802894:	55                   	push   %rbp
  802895:	48 89 e5             	mov    %rsp,%rbp
  802898:	48 83 ec 20          	sub    $0x20,%rsp

	
	int envid;  
	extern unsigned char end[];      
	set_pgfault_handler(pgfault);
  80289c:	48 bf de 20 80 00 00 	movabs $0x8020de,%rdi
  8028a3:	00 00 00 
  8028a6:	48 b8 91 42 80 00 00 	movabs $0x804291,%rax
  8028ad:	00 00 00 
  8028b0:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8028b2:	b8 07 00 00 00       	mov    $0x7,%eax
  8028b7:	cd 30                	int    $0x30
  8028b9:	89 45 ec             	mov    %eax,-0x14(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8028bc:	8b 45 ec             	mov    -0x14(%rbp),%eax
	

	if ((envid=sys_exofork())<0)
  8028bf:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8028c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8028c6:	79 2a                	jns    8028f2 <sfork+0x5e>
		panic("fork: sys_exofork error!\n"); 
  8028c8:	48 ba 8b 4d 80 00 00 	movabs $0x804d8b,%rdx
  8028cf:	00 00 00 
  8028d2:	be ca 00 00 00       	mov    $0xca,%esi
  8028d7:	48 bf ee 4c 80 00 00 	movabs $0x804cee,%rdi
  8028de:	00 00 00 
  8028e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e6:	48 b9 e5 05 80 00 00 	movabs $0x8005e5,%rcx
  8028ed:	00 00 00 
  8028f0:	ff d1                	callq  *%rcx

	if(envid>0){
  8028f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8028f6:	0f 8e e5 00 00 00    	jle    8029e1 <sfork+0x14d>
		
		
		uintptr_t i;
		int flag=1;
  8028fc:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%rbp)

		for (i = 0; i < (uintptr_t)end/*USTACKTOP-PGSIZE*/; i += PGSIZE) ;
  802903:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80290a:	00 
  80290b:	eb 08                	jmp    802915 <sfork+0x81>
  80290d:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  802914:	00 
  802915:	48 b8 10 90 80 00 00 	movabs $0x809010,%rax
  80291c:	00 00 00 
  80291f:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  802923:	72 e8                	jb     80290d <sfork+0x79>
	


		//new_duppage(envid, PPN(USTACKTOP-PGSIZE),flag);
		i-=PGSIZE;
  802925:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  80292c:	00 
    for (;i>=0; i -= PGSIZE) 
		{
			cprintf("23\n");
  80292d:	48 bf e9 4d 80 00 00 	movabs $0x804de9,%rdi
  802934:	00 00 00 
  802937:	b8 00 00 00 00       	mov    $0x0,%eax
  80293c:	48 ba 1e 08 80 00 00 	movabs $0x80081e,%rdx
  802943:	00 00 00 
  802946:	ff d2                	callq  *%rdx
			if(!(uvpd[VPD(i)] & PTE_P) || !(uvpt[VPN(i)] & PTE_P) || !(uvpt[VPN(i)] & PTE_U))
  802948:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80294c:	48 c1 e8 15          	shr    $0x15,%rax
  802950:	48 89 c2             	mov    %rax,%rdx
  802953:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80295a:	01 00 00 
  80295d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802961:	83 e0 01             	and    $0x1,%eax
  802964:	48 85 c0             	test   %rax,%rax
  802967:	74 42                	je     8029ab <sfork+0x117>
  802969:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80296d:	48 c1 e8 0c          	shr    $0xc,%rax
  802971:	48 89 c2             	mov    %rax,%rdx
  802974:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80297b:	01 00 00 
  80297e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802982:	83 e0 01             	and    $0x1,%eax
  802985:	48 85 c0             	test   %rax,%rax
  802988:	74 21                	je     8029ab <sfork+0x117>
  80298a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80298e:	48 c1 e8 0c          	shr    $0xc,%rax
  802992:	48 89 c2             	mov    %rax,%rdx
  802995:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80299c:	01 00 00 
  80299f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029a3:	83 e0 04             	and    $0x4,%eax
  8029a6:	48 85 c0             	test   %rax,%rax
  8029a9:	75 09                	jne    8029b4 <sfork+0x120>
				flag=0;
  8029ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  8029b2:	eb 20                	jmp    8029d4 <sfork+0x140>
			else
				new_duppage(envid, VPN(i),flag); 
  8029b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029b8:	48 c1 e8 0c          	shr    $0xc,%rax
  8029bc:	89 c1                	mov    %eax,%ecx
  8029be:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8029c1:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8029c4:	89 ce                	mov    %ecx,%esi
  8029c6:	89 c7                	mov    %eax,%edi
  8029c8:	48 b8 96 24 80 00 00 	movabs $0x802496,%rax
  8029cf:	00 00 00 
  8029d2:	ff d0                	callq  *%rax
	


		//new_duppage(envid, PPN(USTACKTOP-PGSIZE),flag);
		i-=PGSIZE;
    for (;i>=0; i -= PGSIZE) 
  8029d4:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
  8029db:	00 
			if(!(uvpd[VPD(i)] & PTE_P) || !(uvpt[VPN(i)] & PTE_P) || !(uvpt[VPN(i)] & PTE_U))
				flag=0;
			else
				new_duppage(envid, VPN(i),flag); 

		}
  8029dc:	e9 4c ff ff ff       	jmpq   80292d <sfork+0x99>

		return envid;
	}
	else
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  8029e1:	48 b8 c7 1c 80 00 00 	movabs $0x801cc7,%rax
  8029e8:	00 00 00 
  8029eb:	ff d0                	callq  *%rax
  8029ed:	25 ff 03 00 00       	and    $0x3ff,%eax
  8029f2:	48 98                	cltq   
  8029f4:	48 69 d0 70 01 00 00 	imul   $0x170,%rax,%rdx
  8029fb:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802a02:	00 00 00 
  802a05:	48 01 c2             	add    %rax,%rdx
  802a08:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802a0f:	00 00 00 
  802a12:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  802a15:	b8 00 00 00 00       	mov    $0x0,%eax
	}

}
  802a1a:	c9                   	leaveq 
  802a1b:	c3                   	retq   

0000000000802a1c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802a1c:	55                   	push   %rbp
  802a1d:	48 89 e5             	mov    %rsp,%rbp
  802a20:	48 83 ec 08          	sub    $0x8,%rsp
  802a24:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802a28:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802a2c:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802a33:	ff ff ff 
  802a36:	48 01 d0             	add    %rdx,%rax
  802a39:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802a3d:	c9                   	leaveq 
  802a3e:	c3                   	retq   

0000000000802a3f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802a3f:	55                   	push   %rbp
  802a40:	48 89 e5             	mov    %rsp,%rbp
  802a43:	48 83 ec 08          	sub    $0x8,%rsp
  802a47:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802a4b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a4f:	48 89 c7             	mov    %rax,%rdi
  802a52:	48 b8 1c 2a 80 00 00 	movabs $0x802a1c,%rax
  802a59:	00 00 00 
  802a5c:	ff d0                	callq  *%rax
  802a5e:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802a64:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802a68:	c9                   	leaveq 
  802a69:	c3                   	retq   

0000000000802a6a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802a6a:	55                   	push   %rbp
  802a6b:	48 89 e5             	mov    %rsp,%rbp
  802a6e:	48 83 ec 18          	sub    $0x18,%rsp
  802a72:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802a76:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a7d:	eb 6b                	jmp    802aea <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802a7f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a82:	48 98                	cltq   
  802a84:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802a8a:	48 c1 e0 0c          	shl    $0xc,%rax
  802a8e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802a92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a96:	48 c1 e8 15          	shr    $0x15,%rax
  802a9a:	48 89 c2             	mov    %rax,%rdx
  802a9d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802aa4:	01 00 00 
  802aa7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802aab:	83 e0 01             	and    $0x1,%eax
  802aae:	48 85 c0             	test   %rax,%rax
  802ab1:	74 21                	je     802ad4 <fd_alloc+0x6a>
  802ab3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ab7:	48 c1 e8 0c          	shr    $0xc,%rax
  802abb:	48 89 c2             	mov    %rax,%rdx
  802abe:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802ac5:	01 00 00 
  802ac8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802acc:	83 e0 01             	and    $0x1,%eax
  802acf:	48 85 c0             	test   %rax,%rax
  802ad2:	75 12                	jne    802ae6 <fd_alloc+0x7c>
			*fd_store = fd;
  802ad4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ad8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802adc:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802adf:	b8 00 00 00 00       	mov    $0x0,%eax
  802ae4:	eb 1a                	jmp    802b00 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802ae6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802aea:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802aee:	7e 8f                	jle    802a7f <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802af0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802af4:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802afb:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802b00:	c9                   	leaveq 
  802b01:	c3                   	retq   

0000000000802b02 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802b02:	55                   	push   %rbp
  802b03:	48 89 e5             	mov    %rsp,%rbp
  802b06:	48 83 ec 20          	sub    $0x20,%rsp
  802b0a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b0d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802b11:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802b15:	78 06                	js     802b1d <fd_lookup+0x1b>
  802b17:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802b1b:	7e 07                	jle    802b24 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802b1d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b22:	eb 6c                	jmp    802b90 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802b24:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b27:	48 98                	cltq   
  802b29:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802b2f:	48 c1 e0 0c          	shl    $0xc,%rax
  802b33:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802b37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b3b:	48 c1 e8 15          	shr    $0x15,%rax
  802b3f:	48 89 c2             	mov    %rax,%rdx
  802b42:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802b49:	01 00 00 
  802b4c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b50:	83 e0 01             	and    $0x1,%eax
  802b53:	48 85 c0             	test   %rax,%rax
  802b56:	74 21                	je     802b79 <fd_lookup+0x77>
  802b58:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b5c:	48 c1 e8 0c          	shr    $0xc,%rax
  802b60:	48 89 c2             	mov    %rax,%rdx
  802b63:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b6a:	01 00 00 
  802b6d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b71:	83 e0 01             	and    $0x1,%eax
  802b74:	48 85 c0             	test   %rax,%rax
  802b77:	75 07                	jne    802b80 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802b79:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b7e:	eb 10                	jmp    802b90 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802b80:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b84:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802b88:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802b8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b90:	c9                   	leaveq 
  802b91:	c3                   	retq   

0000000000802b92 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802b92:	55                   	push   %rbp
  802b93:	48 89 e5             	mov    %rsp,%rbp
  802b96:	48 83 ec 30          	sub    $0x30,%rsp
  802b9a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802b9e:	89 f0                	mov    %esi,%eax
  802ba0:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802ba3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ba7:	48 89 c7             	mov    %rax,%rdi
  802baa:	48 b8 1c 2a 80 00 00 	movabs $0x802a1c,%rax
  802bb1:	00 00 00 
  802bb4:	ff d0                	callq  *%rax
  802bb6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802bba:	48 89 d6             	mov    %rdx,%rsi
  802bbd:	89 c7                	mov    %eax,%edi
  802bbf:	48 b8 02 2b 80 00 00 	movabs $0x802b02,%rax
  802bc6:	00 00 00 
  802bc9:	ff d0                	callq  *%rax
  802bcb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bd2:	78 0a                	js     802bde <fd_close+0x4c>
	    || fd != fd2)
  802bd4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bd8:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802bdc:	74 12                	je     802bf0 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802bde:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802be2:	74 05                	je     802be9 <fd_close+0x57>
  802be4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802be7:	eb 05                	jmp    802bee <fd_close+0x5c>
  802be9:	b8 00 00 00 00       	mov    $0x0,%eax
  802bee:	eb 69                	jmp    802c59 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802bf0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bf4:	8b 00                	mov    (%rax),%eax
  802bf6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802bfa:	48 89 d6             	mov    %rdx,%rsi
  802bfd:	89 c7                	mov    %eax,%edi
  802bff:	48 b8 5b 2c 80 00 00 	movabs $0x802c5b,%rax
  802c06:	00 00 00 
  802c09:	ff d0                	callq  *%rax
  802c0b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c0e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c12:	78 2a                	js     802c3e <fd_close+0xac>
		if (dev->dev_close)
  802c14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c18:	48 8b 40 20          	mov    0x20(%rax),%rax
  802c1c:	48 85 c0             	test   %rax,%rax
  802c1f:	74 16                	je     802c37 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802c21:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c25:	48 8b 40 20          	mov    0x20(%rax),%rax
  802c29:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802c2d:	48 89 d7             	mov    %rdx,%rdi
  802c30:	ff d0                	callq  *%rax
  802c32:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c35:	eb 07                	jmp    802c3e <fd_close+0xac>
		else
			r = 0;
  802c37:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802c3e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c42:	48 89 c6             	mov    %rax,%rsi
  802c45:	bf 00 00 00 00       	mov    $0x0,%edi
  802c4a:	48 b8 ee 1d 80 00 00 	movabs $0x801dee,%rax
  802c51:	00 00 00 
  802c54:	ff d0                	callq  *%rax
	return r;
  802c56:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c59:	c9                   	leaveq 
  802c5a:	c3                   	retq   

0000000000802c5b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802c5b:	55                   	push   %rbp
  802c5c:	48 89 e5             	mov    %rsp,%rbp
  802c5f:	48 83 ec 20          	sub    $0x20,%rsp
  802c63:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c66:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802c6a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802c71:	eb 41                	jmp    802cb4 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802c73:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802c7a:	00 00 00 
  802c7d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802c80:	48 63 d2             	movslq %edx,%rdx
  802c83:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c87:	8b 00                	mov    (%rax),%eax
  802c89:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802c8c:	75 22                	jne    802cb0 <dev_lookup+0x55>
			*dev = devtab[i];
  802c8e:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802c95:	00 00 00 
  802c98:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802c9b:	48 63 d2             	movslq %edx,%rdx
  802c9e:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802ca2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ca6:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802ca9:	b8 00 00 00 00       	mov    $0x0,%eax
  802cae:	eb 60                	jmp    802d10 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802cb0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802cb4:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802cbb:	00 00 00 
  802cbe:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802cc1:	48 63 d2             	movslq %edx,%rdx
  802cc4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802cc8:	48 85 c0             	test   %rax,%rax
  802ccb:	75 a6                	jne    802c73 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802ccd:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802cd4:	00 00 00 
  802cd7:	48 8b 00             	mov    (%rax),%rax
  802cda:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ce0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802ce3:	89 c6                	mov    %eax,%esi
  802ce5:	48 bf f0 4d 80 00 00 	movabs $0x804df0,%rdi
  802cec:	00 00 00 
  802cef:	b8 00 00 00 00       	mov    $0x0,%eax
  802cf4:	48 b9 1e 08 80 00 00 	movabs $0x80081e,%rcx
  802cfb:	00 00 00 
  802cfe:	ff d1                	callq  *%rcx
	*dev = 0;
  802d00:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d04:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802d0b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802d10:	c9                   	leaveq 
  802d11:	c3                   	retq   

0000000000802d12 <close>:

int
close(int fdnum)
{
  802d12:	55                   	push   %rbp
  802d13:	48 89 e5             	mov    %rsp,%rbp
  802d16:	48 83 ec 20          	sub    $0x20,%rsp
  802d1a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802d1d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d21:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d24:	48 89 d6             	mov    %rdx,%rsi
  802d27:	89 c7                	mov    %eax,%edi
  802d29:	48 b8 02 2b 80 00 00 	movabs $0x802b02,%rax
  802d30:	00 00 00 
  802d33:	ff d0                	callq  *%rax
  802d35:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d38:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d3c:	79 05                	jns    802d43 <close+0x31>
		return r;
  802d3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d41:	eb 18                	jmp    802d5b <close+0x49>
	else
		return fd_close(fd, 1);
  802d43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d47:	be 01 00 00 00       	mov    $0x1,%esi
  802d4c:	48 89 c7             	mov    %rax,%rdi
  802d4f:	48 b8 92 2b 80 00 00 	movabs $0x802b92,%rax
  802d56:	00 00 00 
  802d59:	ff d0                	callq  *%rax
}
  802d5b:	c9                   	leaveq 
  802d5c:	c3                   	retq   

0000000000802d5d <close_all>:

void
close_all(void)
{
  802d5d:	55                   	push   %rbp
  802d5e:	48 89 e5             	mov    %rsp,%rbp
  802d61:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802d65:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802d6c:	eb 15                	jmp    802d83 <close_all+0x26>
		close(i);
  802d6e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d71:	89 c7                	mov    %eax,%edi
  802d73:	48 b8 12 2d 80 00 00 	movabs $0x802d12,%rax
  802d7a:	00 00 00 
  802d7d:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802d7f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802d83:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802d87:	7e e5                	jle    802d6e <close_all+0x11>
		close(i);
}
  802d89:	c9                   	leaveq 
  802d8a:	c3                   	retq   

0000000000802d8b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802d8b:	55                   	push   %rbp
  802d8c:	48 89 e5             	mov    %rsp,%rbp
  802d8f:	48 83 ec 40          	sub    $0x40,%rsp
  802d93:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802d96:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802d99:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802d9d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802da0:	48 89 d6             	mov    %rdx,%rsi
  802da3:	89 c7                	mov    %eax,%edi
  802da5:	48 b8 02 2b 80 00 00 	movabs $0x802b02,%rax
  802dac:	00 00 00 
  802daf:	ff d0                	callq  *%rax
  802db1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802db4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802db8:	79 08                	jns    802dc2 <dup+0x37>
		return r;
  802dba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dbd:	e9 70 01 00 00       	jmpq   802f32 <dup+0x1a7>
	close(newfdnum);
  802dc2:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802dc5:	89 c7                	mov    %eax,%edi
  802dc7:	48 b8 12 2d 80 00 00 	movabs $0x802d12,%rax
  802dce:	00 00 00 
  802dd1:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802dd3:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802dd6:	48 98                	cltq   
  802dd8:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802dde:	48 c1 e0 0c          	shl    $0xc,%rax
  802de2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802de6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802dea:	48 89 c7             	mov    %rax,%rdi
  802ded:	48 b8 3f 2a 80 00 00 	movabs $0x802a3f,%rax
  802df4:	00 00 00 
  802df7:	ff d0                	callq  *%rax
  802df9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802dfd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e01:	48 89 c7             	mov    %rax,%rdi
  802e04:	48 b8 3f 2a 80 00 00 	movabs $0x802a3f,%rax
  802e0b:	00 00 00 
  802e0e:	ff d0                	callq  *%rax
  802e10:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802e14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e18:	48 c1 e8 15          	shr    $0x15,%rax
  802e1c:	48 89 c2             	mov    %rax,%rdx
  802e1f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802e26:	01 00 00 
  802e29:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e2d:	83 e0 01             	and    $0x1,%eax
  802e30:	48 85 c0             	test   %rax,%rax
  802e33:	74 73                	je     802ea8 <dup+0x11d>
  802e35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e39:	48 c1 e8 0c          	shr    $0xc,%rax
  802e3d:	48 89 c2             	mov    %rax,%rdx
  802e40:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802e47:	01 00 00 
  802e4a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e4e:	83 e0 01             	and    $0x1,%eax
  802e51:	48 85 c0             	test   %rax,%rax
  802e54:	74 52                	je     802ea8 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802e56:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e5a:	48 c1 e8 0c          	shr    $0xc,%rax
  802e5e:	48 89 c2             	mov    %rax,%rdx
  802e61:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802e68:	01 00 00 
  802e6b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e6f:	25 07 0e 00 00       	and    $0xe07,%eax
  802e74:	89 c1                	mov    %eax,%ecx
  802e76:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802e7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e7e:	41 89 c8             	mov    %ecx,%r8d
  802e81:	48 89 d1             	mov    %rdx,%rcx
  802e84:	ba 00 00 00 00       	mov    $0x0,%edx
  802e89:	48 89 c6             	mov    %rax,%rsi
  802e8c:	bf 00 00 00 00       	mov    $0x0,%edi
  802e91:	48 b8 93 1d 80 00 00 	movabs $0x801d93,%rax
  802e98:	00 00 00 
  802e9b:	ff d0                	callq  *%rax
  802e9d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ea0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ea4:	79 02                	jns    802ea8 <dup+0x11d>
			goto err;
  802ea6:	eb 57                	jmp    802eff <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802ea8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802eac:	48 c1 e8 0c          	shr    $0xc,%rax
  802eb0:	48 89 c2             	mov    %rax,%rdx
  802eb3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802eba:	01 00 00 
  802ebd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ec1:	25 07 0e 00 00       	and    $0xe07,%eax
  802ec6:	89 c1                	mov    %eax,%ecx
  802ec8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ecc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ed0:	41 89 c8             	mov    %ecx,%r8d
  802ed3:	48 89 d1             	mov    %rdx,%rcx
  802ed6:	ba 00 00 00 00       	mov    $0x0,%edx
  802edb:	48 89 c6             	mov    %rax,%rsi
  802ede:	bf 00 00 00 00       	mov    $0x0,%edi
  802ee3:	48 b8 93 1d 80 00 00 	movabs $0x801d93,%rax
  802eea:	00 00 00 
  802eed:	ff d0                	callq  *%rax
  802eef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ef2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ef6:	79 02                	jns    802efa <dup+0x16f>
		goto err;
  802ef8:	eb 05                	jmp    802eff <dup+0x174>

	return newfdnum;
  802efa:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802efd:	eb 33                	jmp    802f32 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802eff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f03:	48 89 c6             	mov    %rax,%rsi
  802f06:	bf 00 00 00 00       	mov    $0x0,%edi
  802f0b:	48 b8 ee 1d 80 00 00 	movabs $0x801dee,%rax
  802f12:	00 00 00 
  802f15:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802f17:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f1b:	48 89 c6             	mov    %rax,%rsi
  802f1e:	bf 00 00 00 00       	mov    $0x0,%edi
  802f23:	48 b8 ee 1d 80 00 00 	movabs $0x801dee,%rax
  802f2a:	00 00 00 
  802f2d:	ff d0                	callq  *%rax
	return r;
  802f2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802f32:	c9                   	leaveq 
  802f33:	c3                   	retq   

0000000000802f34 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802f34:	55                   	push   %rbp
  802f35:	48 89 e5             	mov    %rsp,%rbp
  802f38:	48 83 ec 40          	sub    $0x40,%rsp
  802f3c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802f3f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802f43:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802f47:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802f4b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f4e:	48 89 d6             	mov    %rdx,%rsi
  802f51:	89 c7                	mov    %eax,%edi
  802f53:	48 b8 02 2b 80 00 00 	movabs $0x802b02,%rax
  802f5a:	00 00 00 
  802f5d:	ff d0                	callq  *%rax
  802f5f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f62:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f66:	78 24                	js     802f8c <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f6c:	8b 00                	mov    (%rax),%eax
  802f6e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f72:	48 89 d6             	mov    %rdx,%rsi
  802f75:	89 c7                	mov    %eax,%edi
  802f77:	48 b8 5b 2c 80 00 00 	movabs $0x802c5b,%rax
  802f7e:	00 00 00 
  802f81:	ff d0                	callq  *%rax
  802f83:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f86:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f8a:	79 05                	jns    802f91 <read+0x5d>
		return r;
  802f8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f8f:	eb 76                	jmp    803007 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802f91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f95:	8b 40 08             	mov    0x8(%rax),%eax
  802f98:	83 e0 03             	and    $0x3,%eax
  802f9b:	83 f8 01             	cmp    $0x1,%eax
  802f9e:	75 3a                	jne    802fda <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802fa0:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802fa7:	00 00 00 
  802faa:	48 8b 00             	mov    (%rax),%rax
  802fad:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802fb3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802fb6:	89 c6                	mov    %eax,%esi
  802fb8:	48 bf 0f 4e 80 00 00 	movabs $0x804e0f,%rdi
  802fbf:	00 00 00 
  802fc2:	b8 00 00 00 00       	mov    $0x0,%eax
  802fc7:	48 b9 1e 08 80 00 00 	movabs $0x80081e,%rcx
  802fce:	00 00 00 
  802fd1:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802fd3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802fd8:	eb 2d                	jmp    803007 <read+0xd3>
	}
	if (!dev->dev_read)
  802fda:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fde:	48 8b 40 10          	mov    0x10(%rax),%rax
  802fe2:	48 85 c0             	test   %rax,%rax
  802fe5:	75 07                	jne    802fee <read+0xba>
		return -E_NOT_SUPP;
  802fe7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802fec:	eb 19                	jmp    803007 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802fee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ff2:	48 8b 40 10          	mov    0x10(%rax),%rax
  802ff6:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802ffa:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802ffe:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803002:	48 89 cf             	mov    %rcx,%rdi
  803005:	ff d0                	callq  *%rax
}
  803007:	c9                   	leaveq 
  803008:	c3                   	retq   

0000000000803009 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  803009:	55                   	push   %rbp
  80300a:	48 89 e5             	mov    %rsp,%rbp
  80300d:	48 83 ec 30          	sub    $0x30,%rsp
  803011:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803014:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803018:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80301c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803023:	eb 49                	jmp    80306e <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  803025:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803028:	48 98                	cltq   
  80302a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80302e:	48 29 c2             	sub    %rax,%rdx
  803031:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803034:	48 63 c8             	movslq %eax,%rcx
  803037:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80303b:	48 01 c1             	add    %rax,%rcx
  80303e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803041:	48 89 ce             	mov    %rcx,%rsi
  803044:	89 c7                	mov    %eax,%edi
  803046:	48 b8 34 2f 80 00 00 	movabs $0x802f34,%rax
  80304d:	00 00 00 
  803050:	ff d0                	callq  *%rax
  803052:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  803055:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803059:	79 05                	jns    803060 <readn+0x57>
			return m;
  80305b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80305e:	eb 1c                	jmp    80307c <readn+0x73>
		if (m == 0)
  803060:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803064:	75 02                	jne    803068 <readn+0x5f>
			break;
  803066:	eb 11                	jmp    803079 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803068:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80306b:	01 45 fc             	add    %eax,-0x4(%rbp)
  80306e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803071:	48 98                	cltq   
  803073:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803077:	72 ac                	jb     803025 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  803079:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80307c:	c9                   	leaveq 
  80307d:	c3                   	retq   

000000000080307e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80307e:	55                   	push   %rbp
  80307f:	48 89 e5             	mov    %rsp,%rbp
  803082:	48 83 ec 40          	sub    $0x40,%rsp
  803086:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803089:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80308d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803091:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803095:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803098:	48 89 d6             	mov    %rdx,%rsi
  80309b:	89 c7                	mov    %eax,%edi
  80309d:	48 b8 02 2b 80 00 00 	movabs $0x802b02,%rax
  8030a4:	00 00 00 
  8030a7:	ff d0                	callq  *%rax
  8030a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030b0:	78 24                	js     8030d6 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8030b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030b6:	8b 00                	mov    (%rax),%eax
  8030b8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8030bc:	48 89 d6             	mov    %rdx,%rsi
  8030bf:	89 c7                	mov    %eax,%edi
  8030c1:	48 b8 5b 2c 80 00 00 	movabs $0x802c5b,%rax
  8030c8:	00 00 00 
  8030cb:	ff d0                	callq  *%rax
  8030cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030d4:	79 05                	jns    8030db <write+0x5d>
		return r;
  8030d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030d9:	eb 75                	jmp    803150 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8030db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030df:	8b 40 08             	mov    0x8(%rax),%eax
  8030e2:	83 e0 03             	and    $0x3,%eax
  8030e5:	85 c0                	test   %eax,%eax
  8030e7:	75 3a                	jne    803123 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8030e9:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8030f0:	00 00 00 
  8030f3:	48 8b 00             	mov    (%rax),%rax
  8030f6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8030fc:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8030ff:	89 c6                	mov    %eax,%esi
  803101:	48 bf 2b 4e 80 00 00 	movabs $0x804e2b,%rdi
  803108:	00 00 00 
  80310b:	b8 00 00 00 00       	mov    $0x0,%eax
  803110:	48 b9 1e 08 80 00 00 	movabs $0x80081e,%rcx
  803117:	00 00 00 
  80311a:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80311c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803121:	eb 2d                	jmp    803150 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  803123:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803127:	48 8b 40 18          	mov    0x18(%rax),%rax
  80312b:	48 85 c0             	test   %rax,%rax
  80312e:	75 07                	jne    803137 <write+0xb9>
		return -E_NOT_SUPP;
  803130:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803135:	eb 19                	jmp    803150 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  803137:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80313b:	48 8b 40 18          	mov    0x18(%rax),%rax
  80313f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803143:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803147:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80314b:	48 89 cf             	mov    %rcx,%rdi
  80314e:	ff d0                	callq  *%rax
}
  803150:	c9                   	leaveq 
  803151:	c3                   	retq   

0000000000803152 <seek>:

int
seek(int fdnum, off_t offset)
{
  803152:	55                   	push   %rbp
  803153:	48 89 e5             	mov    %rsp,%rbp
  803156:	48 83 ec 18          	sub    $0x18,%rsp
  80315a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80315d:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803160:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803164:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803167:	48 89 d6             	mov    %rdx,%rsi
  80316a:	89 c7                	mov    %eax,%edi
  80316c:	48 b8 02 2b 80 00 00 	movabs $0x802b02,%rax
  803173:	00 00 00 
  803176:	ff d0                	callq  *%rax
  803178:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80317b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80317f:	79 05                	jns    803186 <seek+0x34>
		return r;
  803181:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803184:	eb 0f                	jmp    803195 <seek+0x43>
	fd->fd_offset = offset;
  803186:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80318a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80318d:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  803190:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803195:	c9                   	leaveq 
  803196:	c3                   	retq   

0000000000803197 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  803197:	55                   	push   %rbp
  803198:	48 89 e5             	mov    %rsp,%rbp
  80319b:	48 83 ec 30          	sub    $0x30,%rsp
  80319f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8031a2:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8031a5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8031a9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8031ac:	48 89 d6             	mov    %rdx,%rsi
  8031af:	89 c7                	mov    %eax,%edi
  8031b1:	48 b8 02 2b 80 00 00 	movabs $0x802b02,%rax
  8031b8:	00 00 00 
  8031bb:	ff d0                	callq  *%rax
  8031bd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031c4:	78 24                	js     8031ea <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8031c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031ca:	8b 00                	mov    (%rax),%eax
  8031cc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8031d0:	48 89 d6             	mov    %rdx,%rsi
  8031d3:	89 c7                	mov    %eax,%edi
  8031d5:	48 b8 5b 2c 80 00 00 	movabs $0x802c5b,%rax
  8031dc:	00 00 00 
  8031df:	ff d0                	callq  *%rax
  8031e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031e8:	79 05                	jns    8031ef <ftruncate+0x58>
		return r;
  8031ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031ed:	eb 72                	jmp    803261 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8031ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031f3:	8b 40 08             	mov    0x8(%rax),%eax
  8031f6:	83 e0 03             	and    $0x3,%eax
  8031f9:	85 c0                	test   %eax,%eax
  8031fb:	75 3a                	jne    803237 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8031fd:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803204:	00 00 00 
  803207:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80320a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803210:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803213:	89 c6                	mov    %eax,%esi
  803215:	48 bf 48 4e 80 00 00 	movabs $0x804e48,%rdi
  80321c:	00 00 00 
  80321f:	b8 00 00 00 00       	mov    $0x0,%eax
  803224:	48 b9 1e 08 80 00 00 	movabs $0x80081e,%rcx
  80322b:	00 00 00 
  80322e:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  803230:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803235:	eb 2a                	jmp    803261 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  803237:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80323b:	48 8b 40 30          	mov    0x30(%rax),%rax
  80323f:	48 85 c0             	test   %rax,%rax
  803242:	75 07                	jne    80324b <ftruncate+0xb4>
		return -E_NOT_SUPP;
  803244:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803249:	eb 16                	jmp    803261 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80324b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80324f:	48 8b 40 30          	mov    0x30(%rax),%rax
  803253:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803257:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80325a:	89 ce                	mov    %ecx,%esi
  80325c:	48 89 d7             	mov    %rdx,%rdi
  80325f:	ff d0                	callq  *%rax
}
  803261:	c9                   	leaveq 
  803262:	c3                   	retq   

0000000000803263 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  803263:	55                   	push   %rbp
  803264:	48 89 e5             	mov    %rsp,%rbp
  803267:	48 83 ec 30          	sub    $0x30,%rsp
  80326b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80326e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803272:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803276:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803279:	48 89 d6             	mov    %rdx,%rsi
  80327c:	89 c7                	mov    %eax,%edi
  80327e:	48 b8 02 2b 80 00 00 	movabs $0x802b02,%rax
  803285:	00 00 00 
  803288:	ff d0                	callq  *%rax
  80328a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80328d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803291:	78 24                	js     8032b7 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803293:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803297:	8b 00                	mov    (%rax),%eax
  803299:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80329d:	48 89 d6             	mov    %rdx,%rsi
  8032a0:	89 c7                	mov    %eax,%edi
  8032a2:	48 b8 5b 2c 80 00 00 	movabs $0x802c5b,%rax
  8032a9:	00 00 00 
  8032ac:	ff d0                	callq  *%rax
  8032ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032b5:	79 05                	jns    8032bc <fstat+0x59>
		return r;
  8032b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032ba:	eb 5e                	jmp    80331a <fstat+0xb7>
	if (!dev->dev_stat)
  8032bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032c0:	48 8b 40 28          	mov    0x28(%rax),%rax
  8032c4:	48 85 c0             	test   %rax,%rax
  8032c7:	75 07                	jne    8032d0 <fstat+0x6d>
		return -E_NOT_SUPP;
  8032c9:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8032ce:	eb 4a                	jmp    80331a <fstat+0xb7>
	stat->st_name[0] = 0;
  8032d0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032d4:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8032d7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032db:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8032e2:	00 00 00 
	stat->st_isdir = 0;
  8032e5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032e9:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8032f0:	00 00 00 
	stat->st_dev = dev;
  8032f3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8032f7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032fb:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  803302:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803306:	48 8b 40 28          	mov    0x28(%rax),%rax
  80330a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80330e:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803312:	48 89 ce             	mov    %rcx,%rsi
  803315:	48 89 d7             	mov    %rdx,%rdi
  803318:	ff d0                	callq  *%rax
}
  80331a:	c9                   	leaveq 
  80331b:	c3                   	retq   

000000000080331c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80331c:	55                   	push   %rbp
  80331d:	48 89 e5             	mov    %rsp,%rbp
  803320:	48 83 ec 20          	sub    $0x20,%rsp
  803324:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803328:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80332c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803330:	be 00 00 00 00       	mov    $0x0,%esi
  803335:	48 89 c7             	mov    %rax,%rdi
  803338:	48 b8 0a 34 80 00 00 	movabs $0x80340a,%rax
  80333f:	00 00 00 
  803342:	ff d0                	callq  *%rax
  803344:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803347:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80334b:	79 05                	jns    803352 <stat+0x36>
		return fd;
  80334d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803350:	eb 2f                	jmp    803381 <stat+0x65>
	r = fstat(fd, stat);
  803352:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803356:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803359:	48 89 d6             	mov    %rdx,%rsi
  80335c:	89 c7                	mov    %eax,%edi
  80335e:	48 b8 63 32 80 00 00 	movabs $0x803263,%rax
  803365:	00 00 00 
  803368:	ff d0                	callq  *%rax
  80336a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80336d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803370:	89 c7                	mov    %eax,%edi
  803372:	48 b8 12 2d 80 00 00 	movabs $0x802d12,%rax
  803379:	00 00 00 
  80337c:	ff d0                	callq  *%rax
	return r;
  80337e:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  803381:	c9                   	leaveq 
  803382:	c3                   	retq   

0000000000803383 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  803383:	55                   	push   %rbp
  803384:	48 89 e5             	mov    %rsp,%rbp
  803387:	48 83 ec 10          	sub    $0x10,%rsp
  80338b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80338e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  803392:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  803399:	00 00 00 
  80339c:	8b 00                	mov    (%rax),%eax
  80339e:	85 c0                	test   %eax,%eax
  8033a0:	75 1d                	jne    8033bf <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8033a2:	bf 01 00 00 00       	mov    $0x1,%edi
  8033a7:	48 b8 5e 45 80 00 00 	movabs $0x80455e,%rax
  8033ae:	00 00 00 
  8033b1:	ff d0                	callq  *%rax
  8033b3:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8033ba:	00 00 00 
  8033bd:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8033bf:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8033c6:	00 00 00 
  8033c9:	8b 00                	mov    (%rax),%eax
  8033cb:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8033ce:	b9 07 00 00 00       	mov    $0x7,%ecx
  8033d3:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8033da:	00 00 00 
  8033dd:	89 c7                	mov    %eax,%edi
  8033df:	48 b8 5f 44 80 00 00 	movabs $0x80445f,%rax
  8033e6:	00 00 00 
  8033e9:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8033eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8033f4:	48 89 c6             	mov    %rax,%rsi
  8033f7:	bf 00 00 00 00       	mov    $0x0,%edi
  8033fc:	48 b8 ac 43 80 00 00 	movabs $0x8043ac,%rax
  803403:	00 00 00 
  803406:	ff d0                	callq  *%rax
}
  803408:	c9                   	leaveq 
  803409:	c3                   	retq   

000000000080340a <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80340a:	55                   	push   %rbp
  80340b:	48 89 e5             	mov    %rsp,%rbp
  80340e:	48 83 ec 20          	sub    $0x20,%rsp
  803412:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803416:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here

	struct Fd *fd;
	int ret;
	if (strlen(path)>=MAXPATHLEN)
  803419:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80341d:	48 89 c7             	mov    %rax,%rdi
  803420:	48 b8 a8 13 80 00 00 	movabs $0x8013a8,%rax
  803427:	00 00 00 
  80342a:	ff d0                	callq  *%rax
  80342c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803431:	7e 0a                	jle    80343d <open+0x33>
		return -E_BAD_PATH;
  803433:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803438:	e9 a5 00 00 00       	jmpq   8034e2 <open+0xd8>
	if ((ret=fd_alloc(&fd))<0)
  80343d:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803441:	48 89 c7             	mov    %rax,%rdi
  803444:	48 b8 6a 2a 80 00 00 	movabs $0x802a6a,%rax
  80344b:	00 00 00 
  80344e:	ff d0                	callq  *%rax
  803450:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803453:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803457:	79 08                	jns    803461 <open+0x57>
		return ret;
  803459:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80345c:	e9 81 00 00 00       	jmpq   8034e2 <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  803461:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803468:	00 00 00 
  80346b:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80346e:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy (fsipcbuf.open.req_path, path);
  803474:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803478:	48 89 c6             	mov    %rax,%rsi
  80347b:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  803482:	00 00 00 
  803485:	48 b8 14 14 80 00 00 	movabs $0x801414,%rax
  80348c:	00 00 00 
  80348f:	ff d0                	callq  *%rax
	if ((ret=fsipc (FSREQ_OPEN, (void *) fd)) < 0)
  803491:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803495:	48 89 c6             	mov    %rax,%rsi
  803498:	bf 01 00 00 00       	mov    $0x1,%edi
  80349d:	48 b8 83 33 80 00 00 	movabs $0x803383,%rax
  8034a4:	00 00 00 
  8034a7:	ff d0                	callq  *%rax
  8034a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034b0:	79 1d                	jns    8034cf <open+0xc5>
	{
		fd_close(fd,0);
  8034b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034b6:	be 00 00 00 00       	mov    $0x0,%esi
  8034bb:	48 89 c7             	mov    %rax,%rdi
  8034be:	48 b8 92 2b 80 00 00 	movabs $0x802b92,%rax
  8034c5:	00 00 00 
  8034c8:	ff d0                	callq  *%rax
		return ret;
  8034ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034cd:	eb 13                	jmp    8034e2 <open+0xd8>
	}
	return fd2num (fd);
  8034cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034d3:	48 89 c7             	mov    %rax,%rdi
  8034d6:	48 b8 1c 2a 80 00 00 	movabs $0x802a1c,%rax
  8034dd:	00 00 00 
  8034e0:	ff d0                	callq  *%rax
	panic ("open not implemented");
}
  8034e2:	c9                   	leaveq 
  8034e3:	c3                   	retq   

00000000008034e4 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8034e4:	55                   	push   %rbp
  8034e5:	48 89 e5             	mov    %rsp,%rbp
  8034e8:	48 83 ec 10          	sub    $0x10,%rsp
  8034ec:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8034f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034f4:	8b 50 0c             	mov    0xc(%rax),%edx
  8034f7:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8034fe:	00 00 00 
  803501:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  803503:	be 00 00 00 00       	mov    $0x0,%esi
  803508:	bf 06 00 00 00       	mov    $0x6,%edi
  80350d:	48 b8 83 33 80 00 00 	movabs $0x803383,%rax
  803514:	00 00 00 
  803517:	ff d0                	callq  *%rax
}
  803519:	c9                   	leaveq 
  80351a:	c3                   	retq   

000000000080351b <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80351b:	55                   	push   %rbp
  80351c:	48 89 e5             	mov    %rsp,%rbp
  80351f:	48 83 ec 30          	sub    $0x30,%rsp
  803523:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803527:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80352b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int ret;
	fsipcbuf.read.req_fileid=fd->fd_file.id;
  80352f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803533:	8b 50 0c             	mov    0xc(%rax),%edx
  803536:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80353d:	00 00 00 
  803540:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n=n;
  803542:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803549:	00 00 00 
  80354c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803550:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	if ((ret=fsipc(FSREQ_READ,NULL))<0)
  803554:	be 00 00 00 00       	mov    $0x0,%esi
  803559:	bf 03 00 00 00       	mov    $0x3,%edi
  80355e:	48 b8 83 33 80 00 00 	movabs $0x803383,%rax
  803565:	00 00 00 
  803568:	ff d0                	callq  *%rax
  80356a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80356d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803571:	79 05                	jns    803578 <devfile_read+0x5d>
		return ret;
  803573:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803576:	eb 26                	jmp    80359e <devfile_read+0x83>
	memmove (buf, fsipcbuf.readRet.ret_buf, ret);
  803578:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80357b:	48 63 d0             	movslq %eax,%rdx
  80357e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803582:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803589:	00 00 00 
  80358c:	48 89 c7             	mov    %rax,%rdi
  80358f:	48 b8 38 17 80 00 00 	movabs $0x801738,%rax
  803596:	00 00 00 
  803599:	ff d0                	callq  *%rax
	return ret;
  80359b:	8b 45 fc             	mov    -0x4(%rbp),%eax
	panic("devfile_read not implemented");
}
  80359e:	c9                   	leaveq 
  80359f:	c3                   	retq   

00000000008035a0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8035a0:	55                   	push   %rbp
  8035a1:	48 89 e5             	mov    %rsp,%rbp
  8035a4:	48 83 ec 30          	sub    $0x30,%rsp
  8035a8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8035ac:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8035b0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here

	int ret;
	fsipcbuf.write.req_fileid=fd->fd_file.id;
  8035b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035b8:	8b 50 0c             	mov    0xc(%rax),%edx
  8035bb:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8035c2:	00 00 00 
  8035c5:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n=n>sizeof(fsipcbuf.write.req_buf)?sizeof(fsipcbuf.write.req_buf):n;
  8035c7:	b8 f4 0f 00 00       	mov    $0xff4,%eax
  8035cc:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8035d3:	00 
  8035d4:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  8035d9:	48 89 c2             	mov    %rax,%rdx
  8035dc:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8035e3:	00 00 00 
  8035e6:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove (fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  8035ea:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8035f1:	00 00 00 
  8035f4:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8035f8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035fc:	48 89 c6             	mov    %rax,%rsi
  8035ff:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  803606:	00 00 00 
  803609:	48 b8 38 17 80 00 00 	movabs $0x801738,%rax
  803610:	00 00 00 
  803613:	ff d0                	callq  *%rax
	if ((ret=fsipc(FSREQ_WRITE,NULL))<0)
  803615:	be 00 00 00 00       	mov    $0x0,%esi
  80361a:	bf 04 00 00 00       	mov    $0x4,%edi
  80361f:	48 b8 83 33 80 00 00 	movabs $0x803383,%rax
  803626:	00 00 00 
  803629:	ff d0                	callq  *%rax
  80362b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80362e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803632:	79 05                	jns    803639 <devfile_write+0x99>
		return ret;
  803634:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803637:	eb 03                	jmp    80363c <devfile_write+0x9c>
	
	return ret;
  803639:	8b 45 fc             	mov    -0x4(%rbp),%eax


	panic("devfile_write not implemented");
}
  80363c:	c9                   	leaveq 
  80363d:	c3                   	retq   

000000000080363e <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80363e:	55                   	push   %rbp
  80363f:	48 89 e5             	mov    %rsp,%rbp
  803642:	48 83 ec 20          	sub    $0x20,%rsp
  803646:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80364a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80364e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803652:	8b 50 0c             	mov    0xc(%rax),%edx
  803655:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80365c:	00 00 00 
  80365f:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803661:	be 00 00 00 00       	mov    $0x0,%esi
  803666:	bf 05 00 00 00       	mov    $0x5,%edi
  80366b:	48 b8 83 33 80 00 00 	movabs $0x803383,%rax
  803672:	00 00 00 
  803675:	ff d0                	callq  *%rax
  803677:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80367a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80367e:	79 05                	jns    803685 <devfile_stat+0x47>
		return r;
  803680:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803683:	eb 56                	jmp    8036db <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803685:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803689:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  803690:	00 00 00 
  803693:	48 89 c7             	mov    %rax,%rdi
  803696:	48 b8 14 14 80 00 00 	movabs $0x801414,%rax
  80369d:	00 00 00 
  8036a0:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8036a2:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8036a9:	00 00 00 
  8036ac:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8036b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036b6:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8036bc:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8036c3:	00 00 00 
  8036c6:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8036cc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036d0:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8036d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8036db:	c9                   	leaveq 
  8036dc:	c3                   	retq   

00000000008036dd <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8036dd:	55                   	push   %rbp
  8036de:	48 89 e5             	mov    %rsp,%rbp
  8036e1:	48 83 ec 10          	sub    $0x10,%rsp
  8036e5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8036e9:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8036ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036f0:	8b 50 0c             	mov    0xc(%rax),%edx
  8036f3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8036fa:	00 00 00 
  8036fd:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8036ff:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803706:	00 00 00 
  803709:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80370c:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80370f:	be 00 00 00 00       	mov    $0x0,%esi
  803714:	bf 02 00 00 00       	mov    $0x2,%edi
  803719:	48 b8 83 33 80 00 00 	movabs $0x803383,%rax
  803720:	00 00 00 
  803723:	ff d0                	callq  *%rax
}
  803725:	c9                   	leaveq 
  803726:	c3                   	retq   

0000000000803727 <remove>:

// Delete a file
int
remove(const char *path)
{
  803727:	55                   	push   %rbp
  803728:	48 89 e5             	mov    %rsp,%rbp
  80372b:	48 83 ec 10          	sub    $0x10,%rsp
  80372f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803733:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803737:	48 89 c7             	mov    %rax,%rdi
  80373a:	48 b8 a8 13 80 00 00 	movabs $0x8013a8,%rax
  803741:	00 00 00 
  803744:	ff d0                	callq  *%rax
  803746:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80374b:	7e 07                	jle    803754 <remove+0x2d>
		return -E_BAD_PATH;
  80374d:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803752:	eb 33                	jmp    803787 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803754:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803758:	48 89 c6             	mov    %rax,%rsi
  80375b:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  803762:	00 00 00 
  803765:	48 b8 14 14 80 00 00 	movabs $0x801414,%rax
  80376c:	00 00 00 
  80376f:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803771:	be 00 00 00 00       	mov    $0x0,%esi
  803776:	bf 07 00 00 00       	mov    $0x7,%edi
  80377b:	48 b8 83 33 80 00 00 	movabs $0x803383,%rax
  803782:	00 00 00 
  803785:	ff d0                	callq  *%rax
}
  803787:	c9                   	leaveq 
  803788:	c3                   	retq   

0000000000803789 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803789:	55                   	push   %rbp
  80378a:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80378d:	be 00 00 00 00       	mov    $0x0,%esi
  803792:	bf 08 00 00 00       	mov    $0x8,%edi
  803797:	48 b8 83 33 80 00 00 	movabs $0x803383,%rax
  80379e:	00 00 00 
  8037a1:	ff d0                	callq  *%rax
}
  8037a3:	5d                   	pop    %rbp
  8037a4:	c3                   	retq   

00000000008037a5 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8037a5:	55                   	push   %rbp
  8037a6:	48 89 e5             	mov    %rsp,%rbp
  8037a9:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8037b0:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8037b7:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8037be:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8037c5:	be 00 00 00 00       	mov    $0x0,%esi
  8037ca:	48 89 c7             	mov    %rax,%rdi
  8037cd:	48 b8 0a 34 80 00 00 	movabs $0x80340a,%rax
  8037d4:	00 00 00 
  8037d7:	ff d0                	callq  *%rax
  8037d9:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8037dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037e0:	79 28                	jns    80380a <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8037e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037e5:	89 c6                	mov    %eax,%esi
  8037e7:	48 bf 6e 4e 80 00 00 	movabs $0x804e6e,%rdi
  8037ee:	00 00 00 
  8037f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8037f6:	48 ba 1e 08 80 00 00 	movabs $0x80081e,%rdx
  8037fd:	00 00 00 
  803800:	ff d2                	callq  *%rdx
		return fd_src;
  803802:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803805:	e9 74 01 00 00       	jmpq   80397e <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80380a:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803811:	be 01 01 00 00       	mov    $0x101,%esi
  803816:	48 89 c7             	mov    %rax,%rdi
  803819:	48 b8 0a 34 80 00 00 	movabs $0x80340a,%rax
  803820:	00 00 00 
  803823:	ff d0                	callq  *%rax
  803825:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803828:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80382c:	79 39                	jns    803867 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  80382e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803831:	89 c6                	mov    %eax,%esi
  803833:	48 bf 84 4e 80 00 00 	movabs $0x804e84,%rdi
  80383a:	00 00 00 
  80383d:	b8 00 00 00 00       	mov    $0x0,%eax
  803842:	48 ba 1e 08 80 00 00 	movabs $0x80081e,%rdx
  803849:	00 00 00 
  80384c:	ff d2                	callq  *%rdx
		close(fd_src);
  80384e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803851:	89 c7                	mov    %eax,%edi
  803853:	48 b8 12 2d 80 00 00 	movabs $0x802d12,%rax
  80385a:	00 00 00 
  80385d:	ff d0                	callq  *%rax
		return fd_dest;
  80385f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803862:	e9 17 01 00 00       	jmpq   80397e <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803867:	eb 74                	jmp    8038dd <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  803869:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80386c:	48 63 d0             	movslq %eax,%rdx
  80386f:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803876:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803879:	48 89 ce             	mov    %rcx,%rsi
  80387c:	89 c7                	mov    %eax,%edi
  80387e:	48 b8 7e 30 80 00 00 	movabs $0x80307e,%rax
  803885:	00 00 00 
  803888:	ff d0                	callq  *%rax
  80388a:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  80388d:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803891:	79 4a                	jns    8038dd <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  803893:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803896:	89 c6                	mov    %eax,%esi
  803898:	48 bf 9e 4e 80 00 00 	movabs $0x804e9e,%rdi
  80389f:	00 00 00 
  8038a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8038a7:	48 ba 1e 08 80 00 00 	movabs $0x80081e,%rdx
  8038ae:	00 00 00 
  8038b1:	ff d2                	callq  *%rdx
			close(fd_src);
  8038b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038b6:	89 c7                	mov    %eax,%edi
  8038b8:	48 b8 12 2d 80 00 00 	movabs $0x802d12,%rax
  8038bf:	00 00 00 
  8038c2:	ff d0                	callq  *%rax
			close(fd_dest);
  8038c4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038c7:	89 c7                	mov    %eax,%edi
  8038c9:	48 b8 12 2d 80 00 00 	movabs $0x802d12,%rax
  8038d0:	00 00 00 
  8038d3:	ff d0                	callq  *%rax
			return write_size;
  8038d5:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8038d8:	e9 a1 00 00 00       	jmpq   80397e <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8038dd:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8038e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038e7:	ba 00 02 00 00       	mov    $0x200,%edx
  8038ec:	48 89 ce             	mov    %rcx,%rsi
  8038ef:	89 c7                	mov    %eax,%edi
  8038f1:	48 b8 34 2f 80 00 00 	movabs $0x802f34,%rax
  8038f8:	00 00 00 
  8038fb:	ff d0                	callq  *%rax
  8038fd:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803900:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803904:	0f 8f 5f ff ff ff    	jg     803869 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  80390a:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80390e:	79 47                	jns    803957 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803910:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803913:	89 c6                	mov    %eax,%esi
  803915:	48 bf b1 4e 80 00 00 	movabs $0x804eb1,%rdi
  80391c:	00 00 00 
  80391f:	b8 00 00 00 00       	mov    $0x0,%eax
  803924:	48 ba 1e 08 80 00 00 	movabs $0x80081e,%rdx
  80392b:	00 00 00 
  80392e:	ff d2                	callq  *%rdx
		close(fd_src);
  803930:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803933:	89 c7                	mov    %eax,%edi
  803935:	48 b8 12 2d 80 00 00 	movabs $0x802d12,%rax
  80393c:	00 00 00 
  80393f:	ff d0                	callq  *%rax
		close(fd_dest);
  803941:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803944:	89 c7                	mov    %eax,%edi
  803946:	48 b8 12 2d 80 00 00 	movabs $0x802d12,%rax
  80394d:	00 00 00 
  803950:	ff d0                	callq  *%rax
		return read_size;
  803952:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803955:	eb 27                	jmp    80397e <copy+0x1d9>
	}
	close(fd_src);
  803957:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80395a:	89 c7                	mov    %eax,%edi
  80395c:	48 b8 12 2d 80 00 00 	movabs $0x802d12,%rax
  803963:	00 00 00 
  803966:	ff d0                	callq  *%rax
	close(fd_dest);
  803968:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80396b:	89 c7                	mov    %eax,%edi
  80396d:	48 b8 12 2d 80 00 00 	movabs $0x802d12,%rax
  803974:	00 00 00 
  803977:	ff d0                	callq  *%rax
	return 0;
  803979:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  80397e:	c9                   	leaveq 
  80397f:	c3                   	retq   

0000000000803980 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803980:	55                   	push   %rbp
  803981:	48 89 e5             	mov    %rsp,%rbp
  803984:	53                   	push   %rbx
  803985:	48 83 ec 38          	sub    $0x38,%rsp
  803989:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80398d:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803991:	48 89 c7             	mov    %rax,%rdi
  803994:	48 b8 6a 2a 80 00 00 	movabs $0x802a6a,%rax
  80399b:	00 00 00 
  80399e:	ff d0                	callq  *%rax
  8039a0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8039a3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8039a7:	0f 88 bf 01 00 00    	js     803b6c <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8039ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039b1:	ba 07 04 00 00       	mov    $0x407,%edx
  8039b6:	48 89 c6             	mov    %rax,%rsi
  8039b9:	bf 00 00 00 00       	mov    $0x0,%edi
  8039be:	48 b8 43 1d 80 00 00 	movabs $0x801d43,%rax
  8039c5:	00 00 00 
  8039c8:	ff d0                	callq  *%rax
  8039ca:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8039cd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8039d1:	0f 88 95 01 00 00    	js     803b6c <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8039d7:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8039db:	48 89 c7             	mov    %rax,%rdi
  8039de:	48 b8 6a 2a 80 00 00 	movabs $0x802a6a,%rax
  8039e5:	00 00 00 
  8039e8:	ff d0                	callq  *%rax
  8039ea:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8039ed:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8039f1:	0f 88 5d 01 00 00    	js     803b54 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8039f7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8039fb:	ba 07 04 00 00       	mov    $0x407,%edx
  803a00:	48 89 c6             	mov    %rax,%rsi
  803a03:	bf 00 00 00 00       	mov    $0x0,%edi
  803a08:	48 b8 43 1d 80 00 00 	movabs $0x801d43,%rax
  803a0f:	00 00 00 
  803a12:	ff d0                	callq  *%rax
  803a14:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a17:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a1b:	0f 88 33 01 00 00    	js     803b54 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803a21:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a25:	48 89 c7             	mov    %rax,%rdi
  803a28:	48 b8 3f 2a 80 00 00 	movabs $0x802a3f,%rax
  803a2f:	00 00 00 
  803a32:	ff d0                	callq  *%rax
  803a34:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a38:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a3c:	ba 07 04 00 00       	mov    $0x407,%edx
  803a41:	48 89 c6             	mov    %rax,%rsi
  803a44:	bf 00 00 00 00       	mov    $0x0,%edi
  803a49:	48 b8 43 1d 80 00 00 	movabs $0x801d43,%rax
  803a50:	00 00 00 
  803a53:	ff d0                	callq  *%rax
  803a55:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a58:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a5c:	79 05                	jns    803a63 <pipe+0xe3>
		goto err2;
  803a5e:	e9 d9 00 00 00       	jmpq   803b3c <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a63:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a67:	48 89 c7             	mov    %rax,%rdi
  803a6a:	48 b8 3f 2a 80 00 00 	movabs $0x802a3f,%rax
  803a71:	00 00 00 
  803a74:	ff d0                	callq  *%rax
  803a76:	48 89 c2             	mov    %rax,%rdx
  803a79:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a7d:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803a83:	48 89 d1             	mov    %rdx,%rcx
  803a86:	ba 00 00 00 00       	mov    $0x0,%edx
  803a8b:	48 89 c6             	mov    %rax,%rsi
  803a8e:	bf 00 00 00 00       	mov    $0x0,%edi
  803a93:	48 b8 93 1d 80 00 00 	movabs $0x801d93,%rax
  803a9a:	00 00 00 
  803a9d:	ff d0                	callq  *%rax
  803a9f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803aa2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803aa6:	79 1b                	jns    803ac3 <pipe+0x143>
		goto err3;
  803aa8:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803aa9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803aad:	48 89 c6             	mov    %rax,%rsi
  803ab0:	bf 00 00 00 00       	mov    $0x0,%edi
  803ab5:	48 b8 ee 1d 80 00 00 	movabs $0x801dee,%rax
  803abc:	00 00 00 
  803abf:	ff d0                	callq  *%rax
  803ac1:	eb 79                	jmp    803b3c <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803ac3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ac7:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803ace:	00 00 00 
  803ad1:	8b 12                	mov    (%rdx),%edx
  803ad3:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803ad5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ad9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803ae0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ae4:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803aeb:	00 00 00 
  803aee:	8b 12                	mov    (%rdx),%edx
  803af0:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803af2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803af6:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803afd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b01:	48 89 c7             	mov    %rax,%rdi
  803b04:	48 b8 1c 2a 80 00 00 	movabs $0x802a1c,%rax
  803b0b:	00 00 00 
  803b0e:	ff d0                	callq  *%rax
  803b10:	89 c2                	mov    %eax,%edx
  803b12:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803b16:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803b18:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803b1c:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803b20:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b24:	48 89 c7             	mov    %rax,%rdi
  803b27:	48 b8 1c 2a 80 00 00 	movabs $0x802a1c,%rax
  803b2e:	00 00 00 
  803b31:	ff d0                	callq  *%rax
  803b33:	89 03                	mov    %eax,(%rbx)
	return 0;
  803b35:	b8 00 00 00 00       	mov    $0x0,%eax
  803b3a:	eb 33                	jmp    803b6f <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803b3c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b40:	48 89 c6             	mov    %rax,%rsi
  803b43:	bf 00 00 00 00       	mov    $0x0,%edi
  803b48:	48 b8 ee 1d 80 00 00 	movabs $0x801dee,%rax
  803b4f:	00 00 00 
  803b52:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803b54:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b58:	48 89 c6             	mov    %rax,%rsi
  803b5b:	bf 00 00 00 00       	mov    $0x0,%edi
  803b60:	48 b8 ee 1d 80 00 00 	movabs $0x801dee,%rax
  803b67:	00 00 00 
  803b6a:	ff d0                	callq  *%rax
err:
	return r;
  803b6c:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803b6f:	48 83 c4 38          	add    $0x38,%rsp
  803b73:	5b                   	pop    %rbx
  803b74:	5d                   	pop    %rbp
  803b75:	c3                   	retq   

0000000000803b76 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803b76:	55                   	push   %rbp
  803b77:	48 89 e5             	mov    %rsp,%rbp
  803b7a:	53                   	push   %rbx
  803b7b:	48 83 ec 28          	sub    $0x28,%rsp
  803b7f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803b83:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803b87:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803b8e:	00 00 00 
  803b91:	48 8b 00             	mov    (%rax),%rax
  803b94:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803b9a:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803b9d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ba1:	48 89 c7             	mov    %rax,%rdi
  803ba4:	48 b8 d0 45 80 00 00 	movabs $0x8045d0,%rax
  803bab:	00 00 00 
  803bae:	ff d0                	callq  *%rax
  803bb0:	89 c3                	mov    %eax,%ebx
  803bb2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bb6:	48 89 c7             	mov    %rax,%rdi
  803bb9:	48 b8 d0 45 80 00 00 	movabs $0x8045d0,%rax
  803bc0:	00 00 00 
  803bc3:	ff d0                	callq  *%rax
  803bc5:	39 c3                	cmp    %eax,%ebx
  803bc7:	0f 94 c0             	sete   %al
  803bca:	0f b6 c0             	movzbl %al,%eax
  803bcd:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803bd0:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803bd7:	00 00 00 
  803bda:	48 8b 00             	mov    (%rax),%rax
  803bdd:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803be3:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803be6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803be9:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803bec:	75 05                	jne    803bf3 <_pipeisclosed+0x7d>
			return ret;
  803bee:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803bf1:	eb 4f                	jmp    803c42 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803bf3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bf6:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803bf9:	74 42                	je     803c3d <_pipeisclosed+0xc7>
  803bfb:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803bff:	75 3c                	jne    803c3d <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803c01:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c08:	00 00 00 
  803c0b:	48 8b 00             	mov    (%rax),%rax
  803c0e:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803c14:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803c17:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c1a:	89 c6                	mov    %eax,%esi
  803c1c:	48 bf d1 4e 80 00 00 	movabs $0x804ed1,%rdi
  803c23:	00 00 00 
  803c26:	b8 00 00 00 00       	mov    $0x0,%eax
  803c2b:	49 b8 1e 08 80 00 00 	movabs $0x80081e,%r8
  803c32:	00 00 00 
  803c35:	41 ff d0             	callq  *%r8
	}
  803c38:	e9 4a ff ff ff       	jmpq   803b87 <_pipeisclosed+0x11>
  803c3d:	e9 45 ff ff ff       	jmpq   803b87 <_pipeisclosed+0x11>
}
  803c42:	48 83 c4 28          	add    $0x28,%rsp
  803c46:	5b                   	pop    %rbx
  803c47:	5d                   	pop    %rbp
  803c48:	c3                   	retq   

0000000000803c49 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803c49:	55                   	push   %rbp
  803c4a:	48 89 e5             	mov    %rsp,%rbp
  803c4d:	48 83 ec 30          	sub    $0x30,%rsp
  803c51:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803c54:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803c58:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803c5b:	48 89 d6             	mov    %rdx,%rsi
  803c5e:	89 c7                	mov    %eax,%edi
  803c60:	48 b8 02 2b 80 00 00 	movabs $0x802b02,%rax
  803c67:	00 00 00 
  803c6a:	ff d0                	callq  *%rax
  803c6c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c6f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c73:	79 05                	jns    803c7a <pipeisclosed+0x31>
		return r;
  803c75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c78:	eb 31                	jmp    803cab <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803c7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c7e:	48 89 c7             	mov    %rax,%rdi
  803c81:	48 b8 3f 2a 80 00 00 	movabs $0x802a3f,%rax
  803c88:	00 00 00 
  803c8b:	ff d0                	callq  *%rax
  803c8d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803c91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c95:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803c99:	48 89 d6             	mov    %rdx,%rsi
  803c9c:	48 89 c7             	mov    %rax,%rdi
  803c9f:	48 b8 76 3b 80 00 00 	movabs $0x803b76,%rax
  803ca6:	00 00 00 
  803ca9:	ff d0                	callq  *%rax
}
  803cab:	c9                   	leaveq 
  803cac:	c3                   	retq   

0000000000803cad <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803cad:	55                   	push   %rbp
  803cae:	48 89 e5             	mov    %rsp,%rbp
  803cb1:	48 83 ec 40          	sub    $0x40,%rsp
  803cb5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803cb9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803cbd:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803cc1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cc5:	48 89 c7             	mov    %rax,%rdi
  803cc8:	48 b8 3f 2a 80 00 00 	movabs $0x802a3f,%rax
  803ccf:	00 00 00 
  803cd2:	ff d0                	callq  *%rax
  803cd4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803cd8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803cdc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803ce0:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803ce7:	00 
  803ce8:	e9 92 00 00 00       	jmpq   803d7f <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803ced:	eb 41                	jmp    803d30 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803cef:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803cf4:	74 09                	je     803cff <devpipe_read+0x52>
				return i;
  803cf6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cfa:	e9 92 00 00 00       	jmpq   803d91 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803cff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d03:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d07:	48 89 d6             	mov    %rdx,%rsi
  803d0a:	48 89 c7             	mov    %rax,%rdi
  803d0d:	48 b8 76 3b 80 00 00 	movabs $0x803b76,%rax
  803d14:	00 00 00 
  803d17:	ff d0                	callq  *%rax
  803d19:	85 c0                	test   %eax,%eax
  803d1b:	74 07                	je     803d24 <devpipe_read+0x77>
				return 0;
  803d1d:	b8 00 00 00 00       	mov    $0x0,%eax
  803d22:	eb 6d                	jmp    803d91 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803d24:	48 b8 05 1d 80 00 00 	movabs $0x801d05,%rax
  803d2b:	00 00 00 
  803d2e:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803d30:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d34:	8b 10                	mov    (%rax),%edx
  803d36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d3a:	8b 40 04             	mov    0x4(%rax),%eax
  803d3d:	39 c2                	cmp    %eax,%edx
  803d3f:	74 ae                	je     803cef <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803d41:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d45:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803d49:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803d4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d51:	8b 00                	mov    (%rax),%eax
  803d53:	99                   	cltd   
  803d54:	c1 ea 1b             	shr    $0x1b,%edx
  803d57:	01 d0                	add    %edx,%eax
  803d59:	83 e0 1f             	and    $0x1f,%eax
  803d5c:	29 d0                	sub    %edx,%eax
  803d5e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d62:	48 98                	cltq   
  803d64:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803d69:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803d6b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d6f:	8b 00                	mov    (%rax),%eax
  803d71:	8d 50 01             	lea    0x1(%rax),%edx
  803d74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d78:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803d7a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803d7f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d83:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803d87:	0f 82 60 ff ff ff    	jb     803ced <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803d8d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803d91:	c9                   	leaveq 
  803d92:	c3                   	retq   

0000000000803d93 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803d93:	55                   	push   %rbp
  803d94:	48 89 e5             	mov    %rsp,%rbp
  803d97:	48 83 ec 40          	sub    $0x40,%rsp
  803d9b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803d9f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803da3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803da7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803dab:	48 89 c7             	mov    %rax,%rdi
  803dae:	48 b8 3f 2a 80 00 00 	movabs $0x802a3f,%rax
  803db5:	00 00 00 
  803db8:	ff d0                	callq  *%rax
  803dba:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803dbe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803dc2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803dc6:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803dcd:	00 
  803dce:	e9 8e 00 00 00       	jmpq   803e61 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803dd3:	eb 31                	jmp    803e06 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803dd5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803dd9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ddd:	48 89 d6             	mov    %rdx,%rsi
  803de0:	48 89 c7             	mov    %rax,%rdi
  803de3:	48 b8 76 3b 80 00 00 	movabs $0x803b76,%rax
  803dea:	00 00 00 
  803ded:	ff d0                	callq  *%rax
  803def:	85 c0                	test   %eax,%eax
  803df1:	74 07                	je     803dfa <devpipe_write+0x67>
				return 0;
  803df3:	b8 00 00 00 00       	mov    $0x0,%eax
  803df8:	eb 79                	jmp    803e73 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803dfa:	48 b8 05 1d 80 00 00 	movabs $0x801d05,%rax
  803e01:	00 00 00 
  803e04:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803e06:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e0a:	8b 40 04             	mov    0x4(%rax),%eax
  803e0d:	48 63 d0             	movslq %eax,%rdx
  803e10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e14:	8b 00                	mov    (%rax),%eax
  803e16:	48 98                	cltq   
  803e18:	48 83 c0 20          	add    $0x20,%rax
  803e1c:	48 39 c2             	cmp    %rax,%rdx
  803e1f:	73 b4                	jae    803dd5 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803e21:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e25:	8b 40 04             	mov    0x4(%rax),%eax
  803e28:	99                   	cltd   
  803e29:	c1 ea 1b             	shr    $0x1b,%edx
  803e2c:	01 d0                	add    %edx,%eax
  803e2e:	83 e0 1f             	and    $0x1f,%eax
  803e31:	29 d0                	sub    %edx,%eax
  803e33:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803e37:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803e3b:	48 01 ca             	add    %rcx,%rdx
  803e3e:	0f b6 0a             	movzbl (%rdx),%ecx
  803e41:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e45:	48 98                	cltq   
  803e47:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803e4b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e4f:	8b 40 04             	mov    0x4(%rax),%eax
  803e52:	8d 50 01             	lea    0x1(%rax),%edx
  803e55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e59:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803e5c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803e61:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e65:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803e69:	0f 82 64 ff ff ff    	jb     803dd3 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803e6f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803e73:	c9                   	leaveq 
  803e74:	c3                   	retq   

0000000000803e75 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803e75:	55                   	push   %rbp
  803e76:	48 89 e5             	mov    %rsp,%rbp
  803e79:	48 83 ec 20          	sub    $0x20,%rsp
  803e7d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803e81:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803e85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e89:	48 89 c7             	mov    %rax,%rdi
  803e8c:	48 b8 3f 2a 80 00 00 	movabs $0x802a3f,%rax
  803e93:	00 00 00 
  803e96:	ff d0                	callq  *%rax
  803e98:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803e9c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ea0:	48 be e4 4e 80 00 00 	movabs $0x804ee4,%rsi
  803ea7:	00 00 00 
  803eaa:	48 89 c7             	mov    %rax,%rdi
  803ead:	48 b8 14 14 80 00 00 	movabs $0x801414,%rax
  803eb4:	00 00 00 
  803eb7:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803eb9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ebd:	8b 50 04             	mov    0x4(%rax),%edx
  803ec0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ec4:	8b 00                	mov    (%rax),%eax
  803ec6:	29 c2                	sub    %eax,%edx
  803ec8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ecc:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803ed2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ed6:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803edd:	00 00 00 
	stat->st_dev = &devpipe;
  803ee0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ee4:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803eeb:	00 00 00 
  803eee:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803ef5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803efa:	c9                   	leaveq 
  803efb:	c3                   	retq   

0000000000803efc <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803efc:	55                   	push   %rbp
  803efd:	48 89 e5             	mov    %rsp,%rbp
  803f00:	48 83 ec 10          	sub    $0x10,%rsp
  803f04:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803f08:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f0c:	48 89 c6             	mov    %rax,%rsi
  803f0f:	bf 00 00 00 00       	mov    $0x0,%edi
  803f14:	48 b8 ee 1d 80 00 00 	movabs $0x801dee,%rax
  803f1b:	00 00 00 
  803f1e:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803f20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f24:	48 89 c7             	mov    %rax,%rdi
  803f27:	48 b8 3f 2a 80 00 00 	movabs $0x802a3f,%rax
  803f2e:	00 00 00 
  803f31:	ff d0                	callq  *%rax
  803f33:	48 89 c6             	mov    %rax,%rsi
  803f36:	bf 00 00 00 00       	mov    $0x0,%edi
  803f3b:	48 b8 ee 1d 80 00 00 	movabs $0x801dee,%rax
  803f42:	00 00 00 
  803f45:	ff d0                	callq  *%rax
}
  803f47:	c9                   	leaveq 
  803f48:	c3                   	retq   

0000000000803f49 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  803f49:	55                   	push   %rbp
  803f4a:	48 89 e5             	mov    %rsp,%rbp
  803f4d:	48 83 ec 20          	sub    $0x20,%rsp
  803f51:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  803f54:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f58:	75 35                	jne    803f8f <wait+0x46>
  803f5a:	48 b9 eb 4e 80 00 00 	movabs $0x804eeb,%rcx
  803f61:	00 00 00 
  803f64:	48 ba f6 4e 80 00 00 	movabs $0x804ef6,%rdx
  803f6b:	00 00 00 
  803f6e:	be 09 00 00 00       	mov    $0x9,%esi
  803f73:	48 bf 0b 4f 80 00 00 	movabs $0x804f0b,%rdi
  803f7a:	00 00 00 
  803f7d:	b8 00 00 00 00       	mov    $0x0,%eax
  803f82:	49 b8 e5 05 80 00 00 	movabs $0x8005e5,%r8
  803f89:	00 00 00 
  803f8c:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  803f8f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f92:	25 ff 03 00 00       	and    $0x3ff,%eax
  803f97:	48 98                	cltq   
  803f99:	48 69 d0 70 01 00 00 	imul   $0x170,%rax,%rdx
  803fa0:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803fa7:	00 00 00 
  803faa:	48 01 d0             	add    %rdx,%rax
  803fad:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803fb1:	eb 0c                	jmp    803fbf <wait+0x76>
		sys_yield();
  803fb3:	48 b8 05 1d 80 00 00 	movabs $0x801d05,%rax
  803fba:	00 00 00 
  803fbd:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803fbf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fc3:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803fc9:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803fcc:	75 0e                	jne    803fdc <wait+0x93>
  803fce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fd2:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  803fd8:	85 c0                	test   %eax,%eax
  803fda:	75 d7                	jne    803fb3 <wait+0x6a>
		sys_yield();
}
  803fdc:	c9                   	leaveq 
  803fdd:	c3                   	retq   

0000000000803fde <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803fde:	55                   	push   %rbp
  803fdf:	48 89 e5             	mov    %rsp,%rbp
  803fe2:	48 83 ec 20          	sub    $0x20,%rsp
  803fe6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803fe9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fec:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803fef:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803ff3:	be 01 00 00 00       	mov    $0x1,%esi
  803ff8:	48 89 c7             	mov    %rax,%rdi
  803ffb:	48 b8 fb 1b 80 00 00 	movabs $0x801bfb,%rax
  804002:	00 00 00 
  804005:	ff d0                	callq  *%rax
}
  804007:	c9                   	leaveq 
  804008:	c3                   	retq   

0000000000804009 <getchar>:

int
getchar(void)
{
  804009:	55                   	push   %rbp
  80400a:	48 89 e5             	mov    %rsp,%rbp
  80400d:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804011:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804015:	ba 01 00 00 00       	mov    $0x1,%edx
  80401a:	48 89 c6             	mov    %rax,%rsi
  80401d:	bf 00 00 00 00       	mov    $0x0,%edi
  804022:	48 b8 34 2f 80 00 00 	movabs $0x802f34,%rax
  804029:	00 00 00 
  80402c:	ff d0                	callq  *%rax
  80402e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  804031:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804035:	79 05                	jns    80403c <getchar+0x33>
		return r;
  804037:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80403a:	eb 14                	jmp    804050 <getchar+0x47>
	if (r < 1)
  80403c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804040:	7f 07                	jg     804049 <getchar+0x40>
		return -E_EOF;
  804042:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804047:	eb 07                	jmp    804050 <getchar+0x47>
	return c;
  804049:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80404d:	0f b6 c0             	movzbl %al,%eax
}
  804050:	c9                   	leaveq 
  804051:	c3                   	retq   

0000000000804052 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804052:	55                   	push   %rbp
  804053:	48 89 e5             	mov    %rsp,%rbp
  804056:	48 83 ec 20          	sub    $0x20,%rsp
  80405a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80405d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804061:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804064:	48 89 d6             	mov    %rdx,%rsi
  804067:	89 c7                	mov    %eax,%edi
  804069:	48 b8 02 2b 80 00 00 	movabs $0x802b02,%rax
  804070:	00 00 00 
  804073:	ff d0                	callq  *%rax
  804075:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804078:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80407c:	79 05                	jns    804083 <iscons+0x31>
		return r;
  80407e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804081:	eb 1a                	jmp    80409d <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804083:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804087:	8b 10                	mov    (%rax),%edx
  804089:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  804090:	00 00 00 
  804093:	8b 00                	mov    (%rax),%eax
  804095:	39 c2                	cmp    %eax,%edx
  804097:	0f 94 c0             	sete   %al
  80409a:	0f b6 c0             	movzbl %al,%eax
}
  80409d:	c9                   	leaveq 
  80409e:	c3                   	retq   

000000000080409f <opencons>:

int
opencons(void)
{
  80409f:	55                   	push   %rbp
  8040a0:	48 89 e5             	mov    %rsp,%rbp
  8040a3:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8040a7:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8040ab:	48 89 c7             	mov    %rax,%rdi
  8040ae:	48 b8 6a 2a 80 00 00 	movabs $0x802a6a,%rax
  8040b5:	00 00 00 
  8040b8:	ff d0                	callq  *%rax
  8040ba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040c1:	79 05                	jns    8040c8 <opencons+0x29>
		return r;
  8040c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040c6:	eb 5b                	jmp    804123 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8040c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040cc:	ba 07 04 00 00       	mov    $0x407,%edx
  8040d1:	48 89 c6             	mov    %rax,%rsi
  8040d4:	bf 00 00 00 00       	mov    $0x0,%edi
  8040d9:	48 b8 43 1d 80 00 00 	movabs $0x801d43,%rax
  8040e0:	00 00 00 
  8040e3:	ff d0                	callq  *%rax
  8040e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040ec:	79 05                	jns    8040f3 <opencons+0x54>
		return r;
  8040ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040f1:	eb 30                	jmp    804123 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8040f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040f7:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  8040fe:	00 00 00 
  804101:	8b 12                	mov    (%rdx),%edx
  804103:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804105:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804109:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804110:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804114:	48 89 c7             	mov    %rax,%rdi
  804117:	48 b8 1c 2a 80 00 00 	movabs $0x802a1c,%rax
  80411e:	00 00 00 
  804121:	ff d0                	callq  *%rax
}
  804123:	c9                   	leaveq 
  804124:	c3                   	retq   

0000000000804125 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804125:	55                   	push   %rbp
  804126:	48 89 e5             	mov    %rsp,%rbp
  804129:	48 83 ec 30          	sub    $0x30,%rsp
  80412d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804131:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804135:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804139:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80413e:	75 07                	jne    804147 <devcons_read+0x22>
		return 0;
  804140:	b8 00 00 00 00       	mov    $0x0,%eax
  804145:	eb 4b                	jmp    804192 <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  804147:	eb 0c                	jmp    804155 <devcons_read+0x30>
		sys_yield();
  804149:	48 b8 05 1d 80 00 00 	movabs $0x801d05,%rax
  804150:	00 00 00 
  804153:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804155:	48 b8 45 1c 80 00 00 	movabs $0x801c45,%rax
  80415c:	00 00 00 
  80415f:	ff d0                	callq  *%rax
  804161:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804164:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804168:	74 df                	je     804149 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  80416a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80416e:	79 05                	jns    804175 <devcons_read+0x50>
		return c;
  804170:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804173:	eb 1d                	jmp    804192 <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  804175:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804179:	75 07                	jne    804182 <devcons_read+0x5d>
		return 0;
  80417b:	b8 00 00 00 00       	mov    $0x0,%eax
  804180:	eb 10                	jmp    804192 <devcons_read+0x6d>
	*(char*)vbuf = c;
  804182:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804185:	89 c2                	mov    %eax,%edx
  804187:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80418b:	88 10                	mov    %dl,(%rax)
	return 1;
  80418d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804192:	c9                   	leaveq 
  804193:	c3                   	retq   

0000000000804194 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804194:	55                   	push   %rbp
  804195:	48 89 e5             	mov    %rsp,%rbp
  804198:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80419f:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8041a6:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8041ad:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8041b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8041bb:	eb 76                	jmp    804233 <devcons_write+0x9f>
		m = n - tot;
  8041bd:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8041c4:	89 c2                	mov    %eax,%edx
  8041c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041c9:	29 c2                	sub    %eax,%edx
  8041cb:	89 d0                	mov    %edx,%eax
  8041cd:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8041d0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8041d3:	83 f8 7f             	cmp    $0x7f,%eax
  8041d6:	76 07                	jbe    8041df <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8041d8:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8041df:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8041e2:	48 63 d0             	movslq %eax,%rdx
  8041e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041e8:	48 63 c8             	movslq %eax,%rcx
  8041eb:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8041f2:	48 01 c1             	add    %rax,%rcx
  8041f5:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8041fc:	48 89 ce             	mov    %rcx,%rsi
  8041ff:	48 89 c7             	mov    %rax,%rdi
  804202:	48 b8 38 17 80 00 00 	movabs $0x801738,%rax
  804209:	00 00 00 
  80420c:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80420e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804211:	48 63 d0             	movslq %eax,%rdx
  804214:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80421b:	48 89 d6             	mov    %rdx,%rsi
  80421e:	48 89 c7             	mov    %rax,%rdi
  804221:	48 b8 fb 1b 80 00 00 	movabs $0x801bfb,%rax
  804228:	00 00 00 
  80422b:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80422d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804230:	01 45 fc             	add    %eax,-0x4(%rbp)
  804233:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804236:	48 98                	cltq   
  804238:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80423f:	0f 82 78 ff ff ff    	jb     8041bd <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804245:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804248:	c9                   	leaveq 
  804249:	c3                   	retq   

000000000080424a <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80424a:	55                   	push   %rbp
  80424b:	48 89 e5             	mov    %rsp,%rbp
  80424e:	48 83 ec 08          	sub    $0x8,%rsp
  804252:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804256:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80425b:	c9                   	leaveq 
  80425c:	c3                   	retq   

000000000080425d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80425d:	55                   	push   %rbp
  80425e:	48 89 e5             	mov    %rsp,%rbp
  804261:	48 83 ec 10          	sub    $0x10,%rsp
  804265:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804269:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80426d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804271:	48 be 1b 4f 80 00 00 	movabs $0x804f1b,%rsi
  804278:	00 00 00 
  80427b:	48 89 c7             	mov    %rax,%rdi
  80427e:	48 b8 14 14 80 00 00 	movabs $0x801414,%rax
  804285:	00 00 00 
  804288:	ff d0                	callq  *%rax
	return 0;
  80428a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80428f:	c9                   	leaveq 
  804290:	c3                   	retq   

0000000000804291 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  804291:	55                   	push   %rbp
  804292:	48 89 e5             	mov    %rsp,%rbp
  804295:	48 83 ec 20          	sub    $0x20,%rsp
  804299:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  80429d:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8042a4:	00 00 00 
  8042a7:	48 8b 00             	mov    (%rax),%rax
  8042aa:	48 85 c0             	test   %rax,%rax
  8042ad:	75 6f                	jne    80431e <set_pgfault_handler+0x8d>
		// First time through!
		// LAB 4: Your code here.

		if ((r = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0)
  8042af:	ba 07 00 00 00       	mov    $0x7,%edx
  8042b4:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8042b9:	bf 00 00 00 00       	mov    $0x0,%edi
  8042be:	48 b8 43 1d 80 00 00 	movabs $0x801d43,%rax
  8042c5:	00 00 00 
  8042c8:	ff d0                	callq  *%rax
  8042ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8042cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042d1:	79 30                	jns    804303 <set_pgfault_handler+0x72>
            panic("set_pgfault_handler: %d\n", r);
  8042d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042d6:	89 c1                	mov    %eax,%ecx
  8042d8:	48 ba 22 4f 80 00 00 	movabs $0x804f22,%rdx
  8042df:	00 00 00 
  8042e2:	be 22 00 00 00       	mov    $0x22,%esi
  8042e7:	48 bf 3b 4f 80 00 00 	movabs $0x804f3b,%rdi
  8042ee:	00 00 00 
  8042f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8042f6:	49 b8 e5 05 80 00 00 	movabs $0x8005e5,%r8
  8042fd:	00 00 00 
  804300:	41 ff d0             	callq  *%r8
        sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  804303:	48 be 31 43 80 00 00 	movabs $0x804331,%rsi
  80430a:	00 00 00 
  80430d:	bf 00 00 00 00       	mov    $0x0,%edi
  804312:	48 b8 cd 1e 80 00 00 	movabs $0x801ecd,%rax
  804319:	00 00 00 
  80431c:	ff d0                	callq  *%rax
		//panic("set_pgfault_handler not implemented");

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80431e:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  804325:	00 00 00 
  804328:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80432c:	48 89 10             	mov    %rdx,(%rax)
}
  80432f:	c9                   	leaveq 
  804330:	c3                   	retq   

0000000000804331 <_pgfault_upcall>:
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF


	movq %rsp, %rdi;	
  804331:	48 89 e7             	mov    %rsp,%rdi
	movq 136(%rsp), %rbx;
  804334:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  80433b:	00 
	movq 152(%rsp), %rsp;// Going to another stack for storing rip	
  80433c:	48 8b a4 24 98 00 00 	mov    0x98(%rsp),%rsp
  804343:	00 
	pushq %rbx;
  804344:	53                   	push   %rbx
	movq %rsp, %rbx;	
  804345:	48 89 e3             	mov    %rsp,%rbx
	movq %rdi, %rsp;	
  804348:	48 89 fc             	mov    %rdi,%rsp
	movq %rbx, 152(%rsp)	
  80434b:	48 89 9c 24 98 00 00 	mov    %rbx,0x98(%rsp)
  804352:	00 
   
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addq $16, %rsp;	
  804353:	48 83 c4 10          	add    $0x10,%rsp
	POPA_;  // getting all register values back
  804357:	4c 8b 3c 24          	mov    (%rsp),%r15
  80435b:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804360:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804365:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  80436a:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  80436f:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804374:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804379:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80437e:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804383:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804388:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  80438d:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804392:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804397:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  80439c:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8043a1:	48 83 c4 78          	add    $0x78,%rsp
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.


	add $8, %rsp; //Jump rip field  
  8043a5:	48 83 c4 08          	add    $0x8,%rsp
	popfq
  8043a9:	9d                   	popfq  

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popq %rsp   //USTACK
  8043aa:	5c                   	pop    %rsp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret   
  8043ab:	c3                   	retq   

00000000008043ac <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8043ac:	55                   	push   %rbp
  8043ad:	48 89 e5             	mov    %rsp,%rbp
  8043b0:	48 83 ec 30          	sub    $0x30,%rsp
  8043b4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8043b8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8043bc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	//LAB 4: Your code here.
	if (!pg) pg=(void*)-1;
  8043c0:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8043c5:	75 08                	jne    8043cf <ipc_recv+0x23>
  8043c7:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  8043ce:	ff 
	int res=sys_ipc_recv(pg);
  8043cf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043d3:	48 89 c7             	mov    %rax,%rdi
  8043d6:	48 b8 b7 1f 80 00 00 	movabs $0x801fb7,%rax
  8043dd:	00 00 00 
  8043e0:	ff d0                	callq  *%rax
  8043e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	
	if (from_env_store) *from_env_store=res==0?thisenv->env_ipc_from:0;
  8043e5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8043ea:	74 26                	je     804412 <ipc_recv+0x66>
  8043ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043f0:	75 15                	jne    804407 <ipc_recv+0x5b>
  8043f2:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8043f9:	00 00 00 
  8043fc:	48 8b 00             	mov    (%rax),%rax
  8043ff:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  804405:	eb 05                	jmp    80440c <ipc_recv+0x60>
  804407:	b8 00 00 00 00       	mov    $0x0,%eax
  80440c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804410:	89 02                	mov    %eax,(%rdx)
	if (perm_store) *perm_store=res==0?thisenv->env_ipc_perm:0;
  804412:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804417:	74 26                	je     80443f <ipc_recv+0x93>
  804419:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80441d:	75 15                	jne    804434 <ipc_recv+0x88>
  80441f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804426:	00 00 00 
  804429:	48 8b 00             	mov    (%rax),%rax
  80442c:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  804432:	eb 05                	jmp    804439 <ipc_recv+0x8d>
  804434:	b8 00 00 00 00       	mov    $0x0,%eax
  804439:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80443d:	89 02                	mov    %eax,(%rdx)
	return res!=0?res:thisenv->env_ipc_value;
  80443f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804443:	75 15                	jne    80445a <ipc_recv+0xae>
  804445:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80444c:	00 00 00 
  80444f:	48 8b 00             	mov    (%rax),%rax
  804452:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  804458:	eb 03                	jmp    80445d <ipc_recv+0xb1>
  80445a:	8b 45 fc             	mov    -0x4(%rbp),%eax
	

}
  80445d:	c9                   	leaveq 
  80445e:	c3                   	retq   

000000000080445f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80445f:	55                   	push   %rbp
  804460:	48 89 e5             	mov    %rsp,%rbp
  804463:	48 83 ec 30          	sub    $0x30,%rsp
  804467:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80446a:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80446d:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804471:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.

	if (!pg) pg=(void*)-1;
  804474:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804479:	75 0a                	jne    804485 <ipc_send+0x26>
  80447b:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  804482:	ff 
	int res;
	while ((res=sys_ipc_try_send(to_env, val, pg, perm))<0){
  804483:	eb 3e                	jmp    8044c3 <ipc_send+0x64>
  804485:	eb 3c                	jmp    8044c3 <ipc_send+0x64>
		if(res!=-E_IPC_NOT_RECV)
  804487:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80448b:	74 2a                	je     8044b7 <ipc_send+0x58>
			panic("ipc_send:error other than -E_IPC_NOT_RECV\n");
  80448d:	48 ba 50 4f 80 00 00 	movabs $0x804f50,%rdx
  804494:	00 00 00 
  804497:	be 39 00 00 00       	mov    $0x39,%esi
  80449c:	48 bf 7b 4f 80 00 00 	movabs $0x804f7b,%rdi
  8044a3:	00 00 00 
  8044a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8044ab:	48 b9 e5 05 80 00 00 	movabs $0x8005e5,%rcx
  8044b2:	00 00 00 
  8044b5:	ff d1                	callq  *%rcx
		sys_yield();  
  8044b7:	48 b8 05 1d 80 00 00 	movabs $0x801d05,%rax
  8044be:	00 00 00 
  8044c1:	ff d0                	callq  *%rax
{
	// LAB 4: Your code here.

	if (!pg) pg=(void*)-1;
	int res;
	while ((res=sys_ipc_try_send(to_env, val, pg, perm))<0){
  8044c3:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8044c6:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8044c9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8044cd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8044d0:	89 c7                	mov    %eax,%edi
  8044d2:	48 b8 62 1f 80 00 00 	movabs $0x801f62,%rax
  8044d9:	00 00 00 
  8044dc:	ff d0                	callq  *%rax
  8044de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8044e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044e5:	78 a0                	js     804487 <ipc_send+0x28>
			panic("ipc_send:error other than -E_IPC_NOT_RECV\n");
		sys_yield();  
	}
	//panic("ipc_send not implemented");

}
  8044e7:	c9                   	leaveq 
  8044e8:	c3                   	retq   

00000000008044e9 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  8044e9:	55                   	push   %rbp
  8044ea:	48 89 e5             	mov    %rsp,%rbp
  8044ed:	48 83 ec 10          	sub    $0x10,%rsp
  8044f1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	// LAB 8: Your code here.
	panic("ipc_recv not implemented in VM guest");
  8044f5:	48 ba 88 4f 80 00 00 	movabs $0x804f88,%rdx
  8044fc:	00 00 00 
  8044ff:	be 47 00 00 00       	mov    $0x47,%esi
  804504:	48 bf 7b 4f 80 00 00 	movabs $0x804f7b,%rdi
  80450b:	00 00 00 
  80450e:	b8 00 00 00 00       	mov    $0x0,%eax
  804513:	48 b9 e5 05 80 00 00 	movabs $0x8005e5,%rcx
  80451a:	00 00 00 
  80451d:	ff d1                	callq  *%rcx

000000000080451f <ipc_host_send>:

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80451f:	55                   	push   %rbp
  804520:	48 89 e5             	mov    %rsp,%rbp
  804523:	48 83 ec 20          	sub    $0x20,%rsp
  804527:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80452a:	89 75 f8             	mov    %esi,-0x8(%rbp)
  80452d:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  804531:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 8: Your code here.
	panic("ipc_send not implemented in VM guest");
  804534:	48 ba b0 4f 80 00 00 	movabs $0x804fb0,%rdx
  80453b:	00 00 00 
  80453e:	be 50 00 00 00       	mov    $0x50,%esi
  804543:	48 bf 7b 4f 80 00 00 	movabs $0x804f7b,%rdi
  80454a:	00 00 00 
  80454d:	b8 00 00 00 00       	mov    $0x0,%eax
  804552:	48 b9 e5 05 80 00 00 	movabs $0x8005e5,%rcx
  804559:	00 00 00 
  80455c:	ff d1                	callq  *%rcx

000000000080455e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80455e:	55                   	push   %rbp
  80455f:	48 89 e5             	mov    %rsp,%rbp
  804562:	48 83 ec 14          	sub    $0x14,%rsp
  804566:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804569:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804570:	eb 4e                	jmp    8045c0 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  804572:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804579:	00 00 00 
  80457c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80457f:	48 98                	cltq   
  804581:	48 69 c0 70 01 00 00 	imul   $0x170,%rax,%rax
  804588:	48 01 d0             	add    %rdx,%rax
  80458b:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804591:	8b 00                	mov    (%rax),%eax
  804593:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804596:	75 24                	jne    8045bc <ipc_find_env+0x5e>
			return envs[i].env_id;
  804598:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80459f:	00 00 00 
  8045a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045a5:	48 98                	cltq   
  8045a7:	48 69 c0 70 01 00 00 	imul   $0x170,%rax,%rax
  8045ae:	48 01 d0             	add    %rdx,%rax
  8045b1:	48 05 c0 00 00 00    	add    $0xc0,%rax
  8045b7:	8b 40 08             	mov    0x8(%rax),%eax
  8045ba:	eb 12                	jmp    8045ce <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8045bc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8045c0:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8045c7:	7e a9                	jle    804572 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;

	}
	return 0;
  8045c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8045ce:	c9                   	leaveq 
  8045cf:	c3                   	retq   

00000000008045d0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8045d0:	55                   	push   %rbp
  8045d1:	48 89 e5             	mov    %rsp,%rbp
  8045d4:	48 83 ec 18          	sub    $0x18,%rsp
  8045d8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8045dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8045e0:	48 c1 e8 15          	shr    $0x15,%rax
  8045e4:	48 89 c2             	mov    %rax,%rdx
  8045e7:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8045ee:	01 00 00 
  8045f1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8045f5:	83 e0 01             	and    $0x1,%eax
  8045f8:	48 85 c0             	test   %rax,%rax
  8045fb:	75 07                	jne    804604 <pageref+0x34>
		return 0;
  8045fd:	b8 00 00 00 00       	mov    $0x0,%eax
  804602:	eb 53                	jmp    804657 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804604:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804608:	48 c1 e8 0c          	shr    $0xc,%rax
  80460c:	48 89 c2             	mov    %rax,%rdx
  80460f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804616:	01 00 00 
  804619:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80461d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804621:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804625:	83 e0 01             	and    $0x1,%eax
  804628:	48 85 c0             	test   %rax,%rax
  80462b:	75 07                	jne    804634 <pageref+0x64>
		return 0;
  80462d:	b8 00 00 00 00       	mov    $0x0,%eax
  804632:	eb 23                	jmp    804657 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804634:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804638:	48 c1 e8 0c          	shr    $0xc,%rax
  80463c:	48 89 c2             	mov    %rax,%rdx
  80463f:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804646:	00 00 00 
  804649:	48 c1 e2 04          	shl    $0x4,%rdx
  80464d:	48 01 d0             	add    %rdx,%rax
  804650:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  804654:	0f b7 c0             	movzwl %ax,%eax
}
  804657:	c9                   	leaveq 
  804658:	c3                   	retq   
