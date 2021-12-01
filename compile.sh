#!/usr/bin/zsh
zig build

# Bootloader
nasm -f elf ./multiboot_header.asm
ld -m elf_i386 -n -o kernel.bin -zmax-page-size=0x200000 -nostdlib -T linker.ld -r ./multiboot_header.o ./build/timos.o
rm -r iso
mkdir -p iso/boot/grub
cp ./grub.cfg iso/boot/grub/
cp ./kernel.bin iso/boot/
cp ./build/timos iso/boot/timos.bin

# build iso
git clone https://github.com/limine-bootloader/limine.git --branch=v2.0-branch-binary --depth=1
make -C limine/
cp ./limine.cfg limine/limine.sys limine/limine-cd.bin limine/limine-eltorito-efi.bin iso/

# Create the bootable ISO.
xorriso -as mkisofs -b limine-cd.bin \
        -no-emul-boot -boot-load-size 4 -boot-info-table \
        --efi-boot limine-eltorito-efi.bin \
        -efi-boot-part --efi-boot-image --protective-msdos-label \
        iso/ -o timos.iso
grub-mkrescue -o os.iso iso

# Install Limine stage 1 and 2 for legacy BIOS boot.
./limine/limine-install timos.iso

