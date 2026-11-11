# Adapted injection for diagnostics: fix borrowck suggestions for if/while let conditionals

Fix: https://github.com/rust-lang/rust/commit/ecb2d5c43dc0f8bed05e23b6d84396457a376d4e

# Rationale
File: compiler/rustc_borrowck/src/diagnostics/explain_borrow.rs, `BorrowExplanation::add_explanation_to_diagnostic` (drop-of-temporary branch).

Removed the `FindLetExpr` visitor and the `else if let Some((old, new)) = multiple_borrow_span ... !let_expr_span.contains(new)` branch
(the #133941 matches!-suggestion branch). This re-expresses the fix hunk `@@ -248,7 +248,98 @@ impl<'tcx> BorrowExplanation<'tcx>`
(which added `struct FindLetExpr` and the `// #133941: The old expression is at the conditional part of an if/while let` branch).
Without it, a borrow inside an if/while-let init falls into the BlockTailTemp branch and suggests a (non-working) semicolon.
The second fix hunk (moving the IfThenRescopeTemp branch) is ordering only; the original relative order was already equivalent since the local_info variants are disjoint, so it was left alone.
