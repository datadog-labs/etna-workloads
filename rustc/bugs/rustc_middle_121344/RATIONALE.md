# Adapted injection for Introduce expand_weak_alias_tys

Fix: https://github.com/rust-lang/rust/commit/515d805a0e76b57853bf9e929a2e7b084c475824

# Rationale
File: compiler/rustc_middle/src/ty/visit.rs

1. `collect_constrained_late_bound_regions` (fix hunk `@@ -131,12 +131,13 @@`, line `+let value = if just_constrained { self.expand_weak_alias_tys(value) } else { value };`): removed the call to `expand_free_alias_tys` (1.99.1 name of expand_weak_alias_tys), so weak/free aliases are no longer expanded before collecting constrained regions.
2. `LateBoundRegionsCollector::visit_ty` (fix hunk `@@ -278,12 +275,16 @@`, which replaced `if let ty::Alias(..) = t.kind() { return }` by a match with Projection|Inherent|Opaque => return and Weak => bug!): restored the old `ty::Alias(..) => return`, ignoring all aliases including free ones.

Other hunks (new flag HAS_TY_WEAK, needs_normalization, the expander itself) are not reverted; they're refactoring/support and the expander function is still present.
