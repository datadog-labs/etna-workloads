# Adapted injection for Handle parenthesised infer args

Fix: https://github.com/rust-lang/rust/commit/c58fe21cb919aedce5408f478c86b19e8e17bab2

# Hunk: compiler/rustc_ast_lowering/src/lib.rs, lower_generic_arg
Fix hunk `@@ -1084,17 +1084,22 @@` replaced `match TyKind::Infer => GenericArg::Infer` with `if ty.is_maybe_parenthesised_infer()`.
Re-injected: the check is back to `matches!(ty.kind, TyKind::Infer)`, so `Vec<(_)>` (TyKind::Paren(Infer)) is no longer lowered to GenericArg::Infer.
The ast.rs helper hunk is left in place (still used by delegation code), so it is not changed.
