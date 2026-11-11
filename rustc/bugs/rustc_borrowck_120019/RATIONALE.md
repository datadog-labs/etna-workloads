# Adapted injection for borrowck: use implied bounds from impl header

Fix: https://github.com/rust-lang/rust/commit/8d4693c0f803d87c1ea127093dab5f0499879e5c

# Rationale
File: compiler/rustc_borrowck/src/type_check/free_region_relations.rs, fn `create_old` (the old-solver path; `create` is what the fix's `create` hunk became).

Hunk 1: removed the block "Add implied bounds from impl header" (the loop over `tcx.assumed_wf_types(tcx.local_parent(defining_ty_def_id))` that normalizes each type and calls `add_implied_bounds`, for AssocFn/AssocConst). Re-expresses fix hunk `@@ -275,6 +278,26 @@ ... normalized_inputs_and_output.push(norm_ty);` which added that block.

Hunk 2: removed the now-unused `use rustc_hir::def::DefKind;`, re-expressing fix hunk `@@ -1,5 +1,6 @@` (`+use rustc_hir::def::DefKind;`).
