mod really_really_really_long_module {
    pub trait FooBar {
        type Assoc: FooBar;
        type Wrapper<T>: FooBar;

        fn assoc(&self) -> Self::Assoc;
        fn wrap<T>(&self, value: T) -> Self::Wrapper<T>;
    }
}

use really_really_really_long_module::*;

fn foo<'a, T: FooBar>(
    value: T
) -> <
    <
        <T::Wrapper<T> as FooBar>::Assoc as FooBar
    >::Assoc as FooBar
>::Wrapper<<T::Assoc as FooBar>::Assoc>
{
    // Ensure that we only highlight `FooBar::Wrapper` vs `FooBar::Assoc` in the E0308, instead of
    // the whole type for both expected and found.
    value.assoc().assoc().assoc().wrap(value.assoc().assoc())
}

fn main() {}
