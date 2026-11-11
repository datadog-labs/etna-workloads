#![crate_type = "lib"]
#![feature(no_core, asm_experimental_arch, linkage)]
#![no_core]
extern crate minicore;
use minicore::*;

#[no_mangle]
#[unsafe(naked)]
#[linkage = "weak"]
extern "C" fn weak_nop() {
    naked_asm!("nop")
}
