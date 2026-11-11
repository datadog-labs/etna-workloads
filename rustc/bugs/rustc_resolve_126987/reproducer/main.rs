macro_rules! mac { () => { "" } }
macro_rules! mac2 { () => { "x.rs" } }
std::arch::global_asm!(mac!());
include!(mac2!());
fn main() {}
