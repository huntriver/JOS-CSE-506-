
vmm/guest/obj/user/testfile:     file format elf64-x86-64


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
  80003c:	e8 39 0c 00 00       	callq  800c7a <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <xopen>:

#define FVA ((struct Fd*)0xCCCCC000)

static int
xopen(const char *path, int mode)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 20          	sub    $0x20,%rsp
  80004b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80004f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	extern union Fsipc fsipcbuf;
	envid_t fsenv;

	strcpy(fsipcbuf.open.req_path, path);
  800052:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800056:	48 89 c6             	mov    %rax,%rsi
  800059:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  800060:	00 00 00 
  800063:	48 b8 4f 1b 80 00 00 	movabs $0x801b4f,%rax
  80006a:	00 00 00 
  80006d:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  80006f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  800076:	00 00 00 
  800079:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80007c:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	fsenv = ipc_find_env(ENV_TYPE_FS);
  800082:	bf 01 00 00 00       	mov    $0x1,%edi
  800087:	48 b8 cb 29 80 00 00 	movabs $0x8029cb,%rax
  80008e:	00 00 00 
  800091:	ff d0                	callq  *%rax
  800093:	89 45 fc             	mov    %eax,-0x4(%rbp)
	ipc_send(fsenv, FSREQ_OPEN, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800096:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800099:	b9 07 00 00 00       	mov    $0x7,%ecx
  80009e:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8000a5:	00 00 00 
  8000a8:	be 01 00 00 00       	mov    $0x1,%esi
  8000ad:	89 c7                	mov    %eax,%edi
  8000af:	48 b8 cc 28 80 00 00 	movabs $0x8028cc,%rax
  8000b6:	00 00 00 
  8000b9:	ff d0                	callq  *%rax
	return ipc_recv(NULL, FVA, NULL);
  8000bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c0:	be 00 c0 cc cc       	mov    $0xccccc000,%esi
  8000c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8000ca:	48 b8 19 28 80 00 00 	movabs $0x802819,%rax
  8000d1:	00 00 00 
  8000d4:	ff d0                	callq  *%rax
}
  8000d6:	c9                   	leaveq 
  8000d7:	c3                   	retq   

00000000008000d8 <umain>:

