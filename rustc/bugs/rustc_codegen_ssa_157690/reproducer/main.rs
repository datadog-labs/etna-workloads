#![crate_type = "lib"]
#[repr(C)]
pub struct InnerPadded { a: u16, b: u8, c: u32 }
#[no_mangle]
pub fn make() -> InnerPadded {
    InnerPadded { a: 0, b: 1, c: 0 }
}
