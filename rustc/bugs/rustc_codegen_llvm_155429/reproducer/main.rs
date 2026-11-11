#![feature(no_core, lang_items, intrinsics, rustc_attrs)]
#![no_core]
#![crate_type = "lib"]
extern crate minicore;
use minicore::*;

#[lang = "va_arg_safe"]
pub unsafe trait VaArgSafe {}
unsafe impl VaArgSafe for i128 {}

#[repr(transparent)]
struct VaListInner { ptr: *const c_void }

#[repr(transparent)]
#[lang = "va_list"]
pub struct VaList<'a> { inner: VaListInner, _marker: PhantomData<&'a mut ()> }

#[rustc_intrinsic]
#[rustc_nounwind]
pub const unsafe fn va_arg<T: VaArgSafe>(ap: &mut VaList<'_>) -> T;

#[unsafe(no_mangle)]
unsafe extern "C" fn read_i128(ap: &mut VaList<'_>) -> i128 {
    va_arg(ap)
}
