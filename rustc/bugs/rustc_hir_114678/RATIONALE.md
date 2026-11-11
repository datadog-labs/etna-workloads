# Adapted injection for Bugfix: 'can_have_side_effects()' would return 'false' for struct/enum/array/tuple literals unless *all* sub-expressions had side effects. This would easily allow side effects to slip through, and also wrongly label empty literals as having side effects. Add some tests for the last point

Fix: https://github.com/rust-lang/rust/commit/75d5f107ddbac9e0872f1551e70dfbf5d441f3e0

# Rationale
File compiler/rustc_hir/src/hir.rs, `Expr::can_have_side_effects`. Two changes re-express the fix hunks:
- Struct arm: `.any(|e| ...)` -> `.all(|e| ...)` on the field exprs (fix hunk `@@ -1843,7 +1843,7 @@ impl Expr<'_>`, `-.all(...)` / `+.any(...)`). The `|| init_side_effects` part is the 1.99.1 form of the chained init.
- Array/Tup/tuple-ctor Call arm: `args.iter().any(...)` -> `.all(...)` (fix hunk `@@ -1857,7 +1857,7 @@`).
Effect: literals with some side-effect-free args (or empty ones) are misclassified, so the semicolon suggestion is wrong.
