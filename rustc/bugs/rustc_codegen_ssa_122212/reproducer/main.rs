#![feature(no_core, lang_items)]
#![crate_type = "lib"]
#![no_std]
#![no_core]
#[lang = "pointee_sized"] pub trait PointeeSized {}
#[lang = "meta_sized"] pub trait MetaSized: PointeeSized {}
#[lang = "sized"] pub trait Sized: MetaSized {}
#[lang = "copy"] pub trait Copy {}
#[repr(C)]
#[repr(align(16))]
pub struct Align16 { x: u128, y: u128, z: u128 }
extern "Rust" { fn sink(x: Align16); }
#[no_mangle]
pub unsafe extern "C" fn f(x: Align16) { sink(x) }
