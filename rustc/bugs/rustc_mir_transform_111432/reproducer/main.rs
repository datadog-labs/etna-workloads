#![feature(custom_mir, core_intrinsics)]
extern crate core;
use core::intrinsics::mir::*;

#[custom_mir(dialect = "runtime", phase = "post-cleanup")]
pub fn main() {
    mir! (
        let x: (isize, );
        {
            x.0 = 1;
            Return()
        }
    )
}
