
static S: usize = 42;

pub fn f() -> &'static usize {
    &S
}
