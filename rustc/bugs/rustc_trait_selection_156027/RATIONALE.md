# Adapted injection for Move opaque outlives computation out of live_args_for_alias_from_outlives_bounds for opaques

Fix: https://github.com/rust-lang/rust/commit/cb8b1477b496e5c0776122f72d04bf901598b74d

# Re-injection of the bug fixed by cb8b1477b49 (PR #156027, issue #153215)

The code is in one file: `compiler/rustc_trait_selection/src/traits/outlives_for_liveness.rs`.
1.99.1 already contains the fix plus later work on top of it (b8c8868, 1912e4f, ed9bfaf).
Because of that, the fix does not reverse cleanly. Each hunk below re-expresses one fix hunk
against today's code.

The bug (issue #153215): for an RPITIT such as
`fn hide_ref<'a,'b,T:'static>(&self, x: &'a mut &'b T) -> impl Swap + 'a`, a caller sees the
synthetic GAT `<H as Hider>::{anon_assoc#0}<'a,'b,T>`. Before the fix, its liveness-relevant
args were worked out from the GAT's *declared where-clauses only*, with no implied bounds.
So `'b: 'a`, which is implied by `&'a mut &'b T`, was missed and `'b` was not treated as live.
Polonius (`-Zpolonius=next`) then accepted the dangling-reference swap.
The fix sends RPITIT GATs through the opaque computation, which works in the parent fn's context
(param_env + assumed WF types).

## Hunk 1: `args_known_to_outlive_alias_params`: remove the RPITIT → opaque dispatch
Removed the `DefKind::AssocTy if let Some(ImplTraitInTraitData::Trait { opaque_def_id, .. }) = tcx.opt_rpitit_info(..)`
arm and the now-unused `ImplTraitInTraitData` import. RPITIT GATs now go back to the
non-opaque (associated type) computation.
Re-expresses fix hunk `@@ -149,167 +164,93 @@`, which added:
```
+        DefKind::OpaqueTy => args_known_to_outlive_opaque_params(tcx, def_id),
+        DefKind::AssocTy
+            if let Some(ImplTraitInTraitData::Trait { fn_def_id: _, opaque_def_id }) =
+                tcx.opt_rpitit_info(def_id.to_def_id()) =>
+        {
+            args_known_to_outlive_opaque_params(tcx, opaque_def_id.expect_local())
+        }
```
and the import change in hunk `@@ -3,54 +3,48 @@` (`+ self, Flags, ImplTraitInTraitData, ...`).

## Hunk 2: `args_known_to_outlive_non_opaque_params`: no implied bounds for RPITIT GATs
Before the fix, the function that RPITIT GATs went through (`args_known_to_outlive_alias_params`,
renamed by the fix to `..._associated_type_params`) used `let wf_tys = FxIndexSet::default();`,
meaning "given only the alias's declared where-clauses".
The later commit ed9bfaf (not part of this fix) changed that function to use `tcx.assumed_wf_types`.
For RPITIT GATs, `assumed_wf_types` recovers the fn's WF types, which on its own would hide the
bug. To restore the pre-fix result for exactly the case the fix redirected (RPITIT GATs), this
hunk keeps `wf_tys` empty when `tcx.is_impl_trait_in_trait(def_id)`.
Ordinary associated types and type aliases are unchanged. This is the other half of re-expressing
the same fix hunk `@@ -149,167 +164,93 @@` (the old body, shown as context around `@@ -339,13 +280,11 @@`, used
`let wf_tys = FxIndexSet::default();`).

## Hunk 3: `args_known_to_outlive_opaque_params`: drop the equal-region shortcut
`parent_outlives_region == *parent_outlived_region || region_known_to_outlive(..)` →
`region_known_to_outlive(..)`. The pre-fix opaque code (`live_args_for_opaque_from_outlives_bounds`)
called only `region_known_to_outlive`. Re-expresses fix hunk `@@ -149,167 +164,93 @@`:
```
-                let known_outlives = region_known_to_outlive(
...
+            let region_outlives = parent_outlives_region == *parent_outlived_region
+                || region_known_to_outlive(
```

## Hunk 4: `FreeRegionsVisitor::visit_ty`: restore the opaque early-return path
For `AliasTyKind::Opaque`, the visitor again uses only the alias's own live args, falling back to
non-bivariant args via `variances_of`, and returns early. It no longer intersects with param-env
outlives clauses. Re-expresses fix hunk `@@ -534,30 +472,6 @@`, which removed:
```
-                // Opaques are special, because we need to map onto the opaque's parent.
-                if let ty::AliasTyKind::Opaque { def_id } = kind {
-                    match tcx.live_args_for_alias_from_outlives_bounds(def_id) {
...
-                    return;
-                }
```
(The query key stays `AliasTyKind` instead of going back to `DefId`. That part of the fix
(queries.rs, keys.rs, metadata tables, `Eq` derive) is plumbing only and does not change behaviour.)
