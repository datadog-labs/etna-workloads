
pub struct Bar;

impl __DocHidden::Foo for Bar {
    fn foo() {}
}

#[doc(hidden)]
pub mod __DocHidden {
    pub use aa::Foo;
}
