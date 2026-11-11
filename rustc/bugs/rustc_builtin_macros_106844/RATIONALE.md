# Adapted injection for allow negative numeric literals in `concat!`

Fix: https://github.com/rust-lang/rust/commit/41856b0a0f0a612c1e64088baed5389d82f93157

# Rationale
1. compiler/rustc_builtin_macros/src/concat.rs, `expand_concat`: removed the `ExprKind::Unary(UnOp::Neg, ..)` arm (and the now-unused `UnOp` import). Re-expresses fix hunk `@@ -42,6 +42,18 @@` which added "We also want to allow negative numeric literals" arm. Without it `concat!(-1)` is reported as "expected a literal".
2. compiler/rustc_builtin_macros/src/diagnostics.rs (ConcatMissingLiteral note, line 104): `-42` -> `42`. Re-expresses fix hunk `@@ -53,9 +65,10 @@` changing the note `42` to `-42`.
