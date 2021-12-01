ENTRY(main__main)

SECTIONS {
    .= 0x101000;
    .text : {
        *(.multiboot_header)
        *(.text)
    }
    
    .rodata : {
        *(.data)
    }
    
    .data : {
        *(.data)
    }
    
    .bss : {
         *(.bss)
    }
}
