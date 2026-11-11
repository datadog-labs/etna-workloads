struct AllCopy { a: i32, b: u64, c: [i8; 3] }
#[inline(never)]
fn all_copy_mut(mut_v: &mut AllCopy) -> AllCopy {
    let v = &*mut_v;
    let a = v.a;
    let b = v.b;
    let c = v.c;
    mut_v.a = 0;
    AllCopy { a, b, c }
}
fn main() {
    let mut x = AllCopy { a: 5, b: 6, c: [1, 2, 3] };
    let r = all_copy_mut(&mut x);
    println!("{} {} {:?} / {}", r.a, r.b, r.c, x.a);
}
