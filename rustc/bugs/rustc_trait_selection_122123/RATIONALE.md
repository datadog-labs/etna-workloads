# Adapted injection for Don't require specifying unrelated assoc types when trait alias is in dyn type

Fix: https://github.com/rust-lang/rust/commit/850cc34da2ec86ae5b84e48a03d6b451b1dcd4d7

# Rationale
File: compiler/rustc_trait_selection/src/traits/util.rs, fn `expand_trait_aliases`.
Changed `tcx.explicit_super_clauses_of(trait_pred.def_id())` to `tcx.explicit_implied_clauses_of(...)` when expanding a trait alias.
Re-expresses fix hunk `@@ -127,7 +127,7 @@ impl TraitAliasExpander` : `-tcx.implied_predicates_of(..)` / `+tcx.super_predicates_of(..)`.
The fix made alias expansion use only supertraits, so assoc type bounds (e.g. `Iterator<Item: Foo>`) do not leak into dyn types and demand unrelated assoc types. Reverting to the implied clauses (superset incl. assoc-type bounds) restores the bug. The object_safety.rs hunks were already structurally replaced in 1.99.1 (PredicateFilter::SelfOnly is used), so only this hunk was re-expressed.
