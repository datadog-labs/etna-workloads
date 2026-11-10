#![crate_type = "lib"]
#![feature(lang_items, no_core)]
#![no_core]
#[lang = "pointee_sized"] pub trait PointeeSized {}
#[lang = "meta_sized"] pub trait MetaSized: PointeeSized {}
#[lang = "sized"] pub trait Sized: MetaSized {}
#[lang = "legacy_receiver"] pub trait LegacyReceiver {}
#[lang = "copy"] pub trait Copy {}
impl<T: PointeeSized> Copy for *const T {}
pub unsafe fn foo(x: *const i32) -> &'static i32 { unsafe { &*x } }
