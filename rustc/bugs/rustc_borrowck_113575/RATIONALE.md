# Adapted injection for don't ICE on higher ranked hidden types

Fix: https://github.com/rust-lang/rust/commit/d55522aad87c5605d7edd5dd4b37926e8b446117

# Rationale
One hunk: compiler/rustc_borrowck/src/region_infer/opaque_types/member_constraints.rs, `apply_member_constraint`
(moved from region_infer/mod.rs in 1.99.1).

Re-expresses fix hunk `@@ -805,10 +812,11 @@ apply_member_constraint`: the fix replaced
`assert!(self.scc_universes[scc] == ty::UniverseIndex::ROOT);` with
`if self.scc_universes[scc] != ty::UniverseIndex::ROOT { return; }`.
I restored the assert (via `max_placeholder_universe_reached(member).is_root()`), so a member region
reaching a placeholder (higher-ranked hidden type) ICEs again instead of bailing out.
The other fix hunks (name_regions higher-ranked handling, RePlaceholder diagnostic) were not touched.
