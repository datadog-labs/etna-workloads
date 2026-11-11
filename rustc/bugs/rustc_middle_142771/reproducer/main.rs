pub struct Foo { a: i32, b: i64, c: i32 }
#[inline(never)]
pub fn f(foo: &Foo, v: &mut bool) -> i32 {
    let x = 3;
    let a = &foo.a;
    if x == 3 {
        *v = true;
        let b = &foo.b;
        if x > 1 {
            let c = &foo.c;
            return foo.c;
        }
    }
    0
}
