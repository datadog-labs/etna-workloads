# Adapted injection for Disable usage on trait impls and aliases

Fix: https://github.com/rust-lang/rust/commit/9abaa9d4dffeb897a1dbff97d32d3b6ac190be21

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/traits/on_unimplemented.rs, fn `on_unimplemented_note`.
Removed the `if self.tcx.is_trait_alias(trait_pred.def_id()) { return CustomDiagnostic::default(); }` guard.
This re-expresses fix hunk `@@ -553,6 +553,13 @@ ... of_item`, which added
`if !tcx.is_trait(item_def_id) { return Ok(None); }` so that on_unimplemented is ignored on trait aliases/impls.
In 1.99.1 `of_item` is gone (attrs parsed in rustc_attr_parsing); this guard is the equivalent point where aliases are ignored. Without it, the directive on a trait alias is applied again (the pre-fix behaviour).
The other fix hunks (verify param rename) are pure refactors with no 1.99.1 equivalent.
