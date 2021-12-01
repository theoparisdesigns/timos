/**************************
* Display text on screen *
**************************/
// TODO: REFACTOR

pub fn puts(string: &'static str) {
    use crate::bootboot::*;

    let fb = BOOTBOOT_FB as u64;
    let bootboot_r = unsafe { & (*(BOOTBOOT_INFO as *const BOOTBOOT)) };

    unsafe {
        let font: *mut psf2_t = &_binary_font_psf_start as *const u64 as *mut psf2_t;
        let (mut kx, mut line, mut mask, mut offs): (u32, u64, u64, u32);
        kx = 0;
        let bpl = ((*font).width + 7) / 8;

        for s in string.bytes() {
            let glyph_a: *mut u8 = (font as u64 + (*font).headersize as u64) as *mut u8;
            let mut glyph: *mut u8 = glyph_a.offset(
                (if s > 0 && (s as u32) < (*font).numglyph {
                    s as u32
                } else {
                    0
                } * ((*font).bytesperglyph)) as isize,
            );
            offs = kx * ((*font).width + 1) * 4;
            for _y in 0..(*font).height {
                line = offs as u64;
                mask = 1 << ((*font).width - 1);
                for _x in 0..(*font).width {
                    let target_location = (fb as *const u8 as u64 + line) as *mut u32;
                    let mut target_value: u32 = 0;
                    if (*glyph as u64) & (mask) > 0 {
                        target_value = 0xFFFFFF;
                    }
                    *target_location = target_value;
                    mask >>= 1;
                    line += 4;
                }
                let target_location = (fb as *const u8 as u64 + line) as *mut u32;
                *target_location = 0;
                glyph = glyph.offset(bpl as isize);
                offs += bootboot_r.fb_scanline;
            }
            kx += 1;
        }
    }
}

