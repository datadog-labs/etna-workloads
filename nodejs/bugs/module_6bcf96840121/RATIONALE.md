# Re-introduced bug: memory leak when require() throws

When a module throws while loading, `Module._load` removes it from `Module._cache` and the relative-resolve cache. Before the fix, it stayed in `parent.children`. The failed module (and everything it references) could never be garbage collected, and `parent.children` listed modules that failed to load.

## Change
`lib/internal/modules/cjs/loader.js`, in the `finally` block of `Module._load` (`if (threw)` branch): removed the block that looked up `module` in `parent.children` and spliced it out. This corresponds to the single implementation hunk of the fix. The code is now written with `parent?.children` and primordials, but the logic is the same. Deleting it restores the pre-fix behaviour.

## Failing test
`sequential/test-module-loading` reports `not ok`, and it failed on both runs. Its expected-children list no longer includes the `throws_error.js` and `.node` fixtures, which the fix removed from it. With the bug, those failed modules are still present in `children`, so the children assertion fails. I did not capture the exact assertion message.
