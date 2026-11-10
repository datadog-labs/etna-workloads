#![crate_type = "lib"]
#![feature(no_core, lang_items)]
#![no_core]
#[lang = "pointee_sized"] pub trait PointeeSized {}
#[lang = "meta_sized"] pub trait MetaSized: PointeeSized {}
#[lang = "sized"] pub trait Sized: MetaSized {}
#[lang = "copy"] pub trait Copy {}
impl Copy for bool {}
#[inline(never)] fn opaque() {}
#[inline(never)] fn opaque2() {}
#[inline(never)] fn syncthreads() {}
pub fn function(cond: bool) {
    if cond { opaque(); } else { opaque2(); }
    syncthreads();
    if cond { opaque(); } else { opaque2(); }
}
