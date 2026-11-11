extern crate crate2;
pub trait Trait {}
pub fn foo(_arg: impl Trait) {}
pub fn bar(_arg: impl crate2::Trait) {}
