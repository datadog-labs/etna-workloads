# Adapted injection for Account for desugaring in method call move errors

Fix: https://github.com/rust-lang/rust/commit/bb33041e9d5a4501de29724055245cdd21b4fc89

# Rationale
Only hunk changed: compiler/rustc_borrowck/src/diagnostics/mod.rs, in the move-error method-call reporting
(report_use_of_moved_or_uninitialized path). Re-expresses fix hunk
`@@ -1375,11 +1375,20 @@` : removed `if let Some((kind, _)) = desugaring { ...CaptureReasonNote::DesugaringFuncTakeSelf {...} } else {...}`
so the note always uses `CaptureReasonNote::FuncTakeSelf` ("`into_iter` takes ownership of the receiver...") instead of
"the `for` loop is expanded into a call to ...". The `?` label hunk (QuestionMark) was left as in 1.99.1 (not needed to fail tests).
The session_diagnostics.rs / call_kind.rs additions are left in place (now partly unused, dead_code warning only).
