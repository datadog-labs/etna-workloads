#![deny(improper_ctypes, improper_ctypes_definitions)]
use std::marker::PhantomData;
#[repr(C)]
struct A<T> {
    a: *const A<A<T>>,
    p: PhantomData<T>,
}
extern "C" {
    fn f(a: *const A<()>);
}
fn main() {}
