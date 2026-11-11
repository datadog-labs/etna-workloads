use std::convert::Infallible;
#[deny(unused_must_use)]
fn f() -> Result<(), Infallible> { Ok(()) }
fn main() { f(); }
