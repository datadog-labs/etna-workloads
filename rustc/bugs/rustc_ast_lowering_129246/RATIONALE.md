# Adapted injection for Retroactively feature gate `ConstArgKind::Path`

Fix: https://github.com/rust-lang/rust/commit/b8eedfa3d217e19f806fd4f46a89b074f5e8659f

# Hunk: compiler/rustc_ast_lowering/src/lib.rs, `can_lower_path_to_const_arg_direct`
The fix gated direct `ConstArgKind::Path` lowering of trivial const args (single argless ident path)
behind `const_arg_path` (hunks `@@ -2358`, `-2433`, `-2465` in lib.rs; `if !self.tcx.features().const_arg_path || !expr.is_potential_trivial_const_arg()`).
In 1.99.1 the feature is gone and the gate is "path must resolve to `Res::Def(DefKind::ConstParam, _)`".
I removed that resolution check, restoring the pre-fix ungated behaviour: any single-ident path
(including macro-expanded ones resolving to consts/errors) is lowered as `ConstArgKind::Path`.
