# Adapted injection for Unconditionally-const supertraits are considered not dyn compatible

Fix: https://github.com/rust-lang/rust/commit/e57e5f02b8fa3272d1ec4f75a0ab66dfed9b9b9b

# Rationale
File: compiler/rustc_trait_selection/src/traits/dyn_compatibility.rs
- `dyn_compatibility_violations_for_trait`: removed the call to the unconditionally-const supertrait check and the push of `DynCompatibilityViolation::SupertraitConst`. Re-expresses fix hunk `@@ -106,6 +106,10 @@ fn dyn_compatibility_violations_for_trait(` (the added `super_predicates_are_unconditionally_const` / `violations.push(SupertraitConst(spans))`).
- Removed the now-unused helper `super_clauses_are_unconditionally_const` (1.99.1 name of the fix's `super_predicates_are_unconditionally_const`, hunk `@@ -247,16 +251,31 @@`).
The middle/traits enum variant is left in place (unused variant, harmless). Effect: `dyn Trait` with `const Super` supertrait is wrongly accepted.
