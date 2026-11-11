#![crate_type = "lib"]
#[no_mangle]
pub fn index_on_i32(a: &mut [i32], index: usize) -> &mut i32 {
    &mut a[index]
}
