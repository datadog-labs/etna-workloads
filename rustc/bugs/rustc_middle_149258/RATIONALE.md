# Adapted injection for Fix None handling for simplify_type in for_each_relevant_impl

Fix: https://github.com/rust-lang/rust/commit/eb72e6764e30003fab1d46ecc22e4938b060aaed

# Rationale
File: compiler/rustc_middle/src/ty/trait_def.rs, `TyCtxt::for_each_relevant_impl` (the code moved here from context.rs in 1.99.1).
Re-expresses fix hunk `@@ -589,13 +589,13 @@ impl<'tcx> Interner for TyCtxt<'tcx>`: the fix replaced `simplify_type(..).unwrap()` with `if let Some(simp) = simplify_type(..)`.
In 1.99.1 the main arm still unwraps, and the `None` case is handled by a separate `ty::Pat` arm using `if let Some(simp)`. I removed that arm and added `ty::Pat(_, _)` to the unwrapping arm. `simplify_type` returning `None` for `ty::Pat` now panics on the `.unwrap()`, as before the fix.
