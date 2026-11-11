#![feature(extern_item_impls)]
extern crate dylib_default;

#[dylib_default::eii1]
fn other(x: u64) {
    println!("1{x}");
}

fn main() {}
