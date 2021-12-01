// configure Rust compiler
#![no_std]
#![no_main]

#[cfg(not(test))]
use core::panic::PanicInfo;

#[allow(dead_code)]
#[allow(non_snake_case)]
#[allow(non_camel_case_types)]
mod bootboot;
mod framebuffer;

// Required for -Z build-std flag.
extern crate rlibc;

/******************************************
 * Entry point, called by BOOTBOOT Loader *
 ******************************************/
#[no_mangle] // don't mangle the name of this function
fn _start() -> ! {
    /*** NOTE: this code runs on all cores in parallel ***/
    use bootboot::*;

    //Lets use the BOOTBOOT_INFO as a pointer, dereference it and immediately borrow it.
    let bootboot_r = unsafe { & (*(BOOTBOOT_INFO as *const BOOTBOOT)) };

    if bootboot_r.fb_scanline > 0 {

    }
    // say hello
    framebuffer::puts("Hello TimOS Kernel");
    
    // hang for now
    loop {}
}

/*************************************
 * This function is called on panic. *
 *************************************/
#[cfg(not(test))]
#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}
