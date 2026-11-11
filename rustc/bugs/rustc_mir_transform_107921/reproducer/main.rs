#![allow(arithmetic_overflow, unconditional_panic)]
#[inline(never)]
pub fn f() -> u8 {
    let x = 255u8;
    let y = x + 1;
    y
}
fn main() { println!("{}", f()); }
