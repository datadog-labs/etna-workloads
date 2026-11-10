#![feature(cfg_version)]
#[cfg(not(version = "1.48.0"))]
pub fn g() {}
fn main() {}
