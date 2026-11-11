struct A;
struct B;
impl From<A> for B { fn from(_: A) -> Self { B } }
fn foo1(x: Result<(), A>) -> Result<(), B> {
    x
}
fn main() {}
