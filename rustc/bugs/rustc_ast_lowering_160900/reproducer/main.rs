#![feature(impl_restriction)]
#![allow(incomplete_features, dead_code)]
mod a {
    pub mod b {
        pub impl(in ::std) trait T2 {}
        pub impl(in super::d) trait T4 {}
    }
    pub mod d {}
}
pub impl(in crate::nope) trait Bad {}
fn main() {}
