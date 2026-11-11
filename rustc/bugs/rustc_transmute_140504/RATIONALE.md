# Adapted injection for transmutability: uninit transition matches unit byte only

Fix: https://github.com/rust-lang/rust/commit/88a86794b9e5bcda28b8f89e6b6264bb7bc042c4

# Rationale
File: compiler/rustc_transmute/src/layout/mod.rs, `Byte::uninit()`.
Re-expresses the fix hunk `@@ -6,61 +6,61 @@` in layout/mod.rs, where
`pub(crate) fn uninit() -> Byte { Byte { range: None } }` became
`fn uninit() -> Byte { Byte { start: 0, end: Self::UNINIT + 1 } }`
(uninit transition accepts any byte value, so `Tree::uninit` is valid for any value).
Buggy parent behaviour restored: uninit matches only the uninit byte (`start: UNINIT, end: UNINIT+1`), so init bytes can't match uninit transitions in the DFA union.
