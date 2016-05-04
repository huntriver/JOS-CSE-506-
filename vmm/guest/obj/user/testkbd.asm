
vmm/guest/obj/user/testkbd:     file format elf64-x86-64


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
  80003c:	e8 2a 04 00 00       	callq  80046b <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80004e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
  800052:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800059:	eb 10                	jmp    80006b <umain+0x28>
		sys_yield();
  80005b:	48 b8 8b 1d 80 00 00 	movabs $0x801d8b,%rax
  800062:	00 00 00 
  800065:	ff d0                	callq  *%rax
umain(int argc, char **argv)
{
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
  800067:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80006b:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
  80006f:	7e ea                	jle    80005b <umain+0x18>
		sys_yield();

	close(0);
  800071:	bf 00 00 00 00       	mov    $0x0,%edi
  800076:	48 b8 5a 24 80 00 00 	movabs $0x80245a,%rax
  80007d:	00 00 00 
  800080:	ff d0                	callq  *%rax
	if ((r = opencons()) < 0)
  800082:	48 b8 79 02 80 00 00 	movabs $0x800279,%rax
  800089:	00 00 00 
  80008c:	ff d0                	callq  *%rax
  80008e:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800091:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800095:	79 30                	jns    8000c7 <umain+0x84>
		panic("opencons: %e", r);
  800097:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80009a:	89 c1                	mov    %eax,%ecx
  80009c:	48 ba 60 3c 80 00 00 	movabs $0x803c60,%rdx
  8000a3:	00 00 00 
  8000a6:	be 0f 00 00 00       	mov    $0xf,%esi
  8000ab:	48 bf 6d 3c 80 00 00 	movabs $0x803c6d,%rdi
  8000b2:	00 00 00 
  8000b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ba:	49 b8 11 05 80 00 00 	movabs $0x800511,%r8
  8000c1:	00 00 00 
  8000c4:	41 ff d0             	callq  *%r8
	if (r != 0)
  8000c7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000cb:	74 30                	je     8000fd <umain+0xba>
		panic("first opencons used fd %d", r);
  8000cd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000d0:	89 c1                	mov    %eax,%ecx
  8000d2:	48 ba 7c 3c 80 00 00 	movabs $0x803c7c,%rdx
  8000d9:	00 00 00 
  8000dc:	be 11 00 00 00       	mov    $0x11,%esi
  8000e1:	48 bf 6d 3c 80 00 00 	movabs $0x803c6d,%rdi
  8000e8:	00 00 00 
  8000eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f0:	49 b8 11 05 80 00 00 	movabs $0x800511,%r8
  8000f7:	00 00 00 
  8000fa:	41 ff d0             	callq  *%r8
	if ((r = dup(0, 1)) < 0)
  8000fd:	be 01 00 00 00       	mov    $0x1,%esi
  800102:	bf 00 00 00 00       	mov    $0x0,%edi
  800107:	48 b8 d3 24 80 00 00 	movabs $0x8024d3,%rax
  80010e:	00 00 00 
  800111:	ff d0                	callq  *%rax
  800113:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800116:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80011a:	79 30                	jns    80014c <umain+0x109>
		panic("dup: %e", r);
  80011c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80011f:	89 c1                	mov    %eax,%ecx
  800121:	48 ba 96 3c 80 00 00 	movabs $0x803c96,%rdx
  800128:	00 00 00 
  80012b:	be 13 00 00 00       	mov    $0x13,%esi
  800130:	48 bf 6d 3c 80 00 00 	movabs $0x803c6d,%rdi
  800137:	00 00 00 
  80013a:	b8 00 00 00 00       	mov    $0x0,%eax
  80013f:	49 b8 11 05 80 00 00 	movabs $0x800511,%r8
  800146:	00 00 00 
  800149:	41 ff d0             	callq  *%r8

	for(;;){
		char *buf;

		buf = readline("Type a line: ");
  80014c:	48 bf 9e 3c 80 00 00 	movabs $0x803c9e,%rdi
  800153:	00 00 00 
  800156:	48 b8 d4 12 80 00 00 	movabs $0x8012d4,%rax
  80015d:	00 00 00 
  800160:	ff d0                	callq  *%rax
  800162:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if (buf != NULL)
  800166:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  80016b:	74 29                	je     800196 <umain+0x153>
			fprintf(1, "%s\n", buf);
  80016d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800171:	48 89 c2             	mov    %rax,%rdx
  800174:	48 be ac 3c 80 00 00 	movabs $0x803cac,%rsi
  80017b:	00 00 00 
  80017e:	bf 01 00 00 00       	mov    $0x1,%edi
  800183:	b8 00 00 00 00       	mov    $0x0,%eax
  800188:	48 b9 5e 32 80 00 00 	movabs $0x80325e,%rcx
  80018f:	00 00 00 
  800192:	ff d1                	callq  *%rcx
		else
			fprintf(1, "(end of file received)\n");
	}
  800194:	eb b6                	jmp    80014c <umain+0x109>

		buf = readline("Type a line: ");
		if (buf != NULL)
			fprintf(1, "%s\n", buf);
		else
			fprintf(1, "(end of file received)\n");
  800196:	48 be b0 3c 80 00 00 	movabs $0x803cb0,%rsi
  80019d:	00 00 00 
  8001a0:	bf 01 00 00 00       	mov    $0x1,%edi
  8001a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8001aa:	48 ba 5e 32 80 00 00 	movabs $0x80325e,%rdx
  8001b1:	00 00 00 
  8001b4:	ff d2                	callq  *%rdx
	}
  8001b6:	eb 94                	jmp    80014c <umain+0x109>

00000000008001b8 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8001b8:	55                   	push   %rbp
  8001b9:	48 89 e5             	mov    %rsp,%rbp
  8001bc:	48 83 ec 20          	sub    $0x20,%rsp
  8001c0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8001c3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001c6:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8001c9:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8001cd:	be 01 00 00 00       	mov    $0x1,%esi
  8001d2:	48 89 c7             	mov    %rax,%rdi
  8001d5:	48 b8 81 1c 80 00 00 	movabs $0x801c81,%rax
  8001dc:	00 00 00 
  8001df:	ff d0                	callq  *%rax
}
  8001e1:	c9                   	leaveq 
  8001e2:	c3                   	retq   

00000000008001e3 <getchar>:

int
getchar(void)
{
  8001e3:	55                   	push   %rbp
  8001e4:	48 89 e5             	mov    %rsp,%rbp
  8001e7:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8001eb:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8001ef:	ba 01 00 00 00       	mov    $0x1,%edx
  8001f4:	48 89 c6             	mov    %rax,%rsi
  8001f7:	bf 00 00 00 00       	mov    $0x0,%edi
  8001fc:	48 b8 7c 26 80 00 00 	movabs $0x80267c,%rax
  800203:	00 00 00 
  800206:	ff d0                	callq  *%rax
  800208:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80020b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80020f:	79 05                	jns    800216 <getchar+0x33>
		return r;
  800211:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800214:	eb 14                	jmp    80022a <getchar+0x47>
	if (r < 1)
  800216:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80021a:	7f 07                	jg     800223 <getchar+0x40>
		return -E_EOF;
  80021c:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  800221:	eb 07                	jmp    80022a <getchar+0x47>
	return c;
  800223:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  800227:	0f b6 c0             	movzbl %al,%eax
}
  80022a:	c9                   	leaveq 
  80022b:	c3                   	retq   

000000000080022c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80022c:	55                   	push   %rbp
  80022d:	48 89 e5             	mov    %rsp,%rbp
  800230:	48 83 ec 20          	sub    $0x20,%rsp
  800234:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800237:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80023b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80023e:	48 89 d6             	mov    %rdx,%rsi
  800241:	89 c7                	mov    %eax,%edi
  800243:	48 b8 4a 22 80 00 00 	movabs $0x80224a,%rax
  80024a:	00 00 00 
  80024d:	ff d0                	callq  *%rax
  80024f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800252:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800256:	79 05                	jns    80025d <iscons+0x31>
		return r;
  800258:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80025b:	eb 1a                	jmp    800277 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80025d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800261:	8b 10                	mov    (%rax),%edx
  800263:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80026a:	00 00 00 
  80026d:	8b 00                	mov    (%rax),%eax
  80026f:	39 c2                	cmp    %eax,%edx
  800271:	0f 94 c0             	sete   %al
  800274:	0f b6 c0             	movzbl %al,%eax
}
  800277:	c9                   	leaveq 
  800278:	c3                   	retq   

0000000000800279 <opencons>:

int
opencons(void)
{
  800279:	55                   	push   %rbp
  80027a:	48 89 e5             	mov    %rsp,%rbp
  80027d:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800281:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  800285:	48 89 c7             	mov    %rax,%rdi
  800288:	48 b8 b2 21 80 00 00 	movabs $0x8021b2,%rax
  80028f:	00 00 00 
  800292:	ff d0                	callq  *%rax
  800294:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800297:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80029b:	79 05                	jns    8002a2 <opencons+0x29>
		return r;
  80029d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002a0:	eb 5b                	jmp    8002fd <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8002a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002a6:	ba 07 04 00 00       	mov    $0x407,%edx
  8002ab:	48 89 c6             	mov    %rax,%rsi
  8002ae:	bf 00 00 00 00       	mov    $0x0,%edi
  8002b3:	48 b8 c9 1d 80 00 00 	movabs $0x801dc9,%rax
  8002ba:	00 00 00 
  8002bd:	ff d0                	callq  *%rax
  8002bf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8002c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8002c6:	79 05                	jns    8002cd <opencons+0x54>
		return r;
  8002c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002cb:	eb 30                	jmp    8002fd <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8002cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002d1:	48 ba 00 60 80 00 00 	movabs $0x806000,%rdx
  8002d8:	00 00 00 
  8002db:	8b 12                	mov    (%rdx),%edx
  8002dd:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8002df:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002e3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8002ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002ee:	48 89 c7             	mov    %rax,%rdi
  8002f1:	48 b8 64 21 80 00 00 	movabs $0x802164,%rax
  8002f8:	00 00 00 
  8002fb:	ff d0                	callq  *%rax
}
  8002fd:	c9                   	leaveq 
  8002fe:	c3                   	retq   

00000000008002ff <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8002ff:	55                   	push   %rbp
  800300:	48 89 e5             	mov    %rsp,%rbp
  800303:	48 83 ec 30          	sub    $0x30,%rsp
  800307:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80030b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80030f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  800313:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800318:	75 07                	jne    800321 <devcons_read+0x22>
		return 0;
  80031a:	b8 00 00 00 00       	mov    $0x0,%eax
  80031f:	eb 4b                	jmp    80036c <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  800321:	eb 0c                	jmp    80032f <devcons_read+0x30>
		sys_yield();
  800323:	48 b8 8b 1d 80 00 00 	movabs $0x801d8b,%rax
  80032a:	00 00 00 
  80032d:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80032f:	48 b8 cb 1c 80 00 00 	movabs $0x801ccb,%rax
  800336:	00 00 00 
  800339:	ff d0                	callq  *%rax
  80033b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80033e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800342:	74 df                	je     800323 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  800344:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800348:	79 05                	jns    80034f <devcons_read+0x50>
		return c;
  80034a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80034d:	eb 1d                	jmp    80036c <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  80034f:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  800353:	75 07                	jne    80035c <devcons_read+0x5d>
		return 0;
  800355:	b8 00 00 00 00       	mov    $0x0,%eax
  80035a:	eb 10                	jmp    80036c <devcons_read+0x6d>
	*(char*)vbuf = c;
  80035c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80035f:	89 c2                	mov    %eax,%edx
  800361:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800365:	88 10                	mov    %dl,(%rax)
	return 1;
  800367:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80036c:	c9                   	leaveq 
  80036d:	c3                   	retq   

000000000080036e <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80036e:	55                   	push   %rbp
  80036f:	48 89 e5             	mov    %rsp,%rbp
  800372:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  800379:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  800380:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  800387:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80038e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800395:	eb 76                	jmp    80040d <devcons_write+0x9f>
		m = n - tot;
  800397:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80039e:	89 c2                	mov    %eax,%edx
  8003a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003a3:	29 c2                	sub    %eax,%edx
  8003a5:	89 d0                	mov    %edx,%eax
  8003a7:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8003aa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003ad:	83 f8 7f             	cmp    $0x7f,%eax
  8003b0:	76 07                	jbe    8003b9 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8003b2:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8003b9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003bc:	48 63 d0             	movslq %eax,%rdx
  8003bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003c2:	48 63 c8             	movslq %eax,%rcx
  8003c5:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8003cc:	48 01 c1             	add    %rax,%rcx
  8003cf:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8003d6:	48 89 ce             	mov    %rcx,%rsi
  8003d9:	48 89 c7             	mov    %rax,%rdi
  8003dc:	48 b8 be 17 80 00 00 	movabs $0x8017be,%rax
  8003e3:	00 00 00 
  8003e6:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8003e8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003eb:	48 63 d0             	movslq %eax,%rdx
  8003ee:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8003f5:	48 89 d6             	mov    %rdx,%rsi
  8003f8:	48 89 c7             	mov    %rax,%rdi
  8003fb:	48 b8 81 1c 80 00 00 	movabs $0x801c81,%rax
  800402:	00 00 00 
  800405:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800407:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80040a:	01 45 fc             	add    %eax,-0x4(%rbp)
  80040d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800410:	48 98                	cltq   
  800412:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  800419:	0f 82 78 ff ff ff    	jb     800397 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80041f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800422:	c9                   	leaveq 
  800423:	c3                   	retq   

0000000000800424 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  800424:	55                   	push   %rbp
  800425:	48 89 e5             	mov    %rsp,%rbp
  800428:	48 83 ec 08          	sub    $0x8,%rsp
  80042c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  800430:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800435:	c9                   	leaveq 
  800436:	c3                   	retq   

0000000000800437 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800437:	55                   	push   %rbp
  800438:	48 89 e5             	mov    %rsp,%rbp
  80043b:	48 83 ec 10          	sub    $0x10,%rsp
  80043f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800443:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  800447:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80044b:	48 be cd 3c 80 00 00 	movabs $0x803ccd,%rsi
  800452:	00 00 00 
  800455:	48 89 c7             	mov    %rax,%rdi
  800458:	48 b8 9a 14 80 00 00 	movabs $0x80149a,%rax
  80045f:	00 00 00 
  800462:	ff d0                	callq  *%rax
	return 0;
  800464:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800469:	c9                   	leaveq 
  80046a:	c3                   	retq   

000000000080046b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80046b:	55                   	push   %rbp
  80046c:	48 89 e5             	mov    %rsp,%rbp
  80046f:	48 83 ec 10          	sub    $0x10,%rsp
  800473:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800476:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = envs+ENVX(sys_getenvid ());
  80047a:	48 b8 4d 1d 80 00 00 	movabs $0x801d4d,%rax
  800481:	00 00 00 
  800484:	ff d0                	callq  *%rax
  800486:	48 98                	cltq   
  800488:	25 ff 03 00 00       	and    $0x3ff,%eax
  80048d:	48 69 d0 70 01 00 00 	imul   $0x170,%rax,%rdx
  800494:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80049b:	00 00 00 
  80049e:	48 01 c2             	add    %rax,%rdx
  8004a1:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  8004a8:	00 00 00 
  8004ab:	48 89 10             	mov    %rdx,(%rax)
	// thisenv = 0;


	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8004b2:	7e 14                	jle    8004c8 <libmain+0x5d>
		binaryname = argv[0];
  8004b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8004b8:	48 8b 10             	mov    (%rax),%rdx
  8004bb:	48 b8 38 60 80 00 00 	movabs $0x806038,%rax
  8004c2:	00 00 00 
  8004c5:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8004c8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8004cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004cf:	48 89 d6             	mov    %rdx,%rsi
  8004d2:	89 c7                	mov    %eax,%edi
  8004d4:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8004db:	00 00 00 
  8004de:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8004e0:	48 b8 ee 04 80 00 00 	movabs $0x8004ee,%rax
  8004e7:	00 00 00 
  8004ea:	ff d0                	callq  *%rax
}
  8004ec:	c9                   	leaveq 
  8004ed:	c3                   	retq   

00000000008004ee <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8004ee:	55                   	push   %rbp
  8004ef:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  8004f2:	48 b8 a5 24 80 00 00 	movabs $0x8024a5,%rax
  8004f9:	00 00 00 
  8004fc:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  8004fe:	bf 00 00 00 00       	mov    $0x0,%edi
  800503:	48 b8 09 1d 80 00 00 	movabs $0x801d09,%rax
  80050a:	00 00 00 
  80050d:	ff d0                	callq  *%rax
}
  80050f:	5d                   	pop    %rbp
  800510:	c3                   	retq   

0000000000800511 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800511:	55                   	push   %rbp
  800512:	48 89 e5             	mov    %rsp,%rbp
  800515:	53                   	push   %rbx
  800516:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80051d:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800524:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80052a:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800531:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800538:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80053f:	84 c0                	test   %al,%al
  800541:	74 23                	je     800566 <_panic+0x55>
  800543:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  80054a:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80054e:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800552:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800556:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  80055a:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80055e:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800562:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800566:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80056d:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800574:	00 00 00 
  800577:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80057e:	00 00 00 
  800581:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800585:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80058c:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800593:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80059a:	48 b8 38 60 80 00 00 	movabs $0x806038,%rax
  8005a1:	00 00 00 
  8005a4:	48 8b 18             	mov    (%rax),%rbx
  8005a7:	48 b8 4d 1d 80 00 00 	movabs $0x801d4d,%rax
  8005ae:	00 00 00 
  8005b1:	ff d0                	callq  *%rax
  8005b3:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  8005b9:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8005c0:	41 89 c8             	mov    %ecx,%r8d
  8005c3:	48 89 d1             	mov    %rdx,%rcx
  8005c6:	48 89 da             	mov    %rbx,%rdx
  8005c9:	89 c6                	mov    %eax,%esi
  8005cb:	48 bf e0 3c 80 00 00 	movabs $0x803ce0,%rdi
  8005d2:	00 00 00 
  8005d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8005da:	49 b9 4a 07 80 00 00 	movabs $0x80074a,%r9
  8005e1:	00 00 00 
  8005e4:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8005e7:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8005ee:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005f5:	48 89 d6             	mov    %rdx,%rsi
  8005f8:	48 89 c7             	mov    %rax,%rdi
  8005fb:	48 b8 9e 06 80 00 00 	movabs $0x80069e,%rax
  800602:	00 00 00 
  800605:	ff d0                	callq  *%rax
	cprintf("\n");
  800607:	48 bf 03 3d 80 00 00 	movabs $0x803d03,%rdi
  80060e:	00 00 00 
  800611:	b8 00 00 00 00       	mov    $0x0,%eax
  800616:	48 ba 4a 07 80 00 00 	movabs $0x80074a,%rdx
  80061d:	00 00 00 
  800620:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800622:	cc                   	int3   
  800623:	eb fd                	jmp    800622 <_panic+0x111>

0000000000800625 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800625:	55                   	push   %rbp
  800626:	48 89 e5             	mov    %rsp,%rbp
  800629:	48 83 ec 10          	sub    $0x10,%rsp
  80062d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800630:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800634:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800638:	8b 00                	mov    (%rax),%eax
  80063a:	8d 48 01             	lea    0x1(%rax),%ecx
  80063d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800641:	89 0a                	mov    %ecx,(%rdx)
  800643:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800646:	89 d1                	mov    %edx,%ecx
  800648:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80064c:	48 98                	cltq   
  80064e:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800652:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800656:	8b 00                	mov    (%rax),%eax
  800658:	3d ff 00 00 00       	cmp    $0xff,%eax
  80065d:	75 2c                	jne    80068b <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80065f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800663:	8b 00                	mov    (%rax),%eax
  800665:	48 98                	cltq   
  800667:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80066b:	48 83 c2 08          	add    $0x8,%rdx
  80066f:	48 89 c6             	mov    %rax,%rsi
  800672:	48 89 d7             	mov    %rdx,%rdi
  800675:	48 b8 81 1c 80 00 00 	movabs $0x801c81,%rax
  80067c:	00 00 00 
  80067f:	ff d0                	callq  *%rax
        b->idx = 0;
  800681:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800685:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80068b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80068f:	8b 40 04             	mov    0x4(%rax),%eax
  800692:	8d 50 01             	lea    0x1(%rax),%edx
  800695:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800699:	89 50 04             	mov    %edx,0x4(%rax)
}
  80069c:	c9                   	leaveq 
  80069d:	c3                   	retq   

000000000080069e <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80069e:	55                   	push   %rbp
  80069f:	48 89 e5             	mov    %rsp,%rbp
  8006a2:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8006a9:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8006b0:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8006b7:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8006be:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8006c5:	48 8b 0a             	mov    (%rdx),%rcx
  8006c8:	48 89 08             	mov    %rcx,(%rax)
  8006cb:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8006cf:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8006d3:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8006d7:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8006db:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8006e2:	00 00 00 
    b.cnt = 0;
  8006e5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8006ec:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8006ef:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8006f6:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8006fd:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800704:	48 89 c6             	mov    %rax,%rsi
  800707:	48 bf 25 06 80 00 00 	movabs $0x800625,%rdi
  80070e:	00 00 00 
  800711:	48 b8 fd 0a 80 00 00 	movabs $0x800afd,%rax
  800718:	00 00 00 
  80071b:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80071d:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800723:	48 98                	cltq   
  800725:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80072c:	48 83 c2 08          	add    $0x8,%rdx
  800730:	48 89 c6             	mov    %rax,%rsi
  800733:	48 89 d7             	mov    %rdx,%rdi
  800736:	48 b8 81 1c 80 00 00 	movabs $0x801c81,%rax
  80073d:	00 00 00 
  800740:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800742:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800748:	c9                   	leaveq 
  800749:	c3                   	retq   

000000000080074a <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80074a:	55                   	push   %rbp
  80074b:	48 89 e5             	mov    %rsp,%rbp
  80074e:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800755:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80075c:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800763:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80076a:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800771:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800778:	84 c0                	test   %al,%al
  80077a:	74 20                	je     80079c <cprintf+0x52>
  80077c:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800780:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800784:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800788:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80078c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800790:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800794:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800798:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  80079c:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8007a3:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8007aa:	00 00 00 
  8007ad:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8007b4:	00 00 00 
  8007b7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8007bb:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8007c2:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8007c9:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8007d0:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8007d7:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8007de:	48 8b 0a             	mov    (%rdx),%rcx
  8007e1:	48 89 08             	mov    %rcx,(%rax)
  8007e4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8007e8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8007ec:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007f0:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8007f4:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8007fb:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800802:	48 89 d6             	mov    %rdx,%rsi
  800805:	48 89 c7             	mov    %rax,%rdi
  800808:	48 b8 9e 06 80 00 00 	movabs $0x80069e,%rax
  80080f:	00 00 00 
  800812:	ff d0                	callq  *%rax
  800814:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80081a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800820:	c9                   	leaveq 
  800821:	c3                   	retq   

