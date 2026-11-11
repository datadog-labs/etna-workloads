# Adapted injection for show unit output when there is only output diff in diagnostics

Fix: https://github.com/rust-lang/rust/commit/f46c4129e0310b4fb6a75dbe28c2a86e00c9be27

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/infer/mod.rs, fn cmp_fn_sig (moved from rustc_infer).
The fix hunk `@@ -1168,14 +1168,21 @@` replaced `if !output1.is_unit()` / `if !output2.is_unit()` with
`if !output1.is_unit() || only_output_diff` (and likewise for output2). In 1.99.1 this is `|| output_diff` with
`let output_diff = x1 != x2;`. I removed that variable and the `|| output_diff` conditions, restoring the old
behaviour: a unit return type is omitted even when it is the only difference (`fn(MyFuture)` instead of `fn(MyFuture) -> ()`).
