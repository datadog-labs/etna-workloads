#![feature(no_core, lang_items, auto_traits)]
#![no_core]
#![no_std]
#![crate_type = "lib"]
#[lang = "pointee_sized"] pub trait PointeeSized {}
#[lang = "meta_sized"] pub trait MetaSized: PointeeSized {}
#[lang = "sized"] pub trait Sized: MetaSized {}
#[lang = "copy"] pub trait Copy {}
#[lang = "freeze"] unsafe auto trait Freeze {}
impl Copy for f32 {}
impl Copy for u8 {}
impl Copy for f64 {}

#[repr(C, align(64))]
pub struct Aligned { a: f32, b: f64 }

#[repr(C)]
pub struct Padded { a: u8, b: f64 }

#[no_mangle]
pub extern "C" fn ret_aligned(x: &Aligned) -> Aligned { Aligned { a: x.a, b: x.b } }
#[no_mangle]
pub extern "C" fn ret_padded(x: &Padded) -> Padded { Padded { a: x.a, b: x.b } }
