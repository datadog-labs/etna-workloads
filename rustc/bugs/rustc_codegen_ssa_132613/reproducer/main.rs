use std::env;
extern crate macro_def;
fn square(n: i32) -> i32 { n * n }
fn main() {
    let (z1, z2) = macro_def::square_twice!();
    println!("{z1} == {z2}");
}
