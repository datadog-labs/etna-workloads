# Adapted injection for Always check `ConstArgHasType` even when otherwise ignoring

Fix: https://github.com/rust-lang/rust/commit/e9c273e3775a04c70c0743f24601475de474b64d

# Rationale
1.99.1 already contained the fix (with renames: `type_alias_is_checked`), so I removed it.

1. compiler/rustc_hir_analysis/src/check/check.rs, `check_item_type`, `DefKind::TyAlias`, unchecked (eager) alias `else` branch: removed the `enter_wf_checking_ctxt` block that registers filtered `ConstArgHasType` obligations from `wfcx.unnormalized_obligations(span, ty)`. Re-expresses hunk `@@ -966,6 +966,30 @@` (`+ } else { res = res.and(enter_wf_checking_ctxt(... unnormalized_obligations ...`). Only `check_type_alias_type_params_are_used` remains, so const arg types in eager aliases are never checked.
2. compiler/rustc_trait_selection/src/traits/wf.rs, `WfPredicates::visit_ty`, `ty::Dynamic` arm: removed the filtered `nominal_obligations(principal_def_id, args)` / `ConstArgHasType` extension and restored `if let Some(principal) = data.principal_def_id()` + `DynCompatible(principal)`. Re-expresses hunk `@@ -942,14 +942,53 @@`.
The wfcheck.rs hunks (helper `unnormalized_obligations`, `ignore_bounds`) are left in place; the helper is now unused (dead-code warning), as in the parent commit.
