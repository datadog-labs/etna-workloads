#![feature(staged_api)]
#![stable(feature = "libfoo", since = "1.0.0")]
#[stable(feature = "libfoo", since = "1.0.0")]
pub struct Foo;
impl Foo {
    #[unstable(feature = "foo", reason = "...", issue = "none")]
    pub fn foo(&self) {}
}
