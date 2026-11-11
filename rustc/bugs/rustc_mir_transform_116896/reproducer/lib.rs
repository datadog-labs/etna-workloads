#![crate_type = "lib"]
macro_rules! emit { ($($m:ident)*) => {$( pub mod $m { pub fn main() { let func = || 123u8; func(); } } )*}; }
emit!(m00 m01 m02 m03 m04 m05 m06 m07 m08 m09 m10 m11 m12 m13 m14 m15 m16 m17 m18 m19);
