#![crate_type = "lib"]
#![feature(no_core)]
#![no_core]
extern crate minicore;
use minicore::*;

#[unsafe(naked)]
#[unsafe(no_mangle)]
extern "C" fn naked_ret() {
    naked_asm!("ret")
}
