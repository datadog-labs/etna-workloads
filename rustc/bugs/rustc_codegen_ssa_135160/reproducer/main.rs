#![feature(no_core, lang_items)]
#![no_core]
#![allow(internal_features)]
#[lang = "pointee_sized"] pub trait PointeeSized {}
#[lang = "meta_sized"] pub trait MetaSized: PointeeSized {}
#[lang = "sized"] pub trait Sized: MetaSized {}

#[target_feature(enable = "neon")]
pub unsafe fn my_fun() {}
