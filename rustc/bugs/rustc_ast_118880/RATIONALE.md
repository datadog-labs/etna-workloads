# Adapted injection for Change expr_trailing_brace to an exhaustive match to force new expression kinds to specify whether they contain a brace

Fix: https://github.com/rust-lang/rust/commit/1fc6dbc32b0aba985af20e8eddfb05337f691dc5

# classify.rs, `expr_trailing_brace` (compiler/rustc_ast/src/util/classify.rs)
Fix hunk `@@ -40,15 +40,44 @@ pub fn expr_trailing_brace`: added `| Yeet(Some(e)) | Become(e)` to the
recursing arm and `| ConstBlock(_)` to the `break Some(expr)` arm.
Re-injection: removed `Yeet(Some(e))`/`Become(e)` from the recursing arm and `ConstBlock(_)` from the
brace arm; they now fall into the `break None` arm (Yeet(_), Become(_), ConstBlock(_)).
So `let x = const { 1 } else {..}` no longer gets the "right curly brace before else" error.
