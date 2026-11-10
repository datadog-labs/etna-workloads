fn foo() {}
fn main() {
    let x = &mut 1;
    foo()
    *x = 0;
}
