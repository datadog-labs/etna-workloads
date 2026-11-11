# Verbatim injection for Suppress unused_mut lint if mutation fails due to borrowck error

Fix: https://github.com/rust-lang/rust/commit/5405e5d06e7b2fede8cfba16a5bd140a8ebeb4f0

The injection is the reverse of the fix's implementation hunks, applied to 1.99.1 (clean).
