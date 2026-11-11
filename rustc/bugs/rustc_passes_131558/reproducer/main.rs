#![warn(unused_attributes)]
#[no_mangle]
#[export_name = "foo"]
pub fn bar() {}
fn main() {}
