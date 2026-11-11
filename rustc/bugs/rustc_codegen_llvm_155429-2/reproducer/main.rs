#![feature(no_core, lang_items, intrinsics, rustc_attrs, auto_traits)]
#![no_core]
#![crate_type = "lib"]

#[lang = "pointee_sized"]
pub trait PointeeSized {}
#[lang = "meta_sized"]
pub trait MetaSized: PointeeSized {}
#[lang = "sized"]
pub trait Sized: MetaSized {}
#[lang = "legacy_receiver"]
pub trait LegacyReceiver {}
impl<T: PointeeSized> LegacyReceiver for &mut T {}
#[lang = "freeze"]
pub unsafe auto trait Freeze {}
#[lang = "unpin"]
pub auto trait Unpin {}
#[lang = "destruct"]
pub trait Destruct {}
#[lang = "unsafe_unpin"]
pub unsafe auto trait UnsafeUnpin {}
#[lang = "copy"]
pub trait Copy {}
#[lang = "phantom_data"]
pub struct PhantomData<T: PointeeSized>;
pub enum c_void {}

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
pub unsafe fn va_arg<T: VaArgSafe>(ap: &mut VaList<'_>) -> T;

#[unsafe(no_mangle)]
unsafe extern "C" fn read_i128(ap: &mut VaList<'_>) -> i128 {
    va_arg(ap)
}
