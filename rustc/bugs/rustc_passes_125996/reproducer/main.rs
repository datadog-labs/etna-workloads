extern crate aux;
static K: fn() -> fn() = aux::K;
fn main() { K()(); println!("ok"); }
