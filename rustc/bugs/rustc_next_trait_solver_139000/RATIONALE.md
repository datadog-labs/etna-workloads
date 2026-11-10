# Adapted injection for Make unnormalizable item ambiguous in coherence

Fix: https://github.com/rust-lang/rust/commit/6cd724bb43b92ae573112c3d39804f227c7ebf02

# Rationale
File: compiler/rustc_next_trait_solver/src/solve/normalizes_to.rs, fn `consider_impl_candidate` (the `!cx.has_item_definition(target_item_def_id)` branch).
Fix hunk `@@ -238,8 +238,24 @@` in normalizes_to/mod.rs (file since renamed to normalizes_to.rs) added a `TypingMode::Coherence` arm making normalization of an unnormalizable (guaranteed-unsized impl) item ambiguous, vs. rigid in other modes. I removed the coherence branch (the nested `PredicateKind::Ambiguous` goal), so the item is always treated as rigid (`instantiate_normalizes_to_as_rigid`), as in the pre-fix code.
