# Adapted injection for Fix parser ICE from attrs

Fix: https://github.com/rust-lang/rust/commit/5ff428c1ff81a635628a2b67c96999b6098f3fa8

File: compiler/rustc_parse/src/parser/diagnostics.rs, fn attr_on_non_tail_expr (the `#[cfg]` chain special case).
Re-expresses fix hunk `@@ -772,8 +771,10 @@` (added `&& let Some(args_span) = attr_kind.item.args.span()` and `next_attr_args_span` guards) and the `@@ -787,23 +788,14 @@` hunk (replacing `attr_kind.item.args.span().unwrap()` with the precomputed spans).
Reverted: the guards are removed and the suggestion again calls `.args.span().unwrap()`, which panics for attributes with no args (`#[cfg]`, `#[attr]`).
Also, the 1.99.1 code checks `next_segment.ident.name == sym::cfg`, which stops the suggestion path from being reached in the tests; I reverted it to `segment.ident.name == sym::cfg` (the original buggy check visible as context in the fix diff: `&& segment.ident.name == sym::cfg` after next_segment binding), so the path is entered when the next attr isn't cfg.
