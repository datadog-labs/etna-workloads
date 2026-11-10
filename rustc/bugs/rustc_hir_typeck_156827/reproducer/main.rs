fn foo<T: Into<f32>>(_: T) {}
fn main() {
    foo(0.);
}
