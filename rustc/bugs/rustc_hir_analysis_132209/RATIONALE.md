# Adapted injection for Validate associated type bounds on ?

Fix: https://github.com/rust-lang/rust/commit/06a49b609f763cacf76a4fcdd3ae8f142e0b8b2d

# Rationale
File: compiler/rustc_hir_analysis/src/hir_ty_lowering/mod.rs, fn `lower_poly_trait_ref`.
Fix hunk `@@ -681,11 +681,32 @@` replaced the `rustc_ast::BoundPolarity::Maybe(_) => { // No-op. return arg_count; }` arm with a loop calling `lower_assoc_item_constraint` for each constraint (validating `?Trait<Assoc = ..>`).
In 1.99.1 the `?Trait` bound flows through the "transient" path and its constraints get lowered into a dropped Vec. I re-introduced the old behaviour: record `is_maybe` and, right after lowering generic args, `return arg_count` (no-op) for Maybe bounds, so constraints are never validated (no E0220 for `?NoAssoc<Missing = ()>`).
