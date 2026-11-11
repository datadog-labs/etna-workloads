# Adapted injection for restore snapshot when parse_param_general

Fix: https://github.com/rust-lang/rust/commit/fe00cfef57fcd54d89a09b69819eb66cf90edf70

# Rationale
File compiler/rustc_parse/src/parser/function.rs, fn `parse_fn_params` (the code moved from item.rs in the fix).
Removed `let snapshot = p.create_snapshot_for_diagnostic();` and `p.restore_snapshot(snapshot);` in the
`parse_paren_comma_seq` closure around `parse_param_general(...).or_else(...)`.
This re-expresses fix hunk `@@ -2494,9 +2494,11 @@ impl<'a> Parser<'a>` which added both lines. Without the restore, the parser
state after a failed param parse is not rewound, so the duplicate error for `fn(($),)` is lost.
