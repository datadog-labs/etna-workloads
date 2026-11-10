# Adapted injection for Don't suggest adding `in` to a `for` loop that already has one

Fix: https://github.com/rust-lang/rust/commit/0ab14caeaf5f7ef987e047ccbbbdda59876f86de

# Rationale
File compiler/rustc_parse/src/parser/expr.rs, fn `error_missing_in_for_loop`: in the fallback branch (not `of`, not `=`),
always use `Some(MissingInInForLoopSub::AddIn(span))` instead of `(!self.for_loop_head_has_in()).then_some(AddIn(span))`.
Also removed the helper `for_loop_head_has_in`. Re-expresses the fix hunk `@@ -3086,18 +3086,41 @@ ... fn error_missing_in_for_loop`
(`let sub = (!self.for_loop_head_has_in()).then_some(...)` and the added helper fn).
The `Option` sub field in errors (already present in 1.99.1 diagnostics module) is left as is.
