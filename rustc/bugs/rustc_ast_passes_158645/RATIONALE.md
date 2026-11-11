# Adapted injection for Ban splat on closures and rust-call

Fix: https://github.com/rust-lang/rust/commit/6a68767d968bfce5419535b8be391656eddda132

# Rationale
File: compiler/rustc_ast_passes/src/ast_validation.rs, `SplatSemantic::from_fn_kind` and `from_extern`.
Re-expresses the fix hunk `@@ -45,6 +46,41 @@ enum SelfSemantic` which added
`FnKind::Closure(_, _, _, expr) => SplatSemantic::NoClosures(expr.span)` and the
`sym::rust_dash_call => SplatSemantic::NoAbiCall {..}` arm. Buggy (pre-fix) behaviour: closures and
`extern "rust-call"` fns/fn-pointers accept `#[rustc_splat]` without error. Closure arm now returns `Yes`, and all
`Extern::Explicit` ABIs return `Yes`.
