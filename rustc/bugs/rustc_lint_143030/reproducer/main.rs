#![warn(unused_must_use)]
macro_rules! cmp { ($a:expr, $b:expr) => { $a == $b }; }
fn main() {
    cmp!(1, 1);
}
