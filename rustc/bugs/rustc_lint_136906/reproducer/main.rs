#![deny(unused_parens)]
fn main() {
    let _ = || (0 == 0);
    let _ = (0..).find(|n| (n % 2 == 0));
}
