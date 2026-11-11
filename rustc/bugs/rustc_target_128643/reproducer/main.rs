#![feature(no_core, lang_items)]
#![no_std]
#![no_core]
#![crate_type = "lib"]
#[lang = "pointee_sized"] pub trait PointeeSized {}
#[lang = "meta_sized"] pub trait MetaSized: PointeeSized {}
#[lang = "sized"] pub trait Sized: MetaSized {}
#[lang = "freeze"] unsafe trait Freeze {}
#[lang = "copy"] pub trait Copy {}
impl Copy for FiveU16s {}
impl Copy for u16 {}
impl<T: PointeeSized> Copy for &T {}
#[repr(C)]
pub struct FiveU16s(u16, u16, u16, u16, u16);
#[no_mangle]
pub extern "C" fn read_medium(x: &FiveU16s) -> FiveU16s { *x }
