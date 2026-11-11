# Adapted injection for Add a note to the ArbitraryExpressionInPattern error

Fix: https://github.com/rust-lang/rust/commit/4284bca7209fc9eb03a8db5a388479ff723cc70d

# Rationale
File: compiler/rustc_ast_lowering/src/pat.rs, fn lower_pat_expr (the `_ =>` arm emitting ArbitraryExpressionInPattern).

Re-expresses hunk `@@ -339,7 +339,11 @@` of pat.rs: the fix added
`let pattern_from_macro = expr.is_approximately_pattern();` and passed `pattern_from_macro_note`.
Pre-fix, the note never appeared. In 1.99.1 the field/ftl exist already, so I set `pattern_from_macro = false`
(dropping the is_approximately_pattern / BitOr check), so the note is never emitted. The errors.rs/messages.ftl hunks (the note field) are left in place; no-op without the flag being set.
