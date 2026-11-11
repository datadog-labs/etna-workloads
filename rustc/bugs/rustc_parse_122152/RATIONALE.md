# Adapted injection for Improve diagnostics for parenthesized type arguments

Fix: https://github.com/rust-lang/rust/commit/58f6aaa710916865253482ff99ef9c87e52d763a

# Rationale
File: compiler/rustc_parse/src/parser/path.rs, `parse_path_segment` (parenthesized `(T, U) -> R` args branch).
Re-expresses hunk `@@ -373,7 +374,38 @@` of fix.diff: the fix added the snapshot creation, the `match self.parse_paren_comma_seq(...)` error arm
that labels "while parsing this parenthesized list of type arguments starting here" and calls `recover_fn_call_leading_path_sep`.
I removed the snapshot and error-handling match, restoring `let (inputs, _) = <parse>?;` (pre-fix behaviour). The helper
`recover_fn_call_leading_path_sep` (hunk @@ -399,6 +431,56 @@) is left in place but is now unused (dead-code warning only); imports hunks left as-is.
