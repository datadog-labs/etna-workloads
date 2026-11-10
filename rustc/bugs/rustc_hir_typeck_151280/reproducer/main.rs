mod m {
    pub struct S { pub visible: u8, hidden: u8 }
    impl S { pub fn new() -> S { S { visible: 0, hidden: 0 } } }
}
fn main() {
    let m::S {
        visible,
    } = m::S::new();
}
