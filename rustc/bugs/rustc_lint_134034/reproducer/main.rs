#![deny(unused_parens)]
macro_rules! x { () => { None::<i32> }; }
fn main() {
    let Some(_) = (x!{}) else { return };
}
