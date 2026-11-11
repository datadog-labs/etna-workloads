# Adapted injection for Do not report overflow errors on ConstArgHasType goals

Fix: https://github.com/rust-lang/rust/commit/01c974ff98a293c9792779bbe4428f1e9b55a05b

# Rationale
File: compiler/rustc_trait_selection/src/traits/fulfill.rs, `FulfillProcessor::process_obligation`.
Fix hunk `@@ -423,6 +423,21 @@` added the `ConstArgHasType` arm ("Compute `ConstArgHasType` above the overflow check below") before the general `_ if !recursion_limit.value_within_limit(..)` overflow arm; hunk `@@ -650,18 +665,6 @@` removed the old arm below it.
Re-injection: reversed this — the `ConstArgHasType` arm (body unchanged) and its comment are moved back below the general overflow-check arm, so overflow is reported on ConstArgHasType obligations again.
