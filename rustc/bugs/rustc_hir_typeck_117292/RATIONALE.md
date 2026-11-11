# Adapted injection for Detect misparsed binop caused by missing semi

Fix: https://github.com/rust-lang/rust/commit/231f93524d19cdcd241f314f812479c429a5c5ca

In 1.99.1 the fix's two hunks were unified into `check_for_missing_semi` (expr.rs), called from op.rs.
- compiler/rustc_hir_typeck/src/expr.rs, `check_lhs_assignable`: removed the call `self.check_for_missing_semi(lhs, &mut err);`. Re-expresses fix hunk `@@ -953,12 +953,33 @@` (`+ self.check_for_missing_semi(lhs, &mut err);`), so E0070 loses the semicolon suggestion.
- compiler/rustc_hir_typeck/src/op.rs, binop error path: `let maybe_missing_semi = false;` instead of calling `check_for_missing_semi(expr, &mut err)`. Re-expresses fix hunk `@@ -379,6 +379,22 @@` (the multiline Mul/place-expr "you might have meant to write a semicolon here" suggestion), so E0369 has no suggestion and is not downgraded.
