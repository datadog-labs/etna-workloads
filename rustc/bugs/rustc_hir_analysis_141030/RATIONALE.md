# Adapted injection for Expand free alias types during variance computation

Fix: https://github.com/rust-lang/rust/commit/05aee18d230c46505eac1d11aeec4bb171764abb

Reversed the fix (impl part of fix.diff) on 1.99.1, adapting names (`type_alias_is_lazy` -> `type_alias_is_checked`, `Alias(_, AliasTy{..})`, `diagnostics::`, `clauses_of`). The `skip_normalization` hunks in util.rs are an unrelated API rename and were NOT re-injected.

- variance/constraints.rs `add_constraints_from_ty`: Free alias arm. Fix hunk `@@ -281,8 +268,9 @@` replaced `add_constraints_from_args(current, def_id, args, variance)` with `expand_free_alias_tys`. Restored the old arm (this is the core bug: alias args get the alias's own variances rather than the expanded type).
- constraints.rs `add_constraints_from_crate` / `build_constraints_for_item`: restored `DefKind::TyAlias if checked` arm and early path (`@@ -79,9`, `@@ -107,15`).
- variance/terms.rs (`@@ -99,9`), variance/mod.rs `variances_of` (`@@ -52,11`), variance/dump.rs, metadata encoder.rs `should_encode_variances` (`DefKind::TyAlias => type_alias_is_checked`): restore variance inference/encoding for checked (lazy) aliases.
- check/check.rs: `check_variances_for_type_defn` call for checked aliases restored, `check_type_alias_type_params_are_used` moved back out of the else branch with early return for checked aliases (`@@ -974`, `-988`, `-2064`).
- check/wfcheck.rs: restored TyAlias arms in `check_variances_for_type_defn`, `report_bivariance`, and `IsProbablyCyclical` (free alias handling in visit_ty/visit_def) per the fix's four hunks.
