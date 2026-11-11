pub use my_mod::Foo;
mod my_mod {
    pub struct Foo(u32);
    mod my_sub_mod {
        fn my_func() {
            let crate::Foo(x) = crate::Foo(42);
        }
    }
}
fn main() {}
