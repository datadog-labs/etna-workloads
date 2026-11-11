#![feature(no_core, asm_experimental_arch, lang_items, rustc_attrs)]
#![crate_type = "lib"]
#![no_core]
#[lang = "pointee_sized"] pub trait PointeeSized {}
#[lang = "meta_sized"] pub trait MetaSized: PointeeSized {}
#[lang = "sized"] pub trait Sized: MetaSized {}
#[rustc_builtin_macro] macro_rules! asm { () => {} }

pub fn f() {
    unsafe { asm!("r1:0 = memd(r29+#0)"); }
}
