#![feature(no_core, lang_items)]
#![no_core]
#![crate_type = "lib"]
#[lang = "pointee_sized"] pub trait PointeeSized {}
#[lang = "meta_sized"] pub trait MetaSized: PointeeSized {}
#[lang = "sized"] pub trait Sized: MetaSized {}
#[lang = "legacy_receiver"] pub trait LegacyReceiver {}
#[lang = "copy"] pub trait Copy {}
pub struct Z;
#[no_mangle]
pub extern "C" fn f(_z: Z, x: i32) -> i32 { x }