void
umain(int argc, char **argv)
{
  8000d8:	55                   	push   %rbp
  8000d9:	48 89 e5             	mov    %rsp,%rbp
  8000dc:	53                   	push   %rbx
  8000dd:	48 81 ec 18 03 00 00 	sub    $0x318,%rsp
  8000e4:	89 bd 2c fd ff ff    	mov    %edi,-0x2d4(%rbp)
  8000ea:	48 89 b5 20 fd ff ff 	mov    %rsi,-0x2e0(%rbp)
	struct Fd fdcopy;
	struct Stat st;
	char buf[512];

	// We open files manually first, to avoid the FD layer
	if ((r = xopen("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  8000f1:	be 00 00 00 00       	mov    $0x0,%esi
  8000f6:	48 bf e6 42 80 00 00 	movabs $0x8042e6,%rdi
  8000fd:	00 00 00 
  800100:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800107:	00 00 00 
  80010a:	ff d0                	callq  *%rax
  80010c:	48 98                	cltq   
  80010e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800112:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800117:	79 39                	jns    800152 <umain+0x7a>
  800119:	48 83 7d e0 f4       	cmpq   $0xfffffffffffffff4,-0x20(%rbp)
  80011e:	74 32                	je     800152 <umain+0x7a>
		panic("serve_open /not-found: %e", r);
  800120:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800124:	48 89 c1             	mov    %rax,%rcx
  800127:	48 ba f1 42 80 00 00 	movabs $0x8042f1,%rdx
  80012e:	00 00 00 
  800131:	be 20 00 00 00       	mov    $0x20,%esi
  800136:	48 bf 0b 43 80 00 00 	movabs $0x80430b,%rdi
  80013d:	00 00 00 
  800140:	b8 00 00 00 00       	mov    $0x0,%eax
  800145:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  80014c:	00 00 00 
  80014f:	41 ff d0             	callq  *%r8
	else if (r >= 0)
  800152:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800157:	78 2a                	js     800183 <umain+0xab>
		panic("serve_open /not-found succeeded!");
  800159:	48 ba 20 43 80 00 00 	movabs $0x804320,%rdx
  800160:	00 00 00 
  800163:	be 22 00 00 00       	mov    $0x22,%esi
  800168:	48 bf 0b 43 80 00 00 	movabs $0x80430b,%rdi
  80016f:	00 00 00 
  800172:	b8 00 00 00 00       	mov    $0x0,%eax
  800177:	48 b9 20 0d 80 00 00 	movabs $0x800d20,%rcx
  80017e:	00 00 00 
  800181:	ff d1                	callq  *%rcx

	if ((r = xopen("/newmotd", O_RDONLY)) < 0)
  800183:	be 00 00 00 00       	mov    $0x0,%esi
  800188:	48 bf 41 43 80 00 00 	movabs $0x804341,%rdi
  80018f:	00 00 00 
  800192:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800199:	00 00 00 
  80019c:	ff d0                	callq  *%rax
  80019e:	48 98                	cltq   
  8001a0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8001a4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8001a9:	79 32                	jns    8001dd <umain+0x105>
		panic("serve_open /newmotd: %e", r);
  8001ab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8001af:	48 89 c1             	mov    %rax,%rcx
  8001b2:	48 ba 4a 43 80 00 00 	movabs $0x80434a,%rdx
  8001b9:	00 00 00 
  8001bc:	be 25 00 00 00       	mov    $0x25,%esi
  8001c1:	48 bf 0b 43 80 00 00 	movabs $0x80430b,%rdi
  8001c8:	00 00 00 
  8001cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8001d0:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  8001d7:	00 00 00 
  8001da:	41 ff d0             	callq  *%r8
	if (FVA->fd_dev_id != 'f' || FVA->fd_offset != 0 || FVA->fd_omode != O_RDONLY)
  8001dd:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  8001e2:	8b 00                	mov    (%rax),%eax
  8001e4:	83 f8 66             	cmp    $0x66,%eax
  8001e7:	75 18                	jne    800201 <umain+0x129>
  8001e9:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  8001ee:	8b 40 04             	mov    0x4(%rax),%eax
  8001f1:	85 c0                	test   %eax,%eax
  8001f3:	75 0c                	jne    800201 <umain+0x129>
  8001f5:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  8001fa:	8b 40 08             	mov    0x8(%rax),%eax
  8001fd:	85 c0                	test   %eax,%eax
  8001ff:	74 2a                	je     80022b <umain+0x153>
		panic("serve_open did not fill struct Fd correctly\n");
  800201:	48 ba 68 43 80 00 00 	movabs $0x804368,%rdx
  800208:	00 00 00 
  80020b:	be 27 00 00 00       	mov    $0x27,%esi
  800210:	48 bf 0b 43 80 00 00 	movabs $0x80430b,%rdi
  800217:	00 00 00 
  80021a:	b8 00 00 00 00       	mov    $0x0,%eax
  80021f:	48 b9 20 0d 80 00 00 	movabs $0x800d20,%rcx
  800226:	00 00 00 
  800229:	ff d1                	callq  *%rcx
	cprintf("serve_open is good\n");
  80022b:	48 bf 95 43 80 00 00 	movabs $0x804395,%rdi
  800232:	00 00 00 
  800235:	b8 00 00 00 00       	mov    $0x0,%eax
  80023a:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  800241:	00 00 00 
  800244:	ff d2                	callq  *%rdx

	if ((r = devfile.dev_stat(FVA, &st)) < 0)
  800246:	48 b8 60 60 80 00 00 	movabs $0x806060,%rax
  80024d:	00 00 00 
  800250:	48 8b 40 28          	mov    0x28(%rax),%rax
  800254:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80025b:	48 89 d6             	mov    %rdx,%rsi
  80025e:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  800263:	ff d0                	callq  *%rax
  800265:	48 98                	cltq   
  800267:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  80026b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800270:	79 32                	jns    8002a4 <umain+0x1cc>
		panic("file_stat: %e", r);
  800272:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800276:	48 89 c1             	mov    %rax,%rcx
  800279:	48 ba a9 43 80 00 00 	movabs $0x8043a9,%rdx
  800280:	00 00 00 
  800283:	be 2b 00 00 00       	mov    $0x2b,%esi
  800288:	48 bf 0b 43 80 00 00 	movabs $0x80430b,%rdi
  80028f:	00 00 00 
  800292:	b8 00 00 00 00       	mov    $0x0,%eax
  800297:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  80029e:	00 00 00 
  8002a1:	41 ff d0             	callq  *%r8
	if (strlen(msg) != st.st_size)
  8002a4:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002ab:	00 00 00 
  8002ae:	48 8b 00             	mov    (%rax),%rax
  8002b1:	48 89 c7             	mov    %rax,%rdi
  8002b4:	48 b8 e3 1a 80 00 00 	movabs $0x801ae3,%rax
  8002bb:	00 00 00 
  8002be:	ff d0                	callq  *%rax
  8002c0:	8b 55 b0             	mov    -0x50(%rbp),%edx
  8002c3:	39 d0                	cmp    %edx,%eax
  8002c5:	74 51                	je     800318 <umain+0x240>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
  8002c7:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8002ce:	00 00 00 
  8002d1:	48 8b 00             	mov    (%rax),%rax
  8002d4:	48 89 c7             	mov    %rax,%rdi
  8002d7:	48 b8 e3 1a 80 00 00 	movabs $0x801ae3,%rax
  8002de:	00 00 00 
  8002e1:	ff d0                	callq  *%rax
  8002e3:	89 c2                	mov    %eax,%edx
  8002e5:	8b 45 b0             	mov    -0x50(%rbp),%eax
  8002e8:	41 89 d0             	mov    %edx,%r8d
  8002eb:	89 c1                	mov    %eax,%ecx
  8002ed:	48 ba b8 43 80 00 00 	movabs $0x8043b8,%rdx
  8002f4:	00 00 00 
  8002f7:	be 2d 00 00 00       	mov    $0x2d,%esi
  8002fc:	48 bf 0b 43 80 00 00 	movabs $0x80430b,%rdi
  800303:	00 00 00 
  800306:	b8 00 00 00 00       	mov    $0x0,%eax
  80030b:	49 b9 20 0d 80 00 00 	movabs $0x800d20,%r9
  800312:	00 00 00 
  800315:	41 ff d1             	callq  *%r9
	cprintf("file_stat is good\n");
  800318:	48 bf de 43 80 00 00 	movabs $0x8043de,%rdi
  80031f:	00 00 00 
  800322:	b8 00 00 00 00       	mov    $0x0,%eax
  800327:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  80032e:	00 00 00 
  800331:	ff d2                	callq  *%rdx

	memset(buf, 0, sizeof buf);
  800333:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  80033a:	ba 00 02 00 00       	mov    $0x200,%edx
  80033f:	be 00 00 00 00       	mov    $0x0,%esi
  800344:	48 89 c7             	mov    %rax,%rdi
  800347:	48 b8 e8 1d 80 00 00 	movabs $0x801de8,%rax
  80034e:	00 00 00 
  800351:	ff d0                	callq  *%rax
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  800353:	48 b8 60 60 80 00 00 	movabs $0x806060,%rax
  80035a:	00 00 00 
  80035d:	48 8b 40 10          	mov    0x10(%rax),%rax
  800361:	48 8d 8d 30 fd ff ff 	lea    -0x2d0(%rbp),%rcx
  800368:	ba 00 02 00 00       	mov    $0x200,%edx
  80036d:	48 89 ce             	mov    %rcx,%rsi
  800370:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  800375:	ff d0                	callq  *%rax
  800377:	48 98                	cltq   
  800379:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  80037d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800382:	79 32                	jns    8003b6 <umain+0x2de>
		panic("file_read: %e", r);
  800384:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800388:	48 89 c1             	mov    %rax,%rcx
  80038b:	48 ba f1 43 80 00 00 	movabs $0x8043f1,%rdx
  800392:	00 00 00 
  800395:	be 32 00 00 00       	mov    $0x32,%esi
  80039a:	48 bf 0b 43 80 00 00 	movabs $0x80430b,%rdi
  8003a1:	00 00 00 
  8003a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a9:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  8003b0:	00 00 00 
  8003b3:	41 ff d0             	callq  *%r8
	if (strcmp(buf, msg) != 0)
  8003b6:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8003bd:	00 00 00 
  8003c0:	48 8b 10             	mov    (%rax),%rdx
  8003c3:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  8003ca:	48 89 d6             	mov    %rdx,%rsi
  8003cd:	48 89 c7             	mov    %rax,%rdi
  8003d0:	48 b8 b1 1c 80 00 00 	movabs $0x801cb1,%rax
  8003d7:	00 00 00 
  8003da:	ff d0                	callq  *%rax
  8003dc:	85 c0                	test   %eax,%eax
  8003de:	74 2a                	je     80040a <umain+0x332>
		panic("file_read returned wrong data");
  8003e0:	48 ba ff 43 80 00 00 	movabs $0x8043ff,%rdx
  8003e7:	00 00 00 
  8003ea:	be 34 00 00 00       	mov    $0x34,%esi
  8003ef:	48 bf 0b 43 80 00 00 	movabs $0x80430b,%rdi
  8003f6:	00 00 00 
  8003f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8003fe:	48 b9 20 0d 80 00 00 	movabs $0x800d20,%rcx
  800405:	00 00 00 
  800408:	ff d1                	callq  *%rcx
	cprintf("file_read is good\n");
  80040a:	48 bf 1d 44 80 00 00 	movabs $0x80441d,%rdi
  800411:	00 00 00 
  800414:	b8 00 00 00 00       	mov    $0x0,%eax
  800419:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  800420:	00 00 00 
  800423:	ff d2                	callq  *%rdx

	if ((r = devfile.dev_close(FVA)) < 0)
  800425:	48 b8 60 60 80 00 00 	movabs $0x806060,%rax
  80042c:	00 00 00 
  80042f:	48 8b 40 20          	mov    0x20(%rax),%rax
  800433:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  800438:	ff d0                	callq  *%rax
  80043a:	48 98                	cltq   
  80043c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800440:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800445:	79 32                	jns    800479 <umain+0x3a1>
		panic("file_close: %e", r);
  800447:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80044b:	48 89 c1             	mov    %rax,%rcx
  80044e:	48 ba 30 44 80 00 00 	movabs $0x804430,%rdx
  800455:	00 00 00 
  800458:	be 38 00 00 00       	mov    $0x38,%esi
  80045d:	48 bf 0b 43 80 00 00 	movabs $0x80430b,%rdi
  800464:	00 00 00 
  800467:	b8 00 00 00 00       	mov    $0x0,%eax
  80046c:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  800473:	00 00 00 
  800476:	41 ff d0             	callq  *%r8
	cprintf("file_close is good\n");
  800479:	48 bf 3f 44 80 00 00 	movabs $0x80443f,%rdi
  800480:	00 00 00 
  800483:	b8 00 00 00 00       	mov    $0x0,%eax
  800488:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  80048f:	00 00 00 
  800492:	ff d2                	callq  *%rdx

	// We're about to unmap the FD, but still need a way to get
	// the stale filenum to serve_read, so we make a local copy.
	// The file server won't think it's stale until we unmap the
	// FD page.
	fdcopy = *FVA;
  800494:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  800499:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80049d:	48 8b 00             	mov    (%rax),%rax
  8004a0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  8004a4:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	sys_page_unmap(0, FVA);
  8004a8:	be 00 c0 cc cc       	mov    $0xccccc000,%esi
  8004ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8004b2:	48 b8 29 25 80 00 00 	movabs $0x802529,%rax
  8004b9:	00 00 00 
  8004bc:	ff d0                	callq  *%rax

	if ((r = devfile.dev_read(&fdcopy, buf, sizeof buf)) != -E_INVAL)
  8004be:	48 b8 60 60 80 00 00 	movabs $0x806060,%rax
  8004c5:	00 00 00 
  8004c8:	48 8b 40 10          	mov    0x10(%rax),%rax
  8004cc:	48 8d b5 30 fd ff ff 	lea    -0x2d0(%rbp),%rsi
  8004d3:	48 8d 4d c0          	lea    -0x40(%rbp),%rcx
  8004d7:	ba 00 02 00 00       	mov    $0x200,%edx
  8004dc:	48 89 cf             	mov    %rcx,%rdi
  8004df:	ff d0                	callq  *%rax
  8004e1:	48 98                	cltq   
  8004e3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8004e7:	48 83 7d e0 fd       	cmpq   $0xfffffffffffffffd,-0x20(%rbp)
  8004ec:	74 32                	je     800520 <umain+0x448>
		panic("serve_read does not handle stale fileids correctly: %e", r);
  8004ee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8004f2:	48 89 c1             	mov    %rax,%rcx
  8004f5:	48 ba 58 44 80 00 00 	movabs $0x804458,%rdx
  8004fc:	00 00 00 
  8004ff:	be 43 00 00 00       	mov    $0x43,%esi
  800504:	48 bf 0b 43 80 00 00 	movabs $0x80430b,%rdi
  80050b:	00 00 00 
  80050e:	b8 00 00 00 00       	mov    $0x0,%eax
  800513:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  80051a:	00 00 00 
  80051d:	41 ff d0             	callq  *%r8
	cprintf("stale fileid is good\n");
  800520:	48 bf 8f 44 80 00 00 	movabs $0x80448f,%rdi
  800527:	00 00 00 
  80052a:	b8 00 00 00 00       	mov    $0x0,%eax
  80052f:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  800536:	00 00 00 
  800539:	ff d2                	callq  *%rdx

	// Try writing
	if ((r = xopen("/new-file", O_RDWR|O_CREAT)) < 0)
  80053b:	be 02 01 00 00       	mov    $0x102,%esi
  800540:	48 bf a5 44 80 00 00 	movabs $0x8044a5,%rdi
  800547:	00 00 00 
  80054a:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800551:	00 00 00 
  800554:	ff d0                	callq  *%rax
  800556:	48 98                	cltq   
  800558:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  80055c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800561:	79 32                	jns    800595 <umain+0x4bd>
		panic("serve_open /new-file: %e", r);
  800563:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800567:	48 89 c1             	mov    %rax,%rcx
  80056a:	48 ba af 44 80 00 00 	movabs $0x8044af,%rdx
  800571:	00 00 00 
  800574:	be 48 00 00 00       	mov    $0x48,%esi
  800579:	48 bf 0b 43 80 00 00 	movabs $0x80430b,%rdi
  800580:	00 00 00 
  800583:	b8 00 00 00 00       	mov    $0x0,%eax
  800588:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  80058f:	00 00 00 
  800592:	41 ff d0             	callq  *%r8

	cprintf("xopen new file worked devfile %p, dev_write %p, msg %p, FVA %p\n", devfile, devfile.dev_write, msg, FVA);
  800595:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80059c:	00 00 00 
  80059f:	48 8b 10             	mov    (%rax),%rdx
  8005a2:	48 b8 60 60 80 00 00 	movabs $0x806060,%rax
  8005a9:	00 00 00 
  8005ac:	48 8b 70 18          	mov    0x18(%rax),%rsi
  8005b0:	48 b8 60 60 80 00 00 	movabs $0x806060,%rax
  8005b7:	00 00 00 
  8005ba:	48 8b 08             	mov    (%rax),%rcx
  8005bd:	48 89 0c 24          	mov    %rcx,(%rsp)
  8005c1:	48 8b 48 08          	mov    0x8(%rax),%rcx
  8005c5:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  8005ca:	48 8b 48 10          	mov    0x10(%rax),%rcx
  8005ce:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
  8005d3:	48 8b 48 18          	mov    0x18(%rax),%rcx
  8005d7:	48 89 4c 24 18       	mov    %rcx,0x18(%rsp)
  8005dc:	48 8b 48 20          	mov    0x20(%rax),%rcx
  8005e0:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  8005e5:	48 8b 48 28          	mov    0x28(%rax),%rcx
  8005e9:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  8005ee:	48 8b 40 30          	mov    0x30(%rax),%rax
  8005f2:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  8005f7:	b9 00 c0 cc cc       	mov    $0xccccc000,%ecx
  8005fc:	48 bf c8 44 80 00 00 	movabs $0x8044c8,%rdi
  800603:	00 00 00 
  800606:	b8 00 00 00 00       	mov    $0x0,%eax
  80060b:	49 b8 59 0f 80 00 00 	movabs $0x800f59,%r8
  800612:	00 00 00 
  800615:	41 ff d0             	callq  *%r8

	if ((r = devfile.dev_write(FVA, msg, strlen(msg))) != strlen(msg))
  800618:	48 b8 60 60 80 00 00 	movabs $0x806060,%rax
  80061f:	00 00 00 
  800622:	48 8b 58 18          	mov    0x18(%rax),%rbx
  800626:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80062d:	00 00 00 
  800630:	48 8b 00             	mov    (%rax),%rax
  800633:	48 89 c7             	mov    %rax,%rdi
  800636:	48 b8 e3 1a 80 00 00 	movabs $0x801ae3,%rax
  80063d:	00 00 00 
  800640:	ff d0                	callq  *%rax
  800642:	48 63 d0             	movslq %eax,%rdx
  800645:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80064c:	00 00 00 
  80064f:	48 8b 00             	mov    (%rax),%rax
  800652:	48 89 c6             	mov    %rax,%rsi
  800655:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  80065a:	ff d3                	callq  *%rbx
  80065c:	48 98                	cltq   
  80065e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800662:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800669:	00 00 00 
  80066c:	48 8b 00             	mov    (%rax),%rax
  80066f:	48 89 c7             	mov    %rax,%rdi
  800672:	48 b8 e3 1a 80 00 00 	movabs $0x801ae3,%rax
  800679:	00 00 00 
  80067c:	ff d0                	callq  *%rax
  80067e:	48 98                	cltq   
  800680:	48 39 45 e0          	cmp    %rax,-0x20(%rbp)
  800684:	74 32                	je     8006b8 <umain+0x5e0>
		panic("file_write: %e", r);
  800686:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80068a:	48 89 c1             	mov    %rax,%rcx
  80068d:	48 ba 08 45 80 00 00 	movabs $0x804508,%rdx
  800694:	00 00 00 
  800697:	be 4d 00 00 00       	mov    $0x4d,%esi
  80069c:	48 bf 0b 43 80 00 00 	movabs $0x80430b,%rdi
  8006a3:	00 00 00 
  8006a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8006ab:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  8006b2:	00 00 00 
  8006b5:	41 ff d0             	callq  *%r8
	cprintf("file_write is good\n");
  8006b8:	48 bf 17 45 80 00 00 	movabs $0x804517,%rdi
  8006bf:	00 00 00 
  8006c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8006c7:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  8006ce:	00 00 00 
  8006d1:	ff d2                	callq  *%rdx

	FVA->fd_offset = 0;
  8006d3:	b8 00 c0 cc cc       	mov    $0xccccc000,%eax
  8006d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	memset(buf, 0, sizeof buf);
  8006df:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  8006e6:	ba 00 02 00 00       	mov    $0x200,%edx
  8006eb:	be 00 00 00 00       	mov    $0x0,%esi
  8006f0:	48 89 c7             	mov    %rax,%rdi
  8006f3:	48 b8 e8 1d 80 00 00 	movabs $0x801de8,%rax
  8006fa:	00 00 00 
  8006fd:	ff d0                	callq  *%rax
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  8006ff:	48 b8 60 60 80 00 00 	movabs $0x806060,%rax
  800706:	00 00 00 
  800709:	48 8b 40 10          	mov    0x10(%rax),%rax
  80070d:	48 8d 8d 30 fd ff ff 	lea    -0x2d0(%rbp),%rcx
  800714:	ba 00 02 00 00       	mov    $0x200,%edx
  800719:	48 89 ce             	mov    %rcx,%rsi
  80071c:	bf 00 c0 cc cc       	mov    $0xccccc000,%edi
  800721:	ff d0                	callq  *%rax
  800723:	48 98                	cltq   
  800725:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800729:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80072e:	79 32                	jns    800762 <umain+0x68a>
		panic("file_read after file_write: %e", r);
  800730:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800734:	48 89 c1             	mov    %rax,%rcx
  800737:	48 ba 30 45 80 00 00 	movabs $0x804530,%rdx
  80073e:	00 00 00 
  800741:	be 53 00 00 00       	mov    $0x53,%esi
  800746:	48 bf 0b 43 80 00 00 	movabs $0x80430b,%rdi
  80074d:	00 00 00 
  800750:	b8 00 00 00 00       	mov    $0x0,%eax
  800755:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  80075c:	00 00 00 
  80075f:	41 ff d0             	callq  *%r8
	if (r != strlen(msg))
  800762:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800769:	00 00 00 
  80076c:	48 8b 00             	mov    (%rax),%rax
  80076f:	48 89 c7             	mov    %rax,%rdi
  800772:	48 b8 e3 1a 80 00 00 	movabs $0x801ae3,%rax
  800779:	00 00 00 
  80077c:	ff d0                	callq  *%rax
  80077e:	48 98                	cltq   
  800780:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
  800784:	74 32                	je     8007b8 <umain+0x6e0>
		panic("file_read after file_write returned wrong length: %d", r);
  800786:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80078a:	48 89 c1             	mov    %rax,%rcx
  80078d:	48 ba 50 45 80 00 00 	movabs $0x804550,%rdx
  800794:	00 00 00 
  800797:	be 55 00 00 00       	mov    $0x55,%esi
  80079c:	48 bf 0b 43 80 00 00 	movabs $0x80430b,%rdi
  8007a3:	00 00 00 
  8007a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ab:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  8007b2:	00 00 00 
  8007b5:	41 ff d0             	callq  *%r8
	if (strcmp(buf, msg) != 0)
  8007b8:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8007bf:	00 00 00 
  8007c2:	48 8b 10             	mov    (%rax),%rdx
  8007c5:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  8007cc:	48 89 d6             	mov    %rdx,%rsi
  8007cf:	48 89 c7             	mov    %rax,%rdi
  8007d2:	48 b8 b1 1c 80 00 00 	movabs $0x801cb1,%rax
  8007d9:	00 00 00 
  8007dc:	ff d0                	callq  *%rax
  8007de:	85 c0                	test   %eax,%eax
  8007e0:	74 2a                	je     80080c <umain+0x734>
		panic("file_read after file_write returned wrong data");
  8007e2:	48 ba 88 45 80 00 00 	movabs $0x804588,%rdx
  8007e9:	00 00 00 
  8007ec:	be 57 00 00 00       	mov    $0x57,%esi
  8007f1:	48 bf 0b 43 80 00 00 	movabs $0x80430b,%rdi
  8007f8:	00 00 00 
  8007fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800800:	48 b9 20 0d 80 00 00 	movabs $0x800d20,%rcx
  800807:	00 00 00 
  80080a:	ff d1                	callq  *%rcx
	cprintf("file_read after file_write is good\n");
  80080c:	48 bf b8 45 80 00 00 	movabs $0x8045b8,%rdi
  800813:	00 00 00 
  800816:	b8 00 00 00 00       	mov    $0x0,%eax
  80081b:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  800822:	00 00 00 
  800825:	ff d2                	callq  *%rdx

	// Now we'll try out open
	if ((r = open("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  800827:	be 00 00 00 00       	mov    $0x0,%esi
  80082c:	48 bf e6 42 80 00 00 	movabs $0x8042e6,%rdi
  800833:	00 00 00 
  800836:	48 b8 2b 34 80 00 00 	movabs $0x80342b,%rax
  80083d:	00 00 00 
  800840:	ff d0                	callq  *%rax
  800842:	48 98                	cltq   
  800844:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800848:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80084d:	79 39                	jns    800888 <umain+0x7b0>
  80084f:	48 83 7d e0 f4       	cmpq   $0xfffffffffffffff4,-0x20(%rbp)
  800854:	74 32                	je     800888 <umain+0x7b0>
		panic("open /not-found: %e", r);
  800856:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80085a:	48 89 c1             	mov    %rax,%rcx
  80085d:	48 ba dc 45 80 00 00 	movabs $0x8045dc,%rdx
  800864:	00 00 00 
  800867:	be 5c 00 00 00       	mov    $0x5c,%esi
  80086c:	48 bf 0b 43 80 00 00 	movabs $0x80430b,%rdi
  800873:	00 00 00 
  800876:	b8 00 00 00 00       	mov    $0x0,%eax
  80087b:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  800882:	00 00 00 
  800885:	41 ff d0             	callq  *%r8
	else if (r >= 0)
  800888:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80088d:	78 2a                	js     8008b9 <umain+0x7e1>
		panic("open /not-found succeeded!");
  80088f:	48 ba f0 45 80 00 00 	movabs $0x8045f0,%rdx
  800896:	00 00 00 
  800899:	be 5e 00 00 00       	mov    $0x5e,%esi
  80089e:	48 bf 0b 43 80 00 00 	movabs $0x80430b,%rdi
  8008a5:	00 00 00 
  8008a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ad:	48 b9 20 0d 80 00 00 	movabs $0x800d20,%rcx
  8008b4:	00 00 00 
  8008b7:	ff d1                	callq  *%rcx

	if ((r = open("/newmotd", O_RDONLY)) < 0)
  8008b9:	be 00 00 00 00       	mov    $0x0,%esi
  8008be:	48 bf 41 43 80 00 00 	movabs $0x804341,%rdi
  8008c5:	00 00 00 
  8008c8:	48 b8 2b 34 80 00 00 	movabs $0x80342b,%rax
  8008cf:	00 00 00 
  8008d2:	ff d0                	callq  *%rax
  8008d4:	48 98                	cltq   
  8008d6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8008da:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8008df:	79 32                	jns    800913 <umain+0x83b>
		panic("open /newmotd: %e", r);
  8008e1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8008e5:	48 89 c1             	mov    %rax,%rcx
  8008e8:	48 ba 0b 46 80 00 00 	movabs $0x80460b,%rdx
  8008ef:	00 00 00 
  8008f2:	be 61 00 00 00       	mov    $0x61,%esi
  8008f7:	48 bf 0b 43 80 00 00 	movabs $0x80430b,%rdi
  8008fe:	00 00 00 
  800901:	b8 00 00 00 00       	mov    $0x0,%eax
  800906:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  80090d:	00 00 00 
  800910:	41 ff d0             	callq  *%r8
	fd = (struct Fd*) (0xD0000000 + r*PGSIZE);
  800913:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800917:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80091d:	48 c1 e0 0c          	shl    $0xc,%rax
  800921:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (fd->fd_dev_id != 'f' || fd->fd_offset != 0 || fd->fd_omode != O_RDONLY)
  800925:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800929:	8b 00                	mov    (%rax),%eax
  80092b:	83 f8 66             	cmp    $0x66,%eax
  80092e:	75 16                	jne    800946 <umain+0x86e>
  800930:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800934:	8b 40 04             	mov    0x4(%rax),%eax
  800937:	85 c0                	test   %eax,%eax
  800939:	75 0b                	jne    800946 <umain+0x86e>
  80093b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80093f:	8b 40 08             	mov    0x8(%rax),%eax
  800942:	85 c0                	test   %eax,%eax
  800944:	74 2a                	je     800970 <umain+0x898>
		panic("open did not fill struct Fd correctly\n");
  800946:	48 ba 20 46 80 00 00 	movabs $0x804620,%rdx
  80094d:	00 00 00 
  800950:	be 64 00 00 00       	mov    $0x64,%esi
  800955:	48 bf 0b 43 80 00 00 	movabs $0x80430b,%rdi
  80095c:	00 00 00 
  80095f:	b8 00 00 00 00       	mov    $0x0,%eax
  800964:	48 b9 20 0d 80 00 00 	movabs $0x800d20,%rcx
  80096b:	00 00 00 
  80096e:	ff d1                	callq  *%rcx
	cprintf("open is good\n");
  800970:	48 bf 47 46 80 00 00 	movabs $0x804647,%rdi
  800977:	00 00 00 
  80097a:	b8 00 00 00 00       	mov    $0x0,%eax
  80097f:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  800986:	00 00 00 
  800989:	ff d2                	callq  *%rdx

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
  80098b:	be 01 01 00 00       	mov    $0x101,%esi
  800990:	48 bf 55 46 80 00 00 	movabs $0x804655,%rdi
  800997:	00 00 00 
  80099a:	48 b8 2b 34 80 00 00 	movabs $0x80342b,%rax
  8009a1:	00 00 00 
  8009a4:	ff d0                	callq  *%rax
  8009a6:	48 98                	cltq   
  8009a8:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8009ac:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8009b1:	79 32                	jns    8009e5 <umain+0x90d>
		panic("creat /big: %e", f);
  8009b3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8009b7:	48 89 c1             	mov    %rax,%rcx
  8009ba:	48 ba 5a 46 80 00 00 	movabs $0x80465a,%rdx
  8009c1:	00 00 00 
  8009c4:	be 69 00 00 00       	mov    $0x69,%esi
  8009c9:	48 bf 0b 43 80 00 00 	movabs $0x80430b,%rdi
  8009d0:	00 00 00 
  8009d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8009d8:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  8009df:	00 00 00 
  8009e2:	41 ff d0             	callq  *%r8
	memset(buf, 0, sizeof(buf));
  8009e5:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  8009ec:	ba 00 02 00 00       	mov    $0x200,%edx
  8009f1:	be 00 00 00 00       	mov    $0x0,%esi
  8009f6:	48 89 c7             	mov    %rax,%rdi
  8009f9:	48 b8 e8 1d 80 00 00 	movabs $0x801de8,%rax
  800a00:	00 00 00 
  800a03:	ff d0                	callq  *%rax
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800a05:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  800a0c:	00 
  800a0d:	e9 82 00 00 00       	jmpq   800a94 <umain+0x9bc>
		*(int*)buf = i;
  800a12:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  800a19:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a1d:	89 10                	mov    %edx,(%rax)
		if ((r = write(f, buf, sizeof(buf))) < 0)
  800a1f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800a23:	48 8d 8d 30 fd ff ff 	lea    -0x2d0(%rbp),%rcx
  800a2a:	ba 00 02 00 00       	mov    $0x200,%edx
  800a2f:	48 89 ce             	mov    %rcx,%rsi
  800a32:	89 c7                	mov    %eax,%edi
  800a34:	48 b8 9f 30 80 00 00 	movabs $0x80309f,%rax
  800a3b:	00 00 00 
  800a3e:	ff d0                	callq  *%rax
  800a40:	48 98                	cltq   
  800a42:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800a46:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800a4b:	79 39                	jns    800a86 <umain+0x9ae>
			panic("write /big@%d: %e", i, r);
  800a4d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800a51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a55:	49 89 d0             	mov    %rdx,%r8
  800a58:	48 89 c1             	mov    %rax,%rcx
  800a5b:	48 ba 69 46 80 00 00 	movabs $0x804669,%rdx
  800a62:	00 00 00 
  800a65:	be 6e 00 00 00       	mov    $0x6e,%esi
  800a6a:	48 bf 0b 43 80 00 00 	movabs $0x80430b,%rdi
  800a71:	00 00 00 
  800a74:	b8 00 00 00 00       	mov    $0x0,%eax
  800a79:	49 b9 20 0d 80 00 00 	movabs $0x800d20,%r9
  800a80:	00 00 00 
  800a83:	41 ff d1             	callq  *%r9

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
		panic("creat /big: %e", f);
	memset(buf, 0, sizeof(buf));
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800a86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a8a:	48 05 00 02 00 00    	add    $0x200,%rax
  800a90:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  800a94:	48 81 7d e8 ff df 01 	cmpq   $0x1dfff,-0x18(%rbp)
  800a9b:	00 
  800a9c:	0f 8e 70 ff ff ff    	jle    800a12 <umain+0x93a>
		*(int*)buf = i;
		if ((r = write(f, buf, sizeof(buf))) < 0)
			panic("write /big@%d: %e", i, r);
	}
	close(f);
  800aa2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800aa6:	89 c7                	mov    %eax,%edi
  800aa8:	48 b8 33 2d 80 00 00 	movabs $0x802d33,%rax
  800aaf:	00 00 00 
  800ab2:	ff d0                	callq  *%rax

	if ((f = open("/big", O_RDONLY)) < 0)
  800ab4:	be 00 00 00 00       	mov    $0x0,%esi
  800ab9:	48 bf 55 46 80 00 00 	movabs $0x804655,%rdi
  800ac0:	00 00 00 
  800ac3:	48 b8 2b 34 80 00 00 	movabs $0x80342b,%rax
  800aca:	00 00 00 
  800acd:	ff d0                	callq  *%rax
  800acf:	48 98                	cltq   
  800ad1:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800ad5:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  800ada:	79 32                	jns    800b0e <umain+0xa36>
		panic("open /big: %e", f);
  800adc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800ae0:	48 89 c1             	mov    %rax,%rcx
  800ae3:	48 ba 7b 46 80 00 00 	movabs $0x80467b,%rdx
  800aea:	00 00 00 
  800aed:	be 73 00 00 00       	mov    $0x73,%esi
  800af2:	48 bf 0b 43 80 00 00 	movabs $0x80430b,%rdi
  800af9:	00 00 00 
  800afc:	b8 00 00 00 00       	mov    $0x0,%eax
  800b01:	49 b8 20 0d 80 00 00 	movabs $0x800d20,%r8
  800b08:	00 00 00 
  800b0b:	41 ff d0             	callq  *%r8
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800b0e:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  800b15:	00 
  800b16:	e9 1a 01 00 00       	jmpq   800c35 <umain+0xb5d>
		*(int*)buf = i;
  800b1b:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  800b22:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b26:	89 10                	mov    %edx,(%rax)
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  800b28:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800b2c:	48 8d 8d 30 fd ff ff 	lea    -0x2d0(%rbp),%rcx
  800b33:	ba 00 02 00 00       	mov    $0x200,%edx
  800b38:	48 89 ce             	mov    %rcx,%rsi
  800b3b:	89 c7                	mov    %eax,%edi
  800b3d:	48 b8 2a 30 80 00 00 	movabs $0x80302a,%rax
  800b44:	00 00 00 
  800b47:	ff d0                	callq  *%rax
  800b49:	48 98                	cltq   
  800b4b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  800b4f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800b54:	79 39                	jns    800b8f <umain+0xab7>
			panic("read /big@%d: %e", i, r);
  800b56:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800b5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b5e:	49 89 d0             	mov    %rdx,%r8
  800b61:	48 89 c1             	mov    %rax,%rcx
  800b64:	48 ba 89 46 80 00 00 	movabs $0x804689,%rdx
  800b6b:	00 00 00 
  800b6e:	be 77 00 00 00       	mov    $0x77,%esi
  800b73:	48 bf 0b 43 80 00 00 	movabs $0x80430b,%rdi
  800b7a:	00 00 00 
  800b7d:	b8 00 00 00 00       	mov    $0x0,%eax
  800b82:	49 b9 20 0d 80 00 00 	movabs $0x800d20,%r9
  800b89:	00 00 00 
  800b8c:	41 ff d1             	callq  *%r9
		if (r != sizeof(buf))
  800b8f:	48 81 7d e0 00 02 00 	cmpq   $0x200,-0x20(%rbp)
  800b96:	00 
  800b97:	74 3f                	je     800bd8 <umain+0xb00>
			panic("read /big from %d returned %d < %d bytes",
  800b99:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800b9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ba1:	41 b9 00 02 00 00    	mov    $0x200,%r9d
  800ba7:	49 89 d0             	mov    %rdx,%r8
  800baa:	48 89 c1             	mov    %rax,%rcx
  800bad:	48 ba a0 46 80 00 00 	movabs $0x8046a0,%rdx
  800bb4:	00 00 00 
  800bb7:	be 7a 00 00 00       	mov    $0x7a,%esi
  800bbc:	48 bf 0b 43 80 00 00 	movabs $0x80430b,%rdi
  800bc3:	00 00 00 
  800bc6:	b8 00 00 00 00       	mov    $0x0,%eax
  800bcb:	49 ba 20 0d 80 00 00 	movabs $0x800d20,%r10
  800bd2:	00 00 00 
  800bd5:	41 ff d2             	callq  *%r10
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
  800bd8:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  800bdf:	8b 00                	mov    (%rax),%eax
  800be1:	48 98                	cltq   
  800be3:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800be7:	74 3e                	je     800c27 <umain+0xb4f>
			panic("read /big from %d returned bad data %d",
  800be9:	48 8d 85 30 fd ff ff 	lea    -0x2d0(%rbp),%rax
  800bf0:	8b 10                	mov    (%rax),%edx
  800bf2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bf6:	41 89 d0             	mov    %edx,%r8d
  800bf9:	48 89 c1             	mov    %rax,%rcx
  800bfc:	48 ba d0 46 80 00 00 	movabs $0x8046d0,%rdx
  800c03:	00 00 00 
  800c06:	be 7d 00 00 00       	mov    $0x7d,%esi
  800c0b:	48 bf 0b 43 80 00 00 	movabs $0x80430b,%rdi
  800c12:	00 00 00 
  800c15:	b8 00 00 00 00       	mov    $0x0,%eax
  800c1a:	49 b9 20 0d 80 00 00 	movabs $0x800d20,%r9
  800c21:	00 00 00 
  800c24:	41 ff d1             	callq  *%r9
	}
	close(f);

	if ((f = open("/big", O_RDONLY)) < 0)
		panic("open /big: %e", f);
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800c27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c2b:	48 05 00 02 00 00    	add    $0x200,%rax
  800c31:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  800c35:	48 81 7d e8 ff df 01 	cmpq   $0x1dfff,-0x18(%rbp)
  800c3c:	00 
  800c3d:	0f 8e d8 fe ff ff    	jle    800b1b <umain+0xa43>
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
			panic("read /big from %d returned bad data %d",
			      i, *(int*)buf);
	}
	close(f);
  800c43:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800c47:	89 c7                	mov    %eax,%edi
  800c49:	48 b8 33 2d 80 00 00 	movabs $0x802d33,%rax
  800c50:	00 00 00 
  800c53:	ff d0                	callq  *%rax
	cprintf("large file is good\n");
  800c55:	48 bf f7 46 80 00 00 	movabs $0x8046f7,%rdi
  800c5c:	00 00 00 
  800c5f:	b8 00 00 00 00       	mov    $0x0,%eax
  800c64:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  800c6b:	00 00 00 
  800c6e:	ff d2                	callq  *%rdx
}
  800c70:	48 81 c4 18 03 00 00 	add    $0x318,%rsp
  800c77:	5b                   	pop    %rbx
  800c78:	5d                   	pop    %rbp
  800c79:	c3                   	retq   

0000000000800c7a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800c7a:	55                   	push   %rbp
  800c7b:	48 89 e5             	mov    %rsp,%rbp
  800c7e:	48 83 ec 10          	sub    $0x10,%rsp
  800c82:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c85:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = envs+ENVX(sys_getenvid ());
  800c89:	48 b8 02 24 80 00 00 	movabs $0x802402,%rax
  800c90:	00 00 00 
  800c93:	ff d0                	callq  *%rax
  800c95:	48 98                	cltq   
  800c97:	25 ff 03 00 00       	and    $0x3ff,%eax
  800c9c:	48 69 d0 70 01 00 00 	imul   $0x170,%rax,%rdx
  800ca3:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800caa:	00 00 00 
  800cad:	48 01 c2             	add    %rax,%rdx
  800cb0:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800cb7:	00 00 00 
  800cba:	48 89 10             	mov    %rdx,(%rax)
	// thisenv = 0;


	// save the name of the program so that panic() can use it
	if (argc > 0)
  800cbd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800cc1:	7e 14                	jle    800cd7 <libmain+0x5d>
		binaryname = argv[0];
  800cc3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cc7:	48 8b 10             	mov    (%rax),%rdx
  800cca:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800cd1:	00 00 00 
  800cd4:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800cd7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800cdb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800cde:	48 89 d6             	mov    %rdx,%rsi
  800ce1:	89 c7                	mov    %eax,%edi
  800ce3:	48 b8 d8 00 80 00 00 	movabs $0x8000d8,%rax
  800cea:	00 00 00 
  800ced:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800cef:	48 b8 fd 0c 80 00 00 	movabs $0x800cfd,%rax
  800cf6:	00 00 00 
  800cf9:	ff d0                	callq  *%rax
}
  800cfb:	c9                   	leaveq 
  800cfc:	c3                   	retq   

0000000000800cfd <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800cfd:	55                   	push   %rbp
  800cfe:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  800d01:	48 b8 7e 2d 80 00 00 	movabs $0x802d7e,%rax
  800d08:	00 00 00 
  800d0b:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  800d0d:	bf 00 00 00 00       	mov    $0x0,%edi
  800d12:	48 b8 be 23 80 00 00 	movabs $0x8023be,%rax
  800d19:	00 00 00 
  800d1c:	ff d0                	callq  *%rax
}
  800d1e:	5d                   	pop    %rbp
  800d1f:	c3                   	retq   

0000000000800d20 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800d20:	55                   	push   %rbp
  800d21:	48 89 e5             	mov    %rsp,%rbp
  800d24:	53                   	push   %rbx
  800d25:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800d2c:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800d33:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800d39:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800d40:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800d47:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800d4e:	84 c0                	test   %al,%al
  800d50:	74 23                	je     800d75 <_panic+0x55>
  800d52:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800d59:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800d5d:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800d61:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800d65:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800d69:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800d6d:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800d71:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
  800d75:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800d7c:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800d83:	00 00 00 
  800d86:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800d8d:	00 00 00 
  800d90:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800d94:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800d9b:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800da2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800da9:	48 b8 08 60 80 00 00 	movabs $0x806008,%rax
  800db0:	00 00 00 
  800db3:	48 8b 18             	mov    (%rax),%rbx
  800db6:	48 b8 02 24 80 00 00 	movabs $0x802402,%rax
  800dbd:	00 00 00 
  800dc0:	ff d0                	callq  *%rax
  800dc2:	8b 8d 14 ff ff ff    	mov    -0xec(%rbp),%ecx
  800dc8:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800dcf:	41 89 c8             	mov    %ecx,%r8d
  800dd2:	48 89 d1             	mov    %rdx,%rcx
  800dd5:	48 89 da             	mov    %rbx,%rdx
  800dd8:	89 c6                	mov    %eax,%esi
  800dda:	48 bf 18 47 80 00 00 	movabs $0x804718,%rdi
  800de1:	00 00 00 
  800de4:	b8 00 00 00 00       	mov    $0x0,%eax
  800de9:	49 b9 59 0f 80 00 00 	movabs $0x800f59,%r9
  800df0:	00 00 00 
  800df3:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800df6:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800dfd:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e04:	48 89 d6             	mov    %rdx,%rsi
  800e07:	48 89 c7             	mov    %rax,%rdi
  800e0a:	48 b8 ad 0e 80 00 00 	movabs $0x800ead,%rax
  800e11:	00 00 00 
  800e14:	ff d0                	callq  *%rax
	cprintf("\n");
  800e16:	48 bf 3b 47 80 00 00 	movabs $0x80473b,%rdi
  800e1d:	00 00 00 
  800e20:	b8 00 00 00 00       	mov    $0x0,%eax
  800e25:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  800e2c:	00 00 00 
  800e2f:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800e31:	cc                   	int3   
  800e32:	eb fd                	jmp    800e31 <_panic+0x111>

0000000000800e34 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800e34:	55                   	push   %rbp
  800e35:	48 89 e5             	mov    %rsp,%rbp
  800e38:	48 83 ec 10          	sub    $0x10,%rsp
  800e3c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800e3f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800e43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e47:	8b 00                	mov    (%rax),%eax
  800e49:	8d 48 01             	lea    0x1(%rax),%ecx
  800e4c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e50:	89 0a                	mov    %ecx,(%rdx)
  800e52:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e55:	89 d1                	mov    %edx,%ecx
  800e57:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e5b:	48 98                	cltq   
  800e5d:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800e61:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e65:	8b 00                	mov    (%rax),%eax
  800e67:	3d ff 00 00 00       	cmp    $0xff,%eax
  800e6c:	75 2c                	jne    800e9a <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800e6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e72:	8b 00                	mov    (%rax),%eax
  800e74:	48 98                	cltq   
  800e76:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800e7a:	48 83 c2 08          	add    $0x8,%rdx
  800e7e:	48 89 c6             	mov    %rax,%rsi
  800e81:	48 89 d7             	mov    %rdx,%rdi
  800e84:	48 b8 36 23 80 00 00 	movabs $0x802336,%rax
  800e8b:	00 00 00 
  800e8e:	ff d0                	callq  *%rax
        b->idx = 0;
  800e90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e94:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800e9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800e9e:	8b 40 04             	mov    0x4(%rax),%eax
  800ea1:	8d 50 01             	lea    0x1(%rax),%edx
  800ea4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800ea8:	89 50 04             	mov    %edx,0x4(%rax)
}
  800eab:	c9                   	leaveq 
  800eac:	c3                   	retq   

0000000000800ead <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800ead:	55                   	push   %rbp
  800eae:	48 89 e5             	mov    %rsp,%rbp
  800eb1:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800eb8:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800ebf:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800ec6:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800ecd:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800ed4:	48 8b 0a             	mov    (%rdx),%rcx
  800ed7:	48 89 08             	mov    %rcx,(%rax)
  800eda:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ede:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ee2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ee6:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800eea:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800ef1:	00 00 00 
    b.cnt = 0;
  800ef4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800efb:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800efe:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800f05:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800f0c:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800f13:	48 89 c6             	mov    %rax,%rsi
  800f16:	48 bf 34 0e 80 00 00 	movabs $0x800e34,%rdi
  800f1d:	00 00 00 
  800f20:	48 b8 0c 13 80 00 00 	movabs $0x80130c,%rax
  800f27:	00 00 00 
  800f2a:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800f2c:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800f32:	48 98                	cltq   
  800f34:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800f3b:	48 83 c2 08          	add    $0x8,%rdx
  800f3f:	48 89 c6             	mov    %rax,%rsi
  800f42:	48 89 d7             	mov    %rdx,%rdi
  800f45:	48 b8 36 23 80 00 00 	movabs $0x802336,%rax
  800f4c:	00 00 00 
  800f4f:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800f51:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800f57:	c9                   	leaveq 
  800f58:	c3                   	retq   

0000000000800f59 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800f59:	55                   	push   %rbp
  800f5a:	48 89 e5             	mov    %rsp,%rbp
  800f5d:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800f64:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800f6b:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800f72:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800f79:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800f80:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800f87:	84 c0                	test   %al,%al
  800f89:	74 20                	je     800fab <cprintf+0x52>
  800f8b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800f8f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800f93:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800f97:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800f9b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800f9f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800fa3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800fa7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  800fab:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800fb2:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800fb9:	00 00 00 
  800fbc:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800fc3:	00 00 00 
  800fc6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800fca:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800fd1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800fd8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800fdf:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800fe6:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800fed:	48 8b 0a             	mov    (%rdx),%rcx
  800ff0:	48 89 08             	mov    %rcx,(%rax)
  800ff3:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ff7:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ffb:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800fff:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  801003:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80100a:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801011:	48 89 d6             	mov    %rdx,%rsi
  801014:	48 89 c7             	mov    %rax,%rdi
  801017:	48 b8 ad 0e 80 00 00 	movabs $0x800ead,%rax
  80101e:	00 00 00 
  801021:	ff d0                	callq  *%rax
  801023:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  801029:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80102f:	c9                   	leaveq 
  801030:	c3                   	retq   

0000000000801031 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801031:	55                   	push   %rbp
  801032:	48 89 e5             	mov    %rsp,%rbp
  801035:	53                   	push   %rbx
  801036:	48 83 ec 38          	sub    $0x38,%rsp
  80103a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80103e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801042:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801046:	89 4d d4             	mov    %ecx,-0x2c(%rbp)
  801049:	44 89 45 d0          	mov    %r8d,-0x30(%rbp)
  80104d:	44 89 4d cc          	mov    %r9d,-0x34(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801051:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801054:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801058:	77 3b                	ja     801095 <printnum+0x64>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80105a:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80105d:	44 8d 40 ff          	lea    -0x1(%rax),%r8d
  801061:	8b 5d d4             	mov    -0x2c(%rbp),%ebx
  801064:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801068:	ba 00 00 00 00       	mov    $0x0,%edx
  80106d:	48 f7 f3             	div    %rbx
  801070:	48 89 c2             	mov    %rax,%rdx
  801073:	8b 7d cc             	mov    -0x34(%rbp),%edi
  801076:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  801079:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
  80107d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801081:	41 89 f9             	mov    %edi,%r9d
  801084:	48 89 c7             	mov    %rax,%rdi
  801087:	48 b8 31 10 80 00 00 	movabs $0x801031,%rax
  80108e:	00 00 00 
  801091:	ff d0                	callq  *%rax
  801093:	eb 1e                	jmp    8010b3 <printnum+0x82>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801095:	eb 12                	jmp    8010a9 <printnum+0x78>
			putch(padc, putdat);
  801097:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80109b:	8b 55 cc             	mov    -0x34(%rbp),%edx
  80109e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a2:	48 89 ce             	mov    %rcx,%rsi
  8010a5:	89 d7                	mov    %edx,%edi
  8010a7:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8010a9:	83 6d d0 01          	subl   $0x1,-0x30(%rbp)
  8010ad:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
  8010b1:	7f e4                	jg     801097 <printnum+0x66>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8010b3:	8b 4d d4             	mov    -0x2c(%rbp),%ecx
  8010b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8010ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8010bf:	48 f7 f1             	div    %rcx
  8010c2:	48 89 d0             	mov    %rdx,%rax
  8010c5:	48 ba 30 49 80 00 00 	movabs $0x804930,%rdx
  8010cc:	00 00 00 
  8010cf:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  8010d3:	0f be d0             	movsbl %al,%edx
  8010d6:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8010da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010de:	48 89 ce             	mov    %rcx,%rsi
  8010e1:	89 d7                	mov    %edx,%edi
  8010e3:	ff d0                	callq  *%rax
}
  8010e5:	48 83 c4 38          	add    $0x38,%rsp
  8010e9:	5b                   	pop    %rbx
  8010ea:	5d                   	pop    %rbp
  8010eb:	c3                   	retq   

00000000008010ec <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8010ec:	55                   	push   %rbp
  8010ed:	48 89 e5             	mov    %rsp,%rbp
  8010f0:	48 83 ec 1c          	sub    $0x1c,%rsp
  8010f4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010f8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8010fb:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8010ff:	7e 52                	jle    801153 <getuint+0x67>
		x= va_arg(*ap, unsigned long long);
  801101:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801105:	8b 00                	mov    (%rax),%eax
  801107:	83 f8 30             	cmp    $0x30,%eax
  80110a:	73 24                	jae    801130 <getuint+0x44>
  80110c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801110:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801114:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801118:	8b 00                	mov    (%rax),%eax
  80111a:	89 c0                	mov    %eax,%eax
  80111c:	48 01 d0             	add    %rdx,%rax
  80111f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801123:	8b 12                	mov    (%rdx),%edx
  801125:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801128:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80112c:	89 0a                	mov    %ecx,(%rdx)
  80112e:	eb 17                	jmp    801147 <getuint+0x5b>
  801130:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801134:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801138:	48 89 d0             	mov    %rdx,%rax
  80113b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80113f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801143:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801147:	48 8b 00             	mov    (%rax),%rax
  80114a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80114e:	e9 a3 00 00 00       	jmpq   8011f6 <getuint+0x10a>
	else if (lflag)
  801153:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801157:	74 4f                	je     8011a8 <getuint+0xbc>
		x= va_arg(*ap, unsigned long);
  801159:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80115d:	8b 00                	mov    (%rax),%eax
  80115f:	83 f8 30             	cmp    $0x30,%eax
  801162:	73 24                	jae    801188 <getuint+0x9c>
  801164:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801168:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80116c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801170:	8b 00                	mov    (%rax),%eax
  801172:	89 c0                	mov    %eax,%eax
  801174:	48 01 d0             	add    %rdx,%rax
  801177:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80117b:	8b 12                	mov    (%rdx),%edx
  80117d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801180:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801184:	89 0a                	mov    %ecx,(%rdx)
  801186:	eb 17                	jmp    80119f <getuint+0xb3>
  801188:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80118c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801190:	48 89 d0             	mov    %rdx,%rax
  801193:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  801197:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80119b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80119f:	48 8b 00             	mov    (%rax),%rax
  8011a2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8011a6:	eb 4e                	jmp    8011f6 <getuint+0x10a>
	else
		x= va_arg(*ap, unsigned int);
  8011a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ac:	8b 00                	mov    (%rax),%eax
  8011ae:	83 f8 30             	cmp    $0x30,%eax
  8011b1:	73 24                	jae    8011d7 <getuint+0xeb>
  8011b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8011bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011bf:	8b 00                	mov    (%rax),%eax
  8011c1:	89 c0                	mov    %eax,%eax
  8011c3:	48 01 d0             	add    %rdx,%rax
  8011c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011ca:	8b 12                	mov    (%rdx),%edx
  8011cc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8011cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011d3:	89 0a                	mov    %ecx,(%rdx)
  8011d5:	eb 17                	jmp    8011ee <getuint+0x102>
  8011d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011db:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8011df:	48 89 d0             	mov    %rdx,%rax
  8011e2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8011e6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011ea:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8011ee:	8b 00                	mov    (%rax),%eax
  8011f0:	89 c0                	mov    %eax,%eax
  8011f2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8011f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011fa:	c9                   	leaveq 
  8011fb:	c3                   	retq   

00000000008011fc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8011fc:	55                   	push   %rbp
  8011fd:	48 89 e5             	mov    %rsp,%rbp
  801200:	48 83 ec 1c          	sub    $0x1c,%rsp
  801204:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801208:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  80120b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80120f:	7e 52                	jle    801263 <getint+0x67>
		x=va_arg(*ap, long long);
  801211:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801215:	8b 00                	mov    (%rax),%eax
  801217:	83 f8 30             	cmp    $0x30,%eax
  80121a:	73 24                	jae    801240 <getint+0x44>
  80121c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801220:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801224:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801228:	8b 00                	mov    (%rax),%eax
  80122a:	89 c0                	mov    %eax,%eax
  80122c:	48 01 d0             	add    %rdx,%rax
  80122f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801233:	8b 12                	mov    (%rdx),%edx
  801235:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801238:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80123c:	89 0a                	mov    %ecx,(%rdx)
  80123e:	eb 17                	jmp    801257 <getint+0x5b>
  801240:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801244:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801248:	48 89 d0             	mov    %rdx,%rax
  80124b:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  80124f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801253:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801257:	48 8b 00             	mov    (%rax),%rax
  80125a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80125e:	e9 a3 00 00 00       	jmpq   801306 <getint+0x10a>
	else if (lflag)
  801263:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801267:	74 4f                	je     8012b8 <getint+0xbc>
		x=va_arg(*ap, long);
  801269:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80126d:	8b 00                	mov    (%rax),%eax
  80126f:	83 f8 30             	cmp    $0x30,%eax
  801272:	73 24                	jae    801298 <getint+0x9c>
  801274:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801278:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80127c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801280:	8b 00                	mov    (%rax),%eax
  801282:	89 c0                	mov    %eax,%eax
  801284:	48 01 d0             	add    %rdx,%rax
  801287:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80128b:	8b 12                	mov    (%rdx),%edx
  80128d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801290:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801294:	89 0a                	mov    %ecx,(%rdx)
  801296:	eb 17                	jmp    8012af <getint+0xb3>
  801298:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80129c:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8012a0:	48 89 d0             	mov    %rdx,%rax
  8012a3:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8012a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012ab:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8012af:	48 8b 00             	mov    (%rax),%rax
  8012b2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8012b6:	eb 4e                	jmp    801306 <getint+0x10a>
	else
		x=va_arg(*ap, int);
  8012b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012bc:	8b 00                	mov    (%rax),%eax
  8012be:	83 f8 30             	cmp    $0x30,%eax
  8012c1:	73 24                	jae    8012e7 <getint+0xeb>
  8012c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012c7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8012cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012cf:	8b 00                	mov    (%rax),%eax
  8012d1:	89 c0                	mov    %eax,%eax
  8012d3:	48 01 d0             	add    %rdx,%rax
  8012d6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012da:	8b 12                	mov    (%rdx),%edx
  8012dc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8012df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012e3:	89 0a                	mov    %ecx,(%rdx)
  8012e5:	eb 17                	jmp    8012fe <getint+0x102>
  8012e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012eb:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8012ef:	48 89 d0             	mov    %rdx,%rax
  8012f2:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  8012f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8012fa:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8012fe:	8b 00                	mov    (%rax),%eax
  801300:	48 98                	cltq   
  801302:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  801306:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80130a:	c9                   	leaveq 
  80130b:	c3                   	retq   

000000000080130c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80130c:	55                   	push   %rbp
  80130d:	48 89 e5             	mov    %rsp,%rbp
  801310:	41 54                	push   %r12
  801312:	53                   	push   %rbx
  801313:	48 83 ec 60          	sub    $0x60,%rsp
  801317:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80131b:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80131f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801323:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  801327:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80132b:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80132f:	48 8b 0a             	mov    (%rdx),%rcx
  801332:	48 89 08             	mov    %rcx,(%rax)
  801335:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801339:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80133d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801341:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801345:	eb 28                	jmp    80136f <vprintfmt+0x63>
			if (ch == '\0'){
  801347:	85 db                	test   %ebx,%ebx
  801349:	75 15                	jne    801360 <vprintfmt+0x54>
				current_color=WHITE;
  80134b:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  801352:	00 00 00 
  801355:	c7 00 07 00 00 00    	movl   $0x7,(%rax)
  80135b:	e9 fc 04 00 00       	jmpq   80185c <vprintfmt+0x550>
				return;
			}
				
			putch(ch, putdat);
  801360:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801364:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801368:	48 89 d6             	mov    %rdx,%rsi
  80136b:	89 df                	mov    %ebx,%edi
  80136d:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80136f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801373:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801377:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80137b:	0f b6 00             	movzbl (%rax),%eax
  80137e:	0f b6 d8             	movzbl %al,%ebx
  801381:	83 fb 25             	cmp    $0x25,%ebx
  801384:	75 c1                	jne    801347 <vprintfmt+0x3b>
				
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801386:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80138a:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  801391:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  801398:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80139f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8013a6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8013aa:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013ae:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8013b2:	0f b6 00             	movzbl (%rax),%eax
  8013b5:	0f b6 d8             	movzbl %al,%ebx
  8013b8:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8013bb:	83 f8 55             	cmp    $0x55,%eax
  8013be:	0f 87 64 04 00 00    	ja     801828 <vprintfmt+0x51c>
  8013c4:	89 c0                	mov    %eax,%eax
  8013c6:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8013cd:	00 
  8013ce:	48 b8 58 49 80 00 00 	movabs $0x804958,%rax
  8013d5:	00 00 00 
  8013d8:	48 01 d0             	add    %rdx,%rax
  8013db:	48 8b 00             	mov    (%rax),%rax
  8013de:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8013e0:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8013e4:	eb c0                	jmp    8013a6 <vprintfmt+0x9a>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8013e6:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8013ea:	eb ba                	jmp    8013a6 <vprintfmt+0x9a>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8013ec:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8013f3:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8013f6:	89 d0                	mov    %edx,%eax
  8013f8:	c1 e0 02             	shl    $0x2,%eax
  8013fb:	01 d0                	add    %edx,%eax
  8013fd:	01 c0                	add    %eax,%eax
  8013ff:	01 d8                	add    %ebx,%eax
  801401:	83 e8 30             	sub    $0x30,%eax
  801404:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  801407:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80140b:	0f b6 00             	movzbl (%rax),%eax
  80140e:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801411:	83 fb 2f             	cmp    $0x2f,%ebx
  801414:	7e 0c                	jle    801422 <vprintfmt+0x116>
  801416:	83 fb 39             	cmp    $0x39,%ebx
  801419:	7f 07                	jg     801422 <vprintfmt+0x116>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80141b:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801420:	eb d1                	jmp    8013f3 <vprintfmt+0xe7>
			goto process_precision;
  801422:	eb 58                	jmp    80147c <vprintfmt+0x170>

		case '*':
			precision = va_arg(aq, int);
  801424:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801427:	83 f8 30             	cmp    $0x30,%eax
  80142a:	73 17                	jae    801443 <vprintfmt+0x137>
  80142c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801430:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801433:	89 c0                	mov    %eax,%eax
  801435:	48 01 d0             	add    %rdx,%rax
  801438:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80143b:	83 c2 08             	add    $0x8,%edx
  80143e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801441:	eb 0f                	jmp    801452 <vprintfmt+0x146>
  801443:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801447:	48 89 d0             	mov    %rdx,%rax
  80144a:	48 83 c2 08          	add    $0x8,%rdx
  80144e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801452:	8b 00                	mov    (%rax),%eax
  801454:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  801457:	eb 23                	jmp    80147c <vprintfmt+0x170>

		case '.':
			if (width < 0)
  801459:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80145d:	79 0c                	jns    80146b <vprintfmt+0x15f>
				width = 0;
  80145f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  801466:	e9 3b ff ff ff       	jmpq   8013a6 <vprintfmt+0x9a>
  80146b:	e9 36 ff ff ff       	jmpq   8013a6 <vprintfmt+0x9a>

		case '#':
			altflag = 1;
  801470:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  801477:	e9 2a ff ff ff       	jmpq   8013a6 <vprintfmt+0x9a>

		process_precision:
			if (width < 0)
  80147c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801480:	79 12                	jns    801494 <vprintfmt+0x188>
				width = precision, precision = -1;
  801482:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801485:	89 45 dc             	mov    %eax,-0x24(%rbp)
  801488:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80148f:	e9 12 ff ff ff       	jmpq   8013a6 <vprintfmt+0x9a>
  801494:	e9 0d ff ff ff       	jmpq   8013a6 <vprintfmt+0x9a>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  801499:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  80149d:	e9 04 ff ff ff       	jmpq   8013a6 <vprintfmt+0x9a>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8014a2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8014a5:	83 f8 30             	cmp    $0x30,%eax
  8014a8:	73 17                	jae    8014c1 <vprintfmt+0x1b5>
  8014aa:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8014ae:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8014b1:	89 c0                	mov    %eax,%eax
  8014b3:	48 01 d0             	add    %rdx,%rax
  8014b6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8014b9:	83 c2 08             	add    $0x8,%edx
  8014bc:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8014bf:	eb 0f                	jmp    8014d0 <vprintfmt+0x1c4>
  8014c1:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8014c5:	48 89 d0             	mov    %rdx,%rax
  8014c8:	48 83 c2 08          	add    $0x8,%rdx
  8014cc:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8014d0:	8b 10                	mov    (%rax),%edx
  8014d2:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8014d6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8014da:	48 89 ce             	mov    %rcx,%rsi
  8014dd:	89 d7                	mov    %edx,%edi
  8014df:	ff d0                	callq  *%rax
			break;
  8014e1:	e9 70 03 00 00       	jmpq   801856 <vprintfmt+0x54a>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8014e6:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8014e9:	83 f8 30             	cmp    $0x30,%eax
  8014ec:	73 17                	jae    801505 <vprintfmt+0x1f9>
  8014ee:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8014f2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8014f5:	89 c0                	mov    %eax,%eax
  8014f7:	48 01 d0             	add    %rdx,%rax
  8014fa:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8014fd:	83 c2 08             	add    $0x8,%edx
  801500:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801503:	eb 0f                	jmp    801514 <vprintfmt+0x208>
  801505:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  801509:	48 89 d0             	mov    %rdx,%rax
  80150c:	48 83 c2 08          	add    $0x8,%rdx
  801510:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801514:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  801516:	85 db                	test   %ebx,%ebx
  801518:	79 02                	jns    80151c <vprintfmt+0x210>
				err = -err;
  80151a:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80151c:	83 fb 15             	cmp    $0x15,%ebx
  80151f:	7f 16                	jg     801537 <vprintfmt+0x22b>
  801521:	48 b8 80 48 80 00 00 	movabs $0x804880,%rax
  801528:	00 00 00 
  80152b:	48 63 d3             	movslq %ebx,%rdx
  80152e:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  801532:	4d 85 e4             	test   %r12,%r12
  801535:	75 2e                	jne    801565 <vprintfmt+0x259>
				printfmt(putch, putdat, "error %d", err);
  801537:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80153b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80153f:	89 d9                	mov    %ebx,%ecx
  801541:	48 ba 41 49 80 00 00 	movabs $0x804941,%rdx
  801548:	00 00 00 
  80154b:	48 89 c7             	mov    %rax,%rdi
  80154e:	b8 00 00 00 00       	mov    $0x0,%eax
  801553:	49 b8 65 18 80 00 00 	movabs $0x801865,%r8
  80155a:	00 00 00 
  80155d:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801560:	e9 f1 02 00 00       	jmpq   801856 <vprintfmt+0x54a>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801565:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801569:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80156d:	4c 89 e1             	mov    %r12,%rcx
  801570:	48 ba 4a 49 80 00 00 	movabs $0x80494a,%rdx
  801577:	00 00 00 
  80157a:	48 89 c7             	mov    %rax,%rdi
  80157d:	b8 00 00 00 00       	mov    $0x0,%eax
  801582:	49 b8 65 18 80 00 00 	movabs $0x801865,%r8
  801589:	00 00 00 
  80158c:	41 ff d0             	callq  *%r8
			break;
  80158f:	e9 c2 02 00 00       	jmpq   801856 <vprintfmt+0x54a>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  801594:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801597:	83 f8 30             	cmp    $0x30,%eax
  80159a:	73 17                	jae    8015b3 <vprintfmt+0x2a7>
  80159c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8015a0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8015a3:	89 c0                	mov    %eax,%eax
  8015a5:	48 01 d0             	add    %rdx,%rax
  8015a8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8015ab:	83 c2 08             	add    $0x8,%edx
  8015ae:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8015b1:	eb 0f                	jmp    8015c2 <vprintfmt+0x2b6>
  8015b3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  8015b7:	48 89 d0             	mov    %rdx,%rax
  8015ba:	48 83 c2 08          	add    $0x8,%rdx
  8015be:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8015c2:	4c 8b 20             	mov    (%rax),%r12
  8015c5:	4d 85 e4             	test   %r12,%r12
  8015c8:	75 0a                	jne    8015d4 <vprintfmt+0x2c8>
				p = "(null)";
  8015ca:	49 bc 4d 49 80 00 00 	movabs $0x80494d,%r12
  8015d1:	00 00 00 
			if (width > 0 && padc != '-')
  8015d4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8015d8:	7e 3f                	jle    801619 <vprintfmt+0x30d>
  8015da:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8015de:	74 39                	je     801619 <vprintfmt+0x30d>
				for (width -= strnlen(p, precision); width > 0; width--)
  8015e0:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8015e3:	48 98                	cltq   
  8015e5:	48 89 c6             	mov    %rax,%rsi
  8015e8:	4c 89 e7             	mov    %r12,%rdi
  8015eb:	48 b8 11 1b 80 00 00 	movabs $0x801b11,%rax
  8015f2:	00 00 00 
  8015f5:	ff d0                	callq  *%rax
  8015f7:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8015fa:	eb 17                	jmp    801613 <vprintfmt+0x307>
					putch(padc, putdat);
  8015fc:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  801600:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  801604:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801608:	48 89 ce             	mov    %rcx,%rsi
  80160b:	89 d7                	mov    %edx,%edi
  80160d:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80160f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801613:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801617:	7f e3                	jg     8015fc <vprintfmt+0x2f0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801619:	eb 37                	jmp    801652 <vprintfmt+0x346>
				if (altflag && (ch < ' ' || ch > '~'))
  80161b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  80161f:	74 1e                	je     80163f <vprintfmt+0x333>
  801621:	83 fb 1f             	cmp    $0x1f,%ebx
  801624:	7e 05                	jle    80162b <vprintfmt+0x31f>
  801626:	83 fb 7e             	cmp    $0x7e,%ebx
  801629:	7e 14                	jle    80163f <vprintfmt+0x333>
					putch('?', putdat);
  80162b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80162f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801633:	48 89 d6             	mov    %rdx,%rsi
  801636:	bf 3f 00 00 00       	mov    $0x3f,%edi
  80163b:	ff d0                	callq  *%rax
  80163d:	eb 0f                	jmp    80164e <vprintfmt+0x342>
				else
					putch(ch, putdat);
  80163f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801643:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801647:	48 89 d6             	mov    %rdx,%rsi
  80164a:	89 df                	mov    %ebx,%edi
  80164c:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80164e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801652:	4c 89 e0             	mov    %r12,%rax
  801655:	4c 8d 60 01          	lea    0x1(%rax),%r12
  801659:	0f b6 00             	movzbl (%rax),%eax
  80165c:	0f be d8             	movsbl %al,%ebx
  80165f:	85 db                	test   %ebx,%ebx
  801661:	74 10                	je     801673 <vprintfmt+0x367>
  801663:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801667:	78 b2                	js     80161b <vprintfmt+0x30f>
  801669:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80166d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801671:	79 a8                	jns    80161b <vprintfmt+0x30f>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801673:	eb 16                	jmp    80168b <vprintfmt+0x37f>
				putch(' ', putdat);
  801675:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801679:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80167d:	48 89 d6             	mov    %rdx,%rsi
  801680:	bf 20 00 00 00       	mov    $0x20,%edi
  801685:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801687:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80168b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80168f:	7f e4                	jg     801675 <vprintfmt+0x369>
				putch(' ', putdat);
			break;
  801691:	e9 c0 01 00 00       	jmpq   801856 <vprintfmt+0x54a>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801696:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80169a:	be 03 00 00 00       	mov    $0x3,%esi
  80169f:	48 89 c7             	mov    %rax,%rdi
  8016a2:	48 b8 fc 11 80 00 00 	movabs $0x8011fc,%rax
  8016a9:	00 00 00 
  8016ac:	ff d0                	callq  *%rax
  8016ae:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8016b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016b6:	48 85 c0             	test   %rax,%rax
  8016b9:	79 1d                	jns    8016d8 <vprintfmt+0x3cc>
				putch('-', putdat);
  8016bb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8016bf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8016c3:	48 89 d6             	mov    %rdx,%rsi
  8016c6:	bf 2d 00 00 00       	mov    $0x2d,%edi
  8016cb:	ff d0                	callq  *%rax
				num = -(long long) num;
  8016cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016d1:	48 f7 d8             	neg    %rax
  8016d4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  8016d8:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8016df:	e9 d5 00 00 00       	jmpq   8017b9 <vprintfmt+0x4ad>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  8016e4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8016e8:	be 03 00 00 00       	mov    $0x3,%esi
  8016ed:	48 89 c7             	mov    %rax,%rdi
  8016f0:	48 b8 ec 10 80 00 00 	movabs $0x8010ec,%rax
  8016f7:	00 00 00 
  8016fa:	ff d0                	callq  *%rax
  8016fc:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  801700:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801707:	e9 ad 00 00 00       	jmpq   8017b9 <vprintfmt+0x4ad>
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			// break;
			num = getuint(&aq, 3);
  80170c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801710:	be 03 00 00 00       	mov    $0x3,%esi
  801715:	48 89 c7             	mov    %rax,%rdi
  801718:	48 b8 ec 10 80 00 00 	movabs $0x8010ec,%rax
  80171f:	00 00 00 
  801722:	ff d0                	callq  *%rax
  801724:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  801728:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  80172f:	e9 85 00 00 00       	jmpq   8017b9 <vprintfmt+0x4ad>

			// pointer
		case 'p':
			putch('0', putdat);
  801734:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801738:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80173c:	48 89 d6             	mov    %rdx,%rsi
  80173f:	bf 30 00 00 00       	mov    $0x30,%edi
  801744:	ff d0                	callq  *%rax
			putch('x', putdat);
  801746:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80174a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80174e:	48 89 d6             	mov    %rdx,%rsi
  801751:	bf 78 00 00 00       	mov    $0x78,%edi
  801756:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801758:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80175b:	83 f8 30             	cmp    $0x30,%eax
  80175e:	73 17                	jae    801777 <vprintfmt+0x46b>
  801760:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801764:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801767:	89 c0                	mov    %eax,%eax
  801769:	48 01 d0             	add    %rdx,%rax
  80176c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80176f:	83 c2 08             	add    $0x8,%edx
  801772:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801775:	eb 0f                	jmp    801786 <vprintfmt+0x47a>
				(uintptr_t) va_arg(aq, void *);
  801777:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80177b:	48 89 d0             	mov    %rdx,%rax
  80177e:	48 83 c2 08          	add    $0x8,%rdx
  801782:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801786:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801789:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  80178d:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801794:	eb 23                	jmp    8017b9 <vprintfmt+0x4ad>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801796:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80179a:	be 03 00 00 00       	mov    $0x3,%esi
  80179f:	48 89 c7             	mov    %rax,%rdi
  8017a2:	48 b8 ec 10 80 00 00 	movabs $0x8010ec,%rax
  8017a9:	00 00 00 
  8017ac:	ff d0                	callq  *%rax
  8017ae:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8017b2:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8017b9:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8017be:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8017c1:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8017c4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017c8:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8017cc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8017d0:	45 89 c1             	mov    %r8d,%r9d
  8017d3:	41 89 f8             	mov    %edi,%r8d
  8017d6:	48 89 c7             	mov    %rax,%rdi
  8017d9:	48 b8 31 10 80 00 00 	movabs $0x801031,%rax
  8017e0:	00 00 00 
  8017e3:	ff d0                	callq  *%rax
			break;
  8017e5:	eb 6f                	jmp    801856 <vprintfmt+0x54a>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  8017e7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8017eb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8017ef:	48 89 d6             	mov    %rdx,%rsi
  8017f2:	89 df                	mov    %ebx,%edi
  8017f4:	ff d0                	callq  *%rax
			break;
  8017f6:	eb 5e                	jmp    801856 <vprintfmt+0x54a>
		
		case 'C':
		    num=getuint(&aq,3);		
  8017f8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8017fc:	be 03 00 00 00       	mov    $0x3,%esi
  801801:	48 89 c7             	mov    %rax,%rdi
  801804:	48 b8 ec 10 80 00 00 	movabs $0x8010ec,%rax
  80180b:	00 00 00 
  80180e:	ff d0                	callq  *%rax
  801810:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			current_color=num;
  801814:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801818:	89 c2                	mov    %eax,%edx
  80181a:	48 b8 10 70 80 00 00 	movabs $0x807010,%rax
  801821:	00 00 00 
  801824:	89 10                	mov    %edx,(%rax)
			break;
  801826:	eb 2e                	jmp    801856 <vprintfmt+0x54a>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801828:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80182c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801830:	48 89 d6             	mov    %rdx,%rsi
  801833:	bf 25 00 00 00       	mov    $0x25,%edi
  801838:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  80183a:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80183f:	eb 05                	jmp    801846 <vprintfmt+0x53a>
  801841:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801846:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80184a:	48 83 e8 01          	sub    $0x1,%rax
  80184e:	0f b6 00             	movzbl (%rax),%eax
  801851:	3c 25                	cmp    $0x25,%al
  801853:	75 ec                	jne    801841 <vprintfmt+0x535>
				/* do nothing */;
			break;
  801855:	90                   	nop
		}
	}
  801856:	90                   	nop
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801857:	e9 13 fb ff ff       	jmpq   80136f <vprintfmt+0x63>
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  80185c:	48 83 c4 60          	add    $0x60,%rsp
  801860:	5b                   	pop    %rbx
  801861:	41 5c                	pop    %r12
  801863:	5d                   	pop    %rbp
  801864:	c3                   	retq   

