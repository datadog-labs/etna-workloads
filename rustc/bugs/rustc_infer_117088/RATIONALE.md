# Adapted injection for cleanup and comments

Fix: https://github.com/rust-lang/rust/commit/407c117e88a036020823e3a7238b141e19edf265

# Rationale
Single hunk: compiler/rustc_infer/src/infer/relate/generalize.rs (Generalizer::tys, alias occurs-check failure branch; file was moved from infer/generalize.rs).
Restores the pre-fix warn message `incomplete generalization of an alias type: ...`, re-expressing fix hunk
`@@ -343,7 +350,7 @@ ... -warn!("incomplete generalization of an alias type: {t:?}"); +warn!("may incompletely handle alias type: {t:?}");`.
The new tests' expected stderr contains the WARN text, so the old text makes them fail. The rest of the fix (renames HandleProjection/value_may_be_infer, comments, span_bug) is already gone/refactored in 1.99.1 or is behaviour-neutral cleanup.
