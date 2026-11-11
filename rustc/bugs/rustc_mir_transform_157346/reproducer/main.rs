pub struct S<'a>(pub &'a u8);
#[inline(never)]
pub fn field_borrow(a: &S<'_>) {
    let _b = a.0;
    let _c = a.0;
}
fn main() { let x = 1; field_borrow(&S(&x)); }
