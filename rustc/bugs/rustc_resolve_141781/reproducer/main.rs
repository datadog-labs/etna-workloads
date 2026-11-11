#![feature(unsafe_binders)]
#![deny(unused_lifetimes)]
#![allow(incomplete_features)]
pub struct S([usize; 8]);
pub fn by_value(_x: unsafe<'a> S) -> usize { 0 }
fn main() {}
