# Adapted injection for Ignore RPIT duplicated lifetimes in opaque_types_defined_by

Fix: https://github.com/rust-lang/rust/commit/c5613258bb3f10907ba1127f363102bf842637cd

# Rationale
File: compiler/rustc_ty_utils/src/opaque_types.rs, `OpaqueTypeCollector::visit_opaque_ty`.
Re-expresses the fix hunk `@@ -154,7 +154,14 @@ impl<'tcx> TypeVisitor<TyCtxt<'tcx>> for OpaqueTypeCollector<'tcx>`:
the fix added `parent_count` and called `uses_unique_generic_params(&alias_ty.args[..parent_count], ..)`.
I removed that and pass the full `alias_ty.args` again, so the opaque's own (duplicated, RPIT-captured) lifetime args are checked and emit DuplicateArg.
The util.rs hunk (slice signature) was already present and is left alone (harmless).
