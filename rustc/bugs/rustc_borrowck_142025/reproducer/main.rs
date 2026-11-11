#![feature(super_let)]
extern crate ext;
fn foo() -> impl Sized {
    drop(|| ext::foo!());
    1
}
fn main() { foo(); }
