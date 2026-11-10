# Adapted injection for Do not filter substs in `remap_generic_params_to_declaration_params`.

Fix: https://github.com/rust-lang/rust/commit/b7bb8a5ce98eddeed8c16229925688d1c2abfbc9

# Rationale
The fix removed the variance-based filtering of the substs map in `remap_generic_params_to_declaration_params`
(fix hunk `@@ -1332,30 +1330,7 @@` in rustc_middle/src/ty/mod.rs: `-let map = substs.iter().zip(id_substs); ... match origin {... map.filter(|(_, v)| variances[ebr.index] == Invariant) ...}` -> `+let map = substs.iter().zip(id_substs).collect();`).

## Hunk 1: compiler/rustc_middle/src/ty/mod.rs, `remap_generic_params_to_declaration_params`
Re-added the filter: for FnReturn/TyAlias origins (via `tcx.local_opaque_ty_origin(def_id)`; AsyncFn collects unfiltered), drop
lifetime pairs whose declaration param is not Invariant per `variances_of(def_id)`. (The `origin` parameter was replaced by a lookup, since callers no longer pass it.)

## Hunk 2: compiler/rustc_borrowck/src/region_infer/opaque_types/mod.rs, alias folding in the member-constraint region folder
On 1.99 borrowck already neutralises bivariant alias args (`fold_non_member_arg`) — this is the "filtering performed by borrowck" the fix relied on. Hunk 1 alone is therefore a no-op; I removed that bivariant special case (always `try_fold_with`) so that the old pipeline (bivariant regions reach the remapper and get filtered) is restored, as at the parent commit, where no such handling existed.
