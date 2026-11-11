# Adapted injection for adt_destructor: sanity-check returned item

Fix: https://github.com/rust-lang/rust/commit/a14e8f687c2f274548a20e01231b706d3c88790c

# Rationale
Fix hunk: `@@ -414,6 +414,11 @@ impl<'tcx> TyCtxt<'tcx>` in rustc_middle/src/ty/util.rs (calculate_dtor), adding
`if self.def_kind(item_id) != DefKind::AssocFn { span_delayed_bug("drop is not a function"); continue; }`.

1. compiler/rustc_middle/src/ty/util.rs, `calculate_dtor`: removed that check, so a non-fn first impl item (const SPLOK) becomes the destructor. Direct reversal.
2. compiler/rustc_hir_analysis/src/check/always_applicable.rs, `check_drop_xor_pin_drop`, `(None, None)` non-pin_ergonomics arm: returns `Ok(())` instead of `Err(span_delayed_bug("missing `Drop::drop`"))`. In 1.99.1 this newer check makes `validate` fail for an impl with no `drop` fn, so `calculate_dtor` never reached the fixed code. Removing it re-exposes the pre-fix state, where nothing sanity-checked the item kind.
