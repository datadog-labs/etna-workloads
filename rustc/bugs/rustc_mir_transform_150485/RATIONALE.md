# Verbatim injection for GVN: Do not introduce new dereferences if they borrow from non-SSA locals

Fix: https://github.com/rust-lang/rust/commit/bc2bf6b544be9e4140bf77db4491ecfc9487764e

The injection is the reverse of the fix's implementation hunks, applied to 1.99.1 (fuzzy-C1).
