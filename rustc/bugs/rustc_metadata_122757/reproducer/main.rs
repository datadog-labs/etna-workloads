#![deny(exported_private_dependencies)]
#![crate_type = "rlib"]
extern crate bar;
extern crate foo;
pub fn baz() -> (Option<foo::Foo>, Option<bar::Bar>) { (None, None) }
