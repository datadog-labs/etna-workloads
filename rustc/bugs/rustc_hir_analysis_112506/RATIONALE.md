# Adapted injection for properly check associated consts for infer placeholders

Fix: https://github.com/rust-lang/rust/commit/2b40268f8bed4ba1d916a216a4431bb2ec7b2d41

# Rationale
File: compiler/rustc_hir_analysis/src/collect/type_of.rs, fn `type_of`, arms `TraitItemKind::Const` and `ImplItemKind::Const`.
The `infer_placeholder_type(..., "associated constant")` kind string is reverted to `"constant"`.
Re-expresses fix hunks `@@ -341,7 +341,12 @@ pub(super) fn type_of` (`"constant"` -> `"associated constant"`) and `@@ -359,7 +364,14 @@` (same for ImplItemKind::Const).
The collect.rs hunks (convert_trait_item/convert_impl_item placeholder collection) have no direct equivalent in 1.99.1 (the logic moved into lowering), so they were not re-expressed.
