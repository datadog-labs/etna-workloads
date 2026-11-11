#![feature(no_core, lang_items, rustc_attrs, asm_experimental_arch)]
#![crate_type = "lib"]
#![no_core]
#![allow(internal_features)]
#[rustc_builtin_macro]
macro_rules! naked_asm { () => {} }
#[lang = "pointee_sized"] trait PointeeSized {}
#[lang = "meta_sized"] trait MetaSized: PointeeSized {}
#[lang = "sized"] trait Sized: MetaSized {}
#[unsafe(naked)]
#[no_mangle]
pub extern "C" fn blr() {
    naked_asm!("blr")
}
