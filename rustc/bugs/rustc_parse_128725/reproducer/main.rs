macro_rules! c { ($e:expr) => { stringify!($e) }; }
macro_rules! s { ($s:stmt) => { stringify!($s) }; }
fn main() {
    println!("{}", c!(#[aa] 1 + 2));
    println!("{}", s!(#[aa] 1 as u32));
}
