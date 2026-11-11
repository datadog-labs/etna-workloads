struct Test { a: i32 }
impl Test { fn add(&mut self, n: i32) { self.a += n; } }
fn main() {
    let mut tests = Vec::new();
    tests.push(Test { a: 1 });
    for test in &tests {
        test.add(2);
    }
}
