mod a { pub type C = u8; }
mod b { pub type C = u16; }
pub use a::*;
pub use b::*;
