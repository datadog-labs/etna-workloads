#![crate_type="lib"]
pub fn f(x: &[u8; 1], y: [u8; 1]) -> bool {
    let a = &x[0];
    let b = &y[0];
    *a == *b
}
pub fn g(a: &[u8], i: usize) -> u8 {
    let j = i + 1;
    let r = &a[j];
    *r
}
