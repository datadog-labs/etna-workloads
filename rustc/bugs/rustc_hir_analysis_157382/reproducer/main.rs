#![feature(min_generic_const_args, macroless_generic_const_args, inherent_associated_types)]
#![allow(dead_code)]
#![crate_type = "lib"]
pub const PUBLIC: usize = 1;
pub struct Foo([u8; PUBLIC]);
