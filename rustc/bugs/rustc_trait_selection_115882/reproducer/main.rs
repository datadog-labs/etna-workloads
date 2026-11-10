struct Inv<'a>(Option<*mut &'a u8>);
fn check_bound<'a, T: 'a>(_: T, _: Inv<'a>) {}
trait Trait3<T> {
    fn foo<'a>(arg: T, lt: Inv<'a>) {
        check_bound(arg, lt)
    }
}
fn main() {}
