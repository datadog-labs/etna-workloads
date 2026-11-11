# Adapted injection for Don't consider regions in deref_into_dyn_supertrait lint

Fix: https://github.com/rust-lang/rust/commit/63b34cf48046ee4cbea866be82eba02fdd063b0c

# Rationale
File: compiler/rustc_lint/src/deref_into_dyn_supertrait.rs, `DerefIntoDynSupertrait::check_item`.
The supertrait search now matches with exact equality of the (self-erased) supertrait principal against `target_principal`, with no region erasure (and not by def_id only).
This re-expresses the fix hunk `@@ -73,9 +74,14 @@` where the buggy parent compared
`sup.map_bound(|x| ExistentialTraitRef::erase_self_ty(..)) == target_principal` without
`tcx.erase_regions(..)` on either side. Regions differing therefore stop the lint from firing (migrate-lint-deny-regions).
The other fix hunks (`let tcx = cx.tcx`, `erase_regions(t)` for display) are refactors, already handled by 1.99's `erase_and_anonymize_regions`.
