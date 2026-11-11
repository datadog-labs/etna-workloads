# Adapted injection for In "specify type" suggestion, skip type params that are already known

Fix: https://github.com/rust-lang/rust/commit/6005619bde6abacfdce096d1f67437323b63d8dc

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/infer/need_type_info.rs

1. `ClosureEraser` / its `TypeFolder::fold_ty` impl: in 1.99.1 the folder had been evolved (depth counter, per-arg ADT handling) but implemented the fix's behaviour (replace fully-known ADTs/types with `_`). Restored the pre-fix form: struct holds only `tcx`, and `fold_ty` only converts closures to fn ptrs, otherwise `super_fold_with`. Re-expresses hunk `@@ -155,26 +156,85 @@ impl UnderspecifiedArgKind` (the `ClosureEraser<'a,'tcx>` with `infcx`, `do_not_hide_nested_type`, `self.new_infer()` branches).
2. `ty_to_string`: construct `ClosureEraser { tcx: infcx.tcx }` instead of `{ infcx, depth: 0 }`. Re-expresses hunk `@@ -219,9 +279,9 @@ fn ty_to_string` (`ty.fold_with(&mut ClosureEraser { infcx, ... })` -> `{ tcx: infcx.tcx }`).
