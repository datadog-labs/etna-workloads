struct Foo<'a, 'b>(&'a u8, &'b u8);
fn missing(_: &str) -> Foo { loop {} }
fn main() {}
