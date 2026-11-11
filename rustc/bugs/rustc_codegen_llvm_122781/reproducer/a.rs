#![crate_type = "lib"]
#![allow(internal_features)]
#![feature(no_core, lang_items)]
#![no_core]
#[lang = "pointee_sized"] pub trait PointeeSized {}
#[lang = "meta_sized"] pub trait MetaSized: PointeeSized {}
#[lang = "sized"] pub trait Sized: MetaSized {}
#[lang = "copy"] pub trait Copy {}
#[repr(C)] #[repr(align(16))]
pub struct Align16 { pub a: u64, pub b: u64 }
extern "C" { fn test_16(a: Align16); }
pub unsafe fn f(a: Align16) { test_16(a) }
