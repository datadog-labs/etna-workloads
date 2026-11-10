#![feature(custom_inner_attributes)]
#![deny(dead_code, unused_attributes, unused_imports)]
extern crate pm;
#[path = "child.rs"]
mod child;
fn main() {}
