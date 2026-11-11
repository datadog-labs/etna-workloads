extern crate foreign;
pub struct Local;
pub trait Identity { type Output; }
impl<T> Identity for T { type Output = T; }
impl<T> foreign::Trait0<Local, T, ()> for <T as Identity>::Output {}
fn main() {}
