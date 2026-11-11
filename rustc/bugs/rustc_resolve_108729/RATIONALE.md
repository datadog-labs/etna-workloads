# Adapted injection for fix: modify the condition that `resolve_imports` stops

Fix: https://github.com/rust-lang/rust/commit/177572241076e4885c5c12e407d3ea10d3b2363f

# Rationale
compiler/rustc_resolve/src/imports.rs, `resolve_imports`: restored the old loop condition.
Re-expresses fix hunk `@@ -423,13 +423,17 @@ ... pub(crate) fn resolve_imports`, which replaced
`prev_num_indeterminates = len()+1; while len() < prev_num_indeterminates` with a
per-namespace indeterminate count (`indeterminate_count < prev_indeterminate_count`).
Now the fixed-point loop stops when the number of indeterminate imports (not the count of
indeterminate namespaces) stops decreasing, so nested `use foo as bar` via macros stop early.
(In 1.99.1 resolve_import already returns a count; only the loop condition was reverted.)
