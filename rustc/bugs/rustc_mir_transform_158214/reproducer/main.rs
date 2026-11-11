#[inline(never)]
pub fn f(x: u32) -> u32 {
    if x == 42 { 0 } else { 1 }
}
pub fn main() {
    println!("{} {}", f(42), f(1));
}