0000000000801865 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801865:	55                   	push   %rbp
  801866:	48 89 e5             	mov    %rsp,%rbp
  801869:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801870:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801877:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80187e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801885:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80188c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801893:	84 c0                	test   %al,%al
  801895:	74 20                	je     8018b7 <printfmt+0x52>
  801897:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80189b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80189f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8018a3:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8018a7:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8018ab:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8018af:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8018b3:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  8018b7:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8018be:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8018c5:	00 00 00 
  8018c8:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8018cf:	00 00 00 
  8018d2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8018d6:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8018dd:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8018e4:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8018eb:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8018f2:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8018f9:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801900:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801907:	48 89 c7             	mov    %rax,%rdi
  80190a:	48 b8 0c 13 80 00 00 	movabs $0x80130c,%rax
  801911:	00 00 00 
  801914:	ff d0                	callq  *%rax
	va_end(ap);
}
  801916:	c9                   	leaveq 
  801917:	c3                   	retq   

0000000000801918 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801918:	55                   	push   %rbp
  801919:	48 89 e5             	mov    %rsp,%rbp
  80191c:	48 83 ec 10          	sub    $0x10,%rsp
  801920:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801923:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801927:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80192b:	8b 40 10             	mov    0x10(%rax),%eax
  80192e:	8d 50 01             	lea    0x1(%rax),%edx
  801931:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801935:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801938:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80193c:	48 8b 10             	mov    (%rax),%rdx
  80193f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801943:	48 8b 40 08          	mov    0x8(%rax),%rax
  801947:	48 39 c2             	cmp    %rax,%rdx
  80194a:	73 17                	jae    801963 <sprintputch+0x4b>
		*b->buf++ = ch;
  80194c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801950:	48 8b 00             	mov    (%rax),%rax
  801953:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801957:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80195b:	48 89 0a             	mov    %rcx,(%rdx)
  80195e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801961:	88 10                	mov    %dl,(%rax)
}
  801963:	c9                   	leaveq 
  801964:	c3                   	retq   

