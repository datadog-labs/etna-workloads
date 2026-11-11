#![feature(const_trait_impl)]
struct ConstDrop;
const impl Drop for ConstDrop {
    fn drop(&mut self) {}
}
const fn test() {
    let _ = ConstDrop;
}
