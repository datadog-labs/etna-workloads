# Adapted injection for unify two -Ctarget-feature parsers

Fix: https://github.com/rust-lang/rust/commit/e46c234ca4ccbad085f11de7ca1cd25a40431b22

# Rationale
File: compiler/rustc_codegen_ssa/src/target_features.rs, fn `flag_to_backend_features` (closure passed to `parse_rust_feature_list`).

Re-expresses the fix hunk `@@ -289,85 +321,82 @@ pub fn flag_to_backend_features`, which replaced the old loop
`rust_features.push((false, feature));` ("FIXME: Why do we not remove implied features on "-" here?", issue 134792)
with `parse_rust_feature_list` output, so the reverse implications of a negated feature (`new_features`) are forwarded to the backend.
In 1.99.1 the parsers are already unified; the bug is restored by forwarding only `base_feature` for negated features
(the reverse-implied set is discarded), as before the fix.
