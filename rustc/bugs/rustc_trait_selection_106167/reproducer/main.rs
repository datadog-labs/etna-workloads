#![allow(warnings)]
fn foo(d: impl Sized, p: &mut ()) -> impl Sized + '_ {
    (d, p)
}
fn main() {}