0000000000801965 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801965:	55                   	push   %rbp
  801966:	48 89 e5             	mov    %rsp,%rbp
  801969:	48 83 ec 50          	sub    $0x50,%rsp
  80196d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801971:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801974:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801978:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80197c:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801980:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801984:	48 8b 0a             	mov    (%rdx),%rcx
  801987:	48 89 08             	mov    %rcx,(%rax)
  80198a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80198e:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801992:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801996:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80199a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80199e:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8019a2:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8019a5:	48 98                	cltq   
  8019a7:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8019ab:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8019af:	48 01 d0             	add    %rdx,%rax
  8019b2:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8019b6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8019bd:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8019c2:	74 06                	je     8019ca <vsnprintf+0x65>
  8019c4:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8019c8:	7f 07                	jg     8019d1 <vsnprintf+0x6c>
		return -E_INVAL;
  8019ca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019cf:	eb 2f                	jmp    801a00 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8019d1:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8019d5:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8019d9:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8019dd:	48 89 c6             	mov    %rax,%rsi
  8019e0:	48 bf 18 19 80 00 00 	movabs $0x801918,%rdi
  8019e7:	00 00 00 
  8019ea:	48 b8 0c 13 80 00 00 	movabs $0x80130c,%rax
  8019f1:	00 00 00 
  8019f4:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8019f6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8019fa:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8019fd:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801a00:	c9                   	leaveq 
  801a01:	c3                   	retq   

0000000000801a02 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801a02:	55                   	push   %rbp
  801a03:	48 89 e5             	mov    %rsp,%rbp
  801a06:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801a0d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801a14:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801a1a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801a21:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801a28:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801a2f:	84 c0                	test   %al,%al
  801a31:	74 20                	je     801a53 <snprintf+0x51>
  801a33:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801a37:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801a3b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801a3f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801a43:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801a47:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801a4b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801a4f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  801a53:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801a5a:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801a61:	00 00 00 
  801a64:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801a6b:	00 00 00 
  801a6e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801a72:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  801a79:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801a80:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801a87:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801a8e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801a95:	48 8b 0a             	mov    (%rdx),%rcx
  801a98:	48 89 08             	mov    %rcx,(%rax)
  801a9b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801a9f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801aa3:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801aa7:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801aab:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801ab2:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801ab9:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801abf:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801ac6:	48 89 c7             	mov    %rax,%rdi
  801ac9:	48 b8 65 19 80 00 00 	movabs $0x801965,%rax
  801ad0:	00 00 00 
  801ad3:	ff d0                	callq  *%rax
  801ad5:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801adb:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801ae1:	c9                   	leaveq 
  801ae2:	c3                   	retq   

0000000000801ae3 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801ae3:	55                   	push   %rbp
  801ae4:	48 89 e5             	mov    %rsp,%rbp
  801ae7:	48 83 ec 18          	sub    $0x18,%rsp
  801aeb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801aef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801af6:	eb 09                	jmp    801b01 <strlen+0x1e>
		n++;
  801af8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801afc:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801b01:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b05:	0f b6 00             	movzbl (%rax),%eax
  801b08:	84 c0                	test   %al,%al
  801b0a:	75 ec                	jne    801af8 <strlen+0x15>
		n++;
	return n;
  801b0c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801b0f:	c9                   	leaveq 
  801b10:	c3                   	retq   

0000000000801b11 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801b11:	55                   	push   %rbp
  801b12:	48 89 e5             	mov    %rsp,%rbp
  801b15:	48 83 ec 20          	sub    $0x20,%rsp
  801b19:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b1d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801b21:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801b28:	eb 0e                	jmp    801b38 <strnlen+0x27>
		n++;
  801b2a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801b2e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801b33:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801b38:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801b3d:	74 0b                	je     801b4a <strnlen+0x39>
  801b3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b43:	0f b6 00             	movzbl (%rax),%eax
  801b46:	84 c0                	test   %al,%al
  801b48:	75 e0                	jne    801b2a <strnlen+0x19>
		n++;
	return n;
  801b4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801b4d:	c9                   	leaveq 
  801b4e:	c3                   	retq   

0000000000801b4f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801b4f:	55                   	push   %rbp
  801b50:	48 89 e5             	mov    %rsp,%rbp
  801b53:	48 83 ec 20          	sub    $0x20,%rsp
  801b57:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b5b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801b5f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b63:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  801b67:	90                   	nop
  801b68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b6c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801b70:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801b74:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801b78:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801b7c:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801b80:	0f b6 12             	movzbl (%rdx),%edx
  801b83:	88 10                	mov    %dl,(%rax)
  801b85:	0f b6 00             	movzbl (%rax),%eax
  801b88:	84 c0                	test   %al,%al
  801b8a:	75 dc                	jne    801b68 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801b8c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801b90:	c9                   	leaveq 
  801b91:	c3                   	retq   

0000000000801b92 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801b92:	55                   	push   %rbp
  801b93:	48 89 e5             	mov    %rsp,%rbp
  801b96:	48 83 ec 20          	sub    $0x20,%rsp
  801b9a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801b9e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801ba2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ba6:	48 89 c7             	mov    %rax,%rdi
  801ba9:	48 b8 e3 1a 80 00 00 	movabs $0x801ae3,%rax
  801bb0:	00 00 00 
  801bb3:	ff d0                	callq  *%rax
  801bb5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801bb8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bbb:	48 63 d0             	movslq %eax,%rdx
  801bbe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bc2:	48 01 c2             	add    %rax,%rdx
  801bc5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801bc9:	48 89 c6             	mov    %rax,%rsi
  801bcc:	48 89 d7             	mov    %rdx,%rdi
  801bcf:	48 b8 4f 1b 80 00 00 	movabs $0x801b4f,%rax
  801bd6:	00 00 00 
  801bd9:	ff d0                	callq  *%rax
	return dst;
  801bdb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801bdf:	c9                   	leaveq 
  801be0:	c3                   	retq   

0000000000801be1 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801be1:	55                   	push   %rbp
  801be2:	48 89 e5             	mov    %rsp,%rbp
  801be5:	48 83 ec 28          	sub    $0x28,%rsp
  801be9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801bed:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801bf1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801bf5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bf9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801bfd:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801c04:	00 
  801c05:	eb 2a                	jmp    801c31 <strncpy+0x50>
		*dst++ = *src;
  801c07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c0b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801c0f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801c13:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801c17:	0f b6 12             	movzbl (%rdx),%edx
  801c1a:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801c1c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c20:	0f b6 00             	movzbl (%rax),%eax
  801c23:	84 c0                	test   %al,%al
  801c25:	74 05                	je     801c2c <strncpy+0x4b>
			src++;
  801c27:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801c2c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801c31:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c35:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801c39:	72 cc                	jb     801c07 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801c3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801c3f:	c9                   	leaveq 
  801c40:	c3                   	retq   

0000000000801c41 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801c41:	55                   	push   %rbp
  801c42:	48 89 e5             	mov    %rsp,%rbp
  801c45:	48 83 ec 28          	sub    $0x28,%rsp
  801c49:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801c4d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801c51:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801c55:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c59:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801c5d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801c62:	74 3d                	je     801ca1 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801c64:	eb 1d                	jmp    801c83 <strlcpy+0x42>
			*dst++ = *src++;
  801c66:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c6a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801c6e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801c72:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801c76:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801c7a:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801c7e:	0f b6 12             	movzbl (%rdx),%edx
  801c81:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801c83:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801c88:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801c8d:	74 0b                	je     801c9a <strlcpy+0x59>
  801c8f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c93:	0f b6 00             	movzbl (%rax),%eax
  801c96:	84 c0                	test   %al,%al
  801c98:	75 cc                	jne    801c66 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801c9a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c9e:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801ca1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801ca5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ca9:	48 29 c2             	sub    %rax,%rdx
  801cac:	48 89 d0             	mov    %rdx,%rax
}
  801caf:	c9                   	leaveq 
  801cb0:	c3                   	retq   

0000000000801cb1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801cb1:	55                   	push   %rbp
  801cb2:	48 89 e5             	mov    %rsp,%rbp
  801cb5:	48 83 ec 10          	sub    $0x10,%rsp
  801cb9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801cbd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801cc1:	eb 0a                	jmp    801ccd <strcmp+0x1c>
		p++, q++;
  801cc3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801cc8:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801ccd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cd1:	0f b6 00             	movzbl (%rax),%eax
  801cd4:	84 c0                	test   %al,%al
  801cd6:	74 12                	je     801cea <strcmp+0x39>
  801cd8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cdc:	0f b6 10             	movzbl (%rax),%edx
  801cdf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ce3:	0f b6 00             	movzbl (%rax),%eax
  801ce6:	38 c2                	cmp    %al,%dl
  801ce8:	74 d9                	je     801cc3 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801cea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cee:	0f b6 00             	movzbl (%rax),%eax
  801cf1:	0f b6 d0             	movzbl %al,%edx
  801cf4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cf8:	0f b6 00             	movzbl (%rax),%eax
  801cfb:	0f b6 c0             	movzbl %al,%eax
  801cfe:	29 c2                	sub    %eax,%edx
  801d00:	89 d0                	mov    %edx,%eax
}
  801d02:	c9                   	leaveq 
  801d03:	c3                   	retq   

0000000000801d04 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801d04:	55                   	push   %rbp
  801d05:	48 89 e5             	mov    %rsp,%rbp
  801d08:	48 83 ec 18          	sub    $0x18,%rsp
  801d0c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d10:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d14:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801d18:	eb 0f                	jmp    801d29 <strncmp+0x25>
		n--, p++, q++;
  801d1a:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801d1f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801d24:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801d29:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801d2e:	74 1d                	je     801d4d <strncmp+0x49>
  801d30:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d34:	0f b6 00             	movzbl (%rax),%eax
  801d37:	84 c0                	test   %al,%al
  801d39:	74 12                	je     801d4d <strncmp+0x49>
  801d3b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d3f:	0f b6 10             	movzbl (%rax),%edx
  801d42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d46:	0f b6 00             	movzbl (%rax),%eax
  801d49:	38 c2                	cmp    %al,%dl
  801d4b:	74 cd                	je     801d1a <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801d4d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801d52:	75 07                	jne    801d5b <strncmp+0x57>
		return 0;
  801d54:	b8 00 00 00 00       	mov    $0x0,%eax
  801d59:	eb 18                	jmp    801d73 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801d5b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d5f:	0f b6 00             	movzbl (%rax),%eax
  801d62:	0f b6 d0             	movzbl %al,%edx
  801d65:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d69:	0f b6 00             	movzbl (%rax),%eax
  801d6c:	0f b6 c0             	movzbl %al,%eax
  801d6f:	29 c2                	sub    %eax,%edx
  801d71:	89 d0                	mov    %edx,%eax
}
  801d73:	c9                   	leaveq 
  801d74:	c3                   	retq   

0000000000801d75 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801d75:	55                   	push   %rbp
  801d76:	48 89 e5             	mov    %rsp,%rbp
  801d79:	48 83 ec 0c          	sub    $0xc,%rsp
  801d7d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d81:	89 f0                	mov    %esi,%eax
  801d83:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801d86:	eb 17                	jmp    801d9f <strchr+0x2a>
		if (*s == c)
  801d88:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d8c:	0f b6 00             	movzbl (%rax),%eax
  801d8f:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801d92:	75 06                	jne    801d9a <strchr+0x25>
			return (char *) s;
  801d94:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d98:	eb 15                	jmp    801daf <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801d9a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801d9f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801da3:	0f b6 00             	movzbl (%rax),%eax
  801da6:	84 c0                	test   %al,%al
  801da8:	75 de                	jne    801d88 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801daa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801daf:	c9                   	leaveq 
  801db0:	c3                   	retq   

0000000000801db1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801db1:	55                   	push   %rbp
  801db2:	48 89 e5             	mov    %rsp,%rbp
  801db5:	48 83 ec 0c          	sub    $0xc,%rsp
  801db9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801dbd:	89 f0                	mov    %esi,%eax
  801dbf:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801dc2:	eb 13                	jmp    801dd7 <strfind+0x26>
		if (*s == c)
  801dc4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dc8:	0f b6 00             	movzbl (%rax),%eax
  801dcb:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801dce:	75 02                	jne    801dd2 <strfind+0x21>
			break;
  801dd0:	eb 10                	jmp    801de2 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801dd2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801dd7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ddb:	0f b6 00             	movzbl (%rax),%eax
  801dde:	84 c0                	test   %al,%al
  801de0:	75 e2                	jne    801dc4 <strfind+0x13>
		if (*s == c)
			break;
	return (char *) s;
  801de2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801de6:	c9                   	leaveq 
  801de7:	c3                   	retq   

0000000000801de8 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801de8:	55                   	push   %rbp
  801de9:	48 89 e5             	mov    %rsp,%rbp
  801dec:	48 83 ec 18          	sub    $0x18,%rsp
  801df0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801df4:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801df7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801dfb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801e00:	75 06                	jne    801e08 <memset+0x20>
		return v;
  801e02:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e06:	eb 69                	jmp    801e71 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801e08:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e0c:	83 e0 03             	and    $0x3,%eax
  801e0f:	48 85 c0             	test   %rax,%rax
  801e12:	75 48                	jne    801e5c <memset+0x74>
  801e14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e18:	83 e0 03             	and    $0x3,%eax
  801e1b:	48 85 c0             	test   %rax,%rax
  801e1e:	75 3c                	jne    801e5c <memset+0x74>
		c &= 0xFF;
  801e20:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801e27:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e2a:	c1 e0 18             	shl    $0x18,%eax
  801e2d:	89 c2                	mov    %eax,%edx
  801e2f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e32:	c1 e0 10             	shl    $0x10,%eax
  801e35:	09 c2                	or     %eax,%edx
  801e37:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e3a:	c1 e0 08             	shl    $0x8,%eax
  801e3d:	09 d0                	or     %edx,%eax
  801e3f:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801e42:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e46:	48 c1 e8 02          	shr    $0x2,%rax
  801e4a:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801e4d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e51:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e54:	48 89 d7             	mov    %rdx,%rdi
  801e57:	fc                   	cld    
  801e58:	f3 ab                	rep stos %eax,%es:(%rdi)
  801e5a:	eb 11                	jmp    801e6d <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801e5c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801e60:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801e63:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801e67:	48 89 d7             	mov    %rdx,%rdi
  801e6a:	fc                   	cld    
  801e6b:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801e6d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801e71:	c9                   	leaveq 
  801e72:	c3                   	retq   

0000000000801e73 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801e73:	55                   	push   %rbp
  801e74:	48 89 e5             	mov    %rsp,%rbp
  801e77:	48 83 ec 28          	sub    $0x28,%rsp
  801e7b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801e7f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801e83:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801e87:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e8b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801e8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e93:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801e97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e9b:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801e9f:	0f 83 88 00 00 00    	jae    801f2d <memmove+0xba>
  801ea5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ea9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ead:	48 01 d0             	add    %rdx,%rax
  801eb0:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801eb4:	76 77                	jbe    801f2d <memmove+0xba>
		s += n;
  801eb6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801eba:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801ebe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ec2:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801ec6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eca:	83 e0 03             	and    $0x3,%eax
  801ecd:	48 85 c0             	test   %rax,%rax
  801ed0:	75 3b                	jne    801f0d <memmove+0x9a>
  801ed2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ed6:	83 e0 03             	and    $0x3,%eax
  801ed9:	48 85 c0             	test   %rax,%rax
  801edc:	75 2f                	jne    801f0d <memmove+0x9a>
  801ede:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ee2:	83 e0 03             	and    $0x3,%eax
  801ee5:	48 85 c0             	test   %rax,%rax
  801ee8:	75 23                	jne    801f0d <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801eea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801eee:	48 83 e8 04          	sub    $0x4,%rax
  801ef2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ef6:	48 83 ea 04          	sub    $0x4,%rdx
  801efa:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801efe:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801f02:	48 89 c7             	mov    %rax,%rdi
  801f05:	48 89 d6             	mov    %rdx,%rsi
  801f08:	fd                   	std    
  801f09:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801f0b:	eb 1d                	jmp    801f2a <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801f0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f11:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801f15:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f19:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801f1d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f21:	48 89 d7             	mov    %rdx,%rdi
  801f24:	48 89 c1             	mov    %rax,%rcx
  801f27:	fd                   	std    
  801f28:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801f2a:	fc                   	cld    
  801f2b:	eb 57                	jmp    801f84 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801f2d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f31:	83 e0 03             	and    $0x3,%eax
  801f34:	48 85 c0             	test   %rax,%rax
  801f37:	75 36                	jne    801f6f <memmove+0xfc>
  801f39:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f3d:	83 e0 03             	and    $0x3,%eax
  801f40:	48 85 c0             	test   %rax,%rax
  801f43:	75 2a                	jne    801f6f <memmove+0xfc>
  801f45:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f49:	83 e0 03             	and    $0x3,%eax
  801f4c:	48 85 c0             	test   %rax,%rax
  801f4f:	75 1e                	jne    801f6f <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801f51:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f55:	48 c1 e8 02          	shr    $0x2,%rax
  801f59:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801f5c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f60:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f64:	48 89 c7             	mov    %rax,%rdi
  801f67:	48 89 d6             	mov    %rdx,%rsi
  801f6a:	fc                   	cld    
  801f6b:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801f6d:	eb 15                	jmp    801f84 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801f6f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f73:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f77:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801f7b:	48 89 c7             	mov    %rax,%rdi
  801f7e:	48 89 d6             	mov    %rdx,%rsi
  801f81:	fc                   	cld    
  801f82:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801f84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801f88:	c9                   	leaveq 
  801f89:	c3                   	retq   

0000000000801f8a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801f8a:	55                   	push   %rbp
  801f8b:	48 89 e5             	mov    %rsp,%rbp
  801f8e:	48 83 ec 18          	sub    $0x18,%rsp
  801f92:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801f96:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801f9a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801f9e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801fa2:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801fa6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801faa:	48 89 ce             	mov    %rcx,%rsi
  801fad:	48 89 c7             	mov    %rax,%rdi
  801fb0:	48 b8 73 1e 80 00 00 	movabs $0x801e73,%rax
  801fb7:	00 00 00 
  801fba:	ff d0                	callq  *%rax
}
  801fbc:	c9                   	leaveq 
  801fbd:	c3                   	retq   

0000000000801fbe <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801fbe:	55                   	push   %rbp
  801fbf:	48 89 e5             	mov    %rsp,%rbp
  801fc2:	48 83 ec 28          	sub    $0x28,%rsp
  801fc6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801fca:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801fce:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801fd2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fd6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801fda:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801fde:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801fe2:	eb 36                	jmp    80201a <memcmp+0x5c>
		if (*s1 != *s2)
  801fe4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fe8:	0f b6 10             	movzbl (%rax),%edx
  801feb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801fef:	0f b6 00             	movzbl (%rax),%eax
  801ff2:	38 c2                	cmp    %al,%dl
  801ff4:	74 1a                	je     802010 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801ff6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ffa:	0f b6 00             	movzbl (%rax),%eax
  801ffd:	0f b6 d0             	movzbl %al,%edx
  802000:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802004:	0f b6 00             	movzbl (%rax),%eax
  802007:	0f b6 c0             	movzbl %al,%eax
  80200a:	29 c2                	sub    %eax,%edx
  80200c:	89 d0                	mov    %edx,%eax
  80200e:	eb 20                	jmp    802030 <memcmp+0x72>
		s1++, s2++;
  802010:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802015:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80201a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80201e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802022:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  802026:	48 85 c0             	test   %rax,%rax
  802029:	75 b9                	jne    801fe4 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80202b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802030:	c9                   	leaveq 
  802031:	c3                   	retq   

0000000000802032 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  802032:	55                   	push   %rbp
  802033:	48 89 e5             	mov    %rsp,%rbp
  802036:	48 83 ec 28          	sub    $0x28,%rsp
  80203a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80203e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  802041:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  802045:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802049:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80204d:	48 01 d0             	add    %rdx,%rax
  802050:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  802054:	eb 15                	jmp    80206b <memfind+0x39>
		if (*(const unsigned char *) s == (unsigned char) c)
  802056:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80205a:	0f b6 10             	movzbl (%rax),%edx
  80205d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802060:	38 c2                	cmp    %al,%dl
  802062:	75 02                	jne    802066 <memfind+0x34>
			break;
  802064:	eb 0f                	jmp    802075 <memfind+0x43>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802066:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80206b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80206f:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  802073:	72 e1                	jb     802056 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
  802075:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802079:	c9                   	leaveq 
  80207a:	c3                   	retq   

000000000080207b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80207b:	55                   	push   %rbp
  80207c:	48 89 e5             	mov    %rsp,%rbp
  80207f:	48 83 ec 34          	sub    $0x34,%rsp
  802083:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802087:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80208b:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80208e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  802095:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80209c:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80209d:	eb 05                	jmp    8020a4 <strtol+0x29>
		s++;
  80209f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8020a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020a8:	0f b6 00             	movzbl (%rax),%eax
  8020ab:	3c 20                	cmp    $0x20,%al
  8020ad:	74 f0                	je     80209f <strtol+0x24>
  8020af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020b3:	0f b6 00             	movzbl (%rax),%eax
  8020b6:	3c 09                	cmp    $0x9,%al
  8020b8:	74 e5                	je     80209f <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8020ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020be:	0f b6 00             	movzbl (%rax),%eax
  8020c1:	3c 2b                	cmp    $0x2b,%al
  8020c3:	75 07                	jne    8020cc <strtol+0x51>
		s++;
  8020c5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8020ca:	eb 17                	jmp    8020e3 <strtol+0x68>
	else if (*s == '-')
  8020cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020d0:	0f b6 00             	movzbl (%rax),%eax
  8020d3:	3c 2d                	cmp    $0x2d,%al
  8020d5:	75 0c                	jne    8020e3 <strtol+0x68>
		s++, neg = 1;
  8020d7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8020dc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8020e3:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8020e7:	74 06                	je     8020ef <strtol+0x74>
  8020e9:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8020ed:	75 28                	jne    802117 <strtol+0x9c>
  8020ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020f3:	0f b6 00             	movzbl (%rax),%eax
  8020f6:	3c 30                	cmp    $0x30,%al
  8020f8:	75 1d                	jne    802117 <strtol+0x9c>
  8020fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020fe:	48 83 c0 01          	add    $0x1,%rax
  802102:	0f b6 00             	movzbl (%rax),%eax
  802105:	3c 78                	cmp    $0x78,%al
  802107:	75 0e                	jne    802117 <strtol+0x9c>
		s += 2, base = 16;
  802109:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80210e:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  802115:	eb 2c                	jmp    802143 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  802117:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80211b:	75 19                	jne    802136 <strtol+0xbb>
  80211d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802121:	0f b6 00             	movzbl (%rax),%eax
  802124:	3c 30                	cmp    $0x30,%al
  802126:	75 0e                	jne    802136 <strtol+0xbb>
		s++, base = 8;
  802128:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80212d:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  802134:	eb 0d                	jmp    802143 <strtol+0xc8>
	else if (base == 0)
  802136:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80213a:	75 07                	jne    802143 <strtol+0xc8>
		base = 10;
  80213c:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802143:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802147:	0f b6 00             	movzbl (%rax),%eax
  80214a:	3c 2f                	cmp    $0x2f,%al
  80214c:	7e 1d                	jle    80216b <strtol+0xf0>
  80214e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802152:	0f b6 00             	movzbl (%rax),%eax
  802155:	3c 39                	cmp    $0x39,%al
  802157:	7f 12                	jg     80216b <strtol+0xf0>
			dig = *s - '0';
  802159:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80215d:	0f b6 00             	movzbl (%rax),%eax
  802160:	0f be c0             	movsbl %al,%eax
  802163:	83 e8 30             	sub    $0x30,%eax
  802166:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802169:	eb 4e                	jmp    8021b9 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80216b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80216f:	0f b6 00             	movzbl (%rax),%eax
  802172:	3c 60                	cmp    $0x60,%al
  802174:	7e 1d                	jle    802193 <strtol+0x118>
  802176:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80217a:	0f b6 00             	movzbl (%rax),%eax
  80217d:	3c 7a                	cmp    $0x7a,%al
  80217f:	7f 12                	jg     802193 <strtol+0x118>
			dig = *s - 'a' + 10;
  802181:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802185:	0f b6 00             	movzbl (%rax),%eax
  802188:	0f be c0             	movsbl %al,%eax
  80218b:	83 e8 57             	sub    $0x57,%eax
  80218e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802191:	eb 26                	jmp    8021b9 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  802193:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802197:	0f b6 00             	movzbl (%rax),%eax
  80219a:	3c 40                	cmp    $0x40,%al
  80219c:	7e 48                	jle    8021e6 <strtol+0x16b>
  80219e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021a2:	0f b6 00             	movzbl (%rax),%eax
  8021a5:	3c 5a                	cmp    $0x5a,%al
  8021a7:	7f 3d                	jg     8021e6 <strtol+0x16b>
			dig = *s - 'A' + 10;
  8021a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021ad:	0f b6 00             	movzbl (%rax),%eax
  8021b0:	0f be c0             	movsbl %al,%eax
  8021b3:	83 e8 37             	sub    $0x37,%eax
  8021b6:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8021b9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021bc:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8021bf:	7c 02                	jl     8021c3 <strtol+0x148>
			break;
  8021c1:	eb 23                	jmp    8021e6 <strtol+0x16b>
		s++, val = (val * base) + dig;
  8021c3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8021c8:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8021cb:	48 98                	cltq   
  8021cd:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8021d2:	48 89 c2             	mov    %rax,%rdx
  8021d5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021d8:	48 98                	cltq   
  8021da:	48 01 d0             	add    %rdx,%rax
  8021dd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8021e1:	e9 5d ff ff ff       	jmpq   802143 <strtol+0xc8>

	if (endptr)
  8021e6:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8021eb:	74 0b                	je     8021f8 <strtol+0x17d>
		*endptr = (char *) s;
  8021ed:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8021f1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8021f5:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8021f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021fc:	74 09                	je     802207 <strtol+0x18c>
  8021fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802202:	48 f7 d8             	neg    %rax
  802205:	eb 04                	jmp    80220b <strtol+0x190>
  802207:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80220b:	c9                   	leaveq 
  80220c:	c3                   	retq   

