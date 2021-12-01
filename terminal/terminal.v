module terminal

pub enum VgaColor {
	vga_color_black = 0
	vga_color_blue = 1
	vga_color_green = 2
	vga_color_cyan = 3
	vga_color_red = 4
	vga_color_magenta = 5
	vga_color_brown = 6
	vga_color_light_gray = 7
	vga_color_dark_gray = 8
	vga_color_light_blue = 9
	vga_color_light_green = 10
	vga_color_light_cyan = 11
	vga_color_light_red = 12
	vga_color_light_magenta = 13
	vga_color_light_brown = 14
	vga_color_white = 15
}

pub fn vga_entry_color(fg VgaColor, bg VgaColor) byte {
	return byte(fg) | (byte(bg) << 4)
}

pub fn vga_entry(uc byte, color byte) u16 {
	return uc | (color << 7)
}

pub struct Terminal {
	vga_width  u16
	vga_height u16
mut:
	terminal_row    u16
	terminal_column u16
	terminal_color  byte
	terminal_buffer &u16
}

pub fn terminal_putentryat(mut terminal Terminal, c byte, x u16, y u16) {
	index := y * terminal.vga_width + x
	terminal.terminal_buffer[index] = vga_entry(c, terminal.terminal_color)
}

pub fn terminal_putchar(mut terminal Terminal, c byte) {
	terminal_putentryat(mut terminal, c, terminal.terminal_column, terminal.terminal_row)
	if terminal.terminal_column++ == terminal.vga_width {
		terminal.terminal_column = 0
		if terminal.terminal_row++ == terminal.vga_height {
			terminal.terminal_row = 0
		}
	}
}

pub fn (mut terminal Terminal) terminal_writestring(s string) {
	for i := 0; i < s.len; i++ {
		terminal_putchar(mut terminal, s[i])
	}
}
