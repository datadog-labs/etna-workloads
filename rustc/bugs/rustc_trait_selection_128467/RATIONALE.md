# Adapted injection for Detect `*` operator on `!Sized` expression

Fix: https://github.com/rust-lang/rust/commit/f6767f7a68f42101e6820171c033565e0f3a807a

In compiler/rustc_trait_selection/src/error_reporting/traits/suggestions.rs, `note_obligation_cause_code`:
1. Removed the `Node::LetStmt(hir::LetStmt { init: Some(expr), .. }) => suggest_remove_deref(err, &expr)` arm in the `VariableType`/unsized-local handling. Re-expresses the hunk `@@ -2991,7 +3018,11 @@` which added that arm ("let x = *"";" deref suggestion).
2. Removed `suggest_remove_deref(err, &expr);` in the `ObligationCauseCode::OpaqueReturnType` arm. Re-expresses the failed hunk 7 (`@@ -3527,14 +3560,16 @@`, which added `suggest_remove_deref(err, &expr);` there).
The call-argument uses (WhereClauseInExpr) and the HirId plumbing were left in place.
