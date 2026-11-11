#![crate_type = "lib"]
extern crate leaf;
#[no_mangle]
pub fn outer(a: i32, b: i32) -> i32 { leaf::leaf_with_assert(a, b) }
