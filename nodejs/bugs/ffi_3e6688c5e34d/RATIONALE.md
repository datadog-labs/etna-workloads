# Re-introduced bug: ffi callable not reused per symbol

Every getFunction()/getFunctions()/`functions` read ran CreateFunction() again, emitting a new trampoline, FFIFunctionInfo (and ArrayBuffer), so `lib.functions.foo !== lib.functions.foo` and loops leaked until GC.

## Hunks
- src/node_ffi.h: removed `function_wrappers_` member (fix's header hunk).
- src/node_ffi.cc: removed the MemoryInfo tracking, the `function_wrappers_.clear()` in Close(), the cache lookup at the top of CreateFunction(), and the weak `emplace(...).SetWeak()` before `return ret` (the corresponding fix hunks). Every call builds a fresh callable again.
- lib/ffi.js: removed `wrappedFunctions` SafeWeakMap/WeakRef memoization and the SafeWeakMap/SafeWeakRef primordial imports; wrapFFIFunction restored to the pre-fix form, composing a new wrapper each call.

## Failing test
ffi/test-ffi-dynamic-library, subtest "resolving the same symbol reuses one function": strictEqual fails (`actual: [Function]`, `expected: [Function]`, different function objects). Failed in two consecutive runs.
