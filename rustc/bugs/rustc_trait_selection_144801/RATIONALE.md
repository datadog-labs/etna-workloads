# Adapted injection for Suggest bounds in more cases, accounting for type parameters referenced in predicate

Fix: https://github.com/rust-lang/rust/commit/fa6986ebe749bc59d569e3f75d0b5764f2601d78

# Changes (compiler/rustc_trait_selection/src/error_reporting/traits/suggestions.rs, fn suggest_restricting_param_bound / the loop over body parents)
1. Removed the `hir::Node::TraitItem(Fn) | hir::Node::ImplItem(inherent Fn) if finder.can_suggest_bound(generics)` arm that calls `suggest_arbitrary_trait_bound`. Re-expresses the fix hunk `@@ -410,6 +413,26 @@` (which added that arm). Without it, methods never get the `where` clause suggestion (bug #144734).
2. Restored guard on the `hir::Node::Item(...)` arm: `if finder.can_suggest_bound(generics)` -> `if !param_ty`. Re-expresses `@@ -422,7 +445,7 @@` (`}) if !param_ty => {` -> `if finder.can_suggest_bound(generics)`). Brings back the where-clause suggestion in the trait case of failing_goal_with_repeat_expr_anon_const.
The ParamFinder struct/`finder` remain (now unused by the guard of the item arm), matching the other fix hunks as-is.
