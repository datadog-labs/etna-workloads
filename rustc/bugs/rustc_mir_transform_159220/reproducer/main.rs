
#![feature(custom_mir, core_intrinsics)]

extern crate core;
use core::intrinsics::mir::*;

#[custom_mir(dialect = "runtime", phase = "post-cleanup")]
pub fn dont_opt_storage_dead_in_loop(input: u32) {
    mir! {
        let a: u32;
        let cmp: bool;
        {
            StorageLive(a);
            a = input;
            Goto(bb1)
        }
        bb1 = {
            Goto(bb2)
        }
        bb2 = {
            cmp = a == 123;
            StorageDead(a);
            match Move(cmp) {
                true => bb1,
                _ => bb3,
            }
        }
        bb3 = {
            Return()
        }
    }
}

fn main() {}
