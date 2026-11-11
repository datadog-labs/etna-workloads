#![feature(cmse_nonsecure_entry, no_core, lang_items)]
#![no_core]
#[lang = "pointee_sized"] trait PointeeSized {}
#[lang = "meta_sized"] trait MetaSized: PointeeSized {}
#[lang = "sized"] trait Sized: MetaSized {}
#[lang = "copy"] trait Copy {}
impl Copy for u8 {}
#[repr(C)]
pub struct Big(u8, u8, u8, u8, u8);
#[no_mangle]
pub extern "cmse-nonsecure-entry" fn f(_: u32, _: u32, _: u32, _: u32, _: u32, _: u32) -> Big {
    Big(0, 1, 2, 3, 4)
}
