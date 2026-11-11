#![feature(fn_delegation)]
#![allow(warnings)]
mod m {
    fn foo() { }
    pub reuse foo as bar;
}
trait T {
    reuse m::bar as foo;
}
struct X;
impl T for X {}
trait T1 {
    reuse <X as T>::foo as baz;
}
impl T1 for X {}
struct Y;
impl T1 for Y {
    reuse <X as T>::foo as baz;
}
fn main() { <X as T1>::baz(); <Y as T1>::baz(); }
