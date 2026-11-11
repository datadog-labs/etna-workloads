# Adapted injection for Consider doc(alias) when providing typo suggestions

Fix: https://github.com/rust-lang/rust/commit/f908f0be5a088a0e1748c7853a8acf75be6d1c18

# Rationale
File: compiler/rustc_hir_typeck/src/method/probe.rs, fn `ProbeContext::probe_for_similar_candidate`'s candidate-gathering helper (`impl_or_trait_candidates` filter closure, near `matches_by_doc_alias(x.def_id)`).
Re-expresses fix hunk `@@ -1996,6 +2034,9 @@ ... if self.matches_by_doc_alias(x.def_id) { return true; }`: the fix made doc-alias matches count as close candidates when gathering suggestions. I removed the alias fallback (`self.matches_by_doc_alias(x.def_id)` -> `false`), so aliased items are no longer gathered and `#[doc(alias = "quux")] fn bar` isn't suggested. The rest of the fix (renames, the selection fallback) is already cosmetic or unaffected.
