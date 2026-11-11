# Adapted injection for Don't report E0740 for type error

Fix: https://github.com/rust-lang/rust/commit/08e5a77b069dc55481fef6a415c5bb8f056c00c9

# Hunk: compiler/rustc_hir_analysis/src/check/check.rs, `allowed_union_or_unsafe_field`
Re-expresses fix hunk `@@ -114,9 +114,11 @@ fn check_union_fields` which added `|| ty.references_error()`
("also no need to report an error if the type is unresolved") to the allowed-union-field check.
In 1.99.1 the logic moved to `allowed_union_or_unsafe_field`; I added an early `if ty.references_error() { return false; }`,
so unresolved field types are again treated as not-Copy and an extra E0740 is emitted.
