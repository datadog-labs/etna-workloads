# Adapted injection for Reject linked dylib EII default overrides

Fix: https://github.com/rust-lang/rust/commit/0c822870613e7025f724802f1af6bdbc755a023f

# Rationale
1.99.1 already contains an earlier form of the link-time EII check (separate `default_impl`, `check_externally_implementable_item_linkage`), so the fix's hunks do not reverse textually.

Hunk: compiler/rustc_codegen_ssa/src/base.rs, `collect_eii_linkage`.
It now only records an EII for the link-time check when a default impl exists AND there are no explicit impls (`default_impl.filter(|_| explicit_impls.is_empty())`).
This re-expresses the fix hunk `@@ -902,6 +903,63 @@ ... fn collect_eii_linkage`, whose key line is `(explicit_impl_count == 1 && has_default_impl).then(...)`: the link-time check is needed exactly when one explicit impl overrides a default. The bug version skips that case, so an explicit impl overriding a default from a linked dylib is not rejected.
