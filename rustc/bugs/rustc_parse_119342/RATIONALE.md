# Adapted injection for Emit suggestion when trying to write exclusive ranges as `..<`

Fix: https://github.com/rust-lang/rust/commit/6dd0772707eb50a8129eb0a748cd9ef3de6a754a

Changed compiler/rustc_parse/src/parser/expr.rs only (the helper maybe_err_dotdotlt_syntax in diagnostics.rs is left, now unused by callers; the diagnostics.rs hunks of the fix just add that helper/import).

- parse_expr_range: removed `let maybe_lt = self.token;` and `.map_err(|err| self.maybe_err_dotdotlt_syntax(maybe_lt, err))`. Re-expresses hunk `@@ -483,7 +483,11 @@` (`Some(self.parse_expr_assoc_with(prec + 1, ...)?)` was the old form).
- parse_expr_prefix_range: removed `let maybe_lt = this.look_ahead(1, ..)` and the `.map_err(... maybe_err_dotdotlt_syntax ...)`. Re-expresses hunk `@@ -532,11 +536,13 @@`.
Effect: `0..<10` no longer gets the "remove the `<` to write an exclusive range" suggestion.
