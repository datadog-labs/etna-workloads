#![deny(dropping_copy_types)]
fn main() {
    drop(format_args!("a"));
}
