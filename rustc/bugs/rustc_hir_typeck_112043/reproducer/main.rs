fn f(x: i32) -> Result<(), Box<dyn std::error::Error>> {
    Err(format!("error: {x}"))
}
fn main() { let _ = f(1); }
