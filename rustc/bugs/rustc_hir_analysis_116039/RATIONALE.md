# Adapted injection for Account for nested `impl Trait` in TAIT

Fix: https://github.com/rust-lang/rust/commit/f2ede49c2f9da8c64782abbec3b4a1710d52a4c5

# Rationale
File: compiler/rustc_hir_analysis/src/collect/type_of/opaque.rs, fn `find_opaque_ty_constraints_for_tait`.
Removed the loop walking up `local_parent` while def_kind is OpaqueTy, and the error name uses `tcx.local_parent(def_id)` again.
Re-expresses fix hunk `@@ -74,9 +74,14 @@ ... find_opaque_ty_constraints_for_tait`:
`while tcx.def_kind(parent_def_id) == def::DefKind::OpaqueTy { parent_def_id = tcx.local_parent(parent_def_id); }` and `name: tcx.item_name(parent_def_id...)`.
For nested `impl Trait` in a TAIT, the name is then taken from the outer opaque type (wrong name/ICE-ish diagnostic).
The import hunk is unneeded (`def` already imported, used by the assoc-type function).
