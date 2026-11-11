# Adapted injection for When calling a method on Fn* traits explicitly, argument diagnostics should point at the called method (eg Fn::call_once), not the underlying callee.

Fix: https://github.com/rust-lang/rust/commit/57de75050a9e2aeddfe6a9f4c47776809167b0f7

# Rationale
File: compiler/rustc_hir_typeck/src/fn_ctxt/checks.rs, fn label_fn_like (the Fn/FnMut/FnOnce callee-pointing block, ~line 1659).
Removed `tuple_arguments == TupleAllCallArgs &&` from the `if` condition. This re-expresses the fix hunk
`@@ -2219,21 +2224,27 @@ ... fn label_fn_like` which added `&& tuple_arguments == TupleArguments` ("set only when this is an implicit call ... rather than explicit my_closure.call(...)").
Without it, explicit `Fn::call_once(...)` calls also get diagnostics pointing at the underlying callee rather than the called method.
