#![crate_type = "lib"]
#![no_std]
#[no_mangle]
pub fn copy_indirect(a: [u8; 1024], f: fn([u8; 1024])) -> u8 { f(a); f(a); a[0] }
