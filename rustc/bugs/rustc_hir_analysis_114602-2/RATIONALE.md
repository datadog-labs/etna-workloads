# Adapted injection for Install bidirectional outlives predicates for RPITITs (and RPITs) correctly

Fix: https://github.com/rust-lang/rust/commit/420ee167a8fbda2a078cb3a294fa1108c0180c98

# Rationale

## Bug
Before the fix, the bidirectional outlives predicates between an opaque's (or RPITIT's)
duplicated lifetime param and the original lifetime were computed by resolving the
captured lifetime only *one level*: the captured `'a` of an inner, nested RPIT
(`impl Iterator<Item = impl Into<&'a T>>`) resolves to the *outer opaque's* duplicated
lifetime, not to the fn's `'a`. The resulting "original" region was built with an
index taken from the wrong generics, so the duplicated lifetime was never tied to the
fn lifetime and `T: 'a` could not be proven (E0309) / ICEs (#114285, #114579, #114597).
The fix introduced `TyCtxt::map_rpit_lifetime_to_fn_lifetime` which *loops* through
parent opaques until it reaches the fn's early/late-bound lifetime, and used it in
`compute_bidirectional_outlives_predicates`.

## Hunk: compiler/rustc_hir_analysis/src/collect/clauses_of.rs, `compute_bidirectional_outlives_clauses`
(1.99.1 renamed predicates_of.rs -> clauses_of.rs and the fix's helper to
`map_opaque_lifetime_to_parent_lifetime`.)

Replaced the call `tcx.map_opaque_lifetime_to_parent_lifetime(param.def_id)` with
the pre-fix one-level logic: look up the opaque's lifetime mapping
(`opaque_captured_lifetimes`, the 1.99.1 equivalent of `OpaqueTy::lifetime_mapping`),
find the captured lifetime; if it isn't early-bound `continue` ("There is no
late-bound lifetime to actually match up here"); otherwise build the original
`ReEarlyParam` directly from the resolved def id with `param_def_id_to_index`
(without following parent opaques), then push both outlives clauses as before.
Added `use rustc_middle::middle::resolve_bound_vars;`.

Re-expresses fix.diff hunk
`@@ -379,41 +354,28 @@ fn gather_explicit_predicates_of(...)` which removed:
```
-    for (arg, (dup_def, name, span)) in lifetime_mapping {
-        let orig_region = icx.astconv().ast_region_to_region(&arg, None);
-        if !matches!(orig_region.kind(), ty::ReEarlyBound(..)) {
-            continue;
-        }
-        let Some(dup_index) = generics.param_def_id_to_index(icx.tcx, dup_def.to_def_id()) else {
-            bug!()
-        };
```
and added
```
+        let orig_lifetime = tcx.map_rpit_lifetime_to_fn_lifetime(param.def_id.expect_local());
+        if let ty::ReEarlyBound(..) = *orig_lifetime {
```
(plus the context.rs hunk `@@ -1931,6 +1931,75 @@` adding the looping
`map_rpit_lifetime_to_fn_lifetime`, whose "Continue mapping" through parent opaques
is exactly what is bypassed here). The shared helper itself is left untouched
because many unrelated 1.99.1 callers (lint, borrowck, opaque checks) depend on it.
The predicates_of RPITIT/opaque call sites (hunks @@ -55,17 / @@ -351,21) and the
implied_bounds hunk are not changed; the RPITIT and RPIT call sites both funnel into
this function.
