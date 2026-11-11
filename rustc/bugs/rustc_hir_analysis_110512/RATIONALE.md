# Adapted injection for Do not consider associated type bounds for super_predicates_that_define_assoc_type

Fix: https://github.com/rust-lang/rust/commit/8ea71f264e384877bc1f991ad232141b1b7808a5

# Rationale
File: compiler/rustc_hir_analysis/src/hir_ty_lowering/bounds.rs, fn lower_assoc_item_constraint (the `AssocItemConstraintKind::Bound` arm).

Upstream fix hunk `@@ -1356,8 +1387,20 @@` in astconv/mod.rs: "if !only_self_bounds.0 { ... add_bounds(param_ty, ...) }" — associated type bounds (`Load<Blob: BlobPtr>`) are not expanded when only self bounds are wanted (the supertrait-defines-assoc-type query passes OnlySelfBounds(true)). In 1.99.1 that is PredicateFilter::SelfTraitThatDefines, which was in the "do nothing" arm. I moved it into the expanding arm (with All / SelfAndAssociatedTypeBounds / ConstIfConst), restoring the old behaviour of looking into assoc type bounds (cycle, #76593).
