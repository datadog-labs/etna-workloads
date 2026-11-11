# Adapted injection for Don't compute name of associated item if it's an RPITIT

Fix: https://github.com/rust-lang/rust/commit/11e5987d017b4ab8dfc522d674aea704aad8605a

# Rationale
File: compiler/rustc_hir_analysis/src/hir_ty_lowering/errors.rs, fn complain_about_assoc_item_not_found, `wider_candidate_names` filter_map.
Fix hunk `@@ -204,8 +204,7 @@`: replaced eager `.then_some(item.name())` with lazy `.then(|| item.name())`.
Re-injected by restoring `.then_some(item.name())`, so `item.name()` is computed for RPITIT items (which have no name) and ICEs.
