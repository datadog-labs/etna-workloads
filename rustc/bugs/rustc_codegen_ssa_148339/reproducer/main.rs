use std::arch::naked_asm;
#[unsafe(naked)]
extern "C" fn ret() { naked_asm!("ret") }
#[unsafe(no_mangle)]
pub extern "C" fn entry() { ret() }
