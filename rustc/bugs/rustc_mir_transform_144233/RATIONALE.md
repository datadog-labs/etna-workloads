# Adapted injection for Consider parent predicates in ImpossiblePredicates pass.

Fix: https://github.com/rust-lang/rust/commit/1987471d05854cc8b5014dab44e7648834c02213

# Rationale
File: compiler/rustc_mir_transform/src/impossible_clauses.rs (the pass was renamed from impossible_predicates.rs), fn `has_impossible_clauses`.

Fix hunk (`@@ -36,14 +36,26 @@`): replaced
`tcx.predicates_of(def_id).predicates.iter().filter_map(global)` (own predicates only, no parent)
with `predicates_of(def_id).instantiate_identity(tcx)` (includes parent predicates).
Reintroduced the old behaviour: in 1.99.1 `clauses_of(def_id).instantiate_identity(tcx)` (parents included)
is replaced by `instantiate_own_identity()` (own clauses only). Both the structural `Sized` check and the
filtered/elaborated clause list use these own-only clauses, so parent where-clauses (e.g. on an impl or trait) are ignored.
