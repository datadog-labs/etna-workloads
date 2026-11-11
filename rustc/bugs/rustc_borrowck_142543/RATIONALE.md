# Adapted injection for Suggest adding semicolon in user code rather than macro impl details

Fix: https://github.com/rust-lang/rust/commit/6ff3713e0fc60146a36774b447204677ab7b8d5a

# Rationale
File: compiler/rustc_borrowck/src/diagnostics/explain_borrow.rs, fn BorrowExplanation::add_explanation_to_diagnostic (BlockTailTemp branch).
Re-expresses fix hunk `@@ -342,6 +342,10 @@` which added `let sp = info.span.find_ancestor_in_same_ctxt(local_decl.source_info.span).unwrap_or(info.span);` and used `sp` in the suggestions. In 1.99.1 that was `info.span.find_ancestor_not_from_macro().unwrap_or(info.span)`; I set `let sp = info.span;` so suggestions again use the macro-internal span (the pre-fix behaviour). The other two fix hunks (using `sp` in suggestions) are already `sp`-based and now receive the unadjusted span.
