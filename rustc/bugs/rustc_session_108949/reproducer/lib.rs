#![feature(no_core)]
#![no_core]
#[cfg(target_os = "ericos")]
pub fn a() {}
#[cfg(target_arch = "tamirdarch")]
pub fn b() {}
