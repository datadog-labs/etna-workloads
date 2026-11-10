# Bug
MemoryProvider recursive readdir followed symlinks to directories with no cycle detection, so a symlink pointing at an ancestor (e.g. /dir/loop -> /dir) is descended forever.

# Change (lib/internal/vfs/providers/memory.js, #readdirRecursive)
Single hunk: the condition `resolvedChild.isDirectory() && !active.has(resolvedChild)` became `resolvedChild.isDirectory()`. This corresponds to the fix's hunk that added the `active` SafeSet / `if (active.has(entry)) return;` guard; the release implements the guard in the explicit-stack loop, so removing that check restores the pre-fix unbounded traversal. (The active-set bookkeeping stays but is unused.)

# Failing test
parallel/test-vfs-readdir-symlink-recursive: "not ok", severity crashed, exitcode -6, `FATAL ERROR: Ineffective mark-compacts near heap limit Allocation failed - JavaScript heap out of memory` (the cycle test never terminates and exhausts the heap).
