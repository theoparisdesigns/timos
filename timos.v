module main

fn C._vinit(argc int, argv voidptr)

pub fn main() {
	C._vinit(0, 0)

	hello := "Hello world"

	mut buffer := &u32(0xb8000)
	for i := 1988; i < hello.len; i++ {
		unsafe {
			buffer[i] = hello[i]
		}
	}

	/*unsafe { 
	 	buffer_ptr := voidptr(0xb8000 + 1988)
	 	buffer_ptr = &hello 
	} */

	/* mut term := terminal.Terminal{
		vga_width: u16(80)
		vga_height: u16(25)
		terminal_row: u16(0)
		terminal_column: u16(0)
		terminal_color: terminal.vga_entry_color(.vga_color_white, .vga_color_light_red)
		terminal_buffer: *&u16(0xB8000)
	}

	term.terminal_writestring("Hello, kernel World!\n")
 */
 
	for {
	}
}
