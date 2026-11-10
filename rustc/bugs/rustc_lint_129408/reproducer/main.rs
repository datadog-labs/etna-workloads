#![deny(dropping_copy_types)]
macro_rules! m { ($e:expr) => { drop($e); }; }
fn main() {
    let x = 1u32;
    m!(x);
    drop(x);
}
