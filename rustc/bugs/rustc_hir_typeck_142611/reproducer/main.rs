extern crate ext;
use std::ops::ControlFlow;
fn main() {
    let x: Result<i32, i32> = Err(1);
    let _ = match x {
        Err(r) => ControlFlow::Break(r),
        Ok(r) => { ext::unit!() }
    };
}
