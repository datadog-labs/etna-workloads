#![crate_type = "lib"]
#[repr(C)]
pub struct Big { pub a: [u64; 4] }
#[no_mangle]
pub fn take(x: Big, f: fn(Big) -> Big) -> Big { f(x) }
