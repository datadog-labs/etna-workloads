# Adapted injection for Don't allow DispatchFromDyn impls that transmute ZST to non-ZST

Fix: https://github.com/rust-lang/rust/commit/11bc805369b7e2aa641e885c137b2c86ce701e2c

# Rationale
File: compiler/rustc_hir_analysis/src/coherence/builtin.rs, fn visit_implementation_of_dispatch_from_dyn.
Re-expresses fix hunk `@@ -267,20 +267,20 @@ fn visit_implementation_of_dispatch_from_dyn`: the fix moved the 1-ZST
(`layout.is_1zst() && !ty_a.has_non_region_param()`) ignore check inside `if ty_a == ty_b {`.
The bug re-injection hoists it back out, before `if ty_a == ty_b`, so a field whose type is a ZST in A but
differs in B (ZST -> non-ZST transmute) is silently ignored.
