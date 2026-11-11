# Verbatim injection for const-eval: do not call `immediate_const_vector` on vector of pointers

Fix: https://github.com/rust-lang/rust/commit/71f34429ac7cb65a00ec413a546ad760f6c6aa91

The injection is the reverse of the fix's implementation hunks, applied to 1.99.1 (clean).
