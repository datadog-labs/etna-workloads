# Adapted injection for repr(transparent): do not consider repr(C) types to be 1-ZST

Fix: https://github.com/rust-lang/rust/commit/b9b29c4379c81e3b744ce1275684d3556c08d982

# Rationale
File: compiler/rustc_hir_analysis/src/check/check.rs, fn check_transparent (inner `is_trivial` traversal, ADT arm).
Removed `if def.repr().c() { return ControlFlow::Break(NonTrivialReason::ReprC { ty }); }`.
Re-expresses fix hunk `@@ -1550,28 +1563,36 @@` which added
`if def.repr().c() { return ControlFlow::Break(UnsuitedInfo { ty, reason: UnsuitedReason::ReprC }); }`.
Without it, repr(C) ZSTs are again treated as ordinary 1-ZSTs in repr(transparent) fields (no lint).
The lint rename/level/message hunks are not reproduced (they don't constitute the bug).
