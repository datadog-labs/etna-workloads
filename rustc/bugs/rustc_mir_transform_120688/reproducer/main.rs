
#![feature(custom_mir, core_intrinsics)]
extern crate core;
use core::intrinsics::mir::*;

#[custom_mir(dialect = "runtime", phase = "initial")]
fn fn0() {
    mir! {
        let a: usize;
        let b: [u128; 6];
        let c: ([u128; 6],);
        let d: ([u128; 6],);
        let x: ();
        {
            a = 1_usize;
            b = [42; 6];
            b[a] = 1;
            c = (b,);
            d = c;
            Call(x = fn1(Move(c.0), d), ReturnTo(bb1), UnwindUnreachable())
        }
        bb1 = {
            Return()
        }
    }
}

#[inline(never)]
fn fn1(a: [u128; 6], mut b: ([u128; 6],)) {
    b.0 = [0; 6];
}

fn main() {
    fn0();
}

