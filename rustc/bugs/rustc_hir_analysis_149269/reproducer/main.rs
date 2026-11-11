#![feature(abi_cmse_nonsecure_call, no_core, lang_items)]
#![no_core]
extern crate minicore;
use minicore::*;
fn infer_1() {
    let _ = mem::transmute::<fn() -> _, extern "cmse-nonsecure-call" fn() -> _>;
}
