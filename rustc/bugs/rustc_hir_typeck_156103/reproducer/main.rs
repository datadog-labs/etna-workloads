struct Foo;
impl Drop for Foo { fn drop(&mut self) {} }
fn main() {
    let mut f = Foo;
    Drop::drop(&mut f);
}
