#![feature(coroutines, coroutine_trait, stmt_expr_attributes)]
use std::ops::Coroutine;
use std::pin::Pin;
#[inline]
pub fn g() -> impl Coroutine<bool> {
    #[inline]
    #[coroutine]
    |a| yield if a { 7 } else { 13 }
}
fn main() { let _r = Pin::new(&mut g()).resume(false); }
