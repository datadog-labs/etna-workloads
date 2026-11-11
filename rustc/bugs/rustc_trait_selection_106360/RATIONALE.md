# Adapted injection for Use the root trait predicate to determine whether to remove references

Fix: https://github.com/rust-lang/rust/commit/8b8cce16bfb74bcb06250ed3b9b3dc8c97e1ee4b

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/traits/suggestions.rs, fn `suggest_remove_reference`.
Removed the block that walks `code.parent_with_predicate()` to the root obligation and replaces `trait_pred` with the root's predicate (`let mut trait_pred = trait_pred; let mut code = ...; while let Some((c, Some(parent_trait_pred))) = ...`).
Re-expresses fix hunk `@@ -1359,6 +1359,14 @@ ... suggest_remove_reference` which added exactly that loop. Without it, the leaf predicate is used, so the suggestion to remove `&` is wrongly missed.