000000000080220d <strstr>:

char * strstr(const char *in, const char *str)
{
  80220d:	55                   	push   %rbp
  80220e:	48 89 e5             	mov    %rsp,%rbp
  802211:	48 83 ec 30          	sub    $0x30,%rsp
  802215:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802219:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80221d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802221:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802225:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  802229:	0f b6 00             	movzbl (%rax),%eax
  80222c:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80222f:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  802233:	75 06                	jne    80223b <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  802235:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802239:	eb 6b                	jmp    8022a6 <strstr+0x99>

	len = strlen(str);
  80223b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80223f:	48 89 c7             	mov    %rax,%rdi
  802242:	48 b8 e3 1a 80 00 00 	movabs $0x801ae3,%rax
  802249:	00 00 00 
  80224c:	ff d0                	callq  *%rax
  80224e:	48 98                	cltq   
  802250:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  802254:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802258:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80225c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  802260:	0f b6 00             	movzbl (%rax),%eax
  802263:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  802266:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80226a:	75 07                	jne    802273 <strstr+0x66>
				return (char *) 0;
  80226c:	b8 00 00 00 00       	mov    $0x0,%eax
  802271:	eb 33                	jmp    8022a6 <strstr+0x99>
		} while (sc != c);
  802273:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  802277:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80227a:	75 d8                	jne    802254 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80227c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802280:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802284:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802288:	48 89 ce             	mov    %rcx,%rsi
  80228b:	48 89 c7             	mov    %rax,%rdi
  80228e:	48 b8 04 1d 80 00 00 	movabs $0x801d04,%rax
  802295:	00 00 00 
  802298:	ff d0                	callq  *%rax
  80229a:	85 c0                	test   %eax,%eax
  80229c:	75 b6                	jne    802254 <strstr+0x47>

	return (char *) (in - 1);
  80229e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8022a2:	48 83 e8 01          	sub    $0x1,%rax
}
  8022a6:	c9                   	leaveq 
  8022a7:	c3                   	retq   

00000000008022a8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8022a8:	55                   	push   %rbp
  8022a9:	48 89 e5             	mov    %rsp,%rbp
  8022ac:	53                   	push   %rbx
  8022ad:	48 83 ec 48          	sub    $0x48,%rsp
  8022b1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8022b4:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8022b7:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8022bb:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8022bf:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8022c3:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8022c7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022ca:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8022ce:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8022d2:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8022d6:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8022da:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8022de:	4c 89 c3             	mov    %r8,%rbx
  8022e1:	cd 30                	int    $0x30
  8022e3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8022e7:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8022eb:	74 3e                	je     80232b <syscall+0x83>
  8022ed:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8022f2:	7e 37                	jle    80232b <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8022f4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8022f8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8022fb:	49 89 d0             	mov    %rdx,%r8
  8022fe:	89 c1                	mov    %eax,%ecx
  802300:	48 ba 08 4c 80 00 00 	movabs $0x804c08,%rdx
  802307:	00 00 00 
  80230a:	be 23 00 00 00       	mov    $0x23,%esi
  80230f:	48 bf 25 4c 80 00 00 	movabs $0x804c25,%rdi
  802316:	00 00 00 
  802319:	b8 00 00 00 00       	mov    $0x0,%eax
  80231e:	49 b9 20 0d 80 00 00 	movabs $0x800d20,%r9
  802325:	00 00 00 
  802328:	41 ff d1             	callq  *%r9

	return ret;
  80232b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80232f:	48 83 c4 48          	add    $0x48,%rsp
  802333:	5b                   	pop    %rbx
  802334:	5d                   	pop    %rbp
  802335:	c3                   	retq   

0000000000802336 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  802336:	55                   	push   %rbp
  802337:	48 89 e5             	mov    %rsp,%rbp
  80233a:	48 83 ec 20          	sub    $0x20,%rsp
  80233e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802342:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  802346:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80234a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80234e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802355:	00 
  802356:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80235c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802362:	48 89 d1             	mov    %rdx,%rcx
  802365:	48 89 c2             	mov    %rax,%rdx
  802368:	be 00 00 00 00       	mov    $0x0,%esi
  80236d:	bf 00 00 00 00       	mov    $0x0,%edi
  802372:	48 b8 a8 22 80 00 00 	movabs $0x8022a8,%rax
  802379:	00 00 00 
  80237c:	ff d0                	callq  *%rax
}
  80237e:	c9                   	leaveq 
  80237f:	c3                   	retq   

0000000000802380 <sys_cgetc>:

int
sys_cgetc(void)
{
  802380:	55                   	push   %rbp
  802381:	48 89 e5             	mov    %rsp,%rbp
  802384:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  802388:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80238f:	00 
  802390:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802396:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80239c:	b9 00 00 00 00       	mov    $0x0,%ecx
  8023a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8023a6:	be 00 00 00 00       	mov    $0x0,%esi
  8023ab:	bf 01 00 00 00       	mov    $0x1,%edi
  8023b0:	48 b8 a8 22 80 00 00 	movabs $0x8022a8,%rax
  8023b7:	00 00 00 
  8023ba:	ff d0                	callq  *%rax
}
  8023bc:	c9                   	leaveq 
  8023bd:	c3                   	retq   

00000000008023be <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8023be:	55                   	push   %rbp
  8023bf:	48 89 e5             	mov    %rsp,%rbp
  8023c2:	48 83 ec 10          	sub    $0x10,%rsp
  8023c6:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8023c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023cc:	48 98                	cltq   
  8023ce:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8023d5:	00 
  8023d6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8023dc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8023e2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8023e7:	48 89 c2             	mov    %rax,%rdx
  8023ea:	be 01 00 00 00       	mov    $0x1,%esi
  8023ef:	bf 03 00 00 00       	mov    $0x3,%edi
  8023f4:	48 b8 a8 22 80 00 00 	movabs $0x8022a8,%rax
  8023fb:	00 00 00 
  8023fe:	ff d0                	callq  *%rax
}
  802400:	c9                   	leaveq 
  802401:	c3                   	retq   

0000000000802402 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  802402:	55                   	push   %rbp
  802403:	48 89 e5             	mov    %rsp,%rbp
  802406:	48 83 ec 10          	sub    $0x10,%rsp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80240a:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802411:	00 
  802412:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802418:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80241e:	b9 00 00 00 00       	mov    $0x0,%ecx
  802423:	ba 00 00 00 00       	mov    $0x0,%edx
  802428:	be 00 00 00 00       	mov    $0x0,%esi
  80242d:	bf 02 00 00 00       	mov    $0x2,%edi
  802432:	48 b8 a8 22 80 00 00 	movabs $0x8022a8,%rax
  802439:	00 00 00 
  80243c:	ff d0                	callq  *%rax
}
  80243e:	c9                   	leaveq 
  80243f:	c3                   	retq   

0000000000802440 <sys_yield>:

void
sys_yield(void)
{
  802440:	55                   	push   %rbp
  802441:	48 89 e5             	mov    %rsp,%rbp
  802444:	48 83 ec 10          	sub    $0x10,%rsp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  802448:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  80244f:	00 
  802450:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802456:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80245c:	b9 00 00 00 00       	mov    $0x0,%ecx
  802461:	ba 00 00 00 00       	mov    $0x0,%edx
  802466:	be 00 00 00 00       	mov    $0x0,%esi
  80246b:	bf 0b 00 00 00       	mov    $0xb,%edi
  802470:	48 b8 a8 22 80 00 00 	movabs $0x8022a8,%rax
  802477:	00 00 00 
  80247a:	ff d0                	callq  *%rax
}
  80247c:	c9                   	leaveq 
  80247d:	c3                   	retq   

000000000080247e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80247e:	55                   	push   %rbp
  80247f:	48 89 e5             	mov    %rsp,%rbp
  802482:	48 83 ec 20          	sub    $0x20,%rsp
  802486:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802489:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80248d:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  802490:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802493:	48 63 c8             	movslq %eax,%rcx
  802496:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80249a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80249d:	48 98                	cltq   
  80249f:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8024a6:	00 
  8024a7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8024ad:	49 89 c8             	mov    %rcx,%r8
  8024b0:	48 89 d1             	mov    %rdx,%rcx
  8024b3:	48 89 c2             	mov    %rax,%rdx
  8024b6:	be 01 00 00 00       	mov    $0x1,%esi
  8024bb:	bf 04 00 00 00       	mov    $0x4,%edi
  8024c0:	48 b8 a8 22 80 00 00 	movabs $0x8022a8,%rax
  8024c7:	00 00 00 
  8024ca:	ff d0                	callq  *%rax
}
  8024cc:	c9                   	leaveq 
  8024cd:	c3                   	retq   

00000000008024ce <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8024ce:	55                   	push   %rbp
  8024cf:	48 89 e5             	mov    %rsp,%rbp
  8024d2:	48 83 ec 30          	sub    $0x30,%rsp
  8024d6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8024d9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8024dd:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8024e0:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8024e4:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8024e8:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8024eb:	48 63 c8             	movslq %eax,%rcx
  8024ee:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8024f2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024f5:	48 63 f0             	movslq %eax,%rsi
  8024f8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8024fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024ff:	48 98                	cltq   
  802501:	48 89 0c 24          	mov    %rcx,(%rsp)
  802505:	49 89 f9             	mov    %rdi,%r9
  802508:	49 89 f0             	mov    %rsi,%r8
  80250b:	48 89 d1             	mov    %rdx,%rcx
  80250e:	48 89 c2             	mov    %rax,%rdx
  802511:	be 01 00 00 00       	mov    $0x1,%esi
  802516:	bf 05 00 00 00       	mov    $0x5,%edi
  80251b:	48 b8 a8 22 80 00 00 	movabs $0x8022a8,%rax
  802522:	00 00 00 
  802525:	ff d0                	callq  *%rax
}
  802527:	c9                   	leaveq 
  802528:	c3                   	retq   

0000000000802529 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  802529:	55                   	push   %rbp
  80252a:	48 89 e5             	mov    %rsp,%rbp
  80252d:	48 83 ec 20          	sub    $0x20,%rsp
  802531:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802534:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  802538:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80253c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80253f:	48 98                	cltq   
  802541:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802548:	00 
  802549:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80254f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802555:	48 89 d1             	mov    %rdx,%rcx
  802558:	48 89 c2             	mov    %rax,%rdx
  80255b:	be 01 00 00 00       	mov    $0x1,%esi
  802560:	bf 06 00 00 00       	mov    $0x6,%edi
  802565:	48 b8 a8 22 80 00 00 	movabs $0x8022a8,%rax
  80256c:	00 00 00 
  80256f:	ff d0                	callq  *%rax
}
  802571:	c9                   	leaveq 
  802572:	c3                   	retq   

0000000000802573 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  802573:	55                   	push   %rbp
  802574:	48 89 e5             	mov    %rsp,%rbp
  802577:	48 83 ec 10          	sub    $0x10,%rsp
  80257b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80257e:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  802581:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802584:	48 63 d0             	movslq %eax,%rdx
  802587:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80258a:	48 98                	cltq   
  80258c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802593:	00 
  802594:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80259a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8025a0:	48 89 d1             	mov    %rdx,%rcx
  8025a3:	48 89 c2             	mov    %rax,%rdx
  8025a6:	be 01 00 00 00       	mov    $0x1,%esi
  8025ab:	bf 08 00 00 00       	mov    $0x8,%edi
  8025b0:	48 b8 a8 22 80 00 00 	movabs $0x8022a8,%rax
  8025b7:	00 00 00 
  8025ba:	ff d0                	callq  *%rax
}
  8025bc:	c9                   	leaveq 
  8025bd:	c3                   	retq   

00000000008025be <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8025be:	55                   	push   %rbp
  8025bf:	48 89 e5             	mov    %rsp,%rbp
  8025c2:	48 83 ec 20          	sub    $0x20,%rsp
  8025c6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8025c9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  8025cd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025d4:	48 98                	cltq   
  8025d6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8025dd:	00 
  8025de:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8025e4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8025ea:	48 89 d1             	mov    %rdx,%rcx
  8025ed:	48 89 c2             	mov    %rax,%rdx
  8025f0:	be 01 00 00 00       	mov    $0x1,%esi
  8025f5:	bf 09 00 00 00       	mov    $0x9,%edi
  8025fa:	48 b8 a8 22 80 00 00 	movabs $0x8022a8,%rax
  802601:	00 00 00 
  802604:	ff d0                	callq  *%rax
}
  802606:	c9                   	leaveq 
  802607:	c3                   	retq   

0000000000802608 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802608:	55                   	push   %rbp
  802609:	48 89 e5             	mov    %rsp,%rbp
  80260c:	48 83 ec 20          	sub    $0x20,%rsp
  802610:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802613:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  802617:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80261b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80261e:	48 98                	cltq   
  802620:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802627:	00 
  802628:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80262e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802634:	48 89 d1             	mov    %rdx,%rcx
  802637:	48 89 c2             	mov    %rax,%rdx
  80263a:	be 01 00 00 00       	mov    $0x1,%esi
  80263f:	bf 0a 00 00 00       	mov    $0xa,%edi
  802644:	48 b8 a8 22 80 00 00 	movabs $0x8022a8,%rax
  80264b:	00 00 00 
  80264e:	ff d0                	callq  *%rax
}
  802650:	c9                   	leaveq 
  802651:	c3                   	retq   

0000000000802652 <sys_set_priority>:

void
sys_set_priority(envid_t envid, int priority)
{
  802652:	55                   	push   %rbp
  802653:	48 89 e5             	mov    %rsp,%rbp
  802656:	48 83 ec 10          	sub    $0x10,%rsp
  80265a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80265d:	89 75 f8             	mov    %esi,-0x8(%rbp)
	syscall(SYS_set_priority,1,envid,priority,0,0,0);
  802660:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802663:	48 63 d0             	movslq %eax,%rdx
  802666:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802669:	48 98                	cltq   
  80266b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802672:	00 
  802673:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802679:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80267f:	48 89 d1             	mov    %rdx,%rcx
  802682:	48 89 c2             	mov    %rax,%rdx
  802685:	be 01 00 00 00       	mov    $0x1,%esi
  80268a:	bf 11 00 00 00       	mov    $0x11,%edi
  80268f:	48 b8 a8 22 80 00 00 	movabs $0x8022a8,%rax
  802696:	00 00 00 
  802699:	ff d0                	callq  *%rax

}
  80269b:	c9                   	leaveq 
  80269c:	c3                   	retq   

000000000080269d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  80269d:	55                   	push   %rbp
  80269e:	48 89 e5             	mov    %rsp,%rbp
  8026a1:	48 83 ec 20          	sub    $0x20,%rsp
  8026a5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8026a8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8026ac:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8026b0:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8026b3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8026b6:	48 63 f0             	movslq %eax,%rsi
  8026b9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8026bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026c0:	48 98                	cltq   
  8026c2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8026c6:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8026cd:	00 
  8026ce:	49 89 f1             	mov    %rsi,%r9
  8026d1:	49 89 c8             	mov    %rcx,%r8
  8026d4:	48 89 d1             	mov    %rdx,%rcx
  8026d7:	48 89 c2             	mov    %rax,%rdx
  8026da:	be 00 00 00 00       	mov    $0x0,%esi
  8026df:	bf 0c 00 00 00       	mov    $0xc,%edi
  8026e4:	48 b8 a8 22 80 00 00 	movabs $0x8022a8,%rax
  8026eb:	00 00 00 
  8026ee:	ff d0                	callq  *%rax
}
  8026f0:	c9                   	leaveq 
  8026f1:	c3                   	retq   

00000000008026f2 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8026f2:	55                   	push   %rbp
  8026f3:	48 89 e5             	mov    %rsp,%rbp
  8026f6:	48 83 ec 10          	sub    $0x10,%rsp
  8026fa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  8026fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802702:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802709:	00 
  80270a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802710:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802716:	b9 00 00 00 00       	mov    $0x0,%ecx
  80271b:	48 89 c2             	mov    %rax,%rdx
  80271e:	be 01 00 00 00       	mov    $0x1,%esi
  802723:	bf 0d 00 00 00       	mov    $0xd,%edi
  802728:	48 b8 a8 22 80 00 00 	movabs $0x8022a8,%rax
  80272f:	00 00 00 
  802732:	ff d0                	callq  *%rax
}
  802734:	c9                   	leaveq 
  802735:	c3                   	retq   

0000000000802736 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  802736:	55                   	push   %rbp
  802737:	48 89 e5             	mov    %rsp,%rbp
  80273a:	48 83 ec 10          	sub    $0x10,%rsp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  80273e:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  802745:	00 
  802746:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80274c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802752:	b9 00 00 00 00       	mov    $0x0,%ecx
  802757:	ba 00 00 00 00       	mov    $0x0,%edx
  80275c:	be 00 00 00 00       	mov    $0x0,%esi
  802761:	bf 0e 00 00 00       	mov    $0xe,%edi
  802766:	48 b8 a8 22 80 00 00 	movabs $0x8022a8,%rax
  80276d:	00 00 00 
  802770:	ff d0                	callq  *%rax
}
  802772:	c9                   	leaveq 
  802773:	c3                   	retq   

0000000000802774 <sys_ept_map>:


int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  802774:	55                   	push   %rbp
  802775:	48 89 e5             	mov    %rsp,%rbp
  802778:	48 83 ec 30          	sub    $0x30,%rsp
  80277c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80277f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802783:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802786:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80278a:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  80278e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802791:	48 63 c8             	movslq %eax,%rcx
  802794:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802798:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80279b:	48 63 f0             	movslq %eax,%rsi
  80279e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8027a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027a5:	48 98                	cltq   
  8027a7:	48 89 0c 24          	mov    %rcx,(%rsp)
  8027ab:	49 89 f9             	mov    %rdi,%r9
  8027ae:	49 89 f0             	mov    %rsi,%r8
  8027b1:	48 89 d1             	mov    %rdx,%rcx
  8027b4:	48 89 c2             	mov    %rax,%rdx
  8027b7:	be 00 00 00 00       	mov    $0x0,%esi
  8027bc:	bf 0f 00 00 00       	mov    $0xf,%edi
  8027c1:	48 b8 a8 22 80 00 00 	movabs $0x8022a8,%rax
  8027c8:	00 00 00 
  8027cb:	ff d0                	callq  *%rax
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  8027cd:	c9                   	leaveq 
  8027ce:	c3                   	retq   

00000000008027cf <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  8027cf:	55                   	push   %rbp
  8027d0:	48 89 e5             	mov    %rsp,%rbp
  8027d3:	48 83 ec 20          	sub    $0x20,%rsp
  8027d7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8027db:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  8027df:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8027e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027e7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8027ee:	00 
  8027ef:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8027f5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8027fb:	48 89 d1             	mov    %rdx,%rcx
  8027fe:	48 89 c2             	mov    %rax,%rdx
  802801:	be 00 00 00 00       	mov    $0x0,%esi
  802806:	bf 10 00 00 00       	mov    $0x10,%edi
  80280b:	48 b8 a8 22 80 00 00 	movabs $0x8022a8,%rax
  802812:	00 00 00 
  802815:	ff d0                	callq  *%rax
}
  802817:	c9                   	leaveq 
  802818:	c3                   	retq   

0000000000802819 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802819:	55                   	push   %rbp
  80281a:	48 89 e5             	mov    %rsp,%rbp
  80281d:	48 83 ec 30          	sub    $0x30,%rsp
  802821:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802825:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802829:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	//LAB 4: Your code here.
	if (!pg) pg=(void*)-1;
  80282d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802832:	75 08                	jne    80283c <ipc_recv+0x23>
  802834:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  80283b:	ff 
	int res=sys_ipc_recv(pg);
  80283c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802840:	48 89 c7             	mov    %rax,%rdi
  802843:	48 b8 f2 26 80 00 00 	movabs $0x8026f2,%rax
  80284a:	00 00 00 
  80284d:	ff d0                	callq  *%rax
  80284f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	
	if (from_env_store) *from_env_store=res==0?thisenv->env_ipc_from:0;
  802852:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802857:	74 26                	je     80287f <ipc_recv+0x66>
  802859:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80285d:	75 15                	jne    802874 <ipc_recv+0x5b>
  80285f:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802866:	00 00 00 
  802869:	48 8b 00             	mov    (%rax),%rax
  80286c:	8b 80 0c 01 00 00    	mov    0x10c(%rax),%eax
  802872:	eb 05                	jmp    802879 <ipc_recv+0x60>
  802874:	b8 00 00 00 00       	mov    $0x0,%eax
  802879:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80287d:	89 02                	mov    %eax,(%rdx)
	if (perm_store) *perm_store=res==0?thisenv->env_ipc_perm:0;
  80287f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802884:	74 26                	je     8028ac <ipc_recv+0x93>
  802886:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80288a:	75 15                	jne    8028a1 <ipc_recv+0x88>
  80288c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802893:	00 00 00 
  802896:	48 8b 00             	mov    (%rax),%rax
  802899:	8b 80 10 01 00 00    	mov    0x110(%rax),%eax
  80289f:	eb 05                	jmp    8028a6 <ipc_recv+0x8d>
  8028a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8028a6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028aa:	89 02                	mov    %eax,(%rdx)
	return res!=0?res:thisenv->env_ipc_value;
  8028ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028b0:	75 15                	jne    8028c7 <ipc_recv+0xae>
  8028b2:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8028b9:	00 00 00 
  8028bc:	48 8b 00             	mov    (%rax),%rax
  8028bf:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax
  8028c5:	eb 03                	jmp    8028ca <ipc_recv+0xb1>
  8028c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
	

}
  8028ca:	c9                   	leaveq 
  8028cb:	c3                   	retq   

00000000008028cc <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8028cc:	55                   	push   %rbp
  8028cd:	48 89 e5             	mov    %rsp,%rbp
  8028d0:	48 83 ec 30          	sub    $0x30,%rsp
  8028d4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8028d7:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8028da:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8028de:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	// LAB 4: Your code here.

	if (!pg) pg=(void*)-1;
  8028e1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8028e6:	75 0a                	jne    8028f2 <ipc_send+0x26>
  8028e8:	48 c7 45 e0 ff ff ff 	movq   $0xffffffffffffffff,-0x20(%rbp)
  8028ef:	ff 
	int res;
	while ((res=sys_ipc_try_send(to_env, val, pg, perm))<0){
  8028f0:	eb 3e                	jmp    802930 <ipc_send+0x64>
  8028f2:	eb 3c                	jmp    802930 <ipc_send+0x64>
		if(res!=-E_IPC_NOT_RECV)
  8028f4:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8028f8:	74 2a                	je     802924 <ipc_send+0x58>
			panic("ipc_send:error other than -E_IPC_NOT_RECV\n");
  8028fa:	48 ba 38 4c 80 00 00 	movabs $0x804c38,%rdx
  802901:	00 00 00 
  802904:	be 39 00 00 00       	mov    $0x39,%esi
  802909:	48 bf 63 4c 80 00 00 	movabs $0x804c63,%rdi
  802910:	00 00 00 
  802913:	b8 00 00 00 00       	mov    $0x0,%eax
  802918:	48 b9 20 0d 80 00 00 	movabs $0x800d20,%rcx
  80291f:	00 00 00 
  802922:	ff d1                	callq  *%rcx
		sys_yield();  
  802924:	48 b8 40 24 80 00 00 	movabs $0x802440,%rax
  80292b:	00 00 00 
  80292e:	ff d0                	callq  *%rax
{
	// LAB 4: Your code here.

	if (!pg) pg=(void*)-1;
	int res;
	while ((res=sys_ipc_try_send(to_env, val, pg, perm))<0){
  802930:	8b 75 e8             	mov    -0x18(%rbp),%esi
  802933:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  802936:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80293a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80293d:	89 c7                	mov    %eax,%edi
  80293f:	48 b8 9d 26 80 00 00 	movabs $0x80269d,%rax
  802946:	00 00 00 
  802949:	ff d0                	callq  *%rax
  80294b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80294e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802952:	78 a0                	js     8028f4 <ipc_send+0x28>
			panic("ipc_send:error other than -E_IPC_NOT_RECV\n");
		sys_yield();  
	}
	//panic("ipc_send not implemented");

}
  802954:	c9                   	leaveq 
  802955:	c3                   	retq   

0000000000802956 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  802956:	55                   	push   %rbp
  802957:	48 89 e5             	mov    %rsp,%rbp
  80295a:	48 83 ec 10          	sub    $0x10,%rsp
  80295e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	// LAB 8: Your code here.
	panic("ipc_recv not implemented in VM guest");
  802962:	48 ba 70 4c 80 00 00 	movabs $0x804c70,%rdx
  802969:	00 00 00 
  80296c:	be 47 00 00 00       	mov    $0x47,%esi
  802971:	48 bf 63 4c 80 00 00 	movabs $0x804c63,%rdi
  802978:	00 00 00 
  80297b:	b8 00 00 00 00       	mov    $0x0,%eax
  802980:	48 b9 20 0d 80 00 00 	movabs $0x800d20,%rcx
  802987:	00 00 00 
  80298a:	ff d1                	callq  *%rcx

000000000080298c <ipc_host_send>:

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80298c:	55                   	push   %rbp
  80298d:	48 89 e5             	mov    %rsp,%rbp
  802990:	48 83 ec 20          	sub    $0x20,%rsp
  802994:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802997:	89 75 f8             	mov    %esi,-0x8(%rbp)
  80299a:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  80299e:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	// LAB 8: Your code here.
	panic("ipc_send not implemented in VM guest");
  8029a1:	48 ba 98 4c 80 00 00 	movabs $0x804c98,%rdx
  8029a8:	00 00 00 
  8029ab:	be 50 00 00 00       	mov    $0x50,%esi
  8029b0:	48 bf 63 4c 80 00 00 	movabs $0x804c63,%rdi
  8029b7:	00 00 00 
  8029ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8029bf:	48 b9 20 0d 80 00 00 	movabs $0x800d20,%rcx
  8029c6:	00 00 00 
  8029c9:	ff d1                	callq  *%rcx

00000000008029cb <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8029cb:	55                   	push   %rbp
  8029cc:	48 89 e5             	mov    %rsp,%rbp
  8029cf:	48 83 ec 14          	sub    $0x14,%rsp
  8029d3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8029d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8029dd:	eb 4e                	jmp    802a2d <ipc_find_env+0x62>
		if (envs[i].env_type == type)
  8029df:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8029e6:	00 00 00 
  8029e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029ec:	48 98                	cltq   
  8029ee:	48 69 c0 70 01 00 00 	imul   $0x170,%rax,%rax
  8029f5:	48 01 d0             	add    %rdx,%rax
  8029f8:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8029fe:	8b 00                	mov    (%rax),%eax
  802a00:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802a03:	75 24                	jne    802a29 <ipc_find_env+0x5e>
			return envs[i].env_id;
  802a05:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802a0c:	00 00 00 
  802a0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a12:	48 98                	cltq   
  802a14:	48 69 c0 70 01 00 00 	imul   $0x170,%rax,%rax
  802a1b:	48 01 d0             	add    %rdx,%rax
  802a1e:	48 05 c0 00 00 00    	add    $0xc0,%rax
  802a24:	8b 40 08             	mov    0x8(%rax),%eax
  802a27:	eb 12                	jmp    802a3b <ipc_find_env+0x70>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  802a29:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802a2d:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802a34:	7e a9                	jle    8029df <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;

	}
	return 0;
  802a36:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a3b:	c9                   	leaveq 
  802a3c:	c3                   	retq   

