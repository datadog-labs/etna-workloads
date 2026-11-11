#![deny(if_let_rescope)]
struct Droppy;
impl Drop for Droppy { fn drop(&mut self) {} }
fn droppy() -> Droppy { Droppy }
fn main() {
    if let Some(_value) = Some((droppy(), ()).1) {} else {}
}
