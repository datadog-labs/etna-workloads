# Adapted injection for Make sure we note ambiguity causes on positive/negative impl conflicts

Fix: https://github.com/rust-lang/rust/commit/62d1f4faa172b409ea09a24acaf9dfccfd0c2710

# Rationale
File: compiler/rustc_trait_selection/src/traits/specialize/mod.rs

1. `report_negative_positive_conflict`: re-expresses fix hunk `@@ -483,15 +483,19 @@ fn report_negative_positive_conflict` by restoring the pre-fix
   `tcx.dcx().create_err(NegativePositiveConflict{..}).emit()` and dropping
   `for cause in &overlap.intercrate_ambiguity_causes { cause.add_intercrate_ambiguity_hint(&mut diag); }`.
   Alone this does NOT fail the oracle (the test has no negative impls, so it goes through the plain conflict path).
2. `report_conflicting_impls::decorate`: removed the same `add_intercrate_ambiguity_hint` loop, so the ambiguity-cause note is missing
   on conflicts. This extends the fix's idea (note ambiguity causes on impl conflicts) to the other reporter so the oracle observes it.
