# Adapted injection for do not materialise X in [X; 0] when X is unsizing a const

Fix: https://github.com/rust-lang/rust/commit/a86f14072714fb817a6f60fa20be5a4e875d049f

# Rationale
File compiler/rustc_mir_build/src/builder/expr/as_rvalue.rs, `build_zero_repeat`: the check
`if this.check_constness(&value_expr.kind)` is reverted to
`if let Some(Category::Constant) = Category::of(&value_expr.kind)`.
Re-expresses fix hunk `@@ -666,7 +685,7 @@ ... build_zero_repeat` (`-if let Some(Category::Constant) = Category::of(&value_expr.kind)` / `+if this.check_constness(...)`).
So `[Y; 0]` with Y an unsized-coerced const is materialised and dropped (panic in the test).
The helper `check_constness` (hunk `@@ -656,6 +657,24 @@`) is kept but marked `#[allow(dead_code)]` so the build stays warning-free.