0000000000800822 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800822:	55                   	push   %rbp
  800823:	48 89 e5             	mov    %rsp,%rbp
  800826:	53                   	push   %rbx
  800827:	48 83 ec 38          	sub    $0x38,%rsp
  80082b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80082f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800833:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  800837:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  80083a:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80083e:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800842:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  800845:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800849:	77 3b                	ja     800886 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80084b:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80084e:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  800852:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  800855:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800859:	ba 00 00 00 00       	mov    $0x0,%edx
  80085e:	48 f7 f3             	div    %rbx
  800861:	48 89 c2             	mov    %rax,%rdx
  800864:	8b 7d cc             	mov    -0x34(%rbp),%edi
  800867:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  80086a:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80086e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800872:	41 89 f9             	mov    %edi,%r9d
  800875:	48 89 c7             	mov    %rax,%rdi
  800878:	48 b8 22 08 80 00 00 	movabs $0x800822,%rax
  80087f:	00 00 00 
  800882:	ff d0                	callq  *%rax
  800884:	eb 1e                	jmp    8008a4 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800886:	eb 12                	jmp    80089a <printnum+0x78>
			putch(padc, putdat);
  800888:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80088c:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80088f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800893:	48 89 ce             	mov    %rcx,%rsi
  800896:	89 d7                	mov    %edx,%edi
  800898:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80089a:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  80089e:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8008a2:	7f e4                	jg     800888 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008a4:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8008a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8008b0:	48 f7 f1             	div    %rcx
  8008b3:	48 89 d0             	mov    %rdx,%rax
  8008b6:	48 ba 10 3f 80 00 00 	movabs $0x803f10,%rdx
  8008bd:	00 00 00 
  8008c0:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8008c4:	0f be d0             	movsbl %al,%edx
  8008c7:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8008cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008cf:	48 89 ce             	mov    %rcx,%rsi
  8008d2:	89 d7                	mov    %edx,%edi
  8008d4:	ff d0                	callq  *%rax
}
  8008d6:	48 83 c4 38          	add    $0x38,%rsp
  8008da:	5b                   	pop    %rbx
  8008db:	5d                   	pop    %rbp
  8008dc:	c3                   	retq   

00000000008008dd <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008dd:	55                   	push   %rbp
  8008de:	48 89 e5             	mov    %rsp,%rbp
  8008e1:	48 83 ec 1c          	sub    $0x1c,%rsp
  8008e5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8008e9:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8008ec:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8008f0:	7e 52                	jle    800944 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  8008f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f6:	8b 00                	mov    (%rax),%eax
  8008f8:	83 f8 30             	cmp    $0x30,%eax
  8008fb:	73 24                	jae    800921 <getuint+0x44>
  8008fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800901:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800905:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800909:	8b 00                	mov    (%rax),%eax
  80090b:	89 c0                	mov    %eax,%eax
  80090d:	48 01 d0             	add    %rdx,%rax
  800910:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800914:	8b 12                	mov    (%rdx),%edx
  800916:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800919:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80091d:	89 0a                	mov    %ecx,(%rdx)
  80091f:	eb 17                	jmp    800938 <getuint+0x5b>
  800921:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800925:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800929:	48 89 d0             	mov    %rdx,%rax
  80092c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800930:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800934:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800938:	48 8b 00             	mov    (%rax),%rax
  80093b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80093f:	e9 a3 00 00 00       	jmpq   8009e7 <getuint+0x10a>
	else if (lflag)
  800944:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800948:	74 4f                	je     800999 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  80094a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80094e:	8b 00                	mov    (%rax),%eax
  800950:	83 f8 30             	cmp    $0x30,%eax
  800953:	73 24                	jae    800979 <getuint+0x9c>
  800955:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800959:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80095d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800961:	8b 00                	mov    (%rax),%eax
  800963:	89 c0                	mov    %eax,%eax
  800965:	48 01 d0             	add    %rdx,%rax
  800968:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80096c:	8b 12                	mov    (%rdx),%edx
  80096e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800971:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800975:	89 0a                	mov    %ecx,(%rdx)
  800977:	eb 17                	jmp    800990 <getuint+0xb3>
  800979:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80097d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800981:	48 89 d0             	mov    %rdx,%rax
  800984:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800988:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80098c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800990:	48 8b 00             	mov    (%rax),%rax
  800993:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800997:	eb 4e                	jmp    8009e7 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  800999:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80099d:	8b 00                	mov    (%rax),%eax
  80099f:	83 f8 30             	cmp    $0x30,%eax
  8009a2:	73 24                	jae    8009c8 <getuint+0xeb>
  8009a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b0:	8b 00                	mov    (%rax),%eax
  8009b2:	89 c0                	mov    %eax,%eax
  8009b4:	48 01 d0             	add    %rdx,%rax
  8009b7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009bb:	8b 12                	mov    (%rdx),%edx
  8009bd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009c0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009c4:	89 0a                	mov    %ecx,(%rdx)
  8009c6:	eb 17                	jmp    8009df <getuint+0x102>
  8009c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009cc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8009d0:	48 89 d0             	mov    %rdx,%rax
  8009d3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8009d7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009db:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009df:	8b 00                	mov    (%rax),%eax
  8009e1:	89 c0                	mov    %eax,%eax
  8009e3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8009e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8009eb:	c9                   	leaveq 
  8009ec:	c3                   	retq   

00000000008009ed <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009ed:	55                   	push   %rbp
  8009ee:	48 89 e5             	mov    %rsp,%rbp
  8009f1:	48 83 ec 1c          	sub    $0x1c,%rsp
  8009f5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8009f9:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8009fc:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800a00:	7e 52                	jle    800a54 <getint+0x67>
		x=va_arg(*ap, long long);
  800a02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a06:	8b 00                	mov    (%rax),%eax
  800a08:	83 f8 30             	cmp    $0x30,%eax
  800a0b:	73 24                	jae    800a31 <getint+0x44>
  800a0d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a11:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a15:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a19:	8b 00                	mov    (%rax),%eax
  800a1b:	89 c0                	mov    %eax,%eax
  800a1d:	48 01 d0             	add    %rdx,%rax
  800a20:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a24:	8b 12                	mov    (%rdx),%edx
  800a26:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a29:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a2d:	89 0a                	mov    %ecx,(%rdx)
  800a2f:	eb 17                	jmp    800a48 <getint+0x5b>
  800a31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a35:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a39:	48 89 d0             	mov    %rdx,%rax
  800a3c:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a40:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a44:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a48:	48 8b 00             	mov    (%rax),%rax
  800a4b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a4f:	e9 a3 00 00 00       	jmpq   800af7 <getint+0x10a>
	else if (lflag)
  800a54:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a58:	74 4f                	je     800aa9 <getint+0xbc>
		x=va_arg(*ap, long);
  800a5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a5e:	8b 00                	mov    (%rax),%eax
  800a60:	83 f8 30             	cmp    $0x30,%eax
  800a63:	73 24                	jae    800a89 <getint+0x9c>
  800a65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a69:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a6d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a71:	8b 00                	mov    (%rax),%eax
  800a73:	89 c0                	mov    %eax,%eax
  800a75:	48 01 d0             	add    %rdx,%rax
  800a78:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a7c:	8b 12                	mov    (%rdx),%edx
  800a7e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a81:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a85:	89 0a                	mov    %ecx,(%rdx)
  800a87:	eb 17                	jmp    800aa0 <getint+0xb3>
  800a89:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a8d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800a91:	48 89 d0             	mov    %rdx,%rax
  800a94:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800a98:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a9c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800aa0:	48 8b 00             	mov    (%rax),%rax
  800aa3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800aa7:	eb 4e                	jmp    800af7 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  800aa9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aad:	8b 00                	mov    (%rax),%eax
  800aaf:	83 f8 30             	cmp    $0x30,%eax
  800ab2:	73 24                	jae    800ad8 <getint+0xeb>
  800ab4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ab8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800abc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ac0:	8b 00                	mov    (%rax),%eax
  800ac2:	89 c0                	mov    %eax,%eax
  800ac4:	48 01 d0             	add    %rdx,%rax
  800ac7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800acb:	8b 12                	mov    (%rdx),%edx
  800acd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ad0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ad4:	89 0a                	mov    %ecx,(%rdx)
  800ad6:	eb 17                	jmp    800aef <getint+0x102>
  800ad8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800adc:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800ae0:	48 89 d0             	mov    %rdx,%rax
  800ae3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  800ae7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aeb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800aef:	8b 00                	mov    (%rax),%eax
  800af1:	48 98                	cltq   
  800af3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800af7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800afb:	c9                   	leaveq 
  800afc:	c3                   	retq   

0000000000800afd <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800afd:	55                   	push   %rbp
  800afe:	48 89 e5             	mov    %rsp,%rbp
  800b01:	41 54                	push   %r12
  800b03:	53                   	push   %rbx
  800b04:	48 83 ec 60          	sub    $0x60,%rsp
  800b08:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800b0c:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800b10:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b14:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800b18:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b1c:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800b20:	48 8b 0a             	mov    (%rdx),%rcx
  800b23:	48 89 08             	mov    %rcx,(%rax)
  800b26:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800b2a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800b2e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800b32:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b36:	eb 28                	jmp    800b60 <vprintfmt+0x63>
			if (ch == '\0'){
  800b38:	85 db                	test   %ebx,%ebx
  800b3a:	75 15                	jne    800b51 <vprintfmt+0x54>
				current_color=WHITE;
  800b3c:	48 b8 10 74 80 00 00 	movabs $0x807410,%rax
  800b43:	00 00 00 
  800b46:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  800b4c:	e9 fc 04 00 00       	jmpq   80104d <vprintfmt+0x550>
				return;
			}
				
			putch(ch, putdat);
  800b51:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b55:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b59:	48 89 d6             	mov    %rdx,%rsi
  800b5c:	89 df                	mov    %ebx,%edi
  800b5e:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b60:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b64:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b68:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b6c:	0f b6 00             	movzbl (%rax),%eax
  800b6f:	0f b6 d8             	movzbl %al,%ebx
  800b72:	83 fb 25             	cmp    $0x25,%ebx
  800b75:	75 c1                	jne    800b38 <vprintfmt+0x3b>
				
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b77:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800b7b:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800b82:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800b89:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800b90:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b97:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b9b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b9f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800ba3:	0f b6 00             	movzbl (%rax),%eax
  800ba6:	0f b6 d8             	movzbl %al,%ebx
  800ba9:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800bac:	83 f8 55             	cmp    $0x55,%eax
  800baf:	0f 87 64 04 00 00    	ja     801019 <vprintfmt+0x51c>
  800bb5:	89 c0                	mov    %eax,%eax
  800bb7:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800bbe:	00 
  800bbf:	48 b8 38 3f 80 00 00 	movabs $0x803f38,%rax
  800bc6:	00 00 00 
  800bc9:	48 01 d0             	add    %rdx,%rax
  800bcc:	48 8b 00             	mov    (%rax),%rax
  800bcf:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800bd1:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800bd5:	eb c0                	jmp    800b97 <vprintfmt+0x9a>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bd7:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800bdb:	eb ba                	jmp    800b97 <vprintfmt+0x9a>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bdd:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800be4:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800be7:	89 d0                	mov    %edx,%eax
  800be9:	c1 e0 02             	shl    $0x2,%eax
  800bec:	01 d0                	add    %edx,%eax
  800bee:	01 c0                	add    %eax,%eax
  800bf0:	01 d8                	add    %ebx,%eax
  800bf2:	83 e8 30             	sub    $0x30,%eax
  800bf5:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800bf8:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bfc:	0f b6 00             	movzbl (%rax),%eax
  800bff:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c02:	83 fb 2f             	cmp    $0x2f,%ebx
  800c05:	7e 0c                	jle    800c13 <vprintfmt+0x116>
  800c07:	83 fb 39             	cmp    $0x39,%ebx
  800c0a:	7f 07                	jg     800c13 <vprintfmt+0x116>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c0c:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c11:	eb d1                	jmp    800be4 <vprintfmt+0xe7>
			goto process_precision;
  800c13:	eb 58                	jmp    800c6d <vprintfmt+0x170>

		case '*':
			precision = va_arg(aq, int);
  800c15:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c18:	83 f8 30             	cmp    $0x30,%eax
  800c1b:	73 17                	jae    800c34 <vprintfmt+0x137>
  800c1d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c21:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c24:	89 c0                	mov    %eax,%eax
  800c26:	48 01 d0             	add    %rdx,%rax
  800c29:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c2c:	83 c2 08             	add    $0x8,%edx
  800c2f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c32:	eb 0f                	jmp    800c43 <vprintfmt+0x146>
  800c34:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800c38:	48 89 d0             	mov    %rdx,%rax
  800c3b:	48 83 c2 08          	add    $0x8,%rdx
  800c3f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c43:	8b 00                	mov    (%rax),%eax
  800c45:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800c48:	eb 23                	jmp    800c6d <vprintfmt+0x170>

		case '.':
			if (width < 0)
  800c4a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c4e:	79 0c                	jns    800c5c <vprintfmt+0x15f>
				width = 0;
  800c50:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800c57:	e9 3b ff ff ff       	jmpq   800b97 <vprintfmt+0x9a>
  800c5c:	e9 36 ff ff ff       	jmpq   800b97 <vprintfmt+0x9a>

		case '#':
			altflag = 1;
  800c61:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800c68:	e9 2a ff ff ff       	jmpq   800b97 <vprintfmt+0x9a>

		process_precision:
			if (width < 0)
  800c6d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800c71:	79 12                	jns    800c85 <vprintfmt+0x188>
				width = precision, precision = -1;
  800c73:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800c76:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800c79:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800c80:	e9 12 ff ff ff       	jmpq   800b97 <vprintfmt+0x9a>
  800c85:	e9 0d ff ff ff       	jmpq   800b97 <vprintfmt+0x9a>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c8a:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800c8e:	e9 04 ff ff ff       	jmpq   800b97 <vprintfmt+0x9a>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800c93:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c96:	83 f8 30             	cmp    $0x30,%eax
  800c99:	73 17                	jae    800cb2 <vprintfmt+0x1b5>
  800c9b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800c9f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ca2:	89 c0                	mov    %eax,%eax
  800ca4:	48 01 d0             	add    %rdx,%rax
  800ca7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800caa:	83 c2 08             	add    $0x8,%edx
  800cad:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cb0:	eb 0f                	jmp    800cc1 <vprintfmt+0x1c4>
  800cb2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cb6:	48 89 d0             	mov    %rdx,%rax
  800cb9:	48 83 c2 08          	add    $0x8,%rdx
  800cbd:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cc1:	8b 10                	mov    (%rax),%edx
  800cc3:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800cc7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ccb:	48 89 ce             	mov    %rcx,%rsi
  800cce:	89 d7                	mov    %edx,%edi
  800cd0:	ff d0                	callq  *%rax
			break;
  800cd2:	e9 70 03 00 00       	jmpq   801047 <vprintfmt+0x54a>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800cd7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800cda:	83 f8 30             	cmp    $0x30,%eax
  800cdd:	73 17                	jae    800cf6 <vprintfmt+0x1f9>
  800cdf:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800ce3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ce6:	89 c0                	mov    %eax,%eax
  800ce8:	48 01 d0             	add    %rdx,%rax
  800ceb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cee:	83 c2 08             	add    $0x8,%edx
  800cf1:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cf4:	eb 0f                	jmp    800d05 <vprintfmt+0x208>
  800cf6:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800cfa:	48 89 d0             	mov    %rdx,%rax
  800cfd:	48 83 c2 08          	add    $0x8,%rdx
  800d01:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d05:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800d07:	85 db                	test   %ebx,%ebx
  800d09:	79 02                	jns    800d0d <vprintfmt+0x210>
				err = -err;
  800d0b:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800d0d:	83 fb 15             	cmp    $0x15,%ebx
  800d10:	7f 16                	jg     800d28 <vprintfmt+0x22b>
  800d12:	48 b8 60 3e 80 00 00 	movabs $0x803e60,%rax
  800d19:	00 00 00 
  800d1c:	48 63 d3             	movslq %ebx,%rdx
  800d1f:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800d23:	4d 85 e4             	test   %r12,%r12
  800d26:	75 2e                	jne    800d56 <vprintfmt+0x259>
				printfmt(putch, putdat, "error %d", err);
  800d28:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d2c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d30:	89 d9                	mov    %ebx,%ecx
  800d32:	48 ba 21 3f 80 00 00 	movabs $0x803f21,%rdx
  800d39:	00 00 00 
  800d3c:	48 89 c7             	mov    %rax,%rdi
  800d3f:	b8 00 00 00 00       	mov    $0x0,%eax
  800d44:	49 b8 56 10 80 00 00 	movabs $0x801056,%r8
  800d4b:	00 00 00 
  800d4e:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d51:	e9 f1 02 00 00       	jmpq   801047 <vprintfmt+0x54a>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d56:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d5a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d5e:	4c 89 e1             	mov    %r12,%rcx
  800d61:	48 ba 2a 3f 80 00 00 	movabs $0x803f2a,%rdx
  800d68:	00 00 00 
  800d6b:	48 89 c7             	mov    %rax,%rdi
  800d6e:	b8 00 00 00 00       	mov    $0x0,%eax
  800d73:	49 b8 56 10 80 00 00 	movabs $0x801056,%r8
  800d7a:	00 00 00 
  800d7d:	41 ff d0             	callq  *%r8
			break;
  800d80:	e9 c2 02 00 00       	jmpq   801047 <vprintfmt+0x54a>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800d85:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d88:	83 f8 30             	cmp    $0x30,%eax
  800d8b:	73 17                	jae    800da4 <vprintfmt+0x2a7>
  800d8d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800d91:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d94:	89 c0                	mov    %eax,%eax
  800d96:	48 01 d0             	add    %rdx,%rax
  800d99:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d9c:	83 c2 08             	add    $0x8,%edx
  800d9f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800da2:	eb 0f                	jmp    800db3 <vprintfmt+0x2b6>
  800da4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800da8:	48 89 d0             	mov    %rdx,%rax
  800dab:	48 83 c2 08          	add    $0x8,%rdx
  800daf:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800db3:	4c 8b 20             	mov    (%rax),%r12
  800db6:	4d 85 e4             	test   %r12,%r12
  800db9:	75 0a                	jne    800dc5 <vprintfmt+0x2c8>
				p = "(null)";
  800dbb:	49 bc 2d 3f 80 00 00 	movabs $0x803f2d,%r12
  800dc2:	00 00 00 
			if (width > 0 && padc != '-')
  800dc5:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800dc9:	7e 3f                	jle    800e0a <vprintfmt+0x30d>
  800dcb:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800dcf:	74 39                	je     800e0a <vprintfmt+0x30d>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dd1:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800dd4:	48 98                	cltq   
  800dd6:	48 89 c6             	mov    %rax,%rsi
  800dd9:	4c 89 e7             	mov    %r12,%rdi
  800ddc:	48 b8 5c 14 80 00 00 	movabs $0x80145c,%rax
  800de3:	00 00 00 
  800de6:	ff d0                	callq  *%rax
  800de8:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800deb:	eb 17                	jmp    800e04 <vprintfmt+0x307>
					putch(padc, putdat);
  800ded:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800df1:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800df5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800df9:	48 89 ce             	mov    %rcx,%rsi
  800dfc:	89 d7                	mov    %edx,%edi
  800dfe:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e00:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e04:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e08:	7f e3                	jg     800ded <vprintfmt+0x2f0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e0a:	eb 37                	jmp    800e43 <vprintfmt+0x346>
				if (altflag && (ch < ' ' || ch > '~'))
  800e0c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800e10:	74 1e                	je     800e30 <vprintfmt+0x333>
  800e12:	83 fb 1f             	cmp    $0x1f,%ebx
  800e15:	7e 05                	jle    800e1c <vprintfmt+0x31f>
  800e17:	83 fb 7e             	cmp    $0x7e,%ebx
  800e1a:	7e 14                	jle    800e30 <vprintfmt+0x333>
					putch('?', putdat);
  800e1c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e20:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e24:	48 89 d6             	mov    %rdx,%rsi
  800e27:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800e2c:	ff d0                	callq  *%rax
  800e2e:	eb 0f                	jmp    800e3f <vprintfmt+0x342>
				else
					putch(ch, putdat);
  800e30:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e34:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e38:	48 89 d6             	mov    %rdx,%rsi
  800e3b:	89 df                	mov    %ebx,%edi
  800e3d:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e3f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e43:	4c 89 e0             	mov    %r12,%rax
  800e46:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800e4a:	0f b6 00             	movzbl (%rax),%eax
  800e4d:	0f be d8             	movsbl %al,%ebx
  800e50:	85 db                	test   %ebx,%ebx
  800e52:	74 10                	je     800e64 <vprintfmt+0x367>
  800e54:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e58:	78 b2                	js     800e0c <vprintfmt+0x30f>
  800e5a:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800e5e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800e62:	79 a8                	jns    800e0c <vprintfmt+0x30f>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e64:	eb 16                	jmp    800e7c <vprintfmt+0x37f>
				putch(' ', putdat);
  800e66:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e6a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e6e:	48 89 d6             	mov    %rdx,%rsi
  800e71:	bf 20 00 00 00       	mov    $0x20,%edi
  800e76:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e78:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e7c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e80:	7f e4                	jg     800e66 <vprintfmt+0x369>
				putch(' ', putdat);
			break;
  800e82:	e9 c0 01 00 00       	jmpq   801047 <vprintfmt+0x54a>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800e87:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e8b:	be 03 00 00 00       	mov    $0x3,%esi
  800e90:	48 89 c7             	mov    %rax,%rdi
  800e93:	48 b8 ed 09 80 00 00 	movabs $0x8009ed,%rax
  800e9a:	00 00 00 
  800e9d:	ff d0                	callq  *%rax
  800e9f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800ea3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ea7:	48 85 c0             	test   %rax,%rax
  800eaa:	79 1d                	jns    800ec9 <vprintfmt+0x3cc>
				putch('-', putdat);
  800eac:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800eb0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eb4:	48 89 d6             	mov    %rdx,%rsi
  800eb7:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800ebc:	ff d0                	callq  *%rax
				num = -(long long) num;
  800ebe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ec2:	48 f7 d8             	neg    %rax
  800ec5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800ec9:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ed0:	e9 d5 00 00 00       	jmpq   800faa <vprintfmt+0x4ad>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800ed5:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ed9:	be 03 00 00 00       	mov    $0x3,%esi
  800ede:	48 89 c7             	mov    %rax,%rdi
  800ee1:	48 b8 dd 08 80 00 00 	movabs $0x8008dd,%rax
  800ee8:	00 00 00 
  800eeb:	ff d0                	callq  *%rax
  800eed:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ef1:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ef8:	e9 ad 00 00 00       	jmpq   800faa <vprintfmt+0x4ad>
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			// break;
			num = getuint(&aq, 3);
  800efd:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f01:	be 03 00 00 00       	mov    $0x3,%esi
  800f06:	48 89 c7             	mov    %rax,%rdi
  800f09:	48 b8 dd 08 80 00 00 	movabs $0x8008dd,%rax
  800f10:	00 00 00 
  800f13:	ff d0                	callq  *%rax
  800f15:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800f19:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800f20:	e9 85 00 00 00       	jmpq   800faa <vprintfmt+0x4ad>

			// pointer
		case 'p':
			putch('0', putdat);
  800f25:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f29:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f2d:	48 89 d6             	mov    %rdx,%rsi
  800f30:	bf 30 00 00 00       	mov    $0x30,%edi
  800f35:	ff d0                	callq  *%rax
			putch('x', putdat);
  800f37:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f3b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f3f:	48 89 d6             	mov    %rdx,%rsi
  800f42:	bf 78 00 00 00       	mov    $0x78,%edi
  800f47:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800f49:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f4c:	83 f8 30             	cmp    $0x30,%eax
  800f4f:	73 17                	jae    800f68 <vprintfmt+0x46b>
  800f51:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800f55:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800f58:	89 c0                	mov    %eax,%eax
  800f5a:	48 01 d0             	add    %rdx,%rax
  800f5d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800f60:	83 c2 08             	add    $0x8,%edx
  800f63:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f66:	eb 0f                	jmp    800f77 <vprintfmt+0x47a>
				(uintptr_t) va_arg(aq, void *);
  800f68:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  800f6c:	48 89 d0             	mov    %rdx,%rax
  800f6f:	48 83 c2 08          	add    $0x8,%rdx
  800f73:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800f77:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f7a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800f7e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800f85:	eb 23                	jmp    800faa <vprintfmt+0x4ad>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800f87:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f8b:	be 03 00 00 00       	mov    $0x3,%esi
  800f90:	48 89 c7             	mov    %rax,%rdi
  800f93:	48 b8 dd 08 80 00 00 	movabs $0x8008dd,%rax
  800f9a:	00 00 00 
  800f9d:	ff d0                	callq  *%rax
  800f9f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800fa3:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800faa:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800faf:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800fb2:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800fb5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fb9:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800fbd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fc1:	45 89 c1             	mov    %r8d,%r9d
  800fc4:	41 89 f8             	mov    %edi,%r8d
  800fc7:	48 89 c7             	mov    %rax,%rdi
  800fca:	48 b8 22 08 80 00 00 	movabs $0x800822,%rax
  800fd1:	00 00 00 
  800fd4:	ff d0                	callq  *%rax
			break;
  800fd6:	eb 6f                	jmp    801047 <vprintfmt+0x54a>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fd8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fdc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fe0:	48 89 d6             	mov    %rdx,%rsi
  800fe3:	89 df                	mov    %ebx,%edi
  800fe5:	ff d0                	callq  *%rax
			break;
  800fe7:	eb 5e                	jmp    801047 <vprintfmt+0x54a>
		
		case 'C':
		    num=getuint(&aq,3);		
  800fe9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800fed:	be 03 00 00 00       	mov    $0x3,%esi
  800ff2:	48 89 c7             	mov    %rax,%rdi
  800ff5:	48 b8 dd 08 80 00 00 	movabs $0x8008dd,%rax
  800ffc:	00 00 00 
  800fff:	ff d0                	callq  *%rax
  801001:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			current_color=num;
  801005:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801009:	89 c2                	mov    %eax,%edx
  80100b:	48 b8 10 74 80 00 00 	movabs $0x807410,%rax
  801012:	00 00 00 
  801015:	89 10                	mov    %edx,(%rax)
			break;
  801017:	eb 2e                	jmp    801047 <vprintfmt+0x54a>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801019:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80101d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801021:	48 89 d6             	mov    %rdx,%rsi
  801024:	bf 25 00 00 00       	mov    $0x25,%edi
  801029:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  80102b:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801030:	eb 05                	jmp    801037 <vprintfmt+0x53a>
  801032:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801037:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80103b:	48 83 e8 01          	sub    $0x1,%rax
  80103f:	0f b6 00             	movzbl (%rax),%eax
  801042:	3c 25                	cmp    $0x25,%al
  801044:	75 ec                	jne    801032 <vprintfmt+0x535>
				/* do nothing */;
			break;
  801046:	90                   	nop
		}
	}
  801047:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801048:	e9 13 fb ff ff       	jmpq   800b60 <vprintfmt+0x63>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  80104d:	48 83 c4 60          	add    $0x60,%rsp
  801051:	5b                   	pop    %rbx
  801052:	41 5c                	pop    %r12
  801054:	5d                   	pop    %rbp
  801055:	c3                   	retq   

