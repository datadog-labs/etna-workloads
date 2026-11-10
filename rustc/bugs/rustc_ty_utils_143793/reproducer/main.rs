#![feature(checked_type_aliases)]
#![allow(incomplete_features)]
struct Hold([(); { type Recur = Recur; 0 }]);
fn main() {}
