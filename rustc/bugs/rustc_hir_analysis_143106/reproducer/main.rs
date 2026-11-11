// regression test for #133808.

#![feature(min_generic_const_args, macroless_generic_const_args, generic_const_exprs)]
#![allow(incomplete_features)]
#![crate_type = "lib"]
extern crate aux;

pub trait Foo {}
impl Foo for [u8; aux::NON_LOCAL_CONST] {}
//~^ ERROR the constant `'a'` is not of type `usize`
