# Adapted injection for Improve diagnostic for wrong borrow on binary operations

Fix: https://github.com/rust-lang/rust/commit/ad0729e9d21127ba15aa3d927c057b4442156631

# Rationale
File compiler/rustc_hir_typeck/src/op.rs, fn `suggest_deref_binop_or_borrow` area (the function containing the `ty::Ref(region, lhs_deref_ty, mutbl)` BinOp branch, ~line 583).
Fix hunk `@@ -429,15 +489,60 @@`: the fix changed `let Ref(_, lhs_deref_ty, _)` to `Ref(region, lhs_deref_ty, mutbl)` and added an `else` branch (when lhs deref type is not Copy) calling `suggest_different_borrow` for inverted mutability on lhs / rhs / both.
Reinjected bug: removed that `else` branch and restored the `Ref(_, lhs_deref_ty, _)` pattern, so no "an implementation for ... exists" note or reborrow suggestions are emitted. The helper `suggest_different_borrow` stays (now unused-ish; warning only), corresponding to the fix's first hunks adding it.
