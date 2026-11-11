# Adapted injection for Don't codegen impossible to satisfy impls

Fix: https://github.com/rust-lang/rust/commit/b36bbb0266a12f4869668f55aeaf4c8a68aa8265

# Hunk: compiler/rustc_monomorphize/src/collector.rs, create_mono_items_for_default_impls
Removed the `tcx.instantiate_and_check_impossible_clauses((item.owner_id.to_def_id(), impl_args))` early return
(1.99.1 name of `subst_and_check_impossible_predicates`). Re-expresses fix hunk
`@@ -1326,6 +1326,21 @@ fn create_mono_items_for_default_impls<'tcx>(` which added that check, so eagerly
monomorphized impls with impossible predicates (e.g. `for<'a> &'a mut [u8]: Copy`) are codegenned again.
