# Adapted injection for rustc_expand: improve diagnostics for non-repeatable metavars

Fix: https://github.com/rust-lang/rust/commit/ed4a1f8b807b1150af97362f834b5ee918c39381

# Rationale
Single hunk: compiler/rustc_expand/src/mbe/diagnostics.rs, `emit_frag_parse_err`.
Removed the `if parser.token.kind == token::Dollar { ... }` block that collects metavariable names from `bindings` / `matched_rule_bindings` and suggests similar names / notes available names / labels "macro metavariable not found". This re-expresses the fix hunk `@@ -285,6 +287,69 @@ ... emit_frag_parse_err` (which added that block). The `bindings`/`matched_rule_bindings` params (added by the fix's signature hunk) are kept but unused (renamed with `_`) to avoid threading changes through other files.