0000000000801056 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801056:	55                   	push   %rbp
  801057:	48 89 e5             	mov    %rsp,%rbp
  80105a:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801061:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801068:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80106f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801076:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80107d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801084:	84 c0                	test   %al,%al
  801086:	74 20                	je     8010a8 <printfmt+0x52>
  801088:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80108c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801090:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801094:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801098:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80109c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8010a0:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8010a4:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8010a8:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8010af:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8010b6:	00 00 00 
  8010b9:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8010c0:	00 00 00 
  8010c3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8010c7:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8010ce:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8010d5:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8010dc:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8010e3:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8010ea:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8010f1:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8010f8:	48 89 c7             	mov    %rax,%rdi
  8010fb:	48 b8 fd 0a 80 00 00 	movabs $0x800afd,%rax
  801102:	00 00 00 
  801105:	ff d0                	callq  *%rax
	va_end(ap);
}
  801107:	c9                   	leaveq 
  801108:	c3                   	retq   

0000000000801109 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801109:	55                   	push   %rbp
  80110a:	48 89 e5             	mov    %rsp,%rbp
  80110d:	48 83 ec 10          	sub    $0x10,%rsp
  801111:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801114:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801118:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80111c:	8b 40 10             	mov    0x10(%rax),%eax
  80111f:	8d 50 01             	lea    0x1(%rax),%edx
  801122:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801126:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801129:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80112d:	48 8b 10             	mov    (%rax),%rdx
  801130:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801134:	48 8b 40 08          	mov    0x8(%rax),%rax
  801138:	48 39 c2             	cmp    %rax,%rdx
  80113b:	73 17                	jae    801154 <sprintputch+0x4b>
		*b->buf++ = ch;
  80113d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801141:	48 8b 00             	mov    (%rax),%rax
  801144:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801148:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80114c:	48 89 0a             	mov    %rcx,(%rdx)
  80114f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801152:	88 10                	mov    %dl,(%rax)
}
  801154:	c9                   	leaveq 
  801155:	c3                   	retq   

0000000000801156 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801156:	55                   	push   %rbp
  801157:	48 89 e5             	mov    %rsp,%rbp
  80115a:	48 83 ec 50          	sub    $0x50,%rsp
  80115e:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801162:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801165:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801169:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80116d:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801171:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801175:	48 8b 0a             	mov    (%rdx),%rcx
  801178:	48 89 08             	mov    %rcx,(%rax)
  80117b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80117f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801183:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801187:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80118b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80118f:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801193:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801196:	48 98                	cltq   
  801198:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80119c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8011a0:	48 01 d0             	add    %rdx,%rax
  8011a3:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8011a7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8011ae:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8011b3:	74 06                	je     8011bb <vsnprintf+0x65>
  8011b5:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8011b9:	7f 07                	jg     8011c2 <vsnprintf+0x6c>
		return -E_INVAL;
  8011bb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011c0:	eb 2f                	jmp    8011f1 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8011c2:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8011c6:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8011ca:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8011ce:	48 89 c6             	mov    %rax,%rsi
  8011d1:	48 bf 09 11 80 00 00 	movabs $0x801109,%rdi
  8011d8:	00 00 00 
  8011db:	48 b8 fd 0a 80 00 00 	movabs $0x800afd,%rax
  8011e2:	00 00 00 
  8011e5:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8011e7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8011eb:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8011ee:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8011f1:	c9                   	leaveq 
  8011f2:	c3                   	retq   

00000000008011f3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011f3:	55                   	push   %rbp
  8011f4:	48 89 e5             	mov    %rsp,%rbp
  8011f7:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8011fe:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801205:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  80120b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801212:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801219:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801220:	84 c0                	test   %al,%al
  801222:	74 20                	je     801244 <snprintf+0x51>
  801224:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801228:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80122c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801230:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801234:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801238:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80123c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801240:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801244:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  80124b:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801252:	00 00 00 
  801255:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80125c:	00 00 00 
  80125f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801263:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80126a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801271:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801278:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80127f:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801286:	48 8b 0a             	mov    (%rdx),%rcx
  801289:	48 89 08             	mov    %rcx,(%rax)
  80128c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801290:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801294:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801298:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80129c:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8012a3:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8012aa:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8012b0:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8012b7:	48 89 c7             	mov    %rax,%rdi
  8012ba:	48 b8 56 11 80 00 00 	movabs $0x801156,%rax
  8012c1:	00 00 00 
  8012c4:	ff d0                	callq  *%rax
  8012c6:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8012cc:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8012d2:	c9                   	leaveq 
  8012d3:	c3                   	retq   

00000000008012d4 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  8012d4:	55                   	push   %rbp
  8012d5:	48 89 e5             	mov    %rsp,%rbp
  8012d8:	48 83 ec 20          	sub    $0x20,%rsp
  8012dc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  8012e0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8012e5:	74 27                	je     80130e <readline+0x3a>
		fprintf(1, "%s", prompt);
  8012e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012eb:	48 89 c2             	mov    %rax,%rdx
  8012ee:	48 be e8 41 80 00 00 	movabs $0x8041e8,%rsi
  8012f5:	00 00 00 
  8012f8:	bf 01 00 00 00       	mov    $0x1,%edi
  8012fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801302:	48 b9 5e 32 80 00 00 	movabs $0x80325e,%rcx
  801309:	00 00 00 
  80130c:	ff d1                	callq  *%rcx
#endif

	i = 0;
  80130e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	echoing = iscons(0);
  801315:	bf 00 00 00 00       	mov    $0x0,%edi
  80131a:	48 b8 2c 02 80 00 00 	movabs $0x80022c,%rax
  801321:	00 00 00 
  801324:	ff d0                	callq  *%rax
  801326:	89 45 f8             	mov    %eax,-0x8(%rbp)
	while (1) {
		c = getchar();
  801329:	48 b8 e3 01 80 00 00 	movabs $0x8001e3,%rax
  801330:	00 00 00 
  801333:	ff d0                	callq  *%rax
  801335:	89 45 f4             	mov    %eax,-0xc(%rbp)
		if (c < 0) {
  801338:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80133c:	79 30                	jns    80136e <readline+0x9a>
			if (c != -E_EOF)
  80133e:	83 7d f4 f7          	cmpl   $0xfffffff7,-0xc(%rbp)
  801342:	74 20                	je     801364 <readline+0x90>
				cprintf("read error: %e\n", c);
  801344:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801347:	89 c6                	mov    %eax,%esi
  801349:	48 bf eb 41 80 00 00 	movabs $0x8041eb,%rdi
  801350:	00 00 00 
  801353:	b8 00 00 00 00       	mov    $0x0,%eax
  801358:	48 ba 4a 07 80 00 00 	movabs $0x80074a,%rdx
  80135f:	00 00 00 
  801362:	ff d2                	callq  *%rdx
			return NULL;
  801364:	b8 00 00 00 00       	mov    $0x0,%eax
  801369:	e9 be 00 00 00       	jmpq   80142c <readline+0x158>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  80136e:	83 7d f4 08          	cmpl   $0x8,-0xc(%rbp)
  801372:	74 06                	je     80137a <readline+0xa6>
  801374:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%rbp)
  801378:	75 26                	jne    8013a0 <readline+0xcc>
  80137a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80137e:	7e 20                	jle    8013a0 <readline+0xcc>
			if (echoing)
  801380:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801384:	74 11                	je     801397 <readline+0xc3>
				cputchar('\b');
  801386:	bf 08 00 00 00       	mov    $0x8,%edi
  80138b:	48 b8 b8 01 80 00 00 	movabs $0x8001b8,%rax
  801392:	00 00 00 
  801395:	ff d0                	callq  *%rax
			i--;
  801397:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
  80139b:	e9 87 00 00 00       	jmpq   801427 <readline+0x153>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8013a0:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%rbp)
  8013a4:	7e 3f                	jle    8013e5 <readline+0x111>
  8013a6:	81 7d fc fe 03 00 00 	cmpl   $0x3fe,-0x4(%rbp)
  8013ad:	7f 36                	jg     8013e5 <readline+0x111>
			if (echoing)
  8013af:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8013b3:	74 11                	je     8013c6 <readline+0xf2>
				cputchar(c);
  8013b5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8013b8:	89 c7                	mov    %eax,%edi
  8013ba:	48 b8 b8 01 80 00 00 	movabs $0x8001b8,%rax
  8013c1:	00 00 00 
  8013c4:	ff d0                	callq  *%rax
			buf[i++] = c;
  8013c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8013c9:	8d 50 01             	lea    0x1(%rax),%edx
  8013cc:	89 55 fc             	mov    %edx,-0x4(%rbp)
  8013cf:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8013d2:	89 d1                	mov    %edx,%ecx
  8013d4:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8013db:	00 00 00 
  8013de:	48 98                	cltq   
  8013e0:	88 0c 02             	mov    %cl,(%rdx,%rax,1)
  8013e3:	eb 42                	jmp    801427 <readline+0x153>
		} else if (c == '\n' || c == '\r') {
  8013e5:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  8013e9:	74 06                	je     8013f1 <readline+0x11d>
  8013eb:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  8013ef:	75 36                	jne    801427 <readline+0x153>
			if (echoing)
  8013f1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8013f5:	74 11                	je     801408 <readline+0x134>
				cputchar('\n');
  8013f7:	bf 0a 00 00 00       	mov    $0xa,%edi
  8013fc:	48 b8 b8 01 80 00 00 	movabs $0x8001b8,%rax
  801403:	00 00 00 
  801406:	ff d0                	callq  *%rax
			buf[i] = 0;
  801408:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  80140f:	00 00 00 
  801412:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801415:	48 98                	cltq   
  801417:	c6 04 02 00          	movb   $0x0,(%rdx,%rax,1)
			return buf;
  80141b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801422:	00 00 00 
  801425:	eb 05                	jmp    80142c <readline+0x158>
		}
	}
  801427:	e9 fd fe ff ff       	jmpq   801329 <readline+0x55>
}
  80142c:	c9                   	leaveq 
  80142d:	c3                   	retq   

000000000080142e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80142e:	55                   	push   %rbp
  80142f:	48 89 e5             	mov    %rsp,%rbp
  801432:	48 83 ec 18          	sub    $0x18,%rsp
  801436:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80143a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801441:	eb 09                	jmp    80144c <strlen+0x1e>
		n++;
  801443:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801447:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80144c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801450:	0f b6 00             	movzbl (%rax),%eax
  801453:	84 c0                	test   %al,%al
  801455:	75 ec                	jne    801443 <strlen+0x15>
		n++;
	return n;
  801457:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80145a:	c9                   	leaveq 
  80145b:	c3                   	retq   

000000000080145c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80145c:	55                   	push   %rbp
  80145d:	48 89 e5             	mov    %rsp,%rbp
  801460:	48 83 ec 20          	sub    $0x20,%rsp
  801464:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801468:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80146c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801473:	eb 0e                	jmp    801483 <strnlen+0x27>
		n++;
  801475:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801479:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80147e:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801483:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801488:	74 0b                	je     801495 <strnlen+0x39>
  80148a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80148e:	0f b6 00             	movzbl (%rax),%eax
  801491:	84 c0                	test   %al,%al
  801493:	75 e0                	jne    801475 <strnlen+0x19>
		n++;
	return n;
  801495:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801498:	c9                   	leaveq 
  801499:	c3                   	retq   

000000000080149a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80149a:	55                   	push   %rbp
  80149b:	48 89 e5             	mov    %rsp,%rbp
  80149e:	48 83 ec 20          	sub    $0x20,%rsp
  8014a2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014a6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8014aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014ae:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8014b2:	90                   	nop
  8014b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014b7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014bb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8014bf:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8014c3:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8014c7:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8014cb:	0f b6 12             	movzbl (%rdx),%edx
  8014ce:	88 10                	mov    %dl,(%rax)
  8014d0:	0f b6 00             	movzbl (%rax),%eax
  8014d3:	84 c0                	test   %al,%al
  8014d5:	75 dc                	jne    8014b3 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8014d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8014db:	c9                   	leaveq 
  8014dc:	c3                   	retq   

00000000008014dd <strcat>:

char *
strcat(char *dst, const char *src)
{
  8014dd:	55                   	push   %rbp
  8014de:	48 89 e5             	mov    %rsp,%rbp
  8014e1:	48 83 ec 20          	sub    $0x20,%rsp
  8014e5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014e9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8014ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014f1:	48 89 c7             	mov    %rax,%rdi
  8014f4:	48 b8 2e 14 80 00 00 	movabs $0x80142e,%rax
  8014fb:	00 00 00 
  8014fe:	ff d0                	callq  *%rax
  801500:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801503:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801506:	48 63 d0             	movslq %eax,%rdx
  801509:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80150d:	48 01 c2             	add    %rax,%rdx
  801510:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801514:	48 89 c6             	mov    %rax,%rsi
  801517:	48 89 d7             	mov    %rdx,%rdi
  80151a:	48 b8 9a 14 80 00 00 	movabs $0x80149a,%rax
  801521:	00 00 00 
  801524:	ff d0                	callq  *%rax
	return dst;
  801526:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80152a:	c9                   	leaveq 
  80152b:	c3                   	retq   

000000000080152c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80152c:	55                   	push   %rbp
  80152d:	48 89 e5             	mov    %rsp,%rbp
  801530:	48 83 ec 28          	sub    $0x28,%rsp
  801534:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801538:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80153c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801540:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801544:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801548:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80154f:	00 
  801550:	eb 2a                	jmp    80157c <strncpy+0x50>
		*dst++ = *src;
  801552:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801556:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80155a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80155e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801562:	0f b6 12             	movzbl (%rdx),%edx
  801565:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801567:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80156b:	0f b6 00             	movzbl (%rax),%eax
  80156e:	84 c0                	test   %al,%al
  801570:	74 05                	je     801577 <strncpy+0x4b>
			src++;
  801572:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801577:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80157c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801580:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801584:	72 cc                	jb     801552 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801586:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80158a:	c9                   	leaveq 
  80158b:	c3                   	retq   

000000000080158c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80158c:	55                   	push   %rbp
  80158d:	48 89 e5             	mov    %rsp,%rbp
  801590:	48 83 ec 28          	sub    $0x28,%rsp
  801594:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801598:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80159c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8015a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015a4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8015a8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8015ad:	74 3d                	je     8015ec <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8015af:	eb 1d                	jmp    8015ce <strlcpy+0x42>
			*dst++ = *src++;
  8015b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015b5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015b9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8015bd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8015c1:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8015c5:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8015c9:	0f b6 12             	movzbl (%rdx),%edx
  8015cc:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8015ce:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8015d3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8015d8:	74 0b                	je     8015e5 <strlcpy+0x59>
  8015da:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015de:	0f b6 00             	movzbl (%rax),%eax
  8015e1:	84 c0                	test   %al,%al
  8015e3:	75 cc                	jne    8015b1 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8015e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015e9:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8015ec:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8015f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015f4:	48 29 c2             	sub    %rax,%rdx
  8015f7:	48 89 d0             	mov    %rdx,%rax
}
  8015fa:	c9                   	leaveq 
  8015fb:	c3                   	retq   

00000000008015fc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8015fc:	55                   	push   %rbp
  8015fd:	48 89 e5             	mov    %rsp,%rbp
  801600:	48 83 ec 10          	sub    $0x10,%rsp
  801604:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801608:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80160c:	eb 0a                	jmp    801618 <strcmp+0x1c>
		p++, q++;
  80160e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801613:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801618:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80161c:	0f b6 00             	movzbl (%rax),%eax
  80161f:	84 c0                	test   %al,%al
  801621:	74 12                	je     801635 <strcmp+0x39>
  801623:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801627:	0f b6 10             	movzbl (%rax),%edx
  80162a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80162e:	0f b6 00             	movzbl (%rax),%eax
  801631:	38 c2                	cmp    %al,%dl
  801633:	74 d9                	je     80160e <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801635:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801639:	0f b6 00             	movzbl (%rax),%eax
  80163c:	0f b6 d0             	movzbl %al,%edx
  80163f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801643:	0f b6 00             	movzbl (%rax),%eax
  801646:	0f b6 c0             	movzbl %al,%eax
  801649:	29 c2                	sub    %eax,%edx
  80164b:	89 d0                	mov    %edx,%eax
}
  80164d:	c9                   	leaveq 
  80164e:	c3                   	retq   

000000000080164f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80164f:	55                   	push   %rbp
  801650:	48 89 e5             	mov    %rsp,%rbp
  801653:	48 83 ec 18          	sub    $0x18,%rsp
  801657:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80165b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80165f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801663:	eb 0f                	jmp    801674 <strncmp+0x25>
		n--, p++, q++;
  801665:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80166a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80166f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801674:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801679:	74 1d                	je     801698 <strncmp+0x49>
  80167b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80167f:	0f b6 00             	movzbl (%rax),%eax
  801682:	84 c0                	test   %al,%al
  801684:	74 12                	je     801698 <strncmp+0x49>
  801686:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80168a:	0f b6 10             	movzbl (%rax),%edx
  80168d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801691:	0f b6 00             	movzbl (%rax),%eax
  801694:	38 c2                	cmp    %al,%dl
  801696:	74 cd                	je     801665 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801698:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80169d:	75 07                	jne    8016a6 <strncmp+0x57>
		return 0;
  80169f:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a4:	eb 18                	jmp    8016be <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8016a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016aa:	0f b6 00             	movzbl (%rax),%eax
  8016ad:	0f b6 d0             	movzbl %al,%edx
  8016b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016b4:	0f b6 00             	movzbl (%rax),%eax
  8016b7:	0f b6 c0             	movzbl %al,%eax
  8016ba:	29 c2                	sub    %eax,%edx
  8016bc:	89 d0                	mov    %edx,%eax
}
  8016be:	c9                   	leaveq 
  8016bf:	c3                   	retq   

00000000008016c0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8016c0:	55                   	push   %rbp
  8016c1:	48 89 e5             	mov    %rsp,%rbp
  8016c4:	48 83 ec 0c          	sub    $0xc,%rsp
  8016c8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016cc:	89 f0                	mov    %esi,%eax
  8016ce:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8016d1:	eb 17                	jmp    8016ea <strchr+0x2a>
		if (*s == c)
  8016d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016d7:	0f b6 00             	movzbl (%rax),%eax
  8016da:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8016dd:	75 06                	jne    8016e5 <strchr+0x25>
			return (char *) s;
  8016df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016e3:	eb 15                	jmp    8016fa <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8016e5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8016ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016ee:	0f b6 00             	movzbl (%rax),%eax
  8016f1:	84 c0                	test   %al,%al
  8016f3:	75 de                	jne    8016d3 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8016f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016fa:	c9                   	leaveq 
  8016fb:	c3                   	retq   

