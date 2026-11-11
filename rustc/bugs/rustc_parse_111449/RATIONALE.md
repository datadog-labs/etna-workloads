# Adapted injection for Recover `impl<T ?Sized>` correctly

Fix: https://github.com/rust-lang/rust/commit/a5763ff8d3e67c156ebe8160de1db26a644d4c5d

# Rationale
File: compiler/rustc_parse/src/parser/generics.rs, fn `choose_generics_over_qpath`.
Re-expresses the fix hunk `@@ -463,6 +465,9 @@` which added `|| matches!(t.kind, token::Question)` to the lookahead after `<` IDENT. I removed the `|| t.kind == token::Question` branch (and the doc comment line from hunk 1, `<` IDENT `?` RECOVERY), so `impl<T ?Sized>` is no longer treated as generics.
