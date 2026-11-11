#![warn(unused_qualifications)]
#![allow(unused_imports)]
mod m { pub fn f() {} }
use std::fmt;
fn main() {
    let _: std::fmt::Result = Ok(());
}
