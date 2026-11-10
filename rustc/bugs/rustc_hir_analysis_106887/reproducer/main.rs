struct Wrapper<T>(T);
fn bar() -> _ { Wrapper(foo) }
fn foo() {}
fn main() {}
