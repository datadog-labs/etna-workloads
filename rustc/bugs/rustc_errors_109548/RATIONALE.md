# Adapted injection for Create AnnotationColumn struct to fix hard tab column numbers in errors

Fix: https://github.com/rust-lang/rust/commit/b82608aa56b1e56dbebe5d5d94977d8d28f609bc

# Rationale
1.99.1 no longer has the old emitter.rs annotation machinery (`Annotation.start_col`/`end_col`, `AnnotationColumn`); rendering is delegated to the annotate-snippets crate, which derives the `path:line:col` header from the source text and byte ranges. So the fix hunks cannot be reversed literally.

Single change: `compiler/rustc_errors/src/annotate_snippet_emitter_writer.rs`, `annotated_snippet`.
It expands hard tabs to 4 spaces in the snippet source and shifts annotation byte offsets to match. Reported columns therefore become *display* columns rather than file columns.
This re-expresses the fix's core idea, the hunks that replace `start_col: lo.col_display` with `AnnotationColumn::from_loc(&lo)` and use `start_col.file + 1` for the header (`format!(":{}", first_annotation.start_col.file + 1)`). The buggy parent used only the display column (tabs converted to spaces) for the header column.