0000000000802a3d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802a3d:	55                   	push   %rbp
  802a3e:	48 89 e5             	mov    %rsp,%rbp
  802a41:	48 83 ec 08          	sub    $0x8,%rsp
  802a45:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802a49:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802a4d:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802a54:	ff ff ff 
  802a57:	48 01 d0             	add    %rdx,%rax
  802a5a:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802a5e:	c9                   	leaveq 
  802a5f:	c3                   	retq   

0000000000802a60 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802a60:	55                   	push   %rbp
  802a61:	48 89 e5             	mov    %rsp,%rbp
  802a64:	48 83 ec 08          	sub    $0x8,%rsp
  802a68:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802a6c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a70:	48 89 c7             	mov    %rax,%rdi
  802a73:	48 b8 3d 2a 80 00 00 	movabs $0x802a3d,%rax
  802a7a:	00 00 00 
  802a7d:	ff d0                	callq  *%rax
  802a7f:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802a85:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802a89:	c9                   	leaveq 
  802a8a:	c3                   	retq   

0000000000802a8b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802a8b:	55                   	push   %rbp
  802a8c:	48 89 e5             	mov    %rsp,%rbp
  802a8f:	48 83 ec 18          	sub    $0x18,%rsp
  802a93:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802a97:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a9e:	eb 6b                	jmp    802b0b <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802aa0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aa3:	48 98                	cltq   
  802aa5:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802aab:	48 c1 e0 0c          	shl    $0xc,%rax
  802aaf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802ab3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ab7:	48 c1 e8 15          	shr    $0x15,%rax
  802abb:	48 89 c2             	mov    %rax,%rdx
  802abe:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802ac5:	01 00 00 
  802ac8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802acc:	83 e0 01             	and    $0x1,%eax
  802acf:	48 85 c0             	test   %rax,%rax
  802ad2:	74 21                	je     802af5 <fd_alloc+0x6a>
  802ad4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ad8:	48 c1 e8 0c          	shr    $0xc,%rax
  802adc:	48 89 c2             	mov    %rax,%rdx
  802adf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802ae6:	01 00 00 
  802ae9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802aed:	83 e0 01             	and    $0x1,%eax
  802af0:	48 85 c0             	test   %rax,%rax
  802af3:	75 12                	jne    802b07 <fd_alloc+0x7c>
			*fd_store = fd;
  802af5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802af9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802afd:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802b00:	b8 00 00 00 00       	mov    $0x0,%eax
  802b05:	eb 1a                	jmp    802b21 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802b07:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802b0b:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802b0f:	7e 8f                	jle    802aa0 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802b11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b15:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802b1c:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802b21:	c9                   	leaveq 
  802b22:	c3                   	retq   

0000000000802b23 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802b23:	55                   	push   %rbp
  802b24:	48 89 e5             	mov    %rsp,%rbp
  802b27:	48 83 ec 20          	sub    $0x20,%rsp
  802b2b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b2e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802b32:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802b36:	78 06                	js     802b3e <fd_lookup+0x1b>
  802b38:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802b3c:	7e 07                	jle    802b45 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802b3e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b43:	eb 6c                	jmp    802bb1 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802b45:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b48:	48 98                	cltq   
  802b4a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802b50:	48 c1 e0 0c          	shl    $0xc,%rax
  802b54:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802b58:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b5c:	48 c1 e8 15          	shr    $0x15,%rax
  802b60:	48 89 c2             	mov    %rax,%rdx
  802b63:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802b6a:	01 00 00 
  802b6d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b71:	83 e0 01             	and    $0x1,%eax
  802b74:	48 85 c0             	test   %rax,%rax
  802b77:	74 21                	je     802b9a <fd_lookup+0x77>
  802b79:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b7d:	48 c1 e8 0c          	shr    $0xc,%rax
  802b81:	48 89 c2             	mov    %rax,%rdx
  802b84:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b8b:	01 00 00 
  802b8e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b92:	83 e0 01             	and    $0x1,%eax
  802b95:	48 85 c0             	test   %rax,%rax
  802b98:	75 07                	jne    802ba1 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802b9a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b9f:	eb 10                	jmp    802bb1 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802ba1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ba5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802ba9:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802bac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bb1:	c9                   	leaveq 
  802bb2:	c3                   	retq   

0000000000802bb3 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802bb3:	55                   	push   %rbp
  802bb4:	48 89 e5             	mov    %rsp,%rbp
  802bb7:	48 83 ec 30          	sub    $0x30,%rsp
  802bbb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802bbf:	89 f0                	mov    %esi,%eax
  802bc1:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802bc4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bc8:	48 89 c7             	mov    %rax,%rdi
  802bcb:	48 b8 3d 2a 80 00 00 	movabs $0x802a3d,%rax
  802bd2:	00 00 00 
  802bd5:	ff d0                	callq  *%rax
  802bd7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802bdb:	48 89 d6             	mov    %rdx,%rsi
  802bde:	89 c7                	mov    %eax,%edi
  802be0:	48 b8 23 2b 80 00 00 	movabs $0x802b23,%rax
  802be7:	00 00 00 
  802bea:	ff d0                	callq  *%rax
  802bec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bf3:	78 0a                	js     802bff <fd_close+0x4c>
	    || fd != fd2)
  802bf5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bf9:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802bfd:	74 12                	je     802c11 <fd_close+0x5e>
		return (must_exist ? r : 0);
  802bff:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802c03:	74 05                	je     802c0a <fd_close+0x57>
  802c05:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c08:	eb 05                	jmp    802c0f <fd_close+0x5c>
  802c0a:	b8 00 00 00 00       	mov    $0x0,%eax
  802c0f:	eb 69                	jmp    802c7a <fd_close+0xc7>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802c11:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c15:	8b 00                	mov    (%rax),%eax
  802c17:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c1b:	48 89 d6             	mov    %rdx,%rsi
  802c1e:	89 c7                	mov    %eax,%edi
  802c20:	48 b8 7c 2c 80 00 00 	movabs $0x802c7c,%rax
  802c27:	00 00 00 
  802c2a:	ff d0                	callq  *%rax
  802c2c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c2f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c33:	78 2a                	js     802c5f <fd_close+0xac>
		if (dev->dev_close)
  802c35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c39:	48 8b 40 20          	mov    0x20(%rax),%rax
  802c3d:	48 85 c0             	test   %rax,%rax
  802c40:	74 16                	je     802c58 <fd_close+0xa5>
			r = (*dev->dev_close)(fd);
  802c42:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c46:	48 8b 40 20          	mov    0x20(%rax),%rax
  802c4a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802c4e:	48 89 d7             	mov    %rdx,%rdi
  802c51:	ff d0                	callq  *%rax
  802c53:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c56:	eb 07                	jmp    802c5f <fd_close+0xac>
		else
			r = 0;
  802c58:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802c5f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c63:	48 89 c6             	mov    %rax,%rsi
  802c66:	bf 00 00 00 00       	mov    $0x0,%edi
  802c6b:	48 b8 29 25 80 00 00 	movabs $0x802529,%rax
  802c72:	00 00 00 
  802c75:	ff d0                	callq  *%rax
	return r;
  802c77:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c7a:	c9                   	leaveq 
  802c7b:	c3                   	retq   

0000000000802c7c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802c7c:	55                   	push   %rbp
  802c7d:	48 89 e5             	mov    %rsp,%rbp
  802c80:	48 83 ec 20          	sub    $0x20,%rsp
  802c84:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c87:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802c8b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802c92:	eb 41                	jmp    802cd5 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802c94:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802c9b:	00 00 00 
  802c9e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802ca1:	48 63 d2             	movslq %edx,%rdx
  802ca4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ca8:	8b 00                	mov    (%rax),%eax
  802caa:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802cad:	75 22                	jne    802cd1 <dev_lookup+0x55>
			*dev = devtab[i];
  802caf:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802cb6:	00 00 00 
  802cb9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802cbc:	48 63 d2             	movslq %edx,%rdx
  802cbf:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802cc3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cc7:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802cca:	b8 00 00 00 00       	mov    $0x0,%eax
  802ccf:	eb 60                	jmp    802d31 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802cd1:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802cd5:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  802cdc:	00 00 00 
  802cdf:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802ce2:	48 63 d2             	movslq %edx,%rdx
  802ce5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ce9:	48 85 c0             	test   %rax,%rax
  802cec:	75 a6                	jne    802c94 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802cee:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802cf5:	00 00 00 
  802cf8:	48 8b 00             	mov    (%rax),%rax
  802cfb:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d01:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802d04:	89 c6                	mov    %eax,%esi
  802d06:	48 bf c0 4c 80 00 00 	movabs $0x804cc0,%rdi
  802d0d:	00 00 00 
  802d10:	b8 00 00 00 00       	mov    $0x0,%eax
  802d15:	48 b9 59 0f 80 00 00 	movabs $0x800f59,%rcx
  802d1c:	00 00 00 
  802d1f:	ff d1                	callq  *%rcx
	*dev = 0;
  802d21:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d25:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802d2c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802d31:	c9                   	leaveq 
  802d32:	c3                   	retq   

0000000000802d33 <close>:

int
close(int fdnum)
{
  802d33:	55                   	push   %rbp
  802d34:	48 89 e5             	mov    %rsp,%rbp
  802d37:	48 83 ec 20          	sub    $0x20,%rsp
  802d3b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802d3e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d42:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d45:	48 89 d6             	mov    %rdx,%rsi
  802d48:	89 c7                	mov    %eax,%edi
  802d4a:	48 b8 23 2b 80 00 00 	movabs $0x802b23,%rax
  802d51:	00 00 00 
  802d54:	ff d0                	callq  *%rax
  802d56:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d59:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d5d:	79 05                	jns    802d64 <close+0x31>
		return r;
  802d5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d62:	eb 18                	jmp    802d7c <close+0x49>
	else
		return fd_close(fd, 1);
  802d64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d68:	be 01 00 00 00       	mov    $0x1,%esi
  802d6d:	48 89 c7             	mov    %rax,%rdi
  802d70:	48 b8 b3 2b 80 00 00 	movabs $0x802bb3,%rax
  802d77:	00 00 00 
  802d7a:	ff d0                	callq  *%rax
}
  802d7c:	c9                   	leaveq 
  802d7d:	c3                   	retq   

0000000000802d7e <close_all>:

void
close_all(void)
{
  802d7e:	55                   	push   %rbp
  802d7f:	48 89 e5             	mov    %rsp,%rbp
  802d82:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802d86:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802d8d:	eb 15                	jmp    802da4 <close_all+0x26>
		close(i);
  802d8f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d92:	89 c7                	mov    %eax,%edi
  802d94:	48 b8 33 2d 80 00 00 	movabs $0x802d33,%rax
  802d9b:	00 00 00 
  802d9e:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802da0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802da4:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802da8:	7e e5                	jle    802d8f <close_all+0x11>
		close(i);
}
  802daa:	c9                   	leaveq 
  802dab:	c3                   	retq   

0000000000802dac <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802dac:	55                   	push   %rbp
  802dad:	48 89 e5             	mov    %rsp,%rbp
  802db0:	48 83 ec 40          	sub    $0x40,%rsp
  802db4:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802db7:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802dba:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802dbe:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802dc1:	48 89 d6             	mov    %rdx,%rsi
  802dc4:	89 c7                	mov    %eax,%edi
  802dc6:	48 b8 23 2b 80 00 00 	movabs $0x802b23,%rax
  802dcd:	00 00 00 
  802dd0:	ff d0                	callq  *%rax
  802dd2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dd5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dd9:	79 08                	jns    802de3 <dup+0x37>
		return r;
  802ddb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dde:	e9 70 01 00 00       	jmpq   802f53 <dup+0x1a7>
	close(newfdnum);
  802de3:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802de6:	89 c7                	mov    %eax,%edi
  802de8:	48 b8 33 2d 80 00 00 	movabs $0x802d33,%rax
  802def:	00 00 00 
  802df2:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802df4:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802df7:	48 98                	cltq   
  802df9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802dff:	48 c1 e0 0c          	shl    $0xc,%rax
  802e03:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802e07:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e0b:	48 89 c7             	mov    %rax,%rdi
  802e0e:	48 b8 60 2a 80 00 00 	movabs $0x802a60,%rax
  802e15:	00 00 00 
  802e18:	ff d0                	callq  *%rax
  802e1a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802e1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e22:	48 89 c7             	mov    %rax,%rdi
  802e25:	48 b8 60 2a 80 00 00 	movabs $0x802a60,%rax
  802e2c:	00 00 00 
  802e2f:	ff d0                	callq  *%rax
  802e31:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802e35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e39:	48 c1 e8 15          	shr    $0x15,%rax
  802e3d:	48 89 c2             	mov    %rax,%rdx
  802e40:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802e47:	01 00 00 
  802e4a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e4e:	83 e0 01             	and    $0x1,%eax
  802e51:	48 85 c0             	test   %rax,%rax
  802e54:	74 73                	je     802ec9 <dup+0x11d>
  802e56:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e5a:	48 c1 e8 0c          	shr    $0xc,%rax
  802e5e:	48 89 c2             	mov    %rax,%rdx
  802e61:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802e68:	01 00 00 
  802e6b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e6f:	83 e0 01             	and    $0x1,%eax
  802e72:	48 85 c0             	test   %rax,%rax
  802e75:	74 52                	je     802ec9 <dup+0x11d>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802e77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e7b:	48 c1 e8 0c          	shr    $0xc,%rax
  802e7f:	48 89 c2             	mov    %rax,%rdx
  802e82:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802e89:	01 00 00 
  802e8c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e90:	25 07 0e 00 00       	and    $0xe07,%eax
  802e95:	89 c1                	mov    %eax,%ecx
  802e97:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802e9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e9f:	41 89 c8             	mov    %ecx,%r8d
  802ea2:	48 89 d1             	mov    %rdx,%rcx
  802ea5:	ba 00 00 00 00       	mov    $0x0,%edx
  802eaa:	48 89 c6             	mov    %rax,%rsi
  802ead:	bf 00 00 00 00       	mov    $0x0,%edi
  802eb2:	48 b8 ce 24 80 00 00 	movabs $0x8024ce,%rax
  802eb9:	00 00 00 
  802ebc:	ff d0                	callq  *%rax
  802ebe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ec1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ec5:	79 02                	jns    802ec9 <dup+0x11d>
			goto err;
  802ec7:	eb 57                	jmp    802f20 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802ec9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ecd:	48 c1 e8 0c          	shr    $0xc,%rax
  802ed1:	48 89 c2             	mov    %rax,%rdx
  802ed4:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802edb:	01 00 00 
  802ede:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ee2:	25 07 0e 00 00       	and    $0xe07,%eax
  802ee7:	89 c1                	mov    %eax,%ecx
  802ee9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802eed:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ef1:	41 89 c8             	mov    %ecx,%r8d
  802ef4:	48 89 d1             	mov    %rdx,%rcx
  802ef7:	ba 00 00 00 00       	mov    $0x0,%edx
  802efc:	48 89 c6             	mov    %rax,%rsi
  802eff:	bf 00 00 00 00       	mov    $0x0,%edi
  802f04:	48 b8 ce 24 80 00 00 	movabs $0x8024ce,%rax
  802f0b:	00 00 00 
  802f0e:	ff d0                	callq  *%rax
  802f10:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f13:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f17:	79 02                	jns    802f1b <dup+0x16f>
		goto err;
  802f19:	eb 05                	jmp    802f20 <dup+0x174>

	return newfdnum;
  802f1b:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802f1e:	eb 33                	jmp    802f53 <dup+0x1a7>

err:
	sys_page_unmap(0, newfd);
  802f20:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f24:	48 89 c6             	mov    %rax,%rsi
  802f27:	bf 00 00 00 00       	mov    $0x0,%edi
  802f2c:	48 b8 29 25 80 00 00 	movabs $0x802529,%rax
  802f33:	00 00 00 
  802f36:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802f38:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f3c:	48 89 c6             	mov    %rax,%rsi
  802f3f:	bf 00 00 00 00       	mov    $0x0,%edi
  802f44:	48 b8 29 25 80 00 00 	movabs $0x802529,%rax
  802f4b:	00 00 00 
  802f4e:	ff d0                	callq  *%rax
	return r;
  802f50:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802f53:	c9                   	leaveq 
  802f54:	c3                   	retq   

0000000000802f55 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802f55:	55                   	push   %rbp
  802f56:	48 89 e5             	mov    %rsp,%rbp
  802f59:	48 83 ec 40          	sub    $0x40,%rsp
  802f5d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802f60:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802f64:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802f68:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802f6c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f6f:	48 89 d6             	mov    %rdx,%rsi
  802f72:	89 c7                	mov    %eax,%edi
  802f74:	48 b8 23 2b 80 00 00 	movabs $0x802b23,%rax
  802f7b:	00 00 00 
  802f7e:	ff d0                	callq  *%rax
  802f80:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f83:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f87:	78 24                	js     802fad <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f89:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f8d:	8b 00                	mov    (%rax),%eax
  802f8f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f93:	48 89 d6             	mov    %rdx,%rsi
  802f96:	89 c7                	mov    %eax,%edi
  802f98:	48 b8 7c 2c 80 00 00 	movabs $0x802c7c,%rax
  802f9f:	00 00 00 
  802fa2:	ff d0                	callq  *%rax
  802fa4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fa7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fab:	79 05                	jns    802fb2 <read+0x5d>
		return r;
  802fad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fb0:	eb 76                	jmp    803028 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802fb2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fb6:	8b 40 08             	mov    0x8(%rax),%eax
  802fb9:	83 e0 03             	and    $0x3,%eax
  802fbc:	83 f8 01             	cmp    $0x1,%eax
  802fbf:	75 3a                	jne    802ffb <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802fc1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802fc8:	00 00 00 
  802fcb:	48 8b 00             	mov    (%rax),%rax
  802fce:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802fd4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802fd7:	89 c6                	mov    %eax,%esi
  802fd9:	48 bf df 4c 80 00 00 	movabs $0x804cdf,%rdi
  802fe0:	00 00 00 
  802fe3:	b8 00 00 00 00       	mov    $0x0,%eax
  802fe8:	48 b9 59 0f 80 00 00 	movabs $0x800f59,%rcx
  802fef:	00 00 00 
  802ff2:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802ff4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ff9:	eb 2d                	jmp    803028 <read+0xd3>
	}
	if (!dev->dev_read)
  802ffb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fff:	48 8b 40 10          	mov    0x10(%rax),%rax
  803003:	48 85 c0             	test   %rax,%rax
  803006:	75 07                	jne    80300f <read+0xba>
		return -E_NOT_SUPP;
  803008:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80300d:	eb 19                	jmp    803028 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80300f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803013:	48 8b 40 10          	mov    0x10(%rax),%rax
  803017:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80301b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80301f:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803023:	48 89 cf             	mov    %rcx,%rdi
  803026:	ff d0                	callq  *%rax
}
  803028:	c9                   	leaveq 
  803029:	c3                   	retq   

000000000080302a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80302a:	55                   	push   %rbp
  80302b:	48 89 e5             	mov    %rsp,%rbp
  80302e:	48 83 ec 30          	sub    $0x30,%rsp
  803032:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803035:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803039:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80303d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803044:	eb 49                	jmp    80308f <readn+0x65>
		m = read(fdnum, (char*)buf + tot, n - tot);
  803046:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803049:	48 98                	cltq   
  80304b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80304f:	48 29 c2             	sub    %rax,%rdx
  803052:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803055:	48 63 c8             	movslq %eax,%rcx
  803058:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80305c:	48 01 c1             	add    %rax,%rcx
  80305f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803062:	48 89 ce             	mov    %rcx,%rsi
  803065:	89 c7                	mov    %eax,%edi
  803067:	48 b8 55 2f 80 00 00 	movabs $0x802f55,%rax
  80306e:	00 00 00 
  803071:	ff d0                	callq  *%rax
  803073:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  803076:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80307a:	79 05                	jns    803081 <readn+0x57>
			return m;
  80307c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80307f:	eb 1c                	jmp    80309d <readn+0x73>
		if (m == 0)
  803081:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803085:	75 02                	jne    803089 <readn+0x5f>
			break;
  803087:	eb 11                	jmp    80309a <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803089:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80308c:	01 45 fc             	add    %eax,-0x4(%rbp)
  80308f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803092:	48 98                	cltq   
  803094:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803098:	72 ac                	jb     803046 <readn+0x1c>
		if (m < 0)
			return m;
		if (m == 0)
			break;
	}
	return tot;
  80309a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80309d:	c9                   	leaveq 
  80309e:	c3                   	retq   

000000000080309f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80309f:	55                   	push   %rbp
  8030a0:	48 89 e5             	mov    %rsp,%rbp
  8030a3:	48 83 ec 40          	sub    $0x40,%rsp
  8030a7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8030aa:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8030ae:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8030b2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8030b6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8030b9:	48 89 d6             	mov    %rdx,%rsi
  8030bc:	89 c7                	mov    %eax,%edi
  8030be:	48 b8 23 2b 80 00 00 	movabs $0x802b23,%rax
  8030c5:	00 00 00 
  8030c8:	ff d0                	callq  *%rax
  8030ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030d1:	78 24                	js     8030f7 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8030d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030d7:	8b 00                	mov    (%rax),%eax
  8030d9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8030dd:	48 89 d6             	mov    %rdx,%rsi
  8030e0:	89 c7                	mov    %eax,%edi
  8030e2:	48 b8 7c 2c 80 00 00 	movabs $0x802c7c,%rax
  8030e9:	00 00 00 
  8030ec:	ff d0                	callq  *%rax
  8030ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030f5:	79 05                	jns    8030fc <write+0x5d>
		return r;
  8030f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030fa:	eb 75                	jmp    803171 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8030fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803100:	8b 40 08             	mov    0x8(%rax),%eax
  803103:	83 e0 03             	and    $0x3,%eax
  803106:	85 c0                	test   %eax,%eax
  803108:	75 3a                	jne    803144 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80310a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803111:	00 00 00 
  803114:	48 8b 00             	mov    (%rax),%rax
  803117:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80311d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803120:	89 c6                	mov    %eax,%esi
  803122:	48 bf fb 4c 80 00 00 	movabs $0x804cfb,%rdi
  803129:	00 00 00 
  80312c:	b8 00 00 00 00       	mov    $0x0,%eax
  803131:	48 b9 59 0f 80 00 00 	movabs $0x800f59,%rcx
  803138:	00 00 00 
  80313b:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80313d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803142:	eb 2d                	jmp    803171 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  803144:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803148:	48 8b 40 18          	mov    0x18(%rax),%rax
  80314c:	48 85 c0             	test   %rax,%rax
  80314f:	75 07                	jne    803158 <write+0xb9>
		return -E_NOT_SUPP;
  803151:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803156:	eb 19                	jmp    803171 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  803158:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80315c:	48 8b 40 18          	mov    0x18(%rax),%rax
  803160:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803164:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803168:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80316c:	48 89 cf             	mov    %rcx,%rdi
  80316f:	ff d0                	callq  *%rax
}
  803171:	c9                   	leaveq 
  803172:	c3                   	retq   

0000000000803173 <seek>:

int
seek(int fdnum, off_t offset)
{
  803173:	55                   	push   %rbp
  803174:	48 89 e5             	mov    %rsp,%rbp
  803177:	48 83 ec 18          	sub    $0x18,%rsp
  80317b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80317e:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803181:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803185:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803188:	48 89 d6             	mov    %rdx,%rsi
  80318b:	89 c7                	mov    %eax,%edi
  80318d:	48 b8 23 2b 80 00 00 	movabs $0x802b23,%rax
  803194:	00 00 00 
  803197:	ff d0                	callq  *%rax
  803199:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80319c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031a0:	79 05                	jns    8031a7 <seek+0x34>
		return r;
  8031a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031a5:	eb 0f                	jmp    8031b6 <seek+0x43>
	fd->fd_offset = offset;
  8031a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031ab:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8031ae:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8031b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031b6:	c9                   	leaveq 
  8031b7:	c3                   	retq   

00000000008031b8 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8031b8:	55                   	push   %rbp
  8031b9:	48 89 e5             	mov    %rsp,%rbp
  8031bc:	48 83 ec 30          	sub    $0x30,%rsp
  8031c0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8031c3:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8031c6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8031ca:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8031cd:	48 89 d6             	mov    %rdx,%rsi
  8031d0:	89 c7                	mov    %eax,%edi
  8031d2:	48 b8 23 2b 80 00 00 	movabs $0x802b23,%rax
  8031d9:	00 00 00 
  8031dc:	ff d0                	callq  *%rax
  8031de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031e5:	78 24                	js     80320b <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8031e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031eb:	8b 00                	mov    (%rax),%eax
  8031ed:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8031f1:	48 89 d6             	mov    %rdx,%rsi
  8031f4:	89 c7                	mov    %eax,%edi
  8031f6:	48 b8 7c 2c 80 00 00 	movabs $0x802c7c,%rax
  8031fd:	00 00 00 
  803200:	ff d0                	callq  *%rax
  803202:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803205:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803209:	79 05                	jns    803210 <ftruncate+0x58>
		return r;
  80320b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80320e:	eb 72                	jmp    803282 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803210:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803214:	8b 40 08             	mov    0x8(%rax),%eax
  803217:	83 e0 03             	and    $0x3,%eax
  80321a:	85 c0                	test   %eax,%eax
  80321c:	75 3a                	jne    803258 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80321e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803225:	00 00 00 
  803228:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80322b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803231:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803234:	89 c6                	mov    %eax,%esi
  803236:	48 bf 18 4d 80 00 00 	movabs $0x804d18,%rdi
  80323d:	00 00 00 
  803240:	b8 00 00 00 00       	mov    $0x0,%eax
  803245:	48 b9 59 0f 80 00 00 	movabs $0x800f59,%rcx
  80324c:	00 00 00 
  80324f:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  803251:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803256:	eb 2a                	jmp    803282 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  803258:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80325c:	48 8b 40 30          	mov    0x30(%rax),%rax
  803260:	48 85 c0             	test   %rax,%rax
  803263:	75 07                	jne    80326c <ftruncate+0xb4>
		return -E_NOT_SUPP;
  803265:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80326a:	eb 16                	jmp    803282 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80326c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803270:	48 8b 40 30          	mov    0x30(%rax),%rax
  803274:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803278:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80327b:	89 ce                	mov    %ecx,%esi
  80327d:	48 89 d7             	mov    %rdx,%rdi
  803280:	ff d0                	callq  *%rax
}
  803282:	c9                   	leaveq 
  803283:	c3                   	retq   

