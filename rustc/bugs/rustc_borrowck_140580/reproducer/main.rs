#![feature(super_let)]
extern crate ext;

fn foo() -> impl Sized {
    drop(|| ext::foo!());
    ext::foo!()
}

fn main() {
    foo();
}
