# Adapted injection for Extend builtin/auto trait args with error when they have >1 argument

Fix: https://github.com/rust-lang/rust/commit/c17d33f1df9492ad993da3d8b0ddfcfe08bd652e

# Rationale
File: compiler/rustc_trait_selection/src/traits/select/mod.rs, fn `constituent_types`-based nested obligation builder (the closure that builds `ty::TraitRef` for auto/builtin trait nested obligations).
Re-expresses the fix hunk `@@ -2389,12 +2389,21 @@`: the fix added `if generics_of(trait_def_id).params.len()==1 { TraitRef::new(.., [normalized_ty]) } else { extend_with_error ... }`.
I removed the branch, restoring the original unconditional `ty::TraitRef::new(tcx, trait_def_id, [normalized_ty])`, so an auto trait with extra (ill-formed) generics gets too few args and ICEs.
