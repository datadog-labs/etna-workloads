# Adapted injection for Don't ICE on DiscriminantKind projection in new solver

Fix: https://github.com/rust-lang/rust/commit/f5c78c4d3a9ab8d7b8726540715cc2abfbea0eba

# Rationale
File: compiler/rustc_next_trait_solver/src/solve/normalizes_to.rs, fn `consider_builtin_discriminant_kind_candidate` (moved from rustc_trait_selection/src/solve/project_goals.rs).

Fix hunk `@@ -485,9 +485,49 @@` split the self type match, sending `ty::Alias | ty::Param | ty::Placeholder` to `return Err(NoSolution)` instead of calling `self_ty.discriminant_ty()`. Before the fix, all kinds went through `discriminant_ty`, which yields `<T as DiscriminantKind>::Discriminant` for alias/param (normalizing to itself) and ICEs for placeholders. I re-expressed this by removing the special arm (rigid-alias/param/placeholder, the 1.99.1 equivalent of the NoSolution arm) and adding those types back to the `discriminant_ty` arm.
