trait Trait { fn foo() -> S where Self: Sized { S } }
struct S;
impl Trait for &mut S {}
fn main() {
    let _ = &str::from("value");
    let _ = &mut S::foo();
}
