extern crate dep;
use dep::NegSizedTr;
struct X<T>(T);
impl<T: ?Sized> NegSizedTr for X<T> {}
