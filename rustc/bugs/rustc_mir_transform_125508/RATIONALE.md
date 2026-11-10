# Adapted injection for Stop SRoA'ing `DynMetadata` in MIR

Fix: https://github.com/rust-lang/rust/commit/d7248d7b71fd756bef62e98b52ee1110f8d3a3c4

# Rationale
File compiler/rustc_mir_transform/src/sroa.rs, fn escaping_locals (`is_excluded_ty`): removed the `tcx.is_lang_item(def.did(), LangItem::DynMetadata)` clause, so DynMetadata locals are no longer excluded from SRoA.
Re-expresses fix hunk `@@ -70,6 +70,11 @@ fn escaping_locals` which added `if Some(def.did()) == tcx.lang_items().dyn_metadata() { return true; }`.
