trait ConstDefault { const fn const_default() -> Self; }
const fn foo() -> &'static u8 {
    const C: u8 = 1u8
    &C
}
fn main() {}
