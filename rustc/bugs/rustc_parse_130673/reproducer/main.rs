#![feature(fn_delegation)]
#![allow(incomplete_features)]
trait Trait { fn foo(&self) {} }
struct S;
impl Trait for S {}
struct T(S);
impl Trait for T {
    reuse Trait:::* { &self.0 }
}
fn main() {}
