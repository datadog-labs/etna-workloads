#![feature(no_core, lang_items)]
#![no_core]
#![crate_type = "lib"]
#[lang = "pointee_sized"] pub trait PointeeSized {}
#[lang = "meta_sized"] pub trait MetaSized: PointeeSized {}
#[lang = "sized"] pub trait Sized: MetaSized {}
#[lang = "copy"] pub trait Copy {}
impl Copy for f32 {}
#[no_mangle]
pub extern "Rust" fn return_f32(x: f32) -> f32 { x }
