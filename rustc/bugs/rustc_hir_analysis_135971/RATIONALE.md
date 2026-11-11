# Adapted injection for Properly report error when object type param default references self

Fix: https://github.com/rust-lang/rust/commit/ea9a253ff1e0a24e6439c122960f9a17a6e8d58d

# Hunk
File: compiler/rustc_hir_analysis/src/hir_ty_lowering/dyn_trait.rs, in the dyn-trait lowering (the closure checking `trait_ref.args` for leaked `dummy_self`).
Re-expresses the fix hunk `@@ -237,16 +237,10 @@ impl<'tcx> dyn HirTyLowerer<'tcx>` in dyn_compatibility.rs (file since renamed to dyn_trait.rs):
`-if arg == dummy_self.into() {` / `+if arg.walk().any(|arg| arg == dummy_self.into()) {`, removing the `else if ... span_delayed_bug("trait object trait bounds reference `Self`")` branch.
Buggy behaviour restored: only a bare `Self` default is reported as E0393; a default nested in a type (e.g. `<Self as D>::E`) only gets a delayed bug, so no proper error is emitted.
The ftl note wording change was not reverted (it is message text only).
