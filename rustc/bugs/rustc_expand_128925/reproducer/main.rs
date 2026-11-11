#![feature(derive_coerce_pointee)]
use std::marker::CoercePointee;
#[derive(CoercePointee)]
#[repr(transparent)]
pub struct Ptr<'a, #[pointee] T: ?Sized> { data: &'a mut T }
fn main() {}
