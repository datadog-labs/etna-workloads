struct A;
struct B;
impl From<B> for A { fn from(_: B) -> A { A } }
struct Demo { a: A }
fn main() {
    let a = B;
    let _s = Demo { a };
}
