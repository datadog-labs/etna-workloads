# Verbatim injection for recommend using a HashMap if a HashSet's second generic parameter doesn't implement BuildHasher

Fix: https://github.com/rust-lang/rust/commit/754a82d87c8e1d2561b471e0664be252193644a4

The injection is the reverse of the fix's implementation hunks, applied to 1.99.1 (fuzzy-patch).
