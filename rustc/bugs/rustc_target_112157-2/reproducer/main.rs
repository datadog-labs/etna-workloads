#![feature(no_core, lang_items, repr_simd, simd_ffi, rustc_attrs)]
#![allow(internal_features, improper_ctypes)]
#![crate_type = "lib"]
#![no_core]
#[lang = "pointee_sized"] trait PointeeSized {}
#[lang = "meta_sized"] trait MetaSized: PointeeSized {}
#[lang = "sized"] trait Sized: MetaSized {}
#[lang = "copy"] trait Copy {}
#[repr(simd)] pub struct V([i32; 4]);
#[repr(C)] pub struct Foo { a: V, b: i8 }
#[repr(C)] pub struct Double { one: Foo, two: Foo }
extern "C" {
    fn g(x: Double);
}
pub unsafe fn h(x: Double) { g(x) }
