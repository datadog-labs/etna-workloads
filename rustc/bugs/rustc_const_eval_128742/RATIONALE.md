# Verbatim injection for interpret: make identity upcasts a NOP again to avoid them generating a new random vtable

Fix: https://github.com/rust-lang/rust/commit/9a233bb9dd0783b4819650ed87112dbaf944f353

The injection is the reverse of the fix's implementation hunks, applied to 1.99.1 (fuzzy-C1).
