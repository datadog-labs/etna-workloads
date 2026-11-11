#![deny(single_use_lifetimes)]
pub fn foo<'a>(x: impl IntoIterator<Item = &'a i32>) { let _ = x; }
fn main() {}
