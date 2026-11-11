struct S;
impl S {
    fn assoc_func(&self, _f: impl Fn()) -> usize { 0 }
}
fn main() {
    let s = S;
    let mut x = ();
    s.assoc_func(|| x = ());
}
