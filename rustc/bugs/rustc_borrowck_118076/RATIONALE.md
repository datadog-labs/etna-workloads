# Adapted injection for Suggest cloning and point out obligation errors on move error

Fix: https://github.com/rust-lang/rust/commit/98cfed7b9756aac0f0f74d9bc307eac22151c17e

# Rationale
File: compiler/rustc_borrowck/src/diagnostics/mod.rs, fn explain_captures (CallKind::Normal branch, clone suggestion).
Re-expresses the fix hunk `@@ -1124,17 +1157,9 @@` where the old code only suggested `clone` when the `Clone` obligation
`predicate_must_hold_modulo_regions` held (fully satisfied); the fix instead suggests with unmet obligations listed
("you could `clone` the value ... if the `X` trait bound could be satisfied") and `suggest_derive`.
In 1.99.1 that logic is `type_implements_trait_shallow(...) && !has_sugg`; I added `&& errors.no_errors()` so the suggestion
(and the derive suggestion) is only emitted when all obligations are met, as before the fix.
