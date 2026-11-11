use std::ops::Deref;
struct MyBox<T>(T);
impl<T> Deref for MyBox<T> { type Target = T; fn deref(&self) -> &T { &self.0 } }
fn main() {
    let _x = MyBox(vec![1, 2]).into_iter();
}