00000000008016fc <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8016fc:	55                   	push   %rbp
  8016fd:	48 89 e5             	mov    %rsp,%rbp
  801700:	48 83 ec 0c          	sub    $0xc,%rsp
  801704:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801708:	89 f0                	mov    %esi,%eax
  80170a:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80170d:	eb 13                	jmp    801722 <strfind+0x26>
		if (*s == c)
  80170f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801713:	0f b6 00             	movzbl (%rax),%eax
  801716:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801719:	75 02                	jne    80171d <strfind+0x21>
			break;
  80171b:	eb 10                	jmp    80172d <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80171d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801722:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801726:	0f b6 00             	movzbl (%rax),%eax
  801729:	84 c0                	test   %al,%al
  80172b:	75 e2                	jne    80170f <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  80172d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801731:	c9                   	leaveq 
  801732:	c3                   	retq   

0000000000801733 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801733:	55                   	push   %rbp
  801734:	48 89 e5             	mov    %rsp,%rbp
  801737:	48 83 ec 18          	sub    $0x18,%rsp
  80173b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80173f:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801742:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801746:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80174b:	75 06                	jne    801753 <memset+0x20>
		return v;
  80174d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801751:	eb 69                	jmp    8017bc <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801753:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801757:	83 e0 03             	and    $0x3,%eax
  80175a:	48 85 c0             	test   %rax,%rax
  80175d:	75 48                	jne    8017a7 <memset+0x74>
  80175f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801763:	83 e0 03             	and    $0x3,%eax
  801766:	48 85 c0             	test   %rax,%rax
  801769:	75 3c                	jne    8017a7 <memset+0x74>
		c &= 0xFF;
  80176b:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801772:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801775:	c1 e0 18             	shl    $0x18,%eax
  801778:	89 c2                	mov    %eax,%edx
  80177a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80177d:	c1 e0 10             	shl    $0x10,%eax
  801780:	09 c2                	or     %eax,%edx
  801782:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801785:	c1 e0 08             	shl    $0x8,%eax
  801788:	09 d0                	or     %edx,%eax
  80178a:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80178d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801791:	48 c1 e8 02          	shr    $0x2,%rax
  801795:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801798:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80179c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80179f:	48 89 d7             	mov    %rdx,%rdi
  8017a2:	fc                   	cld    
  8017a3:	f3 ab                	rep stos %eax,%es:(%rdi)
  8017a5:	eb 11                	jmp    8017b8 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8017a7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017ab:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8017ae:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8017b2:	48 89 d7             	mov    %rdx,%rdi
  8017b5:	fc                   	cld    
  8017b6:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8017b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8017bc:	c9                   	leaveq 
  8017bd:	c3                   	retq   

00000000008017be <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8017be:	55                   	push   %rbp
  8017bf:	48 89 e5             	mov    %rsp,%rbp
  8017c2:	48 83 ec 28          	sub    $0x28,%rsp
  8017c6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017ca:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8017ce:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8017d2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8017d6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8017da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017de:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8017e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017e6:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8017ea:	0f 83 88 00 00 00    	jae    801878 <memmove+0xba>
  8017f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017f8:	48 01 d0             	add    %rdx,%rax
  8017fb:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8017ff:	76 77                	jbe    801878 <memmove+0xba>
		s += n;
  801801:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801805:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801809:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80180d:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801811:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801815:	83 e0 03             	and    $0x3,%eax
  801818:	48 85 c0             	test   %rax,%rax
  80181b:	75 3b                	jne    801858 <memmove+0x9a>
  80181d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801821:	83 e0 03             	and    $0x3,%eax
  801824:	48 85 c0             	test   %rax,%rax
  801827:	75 2f                	jne    801858 <memmove+0x9a>
  801829:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80182d:	83 e0 03             	and    $0x3,%eax
  801830:	48 85 c0             	test   %rax,%rax
  801833:	75 23                	jne    801858 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801835:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801839:	48 83 e8 04          	sub    $0x4,%rax
  80183d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801841:	48 83 ea 04          	sub    $0x4,%rdx
  801845:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801849:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80184d:	48 89 c7             	mov    %rax,%rdi
  801850:	48 89 d6             	mov    %rdx,%rsi
  801853:	fd                   	std    
  801854:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801856:	eb 1d                	jmp    801875 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801858:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80185c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801860:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801864:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801868:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80186c:	48 89 d7             	mov    %rdx,%rdi
  80186f:	48 89 c1             	mov    %rax,%rcx
  801872:	fd                   	std    
  801873:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801875:	fc                   	cld    
  801876:	eb 57                	jmp    8018cf <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801878:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80187c:	83 e0 03             	and    $0x3,%eax
  80187f:	48 85 c0             	test   %rax,%rax
  801882:	75 36                	jne    8018ba <memmove+0xfc>
  801884:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801888:	83 e0 03             	and    $0x3,%eax
  80188b:	48 85 c0             	test   %rax,%rax
  80188e:	75 2a                	jne    8018ba <memmove+0xfc>
  801890:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801894:	83 e0 03             	and    $0x3,%eax
  801897:	48 85 c0             	test   %rax,%rax
  80189a:	75 1e                	jne    8018ba <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80189c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018a0:	48 c1 e8 02          	shr    $0x2,%rax
  8018a4:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8018a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018ab:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8018af:	48 89 c7             	mov    %rax,%rdi
  8018b2:	48 89 d6             	mov    %rdx,%rsi
  8018b5:	fc                   	cld    
  8018b6:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8018b8:	eb 15                	jmp    8018cf <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8018ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018be:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8018c2:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8018c6:	48 89 c7             	mov    %rax,%rdi
  8018c9:	48 89 d6             	mov    %rdx,%rsi
  8018cc:	fc                   	cld    
  8018cd:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8018cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8018d3:	c9                   	leaveq 
  8018d4:	c3                   	retq   

00000000008018d5 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8018d5:	55                   	push   %rbp
  8018d6:	48 89 e5             	mov    %rsp,%rbp
  8018d9:	48 83 ec 18          	sub    $0x18,%rsp
  8018dd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018e1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018e5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8018e9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018ed:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8018f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018f5:	48 89 ce             	mov    %rcx,%rsi
  8018f8:	48 89 c7             	mov    %rax,%rdi
  8018fb:	48 b8 be 17 80 00 00 	movabs $0x8017be,%rax
  801902:	00 00 00 
  801905:	ff d0                	callq  *%rax
}
  801907:	c9                   	leaveq 
  801908:	c3                   	retq   

0000000000801909 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801909:	55                   	push   %rbp
  80190a:	48 89 e5             	mov    %rsp,%rbp
  80190d:	48 83 ec 28          	sub    $0x28,%rsp
  801911:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801915:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801919:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80191d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801921:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801925:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801929:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80192d:	eb 36                	jmp    801965 <memcmp+0x5c>
		if (*s1 != *s2)
  80192f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801933:	0f b6 10             	movzbl (%rax),%edx
  801936:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80193a:	0f b6 00             	movzbl (%rax),%eax
  80193d:	38 c2                	cmp    %al,%dl
  80193f:	74 1a                	je     80195b <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801941:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801945:	0f b6 00             	movzbl (%rax),%eax
  801948:	0f b6 d0             	movzbl %al,%edx
  80194b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80194f:	0f b6 00             	movzbl (%rax),%eax
  801952:	0f b6 c0             	movzbl %al,%eax
  801955:	29 c2                	sub    %eax,%edx
  801957:	89 d0                	mov    %edx,%eax
  801959:	eb 20                	jmp    80197b <memcmp+0x72>
		s1++, s2++;
  80195b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801960:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801965:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801969:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80196d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801971:	48 85 c0             	test   %rax,%rax
  801974:	75 b9                	jne    80192f <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801976:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80197b:	c9                   	leaveq 
  80197c:	c3                   	retq   

000000000080197d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80197d:	55                   	push   %rbp
  80197e:	48 89 e5             	mov    %rsp,%rbp
  801981:	48 83 ec 28          	sub    $0x28,%rsp
  801985:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801989:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80198c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801990:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801994:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801998:	48 01 d0             	add    %rdx,%rax
  80199b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80199f:	eb 15                	jmp    8019b6 <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  8019a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019a5:	0f b6 10             	movzbl (%rax),%edx
  8019a8:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8019ab:	38 c2                	cmp    %al,%dl
  8019ad:	75 02                	jne    8019b1 <memfind+0x34>
			break;
  8019af:	eb 0f                	jmp    8019c0 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8019b1:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8019b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019ba:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8019be:	72 e1                	jb     8019a1 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  8019c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8019c4:	c9                   	leaveq 
  8019c5:	c3                   	retq   

00000000008019c6 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8019c6:	55                   	push   %rbp
  8019c7:	48 89 e5             	mov    %rsp,%rbp
  8019ca:	48 83 ec 34          	sub    $0x34,%rsp
  8019ce:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8019d2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8019d6:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8019d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8019e0:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8019e7:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019e8:	eb 05                	jmp    8019ef <strtol+0x29>
		s++;
  8019ea:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019f3:	0f b6 00             	movzbl (%rax),%eax
  8019f6:	3c 20                	cmp    $0x20,%al
  8019f8:	74 f0                	je     8019ea <strtol+0x24>
  8019fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019fe:	0f b6 00             	movzbl (%rax),%eax
  801a01:	3c 09                	cmp    $0x9,%al
  801a03:	74 e5                	je     8019ea <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801a05:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a09:	0f b6 00             	movzbl (%rax),%eax
  801a0c:	3c 2b                	cmp    $0x2b,%al
  801a0e:	75 07                	jne    801a17 <strtol+0x51>
		s++;
  801a10:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a15:	eb 17                	jmp    801a2e <strtol+0x68>
	else if (*s == '-')
  801a17:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a1b:	0f b6 00             	movzbl (%rax),%eax
  801a1e:	3c 2d                	cmp    $0x2d,%al
  801a20:	75 0c                	jne    801a2e <strtol+0x68>
		s++, neg = 1;
  801a22:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a27:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801a2e:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801a32:	74 06                	je     801a3a <strtol+0x74>
  801a34:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801a38:	75 28                	jne    801a62 <strtol+0x9c>
  801a3a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a3e:	0f b6 00             	movzbl (%rax),%eax
  801a41:	3c 30                	cmp    $0x30,%al
  801a43:	75 1d                	jne    801a62 <strtol+0x9c>
  801a45:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a49:	48 83 c0 01          	add    $0x1,%rax
  801a4d:	0f b6 00             	movzbl (%rax),%eax
  801a50:	3c 78                	cmp    $0x78,%al
  801a52:	75 0e                	jne    801a62 <strtol+0x9c>
		s += 2, base = 16;
  801a54:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801a59:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801a60:	eb 2c                	jmp    801a8e <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801a62:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801a66:	75 19                	jne    801a81 <strtol+0xbb>
  801a68:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a6c:	0f b6 00             	movzbl (%rax),%eax
  801a6f:	3c 30                	cmp    $0x30,%al
  801a71:	75 0e                	jne    801a81 <strtol+0xbb>
		s++, base = 8;
  801a73:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a78:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801a7f:	eb 0d                	jmp    801a8e <strtol+0xc8>
	else if (base == 0)
  801a81:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801a85:	75 07                	jne    801a8e <strtol+0xc8>
		base = 10;
  801a87:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801a8e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a92:	0f b6 00             	movzbl (%rax),%eax
  801a95:	3c 2f                	cmp    $0x2f,%al
  801a97:	7e 1d                	jle    801ab6 <strtol+0xf0>
  801a99:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a9d:	0f b6 00             	movzbl (%rax),%eax
  801aa0:	3c 39                	cmp    $0x39,%al
  801aa2:	7f 12                	jg     801ab6 <strtol+0xf0>
			dig = *s - '0';
  801aa4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aa8:	0f b6 00             	movzbl (%rax),%eax
  801aab:	0f be c0             	movsbl %al,%eax
  801aae:	83 e8 30             	sub    $0x30,%eax
  801ab1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801ab4:	eb 4e                	jmp    801b04 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801ab6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aba:	0f b6 00             	movzbl (%rax),%eax
  801abd:	3c 60                	cmp    $0x60,%al
  801abf:	7e 1d                	jle    801ade <strtol+0x118>
  801ac1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ac5:	0f b6 00             	movzbl (%rax),%eax
  801ac8:	3c 7a                	cmp    $0x7a,%al
  801aca:	7f 12                	jg     801ade <strtol+0x118>
			dig = *s - 'a' + 10;
  801acc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ad0:	0f b6 00             	movzbl (%rax),%eax
  801ad3:	0f be c0             	movsbl %al,%eax
  801ad6:	83 e8 57             	sub    $0x57,%eax
  801ad9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801adc:	eb 26                	jmp    801b04 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801ade:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ae2:	0f b6 00             	movzbl (%rax),%eax
  801ae5:	3c 40                	cmp    $0x40,%al
  801ae7:	7e 48                	jle    801b31 <strtol+0x16b>
  801ae9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801aed:	0f b6 00             	movzbl (%rax),%eax
  801af0:	3c 5a                	cmp    $0x5a,%al
  801af2:	7f 3d                	jg     801b31 <strtol+0x16b>
			dig = *s - 'A' + 10;
  801af4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801af8:	0f b6 00             	movzbl (%rax),%eax
  801afb:	0f be c0             	movsbl %al,%eax
  801afe:	83 e8 37             	sub    $0x37,%eax
  801b01:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801b04:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801b07:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801b0a:	7c 02                	jl     801b0e <strtol+0x148>
			break;
  801b0c:	eb 23                	jmp    801b31 <strtol+0x16b>
		s++, val = (val * base) + dig;
  801b0e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801b13:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801b16:	48 98                	cltq   
  801b18:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801b1d:	48 89 c2             	mov    %rax,%rdx
  801b20:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801b23:	48 98                	cltq   
  801b25:	48 01 d0             	add    %rdx,%rax
  801b28:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801b2c:	e9 5d ff ff ff       	jmpq   801a8e <strtol+0xc8>

	if (endptr)
  801b31:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801b36:	74 0b                	je     801b43 <strtol+0x17d>
		*endptr = (char *) s;
  801b38:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b3c:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801b40:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801b43:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b47:	74 09                	je     801b52 <strtol+0x18c>
  801b49:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b4d:	48 f7 d8             	neg    %rax
  801b50:	eb 04                	jmp    801b56 <strtol+0x190>
  801b52:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801b56:	c9                   	leaveq 
  801b57:	c3                   	retq   

0000000000801b58 <strstr>:

char * strstr(const char *in, const char *str)
{
  801b58:	55                   	push   %rbp
  801b59:	48 89 e5             	mov    %rsp,%rbp
  801b5c:	48 83 ec 30          	sub    $0x30,%rsp
  801b60:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801b64:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801b68:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b6c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801b70:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801b74:	0f b6 00             	movzbl (%rax),%eax
  801b77:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801b7a:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801b7e:	75 06                	jne    801b86 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801b80:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b84:	eb 6b                	jmp    801bf1 <strstr+0x99>

	len = strlen(str);
  801b86:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b8a:	48 89 c7             	mov    %rax,%rdi
  801b8d:	48 b8 2e 14 80 00 00 	movabs $0x80142e,%rax
  801b94:	00 00 00 
  801b97:	ff d0                	callq  *%rax
  801b99:	48 98                	cltq   
  801b9b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801b9f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ba3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801ba7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801bab:	0f b6 00             	movzbl (%rax),%eax
  801bae:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801bb1:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801bb5:	75 07                	jne    801bbe <strstr+0x66>
				return (char *) 0;
  801bb7:	b8 00 00 00 00       	mov    $0x0,%eax
  801bbc:	eb 33                	jmp    801bf1 <strstr+0x99>
		} while (sc != c);
  801bbe:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801bc2:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801bc5:	75 d8                	jne    801b9f <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801bc7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bcb:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801bcf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bd3:	48 89 ce             	mov    %rcx,%rsi
  801bd6:	48 89 c7             	mov    %rax,%rdi
  801bd9:	48 b8 4f 16 80 00 00 	movabs $0x80164f,%rax
  801be0:	00 00 00 
  801be3:	ff d0                	callq  *%rax
  801be5:	85 c0                	test   %eax,%eax
  801be7:	75 b6                	jne    801b9f <strstr+0x47>

	return (char *) (in - 1);
  801be9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801bed:	48 83 e8 01          	sub    $0x1,%rax
}
  801bf1:	c9                   	leaveq 
  801bf2:	c3                   	retq   

0000000000801bf3 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801bf3:	55                   	push   %rbp
  801bf4:	48 89 e5             	mov    %rsp,%rbp
  801bf7:	53                   	push   %rbx
  801bf8:	48 83 ec 48          	sub    $0x48,%rsp
  801bfc:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801bff:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801c02:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801c06:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801c0a:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801c0e:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c12:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801c15:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801c19:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801c1d:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801c21:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801c25:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801c29:	4c 89 c3             	mov    %r8,%rbx
  801c2c:	cd 30                	int    $0x30
  801c2e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801c32:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801c36:	74 3e                	je     801c76 <syscall+0x83>
  801c38:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801c3d:	7e 37                	jle    801c76 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801c3f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801c43:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801c46:	49 89 d0             	mov    %rdx,%r8
  801c49:	89 c1                	mov    %eax,%ecx
  801c4b:	48 ba fb 41 80 00 00 	movabs $0x8041fb,%rdx
  801c52:	00 00 00 
  801c55:	be 23 00 00 00       	mov    $0x23,%esi
  801c5a:	48 bf 18 42 80 00 00 	movabs $0x804218,%rdi
  801c61:	00 00 00 
  801c64:	b8 00 00 00 00       	mov    $0x0,%eax
  801c69:	49 b9 11 05 80 00 00 	movabs $0x800511,%r9
  801c70:	00 00 00 
  801c73:	41 ff d1             	callq  *%r9

	return ret;
  801c76:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801c7a:	48 83 c4 48          	add    $0x48,%rsp
  801c7e:	5b                   	pop    %rbx
  801c7f:	5d                   	pop    %rbp
  801c80:	c3                   	retq   

0000000000801c81 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801c81:	55                   	push   %rbp
  801c82:	48 89 e5             	mov    %rsp,%rbp
  801c85:	48 83 ec 20          	sub    $0x20,%rsp
  801c89:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c8d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801c91:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c95:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c99:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ca0:	00 
  801ca1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ca7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cad:	48 89 d1             	mov    %rdx,%rcx
  801cb0:	48 89 c2             	mov    %rax,%rdx
  801cb3:	be 00 00 00 00       	mov    $0x0,%esi
  801cb8:	bf 00 00 00 00       	mov    $0x0,%edi
  801cbd:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  801cc4:	00 00 00 
  801cc7:	ff d0                	callq  *%rax
}
  801cc9:	c9                   	leaveq 
  801cca:	c3                   	retq   

0000000000801ccb <sys_cgetc>:

int
sys_cgetc(void)
{
  801ccb:	55                   	push   %rbp
  801ccc:	48 89 e5             	mov    %rsp,%rbp
  801ccf:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801cd3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801cda:	00 
  801cdb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ce1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ce7:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cec:	ba 00 00 00 00       	mov    $0x0,%edx
  801cf1:	be 00 00 00 00       	mov    $0x0,%esi
  801cf6:	bf 01 00 00 00       	mov    $0x1,%edi
  801cfb:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  801d02:	00 00 00 
  801d05:	ff d0                	callq  *%rax
}
  801d07:	c9                   	leaveq 
  801d08:	c3                   	retq   

0000000000801d09 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801d09:	55                   	push   %rbp
  801d0a:	48 89 e5             	mov    %rsp,%rbp
  801d0d:	48 83 ec 10          	sub    $0x10,%rsp
  801d11:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801d14:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d17:	48 98                	cltq   
  801d19:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d20:	00 
  801d21:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d27:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d2d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d32:	48 89 c2             	mov    %rax,%rdx
  801d35:	be 01 00 00 00       	mov    $0x1,%esi
  801d3a:	bf 03 00 00 00       	mov    $0x3,%edi
  801d3f:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  801d46:	00 00 00 
  801d49:	ff d0                	callq  *%rax
}
  801d4b:	c9                   	leaveq 
  801d4c:	c3                   	retq   

0000000000801d4d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801d4d:	55                   	push   %rbp
  801d4e:	48 89 e5             	mov    %rsp,%rbp
  801d51:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801d55:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d5c:	00 
  801d5d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d63:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d69:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d6e:	ba 00 00 00 00       	mov    $0x0,%edx
  801d73:	be 00 00 00 00       	mov    $0x0,%esi
  801d78:	bf 02 00 00 00       	mov    $0x2,%edi
  801d7d:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  801d84:	00 00 00 
  801d87:	ff d0                	callq  *%rax
}
  801d89:	c9                   	leaveq 
  801d8a:	c3                   	retq   

0000000000801d8b <sys_yield>:

void
sys_yield(void)
{
  801d8b:	55                   	push   %rbp
  801d8c:	48 89 e5             	mov    %rsp,%rbp
  801d8f:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801d93:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801d9a:	00 
  801d9b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801da1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801da7:	b9 00 00 00 00       	mov    $0x0,%ecx
  801dac:	ba 00 00 00 00       	mov    $0x0,%edx
  801db1:	be 00 00 00 00       	mov    $0x0,%esi
  801db6:	bf 0b 00 00 00       	mov    $0xb,%edi
  801dbb:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  801dc2:	00 00 00 
  801dc5:	ff d0                	callq  *%rax
}
  801dc7:	c9                   	leaveq 
  801dc8:	c3                   	retq   

0000000000801dc9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801dc9:	55                   	push   %rbp
  801dca:	48 89 e5             	mov    %rsp,%rbp
  801dcd:	48 83 ec 20          	sub    $0x20,%rsp
  801dd1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801dd4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801dd8:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801ddb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dde:	48 63 c8             	movslq %eax,%rcx
  801de1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801de5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801de8:	48 98                	cltq   
  801dea:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801df1:	00 
  801df2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801df8:	49 89 c8             	mov    %rcx,%r8
  801dfb:	48 89 d1             	mov    %rdx,%rcx
  801dfe:	48 89 c2             	mov    %rax,%rdx
  801e01:	be 01 00 00 00       	mov    $0x1,%esi
  801e06:	bf 04 00 00 00       	mov    $0x4,%edi
  801e0b:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  801e12:	00 00 00 
  801e15:	ff d0                	callq  *%rax
}
  801e17:	c9                   	leaveq 
  801e18:	c3                   	retq   