0000000000803284 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  803284:	55                   	push   %rbp
  803285:	48 89 e5             	mov    %rsp,%rbp
  803288:	48 83 ec 30          	sub    $0x30,%rsp
  80328c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80328f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803293:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803297:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80329a:	48 89 d6             	mov    %rdx,%rsi
  80329d:	89 c7                	mov    %eax,%edi
  80329f:	48 b8 23 2b 80 00 00 	movabs $0x802b23,%rax
  8032a6:	00 00 00 
  8032a9:	ff d0                	callq  *%rax
  8032ab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032b2:	78 24                	js     8032d8 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8032b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032b8:	8b 00                	mov    (%rax),%eax
  8032ba:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8032be:	48 89 d6             	mov    %rdx,%rsi
  8032c1:	89 c7                	mov    %eax,%edi
  8032c3:	48 b8 7c 2c 80 00 00 	movabs $0x802c7c,%rax
  8032ca:	00 00 00 
  8032cd:	ff d0                	callq  *%rax
  8032cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032d6:	79 05                	jns    8032dd <fstat+0x59>
		return r;
  8032d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032db:	eb 5e                	jmp    80333b <fstat+0xb7>
	if (!dev->dev_stat)
  8032dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032e1:	48 8b 40 28          	mov    0x28(%rax),%rax
  8032e5:	48 85 c0             	test   %rax,%rax
  8032e8:	75 07                	jne    8032f1 <fstat+0x6d>
		return -E_NOT_SUPP;
  8032ea:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8032ef:	eb 4a                	jmp    80333b <fstat+0xb7>
	stat->st_name[0] = 0;
  8032f1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032f5:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8032f8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032fc:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  803303:	00 00 00 
	stat->st_isdir = 0;
  803306:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80330a:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803311:	00 00 00 
	stat->st_dev = dev;
  803314:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803318:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80331c:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  803323:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803327:	48 8b 40 28          	mov    0x28(%rax),%rax
  80332b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80332f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803333:	48 89 ce             	mov    %rcx,%rsi
  803336:	48 89 d7             	mov    %rdx,%rdi
  803339:	ff d0                	callq  *%rax
}
  80333b:	c9                   	leaveq 
  80333c:	c3                   	retq   

000000000080333d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80333d:	55                   	push   %rbp
  80333e:	48 89 e5             	mov    %rsp,%rbp
  803341:	48 83 ec 20          	sub    $0x20,%rsp
  803345:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803349:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80334d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803351:	be 00 00 00 00       	mov    $0x0,%esi
  803356:	48 89 c7             	mov    %rax,%rdi
  803359:	48 b8 2b 34 80 00 00 	movabs $0x80342b,%rax
  803360:	00 00 00 
  803363:	ff d0                	callq  *%rax
  803365:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803368:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80336c:	79 05                	jns    803373 <stat+0x36>
		return fd;
  80336e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803371:	eb 2f                	jmp    8033a2 <stat+0x65>
	r = fstat(fd, stat);
  803373:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803377:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80337a:	48 89 d6             	mov    %rdx,%rsi
  80337d:	89 c7                	mov    %eax,%edi
  80337f:	48 b8 84 32 80 00 00 	movabs $0x803284,%rax
  803386:	00 00 00 
  803389:	ff d0                	callq  *%rax
  80338b:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80338e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803391:	89 c7                	mov    %eax,%edi
  803393:	48 b8 33 2d 80 00 00 	movabs $0x802d33,%rax
  80339a:	00 00 00 
  80339d:	ff d0                	callq  *%rax
	return r;
  80339f:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8033a2:	c9                   	leaveq 
  8033a3:	c3                   	retq   

00000000008033a4 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8033a4:	55                   	push   %rbp
  8033a5:	48 89 e5             	mov    %rsp,%rbp
  8033a8:	48 83 ec 10          	sub    $0x10,%rsp
  8033ac:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8033af:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8033b3:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8033ba:	00 00 00 
  8033bd:	8b 00                	mov    (%rax),%eax
  8033bf:	85 c0                	test   %eax,%eax
  8033c1:	75 1d                	jne    8033e0 <fsipc+0x3c>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8033c3:	bf 01 00 00 00       	mov    $0x1,%edi
  8033c8:	48 b8 cb 29 80 00 00 	movabs $0x8029cb,%rax
  8033cf:	00 00 00 
  8033d2:	ff d0                	callq  *%rax
  8033d4:	48 ba 00 70 80 00 00 	movabs $0x807000,%rdx
  8033db:	00 00 00 
  8033de:	89 02                	mov    %eax,(%rdx)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8033e0:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8033e7:	00 00 00 
  8033ea:	8b 00                	mov    (%rax),%eax
  8033ec:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8033ef:	b9 07 00 00 00       	mov    $0x7,%ecx
  8033f4:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8033fb:	00 00 00 
  8033fe:	89 c7                	mov    %eax,%edi
  803400:	48 b8 cc 28 80 00 00 	movabs $0x8028cc,%rax
  803407:	00 00 00 
  80340a:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80340c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803410:	ba 00 00 00 00       	mov    $0x0,%edx
  803415:	48 89 c6             	mov    %rax,%rsi
  803418:	bf 00 00 00 00       	mov    $0x0,%edi
  80341d:	48 b8 19 28 80 00 00 	movabs $0x802819,%rax
  803424:	00 00 00 
  803427:	ff d0                	callq  *%rax
}
  803429:	c9                   	leaveq 
  80342a:	c3                   	retq   

000000000080342b <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80342b:	55                   	push   %rbp
  80342c:	48 89 e5             	mov    %rsp,%rbp
  80342f:	48 83 ec 20          	sub    $0x20,%rsp
  803433:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803437:	89 75 e4             	mov    %esi,-0x1c(%rbp)

	// LAB 5: Your code here

	struct Fd *fd;
	int ret;
	if (strlen(path)>=MAXPATHLEN)
  80343a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80343e:	48 89 c7             	mov    %rax,%rdi
  803441:	48 b8 e3 1a 80 00 00 	movabs $0x801ae3,%rax
  803448:	00 00 00 
  80344b:	ff d0                	callq  *%rax
  80344d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803452:	7e 0a                	jle    80345e <open+0x33>
		return -E_BAD_PATH;
  803454:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803459:	e9 a5 00 00 00       	jmpq   803503 <open+0xd8>
	if ((ret=fd_alloc(&fd))<0)
  80345e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803462:	48 89 c7             	mov    %rax,%rdi
  803465:	48 b8 8b 2a 80 00 00 	movabs $0x802a8b,%rax
  80346c:	00 00 00 
  80346f:	ff d0                	callq  *%rax
  803471:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803474:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803478:	79 08                	jns    803482 <open+0x57>
		return ret;
  80347a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80347d:	e9 81 00 00 00       	jmpq   803503 <open+0xd8>
	fsipcbuf.open.req_omode = mode;
  803482:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803489:	00 00 00 
  80348c:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80348f:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)
	strcpy (fsipcbuf.open.req_path, path);
  803495:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803499:	48 89 c6             	mov    %rax,%rsi
  80349c:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  8034a3:	00 00 00 
  8034a6:	48 b8 4f 1b 80 00 00 	movabs $0x801b4f,%rax
  8034ad:	00 00 00 
  8034b0:	ff d0                	callq  *%rax
	if ((ret=fsipc (FSREQ_OPEN, (void *) fd)) < 0)
  8034b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034b6:	48 89 c6             	mov    %rax,%rsi
  8034b9:	bf 01 00 00 00       	mov    $0x1,%edi
  8034be:	48 b8 a4 33 80 00 00 	movabs $0x8033a4,%rax
  8034c5:	00 00 00 
  8034c8:	ff d0                	callq  *%rax
  8034ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034d1:	79 1d                	jns    8034f0 <open+0xc5>
	{
		fd_close(fd,0);
  8034d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034d7:	be 00 00 00 00       	mov    $0x0,%esi
  8034dc:	48 89 c7             	mov    %rax,%rdi
  8034df:	48 b8 b3 2b 80 00 00 	movabs $0x802bb3,%rax
  8034e6:	00 00 00 
  8034e9:	ff d0                	callq  *%rax
		return ret;
  8034eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034ee:	eb 13                	jmp    803503 <open+0xd8>
	}
	return fd2num (fd);
  8034f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034f4:	48 89 c7             	mov    %rax,%rdi
  8034f7:	48 b8 3d 2a 80 00 00 	movabs $0x802a3d,%rax
  8034fe:	00 00 00 
  803501:	ff d0                	callq  *%rax
	panic ("open not implemented");
}
  803503:	c9                   	leaveq 
  803504:	c3                   	retq   

0000000000803505 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  803505:	55                   	push   %rbp
  803506:	48 89 e5             	mov    %rsp,%rbp
  803509:	48 83 ec 10          	sub    $0x10,%rsp
  80350d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803511:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803515:	8b 50 0c             	mov    0xc(%rax),%edx
  803518:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80351f:	00 00 00 
  803522:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  803524:	be 00 00 00 00       	mov    $0x0,%esi
  803529:	bf 06 00 00 00       	mov    $0x6,%edi
  80352e:	48 b8 a4 33 80 00 00 	movabs $0x8033a4,%rax
  803535:	00 00 00 
  803538:	ff d0                	callq  *%rax
}
  80353a:	c9                   	leaveq 
  80353b:	c3                   	retq   

000000000080353c <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80353c:	55                   	push   %rbp
  80353d:	48 89 e5             	mov    %rsp,%rbp
  803540:	48 83 ec 30          	sub    $0x30,%rsp
  803544:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803548:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80354c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
	int ret;
	fsipcbuf.read.req_fileid=fd->fd_file.id;
  803550:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803554:	8b 50 0c             	mov    0xc(%rax),%edx
  803557:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80355e:	00 00 00 
  803561:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n=n;
  803563:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80356a:	00 00 00 
  80356d:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803571:	48 89 50 08          	mov    %rdx,0x8(%rax)
	
	if ((ret=fsipc(FSREQ_READ,NULL))<0)
  803575:	be 00 00 00 00       	mov    $0x0,%esi
  80357a:	bf 03 00 00 00       	mov    $0x3,%edi
  80357f:	48 b8 a4 33 80 00 00 	movabs $0x8033a4,%rax
  803586:	00 00 00 
  803589:	ff d0                	callq  *%rax
  80358b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80358e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803592:	79 05                	jns    803599 <devfile_read+0x5d>
		return ret;
  803594:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803597:	eb 26                	jmp    8035bf <devfile_read+0x83>
	memmove (buf, fsipcbuf.readRet.ret_buf, ret);
  803599:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80359c:	48 63 d0             	movslq %eax,%rdx
  80359f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8035a3:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8035aa:	00 00 00 
  8035ad:	48 89 c7             	mov    %rax,%rdi
  8035b0:	48 b8 73 1e 80 00 00 	movabs $0x801e73,%rax
  8035b7:	00 00 00 
  8035ba:	ff d0                	callq  *%rax
	return ret;
  8035bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
	panic("devfile_read not implemented");
}
  8035bf:	c9                   	leaveq 
  8035c0:	c3                   	retq   

00000000008035c1 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8035c1:	55                   	push   %rbp
  8035c2:	48 89 e5             	mov    %rsp,%rbp
  8035c5:	48 83 ec 30          	sub    $0x30,%rsp
  8035c9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8035cd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8035d1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here

	int ret;
	fsipcbuf.write.req_fileid=fd->fd_file.id;
  8035d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035d9:	8b 50 0c             	mov    0xc(%rax),%edx
  8035dc:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8035e3:	00 00 00 
  8035e6:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n=n>sizeof(fsipcbuf.write.req_buf)?sizeof(fsipcbuf.write.req_buf):n;
  8035e8:	b8 f4 0f 00 00       	mov    $0xff4,%eax
  8035ed:	48 81 7d d8 f4 0f 00 	cmpq   $0xff4,-0x28(%rbp)
  8035f4:	00 
  8035f5:	48 0f 46 45 d8       	cmovbe -0x28(%rbp),%rax
  8035fa:	48 89 c2             	mov    %rax,%rdx
  8035fd:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803604:	00 00 00 
  803607:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove (fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  80360b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803612:	00 00 00 
  803615:	48 8b 50 08          	mov    0x8(%rax),%rdx
  803619:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80361d:	48 89 c6             	mov    %rax,%rsi
  803620:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  803627:	00 00 00 
  80362a:	48 b8 73 1e 80 00 00 	movabs $0x801e73,%rax
  803631:	00 00 00 
  803634:	ff d0                	callq  *%rax
	if ((ret=fsipc(FSREQ_WRITE,NULL))<0)
  803636:	be 00 00 00 00       	mov    $0x0,%esi
  80363b:	bf 04 00 00 00       	mov    $0x4,%edi
  803640:	48 b8 a4 33 80 00 00 	movabs $0x8033a4,%rax
  803647:	00 00 00 
  80364a:	ff d0                	callq  *%rax
  80364c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80364f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803653:	79 05                	jns    80365a <devfile_write+0x99>
		return ret;
  803655:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803658:	eb 03                	jmp    80365d <devfile_write+0x9c>
	
	return ret;
  80365a:	8b 45 fc             	mov    -0x4(%rbp),%eax


	panic("devfile_write not implemented");
}
  80365d:	c9                   	leaveq 
  80365e:	c3                   	retq   

000000000080365f <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80365f:	55                   	push   %rbp
  803660:	48 89 e5             	mov    %rsp,%rbp
  803663:	48 83 ec 20          	sub    $0x20,%rsp
  803667:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80366b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80366f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803673:	8b 50 0c             	mov    0xc(%rax),%edx
  803676:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80367d:	00 00 00 
  803680:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803682:	be 00 00 00 00       	mov    $0x0,%esi
  803687:	bf 05 00 00 00       	mov    $0x5,%edi
  80368c:	48 b8 a4 33 80 00 00 	movabs $0x8033a4,%rax
  803693:	00 00 00 
  803696:	ff d0                	callq  *%rax
  803698:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80369b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80369f:	79 05                	jns    8036a6 <devfile_stat+0x47>
		return r;
  8036a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036a4:	eb 56                	jmp    8036fc <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8036a6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036aa:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8036b1:	00 00 00 
  8036b4:	48 89 c7             	mov    %rax,%rdi
  8036b7:	48 b8 4f 1b 80 00 00 	movabs $0x801b4f,%rax
  8036be:	00 00 00 
  8036c1:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8036c3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8036ca:	00 00 00 
  8036cd:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8036d3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036d7:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8036dd:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8036e4:	00 00 00 
  8036e7:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8036ed:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036f1:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8036f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8036fc:	c9                   	leaveq 
  8036fd:	c3                   	retq   

00000000008036fe <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8036fe:	55                   	push   %rbp
  8036ff:	48 89 e5             	mov    %rsp,%rbp
  803702:	48 83 ec 10          	sub    $0x10,%rsp
  803706:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80370a:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80370d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803711:	8b 50 0c             	mov    0xc(%rax),%edx
  803714:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80371b:	00 00 00 
  80371e:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803720:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803727:	00 00 00 
  80372a:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80372d:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803730:	be 00 00 00 00       	mov    $0x0,%esi
  803735:	bf 02 00 00 00       	mov    $0x2,%edi
  80373a:	48 b8 a4 33 80 00 00 	movabs $0x8033a4,%rax
  803741:	00 00 00 
  803744:	ff d0                	callq  *%rax
}
  803746:	c9                   	leaveq 
  803747:	c3                   	retq   

0000000000803748 <remove>:

// Delete a file
int
remove(const char *path)
{
  803748:	55                   	push   %rbp
  803749:	48 89 e5             	mov    %rsp,%rbp
  80374c:	48 83 ec 10          	sub    $0x10,%rsp
  803750:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803754:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803758:	48 89 c7             	mov    %rax,%rdi
  80375b:	48 b8 e3 1a 80 00 00 	movabs $0x801ae3,%rax
  803762:	00 00 00 
  803765:	ff d0                	callq  *%rax
  803767:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80376c:	7e 07                	jle    803775 <remove+0x2d>
		return -E_BAD_PATH;
  80376e:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803773:	eb 33                	jmp    8037a8 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803775:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803779:	48 89 c6             	mov    %rax,%rsi
  80377c:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  803783:	00 00 00 
  803786:	48 b8 4f 1b 80 00 00 	movabs $0x801b4f,%rax
  80378d:	00 00 00 
  803790:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803792:	be 00 00 00 00       	mov    $0x0,%esi
  803797:	bf 07 00 00 00       	mov    $0x7,%edi
  80379c:	48 b8 a4 33 80 00 00 	movabs $0x8033a4,%rax
  8037a3:	00 00 00 
  8037a6:	ff d0                	callq  *%rax
}
  8037a8:	c9                   	leaveq 
  8037a9:	c3                   	retq   

00000000008037aa <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8037aa:	55                   	push   %rbp
  8037ab:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8037ae:	be 00 00 00 00       	mov    $0x0,%esi
  8037b3:	bf 08 00 00 00       	mov    $0x8,%edi
  8037b8:	48 b8 a4 33 80 00 00 	movabs $0x8033a4,%rax
  8037bf:	00 00 00 
  8037c2:	ff d0                	callq  *%rax
}
  8037c4:	5d                   	pop    %rbp
  8037c5:	c3                   	retq   

00000000008037c6 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8037c6:	55                   	push   %rbp
  8037c7:	48 89 e5             	mov    %rsp,%rbp
  8037ca:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8037d1:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8037d8:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8037df:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8037e6:	be 00 00 00 00       	mov    $0x0,%esi
  8037eb:	48 89 c7             	mov    %rax,%rdi
  8037ee:	48 b8 2b 34 80 00 00 	movabs $0x80342b,%rax
  8037f5:	00 00 00 
  8037f8:	ff d0                	callq  *%rax
  8037fa:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8037fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803801:	79 28                	jns    80382b <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803803:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803806:	89 c6                	mov    %eax,%esi
  803808:	48 bf 3e 4d 80 00 00 	movabs $0x804d3e,%rdi
  80380f:	00 00 00 
  803812:	b8 00 00 00 00       	mov    $0x0,%eax
  803817:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  80381e:	00 00 00 
  803821:	ff d2                	callq  *%rdx
		return fd_src;
  803823:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803826:	e9 74 01 00 00       	jmpq   80399f <copy+0x1d9>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80382b:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803832:	be 01 01 00 00       	mov    $0x101,%esi
  803837:	48 89 c7             	mov    %rax,%rdi
  80383a:	48 b8 2b 34 80 00 00 	movabs $0x80342b,%rax
  803841:	00 00 00 
  803844:	ff d0                	callq  *%rax
  803846:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803849:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80384d:	79 39                	jns    803888 <copy+0xc2>
		cprintf("cp create dest  error:%e\n", fd_dest);
  80384f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803852:	89 c6                	mov    %eax,%esi
  803854:	48 bf 54 4d 80 00 00 	movabs $0x804d54,%rdi
  80385b:	00 00 00 
  80385e:	b8 00 00 00 00       	mov    $0x0,%eax
  803863:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  80386a:	00 00 00 
  80386d:	ff d2                	callq  *%rdx
		close(fd_src);
  80386f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803872:	89 c7                	mov    %eax,%edi
  803874:	48 b8 33 2d 80 00 00 	movabs $0x802d33,%rax
  80387b:	00 00 00 
  80387e:	ff d0                	callq  *%rax
		return fd_dest;
  803880:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803883:	e9 17 01 00 00       	jmpq   80399f <copy+0x1d9>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803888:	eb 74                	jmp    8038fe <copy+0x138>
		write_size = write(fd_dest, buffer, read_size);
  80388a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80388d:	48 63 d0             	movslq %eax,%rdx
  803890:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803897:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80389a:	48 89 ce             	mov    %rcx,%rsi
  80389d:	89 c7                	mov    %eax,%edi
  80389f:	48 b8 9f 30 80 00 00 	movabs $0x80309f,%rax
  8038a6:	00 00 00 
  8038a9:	ff d0                	callq  *%rax
  8038ab:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8038ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8038b2:	79 4a                	jns    8038fe <copy+0x138>
			cprintf("cp write error:%e\n", write_size);
  8038b4:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8038b7:	89 c6                	mov    %eax,%esi
  8038b9:	48 bf 6e 4d 80 00 00 	movabs $0x804d6e,%rdi
  8038c0:	00 00 00 
  8038c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8038c8:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  8038cf:	00 00 00 
  8038d2:	ff d2                	callq  *%rdx
			close(fd_src);
  8038d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038d7:	89 c7                	mov    %eax,%edi
  8038d9:	48 b8 33 2d 80 00 00 	movabs $0x802d33,%rax
  8038e0:	00 00 00 
  8038e3:	ff d0                	callq  *%rax
			close(fd_dest);
  8038e5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8038e8:	89 c7                	mov    %eax,%edi
  8038ea:	48 b8 33 2d 80 00 00 	movabs $0x802d33,%rax
  8038f1:	00 00 00 
  8038f4:	ff d0                	callq  *%rax
			return write_size;
  8038f6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8038f9:	e9 a1 00 00 00       	jmpq   80399f <copy+0x1d9>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8038fe:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803905:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803908:	ba 00 02 00 00       	mov    $0x200,%edx
  80390d:	48 89 ce             	mov    %rcx,%rsi
  803910:	89 c7                	mov    %eax,%edi
  803912:	48 b8 55 2f 80 00 00 	movabs $0x802f55,%rax
  803919:	00 00 00 
  80391c:	ff d0                	callq  *%rax
  80391e:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803921:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803925:	0f 8f 5f ff ff ff    	jg     80388a <copy+0xc4>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  80392b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80392f:	79 47                	jns    803978 <copy+0x1b2>
		cprintf("cp read src error:%e\n", read_size);
  803931:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803934:	89 c6                	mov    %eax,%esi
  803936:	48 bf 81 4d 80 00 00 	movabs $0x804d81,%rdi
  80393d:	00 00 00 
  803940:	b8 00 00 00 00       	mov    $0x0,%eax
  803945:	48 ba 59 0f 80 00 00 	movabs $0x800f59,%rdx
  80394c:	00 00 00 
  80394f:	ff d2                	callq  *%rdx
		close(fd_src);
  803951:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803954:	89 c7                	mov    %eax,%edi
  803956:	48 b8 33 2d 80 00 00 	movabs $0x802d33,%rax
  80395d:	00 00 00 
  803960:	ff d0                	callq  *%rax
		close(fd_dest);
  803962:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803965:	89 c7                	mov    %eax,%edi
  803967:	48 b8 33 2d 80 00 00 	movabs $0x802d33,%rax
  80396e:	00 00 00 
  803971:	ff d0                	callq  *%rax
		return read_size;
  803973:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803976:	eb 27                	jmp    80399f <copy+0x1d9>
	}
	close(fd_src);
  803978:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80397b:	89 c7                	mov    %eax,%edi
  80397d:	48 b8 33 2d 80 00 00 	movabs $0x802d33,%rax
  803984:	00 00 00 
  803987:	ff d0                	callq  *%rax
	close(fd_dest);
  803989:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80398c:	89 c7                	mov    %eax,%edi
  80398e:	48 b8 33 2d 80 00 00 	movabs $0x802d33,%rax
  803995:	00 00 00 
  803998:	ff d0                	callq  *%rax
	return 0;
  80399a:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  80399f:	c9                   	leaveq 
  8039a0:	c3                   	retq   

