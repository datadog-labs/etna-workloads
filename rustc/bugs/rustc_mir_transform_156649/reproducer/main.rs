#![feature(async_drop)]
#![allow(incomplete_features)]
use core::future::async_drop_in_place;
struct SyncInt(i32);
impl Drop for SyncInt { fn drop(&mut self) {} }
pub fn f(x: &mut SyncInt) {
    let _ = unsafe { async_drop_in_place(x) };
}
fn main() { let mut s = SyncInt(1); f(&mut s); }
