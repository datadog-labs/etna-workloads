#![feature(repr_simd, core_intrinsics)]
#![allow(internal_features)]
use std::intrinsics::simd::simd_bitmask;
#[repr(simd)] #[derive(Copy, Clone)]
struct M([i32; 10]);
fn main() {
    let m = M([-1, 0, -1, 0, 0, 0, 0, 0, 0, -1]);
    let b: u16 = unsafe { simd_bitmask(m) };
    println!("{:#b}", b);
}
