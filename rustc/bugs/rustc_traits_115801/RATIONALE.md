# Adapted injection for Detect cycle errors hidden by opaques during monomorphization

Fix: https://github.com/rust-lang/rust/commit/8fbd78ccea0e462be3d3745923d5aed8a451dc62

# Rationale
File: compiler/rustc_traits/src/normalize_projection_ty.rs, fn normalize_canonicalized_projection.
Fix hunk `@@ -40,6 +43,27 @@ fn normalize_projection_ty` added a `// #112047` block that runs select_where_possible
(now `ocx.try_evaluate_obligations()`) after registering obligations, reports `report_overflow_obligation_cycle`
for cycle errors (non-rustdoc) and returns `Err(NoSolution)`. I removed that block (the buggy parent behaviour),
so cycle errors hidden by opaques are not detected during monomorphization normalization.
Also removed the now-unused imports (the fix's `@@ -3,10 +3,13 @@` import hunk): `InferCtxtErrorExt`, `ScrubbedTraitError`.