0000000000801e19 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801e19:	55                   	push   %rbp
  801e1a:	48 89 e5             	mov    %rsp,%rbp
  801e1d:	48 83 ec 30          	sub    $0x30,%rsp
  801e21:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e24:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e28:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801e2b:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801e2f:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801e33:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801e36:	48 63 c8             	movslq %eax,%rcx
  801e39:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801e3d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e40:	48 63 f0             	movslq %eax,%rsi
  801e43:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e47:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e4a:	48 98                	cltq   
  801e4c:	48 89 0c 24          	mov    %rcx,(%rsp)
  801e50:	49 89 f9             	mov    %rdi,%r9
  801e53:	49 89 f0             	mov    %rsi,%r8
  801e56:	48 89 d1             	mov    %rdx,%rcx
  801e59:	48 89 c2             	mov    %rax,%rdx
  801e5c:	be 01 00 00 00       	mov    $0x1,%esi
  801e61:	bf 05 00 00 00       	mov    $0x5,%edi
  801e66:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  801e6d:	00 00 00 
  801e70:	ff d0                	callq  *%rax
}
  801e72:	c9                   	leaveq 
  801e73:	c3                   	retq   

0000000000801e74 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801e74:	55                   	push   %rbp
  801e75:	48 89 e5             	mov    %rsp,%rbp
  801e78:	48 83 ec 20          	sub    $0x20,%rsp
  801e7c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e7f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801e83:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e87:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e8a:	48 98                	cltq   
  801e8c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801e93:	00 
  801e94:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e9a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ea0:	48 89 d1             	mov    %rdx,%rcx
  801ea3:	48 89 c2             	mov    %rax,%rdx
  801ea6:	be 01 00 00 00       	mov    $0x1,%esi
  801eab:	bf 06 00 00 00       	mov    $0x6,%edi
  801eb0:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  801eb7:	00 00 00 
  801eba:	ff d0                	callq  *%rax
}
  801ebc:	c9                   	leaveq 
  801ebd:	c3                   	retq   

0000000000801ebe <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801ebe:	55                   	push   %rbp
  801ebf:	48 89 e5             	mov    %rsp,%rbp
  801ec2:	48 83 ec 10          	sub    $0x10,%rsp
  801ec6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ec9:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801ecc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ecf:	48 63 d0             	movslq %eax,%rdx
  801ed2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ed5:	48 98                	cltq   
  801ed7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801ede:	00 
  801edf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ee5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801eeb:	48 89 d1             	mov    %rdx,%rcx
  801eee:	48 89 c2             	mov    %rax,%rdx
  801ef1:	be 01 00 00 00       	mov    $0x1,%esi
  801ef6:	bf 08 00 00 00       	mov    $0x8,%edi
  801efb:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  801f02:	00 00 00 
  801f05:	ff d0                	callq  *%rax
}
  801f07:	c9                   	leaveq 
  801f08:	c3                   	retq   

0000000000801f09 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801f09:	55                   	push   %rbp
  801f0a:	48 89 e5             	mov    %rsp,%rbp
  801f0d:	48 83 ec 20          	sub    $0x20,%rsp
  801f11:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f14:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801f18:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f1f:	48 98                	cltq   
  801f21:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f28:	00 
  801f29:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f2f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f35:	48 89 d1             	mov    %rdx,%rcx
  801f38:	48 89 c2             	mov    %rax,%rdx
  801f3b:	be 01 00 00 00       	mov    $0x1,%esi
  801f40:	bf 09 00 00 00       	mov    $0x9,%edi
  801f45:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  801f4c:	00 00 00 
  801f4f:	ff d0                	callq  *%rax
}
  801f51:	c9                   	leaveq 
  801f52:	c3                   	retq   

0000000000801f53 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801f53:	55                   	push   %rbp
  801f54:	48 89 e5             	mov    %rsp,%rbp
  801f57:	48 83 ec 20          	sub    $0x20,%rsp
  801f5b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f5e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801f62:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f66:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f69:	48 98                	cltq   
  801f6b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801f72:	00 
  801f73:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f79:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f7f:	48 89 d1             	mov    %rdx,%rcx
  801f82:	48 89 c2             	mov    %rax,%rdx
  801f85:	be 01 00 00 00       	mov    $0x1,%esi
  801f8a:	bf 0a 00 00 00       	mov    $0xa,%edi
  801f8f:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  801f96:	00 00 00 
  801f99:	ff d0                	callq  *%rax
}
  801f9b:	c9                   	leaveq 
  801f9c:	c3                   	retq   

0000000000801f9d <sys_set_priority>:

void
sys_set_priority(envid_t envid, int priority)
{
  801f9d:	55                   	push   %rbp
  801f9e:	48 89 e5             	mov    %rsp,%rbp
  801fa1:	48 83 ec 10          	sub    $0x10,%rsp
  801fa5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801fa8:	89 75 f8             	mov    %esi,-0x8(%rbp)
	syscall(SYS_set_priority,1,envid,priority,0,0,0);
  801fab:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801fae:	48 63 d0             	movslq %eax,%rdx
  801fb1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fb4:	48 98                	cltq   
  801fb6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  801fbd:	00 
  801fbe:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fc4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fca:	48 89 d1             	mov    %rdx,%rcx
  801fcd:	48 89 c2             	mov    %rax,%rdx
  801fd0:	be 01 00 00 00       	mov    $0x1,%esi
  801fd5:	bf 11 00 00 00       	mov    $0x11,%edi
  801fda:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  801fe1:	00 00 00 
  801fe4:	ff d0                	callq  *%rax

}
  801fe6:	c9                   	leaveq 
  801fe7:	c3                   	retq   

0000000000801fe8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801fe8:	55                   	push   %rbp
  801fe9:	48 89 e5             	mov    %rsp,%rbp
  801fec:	48 83 ec 20          	sub    $0x20,%rsp
  801ff0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ff3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801ff7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801ffb:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801ffe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802001:	48 63 f0             	movslq %eax,%rsi
  802004:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802008:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80200b:	48 98                	cltq   
  80200d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802011:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802018:	00 
  802019:	49 89 f1             	mov    %rsi,%r9
  80201c:	49 89 c8             	mov    %rcx,%r8
  80201f:	48 89 d1             	mov    %rdx,%rcx
  802022:	48 89 c2             	mov    %rax,%rdx
  802025:	be 00 00 00 00       	mov    $0x0,%esi
  80202a:	bf 0c 00 00 00       	mov    $0xc,%edi
  80202f:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  802036:	00 00 00 
  802039:	ff d0                	callq  *%rax
}
  80203b:	c9                   	leaveq 
  80203c:	c3                   	retq   

000000000080203d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80203d:	55                   	push   %rbp
  80203e:	48 89 e5             	mov    %rsp,%rbp
  802041:	48 83 ec 10          	sub    $0x10,%rsp
  802045:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  802049:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80204d:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802054:	00 
  802055:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80205b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802061:	b9 00 00 00 00       	mov    $0x0,%ecx
  802066:	48 89 c2             	mov    %rax,%rdx
  802069:	be 01 00 00 00       	mov    $0x1,%esi
  80206e:	bf 0d 00 00 00       	mov    $0xd,%edi
  802073:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  80207a:	00 00 00 
  80207d:	ff d0                	callq  *%rax
}
  80207f:	c9                   	leaveq 
  802080:	c3                   	retq   

0000000000802081 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  802081:	55                   	push   %rbp
  802082:	48 89 e5             	mov    %rsp,%rbp
  802085:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  802089:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802090:	00 
  802091:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802097:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80209d:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8020a7:	be 00 00 00 00       	mov    $0x0,%esi
  8020ac:	bf 0e 00 00 00       	mov    $0xe,%edi
  8020b1:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  8020b8:	00 00 00 
  8020bb:	ff d0                	callq  *%rax
}
  8020bd:	c9                   	leaveq 
  8020be:	c3                   	retq   

00000000008020bf <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  8020bf:	55                   	push   %rbp
  8020c0:	48 89 e5             	mov    %rsp,%rbp
  8020c3:	48 83 ec 30          	sub    $0x30,%rsp
  8020c7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8020ca:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8020ce:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8020d1:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8020d5:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  8020d9:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8020dc:	48 63 c8             	movslq %eax,%rcx
  8020df:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8020e3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8020e6:	48 63 f0             	movslq %eax,%rsi
  8020e9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020f0:	48 98                	cltq   
  8020f2:	48 89 0c 24          	mov    %rcx,(%rsp)
  8020f6:	49 89 f9             	mov    %rdi,%r9
  8020f9:	49 89 f0             	mov    %rsi,%r8
  8020fc:	48 89 d1             	mov    %rdx,%rcx
  8020ff:	48 89 c2             	mov    %rax,%rdx
  802102:	be 00 00 00 00       	mov    $0x0,%esi
  802107:	bf 0f 00 00 00       	mov    $0xf,%edi
  80210c:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  802113:	00 00 00 
  802116:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  802118:	c9                   	leaveq 
  802119:	c3                   	retq   

000000000080211a <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  80211a:	55                   	push   %rbp
  80211b:	48 89 e5             	mov    %rsp,%rbp
  80211e:	48 83 ec 20          	sub    $0x20,%rsp
  802122:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802126:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  80212a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80212e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802132:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802139:	00 
  80213a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802140:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802146:	48 89 d1             	mov    %rdx,%rcx
  802149:	48 89 c2             	mov    %rax,%rdx
  80214c:	be 00 00 00 00       	mov    $0x0,%esi
  802151:	bf 10 00 00 00       	mov    $0x10,%edi
  802156:	48 b8 f3 1b 80 00 00 	movabs $0x801bf3,%rax
  80215d:	00 00 00 
  802160:	ff d0                	callq  *%rax
}
  802162:	c9                   	leaveq 
  802163:	c3                   	retq   

0000000000802164 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802164:	55                   	push   %rbp
  802165:	48 89 e5             	mov    %rsp,%rbp
  802168:	48 83 ec 08          	sub    $0x8,%rsp
  80216c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802170:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802174:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80217b:	ff ff ff 
  80217e:	48 01 d0             	add    %rdx,%rax
  802181:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802185:	c9                   	leaveq 
  802186:	c3                   	retq   

0000000000802187 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802187:	55                   	push   %rbp
  802188:	48 89 e5             	mov    %rsp,%rbp
  80218b:	48 83 ec 08          	sub    $0x8,%rsp
  80218f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802193:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802197:	48 89 c7             	mov    %rax,%rdi
  80219a:	48 b8 64 21 80 00 00 	movabs $0x802164,%rax
  8021a1:	00 00 00 
  8021a4:	ff d0                	callq  *%rax
  8021a6:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8021ac:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8021b0:	c9                   	leaveq 
  8021b1:	c3                   	retq   

00000000008021b2 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8021b2:	55                   	push   %rbp
  8021b3:	48 89 e5             	mov    %rsp,%rbp
  8021b6:	48 83 ec 18          	sub    $0x18,%rsp
  8021ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8021be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8021c5:	eb 6b                	jmp    802232 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8021c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021ca:	48 98                	cltq   
  8021cc:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8021d2:	48 c1 e0 0c          	shl    $0xc,%rax
  8021d6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8021da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021de:	48 c1 e8 15          	shr    $0x15,%rax
  8021e2:	48 89 c2             	mov    %rax,%rdx
  8021e5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021ec:	01 00 00 
  8021ef:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021f3:	83 e0 01             	and    $0x1,%eax
  8021f6:	48 85 c0             	test   %rax,%rax
  8021f9:	74 21                	je     80221c <fd_alloc+0x6a>
  8021fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021ff:	48 c1 e8 0c          	shr    $0xc,%rax
  802203:	48 89 c2             	mov    %rax,%rdx
  802206:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80220d:	01 00 00 
  802210:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802214:	83 e0 01             	and    $0x1,%eax
  802217:	48 85 c0             	test   %rax,%rax
  80221a:	75 12                	jne    80222e <fd_alloc+0x7c>
			*fd_store = fd;
  80221c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802220:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802224:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802227:	b8 00 00 00 00       	mov    $0x0,%eax
  80222c:	eb 1a                	jmp    802248 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80222e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802232:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802236:	7e 8f                	jle    8021c7 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802238:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80223c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802243:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802248:	c9                   	leaveq 
  802249:	c3                   	retq   

000000000080224a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80224a:	55                   	push   %rbp
  80224b:	48 89 e5             	mov    %rsp,%rbp
  80224e:	48 83 ec 20          	sub    $0x20,%rsp
  802252:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802255:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802259:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80225d:	78 06                	js     802265 <fd_lookup+0x1b>
  80225f:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802263:	7e 07                	jle    80226c <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802265:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80226a:	eb 6c                	jmp    8022d8 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80226c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80226f:	48 98                	cltq   
  802271:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802277:	48 c1 e0 0c          	shl    $0xc,%rax
  80227b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80227f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802283:	48 c1 e8 15          	shr    $0x15,%rax
  802287:	48 89 c2             	mov    %rax,%rdx
  80228a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802291:	01 00 00 
  802294:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802298:	83 e0 01             	and    $0x1,%eax
  80229b:	48 85 c0             	test   %rax,%rax
  80229e:	74 21                	je     8022c1 <fd_lookup+0x77>
  8022a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022a4:	48 c1 e8 0c          	shr    $0xc,%rax
  8022a8:	48 89 c2             	mov    %rax,%rdx
  8022ab:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022b2:	01 00 00 
  8022b5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022b9:	83 e0 01             	and    $0x1,%eax
  8022bc:	48 85 c0             	test   %rax,%rax
  8022bf:	75 07                	jne    8022c8 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8022c1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022c6:	eb 10                	jmp    8022d8 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8022c8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022cc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8022d0:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8022d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022d8:	c9                   	leaveq 
  8022d9:	c3                   	retq   

00000000008022da <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8022da:	55                   	push   %rbp
  8022db:	48 89 e5             	mov    %rsp,%rbp
  8022de:	48 83 ec 30          	sub    $0x30,%rsp
  8022e2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8022e6:	89 f0                	mov    %esi,%eax
  8022e8:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8022eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022ef:	48 89 c7             	mov    %rax,%rdi
  8022f2:	48 b8 64 21 80 00 00 	movabs $0x802164,%rax
  8022f9:	00 00 00 
  8022fc:	ff d0                	callq  *%rax
  8022fe:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802302:	48 89 d6             	mov    %rdx,%rsi
  802305:	89 c7                	mov    %eax,%edi
  802307:	48 b8 4a 22 80 00 00 	movabs $0x80224a,%rax
  80230e:	00 00 00 
  802311:	ff d0                	callq  *%rax
  802313:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802316:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80231a:	78 0a                	js     802326 <fd_close+0x4c>
	    || fd != fd2)
  80231c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802320:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802324:	74 12                	je     802338 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802326:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80232a:	74 05                	je     802331 <fd_close+0x57>
  80232c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80232f:	eb 05                	jmp    802336 <fd_close+0x5c>
  802331:	b8 00 00 00 00       	mov    $0x0,%eax
  802336:	eb 69                	jmp    8023a1 <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802338:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80233c:	8b 00                	mov    (%rax),%eax
  80233e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802342:	48 89 d6             	mov    %rdx,%rsi
  802345:	89 c7                	mov    %eax,%edi
  802347:	48 b8 a3 23 80 00 00 	movabs $0x8023a3,%rax
  80234e:	00 00 00 
  802351:	ff d0                	callq  *%rax
  802353:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802356:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80235a:	78 2a                	js     802386 <fd_close+0xac>
		if (dev->dev_close)
  80235c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802360:	48 8b 40 20          	mov    0x20(%rax),%rax
  802364:	48 85 c0             	test   %rax,%rax
  802367:	74 16                	je     80237f <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802369:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80236d:	48 8b 40 20          	mov    0x20(%rax),%rax
  802371:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802375:	48 89 d7             	mov    %rdx,%rdi
  802378:	ff d0                	callq  *%rax
  80237a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80237d:	eb 07                	jmp    802386 <fd_close+0xac>
		else
			r = 0;
  80237f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802386:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80238a:	48 89 c6             	mov    %rax,%rsi
  80238d:	bf 00 00 00 00       	mov    $0x0,%edi
  802392:	48 b8 74 1e 80 00 00 	movabs $0x801e74,%rax
  802399:	00 00 00 
  80239c:	ff d0                	callq  *%rax
	return r;
  80239e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8023a1:	c9                   	leaveq 
  8023a2:	c3                   	retq   

00000000008023a3 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8023a3:	55                   	push   %rbp
  8023a4:	48 89 e5             	mov    %rsp,%rbp
  8023a7:	48 83 ec 20          	sub    $0x20,%rsp
  8023ab:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023ae:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8023b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8023b9:	eb 41                	jmp    8023fc <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8023bb:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  8023c2:	00 00 00 
  8023c5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8023c8:	48 63 d2             	movslq %edx,%rdx
  8023cb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023cf:	8b 00                	mov    (%rax),%eax
  8023d1:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8023d4:	75 22                	jne    8023f8 <dev_lookup+0x55>
			*dev = devtab[i];
  8023d6:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  8023dd:	00 00 00 
  8023e0:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8023e3:	48 63 d2             	movslq %edx,%rdx
  8023e6:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8023ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023ee:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8023f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f6:	eb 60                	jmp    802458 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8023f8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8023fc:	48 b8 40 60 80 00 00 	movabs $0x806040,%rax
  802403:	00 00 00 
  802406:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802409:	48 63 d2             	movslq %edx,%rdx
  80240c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802410:	48 85 c0             	test   %rax,%rax
  802413:	75 a6                	jne    8023bb <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802415:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  80241c:	00 00 00 
  80241f:	48 8b 00             	mov    (%rax),%rax
  802422:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802428:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80242b:	89 c6                	mov    %eax,%esi
  80242d:	48 bf 28 42 80 00 00 	movabs $0x804228,%rdi
  802434:	00 00 00 
  802437:	b8 00 00 00 00       	mov    $0x0,%eax
  80243c:	48 b9 4a 07 80 00 00 	movabs $0x80074a,%rcx
  802443:	00 00 00 
  802446:	ff d1                	callq  *%rcx
	*dev = 0;
  802448:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80244c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802453:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802458:	c9                   	leaveq 
  802459:	c3                   	retq   

000000000080245a <close>:

int
close(int fdnum)
{
  80245a:	55                   	push   %rbp
  80245b:	48 89 e5             	mov    %rsp,%rbp
  80245e:	48 83 ec 20          	sub    $0x20,%rsp
  802462:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802465:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802469:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80246c:	48 89 d6             	mov    %rdx,%rsi
  80246f:	89 c7                	mov    %eax,%edi
  802471:	48 b8 4a 22 80 00 00 	movabs $0x80224a,%rax
  802478:	00 00 00 
  80247b:	ff d0                	callq  *%rax
  80247d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802480:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802484:	79 05                	jns    80248b <close+0x31>
		return r;
  802486:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802489:	eb 18                	jmp    8024a3 <close+0x49>
	else
		return fd_close(fd, 1);
  80248b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80248f:	be 01 00 00 00       	mov    $0x1,%esi
  802494:	48 89 c7             	mov    %rax,%rdi
  802497:	48 b8 da 22 80 00 00 	movabs $0x8022da,%rax
  80249e:	00 00 00 
  8024a1:	ff d0                	callq  *%rax
}
  8024a3:	c9                   	leaveq 
  8024a4:	c3                   	retq   

00000000008024a5 <close_all>:

void
close_all(void)
{
  8024a5:	55                   	push   %rbp
  8024a6:	48 89 e5             	mov    %rsp,%rbp
  8024a9:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8024ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8024b4:	eb 15                	jmp    8024cb <close_all+0x26>
		close(i);
  8024b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024b9:	89 c7                	mov    %eax,%edi
  8024bb:	48 b8 5a 24 80 00 00 	movabs $0x80245a,%rax
  8024c2:	00 00 00 
  8024c5:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8024c7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8024cb:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8024cf:	7e e5                	jle    8024b6 <close_all+0x11>
		close(i);
}
  8024d1:	c9                   	leaveq 
  8024d2:	c3                   	retq   

00000000008024d3 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8024d3:	55                   	push   %rbp
  8024d4:	48 89 e5             	mov    %rsp,%rbp
  8024d7:	48 83 ec 40          	sub    $0x40,%rsp
  8024db:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8024de:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8024e1:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8024e5:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8024e8:	48 89 d6             	mov    %rdx,%rsi
  8024eb:	89 c7                	mov    %eax,%edi
  8024ed:	48 b8 4a 22 80 00 00 	movabs $0x80224a,%rax
  8024f4:	00 00 00 
  8024f7:	ff d0                	callq  *%rax
  8024f9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802500:	79 08                	jns    80250a <dup+0x37>
		return r;
  802502:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802505:	e9 70 01 00 00       	jmpq   80267a <dup+0x1a7>
	close(newfdnum);
  80250a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80250d:	89 c7                	mov    %eax,%edi
  80250f:	48 b8 5a 24 80 00 00 	movabs $0x80245a,%rax
  802516:	00 00 00 
  802519:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80251b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80251e:	48 98                	cltq   
  802520:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802526:	48 c1 e0 0c          	shl    $0xc,%rax
  80252a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80252e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802532:	48 89 c7             	mov    %rax,%rdi
  802535:	48 b8 87 21 80 00 00 	movabs $0x802187,%rax
  80253c:	00 00 00 
  80253f:	ff d0                	callq  *%rax
  802541:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802545:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802549:	48 89 c7             	mov    %rax,%rdi
  80254c:	48 b8 87 21 80 00 00 	movabs $0x802187,%rax
  802553:	00 00 00 
  802556:	ff d0                	callq  *%rax
  802558:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80255c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802560:	48 c1 e8 15          	shr    $0x15,%rax
  802564:	48 89 c2             	mov    %rax,%rdx
  802567:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80256e:	01 00 00 
  802571:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802575:	83 e0 01             	and    $0x1,%eax
  802578:	48 85 c0             	test   %rax,%rax
  80257b:	74 73                	je     8025f0 <dup+0x11d>
  80257d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802581:	48 c1 e8 0c          	shr    $0xc,%rax
  802585:	48 89 c2             	mov    %rax,%rdx
  802588:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80258f:	01 00 00 
  802592:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802596:	83 e0 01             	and    $0x1,%eax
  802599:	48 85 c0             	test   %rax,%rax
  80259c:	74 52                	je     8025f0 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80259e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025a2:	48 c1 e8 0c          	shr    $0xc,%rax
  8025a6:	48 89 c2             	mov    %rax,%rdx
  8025a9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025b0:	01 00 00 
  8025b3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025b7:	25 07 0e 00 00       	and    $0xe07,%eax
  8025bc:	89 c1                	mov    %eax,%ecx
  8025be:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8025c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025c6:	41 89 c8             	mov    %ecx,%r8d
  8025c9:	48 89 d1             	mov    %rdx,%rcx
  8025cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8025d1:	48 89 c6             	mov    %rax,%rsi
  8025d4:	bf 00 00 00 00       	mov    $0x0,%edi
  8025d9:	48 b8 19 1e 80 00 00 	movabs $0x801e19,%rax
  8025e0:	00 00 00 
  8025e3:	ff d0                	callq  *%rax
  8025e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025ec:	79 02                	jns    8025f0 <dup+0x11d>
			goto err;
  8025ee:	eb 57                	jmp    802647 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8025f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025f4:	48 c1 e8 0c          	shr    $0xc,%rax
  8025f8:	48 89 c2             	mov    %rax,%rdx
  8025fb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802602:	01 00 00 
  802605:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802609:	25 07 0e 00 00       	and    $0xe07,%eax
  80260e:	89 c1                	mov    %eax,%ecx
  802610:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802614:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802618:	41 89 c8             	mov    %ecx,%r8d
  80261b:	48 89 d1             	mov    %rdx,%rcx
  80261e:	ba 00 00 00 00       	mov    $0x0,%edx
  802623:	48 89 c6             	mov    %rax,%rsi
  802626:	bf 00 00 00 00       	mov    $0x0,%edi
  80262b:	48 b8 19 1e 80 00 00 	movabs $0x801e19,%rax
  802632:	00 00 00 
  802635:	ff d0                	callq  *%rax
  802637:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80263a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80263e:	79 02                	jns    802642 <dup+0x16f>
		goto err;
  802640:	eb 05                	jmp    802647 <dup+0x174>

	return newfdnum;
  802642:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802645:	eb 33                	jmp    80267a <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802647:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80264b:	48 89 c6             	mov    %rax,%rsi
  80264e:	bf 00 00 00 00       	mov    $0x0,%edi
  802653:	48 b8 74 1e 80 00 00 	movabs $0x801e74,%rax
  80265a:	00 00 00 
  80265d:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80265f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802663:	48 89 c6             	mov    %rax,%rsi
  802666:	bf 00 00 00 00       	mov    $0x0,%edi
  80266b:	48 b8 74 1e 80 00 00 	movabs $0x801e74,%rax
  802672:	00 00 00 
  802675:	ff d0                	callq  *%rax
	return r;
  802677:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80267a:	c9                   	leaveq 
  80267b:	c3                   	retq   

