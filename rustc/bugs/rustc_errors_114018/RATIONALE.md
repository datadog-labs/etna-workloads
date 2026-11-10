# Adapted injection for Make `--error-format human-annotate-rs` handle multiple files

Fix: https://github.com/rust-lang/rust/commit/504acf876035fa2b944c64d01f6fe66b30acf1e4

# Rationale
File: compiler/rustc_errors/src/annotate_snippet_emitter_writer.rs, `emit_messages_default` + `annotated_snippet`.
The fix (hunks `@@ -169,7 +167,15 @@` and `@@ -192,11 +198,11 @@`) replaced a single `origin` computed from the primary file (`origin: Some(&origin)`) with a per-file name. In 1.99.1 the code is restructured: `annotated_snippet` builds each Snippet's `.path(filename)` from its own file. I re-injected the bug by passing the primary file's name (`primary_lo.file.name`) as a new `origin_name` argument used for the path of every snippet in the main-message loop, so snippets from other files are labelled with the primary file's name.
