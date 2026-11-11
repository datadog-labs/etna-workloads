trait Trait {
    async fn foo();
    async fn bar() -> i32;
}
struct S;
impl Trait for S {}
fn main() {}
