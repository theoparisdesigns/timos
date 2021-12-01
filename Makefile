#

all: kernel.x86_64.elf

# Kernel build
kernel.x86_64.elf: src/**
	objcopy -O elf64-x86-64 -B i386 -I binary font.psf font.o
	cargo xbuild --target ./triplets/kernel-x86.json
	# Using this causes the kernel to exceed the 2 MB limit
	# cargo build -Z build-std=core,alloc --target ./triplets/$mykernel-x86.json
	cp ./target/kernel-x86/debug/kernel-rust kernel.x86_64.elf