000000000080267c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80267c:	55                   	push   %rbp
  80267d:	48 89 e5             	mov    %rsp,%rbp
  802680:	48 83 ec 40          	sub    $0x40,%rsp
  802684:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802687:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80268b:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80268f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802693:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802696:	48 89 d6             	mov    %rdx,%rsi
  802699:	89 c7                	mov    %eax,%edi
  80269b:	48 b8 4a 22 80 00 00 	movabs $0x80224a,%rax
  8026a2:	00 00 00 
  8026a5:	ff d0                	callq  *%rax
  8026a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026ae:	78 24                	js     8026d4 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8026b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026b4:	8b 00                	mov    (%rax),%eax
  8026b6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026ba:	48 89 d6             	mov    %rdx,%rsi
  8026bd:	89 c7                	mov    %eax,%edi
  8026bf:	48 b8 a3 23 80 00 00 	movabs $0x8023a3,%rax
  8026c6:	00 00 00 
  8026c9:	ff d0                	callq  *%rax
  8026cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026d2:	79 05                	jns    8026d9 <read+0x5d>
		return r;
  8026d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026d7:	eb 76                	jmp    80274f <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8026d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026dd:	8b 40 08             	mov    0x8(%rax),%eax
  8026e0:	83 e0 03             	and    $0x3,%eax
  8026e3:	83 f8 01             	cmp    $0x1,%eax
  8026e6:	75 3a                	jne    802722 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8026e8:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  8026ef:	00 00 00 
  8026f2:	48 8b 00             	mov    (%rax),%rax
  8026f5:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8026fb:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8026fe:	89 c6                	mov    %eax,%esi
  802700:	48 bf 47 42 80 00 00 	movabs $0x804247,%rdi
  802707:	00 00 00 
  80270a:	b8 00 00 00 00       	mov    $0x0,%eax
  80270f:	48 b9 4a 07 80 00 00 	movabs $0x80074a,%rcx
  802716:	00 00 00 
  802719:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80271b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802720:	eb 2d                	jmp    80274f <read+0xd3>
	}
	if (!dev->dev_read)
  802722:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802726:	48 8b 40 10          	mov    0x10(%rax),%rax
  80272a:	48 85 c0             	test   %rax,%rax
  80272d:	75 07                	jne    802736 <read+0xba>
		return -E_NOT_SUPP;
  80272f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802734:	eb 19                	jmp    80274f <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802736:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80273a:	48 8b 40 10          	mov    0x10(%rax),%rax
  80273e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802742:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802746:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80274a:	48 89 cf             	mov    %rcx,%rdi
  80274d:	ff d0                	callq  *%rax
}
  80274f:	c9                   	leaveq 
  802750:	c3                   	retq   

0000000000802751 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802751:	55                   	push   %rbp
  802752:	48 89 e5             	mov    %rsp,%rbp
  802755:	48 83 ec 30          	sub    $0x30,%rsp
  802759:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80275c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802760:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802764:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80276b:	eb 49                	jmp    8027b6 <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80276d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802770:	48 98                	cltq   
  802772:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802776:	48 29 c2             	sub    %rax,%rdx
  802779:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80277c:	48 63 c8             	movslq %eax,%rcx
  80277f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802783:	48 01 c1             	add    %rax,%rcx
  802786:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802789:	48 89 ce             	mov    %rcx,%rsi
  80278c:	89 c7                	mov    %eax,%edi
  80278e:	48 b8 7c 26 80 00 00 	movabs $0x80267c,%rax
  802795:	00 00 00 
  802798:	ff d0                	callq  *%rax
  80279a:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80279d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8027a1:	79 05                	jns    8027a8 <readn+0x57>
			return m;
  8027a3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8027a6:	eb 1c                	jmp    8027c4 <readn+0x73>
		if (m == 0)
  8027a8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8027ac:	75 02                	jne    8027b0 <readn+0x5f>
			break;
  8027ae:	eb 11                	jmp    8027c1 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8027b0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8027b3:	01 45 fc             	add    %eax,-0x4(%rbp)
  8027b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027b9:	48 98                	cltq   
  8027bb:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8027bf:	72 ac                	jb     80276d <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  8027c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8027c4:	c9                   	leaveq 
  8027c5:	c3                   	retq   

00000000008027c6 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8027c6:	55                   	push   %rbp
  8027c7:	48 89 e5             	mov    %rsp,%rbp
  8027ca:	48 83 ec 40          	sub    $0x40,%rsp
  8027ce:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8027d1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8027d5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8027d9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8027dd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8027e0:	48 89 d6             	mov    %rdx,%rsi
  8027e3:	89 c7                	mov    %eax,%edi
  8027e5:	48 b8 4a 22 80 00 00 	movabs $0x80224a,%rax
  8027ec:	00 00 00 
  8027ef:	ff d0                	callq  *%rax
  8027f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027f8:	78 24                	js     80281e <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8027fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027fe:	8b 00                	mov    (%rax),%eax
  802800:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802804:	48 89 d6             	mov    %rdx,%rsi
  802807:	89 c7                	mov    %eax,%edi
  802809:	48 b8 a3 23 80 00 00 	movabs $0x8023a3,%rax
  802810:	00 00 00 
  802813:	ff d0                	callq  *%rax
  802815:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802818:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80281c:	79 05                	jns    802823 <write+0x5d>
		return r;
  80281e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802821:	eb 75                	jmp    802898 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802823:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802827:	8b 40 08             	mov    0x8(%rax),%eax
  80282a:	83 e0 03             	and    $0x3,%eax
  80282d:	85 c0                	test   %eax,%eax
  80282f:	75 3a                	jne    80286b <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802831:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  802838:	00 00 00 
  80283b:	48 8b 00             	mov    (%rax),%rax
  80283e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802844:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802847:	89 c6                	mov    %eax,%esi
  802849:	48 bf 63 42 80 00 00 	movabs $0x804263,%rdi
  802850:	00 00 00 
  802853:	b8 00 00 00 00       	mov    $0x0,%eax
  802858:	48 b9 4a 07 80 00 00 	movabs $0x80074a,%rcx
  80285f:	00 00 00 
  802862:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802864:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802869:	eb 2d                	jmp    802898 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80286b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80286f:	48 8b 40 18          	mov    0x18(%rax),%rax
  802873:	48 85 c0             	test   %rax,%rax
  802876:	75 07                	jne    80287f <write+0xb9>
		return -E_NOT_SUPP;
  802878:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80287d:	eb 19                	jmp    802898 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80287f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802883:	48 8b 40 18          	mov    0x18(%rax),%rax
  802887:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80288b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80288f:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802893:	48 89 cf             	mov    %rcx,%rdi
  802896:	ff d0                	callq  *%rax
}
  802898:	c9                   	leaveq 
  802899:	c3                   	retq   

000000000080289a <seek>:

int
seek(int fdnum, off_t offset)
{
  80289a:	55                   	push   %rbp
  80289b:	48 89 e5             	mov    %rsp,%rbp
  80289e:	48 83 ec 18          	sub    $0x18,%rsp
  8028a2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8028a5:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028a8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028ac:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028af:	48 89 d6             	mov    %rdx,%rsi
  8028b2:	89 c7                	mov    %eax,%edi
  8028b4:	48 b8 4a 22 80 00 00 	movabs $0x80224a,%rax
  8028bb:	00 00 00 
  8028be:	ff d0                	callq  *%rax
  8028c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028c7:	79 05                	jns    8028ce <seek+0x34>
		return r;
  8028c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028cc:	eb 0f                	jmp    8028dd <seek+0x43>
	fd->fd_offset = offset;
  8028ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028d2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8028d5:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8028d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028dd:	c9                   	leaveq 
  8028de:	c3                   	retq   

00000000008028df <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8028df:	55                   	push   %rbp
  8028e0:	48 89 e5             	mov    %rsp,%rbp
  8028e3:	48 83 ec 30          	sub    $0x30,%rsp
  8028e7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8028ea:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8028ed:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8028f1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8028f4:	48 89 d6             	mov    %rdx,%rsi
  8028f7:	89 c7                	mov    %eax,%edi
  8028f9:	48 b8 4a 22 80 00 00 	movabs $0x80224a,%rax
  802900:	00 00 00 
  802903:	ff d0                	callq  *%rax
  802905:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802908:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80290c:	78 24                	js     802932 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80290e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802912:	8b 00                	mov    (%rax),%eax
  802914:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802918:	48 89 d6             	mov    %rdx,%rsi
  80291b:	89 c7                	mov    %eax,%edi
  80291d:	48 b8 a3 23 80 00 00 	movabs $0x8023a3,%rax
  802924:	00 00 00 
  802927:	ff d0                	callq  *%rax
  802929:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80292c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802930:	79 05                	jns    802937 <ftruncate+0x58>
		return r;
  802932:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802935:	eb 72                	jmp    8029a9 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802937:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80293b:	8b 40 08             	mov    0x8(%rax),%eax
  80293e:	83 e0 03             	and    $0x3,%eax
  802941:	85 c0                	test   %eax,%eax
  802943:	75 3a                	jne    80297f <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802945:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  80294c:	00 00 00 
  80294f:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802952:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802958:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80295b:	89 c6                	mov    %eax,%esi
  80295d:	48 bf 80 42 80 00 00 	movabs $0x804280,%rdi
  802964:	00 00 00 
  802967:	b8 00 00 00 00       	mov    $0x0,%eax
  80296c:	48 b9 4a 07 80 00 00 	movabs $0x80074a,%rcx
  802973:	00 00 00 
  802976:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802978:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80297d:	eb 2a                	jmp    8029a9 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80297f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802983:	48 8b 40 30          	mov    0x30(%rax),%rax
  802987:	48 85 c0             	test   %rax,%rax
  80298a:	75 07                	jne    802993 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80298c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802991:	eb 16                	jmp    8029a9 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802993:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802997:	48 8b 40 30          	mov    0x30(%rax),%rax
  80299b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80299f:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8029a2:	89 ce                	mov    %ecx,%esi
  8029a4:	48 89 d7             	mov    %rdx,%rdi
  8029a7:	ff d0                	callq  *%rax
}
  8029a9:	c9                   	leaveq 
  8029aa:	c3                   	retq   

00000000008029ab <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8029ab:	55                   	push   %rbp
  8029ac:	48 89 e5             	mov    %rsp,%rbp
  8029af:	48 83 ec 30          	sub    $0x30,%rsp
  8029b3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8029b6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8029ba:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8029be:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029c1:	48 89 d6             	mov    %rdx,%rsi
  8029c4:	89 c7                	mov    %eax,%edi
  8029c6:	48 b8 4a 22 80 00 00 	movabs $0x80224a,%rax
  8029cd:	00 00 00 
  8029d0:	ff d0                	callq  *%rax
  8029d2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029d9:	78 24                	js     8029ff <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8029db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029df:	8b 00                	mov    (%rax),%eax
  8029e1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029e5:	48 89 d6             	mov    %rdx,%rsi
  8029e8:	89 c7                	mov    %eax,%edi
  8029ea:	48 b8 a3 23 80 00 00 	movabs $0x8023a3,%rax
  8029f1:	00 00 00 
  8029f4:	ff d0                	callq  *%rax
  8029f6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029fd:	79 05                	jns    802a04 <fstat+0x59>
		return r;
  8029ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a02:	eb 5e                	jmp    802a62 <fstat+0xb7>
	if (!dev->dev_stat)
  802a04:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a08:	48 8b 40 28          	mov    0x28(%rax),%rax
  802a0c:	48 85 c0             	test   %rax,%rax
  802a0f:	75 07                	jne    802a18 <fstat+0x6d>
		return -E_NOT_SUPP;
  802a11:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a16:	eb 4a                	jmp    802a62 <fstat+0xb7>
	stat->st_name[0] = 0;
  802a18:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a1c:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802a1f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a23:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802a2a:	00 00 00 
	stat->st_isdir = 0;
  802a2d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a31:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802a38:	00 00 00 
	stat->st_dev = dev;
  802a3b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a3f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a43:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802a4a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a4e:	48 8b 40 28          	mov    0x28(%rax),%rax
  802a52:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802a56:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802a5a:	48 89 ce             	mov    %rcx,%rsi
  802a5d:	48 89 d7             	mov    %rdx,%rdi
  802a60:	ff d0                	callq  *%rax
}
  802a62:	c9                   	leaveq 
  802a63:	c3                   	retq   

0000000000802a64 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802a64:	55                   	push   %rbp
  802a65:	48 89 e5             	mov    %rsp,%rbp
  802a68:	48 83 ec 20          	sub    $0x20,%rsp
  802a6c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a70:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802a74:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a78:	be 00 00 00 00       	mov    $0x0,%esi
  802a7d:	48 89 c7             	mov    %rax,%rdi
  802a80:	48 b8 52 2b 80 00 00 	movabs $0x802b52,%rax
  802a87:	00 00 00 
  802a8a:	ff d0                	callq  *%rax
  802a8c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a8f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a93:	79 05                	jns    802a9a <stat+0x36>
		return fd;
  802a95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a98:	eb 2f                	jmp    802ac9 <stat+0x65>
	r = fstat(fd, stat);
  802a9a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802a9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aa1:	48 89 d6             	mov    %rdx,%rsi
  802aa4:	89 c7                	mov    %eax,%edi
  802aa6:	48 b8 ab 29 80 00 00 	movabs $0x8029ab,%rax
  802aad:	00 00 00 
  802ab0:	ff d0                	callq  *%rax
  802ab2:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802ab5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ab8:	89 c7                	mov    %eax,%edi
  802aba:	48 b8 5a 24 80 00 00 	movabs $0x80245a,%rax
  802ac1:	00 00 00 
  802ac4:	ff d0                	callq  *%rax
	return r;
  802ac6:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802ac9:	c9                   	leaveq 
  802aca:	c3                   	retq   

0000000000802acb <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802acb:	55                   	push   %rbp
  802acc:	48 89 e5             	mov    %rsp,%rbp
  802acf:	48 83 ec 10          	sub    $0x10,%rsp
  802ad3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802ad6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802ada:	48 b8 00 74 80 00 00 	movabs $0x807400,%rax
  802ae1:	00 00 00 
  802ae4:	8b 00                	mov    (%rax),%eax
  802ae6:	85 c0                	test   %eax,%eax
  802ae8:	75 1d                	jne    802b07 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802aea:	bf 01 00 00 00       	mov    $0x1,%edi
  802aef:	48 b8 47 3b 80 00 00 	movabs $0x803b47,%rax
  802af6:	00 00 00 
  802af9:	ff d0                	callq  *%rax
  802afb:	48 ba 00 74 80 00 00 	movabs $0x807400,%rdx
  802b02:	00 00 00 
  802b05:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802b07:	48 b8 00 74 80 00 00 	movabs $0x807400,%rax
  802b0e:	00 00 00 
  802b11:	8b 00                	mov    (%rax),%eax
  802b13:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802b16:	b9 07 00 00 00       	mov    $0x7,%ecx
  802b1b:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  802b22:	00 00 00 
  802b25:	89 c7                	mov    %eax,%edi
  802b27:	48 b8 48 3a 80 00 00 	movabs $0x803a48,%rax
  802b2e:	00 00 00 
  802b31:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802b33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b37:	ba 00 00 00 00       	mov    $0x0,%edx
  802b3c:	48 89 c6             	mov    %rax,%rsi
  802b3f:	bf 00 00 00 00       	mov    $0x0,%edi
  802b44:	48 b8 95 39 80 00 00 	movabs $0x803995,%rax
  802b4b:	00 00 00 
  802b4e:	ff d0                	callq  *%rax
}
  802b50:	c9                   	leaveq 
  802b51:	c3                   	retq   

0000000000802b52 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802b52:	55                   	push   %rbp
  802b53:	48 89 e5             	mov    %rsp,%rbp
  802b56:	48 83 ec 20          	sub    $0x20,%rsp
  802b5a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b5e:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here

	struct Fd *fd;
	int ret;
	if (strlen(path)>=MAXPATHLEN)
  802b61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b65:	48 89 c7             	mov    %rax,%rdi
  802b68:	48 b8 2e 14 80 00 00 	movabs $0x80142e,%rax
  802b6f:	00 00 00 
  802b72:	ff d0                	callq  *%rax
  802b74:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802b79:	7e 0a                	jle    802b85 <open+0x33>
		return -E_BAD_PATH;
  802b7b:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802b80:	e9 a5 00 00 00       	jmpq   802c2a <open+0xd8>
	if ((ret=fd_alloc(&fd))<0)
  802b85:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802b89:	48 89 c7             	mov    %rax,%rdi
  802b8c:	48 b8 b2 21 80 00 00 	movabs $0x8021b2,%rax
  802b93:	00 00 00 
  802b96:	ff d0                	callq  *%rax
  802b98:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b9b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b9f:	79 08                	jns    802ba9 <open+0x57>
		return ret;
  802ba1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ba4:	e9 81 00 00 00       	jmpq   802c2a <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  802ba9:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802bb0:	00 00 00 
  802bb3:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802bb6:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy (fsipcbuf.open.req_path, path);
  802bbc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bc0:	48 89 c6             	mov    %rax,%rsi
  802bc3:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802bca:	00 00 00 
  802bcd:	48 b8 9a 14 80 00 00 	movabs $0x80149a,%rax
  802bd4:	00 00 00 
  802bd7:	ff d0                	callq  *%rax
	if ((ret=fsipc (FSREQ_OPEN, (void *) fd)) < 0)
  802bd9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bdd:	48 89 c6             	mov    %rax,%rsi
  802be0:	bf 01 00 00 00       	mov    $0x1,%edi
  802be5:	48 b8 cb 2a 80 00 00 	movabs $0x802acb,%rax
  802bec:	00 00 00 
  802bef:	ff d0                	callq  *%rax
  802bf1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bf4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bf8:	79 1d                	jns    802c17 <open+0xc5>
	{
		fd_close(fd,0);
  802bfa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bfe:	be 00 00 00 00       	mov    $0x0,%esi
  802c03:	48 89 c7             	mov    %rax,%rdi
  802c06:	48 b8 da 22 80 00 00 	movabs $0x8022da,%rax
  802c0d:	00 00 00 
  802c10:	ff d0                	callq  *%rax
		return ret;
  802c12:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c15:	eb 13                	jmp    802c2a <open+0xd8>
	}
	return fd2num (fd);
  802c17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c1b:	48 89 c7             	mov    %rax,%rdi
  802c1e:	48 b8 64 21 80 00 00 	movabs $0x802164,%rax
  802c25:	00 00 00 
  802c28:	ff d0                	callq  *%rax
	panic ("open not implemented");
}
  802c2a:	c9                   	leaveq 
  802c2b:	c3                   	retq   

0000000000802c2c <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802c2c:	55                   	push   %rbp
  802c2d:	48 89 e5             	mov    %rsp,%rbp
  802c30:	48 83 ec 10          	sub    $0x10,%rsp
  802c34:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802c38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c3c:	8b 50 0c             	mov    0xc(%rax),%edx
  802c3f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c46:	00 00 00 
  802c49:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802c4b:	be 00 00 00 00       	mov    $0x0,%esi
  802c50:	bf 06 00 00 00       	mov    $0x6,%edi
  802c55:	48 b8 cb 2a 80 00 00 	movabs $0x802acb,%rax
  802c5c:	00 00 00 
  802c5f:	ff d0                	callq  *%rax
}
  802c61:	c9                   	leaveq 
  802c62:	c3                   	retq   

0000000000802c63 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802c63:	55                   	push   %rbp
  802c64:	48 89 e5             	mov    %rsp,%rbp
  802c67:	48 83 ec 30          	sub    $0x30,%rsp
  802c6b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c6f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c73:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int ret;
	fsipcbuf.read.req_fileid=fd->fd_file.id;
  802c77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c7b:	8b 50 0c             	mov    0xc(%rax),%edx
  802c7e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c85:	00 00 00 
  802c88:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n=n;
  802c8a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c91:	00 00 00 
  802c94:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802c98:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	if ((ret=fsipc(FSREQ_READ,NULL))<0)
  802c9c:	be 00 00 00 00       	mov    $0x0,%esi
  802ca1:	bf 03 00 00 00       	mov    $0x3,%edi
  802ca6:	48 b8 cb 2a 80 00 00 	movabs $0x802acb,%rax
  802cad:	00 00 00 
  802cb0:	ff d0                	callq  *%rax
  802cb2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cb5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cb9:	79 05                	jns    802cc0 <devfile_read+0x5d>
		return ret;
  802cbb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cbe:	eb 26                	jmp    802ce6 <devfile_read+0x83>
	memmove (buf, fsipcbuf.readRet.ret_buf, ret);
  802cc0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cc3:	48 63 d0             	movslq %eax,%rdx
  802cc6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cca:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802cd1:	00 00 00 
  802cd4:	48 89 c7             	mov    %rax,%rdi
  802cd7:	48 b8 be 17 80 00 00 	movabs $0x8017be,%rax
  802cde:	00 00 00 
  802ce1:	ff d0                	callq  *%rax
	return ret;
  802ce3:	8b 45 fc             	mov    -0x4(%rbp),%eax
	panic("devfile_read not implemented");
}
  802ce6:	c9                   	leaveq 
  802ce7:	c3                   	retq   

