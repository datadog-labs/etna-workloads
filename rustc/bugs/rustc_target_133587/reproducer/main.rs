#![feature(no_core, lang_items, rustc_attrs, asm_experimental_arch)]
#![no_core]
#![crate_type = "lib"]
#[lang = "pointee_sized"] pub trait PointeeSized {}
#[lang = "meta_sized"] pub trait MetaSized: PointeeSized {}
#[lang = "sized"] pub trait Sized: MetaSized {}
#[lang = "copy"] pub trait Copy {}
impl Copy for f32 {}
#[rustc_builtin_macro] macro_rules! asm { () => {} }
pub unsafe fn f(x: f32) {
    asm!("/* {} */", in(freg) x);
}
