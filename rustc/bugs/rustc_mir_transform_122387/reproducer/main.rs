pub enum O2<T> { Some(T), None, Other }
#[inline(never)]
pub fn f(x: O2<u32>, y: O2<u32>) -> u32 {
    match (x, y) {
        (O2::Some(a), O2::Some(b)) => a + b,
        (O2::None, O2::None) => 1,
        (O2::Other, O2::Other) => 2,
        _ => 3,
    }
}
fn main() { f(O2::None, O2::None); }
