#![allow(dead_code)]
struct U { a: usize, b: u8 }
const C: U = U { a: 5, b: 9 };
pub fn f() -> usize {
    let u = C;
    u.a
}
fn main() { println!("{}", f()); }
