fn f() -> i32 {
    match 1 {
        x => dbg!(x),
    }
    todo!()
}
fn main() { f(); }
