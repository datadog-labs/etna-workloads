#![allow(internal_features)]
#![feature(no_core, lang_items, repr_simd)]
#![no_core]
#![crate_type = "lib"]
#[lang = "pointee_sized"] pub trait PointeeSized {}
#[lang = "meta_sized"] pub trait MetaSized: PointeeSized {}
#[lang = "sized"] pub trait Sized: MetaSized {}
#[lang = "copy"] pub trait Copy {}
impl Copy for i8 {}
impl<T: Copy, const N: usize> Copy for [T; N] {}
#[repr(simd)]
pub struct V([i8; 16]);
impl Copy for V {}
#[no_mangle]
pub extern "C" fn f(a: V, b: V) -> V { b }
