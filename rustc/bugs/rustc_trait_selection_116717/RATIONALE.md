# Adapted injection for Special case iterator chain checks for suggestion

Fix: https://github.com/rust-lang/rust/commit/6d23ee8430df1b2dfedb48f8321d9c47b26d7858

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/traits/suggestions.rs, fn `look_for_iterator_item_mistakes` (the code moved here from `point_at_chain`).
Removed the block `if tcx.is_diagnostic_item(sym::IteratorItem, *def_id) && path_segment.ident.name == sym::map ...` which emits "consider removing this semicolon" for trailing `;` in `Iterator::map` closures and the "this method call is cloning the reference ... which doesn't implement Clone" label plus `T: Clone` restriction suggestion.
This re-expresses the fix hunk `@@ -3611,13 +3611,103 @@ ... point_at_chain` (the added "Special case for iterator chains" `for entry in &assocs_in_this_method` loop with the `sym::map` special cases). The `.iter()`/`.into_iter()` suggestions, which predate the fix, are kept.
