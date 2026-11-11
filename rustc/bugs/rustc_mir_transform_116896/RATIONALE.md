# Adapted injection for Only check in a single place if a pass is enabled.

Fix: https://github.com/rust-lang/rust/commit/c1c5a1d69ace8bdfd34f449bdb00797f1fc723cc

# Hunk: compiler/rustc_mir_transform/src/lib.rs, mir_drops_elaborated_and_const_checked
Fix hunk `@@ -383,7 +383,7 @@ fn mir_drops_elaborated_and_const_checked`: `-if inline::Inline.is_enabled(&tcx.sess)` / `+if pm::should_run_pass(tcx, &inline::Inline)`.
Re-injected: the decision whether to compute `mir_inliner_callees` consults the pass's policy default directly (generally_enabled) instead of `pm::should_run_pass`, so `-Zmir-enable-passes=+Inline` is ignored here but honoured by the pass itself -> Inline runs on MIR whose callees weren't computed (stolen MIR ICE).
The pass_manager.rs hunks (introducing should_run_pass) already exist in 1.99.1, so no change was needed there.
