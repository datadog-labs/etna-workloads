#![feature(no_core, lang_items)]
#![allow(internal_features)]
#![no_std]
#![no_core]
#[lang = "pointee_sized"] pub trait PointeeSized {}
#[lang = "meta_sized"] pub trait MetaSized: PointeeSized {}
#[lang = "sized"] pub trait Sized: MetaSized {}
#[lang = "copy"] pub trait Copy {}

#[repr(C, align(2))]
pub struct Example([u8; 0x7fffffff]);

pub fn lib(_x: Example) {}
