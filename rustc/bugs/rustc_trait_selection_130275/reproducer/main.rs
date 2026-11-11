extern crate samename;
pub trait Test {}
struct A;
impl Test for A {}
fn needs_test(_: impl Test) {}
fn main() {
    needs_test(samename::B);
}
