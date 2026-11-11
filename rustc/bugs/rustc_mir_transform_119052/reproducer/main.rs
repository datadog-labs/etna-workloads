#[inline(never)]
fn f<T: Copy>(x: &[T]) -> T {
    let a = u64::MAX as usize;
    if a < x.len() { x[a] } else { x[0] }
}
fn main() { println!("{}", f(&[5, 3])); }
