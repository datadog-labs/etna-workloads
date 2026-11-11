# Adapted injection for Emits E0599 when meeting MyTrait::missing_method

Fix: https://github.com/rust-lang/rust/commit/db645124221a1e2d3e70b14fbedef019e036c066

# Rationale
1.99.1 no longer matches the fix's code layout, so the fix is re-expressed in two hunks.

1. compiler/rustc_hir_analysis/src/hir_ty_lowering/dyn_trait.rs, `lower_trait_object_ty`:
   the `Some(guar) => return Ty::new_error(tcx, guar)` arm now continues (`Some(_guar) => {}`).
   This re-expresses the astconv hunk `@@ -3732,7 +3731,7 @@ ... - diag.emit(); + diag.stash(self_ty.span, StashKey::TraitMissingMethod);`.
   The fix kept the bare-trait diagnostic from reaching the type as an error, so that E0599 for `MyTrait::missing_method` could be emitted or cancelled later. Here the E0782 is emitted and lowering continues with a `dyn` type, so a second error follows (the pre-fix double reporting).
2. compiler/rustc_hir_typeck/src/fn_ctxt/_impl.rs, `resolve_fully_qualified_path`:
   the argument `trait_missing_method && span.edition().at_least_rust_2021()` became `false`.
   This re-expresses the fix hunk `@@ -883,10 +903,12 @@ ... + trait_missing_method && span.edition().rust_2021(), // emits missing method for trait only after edition 2021`.
   The new flag is not passed, so the E0599 message reads "no function ... found for trait `dyn HasNot` in the current scope" and the "items from traits" help is added. This matches the parent behaviour.
