const std = @import("std");
const builtin = std.builtin;
const multiboot = @import("multiboot.zig");
const vga = @import("vga.zig");
const x86 = @import("x86.zig");

// Place the header at the very beginning of the binary.
export const multiboot_header align(4) linksection(".multiboot") = multiboot: {
    const MAGIC = @as(u32, 0x1BADB002); // multiboot magic
    const ALIGN = @as(u32, 1 << 0); // Align loaded modules at 4k
    const MEMINFO = @as(u32, 1 << 1); // Receive a memory map from the bootloader.
    const ADDR = @as(u32, 1 << 16); // Load specific addr
    const FLAGS = ALIGN | MEMINFO; // Combine the flags.

    break :multiboot multiboot.MultibootHeader{
        .magic = MAGIC,
        .flags = FLAGS,
        .checksum = ~(MAGIC +% FLAGS) +% 1,
    };
};

// arch independant initialization
export fn kmain(magic: u32, info: *const multiboot.MultibootInfo) void {
    std.debug.assert(magic == multiboot.MULTIBOOT_BOOTLOADER_MAGIC);
    vga.terminal.initialize();
    vga.terminal.write("Hello, kernel world!\n");
    x86.hlt();
}
