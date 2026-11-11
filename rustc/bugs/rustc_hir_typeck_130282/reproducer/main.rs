use std::ops::Deref;
struct Wrap<T>(T);
impl<T> Deref for Wrap<T> {
    type Target = Wrap<Wrap<T>>;
    fn deref(&self) -> &Self::Target { todo!() }
}
fn main() {
    Wrap(1).lmao();
}
