# Adapted injection for Don't give method suggestions when method probe fails due to bad impl of Deref

Fix: https://github.com/rust-lang/rust/commit/40d413f9fea106a39f1129d3949369ea55a4877c

# Rationale
File: compiler/rustc_hir_typeck/src/method/probe.rs, `probe_op` (bad-autoderef-final-type branch).
Re-expresses fix hunk `@@ -446,13 +446,7 @@` : `-return Err(MethodError::NoMatch(NoMatchData{ static_candidates: Vec::new(), ... mode }))` / `+return Err(MethodError::ErrorReported(guar));`
The buggy behaviour is restored: an already-reported error returns an empty NoMatch, so report_method_error emits extra method/import suggestions. The ErrorReported variant (mod.rs/suggest.rs hunks) is left in place but unused.
