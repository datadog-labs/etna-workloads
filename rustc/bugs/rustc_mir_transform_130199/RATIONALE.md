# Adapted injection for Don't call closure_by_move_body_def_id on FnOnce async closures in MIR validation

Fix: https://github.com/rust-lang/rust/commit/5cf117ed0514af068a6e0e42f732dd93ff5e90dc

# Rationale
File compiler/rustc_mir_transform/src/validate.rs, TypeChecker::visit_projection_elem (ty::Coroutine arm):
replaced `self.tcx.needs_coroutine_by_move_body_def_id(def_id)` with the original
`if let Some(hir::CoroutineKind::Desugared(_, hir::CoroutineSource::Closure)) = self.tcx.coroutine_kind(def_id)` (and re-added `use rustc_hir as hir;`).
Re-expresses fix hunk `@@ -716,10 +715,7 @@ impl<'a, 'tcx> Visitor<'tcx> for TypeChecker` (and the `-use rustc_hir as hir;` hunk).
With the check back, the by-move-body query is called on FnOnce async closures during validation (issue #130167).
The other fix hunks (signature changes) were not needed.
