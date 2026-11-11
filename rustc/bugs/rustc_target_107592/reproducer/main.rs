#![feature(no_core, lang_items)]
#![no_core]
#![crate_type = "lib"]
#[lang = "pointee_sized"] trait PointeeSized {}
#[lang = "meta_sized"] trait MetaSized: PointeeSized {}
#[lang = "sized"] trait Sized: MetaSized {}
#[lang = "copy"] trait Copy {}
#[repr(C)]
pub enum Foo { Bar }
pub fn f(_: Foo) {}