0000000000802ce8 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802ce8:	55                   	push   %rbp
  802ce9:	48 89 e5             	mov    %rsp,%rbp
  802cec:	48 83 ec 30          	sub    $0x30,%rsp
  802cf0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802cf4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802cf8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here

	int ret;
	fsipcbuf.write.req_fileid=fd->fd_file.id;
  802cfc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d00:	8b 50 0c             	mov    0xc(%rax),%edx
  802d03:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d0a:	00 00 00 
  802d0d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n=n>sizeof(fsipcbuf.write.req_buf)?sizeof(fsipcbuf.write.req_buf):n;
  802d0f:	b8 f4 0f 00 00       	mov    $0xff4,%eax
  802d14:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  802d1b:	00 
  802d1c:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  802d21:	48 89 c2             	mov    %rax,%rdx
  802d24:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d2b:	00 00 00 
  802d2e:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove (fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  802d32:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d39:	00 00 00 
  802d3c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802d40:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d44:	48 89 c6             	mov    %rax,%rsi
  802d47:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802d4e:	00 00 00 
  802d51:	48 b8 be 17 80 00 00 	movabs $0x8017be,%rax
  802d58:	00 00 00 
  802d5b:	ff d0                	callq  *%rax
	if ((ret=fsipc(FSREQ_WRITE,NULL))<0)
  802d5d:	be 00 00 00 00       	mov    $0x0,%esi
  802d62:	bf 04 00 00 00       	mov    $0x4,%edi
  802d67:	48 b8 cb 2a 80 00 00 	movabs $0x802acb,%rax
  802d6e:	00 00 00 
  802d71:	ff d0                	callq  *%rax
  802d73:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d76:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d7a:	79 05                	jns    802d81 <devfile_write+0x99>
		return ret;
  802d7c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d7f:	eb 03                	jmp    802d84 <devfile_write+0x9c>
	
	return ret;
  802d81:	8b 45 fc             	mov    -0x4(%rbp),%eax


	panic("devfile_write not implemented");
}
  802d84:	c9                   	leaveq 
  802d85:	c3                   	retq   

0000000000802d86 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802d86:	55                   	push   %rbp
  802d87:	48 89 e5             	mov    %rsp,%rbp
  802d8a:	48 83 ec 20          	sub    $0x20,%rsp
  802d8e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d92:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802d96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d9a:	8b 50 0c             	mov    0xc(%rax),%edx
  802d9d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802da4:	00 00 00 
  802da7:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802da9:	be 00 00 00 00       	mov    $0x0,%esi
  802dae:	bf 05 00 00 00       	mov    $0x5,%edi
  802db3:	48 b8 cb 2a 80 00 00 	movabs $0x802acb,%rax
  802dba:	00 00 00 
  802dbd:	ff d0                	callq  *%rax
  802dbf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dc2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dc6:	79 05                	jns    802dcd <devfile_stat+0x47>
		return r;
  802dc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dcb:	eb 56                	jmp    802e23 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802dcd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802dd1:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802dd8:	00 00 00 
  802ddb:	48 89 c7             	mov    %rax,%rdi
  802dde:	48 b8 9a 14 80 00 00 	movabs $0x80149a,%rax
  802de5:	00 00 00 
  802de8:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802dea:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802df1:	00 00 00 
  802df4:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802dfa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802dfe:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802e04:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e0b:	00 00 00 
  802e0e:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802e14:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e18:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802e1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e23:	c9                   	leaveq 
  802e24:	c3                   	retq   

0000000000802e25 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802e25:	55                   	push   %rbp
  802e26:	48 89 e5             	mov    %rsp,%rbp
  802e29:	48 83 ec 10          	sub    $0x10,%rsp
  802e2d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e31:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802e34:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e38:	8b 50 0c             	mov    0xc(%rax),%edx
  802e3b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e42:	00 00 00 
  802e45:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802e47:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e4e:	00 00 00 
  802e51:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802e54:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802e57:	be 00 00 00 00       	mov    $0x0,%esi
  802e5c:	bf 02 00 00 00       	mov    $0x2,%edi
  802e61:	48 b8 cb 2a 80 00 00 	movabs $0x802acb,%rax
  802e68:	00 00 00 
  802e6b:	ff d0                	callq  *%rax
}
  802e6d:	c9                   	leaveq 
  802e6e:	c3                   	retq   

0000000000802e6f <remove>:

// Delete a file
int
remove(const char *path)
{
  802e6f:	55                   	push   %rbp
  802e70:	48 89 e5             	mov    %rsp,%rbp
  802e73:	48 83 ec 10          	sub    $0x10,%rsp
  802e77:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802e7b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e7f:	48 89 c7             	mov    %rax,%rdi
  802e82:	48 b8 2e 14 80 00 00 	movabs $0x80142e,%rax
  802e89:	00 00 00 
  802e8c:	ff d0                	callq  *%rax
  802e8e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802e93:	7e 07                	jle    802e9c <remove+0x2d>
		return -E_BAD_PATH;
  802e95:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802e9a:	eb 33                	jmp    802ecf <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802e9c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ea0:	48 89 c6             	mov    %rax,%rsi
  802ea3:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802eaa:	00 00 00 
  802ead:	48 b8 9a 14 80 00 00 	movabs $0x80149a,%rax
  802eb4:	00 00 00 
  802eb7:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802eb9:	be 00 00 00 00       	mov    $0x0,%esi
  802ebe:	bf 07 00 00 00       	mov    $0x7,%edi
  802ec3:	48 b8 cb 2a 80 00 00 	movabs $0x802acb,%rax
  802eca:	00 00 00 
  802ecd:	ff d0                	callq  *%rax
}
  802ecf:	c9                   	leaveq 
  802ed0:	c3                   	retq   

0000000000802ed1 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802ed1:	55                   	push   %rbp
  802ed2:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802ed5:	be 00 00 00 00       	mov    $0x0,%esi
  802eda:	bf 08 00 00 00       	mov    $0x8,%edi
  802edf:	48 b8 cb 2a 80 00 00 	movabs $0x802acb,%rax
  802ee6:	00 00 00 
  802ee9:	ff d0                	callq  *%rax
}
  802eeb:	5d                   	pop    %rbp
  802eec:	c3                   	retq   

0000000000802eed <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802eed:	55                   	push   %rbp
  802eee:	48 89 e5             	mov    %rsp,%rbp
  802ef1:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802ef8:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802eff:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802f06:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802f0d:	be 00 00 00 00       	mov    $0x0,%esi
  802f12:	48 89 c7             	mov    %rax,%rdi
  802f15:	48 b8 52 2b 80 00 00 	movabs $0x802b52,%rax
  802f1c:	00 00 00 
  802f1f:	ff d0                	callq  *%rax
  802f21:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802f24:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f28:	79 28                	jns    802f52 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802f2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f2d:	89 c6                	mov    %eax,%esi
  802f2f:	48 bf a6 42 80 00 00 	movabs $0x8042a6,%rdi
  802f36:	00 00 00 
  802f39:	b8 00 00 00 00       	mov    $0x0,%eax
  802f3e:	48 ba 4a 07 80 00 00 	movabs $0x80074a,%rdx
  802f45:	00 00 00 
  802f48:	ff d2                	callq  *%rdx
		return fd_src;
  802f4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f4d:	e9 74 01 00 00       	jmpq   8030c6 <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802f52:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802f59:	be 01 01 00 00       	mov    $0x101,%esi
  802f5e:	48 89 c7             	mov    %rax,%rdi
  802f61:	48 b8 52 2b 80 00 00 	movabs $0x802b52,%rax
  802f68:	00 00 00 
  802f6b:	ff d0                	callq  *%rax
  802f6d:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802f70:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802f74:	79 39                	jns    802faf <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802f76:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f79:	89 c6                	mov    %eax,%esi
  802f7b:	48 bf bc 42 80 00 00 	movabs $0x8042bc,%rdi
  802f82:	00 00 00 
  802f85:	b8 00 00 00 00       	mov    $0x0,%eax
  802f8a:	48 ba 4a 07 80 00 00 	movabs $0x80074a,%rdx
  802f91:	00 00 00 
  802f94:	ff d2                	callq  *%rdx
		close(fd_src);
  802f96:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f99:	89 c7                	mov    %eax,%edi
  802f9b:	48 b8 5a 24 80 00 00 	movabs $0x80245a,%rax
  802fa2:	00 00 00 
  802fa5:	ff d0                	callq  *%rax
		return fd_dest;
  802fa7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802faa:	e9 17 01 00 00       	jmpq   8030c6 <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802faf:	eb 74                	jmp    803025 <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  802fb1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802fb4:	48 63 d0             	movslq %eax,%rdx
  802fb7:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802fbe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802fc1:	48 89 ce             	mov    %rcx,%rsi
  802fc4:	89 c7                	mov    %eax,%edi
  802fc6:	48 b8 c6 27 80 00 00 	movabs $0x8027c6,%rax
  802fcd:	00 00 00 
  802fd0:	ff d0                	callq  *%rax
  802fd2:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802fd5:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802fd9:	79 4a                	jns    803025 <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  802fdb:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802fde:	89 c6                	mov    %eax,%esi
  802fe0:	48 bf d6 42 80 00 00 	movabs $0x8042d6,%rdi
  802fe7:	00 00 00 
  802fea:	b8 00 00 00 00       	mov    $0x0,%eax
  802fef:	48 ba 4a 07 80 00 00 	movabs $0x80074a,%rdx
  802ff6:	00 00 00 
  802ff9:	ff d2                	callq  *%rdx
			close(fd_src);
  802ffb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ffe:	89 c7                	mov    %eax,%edi
  803000:	48 b8 5a 24 80 00 00 	movabs $0x80245a,%rax
  803007:	00 00 00 
  80300a:	ff d0                	callq  *%rax
			close(fd_dest);
  80300c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80300f:	89 c7                	mov    %eax,%edi
  803011:	48 b8 5a 24 80 00 00 	movabs $0x80245a,%rax
  803018:	00 00 00 
  80301b:	ff d0                	callq  *%rax
			return write_size;
  80301d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803020:	e9 a1 00 00 00       	jmpq   8030c6 <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803025:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80302c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80302f:	ba 00 02 00 00       	mov    $0x200,%edx
  803034:	48 89 ce             	mov    %rcx,%rsi
  803037:	89 c7                	mov    %eax,%edi
  803039:	48 b8 7c 26 80 00 00 	movabs $0x80267c,%rax
  803040:	00 00 00 
  803043:	ff d0                	callq  *%rax
  803045:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803048:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80304c:	0f 8f 5f ff ff ff    	jg     802fb1 <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803052:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803056:	79 47                	jns    80309f <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803058:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80305b:	89 c6                	mov    %eax,%esi
  80305d:	48 bf e9 42 80 00 00 	movabs $0x8042e9,%rdi
  803064:	00 00 00 
  803067:	b8 00 00 00 00       	mov    $0x0,%eax
  80306c:	48 ba 4a 07 80 00 00 	movabs $0x80074a,%rdx
  803073:	00 00 00 
  803076:	ff d2                	callq  *%rdx
		close(fd_src);
  803078:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80307b:	89 c7                	mov    %eax,%edi
  80307d:	48 b8 5a 24 80 00 00 	movabs $0x80245a,%rax
  803084:	00 00 00 
  803087:	ff d0                	callq  *%rax
		close(fd_dest);
  803089:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80308c:	89 c7                	mov    %eax,%edi
  80308e:	48 b8 5a 24 80 00 00 	movabs $0x80245a,%rax
  803095:	00 00 00 
  803098:	ff d0                	callq  *%rax
		return read_size;
  80309a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80309d:	eb 27                	jmp    8030c6 <copy+0x1d9>
	}
	close(fd_src);
  80309f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030a2:	89 c7                	mov    %eax,%edi
  8030a4:	48 b8 5a 24 80 00 00 	movabs $0x80245a,%rax
  8030ab:	00 00 00 
  8030ae:	ff d0                	callq  *%rax
	close(fd_dest);
  8030b0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030b3:	89 c7                	mov    %eax,%edi
  8030b5:	48 b8 5a 24 80 00 00 	movabs $0x80245a,%rax
  8030bc:	00 00 00 
  8030bf:	ff d0                	callq  *%rax
	return 0;
  8030c1:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8030c6:	c9                   	leaveq 
  8030c7:	c3                   	retq   

00000000008030c8 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  8030c8:	55                   	push   %rbp
  8030c9:	48 89 e5             	mov    %rsp,%rbp
  8030cc:	48 83 ec 20          	sub    $0x20,%rsp
  8030d0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  8030d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030d8:	8b 40 0c             	mov    0xc(%rax),%eax
  8030db:	85 c0                	test   %eax,%eax
  8030dd:	7e 67                	jle    803146 <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  8030df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030e3:	8b 40 04             	mov    0x4(%rax),%eax
  8030e6:	48 63 d0             	movslq %eax,%rdx
  8030e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030ed:	48 8d 48 10          	lea    0x10(%rax),%rcx
  8030f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030f5:	8b 00                	mov    (%rax),%eax
  8030f7:	48 89 ce             	mov    %rcx,%rsi
  8030fa:	89 c7                	mov    %eax,%edi
  8030fc:	48 b8 c6 27 80 00 00 	movabs $0x8027c6,%rax
  803103:	00 00 00 
  803106:	ff d0                	callq  *%rax
  803108:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  80310b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80310f:	7e 13                	jle    803124 <writebuf+0x5c>
			b->result += result;
  803111:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803115:	8b 50 08             	mov    0x8(%rax),%edx
  803118:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80311b:	01 c2                	add    %eax,%edx
  80311d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803121:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  803124:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803128:	8b 40 04             	mov    0x4(%rax),%eax
  80312b:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  80312e:	74 16                	je     803146 <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  803130:	b8 00 00 00 00       	mov    $0x0,%eax
  803135:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803139:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  80313d:	89 c2                	mov    %eax,%edx
  80313f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803143:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  803146:	c9                   	leaveq 
  803147:	c3                   	retq   

0000000000803148 <putch>:

static void
putch(int ch, void *thunk)
{
  803148:	55                   	push   %rbp
  803149:	48 89 e5             	mov    %rsp,%rbp
  80314c:	48 83 ec 20          	sub    $0x20,%rsp
  803150:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803153:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  803157:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80315b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  80315f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803163:	8b 40 04             	mov    0x4(%rax),%eax
  803166:	8d 48 01             	lea    0x1(%rax),%ecx
  803169:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80316d:	89 4a 04             	mov    %ecx,0x4(%rdx)
  803170:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803173:	89 d1                	mov    %edx,%ecx
  803175:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803179:	48 98                	cltq   
  80317b:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  80317f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803183:	8b 40 04             	mov    0x4(%rax),%eax
  803186:	3d 00 01 00 00       	cmp    $0x100,%eax
  80318b:	75 1e                	jne    8031ab <putch+0x63>
		writebuf(b);
  80318d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803191:	48 89 c7             	mov    %rax,%rdi
  803194:	48 b8 c8 30 80 00 00 	movabs $0x8030c8,%rax
  80319b:	00 00 00 
  80319e:	ff d0                	callq  *%rax
		b->idx = 0;
  8031a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  8031ab:	c9                   	leaveq 
  8031ac:	c3                   	retq   

00000000008031ad <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8031ad:	55                   	push   %rbp
  8031ae:	48 89 e5             	mov    %rsp,%rbp
  8031b1:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  8031b8:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  8031be:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  8031c5:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  8031cc:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  8031d2:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  8031d8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8031df:	00 00 00 
	b.result = 0;
  8031e2:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  8031e9:	00 00 00 
	b.error = 1;
  8031ec:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  8031f3:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8031f6:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  8031fd:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  803204:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80320b:	48 89 c6             	mov    %rax,%rsi
  80320e:	48 bf 48 31 80 00 00 	movabs $0x803148,%rdi
  803215:	00 00 00 
  803218:	48 b8 fd 0a 80 00 00 	movabs $0x800afd,%rax
  80321f:	00 00 00 
  803222:	ff d0                	callq  *%rax
	if (b.idx > 0)
  803224:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  80322a:	85 c0                	test   %eax,%eax
  80322c:	7e 16                	jle    803244 <vfprintf+0x97>
		writebuf(&b);
  80322e:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  803235:	48 89 c7             	mov    %rax,%rdi
  803238:	48 b8 c8 30 80 00 00 	movabs $0x8030c8,%rax
  80323f:	00 00 00 
  803242:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  803244:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  80324a:	85 c0                	test   %eax,%eax
  80324c:	74 08                	je     803256 <vfprintf+0xa9>
  80324e:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  803254:	eb 06                	jmp    80325c <vfprintf+0xaf>
  803256:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  80325c:	c9                   	leaveq 
  80325d:	c3                   	retq   

000000000080325e <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  80325e:	55                   	push   %rbp
  80325f:	48 89 e5             	mov    %rsp,%rbp
  803262:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  803269:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  80326f:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  803276:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80327d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803284:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80328b:	84 c0                	test   %al,%al
  80328d:	74 20                	je     8032af <fprintf+0x51>
  80328f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803293:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803297:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80329b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80329f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8032a3:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8032a7:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8032ab:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8032af:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8032b6:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  8032bd:	00 00 00 
  8032c0:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8032c7:	00 00 00 
  8032ca:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8032ce:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8032d5:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8032dc:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  8032e3:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8032ea:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  8032f1:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8032f7:	48 89 ce             	mov    %rcx,%rsi
  8032fa:	89 c7                	mov    %eax,%edi
  8032fc:	48 b8 ad 31 80 00 00 	movabs $0x8031ad,%rax
  803303:	00 00 00 
  803306:	ff d0                	callq  *%rax
  803308:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  80330e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803314:	c9                   	leaveq 
  803315:	c3                   	retq   

0000000000803316 <printf>:

int
printf(const char *fmt, ...)
{
  803316:	55                   	push   %rbp
  803317:	48 89 e5             	mov    %rsp,%rbp
  80331a:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  803321:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  803328:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80332f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803336:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80333d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803344:	84 c0                	test   %al,%al
  803346:	74 20                	je     803368 <printf+0x52>
  803348:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80334c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803350:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803354:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803358:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80335c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803360:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803364:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  803368:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80336f:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  803376:	00 00 00 
  803379:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803380:	00 00 00 
  803383:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803387:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80338e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803395:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(1, fmt, ap);
  80339c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8033a3:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8033aa:	48 89 c6             	mov    %rax,%rsi
  8033ad:	bf 01 00 00 00       	mov    $0x1,%edi
  8033b2:	48 b8 ad 31 80 00 00 	movabs $0x8031ad,%rax
  8033b9:	00 00 00 
  8033bc:	ff d0                	callq  *%rax
  8033be:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  8033c4:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8033ca:	c9                   	leaveq 
  8033cb:	c3                   	retq   

00000000008033cc <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8033cc:	55                   	push   %rbp
  8033cd:	48 89 e5             	mov    %rsp,%rbp
  8033d0:	53                   	push   %rbx
  8033d1:	48 83 ec 38          	sub    $0x38,%rsp
  8033d5:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8033d9:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8033dd:	48 89 c7             	mov    %rax,%rdi
  8033e0:	48 b8 b2 21 80 00 00 	movabs $0x8021b2,%rax
  8033e7:	00 00 00 
  8033ea:	ff d0                	callq  *%rax
  8033ec:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8033ef:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8033f3:	0f 88 bf 01 00 00    	js     8035b8 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8033f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033fd:	ba 07 04 00 00       	mov    $0x407,%edx
  803402:	48 89 c6             	mov    %rax,%rsi
  803405:	bf 00 00 00 00       	mov    $0x0,%edi
  80340a:	48 b8 c9 1d 80 00 00 	movabs $0x801dc9,%rax
  803411:	00 00 00 
  803414:	ff d0                	callq  *%rax
  803416:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803419:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80341d:	0f 88 95 01 00 00    	js     8035b8 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803423:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803427:	48 89 c7             	mov    %rax,%rdi
  80342a:	48 b8 b2 21 80 00 00 	movabs $0x8021b2,%rax
  803431:	00 00 00 
  803434:	ff d0                	callq  *%rax
  803436:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803439:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80343d:	0f 88 5d 01 00 00    	js     8035a0 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803443:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803447:	ba 07 04 00 00       	mov    $0x407,%edx
  80344c:	48 89 c6             	mov    %rax,%rsi
  80344f:	bf 00 00 00 00       	mov    $0x0,%edi
  803454:	48 b8 c9 1d 80 00 00 	movabs $0x801dc9,%rax
  80345b:	00 00 00 
  80345e:	ff d0                	callq  *%rax
  803460:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803463:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803467:	0f 88 33 01 00 00    	js     8035a0 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80346d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803471:	48 89 c7             	mov    %rax,%rdi
  803474:	48 b8 87 21 80 00 00 	movabs $0x802187,%rax
  80347b:	00 00 00 
  80347e:	ff d0                	callq  *%rax
  803480:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803484:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803488:	ba 07 04 00 00       	mov    $0x407,%edx
  80348d:	48 89 c6             	mov    %rax,%rsi
  803490:	bf 00 00 00 00       	mov    $0x0,%edi
  803495:	48 b8 c9 1d 80 00 00 	movabs $0x801dc9,%rax
  80349c:	00 00 00 
  80349f:	ff d0                	callq  *%rax
  8034a1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034a4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8034a8:	79 05                	jns    8034af <pipe+0xe3>
		goto err2;
  8034aa:	e9 d9 00 00 00       	jmpq   803588 <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8034af:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8034b3:	48 89 c7             	mov    %rax,%rdi
  8034b6:	48 b8 87 21 80 00 00 	movabs $0x802187,%rax
  8034bd:	00 00 00 
  8034c0:	ff d0                	callq  *%rax
  8034c2:	48 89 c2             	mov    %rax,%rdx
  8034c5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034c9:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8034cf:	48 89 d1             	mov    %rdx,%rcx
  8034d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8034d7:	48 89 c6             	mov    %rax,%rsi
  8034da:	bf 00 00 00 00       	mov    $0x0,%edi
  8034df:	48 b8 19 1e 80 00 00 	movabs $0x801e19,%rax
  8034e6:	00 00 00 
  8034e9:	ff d0                	callq  *%rax
  8034eb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8034ee:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8034f2:	79 1b                	jns    80350f <pipe+0x143>
		goto err3;
  8034f4:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8034f5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034f9:	48 89 c6             	mov    %rax,%rsi
  8034fc:	bf 00 00 00 00       	mov    $0x0,%edi
  803501:	48 b8 74 1e 80 00 00 	movabs $0x801e74,%rax
  803508:	00 00 00 
  80350b:	ff d0                	callq  *%rax
  80350d:	eb 79                	jmp    803588 <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80350f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803513:	48 ba 00 61 80 00 00 	movabs $0x806100,%rdx
  80351a:	00 00 00 
  80351d:	8b 12                	mov    (%rdx),%edx
  80351f:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803521:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803525:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80352c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803530:	48 ba 00 61 80 00 00 	movabs $0x806100,%rdx
  803537:	00 00 00 
  80353a:	8b 12                	mov    (%rdx),%edx
  80353c:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80353e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803542:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803549:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80354d:	48 89 c7             	mov    %rax,%rdi
  803550:	48 b8 64 21 80 00 00 	movabs $0x802164,%rax
  803557:	00 00 00 
  80355a:	ff d0                	callq  *%rax
  80355c:	89 c2                	mov    %eax,%edx
  80355e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803562:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803564:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803568:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80356c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803570:	48 89 c7             	mov    %rax,%rdi
  803573:	48 b8 64 21 80 00 00 	movabs $0x802164,%rax
  80357a:	00 00 00 
  80357d:	ff d0                	callq  *%rax
  80357f:	89 03                	mov    %eax,(%rbx)
	return 0;
  803581:	b8 00 00 00 00       	mov    $0x0,%eax
  803586:	eb 33                	jmp    8035bb <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803588:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80358c:	48 89 c6             	mov    %rax,%rsi
  80358f:	bf 00 00 00 00       	mov    $0x0,%edi
  803594:	48 b8 74 1e 80 00 00 	movabs $0x801e74,%rax
  80359b:	00 00 00 
  80359e:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8035a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035a4:	48 89 c6             	mov    %rax,%rsi
  8035a7:	bf 00 00 00 00       	mov    $0x0,%edi
  8035ac:	48 b8 74 1e 80 00 00 	movabs $0x801e74,%rax
  8035b3:	00 00 00 
  8035b6:	ff d0                	callq  *%rax
err:
	return r;
  8035b8:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8035bb:	48 83 c4 38          	add    $0x38,%rsp
  8035bf:	5b                   	pop    %rbx
  8035c0:	5d                   	pop    %rbp
  8035c1:	c3                   	retq   

00000000008035c2 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8035c2:	55                   	push   %rbp
  8035c3:	48 89 e5             	mov    %rsp,%rbp
  8035c6:	53                   	push   %rbx
  8035c7:	48 83 ec 28          	sub    $0x28,%rsp
  8035cb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8035cf:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8035d3:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  8035da:	00 00 00 
  8035dd:	48 8b 00             	mov    (%rax),%rax
  8035e0:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8035e6:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8035e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8035ed:	48 89 c7             	mov    %rax,%rdi
  8035f0:	48 b8 b9 3b 80 00 00 	movabs $0x803bb9,%rax
  8035f7:	00 00 00 
  8035fa:	ff d0                	callq  *%rax
  8035fc:	89 c3                	mov    %eax,%ebx
  8035fe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803602:	48 89 c7             	mov    %rax,%rdi
  803605:	48 b8 b9 3b 80 00 00 	movabs $0x803bb9,%rax
  80360c:	00 00 00 
  80360f:	ff d0                	callq  *%rax
  803611:	39 c3                	cmp    %eax,%ebx
  803613:	0f 94 c0             	sete   %al
  803616:	0f b6 c0             	movzbl %al,%eax
  803619:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80361c:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  803623:	00 00 00 
  803626:	48 8b 00             	mov    (%rax),%rax
  803629:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80362f:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803632:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803635:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803638:	75 05                	jne    80363f <_pipeisclosed+0x7d>
			return ret;
  80363a:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80363d:	eb 4f                	jmp    80368e <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  80363f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803642:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803645:	74 42                	je     803689 <_pipeisclosed+0xc7>
  803647:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80364b:	75 3c                	jne    803689 <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80364d:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  803654:	00 00 00 
  803657:	48 8b 00             	mov    (%rax),%rax
  80365a:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803660:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803663:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803666:	89 c6                	mov    %eax,%esi
  803668:	48 bf 09 43 80 00 00 	movabs $0x804309,%rdi
  80366f:	00 00 00 
  803672:	b8 00 00 00 00       	mov    $0x0,%eax
  803677:	49 b8 4a 07 80 00 00 	movabs $0x80074a,%r8
  80367e:	00 00 00 
  803681:	41 ff d0             	callq  *%r8
	}
  803684:	e9 4a ff ff ff       	jmpq   8035d3 <_pipeisclosed+0x11>
  803689:	e9 45 ff ff ff       	jmpq   8035d3 <_pipeisclosed+0x11>
}
  80368e:	48 83 c4 28          	add    $0x28,%rsp
  803692:	5b                   	pop    %rbx
  803693:	5d                   	pop    %rbp
  803694:	c3                   	retq   

