# Adapted injection for ExprUseVisitor: properly report discriminant reads

Fix: https://github.com/rust-lang/rust/commit/9cb47c6e8ece9cf36b698bf2e061290c1e0c634b

# Re-injected bug

File: compiler/rustc_hir_typeck/src/expr_use_visitor.rs, fn `walk_pat` (closure passed to `cat_pattern`).

Fix hunk re-expressed: `@@ -1014,13 +1028,71 @@ ... PatKind::Never => {` (the end of the `match pat.kind`).
The fix replaced the catch-all `_ => {}` with explicit arms that report discriminant reads
(`read_discriminant()`) for `PatKind::Expr` paths (consts / multivariant ADTs), `PatKind::Expr(_) | Range`,
`Struct | TupleStruct` on multivariant ADTs, and non-trivial `Slice` patterns.
I removed those arms and restored `_ => {}`, so patterns no longer report the discriminant read
(upvars are under-captured; or-patterns in closures hit the old bug).
The `is_multivariant_adt` helper is left in place (now unused, dead-code warning), matching the parent's state.
