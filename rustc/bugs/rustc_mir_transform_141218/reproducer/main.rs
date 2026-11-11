#![feature(custom_mir, core_intrinsics)]
use std::intrinsics::mir::*;
pub enum Adt { None, Some(u32) }
#[custom_mir(dialect = "runtime")]
pub fn overlapping(_1: Adt) {
    mir! {
        let _2: &mut Adt;
        let _3: u32;
        let _4: &Adt;
        {
            _2 = &mut _1;
            _4 = &(*_2);
            _3 = Field(Variant((*_4), 1), 0);
            (*_2) = Adt::Some(_3);
            Return()
        }
    }
}
fn main() { overlapping(Adt::Some(0)); }
