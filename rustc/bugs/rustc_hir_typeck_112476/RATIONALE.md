# Adapted injection for Do not offer any of the suggestions in emit_coerce_suggestions for expr from destructuring assignment desugaring

Fix: https://github.com/rust-lang/rust/commit/33f73c2e939afb9c71555735acef2ee20e4f10bd

# Rationale
File compiler/rustc_hir_typeck/src/demand.rs, fn `emit_coerce_suggestions`: removed
`if self.is_destruct_assignment_desugaring(expr) { return; }` before `emit_type_mismatch_suggestions`.
Re-expresses fix hunk `@@ -83,6 +83,10 @@ ... emit_coerce_suggestions` (added that early return). Other hunks (helper fn, make_sugg) are not needed to bring the bug back; the helper is now unused.
