# Verbatim injection for const: don't ICE when encountering a mutable ref to immutable memory

Fix: https://github.com/rust-lang/rust/commit/7dfffe7e70b49777cfc4bf394eeafc27c1a36c18

The injection is the reverse of the fix's implementation hunks, applied to 1.99.1 (fuzzy-patch).
