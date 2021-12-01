#!/bin/sh

# Compile bootboot mkbootimg
mkdir -p bootboot
cd bootboot
git clone https://gitlab.com/bztsrc/bootboot .
git pull
cd mkbootimg
make
chmod +x mkbootimg
cd ../../

# Build the kernel
make

mkdir -p tmp/sys/core
cp kernel.*.elf tmp/sys/core
cp bootboot.cfg tmp/sys/config

# Make the boot image
./bootboot/mkbootimg/mkbootimg check kernel.x86_64.elf
./bootboot/mkbootimg/mkbootimg timos.json timos.img
