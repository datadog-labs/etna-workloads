#![feature(checked_type_aliases)]
#![allow(incomplete_features)]
struct Struct<T>(eager::Alias<T>);
fn main() {
    let _: eager::Alias<String>;
}
