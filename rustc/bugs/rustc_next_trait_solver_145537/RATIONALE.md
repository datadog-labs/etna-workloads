# Adapted injection for Do not consider a `T: !Sized` candidate to satisfy a `T: !MetaSized` obligation.

Fix: https://github.com/rust-lang/rust/commit/c7cd1b3b9da1ffce791ec33dbcad82559dbc4447

# Hunks
1. compiler/rustc_trait_selection/src/traits/util.rs, `lazily_elaborate_sizedness_candidate`: restored
   `if obligation.predicate.polarity() != candidate.polarity() { return candidate; }`, re-expressing fix hunk
   `@@ -427,7 +427,9 @@` (which required both polarities to be Positive). Now a `T: !Sized` candidate is elaborated to satisfy `T: !MetaSized`.
2. compiler/rustc_next_trait_solver/src/solve/trait_goals.rs, `fast_reject_assumption::trait_def_id_matches`: removed
   `polarity == PredicatePolarity::Positive &&` from the Sized->MetaSized check (fix hunk `@@ -133,19 +133,26 @@`).
   The param is kept as `_polarity` (unused) so the call site is unchanged.
