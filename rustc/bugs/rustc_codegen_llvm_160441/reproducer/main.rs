#![feature(no_core, lang_items, rustc_attrs, asm_experimental_arch)]
#![crate_type = "rlib"]
#![no_core]
#[lang = "pointee_sized"] pub trait PointeeSized {}
#[lang = "meta_sized"] pub trait MetaSized: PointeeSized {}
#[lang = "sized"] pub trait Sized: MetaSized {}
#[lang = "copy"] pub trait Copy {}
impl Copy for f64 {}
#[rustc_builtin_macro] macro_rules! asm { () => {} }

#[no_mangle]
pub unsafe fn f64_in(x: f64) {
    asm!("# {}", in(vsreg) x);
}
#[no_mangle]
pub unsafe fn f64_out() -> f64 {
    let y;
    asm!("# {}", out(vsreg) y);
    y
}
