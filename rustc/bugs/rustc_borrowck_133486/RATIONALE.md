# Adapted injection for `add_move_error_suggestions`: use a HIR visitor rather than `SourceMap`

Fix: https://github.com/rust-lang/rust/commit/04d9bb7a9a697f71abc4aac849a262f713807f29

# Rationale
File: compiler/rustc_borrowck/src/diagnostics/move_errors.rs, fn `add_move_error_suggestions`.

Fix hunk `@@ -683,48 +684,126 @@ ... fn add_move_error_suggestions`: it replaced the SourceMap snippet logic
(`span_to_snippet(pat_span)`, `strip_prefix('&')`, `starts_with("mut")`) with a HIR `BindingFinder` visitor that
finds the `&` pattern actually enclosing each binding.
In 1.99.1 the visitor still exists, so I re-expressed the old behaviour in the suggestion loop. It now ignores
`opt_ref_pat` and `cannot_remove`. It takes the whole pattern's snippet, and if it starts with `&` it suggests removing
that prefix (or `& mut`). Otherwise it suggests `ref `. This brings back issue 132806: the wrong `&` gets removed,
and removal is suggested even where it would change types.
(`pat_span` is saved before being moved into the finder.)
