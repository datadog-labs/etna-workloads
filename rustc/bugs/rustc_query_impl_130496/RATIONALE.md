# Adapted injection for Fix circular fn_sig queries to return the correct number of arguments for methods

Fix: https://github.com/rust-lang/rust/commit/3cb1f334b8c74f7c8c5860e2c84b317fbc86165d

# Rationale
File: compiler/rustc_query_impl/src/handle_cycle_error.rs, fn `fn_sig` (moved from rustc_middle/src/values.rs).
Fix hunk: `@@ -56,7 +56,7 @@ impl<'tcx> Value<TyCtxt<'tcx>> for ty::Binder<'_, ty::FnSig<'_>>`:
`-sig.decl.inputs.len()` / `+sig.decl.inputs.len() + implicit_self.has_implicit_self() as usize`.
In 1.99.1 the code already had the fixed arity semantics (inputs.len(), which now includes self), so the buggy
form is re-expressed as `inputs.len() - has_implicit_self() as usize`: cycle-recovery fn_sig has one too few args for methods.
