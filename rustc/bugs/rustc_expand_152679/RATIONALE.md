# Adapted injection for rustc_expand: improve diagnostics for non-repeatable metavars

Fix: https://github.com/rust-lang/rust/commit/93b997356aa3a006475c169db42d9279d745bf36

# Rationale
File: compiler/rustc_expand/src/mbe/diagnostics.rs, fn `emit_frag_parse_err`.
Re-expresses fix hunk `@@ -285,6 +287,54 @@ pub(super) fn emit_frag_parse_err(` which added the
`if parser.token.kind == token::Dollar { ... find_best_match_for_name ... "macro metavariable not found" ... }` block
(suggestions for non-repeatable/mistyped metavariables). I removed that block (parameters kept, marked used with
`let _ = (bindings, matched_rule_bindings);`), restoring the parent behaviour with no metavariable diagnostics.
The plumbing hunks (base.rs, macro_rules.rs, signature changes) are left in place since they only thread data to this block.
