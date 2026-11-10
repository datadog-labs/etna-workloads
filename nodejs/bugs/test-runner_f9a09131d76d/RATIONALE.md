# Rationale

**Bug:** `t.assert` exposed every function exported by `node:assert` (e.g. `AssertionError`, `CallTracker`, `Assert`, `strict`) instead of only an allowlist of assertion methods.

**Change** (`lib/internal/test_runner/assert.js`, `getAssertionMap`): the fix replaced the `ObjectEntries(assert)` loop (copy every function export) with a `methodsToCopy` allowlist, and the code has since moved from `test.js` into this file. I reversed that: I removed the `methodsToCopy` array and the allowlist loop, restored the loop over `ObjectEntries(assert)` that copies every function-valued export, and added `ObjectEntries` to the primordials import. This corresponds to the fix's `lazyAssertObject` hunk and the removed/added `ObjectEntries` import hunk. The `test.js` `map.forEach` hunk is only a refactor and needs no reversal.

**Failing test:** `parallel/test-runner-assert` gives "not ok" on two runs. `Object.keys(t.assert)` now contains extra keys such as `AssertionError`, so the `deepStrictEqual` check against the allowlist fails.
