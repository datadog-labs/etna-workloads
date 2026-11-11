#![feature(repr_simd)]
#![crate_type = "lib"]
#[repr(simd)]
#[derive(Copy, Clone)]
pub struct S([u8; 16]);
pub fn foo(simds: &[S], _unused: S) {
    let _a = simds[0];
}
