# Re-introduced bug: enableCompileCache() with invalid argument

**Bug:** `module.enableCompileCache(invalid)` (e.g. `0`, `null`, `false`, a function, `[]`) passed a non-string directory to the native binding, which used `CHECK(args[0]->IsString())` and aborted the whole process instead of throwing a catchable `ERR_INVALID_ARG_TYPE`.

**Change (src/node_modules.cc, `EnableCompileCache`):** Single hunk, corresponding to the single implementation hunk of the fix. The `if (!args[0]->IsString()) { THROW_ERR_INVALID_ARG_TYPE(...); return; }` block is replaced by the original `CHECK(args[0]->IsString());` at the top of the function. The surrounding code differs from the original (the release also parses portable/readOnly options), so the hunk is re-expressed rather than reverse-applied.

**Failing test:** `parallel/test-compile-cache-api-error` -> `not ok`, the process aborts with `Assertion failed: args[0]->IsString()` (stable across 2 runs).
