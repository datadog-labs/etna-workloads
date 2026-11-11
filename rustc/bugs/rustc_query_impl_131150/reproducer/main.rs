extern crate alias;

use alias::Trait;
struct S;
impl Trait for S {
    type T = ();
}
struct A((A, <S as Trait>::T<NOT_EXIST?>));

fn main() {}
