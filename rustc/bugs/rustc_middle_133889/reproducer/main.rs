#![feature(exhaustive_patterns, never_type, my_coro_state)]
extern crate staged_api;
use staged_api::{Foo, MyCoroutineState};
enum Void {}
fn demo(x: Foo<Void>) { match x {} }
fn unstable_enum(x: MyCoroutineState<i32, !>) {
    match x { MyCoroutineState::Yielded(_) => {} }
}
fn main() {}
