#![crate_type="lib"]
#[repr(C)] pub struct Z;
#[no_mangle] pub extern "win64" fn f(_: Z) {}
