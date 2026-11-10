#![allow(dead_code)]
trait Trait { type Assoc; }
impl Trait for u32 {
    type Assoc where u32: Copy = ();
}
fn main() {}
