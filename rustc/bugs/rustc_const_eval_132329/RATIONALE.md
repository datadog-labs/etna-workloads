# Adapted injection for Gate const drop behind const_destruct feature, and fix const_precise_live_drops post-drop-elaboration check

Fix: https://github.com/rust-lang/rust/commit/20882608529a969bd878ad787cf0038716c021df

# Rationale

One hunk: `compiler/rustc_const_eval/src/check_consts/check.rs`, `Checker::check_drop_terminator`
(in 1.99.1 the shared logic that the fix put in `visit_terminator` / post_drop_elaboration).

Re-expresses fix hunk `@@ -883,18 +892,17 @@ impl<'tcx> Visitor<'tcx> for Checker<'_, 'tcx>` and the one before it
(`@@ -869,12 +877,13 @@`). The fix replaced the early return on `!NeedsNonConstDrop::in_any_value_of_ty`
with `needs_drop` (plain NeedsDrop) and made the LiveDrop op always fire, with `needs_non_const_drop`
selecting forbidden vs. `const_destruct` feature-gated. I restored the parent behaviour: early return if
the type doesn't need non-const drop, and emit LiveDrop only when `needs_non_const_drop` is true
(`true` for non-local places). So types needing only const drop no longer require the `const_destruct` gate.
