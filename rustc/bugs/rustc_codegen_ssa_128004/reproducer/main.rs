#![crate_type = "lib"]
#![feature(no_core, lang_items, rustc_attrs, asm_experimental_arch, arm_target_feature)]
#![no_core]
#[lang = "pointee_sized"] pub trait PointeeSized {}
#[lang = "meta_sized"] pub trait MetaSized: PointeeSized {}
#[lang = "sized"] pub trait Sized: MetaSized {}
#[rustc_builtin_macro] macro_rules! naked_asm { ($($t:tt)*) => {} }
#[no_mangle]
#[unsafe(naked)]
#[instruction_set(arm::t32)]
pub extern "C" fn test_thumb() { naked_asm!("bx lr"); }
#[no_mangle]
#[unsafe(naked)]
#[instruction_set(arm::a32)]
pub extern "C" fn test_arm() { naked_asm!("bx lr"); }
