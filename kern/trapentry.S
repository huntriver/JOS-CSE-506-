/* See COPYRIGHT for copyright information. */

#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <inc/trap.h>
#include <kern/macro.h>

#include <kern/picirq.h>


###################################################################
# exceptions/interrupts
###################################################################

/* TRAPHANDLER defines a globally-visible function for handling a trap.
* It pushes a trap number onto the stack, then jumps to _alltraps.
* Use TRAPHANDLER for traps where the CPU automatically pushes an error code.
*
* You shouldn't call a TRAPHANDLER function from C, but you may
* need to _declare_ one in C (for instance, to get a function pointer
	* during IDT setup).  You can declare the function with
*   void NAME();
* where NAME is the argument passed to TRAPHANDLER.
*/

/* Use MYTH_NOEC for traps where the CPU doesn't push an error code.
* It pushes a 0 in place of the error code, so the trap frame has the same
* format in either case.
*/



#define TRAPHANDLER(name, num)                        \
.text;                \
.globl name;                                \
.type name, @function;                \
.align 2;                        \
name:                                \
pushq $(num);                \
jmp _alltraps;                \
.data;                                \
.8byte name


#define TRAPHANDLER_NOEC(name, num)        \
.text;                \
.globl name;                                \
.type name, @function;                \
.align 2;                        \
name:                                \
pushq $0;                        \
pushq $(num);                \
jmp _alltraps;                \
.data;                                 \
.8byte name      

#define TRAPHANDLER_NOEC48(name, num)					\
.globl name;							\
.type name, @function;						\
.align 2;							\
name:								\
pushq $0;							\
pushq $(num);							\
jmp _alltraps


#define TRAPHANDLER_NULL()                \
.data;                                \
.8byte 0


/*Lab 3: Your code here for generating entry points for the different traps.
Find the PUSHA,POPA macros in kern/macro.h. Since amd64 doesn't support
pusha,popa so you will find these macros handy.*/
.data
.align 2
.global entries
entries:
.text
TRAPHANDLER_NOEC(entry0, 0)
TRAPHANDLER_NOEC(entry1, 1)
TRAPHANDLER_NOEC(entry2, 2)
TRAPHANDLER_NOEC(entry3, 3)
TRAPHANDLER_NOEC(entry4, 4)
TRAPHANDLER_NOEC(entry5, 5)
TRAPHANDLER_NOEC(entry6, 6)
TRAPHANDLER_NOEC(entry7, 7)
TRAPHANDLER(entry8, 8)
TRAPHANDLER_NULL()
TRAPHANDLER(entry10, 10)
TRAPHANDLER(entry11, 11)
TRAPHANDLER(entry12, 12)
TRAPHANDLER(entry13, 13)
TRAPHANDLER(entry14, 14)
TRAPHANDLER_NULL()
TRAPHANDLER_NOEC(entry16, 16)
TRAPHANDLER(entry17, 17)
TRAPHANDLER_NOEC(entry18, 18)
TRAPHANDLER_NOEC(entry19, 19)

/* irq 32-47 
TRAPHANDLER_NOEC(entry32, 32)
TRAPHANDLER_NOEC(entry33, 33)
TRAPHANDLER_NOEC(entry34, 34)
TRAPHANDLER_NOEC(entry35, 35)
TRAPHANDLER_NOEC(entry36, 36)
TRAPHANDLER_NOEC(entry37, 37)
TRAPHANDLER_NOEC(entry38, 38)
TRAPHANDLER_NOEC(entry39, 39)
TRAPHANDLER_NOEC(entry40, 40)
TRAPHANDLER_NOEC(entry41, 41)
TRAPHANDLER_NOEC(entry42, 42)
TRAPHANDLER_NOEC(entry43, 43)
TRAPHANDLER_NOEC(entry44, 44)
TRAPHANDLER_NOEC(entry45, 45)
TRAPHANDLER_NOEC(entry46, 46)
TRAPHANDLER_NOEC(entry47, 47)
*/

TRAPHANDLER_NOEC48(entry48, 48)


/*
* Lab 3: Your code here for _alltraps
*
* Hint: Be sure to review the x64 calling convention from lab1
*       for how to pass a pointer to the trapframe.
*/

_alltraps:
movw %ds,%r15
pushq %r15
movw %es, %r15
pushq %r15
PUSHA

movw $(GD_KD), %r15
movw %r15, %es
movw %r15, %ds
mov %rsp, %rdi
call trap
