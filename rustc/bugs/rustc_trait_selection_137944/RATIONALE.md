# Adapted injection for trait_sel: print `{Meta,Pointee}Sized` impl headers

Fix: https://github.com/rust-lang/rust/commit/9044b78c0dca4751934c249a9d30b1a2d285fb54

# Rationale
All changes are in `to_pretty_impl_header` in compiler/rustc_trait_selection/src/error_reporting/traits/mod.rs.
In 1.99.1 the code uses `clauses_of` (formerly `predicates_of`), so fix.diff hunk 3 did not apply textually.

1. Fix hunk `@@ -358,24 +365,47 @@` (`if Some(trait_clause.def_id()) == sized_trait {...} else if ... == meta_sized_trait {`): removed the `meta_sized_trait` lookup and its branch. `MetaSized` clauses are no longer absorbed and so print as ordinary where-clauses.
2. Same hunk, final loop (`if !tcx.features().sized_hierarchy() {... format!("{ty}: MetaSized") ... "PointeeSized"`): reverted to the old behaviour. Every type without a `Sized` clause prints `T: ?Sized`. `Sized`, `MetaSized` and `PointeeSized` are never printed under the sized_hierarchy feature.
