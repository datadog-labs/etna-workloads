struct Stuff { count: i32 }
fn demo_unwrap() -> Stuff {
    let count = Some(1);
    Stuff { count }
}
fn main() {}
