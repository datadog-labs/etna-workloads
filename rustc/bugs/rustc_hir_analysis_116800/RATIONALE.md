# Adapted injection for Fix outlives suggestion for GAT in RPITIT

Fix: https://github.com/rust-lang/rust/commit/17ec3cd5bfe295cf31c464f40776c438b9570ac0

# Rationale
File compiler/rustc_hir_analysis/src/check/wfcheck.rs, fn check_gat_where_clauses: removed the early
`continue` for `tcx.is_impl_trait_in_trait(gat_def_id.to_def_id())` in the final loop over
`required_bounds_by_item`. Re-expresses fix hunk `@@ -431,7 +432,12 @@ fn check_gat_where_clauses` which added
"// Don't suggest adding `Self: 'a` to a GAT that can't be named / if tcx.is_impl_trait_in_trait(..) { continue; }".
Other hunks were pure refactors (signature changes) and are not part of the bug.
