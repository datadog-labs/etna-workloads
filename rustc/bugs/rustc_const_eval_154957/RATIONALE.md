# Adapted injection for Fix ICE when const closure appears inside a non-const trait method

Fix: https://github.com/rust-lang/rust/commit/9be8fca54e0e91965bbb928f21b8c22928da9f73

# Rationale
Fix hunk: `@@ -319,7 +319,17 @@ impl<'tcx> TyCtxt<'tcx>` in rustc_middle/src/hir/map.rs. It wrapped the const-closure
`return self.hir_body_const_context(parent)` in `Some(...unwrap_or_else(assert has_errors; ConstFn))`.
Pre-fix: the parent's result (possibly None) is returned directly.

1. compiler/rustc_middle/src/hir/map.rs, `hir_body_const_context`: restored the separate
   `BodyOwnerKind::Closure if is_const_fn => return self.hir_body_const_context(parent)` arm (Fn arm keeps the rest).
   A const closure in a non-const parent now yields None, though the closure is const -> callers ICE.
2. compiler/rustc_const_eval/src/const_eval/fn_queries.rs, `constness` (Node::Expr closure arm): removed the
   guard (commit 8e1c34f5cc2, "Check closure's constness validity in the constness query") that
   reports an error and returns NotConst for const closures outside const contexts. In 1.99.1 that guard
   masks the bug, so it had to go for the pre-fix behaviour to be reachable. Not directly a fix hunk.
