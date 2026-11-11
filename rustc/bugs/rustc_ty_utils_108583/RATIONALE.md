# Adapted injection for Shift vars for default RPITIT methods correctly

Fix: https://github.com/rust-lang/rust/commit/b7e0ca993d0d1d15ed211ceec53ee4ffe526cb16

All changes are in compiler/rustc_ty_utils/src/ty.rs.

1. `ImplTraitInTraitFinder::visit_binder`: removed `self.depth.shift_in(1)` / `shift_out(1)`, so `depth` is never tracked.
   Re-expresses fix hunk `@@ -244,15 +246,36 @@` (added `visit_binder` that does `self.depth.shift_in(1); ... shift_out(1)`).
2. `ImplTraitInTraitFinder::visit_ty`: the late-bound region is rebuilt as `Region::new_bound(tcx, index, bv)` instead of `index.shifted_out_to_binder(self.depth)`.
   Re-expresses the same hunk (`mk_re_late_bound(index.shifted_out_to_binder(self.depth), bv)` and the comment "Shift these binders back out").
3. `param_env`: removed `&& assoc_item.defaultness(tcx).has_value()`.
   This gate was added after the fix (commit 0f0ab89feb4), so it was not present at the parent commit. The parent ran the finder for every trait AssocFn.
   The oracle test's method has no default body, so with the gate the buggy path would never run. The restored condition matches the fix hunk `@@ -142,12 +142,14 @@` context (`container == TraitContainer` only).
