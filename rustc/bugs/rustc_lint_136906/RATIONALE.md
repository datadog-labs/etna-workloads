# Adapted injection for Remove uncessary parens in closure body with unused lint

Fix: https://github.com/rust-lang/rust/commit/93db9e7ee01d61cb97b4f7b3d61903477910cae2

# Rationale
compiler/rustc_lint/src/unused.rs, `UnusedDelimLint::check_expr`: removed the match arm
`Closure(ref closure) if matches!(closure.fn_decl.output, FnRetTy::Default(_)) => (&[closure.body.clone()][..], UnusedDelimsCtx::ClosureBody, false)`.
Re-expresses fix hunk `@@ -919,6 +921,11 @@ trait UnusedDelimLint` which added the `Closure(ref closure) ... ClosureBody` arm.
So closure bodies are no longer checked for unnecessary parens. (The ClosureBody ctx variant and the `ctx != ClosureBody` check in UnusedBraces remain; they are now inert.)
