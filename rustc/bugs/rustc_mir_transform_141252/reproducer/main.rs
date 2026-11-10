#![feature(custom_mir, core_intrinsics)]
use std::intrinsics::mir::*;

#[custom_mir(dialect = "runtime")]
#[inline(never)]
pub fn repeat_place(mut idx1: usize, idx2: usize, val: &i32) -> i32 {
    mir! {
        let array;
        let elem;
        {
            array = [*val; 5];
            elem = &array[idx1];
            idx1 = idx2;
            RET = *elem;
            Return()
        }
    }
}

fn main() {
    println!("{}", repeat_place(0, 5, &0));
}
