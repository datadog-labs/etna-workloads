# Adapted injection for Don't substitute a GAT that has mismatched generics in OpaqueTypeCollector

Fix: https://github.com/rust-lang/rust/commit/5344ed23fadce0bd2af6a50cb4623704b1fe6383

# Rationale
File: compiler/rustc_ty_utils/src/opaque_types.rs, `OpaqueTypeCollector::visit_ty`, the `ty::Alias(Projection)` arm.
The fix (hunk `@@ -98,37 +107,48 @@` in opaque_types.rs, plus moving `check_substs_compatible` into util.rs) added a check that the GAT's rebased args are compatible with the impl assoc item's generics before substituting `type_of(assoc)`. In 1.99.1 that check is `tcx.check_args_compatible(assoc.def_id, alias_args)` with a delayed-bug else branch. I removed it, so the type is always instantiated with the mismatched args (the pre-fix behaviour).
