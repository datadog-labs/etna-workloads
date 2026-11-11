struct S;
fn main() {
    let mut s = S;
    let x = &raw const s;
    let _: &S = unsafe { *x };
    let x = &raw mut s;
    let _: &mut S = unsafe { *x };
}
