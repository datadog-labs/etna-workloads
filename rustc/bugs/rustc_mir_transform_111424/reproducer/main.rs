#![feature(unsized_fn_params)]
#![allow(incomplete_features, internal_features)]
#[inline(always)]
fn callee(_: [i32]) {}
fn caller(x: Box<[i32]>) {
    callee(*x);
}
fn main() {
    caller(Box::new([1]));
}
