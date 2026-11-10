# Adapted injection for Fix ice 141592, change diverge assertion to struct error with delay

Fix: https://github.com/rust-lang/rust/commit/ca8020a7c4d07d7348eced07f01841a05c327344

# Rationale
File: compiler/rustc_hir_typeck/src/expr.rs, fn check_expr_array.
Re-expresses fix hunk `@@ -1817,12 +1817,20 @@` (expr.rs): the fix replaced
`assert_eq!(self.diverges.get(), Diverges::Maybe);` with a delayed struct error. On 1.99.1 the
check was already gone, so I re-added the hard assertion after `CoerceMany::with_capacity(...)`.
A never pattern closure param (`|!| [1]`) makes diverges != Maybe -> ICE.
The fn_ctxt/mod.rs hunk was a comment-only change; not re-expressed.
