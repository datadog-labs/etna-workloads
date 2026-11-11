#![deny(for_loops_over_fallibles)]
extern crate dep;
fn main() {
    let _name = Some(1);
    dep::do_loop!(_name);
}
