fn direct_tuple_struct() {
    struct Foo(bool);
    struct Bar(Foo);
    _ = Bar(false);
}
fn main() {}
