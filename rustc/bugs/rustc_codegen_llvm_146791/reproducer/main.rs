#![crate_type = "lib"]
use std::arch::asm;
#[no_mangle]
pub fn f(_x: &mut i32) -> i32 {
    let r: i32;
    unsafe { asm!("mov {0:e}, 1", out(reg) r, options(readonly, nostack)); }
    r
}
