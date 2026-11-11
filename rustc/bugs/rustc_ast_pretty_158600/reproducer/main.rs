#![feature(const_trait_impl)]
trait T {}
const impl<X> T for Vec<X> {}
fn main() {}
