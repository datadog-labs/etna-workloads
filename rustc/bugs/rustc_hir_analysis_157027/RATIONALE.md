# Adapted injection for Move distractingly lengthy error reporting code into new `report_ambiguous_assoc_item`

Fix: https://github.com/rust-lang/rust/commit/fd36a801b1ea39cc9a251058aa231de09d844f99

# Rationale
File: compiler/rustc_hir_analysis/src/hir_ty_lowering/mod.rs, fn probe_single_bound_for_assoc_item.
The error-reporting move (report_ambiguous_assoc_item) already exists in 1.99.1. What remains is the fix's behavioural part, hunk `@@ -1297,137 +1294,21 @@`: the new code does `return Err(self.report_ambiguous_assoc_item(...))` unconditionally; the old code did `err.emit();` and fell through to `Ok(bound)` (returning the first candidate) unless where_bounds (equality-constraint case) was non-empty. I re-expressed it: report the error, only return Err when `constraint.is_some()`, otherwise fall through to `Ok(bound1)`. This leaks a nonsensical type (for ambiguous RTN `T::f(..)`) to later passes, triggering the "not enough bound vars" debug assertion.
