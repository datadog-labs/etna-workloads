#![allow(incomplete_features)]
#![feature(generic_const_exprs)]
fn f<const N: i8>() {
    aux::arg0_as_i8(N + 1);
}
fn main() {}
