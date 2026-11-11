struct D<'a>(&'a ());
impl<'a> Drop for D<'a> { fn drop(&mut self) {} }
impl<'a> D<'a> { fn end(&self) -> usize { 0 } }
macro_rules! perform { ($e:expr) => { D(&$e).end() } }
fn main() {
    { let l = (); perform!(l) };
}
