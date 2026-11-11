# Adapted injection for Don't reject *multiple* relaxed bounds, reject *duplicate* ones.

Fix: https://github.com/rust-lang/rust/commit/cdc3d701cb4ff37e9d0c96c1c68b2e8789c19441

# Rationale
One hunk: compiler/rustc_ast_lowering/src/lib.rs, `validate_relaxed_bound`, `RelaxedBoundPolicy::Allowed` arm.
In 1.99.1 the check moved from hir_analysis `check_and_report_invalid_relaxed_bounds` to AST lowering, keyed by trait DefId (`dedup_map`).
This re-expresses the fix hunk in hir_ty_lowering/errors.rs (`@@ -35,31 +35,29 @@`), which replaced
`if relaxed_bounds.len() > 1 { emit MultipleRelaxedDefaultBounds }` with per-trait grouping (`grouped_bounds.entry(trait_def_id)`, "duplicate relaxed `{name}` bounds").
The bug: any second relaxed bound (even of a different trait, e.g. `?Sized + ?Iterator`) is now reported as E0203, with the old message
"type parameter has more than one relaxed default bound, only one is supported" (removed .ftl/errors.rs text in the fix, inlined here as a string).
