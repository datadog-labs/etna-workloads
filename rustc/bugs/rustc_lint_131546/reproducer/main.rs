#![deny(unused_parens)]
pub fn foo() -> impl Fn() {
    let _ = (#[inline] #[allow(dead_code)] || println!("Hello!"));
    (#[inline] #[allow(dead_code)] || println!("Hello!"))
}
fn main() { foo()(); }
