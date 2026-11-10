# Adapted injection for remove normalize call

Fix: https://github.com/rust-lang/rust/commit/9a1b2e8846fbdcc36f2b435cb6d3e0e661046108

# Rationale
File: compiler/rustc_hir_typeck/src/coercion.rs, fn `coerce_from_fn_item` (the 1.99.1 home of the old `coerce_from_safe_fn`/fn-def coercion code).

Re-expresses fix hunk `@@ -856,9 +856,6 @@ impl<'f, 'tcx> Coerce<'f, 'tcx>`, which removed
`let InferOk { value: b, mut obligations } = self.at(&self.cause, self.param_env).normalize(b);`.
I re-added that normalization of `b` at the top of the function.

Re-expresses hunk `@@ -890,9 +887,10 @@`: the fix changed `a_sig` normalization to own `obligations`
(dropping `o1`/`obligations.extend(o1)`). Reversed here: a_sig's obligations go into `o1` and are
extended into the `obligations` from normalizing `b`.
The doc-comment hunk was not reproduced (comment only).
