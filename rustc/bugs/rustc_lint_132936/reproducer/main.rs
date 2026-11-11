#![deny(unused_parens)]
pub fn f() {
    return (_ = 42);
}
fn main() { f() }
