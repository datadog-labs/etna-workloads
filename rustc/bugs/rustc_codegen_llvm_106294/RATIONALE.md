# Verbatim injection for Put `noundef` on all scalars that don't allow uninit

Fix: https://github.com/rust-lang/rust/commit/645c0fddd2e0446cc0e6eecd8a78de4b5ab5a967

The injection is the reverse of the fix's implementation hunks, applied to 1.99.1 (fuzzy-patch).
