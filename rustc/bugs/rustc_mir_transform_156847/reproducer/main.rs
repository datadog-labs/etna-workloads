#![warn(unused)]
struct Foo { r#move: i32 }
fn main() {
    let y = Foo { r#move: 3 };
    let _ = match y { Foo { r#move } => 0 };
}
