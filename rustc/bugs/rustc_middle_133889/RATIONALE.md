# Adapted injection for Dont consider fields that are forced unstable due to -Zforce-unstable-if-unmarked to be uninhabited

Fix: https://github.com/rust-lang/rust/commit/0a6a0e47d2efb207ad0e95c3eb67b543c8cbb2e6

# Rationale
The 1.99.1 code no longer has the unstable-field checks at all (the fix's hunks don't apply), so I restored the pre-fix behaviour: unstable fields are treated as ignorable for inhabitedness, with no `rustc_private` exclusion. This is the state the fix's parent had.

1. compiler/rustc_middle/src/ty/inhabitedness/mod.rs, `VariantDef::inhabited_predicate`: a field whose stability is unstable now returns `InhabitedPredicate::True`. This re-expresses fix hunk `@@ -90,7 +91,13 @@` (the old line `if tcx.lookup_stability(field.did).is_some_and(|stab| stab.is_unstable()) { return InhabitedPredicate::True; }`, without the `stab.feature != sym::rustc_private` filter).
2. compiler/rustc_pattern_analysis/src/rustc.rs, `ctor_sub_tys`: `is_unstable` is computed from `lookup_stability(..).is_unstable()` and `skip = is_uninhabited && (!is_visible || is_unstable)`. This re-expresses fix hunk `@@ -232,10 +232,10 @@` (old `let is_unstable = cx.tcx.lookup_stability(field.did).is_some_and(|stab| stab.is_unstable());`, without the `rustc_private` filter).
