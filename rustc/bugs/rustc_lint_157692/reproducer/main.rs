#![deny(unused_parens)]
#![allow(uncommon_codepoints)]
extern crate pm;
pm::emit_parenthesized_bound!(é);
fn main() {}
