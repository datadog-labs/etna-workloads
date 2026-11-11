#![feature(type_alias_impl_trait)]
pub type Foo = impl Sized;

#[cfg_attr(rpass1, define_opaque())]
#[cfg_attr(bfail2, define_opaque(Foo))]
fn a() {
    let _: Foo = b();
}

#[define_opaque(Foo)]
fn b() -> Foo {
    ()
}

fn main() {}
