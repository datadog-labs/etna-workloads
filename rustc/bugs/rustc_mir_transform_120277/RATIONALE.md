# Adapted injection for Normalize field types before checking validity

Fix: https://github.com/rust-lang/rust/commit/866364cc5d79b26ec1ab58eca0cc4c3416b5a1bc

# Rationale
File: compiler/rustc_mir_transform/src/validate.rs (moved from rustc_const_eval/src/transform/validate.rs), `TypeChecker::visit_rvalue`, Aggregate arm.

1. Union case (`AggregateKind::Adt(.., Some(field))`): fix hunk `@@ -810,13 +810,18 @@` wrapped the union field type in `normalize_erasing_regions`. Removed it; dest type is now the raw `fields[field].ty(tcx, args).skip_normalization()`.
2. Struct/enum case (`AggregateKind::Adt(.., None)`): fix hunk `@@ -826,10 +831,10 @@` added `let dest_ty = normalize_erasing_regions(param_env, dest.ty(tcx,args))`. Removed it; unnormalized `dest.ty(..)` is passed to `mir_assign_valid_types`.
