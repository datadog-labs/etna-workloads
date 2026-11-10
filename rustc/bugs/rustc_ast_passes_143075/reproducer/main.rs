#![feature(abi_x86_interrupt)]
#![crate_type = "lib"]
pub extern "x86-interrupt" fn a(_p: *const u8) -> ! { loop {} }
pub extern "x86-interrupt" fn b(_p: *const u8) -> () {}
