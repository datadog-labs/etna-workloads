struct S;
trait X {}
impl X for S {}
fn foo<T: X>(_: &T) {}
fn main() {
    let hello = &S;
    foo(*hello);
}
