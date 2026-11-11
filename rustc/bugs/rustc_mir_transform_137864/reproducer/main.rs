#![feature(unsafe_binders)]
#![allow(incomplete_features, unused, dead_code)]
use std::unsafe_binder::wrap_binder;
fn test() {
    unsafe {
        let x = 1;
        let binder: unsafe<'a> &'a i32 = wrap_binder!(&x);
    }
}
fn main() { test(); println!("ok"); }
