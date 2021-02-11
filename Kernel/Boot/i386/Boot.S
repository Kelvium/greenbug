#define ASM_FILE
#include "Multiboot2.h"

/*  The size of our stack (16KB). */
#define STACK_SIZE 0x4000

/* The flags for the Multiboot header. */
#ifdef __ELF__
#define AOUT_KLUDGE 0
#else
#define AOUT_KLUDGE MULTIBOOT_AOUT_KLUDGE
#endif

.section .multiboot

/* functions */
.global _start
.extern init

_start:
    jmp multiboot_entry
    .align 8

multiboot_header:
    /* magic */
    .long MULTIBOOT2_HEADER_MAGIC
    /* ISA: i386 */
    .long GRUB_MULTIBOOT_ARCHITECTURE_I386
    /* header length. */
    .long multiboot_header_end - multiboot_header
    /* checksum */
    .long -(MULTIBOOT2_HEADER_MAGIC + GRUB_MULTIBOOT_ARCHITECTURE_I386 + (multiboot_header_end - multiboot_header))

#ifndef __ELF__
address_tag_start:
    .short MULTIBOOT_HEADER_TAG_ADDRESS
    .short MULTIBOOT_HEADER_TAG_OPTIONAL
    .long address_tag_end - address_tag_start
    /* header_addr */
    .long multiboot_header
    /* load_addr */
    .long _start
    /* load_end_addr */
    .long _edata
    /* bss_end_addr */
    .long _end

address_tag_end:

entry_address_tag_start:
    .short MULTIBOOT_HEADER_TAG_ENTRY_ADDRESS
    .short MULTIBOOT_HEADER_TAG_OPTIONAL
    .long entry_address_tag_end - entry_address_tag_start
    /* entry_addr */
    .long multiboot_entry

entry_address_tag_end:

#endif

framebuffer_tag_start:
    .short MULTIBOOT_HEADER_TAG_FRAMEBUFFER
    .short MULTIBOOT_HEADER_TAG_OPTIONAL
    .long framebuffer_tag_end - framebuffer_tag_start
    .long 1024
    .long 768
    .long 32

framebuffer_tag_end:
    .short MULTIBOOT_HEADER_TAG_END
    .short 0
    .long 8

multiboot_header_end:

multiboot_entry:
    /* Initialize the stack pointer. */
    movl $stack, %esp

    /* Reset EFLAGS. */
    pushl $0
    popf

    /*  Push the pointer to the Multiboot information structure. */
    pushl %ebx
    /* Push the magic value. */
    pushl %eax

    /* Now enter the C++ main function... */
    call init

    /* todo: halt */

loop:
    hlt
    jmp loop

halt_message:
    .asciz "Halted."

    /* Our stack area. */
    .comm stack, STACK_AREA
