#![feature(rustc_attrs)]
extern crate p1;
extern crate p2;
#[rustc_diagnostic_item = "Foo"]
pub struct Foo {}
fn main() {}
