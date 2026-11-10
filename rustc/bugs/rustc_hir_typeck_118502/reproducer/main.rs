struct A {}
impl A {
    fn hello(self, _x: i32) {}
    fn test(_x: i32) {}
}
fn main() {
    let _a = A {};
    _a.hello(1);
    _a.test(1);
}
