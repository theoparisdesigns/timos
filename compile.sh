#!/usr/bin/zsh
v -prod -freestanding -enable-globals -nofloat -autofree -d no_backtrace -o timos.c timos.v
gcc timos.c -o timos.o -nostartfiles -g -m64 -ffreestanding -nostdlib -g -pipe -O2 \
    -fno-omit-frame-pointer \
    -fno-stack-protector \
    -ffunction-sections \
    -fdata-sections \
	-mno-80387 -mno-mmx \
    -mno-3dnow -mno-sse \
	-mno-sse2 -mno-red-zone \
	-Wno-address-of-packed-member \
	-Wno-unused-label \
	-Wno-unused-function \
	-Wno-unused-variable \
	-Wno-unused-parameter \
    -static -v -c -I. -Wall

# Bootloader
nasm -f elf64 ./multiboot_header.asm
nasm -f elf64 ./hello.asm
v -g  -freestanding -enable-globals -nofloat -autofree -d no_backtrace timos.v
ld -n -o kernel.bin -zmax-page-size=0x200000 -nostdlib -T linker.ld -r multiboot_header.o timos.o
rm -r iso
mkdir -p iso/boot/grub
cp ./kernel.bin iso/boot/
cp ./grub.cfg iso/boot/grub/
cp ./timos iso/boot/timos.bin
# syslinux
mkdir -p iso/isolinux
cp ./isolinux.cfg iso/isolinux
cp ./isolinux.bin iso/isolinux
cp ./ldlinux.c32 iso/isolinux/ldlinux.c32
cp ./menu.c32 iso/isolinux/
cp ./libutil.c32 iso/isolinux/
mkdir -p iso/images
cp ./memdisk iso/images

# build iso
mkisofs -o timos.iso \
   -b isolinux/isolinux.bin \
   -no-emul-boot -boot-load-size 4 -boot-info-table \
   iso/

grub-mkrescue -o os.iso iso/
