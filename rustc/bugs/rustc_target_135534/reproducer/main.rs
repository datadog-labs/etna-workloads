#![crate_type = "lib"]
#![no_std]
#![no_core]
#![feature(no_core, lang_items)]
#![allow(internal_features)]
#[lang = "pointee_sized"]
pub trait PointeeSized {}
#[lang = "meta_sized"]
pub trait MetaSized: PointeeSized {}
#[lang = "sized"]
pub trait Sized: MetaSized {}
#[lang = "copy"]
pub trait Copy {}
impl Copy for i128 {}
#[no_mangle]
pub extern "C" fn ret(a: i128) -> i128 { a }
