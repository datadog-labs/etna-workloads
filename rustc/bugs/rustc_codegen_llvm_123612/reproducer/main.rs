#![feature(no_core, lang_items)]
#![allow(internal_features)]
#![crate_type = "lib"]
#![no_core]
#[lang = "pointee_sized"] trait PointeeSized {}
#[lang = "meta_sized"] trait MetaSized: PointeeSized {}
#[lang = "sized"] trait Sized: MetaSized {}