0000000000803695 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803695:	55                   	push   %rbp
  803696:	48 89 e5             	mov    %rsp,%rbp
  803699:	48 83 ec 30          	sub    $0x30,%rsp
  80369d:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8036a0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8036a4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8036a7:	48 89 d6             	mov    %rdx,%rsi
  8036aa:	89 c7                	mov    %eax,%edi
  8036ac:	48 b8 4a 22 80 00 00 	movabs $0x80224a,%rax
  8036b3:	00 00 00 
  8036b6:	ff d0                	callq  *%rax
  8036b8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036bf:	79 05                	jns    8036c6 <pipeisclosed+0x31>
		return r;
  8036c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036c4:	eb 31                	jmp    8036f7 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8036c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036ca:	48 89 c7             	mov    %rax,%rdi
  8036cd:	48 b8 87 21 80 00 00 	movabs $0x802187,%rax
  8036d4:	00 00 00 
  8036d7:	ff d0                	callq  *%rax
  8036d9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8036dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036e1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8036e5:	48 89 d6             	mov    %rdx,%rsi
  8036e8:	48 89 c7             	mov    %rax,%rdi
  8036eb:	48 b8 c2 35 80 00 00 	movabs $0x8035c2,%rax
  8036f2:	00 00 00 
  8036f5:	ff d0                	callq  *%rax
}
  8036f7:	c9                   	leaveq 
  8036f8:	c3                   	retq   

00000000008036f9 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8036f9:	55                   	push   %rbp
  8036fa:	48 89 e5             	mov    %rsp,%rbp
  8036fd:	48 83 ec 40          	sub    $0x40,%rsp
  803701:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803705:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803709:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80370d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803711:	48 89 c7             	mov    %rax,%rdi
  803714:	48 b8 87 21 80 00 00 	movabs $0x802187,%rax
  80371b:	00 00 00 
  80371e:	ff d0                	callq  *%rax
  803720:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803724:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803728:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80372c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803733:	00 
  803734:	e9 92 00 00 00       	jmpq   8037cb <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803739:	eb 41                	jmp    80377c <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80373b:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803740:	74 09                	je     80374b <devpipe_read+0x52>
				return i;
  803742:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803746:	e9 92 00 00 00       	jmpq   8037dd <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80374b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80374f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803753:	48 89 d6             	mov    %rdx,%rsi
  803756:	48 89 c7             	mov    %rax,%rdi
  803759:	48 b8 c2 35 80 00 00 	movabs $0x8035c2,%rax
  803760:	00 00 00 
  803763:	ff d0                	callq  *%rax
  803765:	85 c0                	test   %eax,%eax
  803767:	74 07                	je     803770 <devpipe_read+0x77>
				return 0;
  803769:	b8 00 00 00 00       	mov    $0x0,%eax
  80376e:	eb 6d                	jmp    8037dd <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803770:	48 b8 8b 1d 80 00 00 	movabs $0x801d8b,%rax
  803777:	00 00 00 
  80377a:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80377c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803780:	8b 10                	mov    (%rax),%edx
  803782:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803786:	8b 40 04             	mov    0x4(%rax),%eax
  803789:	39 c2                	cmp    %eax,%edx
  80378b:	74 ae                	je     80373b <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80378d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803791:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803795:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803799:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80379d:	8b 00                	mov    (%rax),%eax
  80379f:	99                   	cltd   
  8037a0:	c1 ea 1b             	shr    $0x1b,%edx
  8037a3:	01 d0                	add    %edx,%eax
  8037a5:	83 e0 1f             	and    $0x1f,%eax
  8037a8:	29 d0                	sub    %edx,%eax
  8037aa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8037ae:	48 98                	cltq   
  8037b0:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8037b5:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8037b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037bb:	8b 00                	mov    (%rax),%eax
  8037bd:	8d 50 01             	lea    0x1(%rax),%edx
  8037c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037c4:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8037c6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8037cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037cf:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8037d3:	0f 82 60 ff ff ff    	jb     803739 <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8037d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8037dd:	c9                   	leaveq 
  8037de:	c3                   	retq   

00000000008037df <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8037df:	55                   	push   %rbp
  8037e0:	48 89 e5             	mov    %rsp,%rbp
  8037e3:	48 83 ec 40          	sub    $0x40,%rsp
  8037e7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8037eb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8037ef:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8037f3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037f7:	48 89 c7             	mov    %rax,%rdi
  8037fa:	48 b8 87 21 80 00 00 	movabs $0x802187,%rax
  803801:	00 00 00 
  803804:	ff d0                	callq  *%rax
  803806:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80380a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80380e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803812:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803819:	00 
  80381a:	e9 8e 00 00 00       	jmpq   8038ad <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80381f:	eb 31                	jmp    803852 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803821:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803825:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803829:	48 89 d6             	mov    %rdx,%rsi
  80382c:	48 89 c7             	mov    %rax,%rdi
  80382f:	48 b8 c2 35 80 00 00 	movabs $0x8035c2,%rax
  803836:	00 00 00 
  803839:	ff d0                	callq  *%rax
  80383b:	85 c0                	test   %eax,%eax
  80383d:	74 07                	je     803846 <devpipe_write+0x67>
				return 0;
  80383f:	b8 00 00 00 00       	mov    $0x0,%eax
  803844:	eb 79                	jmp    8038bf <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803846:	48 b8 8b 1d 80 00 00 	movabs $0x801d8b,%rax
  80384d:	00 00 00 
  803850:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803852:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803856:	8b 40 04             	mov    0x4(%rax),%eax
  803859:	48 63 d0             	movslq %eax,%rdx
  80385c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803860:	8b 00                	mov    (%rax),%eax
  803862:	48 98                	cltq   
  803864:	48 83 c0 20          	add    $0x20,%rax
  803868:	48 39 c2             	cmp    %rax,%rdx
  80386b:	73 b4                	jae    803821 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80386d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803871:	8b 40 04             	mov    0x4(%rax),%eax
  803874:	99                   	cltd   
  803875:	c1 ea 1b             	shr    $0x1b,%edx
  803878:	01 d0                	add    %edx,%eax
  80387a:	83 e0 1f             	and    $0x1f,%eax
  80387d:	29 d0                	sub    %edx,%eax
  80387f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803883:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803887:	48 01 ca             	add    %rcx,%rdx
  80388a:	0f b6 0a             	movzbl (%rdx),%ecx
  80388d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803891:	48 98                	cltq   
  803893:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803897:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80389b:	8b 40 04             	mov    0x4(%rax),%eax
  80389e:	8d 50 01             	lea    0x1(%rax),%edx
  8038a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038a5:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8038a8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8038ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038b1:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8038b5:	0f 82 64 ff ff ff    	jb     80381f <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8038bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8038bf:	c9                   	leaveq 
  8038c0:	c3                   	retq   

00000000008038c1 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8038c1:	55                   	push   %rbp
  8038c2:	48 89 e5             	mov    %rsp,%rbp
  8038c5:	48 83 ec 20          	sub    $0x20,%rsp
  8038c9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8038cd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8038d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038d5:	48 89 c7             	mov    %rax,%rdi
  8038d8:	48 b8 87 21 80 00 00 	movabs $0x802187,%rax
  8038df:	00 00 00 
  8038e2:	ff d0                	callq  *%rax
  8038e4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8038e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8038ec:	48 be 1c 43 80 00 00 	movabs $0x80431c,%rsi
  8038f3:	00 00 00 
  8038f6:	48 89 c7             	mov    %rax,%rdi
  8038f9:	48 b8 9a 14 80 00 00 	movabs $0x80149a,%rax
  803900:	00 00 00 
  803903:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803905:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803909:	8b 50 04             	mov    0x4(%rax),%edx
  80390c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803910:	8b 00                	mov    (%rax),%eax
  803912:	29 c2                	sub    %eax,%edx
  803914:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803918:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80391e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803922:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803929:	00 00 00 
	stat->st_dev = &devpipe;
  80392c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803930:	48 b9 00 61 80 00 00 	movabs $0x806100,%rcx
  803937:	00 00 00 
  80393a:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803941:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803946:	c9                   	leaveq 
  803947:	c3                   	retq   

0000000000803948 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803948:	55                   	push   %rbp
  803949:	48 89 e5             	mov    %rsp,%rbp
  80394c:	48 83 ec 10          	sub    $0x10,%rsp
  803950:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803954:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803958:	48 89 c6             	mov    %rax,%rsi
  80395b:	bf 00 00 00 00       	mov    $0x0,%edi
  803960:	48 b8 74 1e 80 00 00 	movabs $0x801e74,%rax
  803967:	00 00 00 
  80396a:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  80396c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803970:	48 89 c7             	mov    %rax,%rdi
  803973:	48 b8 87 21 80 00 00 	movabs $0x802187,%rax
  80397a:	00 00 00 
  80397d:	ff d0                	callq  *%rax
  80397f:	48 89 c6             	mov    %rax,%rsi
  803982:	bf 00 00 00 00       	mov    $0x0,%edi
  803987:	48 b8 74 1e 80 00 00 	movabs $0x801e74,%rax
  80398e:	00 00 00 
  803991:	ff d0                	callq  *%rax
}
  803993:	c9                   	leaveq 
  803994:	c3                   	retq   

0000000000803995 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803995:	55                   	push   %rbp
  803996:	48 89 e5             	mov    %rsp,%rbp
  803999:	48 83 ec 30          	sub    $0x30,%rsp
  80399d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8039a1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8039a5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	//LAB 4: Your code here.
	if (!pg) pg=(void*)-1;
  8039a9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8039ae:	75 08                	jne    8039b8 <ipc_recv+0x23>
  8039b0:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  8039b7:	ff 
	int res=sys_ipc_recv(pg);
  8039b8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039bc:	48 89 c7             	mov    %rax,%rdi
  8039bf:	48 b8 3d 20 80 00 00 	movabs $0x80203d,%rax
  8039c6:	00 00 00 
  8039c9:	ff d0                	callq  *%rax
  8039cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
	
	if (from_env_store) *from_env_store=res==0?thisenv->env_ipc_from:0;
  8039ce:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8039d3:	74 26                	je     8039fb <ipc_recv+0x66>
  8039d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039d9:	75 15                	jne    8039f0 <ipc_recv+0x5b>
  8039db:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  8039e2:	00 00 00 
  8039e5:	48 8b 00             	mov    (%rax),%rax
  8039e8:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  8039ee:	eb 05                	jmp    8039f5 <ipc_recv+0x60>
  8039f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8039f5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8039f9:	89 02                	mov    %eax,(%rdx)
	if (perm_store) *perm_store=res==0?thisenv->env_ipc_perm:0;
  8039fb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803a00:	74 26                	je     803a28 <ipc_recv+0x93>
  803a02:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a06:	75 15                	jne    803a1d <ipc_recv+0x88>
  803a08:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  803a0f:	00 00 00 
  803a12:	48 8b 00             	mov    (%rax),%rax
  803a15:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  803a1b:	eb 05                	jmp    803a22 <ipc_recv+0x8d>
  803a1d:	b8 00 00 00 00       	mov    $0x0,%eax
  803a22:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803a26:	89 02                	mov    %eax,(%rdx)
	return res!=0?res:thisenv->env_ipc_value;
  803a28:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a2c:	75 15                	jne    803a43 <ipc_recv+0xae>
  803a2e:	48 b8 08 74 80 00 00 	movabs $0x807408,%rax
  803a35:	00 00 00 
  803a38:	48 8b 00             	mov    (%rax),%rax
  803a3b:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  803a41:	eb 03                	jmp    803a46 <ipc_recv+0xb1>
  803a43:	8b 45 fc             	mov    -0x4(%rbp),%eax
	

}
  803a46:	c9                   	leaveq 
  803a47:	c3                   	retq   

0000000000803a48 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803a48:	55                   	push   %rbp
  803a49:	48 89 e5             	mov    %rsp,%rbp
  803a4c:	48 83 ec 30          	sub    $0x30,%rsp
  803a50:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a53:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803a56:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803a5a:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.

	if (!pg) pg=(void*)-1;
  803a5d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803a62:	75 0a                	jne    803a6e <ipc_send+0x26>
  803a64:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  803a6b:	ff 
	int res;
	while ((res=sys_ipc_try_send(to_env, val, pg, perm))<0){
  803a6c:	eb 3e                	jmp    803aac <ipc_send+0x64>
  803a6e:	eb 3c                	jmp    803aac <ipc_send+0x64>
		if(res!=-E_IPC_NOT_RECV)
  803a70:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803a74:	74 2a                	je     803aa0 <ipc_send+0x58>
			panic("ipc_send:error other than -E_IPC_NOT_RECV\n");
  803a76:	48 ba 28 43 80 00 00 	movabs $0x804328,%rdx
  803a7d:	00 00 00 
  803a80:	be 39 00 00 00       	mov    $0x39,%esi
  803a85:	48 bf 53 43 80 00 00 	movabs $0x804353,%rdi
  803a8c:	00 00 00 
  803a8f:	b8 00 00 00 00       	mov    $0x0,%eax
  803a94:	48 b9 11 05 80 00 00 	movabs $0x800511,%rcx
  803a9b:	00 00 00 
  803a9e:	ff d1                	callq  *%rcx
		sys_yield();  
  803aa0:	48 b8 8b 1d 80 00 00 	movabs $0x801d8b,%rax
  803aa7:	00 00 00 
  803aaa:	ff d0                	callq  *%rax
{
	// LAB 4: Your code here.

	if (!pg) pg=(void*)-1;
	int res;
	while ((res=sys_ipc_try_send(to_env, val, pg, perm))<0){
  803aac:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803aaf:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803ab2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803ab6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ab9:	89 c7                	mov    %eax,%edi
  803abb:	48 b8 e8 1f 80 00 00 	movabs $0x801fe8,%rax
  803ac2:	00 00 00 
  803ac5:	ff d0                	callq  *%rax
  803ac7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803aca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ace:	78 a0                	js     803a70 <ipc_send+0x28>
			panic("ipc_send:error other than -E_IPC_NOT_RECV\n");
		sys_yield();  
	}
	//panic("ipc_send not implemented");

}
  803ad0:	c9                   	leaveq 
  803ad1:	c3                   	retq   

0000000000803ad2 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  803ad2:	55                   	push   %rbp
  803ad3:	48 89 e5             	mov    %rsp,%rbp
  803ad6:	48 83 ec 10          	sub    $0x10,%rsp
  803ada:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	// LAB 8: Your code here.
	panic("ipc_recv not implemented in VM guest");
  803ade:	48 ba 60 43 80 00 00 	movabs $0x804360,%rdx
  803ae5:	00 00 00 
  803ae8:	be 47 00 00 00       	mov    $0x47,%esi
  803aed:	48 bf 53 43 80 00 00 	movabs $0x804353,%rdi
  803af4:	00 00 00 
  803af7:	b8 00 00 00 00       	mov    $0x0,%eax
  803afc:	48 b9 11 05 80 00 00 	movabs $0x800511,%rcx
  803b03:	00 00 00 
  803b06:	ff d1                	callq  *%rcx

0000000000803b08 <ipc_host_send>:

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803b08:	55                   	push   %rbp
  803b09:	48 89 e5             	mov    %rsp,%rbp
  803b0c:	48 83 ec 20          	sub    $0x20,%rsp
  803b10:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803b13:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803b16:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  803b1a:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 8: Your code here.
	panic("ipc_send not implemented in VM guest");
  803b1d:	48 ba 88 43 80 00 00 	movabs $0x804388,%rdx
  803b24:	00 00 00 
  803b27:	be 50 00 00 00       	mov    $0x50,%esi
  803b2c:	48 bf 53 43 80 00 00 	movabs $0x804353,%rdi
  803b33:	00 00 00 
  803b36:	b8 00 00 00 00       	mov    $0x0,%eax
  803b3b:	48 b9 11 05 80 00 00 	movabs $0x800511,%rcx
  803b42:	00 00 00 
  803b45:	ff d1                	callq  *%rcx

0000000000803b47 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803b47:	55                   	push   %rbp
  803b48:	48 89 e5             	mov    %rsp,%rbp
  803b4b:	48 83 ec 14          	sub    $0x14,%rsp
  803b4f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803b52:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803b59:	eb 4e                	jmp    803ba9 <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  803b5b:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803b62:	00 00 00 
  803b65:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b68:	48 98                	cltq   
  803b6a:	48 69 c0 70 01 00 00 	imul   $0x170,%rax,%rax
  803b71:	48 01 d0             	add    %rdx,%rax
  803b74:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803b7a:	8b 00                	mov    (%rax),%eax
  803b7c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803b7f:	75 24                	jne    803ba5 <ipc_find_env+0x5e>
			return envs[i].env_id;
  803b81:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803b88:	00 00 00 
  803b8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b8e:	48 98                	cltq   
  803b90:	48 69 c0 70 01 00 00 	imul   $0x170,%rax,%rax
  803b97:	48 01 d0             	add    %rdx,%rax
  803b9a:	48 05 c0 00 00 00    	add    $0xc0,%rax
  803ba0:	8b 40 08             	mov    0x8(%rax),%eax
  803ba3:	eb 12                	jmp    803bb7 <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803ba5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803ba9:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803bb0:	7e a9                	jle    803b5b <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;

	}
	return 0;
  803bb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803bb7:	c9                   	leaveq 
  803bb8:	c3                   	retq   

0000000000803bb9 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803bb9:	55                   	push   %rbp
  803bba:	48 89 e5             	mov    %rsp,%rbp
  803bbd:	48 83 ec 18          	sub    $0x18,%rsp
  803bc1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803bc5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bc9:	48 c1 e8 15          	shr    $0x15,%rax
  803bcd:	48 89 c2             	mov    %rax,%rdx
  803bd0:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803bd7:	01 00 00 
  803bda:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803bde:	83 e0 01             	and    $0x1,%eax
  803be1:	48 85 c0             	test   %rax,%rax
  803be4:	75 07                	jne    803bed <pageref+0x34>
		return 0;
  803be6:	b8 00 00 00 00       	mov    $0x0,%eax
  803beb:	eb 53                	jmp    803c40 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  803bed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bf1:	48 c1 e8 0c          	shr    $0xc,%rax
  803bf5:	48 89 c2             	mov    %rax,%rdx
  803bf8:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803bff:	01 00 00 
  803c02:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c06:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803c0a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c0e:	83 e0 01             	and    $0x1,%eax
  803c11:	48 85 c0             	test   %rax,%rax
  803c14:	75 07                	jne    803c1d <pageref+0x64>
		return 0;
  803c16:	b8 00 00 00 00       	mov    $0x0,%eax
  803c1b:	eb 23                	jmp    803c40 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  803c1d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c21:	48 c1 e8 0c          	shr    $0xc,%rax
  803c25:	48 89 c2             	mov    %rax,%rdx
  803c28:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  803c2f:	00 00 00 
  803c32:	48 c1 e2 04          	shl    $0x4,%rdx
  803c36:	48 01 d0             	add    %rdx,%rax
  803c39:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  803c3d:	0f b7 c0             	movzwl %ax,%eax
}
  803c40:	c9                   	leaveq 
  803c41:	c3                   	retq   
