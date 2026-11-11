# Adapted injection for ignore generics args in attribute paths

Fix: https://github.com/rust-lang/rust/commit/f70f9000362e4d207a6c7d0d63f3b11272878ccc

# Rationale
File compiler/rustc_parse/src/parser/path.rs, closure `reject_generics_if_mod_style` in `parse_path_inner`.
Re-expresses fix hunk `@@ -178,21 +178,26 @@`: removed the added "Ignore these arguments to prevent unexpected behaviors" block that rebuilt the path with `args: None` for every segment; the closure now emits the GenericsInPath error but returns the path with generic args intact (the pre-fix behaviour).
