#![feature(mut_restriction)]
#![allow(incomplete_features)]
pub mod inner {
    pub struct Wrapper(pub mut(self) u8);
}
fn main() {
    let f = inner::Wrapper;
    let _ = f(1);
}
