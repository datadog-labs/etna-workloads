#![deny(unused_parens)]
fn main() {
    let x = 0;
    let _r = (&raw const x);
}
