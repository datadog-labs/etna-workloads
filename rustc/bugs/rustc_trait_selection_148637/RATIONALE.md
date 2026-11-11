# Adapted injection for Replace #[rustc_do_not_implement_via_object] with #[rustc_dyn_incompatible_trait], which makes the marked trait dyn-incompatible.

Fix: https://github.com/rust-lang/rust/commit/c3205f98dda8ab49d4774f8af61211d75ae7b2d4

# Rationale
Most of the fix was already in 1.99.1 (attribute renamed, `library/core` already uses `#[rustc_dyn_incompatible_trait]`).
One hunk re-expressed: `compiler/rustc_trait_selection/src/traits/dyn_compatibility.rs`, `dyn_compatibility_violations_for_trait`:
removed the `else if let Some(span) = tcx.trait_def(trait_def_id).force_dyn_incompatible { violations.push(ExplicitlyDynIncompatible(..)) }` branch.
This corresponds to the fix's `TraitDef` hunk (`@@ -69,10 +70,9 @@` in trait_def.rs: `force_dyn_incompatible: Option<Span>`) and the new
`DynCompatibilityViolation::ExplicitlyDynIncompatible` in middle/traits/mod.rs: without the violation, marked traits (Unsize, Sized-adjacent, etc.) are no longer dyn-incompatible, as before the fix.
