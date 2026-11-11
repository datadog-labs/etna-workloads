pub enum Foo { X, Y }
pub fn typo1(foo: Foo) -> Foo {
    use Foo::*;
    match foo {
        X => Y.
        Y => X,
    }
}
fn main() {}