00000000008039a1 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8039a1:	55                   	push   %rbp
  8039a2:	48 89 e5             	mov    %rsp,%rbp
  8039a5:	53                   	push   %rbx
  8039a6:	48 83 ec 38          	sub    $0x38,%rsp
  8039aa:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8039ae:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8039b2:	48 89 c7             	mov    %rax,%rdi
  8039b5:	48 b8 8b 2a 80 00 00 	movabs $0x802a8b,%rax
  8039bc:	00 00 00 
  8039bf:	ff d0                	callq  *%rax
  8039c1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8039c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8039c8:	0f 88 bf 01 00 00    	js     803b8d <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8039ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039d2:	ba 07 04 00 00       	mov    $0x407,%edx
  8039d7:	48 89 c6             	mov    %rax,%rsi
  8039da:	bf 00 00 00 00       	mov    $0x0,%edi
  8039df:	48 b8 7e 24 80 00 00 	movabs $0x80247e,%rax
  8039e6:	00 00 00 
  8039e9:	ff d0                	callq  *%rax
  8039eb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8039ee:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8039f2:	0f 88 95 01 00 00    	js     803b8d <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8039f8:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8039fc:	48 89 c7             	mov    %rax,%rdi
  8039ff:	48 b8 8b 2a 80 00 00 	movabs $0x802a8b,%rax
  803a06:	00 00 00 
  803a09:	ff d0                	callq  *%rax
  803a0b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a0e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a12:	0f 88 5d 01 00 00    	js     803b75 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a18:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a1c:	ba 07 04 00 00       	mov    $0x407,%edx
  803a21:	48 89 c6             	mov    %rax,%rsi
  803a24:	bf 00 00 00 00       	mov    $0x0,%edi
  803a29:	48 b8 7e 24 80 00 00 	movabs $0x80247e,%rax
  803a30:	00 00 00 
  803a33:	ff d0                	callq  *%rax
  803a35:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a38:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a3c:	0f 88 33 01 00 00    	js     803b75 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803a42:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a46:	48 89 c7             	mov    %rax,%rdi
  803a49:	48 b8 60 2a 80 00 00 	movabs $0x802a60,%rax
  803a50:	00 00 00 
  803a53:	ff d0                	callq  *%rax
  803a55:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a59:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a5d:	ba 07 04 00 00       	mov    $0x407,%edx
  803a62:	48 89 c6             	mov    %rax,%rsi
  803a65:	bf 00 00 00 00       	mov    $0x0,%edi
  803a6a:	48 b8 7e 24 80 00 00 	movabs $0x80247e,%rax
  803a71:	00 00 00 
  803a74:	ff d0                	callq  *%rax
  803a76:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803a79:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a7d:	79 05                	jns    803a84 <pipe+0xe3>
		goto err2;
  803a7f:	e9 d9 00 00 00       	jmpq   803b5d <pipe+0x1bc>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a84:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a88:	48 89 c7             	mov    %rax,%rdi
  803a8b:	48 b8 60 2a 80 00 00 	movabs $0x802a60,%rax
  803a92:	00 00 00 
  803a95:	ff d0                	callq  *%rax
  803a97:	48 89 c2             	mov    %rax,%rdx
  803a9a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a9e:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803aa4:	48 89 d1             	mov    %rdx,%rcx
  803aa7:	ba 00 00 00 00       	mov    $0x0,%edx
  803aac:	48 89 c6             	mov    %rax,%rsi
  803aaf:	bf 00 00 00 00       	mov    $0x0,%edi
  803ab4:	48 b8 ce 24 80 00 00 	movabs $0x8024ce,%rax
  803abb:	00 00 00 
  803abe:	ff d0                	callq  *%rax
  803ac0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803ac3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ac7:	79 1b                	jns    803ae4 <pipe+0x143>
		goto err3;
  803ac9:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803aca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ace:	48 89 c6             	mov    %rax,%rsi
  803ad1:	bf 00 00 00 00       	mov    $0x0,%edi
  803ad6:	48 b8 29 25 80 00 00 	movabs $0x802529,%rax
  803add:	00 00 00 
  803ae0:	ff d0                	callq  *%rax
  803ae2:	eb 79                	jmp    803b5d <pipe+0x1bc>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803ae4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ae8:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803aef:	00 00 00 
  803af2:	8b 12                	mov    (%rdx),%edx
  803af4:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803af6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803afa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803b01:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b05:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803b0c:	00 00 00 
  803b0f:	8b 12                	mov    (%rdx),%edx
  803b11:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803b13:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b17:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803b1e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b22:	48 89 c7             	mov    %rax,%rdi
  803b25:	48 b8 3d 2a 80 00 00 	movabs $0x802a3d,%rax
  803b2c:	00 00 00 
  803b2f:	ff d0                	callq  *%rax
  803b31:	89 c2                	mov    %eax,%edx
  803b33:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803b37:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803b39:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803b3d:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803b41:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b45:	48 89 c7             	mov    %rax,%rdi
  803b48:	48 b8 3d 2a 80 00 00 	movabs $0x802a3d,%rax
  803b4f:	00 00 00 
  803b52:	ff d0                	callq  *%rax
  803b54:	89 03                	mov    %eax,(%rbx)
	return 0;
  803b56:	b8 00 00 00 00       	mov    $0x0,%eax
  803b5b:	eb 33                	jmp    803b90 <pipe+0x1ef>

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803b5d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b61:	48 89 c6             	mov    %rax,%rsi
  803b64:	bf 00 00 00 00       	mov    $0x0,%edi
  803b69:	48 b8 29 25 80 00 00 	movabs $0x802529,%rax
  803b70:	00 00 00 
  803b73:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803b75:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b79:	48 89 c6             	mov    %rax,%rsi
  803b7c:	bf 00 00 00 00       	mov    $0x0,%edi
  803b81:	48 b8 29 25 80 00 00 	movabs $0x802529,%rax
  803b88:	00 00 00 
  803b8b:	ff d0                	callq  *%rax
err:
	return r;
  803b8d:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803b90:	48 83 c4 38          	add    $0x38,%rsp
  803b94:	5b                   	pop    %rbx
  803b95:	5d                   	pop    %rbp
  803b96:	c3                   	retq   

0000000000803b97 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803b97:	55                   	push   %rbp
  803b98:	48 89 e5             	mov    %rsp,%rbp
  803b9b:	53                   	push   %rbx
  803b9c:	48 83 ec 28          	sub    $0x28,%rsp
  803ba0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803ba4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803ba8:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803baf:	00 00 00 
  803bb2:	48 8b 00             	mov    (%rax),%rax
  803bb5:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803bbb:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803bbe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bc2:	48 89 c7             	mov    %rax,%rdi
  803bc5:	48 b8 1d 42 80 00 00 	movabs $0x80421d,%rax
  803bcc:	00 00 00 
  803bcf:	ff d0                	callq  *%rax
  803bd1:	89 c3                	mov    %eax,%ebx
  803bd3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bd7:	48 89 c7             	mov    %rax,%rdi
  803bda:	48 b8 1d 42 80 00 00 	movabs $0x80421d,%rax
  803be1:	00 00 00 
  803be4:	ff d0                	callq  *%rax
  803be6:	39 c3                	cmp    %eax,%ebx
  803be8:	0f 94 c0             	sete   %al
  803beb:	0f b6 c0             	movzbl %al,%eax
  803bee:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803bf1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803bf8:	00 00 00 
  803bfb:	48 8b 00             	mov    (%rax),%rax
  803bfe:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803c04:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803c07:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c0a:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803c0d:	75 05                	jne    803c14 <_pipeisclosed+0x7d>
			return ret;
  803c0f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803c12:	eb 4f                	jmp    803c63 <_pipeisclosed+0xcc>
		if (n != nn && ret == 1)
  803c14:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c17:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803c1a:	74 42                	je     803c5e <_pipeisclosed+0xc7>
  803c1c:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803c20:	75 3c                	jne    803c5e <_pipeisclosed+0xc7>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803c22:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803c29:	00 00 00 
  803c2c:	48 8b 00             	mov    (%rax),%rax
  803c2f:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803c35:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803c38:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c3b:	89 c6                	mov    %eax,%esi
  803c3d:	48 bf a1 4d 80 00 00 	movabs $0x804da1,%rdi
  803c44:	00 00 00 
  803c47:	b8 00 00 00 00       	mov    $0x0,%eax
  803c4c:	49 b8 59 0f 80 00 00 	movabs $0x800f59,%r8
  803c53:	00 00 00 
  803c56:	41 ff d0             	callq  *%r8
	}
  803c59:	e9 4a ff ff ff       	jmpq   803ba8 <_pipeisclosed+0x11>
  803c5e:	e9 45 ff ff ff       	jmpq   803ba8 <_pipeisclosed+0x11>
}
  803c63:	48 83 c4 28          	add    $0x28,%rsp
  803c67:	5b                   	pop    %rbx
  803c68:	5d                   	pop    %rbp
  803c69:	c3                   	retq   

0000000000803c6a <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803c6a:	55                   	push   %rbp
  803c6b:	48 89 e5             	mov    %rsp,%rbp
  803c6e:	48 83 ec 30          	sub    $0x30,%rsp
  803c72:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803c75:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803c79:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803c7c:	48 89 d6             	mov    %rdx,%rsi
  803c7f:	89 c7                	mov    %eax,%edi
  803c81:	48 b8 23 2b 80 00 00 	movabs $0x802b23,%rax
  803c88:	00 00 00 
  803c8b:	ff d0                	callq  *%rax
  803c8d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c90:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c94:	79 05                	jns    803c9b <pipeisclosed+0x31>
		return r;
  803c96:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c99:	eb 31                	jmp    803ccc <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803c9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c9f:	48 89 c7             	mov    %rax,%rdi
  803ca2:	48 b8 60 2a 80 00 00 	movabs $0x802a60,%rax
  803ca9:	00 00 00 
  803cac:	ff d0                	callq  *%rax
  803cae:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803cb2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cb6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803cba:	48 89 d6             	mov    %rdx,%rsi
  803cbd:	48 89 c7             	mov    %rax,%rdi
  803cc0:	48 b8 97 3b 80 00 00 	movabs $0x803b97,%rax
  803cc7:	00 00 00 
  803cca:	ff d0                	callq  *%rax
}
  803ccc:	c9                   	leaveq 
  803ccd:	c3                   	retq   

0000000000803cce <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803cce:	55                   	push   %rbp
  803ccf:	48 89 e5             	mov    %rsp,%rbp
  803cd2:	48 83 ec 40          	sub    $0x40,%rsp
  803cd6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803cda:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803cde:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803ce2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ce6:	48 89 c7             	mov    %rax,%rdi
  803ce9:	48 b8 60 2a 80 00 00 	movabs $0x802a60,%rax
  803cf0:	00 00 00 
  803cf3:	ff d0                	callq  *%rax
  803cf5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803cf9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803cfd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803d01:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803d08:	00 
  803d09:	e9 92 00 00 00       	jmpq   803da0 <devpipe_read+0xd2>
		while (p->p_rpos == p->p_wpos) {
  803d0e:	eb 41                	jmp    803d51 <devpipe_read+0x83>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803d10:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803d15:	74 09                	je     803d20 <devpipe_read+0x52>
				return i;
  803d17:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d1b:	e9 92 00 00 00       	jmpq   803db2 <devpipe_read+0xe4>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803d20:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d24:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d28:	48 89 d6             	mov    %rdx,%rsi
  803d2b:	48 89 c7             	mov    %rax,%rdi
  803d2e:	48 b8 97 3b 80 00 00 	movabs $0x803b97,%rax
  803d35:	00 00 00 
  803d38:	ff d0                	callq  *%rax
  803d3a:	85 c0                	test   %eax,%eax
  803d3c:	74 07                	je     803d45 <devpipe_read+0x77>
				return 0;
  803d3e:	b8 00 00 00 00       	mov    $0x0,%eax
  803d43:	eb 6d                	jmp    803db2 <devpipe_read+0xe4>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803d45:	48 b8 40 24 80 00 00 	movabs $0x802440,%rax
  803d4c:	00 00 00 
  803d4f:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803d51:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d55:	8b 10                	mov    (%rax),%edx
  803d57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d5b:	8b 40 04             	mov    0x4(%rax),%eax
  803d5e:	39 c2                	cmp    %eax,%edx
  803d60:	74 ae                	je     803d10 <devpipe_read+0x42>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803d62:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d66:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803d6a:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803d6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d72:	8b 00                	mov    (%rax),%eax
  803d74:	99                   	cltd   
  803d75:	c1 ea 1b             	shr    $0x1b,%edx
  803d78:	01 d0                	add    %edx,%eax
  803d7a:	83 e0 1f             	and    $0x1f,%eax
  803d7d:	29 d0                	sub    %edx,%eax
  803d7f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d83:	48 98                	cltq   
  803d85:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803d8a:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803d8c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d90:	8b 00                	mov    (%rax),%eax
  803d92:	8d 50 01             	lea    0x1(%rax),%edx
  803d95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d99:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803d9b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803da0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803da4:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803da8:	0f 82 60 ff ff ff    	jb     803d0e <devpipe_read+0x40>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803dae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803db2:	c9                   	leaveq 
  803db3:	c3                   	retq   

0000000000803db4 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803db4:	55                   	push   %rbp
  803db5:	48 89 e5             	mov    %rsp,%rbp
  803db8:	48 83 ec 40          	sub    $0x40,%rsp
  803dbc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803dc0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803dc4:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803dc8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803dcc:	48 89 c7             	mov    %rax,%rdi
  803dcf:	48 b8 60 2a 80 00 00 	movabs $0x802a60,%rax
  803dd6:	00 00 00 
  803dd9:	ff d0                	callq  *%rax
  803ddb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803ddf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803de3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803de7:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803dee:	00 
  803def:	e9 8e 00 00 00       	jmpq   803e82 <devpipe_write+0xce>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803df4:	eb 31                	jmp    803e27 <devpipe_write+0x73>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803df6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803dfa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803dfe:	48 89 d6             	mov    %rdx,%rsi
  803e01:	48 89 c7             	mov    %rax,%rdi
  803e04:	48 b8 97 3b 80 00 00 	movabs $0x803b97,%rax
  803e0b:	00 00 00 
  803e0e:	ff d0                	callq  *%rax
  803e10:	85 c0                	test   %eax,%eax
  803e12:	74 07                	je     803e1b <devpipe_write+0x67>
				return 0;
  803e14:	b8 00 00 00 00       	mov    $0x0,%eax
  803e19:	eb 79                	jmp    803e94 <devpipe_write+0xe0>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803e1b:	48 b8 40 24 80 00 00 	movabs $0x802440,%rax
  803e22:	00 00 00 
  803e25:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803e27:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e2b:	8b 40 04             	mov    0x4(%rax),%eax
  803e2e:	48 63 d0             	movslq %eax,%rdx
  803e31:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e35:	8b 00                	mov    (%rax),%eax
  803e37:	48 98                	cltq   
  803e39:	48 83 c0 20          	add    $0x20,%rax
  803e3d:	48 39 c2             	cmp    %rax,%rdx
  803e40:	73 b4                	jae    803df6 <devpipe_write+0x42>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803e42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e46:	8b 40 04             	mov    0x4(%rax),%eax
  803e49:	99                   	cltd   
  803e4a:	c1 ea 1b             	shr    $0x1b,%edx
  803e4d:	01 d0                	add    %edx,%eax
  803e4f:	83 e0 1f             	and    $0x1f,%eax
  803e52:	29 d0                	sub    %edx,%eax
  803e54:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803e58:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803e5c:	48 01 ca             	add    %rcx,%rdx
  803e5f:	0f b6 0a             	movzbl (%rdx),%ecx
  803e62:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e66:	48 98                	cltq   
  803e68:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803e6c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e70:	8b 40 04             	mov    0x4(%rax),%eax
  803e73:	8d 50 01             	lea    0x1(%rax),%edx
  803e76:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e7a:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803e7d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803e82:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803e86:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803e8a:	0f 82 64 ff ff ff    	jb     803df4 <devpipe_write+0x40>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803e90:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803e94:	c9                   	leaveq 
  803e95:	c3                   	retq   

0000000000803e96 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803e96:	55                   	push   %rbp
  803e97:	48 89 e5             	mov    %rsp,%rbp
  803e9a:	48 83 ec 20          	sub    $0x20,%rsp
  803e9e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803ea2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803ea6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803eaa:	48 89 c7             	mov    %rax,%rdi
  803ead:	48 b8 60 2a 80 00 00 	movabs $0x802a60,%rax
  803eb4:	00 00 00 
  803eb7:	ff d0                	callq  *%rax
  803eb9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803ebd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ec1:	48 be b4 4d 80 00 00 	movabs $0x804db4,%rsi
  803ec8:	00 00 00 
  803ecb:	48 89 c7             	mov    %rax,%rdi
  803ece:	48 b8 4f 1b 80 00 00 	movabs $0x801b4f,%rax
  803ed5:	00 00 00 
  803ed8:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803eda:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ede:	8b 50 04             	mov    0x4(%rax),%edx
  803ee1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ee5:	8b 00                	mov    (%rax),%eax
  803ee7:	29 c2                	sub    %eax,%edx
  803ee9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803eed:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803ef3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ef7:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803efe:	00 00 00 
	stat->st_dev = &devpipe;
  803f01:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f05:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  803f0c:	00 00 00 
  803f0f:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803f16:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f1b:	c9                   	leaveq 
  803f1c:	c3                   	retq   

0000000000803f1d <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803f1d:	55                   	push   %rbp
  803f1e:	48 89 e5             	mov    %rsp,%rbp
  803f21:	48 83 ec 10          	sub    $0x10,%rsp
  803f25:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	(void) sys_page_unmap(0, fd);
  803f29:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f2d:	48 89 c6             	mov    %rax,%rsi
  803f30:	bf 00 00 00 00       	mov    $0x0,%edi
  803f35:	48 b8 29 25 80 00 00 	movabs $0x802529,%rax
  803f3c:	00 00 00 
  803f3f:	ff d0                	callq  *%rax
	return sys_page_unmap(0, fd2data(fd));
  803f41:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f45:	48 89 c7             	mov    %rax,%rdi
  803f48:	48 b8 60 2a 80 00 00 	movabs $0x802a60,%rax
  803f4f:	00 00 00 
  803f52:	ff d0                	callq  *%rax
  803f54:	48 89 c6             	mov    %rax,%rsi
  803f57:	bf 00 00 00 00       	mov    $0x0,%edi
  803f5c:	48 b8 29 25 80 00 00 	movabs $0x802529,%rax
  803f63:	00 00 00 
  803f66:	ff d0                	callq  *%rax
}
  803f68:	c9                   	leaveq 
  803f69:	c3                   	retq   

0000000000803f6a <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803f6a:	55                   	push   %rbp
  803f6b:	48 89 e5             	mov    %rsp,%rbp
  803f6e:	48 83 ec 20          	sub    $0x20,%rsp
  803f72:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803f75:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f78:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803f7b:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803f7f:	be 01 00 00 00       	mov    $0x1,%esi
  803f84:	48 89 c7             	mov    %rax,%rdi
  803f87:	48 b8 36 23 80 00 00 	movabs $0x802336,%rax
  803f8e:	00 00 00 
  803f91:	ff d0                	callq  *%rax
}
  803f93:	c9                   	leaveq 
  803f94:	c3                   	retq   

0000000000803f95 <getchar>:

int
getchar(void)
{
  803f95:	55                   	push   %rbp
  803f96:	48 89 e5             	mov    %rsp,%rbp
  803f99:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803f9d:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803fa1:	ba 01 00 00 00       	mov    $0x1,%edx
  803fa6:	48 89 c6             	mov    %rax,%rsi
  803fa9:	bf 00 00 00 00       	mov    $0x0,%edi
  803fae:	48 b8 55 2f 80 00 00 	movabs $0x802f55,%rax
  803fb5:	00 00 00 
  803fb8:	ff d0                	callq  *%rax
  803fba:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803fbd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fc1:	79 05                	jns    803fc8 <getchar+0x33>
		return r;
  803fc3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fc6:	eb 14                	jmp    803fdc <getchar+0x47>
	if (r < 1)
  803fc8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fcc:	7f 07                	jg     803fd5 <getchar+0x40>
		return -E_EOF;
  803fce:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803fd3:	eb 07                	jmp    803fdc <getchar+0x47>
	return c;
  803fd5:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803fd9:	0f b6 c0             	movzbl %al,%eax
}
  803fdc:	c9                   	leaveq 
  803fdd:	c3                   	retq   

0000000000803fde <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803fde:	55                   	push   %rbp
  803fdf:	48 89 e5             	mov    %rsp,%rbp
  803fe2:	48 83 ec 20          	sub    $0x20,%rsp
  803fe6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803fe9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803fed:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ff0:	48 89 d6             	mov    %rdx,%rsi
  803ff3:	89 c7                	mov    %eax,%edi
  803ff5:	48 b8 23 2b 80 00 00 	movabs $0x802b23,%rax
  803ffc:	00 00 00 
  803fff:	ff d0                	callq  *%rax
  804001:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804004:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804008:	79 05                	jns    80400f <iscons+0x31>
		return r;
  80400a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80400d:	eb 1a                	jmp    804029 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80400f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804013:	8b 10                	mov    (%rax),%edx
  804015:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  80401c:	00 00 00 
  80401f:	8b 00                	mov    (%rax),%eax
  804021:	39 c2                	cmp    %eax,%edx
  804023:	0f 94 c0             	sete   %al
  804026:	0f b6 c0             	movzbl %al,%eax
}
  804029:	c9                   	leaveq 
  80402a:	c3                   	retq   

000000000080402b <opencons>:

int
opencons(void)
{
  80402b:	55                   	push   %rbp
  80402c:	48 89 e5             	mov    %rsp,%rbp
  80402f:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804033:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804037:	48 89 c7             	mov    %rax,%rdi
  80403a:	48 b8 8b 2a 80 00 00 	movabs $0x802a8b,%rax
  804041:	00 00 00 
  804044:	ff d0                	callq  *%rax
  804046:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804049:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80404d:	79 05                	jns    804054 <opencons+0x29>
		return r;
  80404f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804052:	eb 5b                	jmp    8040af <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804054:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804058:	ba 07 04 00 00       	mov    $0x407,%edx
  80405d:	48 89 c6             	mov    %rax,%rsi
  804060:	bf 00 00 00 00       	mov    $0x0,%edi
  804065:	48 b8 7e 24 80 00 00 	movabs $0x80247e,%rax
  80406c:	00 00 00 
  80406f:	ff d0                	callq  *%rax
  804071:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804074:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804078:	79 05                	jns    80407f <opencons+0x54>
		return r;
  80407a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80407d:	eb 30                	jmp    8040af <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80407f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804083:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  80408a:	00 00 00 
  80408d:	8b 12                	mov    (%rdx),%edx
  80408f:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804091:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804095:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80409c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040a0:	48 89 c7             	mov    %rax,%rdi
  8040a3:	48 b8 3d 2a 80 00 00 	movabs $0x802a3d,%rax
  8040aa:	00 00 00 
  8040ad:	ff d0                	callq  *%rax
}
  8040af:	c9                   	leaveq 
  8040b0:	c3                   	retq   

00000000008040b1 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8040b1:	55                   	push   %rbp
  8040b2:	48 89 e5             	mov    %rsp,%rbp
  8040b5:	48 83 ec 30          	sub    $0x30,%rsp
  8040b9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8040bd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8040c1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8040c5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8040ca:	75 07                	jne    8040d3 <devcons_read+0x22>
		return 0;
  8040cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8040d1:	eb 4b                	jmp    80411e <devcons_read+0x6d>

	while ((c = sys_cgetc()) == 0)
  8040d3:	eb 0c                	jmp    8040e1 <devcons_read+0x30>
		sys_yield();
  8040d5:	48 b8 40 24 80 00 00 	movabs $0x802440,%rax
  8040dc:	00 00 00 
  8040df:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8040e1:	48 b8 80 23 80 00 00 	movabs $0x802380,%rax
  8040e8:	00 00 00 
  8040eb:	ff d0                	callq  *%rax
  8040ed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040f4:	74 df                	je     8040d5 <devcons_read+0x24>
		sys_yield();
	if (c < 0)
  8040f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040fa:	79 05                	jns    804101 <devcons_read+0x50>
		return c;
  8040fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040ff:	eb 1d                	jmp    80411e <devcons_read+0x6d>
	if (c == 0x04)	// ctl-d is eof
  804101:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804105:	75 07                	jne    80410e <devcons_read+0x5d>
		return 0;
  804107:	b8 00 00 00 00       	mov    $0x0,%eax
  80410c:	eb 10                	jmp    80411e <devcons_read+0x6d>
	*(char*)vbuf = c;
  80410e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804111:	89 c2                	mov    %eax,%edx
  804113:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804117:	88 10                	mov    %dl,(%rax)
	return 1;
  804119:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80411e:	c9                   	leaveq 
  80411f:	c3                   	retq   

0000000000804120 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804120:	55                   	push   %rbp
  804121:	48 89 e5             	mov    %rsp,%rbp
  804124:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80412b:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804132:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804139:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804140:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804147:	eb 76                	jmp    8041bf <devcons_write+0x9f>
		m = n - tot;
  804149:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804150:	89 c2                	mov    %eax,%edx
  804152:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804155:	29 c2                	sub    %eax,%edx
  804157:	89 d0                	mov    %edx,%eax
  804159:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80415c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80415f:	83 f8 7f             	cmp    $0x7f,%eax
  804162:	76 07                	jbe    80416b <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804164:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80416b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80416e:	48 63 d0             	movslq %eax,%rdx
  804171:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804174:	48 63 c8             	movslq %eax,%rcx
  804177:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80417e:	48 01 c1             	add    %rax,%rcx
  804181:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804188:	48 89 ce             	mov    %rcx,%rsi
  80418b:	48 89 c7             	mov    %rax,%rdi
  80418e:	48 b8 73 1e 80 00 00 	movabs $0x801e73,%rax
  804195:	00 00 00 
  804198:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80419a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80419d:	48 63 d0             	movslq %eax,%rdx
  8041a0:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8041a7:	48 89 d6             	mov    %rdx,%rsi
  8041aa:	48 89 c7             	mov    %rax,%rdi
  8041ad:	48 b8 36 23 80 00 00 	movabs $0x802336,%rax
  8041b4:	00 00 00 
  8041b7:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8041b9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8041bc:	01 45 fc             	add    %eax,-0x4(%rbp)
  8041bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041c2:	48 98                	cltq   
  8041c4:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8041cb:	0f 82 78 ff ff ff    	jb     804149 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8041d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8041d4:	c9                   	leaveq 
  8041d5:	c3                   	retq   

00000000008041d6 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8041d6:	55                   	push   %rbp
  8041d7:	48 89 e5             	mov    %rsp,%rbp
  8041da:	48 83 ec 08          	sub    $0x8,%rsp
  8041de:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8041e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8041e7:	c9                   	leaveq 
  8041e8:	c3                   	retq   

00000000008041e9 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8041e9:	55                   	push   %rbp
  8041ea:	48 89 e5             	mov    %rsp,%rbp
  8041ed:	48 83 ec 10          	sub    $0x10,%rsp
  8041f1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8041f5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8041f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041fd:	48 be c0 4d 80 00 00 	movabs $0x804dc0,%rsi
  804204:	00 00 00 
  804207:	48 89 c7             	mov    %rax,%rdi
  80420a:	48 b8 4f 1b 80 00 00 	movabs $0x801b4f,%rax
  804211:	00 00 00 
  804214:	ff d0                	callq  *%rax
	return 0;
  804216:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80421b:	c9                   	leaveq 
  80421c:	c3                   	retq   

000000000080421d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80421d:	55                   	push   %rbp
  80421e:	48 89 e5             	mov    %rsp,%rbp
  804221:	48 83 ec 18          	sub    $0x18,%rsp
  804225:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804229:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80422d:	48 c1 e8 15          	shr    $0x15,%rax
  804231:	48 89 c2             	mov    %rax,%rdx
  804234:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80423b:	01 00 00 
  80423e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804242:	83 e0 01             	and    $0x1,%eax
  804245:	48 85 c0             	test   %rax,%rax
  804248:	75 07                	jne    804251 <pageref+0x34>
		return 0;
  80424a:	b8 00 00 00 00       	mov    $0x0,%eax
  80424f:	eb 53                	jmp    8042a4 <pageref+0x87>
	pte = uvpt[PGNUM(v)];
  804251:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804255:	48 c1 e8 0c          	shr    $0xc,%rax
  804259:	48 89 c2             	mov    %rax,%rdx
  80425c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804263:	01 00 00 
  804266:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80426a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80426e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804272:	83 e0 01             	and    $0x1,%eax
  804275:	48 85 c0             	test   %rax,%rax
  804278:	75 07                	jne    804281 <pageref+0x64>
		return 0;
  80427a:	b8 00 00 00 00       	mov    $0x0,%eax
  80427f:	eb 23                	jmp    8042a4 <pageref+0x87>
	return pages[PPN(pte)].pp_ref;
  804281:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804285:	48 c1 e8 0c          	shr    $0xc,%rax
  804289:	48 89 c2             	mov    %rax,%rdx
  80428c:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804293:	00 00 00 
  804296:	48 c1 e2 04          	shl    $0x4,%rdx
  80429a:	48 01 d0             	add    %rdx,%rax
  80429d:	0f b7 40 08          	movzwl 0x8(%rax),%eax
  8042a1:	0f b7 c0             	movzwl %ax,%eax
}
  8042a4:	c9                   	leaveq 
  8042a5:	c3                   	retq   
