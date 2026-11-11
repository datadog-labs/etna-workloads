extern crate aux;
struct S;
impl aux::PrivateTrait for S {
    const FOO: usize = 1;
    fn nonexistent() {}
}
fn main() {}
