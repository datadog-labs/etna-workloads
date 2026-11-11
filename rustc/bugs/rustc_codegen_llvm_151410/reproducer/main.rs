#![feature(no_core, lang_items, rustc_attrs)]
#![no_core]
#![allow(internal_features)]
#[lang = "pointee_sized"] pub trait PointeeSized {}
#[lang = "meta_sized"] pub trait MetaSized: PointeeSized {}
#[lang = "sized"] pub trait Sized: MetaSized {}
#[lang = "copy"] pub trait Copy {}
impl<T: PointeeSized> Copy for &T {}
#[no_mangle]
pub fn ref_of_local(f: fn(&i32)) {
    let i = 0;
    f(&i);
}
