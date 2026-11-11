#![feature(no_core, rustc_attrs, lang_items, asm_experimental_arch)]
#![no_core]
#![crate_type = "lib"]
#[lang = "pointee_sized"] pub trait PointeeSized {}
#[lang = "meta_sized"] pub trait MetaSized: PointeeSized {}
#[lang = "sized"] pub trait Sized: MetaSized {}
#[rustc_builtin_macro]
macro_rules! asm { () => {} }
pub fn f() {
    unsafe {
        asm!("", out("p0") _);
        asm!("", out("ffr") _);
    }
}
