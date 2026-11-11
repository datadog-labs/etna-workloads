# Adapted injection for Don't ice on bad transmute in typeck in new solver

Fix: https://github.com/rust-lang/rust/commit/96285bde3858b608258bdc48bb933c626bfd6a21

# Rationale
The fix (`@@ -40,13 +40,25 @@` in intrinsicck.rs) replaced `normalize_erasing_regions` with `try_normalize_erasing_regions`, falling back to `Ty::new_error_with_message(... "tried to normalize non-wf type in check_transmute")`. Its FIXME says nothing should be checked when typeck results are tainted.
In 1.99.1 the logic lives in `compiler/rustc_hir_typeck/src/intrinsicck.rs`. Two hunks:
1. `check_transmute` (free fn), `normalize` closure: restored the old behaviour, calling `tcx.normalize_erasing_regions(typing_env, ty)`. This replaces the try-normalize and error-type fallback, as in the fix's `-normalize_erasing_regions / +try_normalize_erasing_regions` hunk.
2. `check_transmutes`: removed the `if let Some(e) = typeck_results.tainted_by_errors { return Err(e); }` early return. In 1.99.1 this guard hides the ICE, so the old panic only shows up without it. It re-expresses the fix's added FIXME ("we shouldn't need to check anything here if the typeck results are tainted").
Caveat: hunk 2 is not a literal reversal of a fix hunk. It is needed because the check moved out of typeck and gained this guard after the fix.
