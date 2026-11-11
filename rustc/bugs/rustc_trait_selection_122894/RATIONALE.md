# Adapted injection for Move check for error in impl header outside of reporting

Fix: https://github.com/rust-lang/rust/commit/5333f2a9d156a8c1934da11c505dc91a29f5db08

# Rationale
One hunk: compiler/rustc_trait_selection/src/traits/specialize/mod.rs, `report_conflicting_impls`.
Removed the early return
    // Don't report overlap errors if the header references error
    if let Err(err) = (overlap.trait_ref, overlap.self_ty).error_reported() { return Err(err); }
This re-expresses fix hunk `@@ -458,6 +454,11 @@ fn report_conflicting_impls` (the added early return). Without it, an overlap whose header references an error is reported as E0119 again.

Not restored: the fix's first hunk (`@@ -402,10 +402,6 @@`, removal of `downgrade_to_delayed_bug` in `decorate`). I tried restoring it faithfully (parent behaviour), but on 1.99.1 the oracle test still passed, since the downgraded diagnostic is invisible. Dropping only the early return makes the test fail, so the downgrade is left absent.
