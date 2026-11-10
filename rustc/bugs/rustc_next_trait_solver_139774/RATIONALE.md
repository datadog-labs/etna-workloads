# Adapted injection for Fix replacing supertrait aliases in ReplaceProjectionWith

Fix: https://github.com/rust-lang/rust/commit/3863018d960ad8bf6dd631f31f9d487e4a9880f1

# Rationale
File: compiler/rustc_next_trait_solver/src/solve/assembly/structural_traits.rs, `ReplaceProjectionWith::try_eagerly_replace_alias`.
Removed the `if alias_term.self_ty() != self.self_ty { return Ok(None); }` early-out.
Re-expresses fix hunk `@@ -871,72 +872,130 @@` in structural_traits.rs, which added `self_ty: trait_ref.self_ty()` to the folder
and the check `if alias_term.self_ty() != self.self_ty { return Ok(None); }`. Without it, aliases like `<V as Super>::Output`
(not relevant to the dyn type) are replaced/unified, causing a panic/ICE (supertrait-alias-1, -2).
