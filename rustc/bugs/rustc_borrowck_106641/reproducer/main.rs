struct S;
impl S {
    fn foo(&mut self) {
        let y = || {
            self.bar();
        };
        self.qux();
        y();
    }
    fn bar(&self) {}
    fn qux(&mut self) {}
}
fn main() { S.foo(); }
