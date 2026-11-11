trait Trait { type Out; fn mk() -> Self::Out; }
struct Constructor(i32);
impl Trait for () {
    type Out = Constructor;
    fn mk() -> Self::Out { Self::Out(1) }
}
fn main() {}
