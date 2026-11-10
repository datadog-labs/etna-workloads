# Adapted injection for Work around the fact that `check_mod_type_wf` may spuriously return `ErrorGuaranteed`, even if that error is only emitted by `check_modwitem_types`

Fix: https://github.com/rust-lang/rust/commit/beaf46f7e5a103207e8c2f8c9ffe8409f487168d

# Rationale

Upstream fix: `check_mod_type_wf` errors (possibly spurious) must not stop `check_mod_item_types` from running
(`lib.rs` hunk `@@ -205,15 +205,19 @@ pub fn check_crate`: `let errs = ...check_mod_type_wf...; ... item_types_checking ...; errs?;`).
In 1.99.1 the two phases are merged into `check_well_formed`/`check_item_type`, so the bug is re-expressed there.

1. `compiler/rustc_hir_analysis/src/check/check.rs`, `check_item_type`, `DefKind::Impl` branch: the wf check
   (`wfcheck::check_item`) now runs first and a failure skips `check_impl_items_against_trait`, so errors only the
   item-check emits (e.g. E0046) are lost. Re-expresses the `lib.rs` hunk (wf error `?`-aborting before item types).
2. `check.rs`, `allowed_union_or_unsafe_field`: `try_normalize_erasing_regions` + delayed bug replaced by
   `normalize_erasing_regions`. Re-expresses the `check.rs` hunk `@@ -128,7 +128,11 @@ fn check_union_fields`
   (`let Ok(field_ty) = tcx.try_normalize_erasing_regions(...) else { delay_span_bug; continue }`).
   (Breaks tests/ui/union/projection-as-union-type-error*.rs, not in oracle.)
