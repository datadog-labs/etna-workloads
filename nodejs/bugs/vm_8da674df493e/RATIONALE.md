# Rationale

**Bug:** `vm.compileFunction`'s `parsingContext` option was ignored: the function was compiled in the current context rather than the given parsing context, so globals of the parsing context (e.g. `varInContext`) were not visible.

**Hunk:** `src/node_contextify.cc`, in `ContextifyFunction::CompileFunction`, the call to `CompileFunctionAndCacheResult` now passes `context` instead of `parsing_context`. This corresponds to the fix's one hunk (`parsing_context` -> `context` in the compile call). Today the call is wrapped in a helper that forwards that argument to `ScriptCompiler::CompileFunction`, so the swap is made at the call site.

**Failing test:** `parallel/test-vm-basic` fails (run twice) with `ReferenceError: varInContext is not defined at <anonymous>:1:1`.
