# Verbatim injection for Replace walk with visit so we dont skip outermost expr kind in def collector

Fix: https://github.com/rust-lang/rust/commit/7ab44cddc9320f1dfdef40916f33c6f3e83876e6

The injection is the reverse of the fix's implementation hunks, applied to 1.99.1 (fuzzy-patch).
