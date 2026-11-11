# Adapted injection for coherence: don't add hidden types for opaques

Fix: https://github.com/rust-lang/rust/commit/0a6ae29fe855a07b204c5b0e490c59c3ab3d443a

# Rationale
File: compiler/rustc_next_trait_solver/src/solve/project_goals/opaque_types.rs, `normalize_opaque_type`, `TypingMode::Coherence` arm.

Fix hunk: `@@ -533,17 +533,29 @@ impl<'tcx> InferCtxt<'tcx>` in rustc_infer/src/infer/opaque_types.rs. The fix added
`if self.intercrate { ...PredicateKind::Ambiguous... } else { register(...) }`, so that hidden types are NOT registered in coherence.
In 1.99.1 that logic moved: the old solver's equivalent (`insert_hidden_type`, Coherence arm) is dead code in coherence because coherence defaults to the next solver
(`-Znext-solver=coherence`). The live equivalent is the Coherence arm of `normalize_opaque_type`, which previously only added item bounds and an `Ambiguous` goal.
I removed the Ambiguous goal and instead register the hidden type in the opaque storage (`register_hidden_type_in_storage`) and equate with any previous entry, i.e. the pre-fix behaviour.
Effect: `(TAIT, TAIT)` vs `(u32, i32)` now gets TAIT := u32 then i32 mismatch, so impls are wrongly considered disjoint (no E0119).
