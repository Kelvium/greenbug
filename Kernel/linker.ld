ENTRY(start)
SECTIONS
{
    .text 0x100000 :
    {
        code = .; _code = .; __code = .;
        *(.multiboot)
        *(.text)
        . = ALIGN(4096);
    }
}
