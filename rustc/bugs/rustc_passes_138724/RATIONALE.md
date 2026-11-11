# Adapted injection for Check attrs: Don't try to retrieve the name of list stems

Fix: https://github.com/rust-lang/rust/commit/b5069da9df85b8f374a3fd59c2145396e374537d

# Rationale
File compiler/rustc_passes/src/check_attr.rs, fn check_doc_alias_value (the "alias == item name" check).
Fix hunk `@@ -952,8 +952,7 @@`: replaced `let item_name = self.tcx.hir_name(hir_id); if item_name == doc_alias` with `self.tcx.hir_opt_name(hir_id) == Some(doc_alias)`.
Re-injected: use `self.tcx.hir_name(hir_id) == alias` again, which ICEs for `use {..}` list stems (no name).
