# Adapted injection for `-Znext-solver` Emit error instead of ICE when combining {int, float} var with alias

Fix: https://github.com/rust-lang/rust/commit/b130dd14aea5fa5fcf230ed4a147ac93f22868f4

# Rationale
File: compiler/rustc_type_ir/src/relate/combine.rs, fn `super_combine_tys`.

Fix hunk `@@ -115,9 +115,31 @@` replaced the arm `(_, ty::Alias(..)) | (ty::Alias(..), _) if infcx.next_trait_solver()` (which for `StructurallyRelateAliases::Yes` called `structurally_relate_tys`) with a version that returns `TypeError::Sorts` when the other side is an Int/Float var.
In 1.99.1 `StructurallyRelateAliases` is gone and that arm no longer exists. Int/float var vs alias falls into `(ty::Infer(_), _) | (_, ty::Infer(_)) => Err(Sorts)`.
I re-added, just before that "All other cases of inference are errors" arm, an arm `(Alias(..), _) | (_, Alias(..)) if next_trait_solver => structurally_relate_tys(relation, a, b)`. This is the pre-fix behaviour: an int/float var is passed to `structurally_relate_tys`, which panics ("var types encountered").
