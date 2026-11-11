#[no_mangle]
pub extern "C" fn f(x: u32) -> u32 { x.wrapping_mul(3) }
