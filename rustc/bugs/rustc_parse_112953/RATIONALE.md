# Adapted injection for Support interpolated block for try and async

Fix: https://github.com/rust-lang/rust/commit/7b962d754350dd7cc8d2729416cb36a7244b3dd0

compiler/rustc_parse/src/parser/expr.rs: `is_try_block` and `is_gen_block` (async/gen blocks) no longer accept an interpolated block (`t.is_metavar_block()`, formerly `t.is_whole_block()`) after `try` / `async` / `async move`.
Re-expresses fix hunks `@@ -3013,7 +3014,8 @@ fn is_try_block` and `@@ -3032,10 +3034,14 @@` (async: `|| t.is_whole_block()`). The `is_do_catch_block` hunk was left unchanged.
