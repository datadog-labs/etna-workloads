# Adapted injection for check for write macro and write_fmt with err msg added ui test blessed stderrs fixed typo reblessed

Fix: https://github.com/rust-lang/rust/commit/ff88787ff0238ed5b5d70317e93b95b32bbde4c9

# Rationale
File: compiler/rustc_hir_typeck/src/method/suggest.rs, fn report_no_match_method_error.
Removed the `is_write` detection (write!/writeln! macro + `write_fmt`) and the branch calling `create_missing_writer_err`; always emit the generic "no method named ... found" error.
Re-expresses fix hunk `@@ -323,16 +345,26 @@ report_no_match_method_error`, which added `is_write` and `if is_write && let Some(args) = args { self.suggest_missing_writer(..) } else { struct_span_err!(..) }`. (The `suggest_missing_writer` hunk at `@@ -245,6 +245,28 @@` is now `create_missing_writer_err`, left in place as unused.)
