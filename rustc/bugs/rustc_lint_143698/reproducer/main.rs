#![deny(unused_parens)]
trait MyTrait {}
fn foo(_: Box<dyn FnMut(&mut u32) -> &mut (dyn MyTrait) + Send + Sync>) {}
fn main() {}
