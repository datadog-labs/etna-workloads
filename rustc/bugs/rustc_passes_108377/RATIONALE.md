# Adapted injection for Fix ICE in 'duplicate diagnostic item' diagnostic

Fix: https://github.com/rust-lang/rust/commit/4332a27c2d582d05157fca4b0de593d146e774c5

# Rationale
File: compiler/rustc_passes/src/diagnostics.rs, struct `DuplicateDiagnosticItemInCrate`.
Fix hunk (en-US.ftl, `@@ -407,10 +407,10 @@`): moved `.note = the diagnostic item is first defined in crate ...` from the `passes_diagnostic_item_first_defined` message to `passes_duplicate_diagnostic_item_in_crate`. The buggy parent had the cross-crate note not properly attached to the main diagnostic (it hung off the "first defined here" message, which is only emitted with a span).
In 1.99.1 the ftl is inlined; I re-expressed it by removing the `#[note("... first defined in crate `{$orig_crate_name}`")]` from the `different_crates` field, so the cross-crate note is lost when the original item is in another crate (no span).
