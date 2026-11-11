# Verbatim injection for fix: don't suggest .into_iter() for .cloned()/.copied() on non-reference Option

Fix: https://github.com/rust-lang/rust/commit/4049f43ef928470e2bef3d24fbb305b55785ee53

The injection is the reverse of the fix's implementation hunks, applied to 1.99.1 (clean).
