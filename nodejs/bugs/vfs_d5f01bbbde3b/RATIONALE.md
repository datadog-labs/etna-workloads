# Re-introduced bug: vfs rename into descendant directory

**Bug.** `MemoryProvider.renameSync` allowed renaming a directory into its own descendant (e.g. `/a` -> `/a/b/c`). The subtree was unlinked from its old parent and attached under itself, so it was detached from the root. The fix rejects this with EINVAL before mutating the tree.

**Hunks.**
1. `lib/internal/vfs/providers/memory.js`, `renameSync`: removed the `if (entry.isDirectory()) { ... throw createEINVAL('rename', oldPath) }` block. This corresponds to the fix's added `StringPrototypeStartsWith(normalizedNew, ...)` EINVAL check. The release had since rewritten that check to compare symlink-resolved paths, so I removed its current form. Without it, the rename proceeds and mutates the tree.
2. Same file: removed the `StringPrototypeStartsWith` primordial import. This corresponds to the fix's import hunk, and nothing else uses it.

**Failing test.** `parallel/test-vfs-rename` fails (`not ok`, stable across 2 runs). `assert.throws(() => myVfs.renameSync('/a', '/a/b/c'), { code: 'EINVAL' })` fails because no exception is thrown.
