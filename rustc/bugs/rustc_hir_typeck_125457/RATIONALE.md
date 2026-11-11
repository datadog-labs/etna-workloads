# Adapted injection for Properly deal with missing/placeholder types inside GACs

Fix: https://github.com/rust-lang/rust/commit/24afa42a90eb035e24e5dcffbc538fb96277e3a3

# Rationale
File: compiler/rustc_hir_typeck/src/lib.rs, fn infer_type_if_missing.
Re-expresses the fix hunk `@@ -235,11 +235,16 @@ fn infer_type_if_missing`: the fix computes args as
`identity_for_item(tcx, def_id).rebase_onto(tcx, impl_def_id, impl_trait_ref.args)` so the GAC's own generics are included.
Bug re-injected: use `impl_trait_ref.args` directly (omitting the GAC's own params), and drop the `check_args_compatible` guard (added later upstream, which otherwise hides the mismatch) so type_of(trait_item) is instantiated with too-short args.
