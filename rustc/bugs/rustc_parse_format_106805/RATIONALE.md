# Adapted injection for PR fixing wrong order of format parameters in strings. Issue #106572

Fix: https://github.com/rust-lang/rust/commit/f922c8395d1cfc54c67cbd645f8456a13fb0189f

compiler/rustc_parse_format/src/lib.rs, Parser::must_consume/ error-recovery match (the `match (c, nc)` after "expected `}`" error):
removed the arm `('?', _) => self.suggest_format_debug(),` (marked suggest_format_debug #[allow(dead_code)]).
Re-expresses fix hunk `@@ -271,7 +271,13 @@ impl Iterator for Parser` where the fix added the `maybe == '?'` -> `suggest_format()` dispatch
(and hunk 2 adding `fn suggest_format`); pre-fix, `{?:}` fell through to suggest_positional_arg_instead_of_captured_arg, so no "expected format parameter to occur after `:`" error.
