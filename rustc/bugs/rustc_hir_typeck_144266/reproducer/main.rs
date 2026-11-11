extern crate ext;
pub fn foo<I: Iterator>(mut iter: I, value: &I::Item)
where Item: Eq + std::fmt::Debug,
{
    ext::eq!(assert iter.next(), Some(value));
}
fn main() {}
