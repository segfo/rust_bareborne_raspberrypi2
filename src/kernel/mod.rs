use serial::{getc,write,writec,Writer};
use core::fmt::Write;

#[no_mangle]
pub extern fn kernel_main() {
    write("Hello Rust Kernel world!\n");
    loop {
        let c = getc();
        match c{
            0x0a|0x0d=>write("\n"),
            c => writec(c)
        };
    }
}