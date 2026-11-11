#![feature(no_core, lang_items, rustc_attrs)]
#![no_core]
#![no_std]
#[lang = "pointee_sized"] pub trait PointeeSized {}
#[lang = "meta_sized"] pub trait MetaSized: PointeeSized {}
#[lang = "sized"] pub trait Sized: MetaSized {}
#[lang = "copy"] pub trait Copy {}
impl Copy for i128 {}
impl<T: ?Sized> Copy for &T {}
#[no_mangle]
pub extern "C" fn ret_i128(x: &i128) -> i128 { *x }
