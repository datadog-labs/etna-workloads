# Verbatim injection for Fix backtraces with `-C panic=abort` on linux; emit unwind tables by default

Fix: https://github.com/rust-lang/rust/commit/fe66eaa67acc47525db6f13cf97d54780d87b805

The injection is the reverse of the fix's implementation hunks, applied to 1.99.1 (fuzzy-patch).
