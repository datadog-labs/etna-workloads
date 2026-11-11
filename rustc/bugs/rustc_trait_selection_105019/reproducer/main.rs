fn foo(x: &str) -> bool {
    x.starts_with("hi".to_string() + " you")
}
fn main() { foo("a"); }
