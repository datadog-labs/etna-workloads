use std::convert::TryFrom;
struct D;
enum ParseError {}
fn f<T>() where T: Clone, <T as TryFrom<String>>::Error: ParseError {}
fn main() {}
