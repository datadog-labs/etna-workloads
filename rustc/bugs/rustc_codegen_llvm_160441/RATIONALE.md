# Verbatim injection for PowerPC inline ASM: Fix scalar floats being in the wrong vector lane on little endian

Fix: https://github.com/rust-lang/rust/commit/325add27ec6acc63e44604f06766e956b032b6bc

The injection is the reverse of the fix's implementation hunks, applied to 1.99.1 (clean).
