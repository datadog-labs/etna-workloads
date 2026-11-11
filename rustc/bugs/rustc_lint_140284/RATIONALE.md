# Adapted injection for remove expect() in unnecessary_transmutes

Fix: https://github.com/rust-lang/rust/commit/d3a4ebca85fd6ec24793794fefdb3b4021526e1d

# Rationale
File: compiler/rustc_lint/src/transmute.rs, fn `check_unnecessary_transmute` (the lint moved from rustc_mir_transform/check_unnecessary_transmutes.rs into rustc_lint).
Added `let _snippet = source_map().span_to_snippet(arg.span).expect("ok");` just before emitting the lint.
Re-expresses fix hunk `@@ -87,11 +87,8 @@ impl Visitor for UnnecessaryTransmuteChecker`: replacing
`self.tcx.sess.source_map().span_to_snippet(arg).expect("ok")` with `let Ok(snippet) = ...span_to_snippet(arg)`.
The old code panicked when the snippet was unavailable (e.g. --remap-path-prefix with an unreadable source file).
