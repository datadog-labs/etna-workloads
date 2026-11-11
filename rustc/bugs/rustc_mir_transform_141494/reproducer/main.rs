#[inline(never)]
pub fn f(i: char) -> u8 {
    match i { 'a' => 97, 'b' => 98, _ => unsafe { std::hint::unreachable_unchecked() } }
}
fn main() {
    println!("{}", f('b'));
}
