# Verbatim injection for don't fire `unused_mut` on `&pin mut self`

Fix: https://github.com/rust-lang/rust/commit/7f51ec6773ed4b22badd0c6a7c53266ca96a05b8

The injection is the reverse of the fix's implementation hunks, applied to 1.99.1 (clean).
