#![feature(custom_mir, core_intrinsics)]
use std::intrinsics::mir::*;
enum E<T> { A, B(T) }
#[custom_mir(dialect = "runtime")]
pub fn f() -> usize {
    mir! {
        let a: isize;
        let e: E<char>;
        {
            e = E::A;
            SetDiscriminant(e, 1);
            a = Discriminant(e);
            match a { 0 => bb0, _ => bb1 }
        }
        bb0 = { RET = 0; Return() }
        bb1 = { RET = 1; Return() }
    }
}
fn main() { println!("{}", f()); }
