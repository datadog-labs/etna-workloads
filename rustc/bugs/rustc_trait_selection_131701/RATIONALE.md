# Adapted injection for Don't report on_unimplemented for negative traits

Fix: https://github.com/rust-lang/rust/commit/5a8405a5fa55526af743a44abf9c57d1452afbaa

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/traits/on_unimplemented.rs, fn `on_unimplemented_note`.
Removed the early return `if trait_pred.polarity() != ty::PredicatePolarity::Positive { return CustomDiagnostic::default(); }`.
Re-expresses fix hunk `@@ -108,14 +108,18 @@ ... on_unimplemented_note`, which added that polarity check (plus the trait_ref -> trait_pred signature change, already present in 1.99.1). Without it, negative-trait errors use the trait's on_unimplemented message.
