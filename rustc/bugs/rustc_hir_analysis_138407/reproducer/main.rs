#![feature(fn_delegation)]
#![allow(incomplete_features)]
mod to_reuse {
    pub unsafe extern "C" fn variadic_fn(n: usize, mut args: ...) {}
}
reuse to_reuse::variadic_fn;
fn main() {}
