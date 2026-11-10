#![feature(rust_cold_cc)]
#![crate_type = "lib"]
pub extern "rust-cold" fn foo(_: [usize; 3]) {}
