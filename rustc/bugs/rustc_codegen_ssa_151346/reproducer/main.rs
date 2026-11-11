#![feature(repr_simd, core_intrinsics)]
use std::intrinsics::simd::simd_splat;
#[repr(simd)]
#[derive(Copy, Clone)]
struct S<T, const N: usize>([T; N]);
static ZERO: u8 = 0;
fn main() {
    unsafe {
        let y: S<*const u8, 2> = const { simd_splat(&raw const ZERO) };
        let a: [*const u8; 2] = std::mem::transmute(y);
        println!("{}", a[1] == &raw const ZERO);
    }
}
