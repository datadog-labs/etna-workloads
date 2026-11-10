# Re-introduced bug: path.posix.relative() trailing slash when target is root

**Bug:** `path.posix.relative('/page1/page2/foo', '/')` returns `'../../../'` (trailing slash) instead of `'../../..'`. When `to` is the root, no common separator was recorded, so `lastCommonSep` stayed -1 and the tail slice of `to` (`'/'`) was appended.

**Hunk (lib/path.js, posix.relative):** corresponds to the single hunk of the fix. The fix split `else if (fromLen > length && ...)` into `else if (fromLen > length) { if (slash) {...} else if (i === 0) { lastCommonSep = 0; } }`. I reverted it to the original form `else if (fromLen > length && from.charCodeAt(fromStart + i) === CHAR_FORWARD_SLASH)`, removing the `i === 0` root case (re-expressed with the current `StringPrototypeCharCodeAt` primordial). The win32 branch is untouched, as in the fix.

**Failing test:** parallel/test-path-relative:
`path.posix.relative("/page1/page2/foo","/") expect="../../.." actual="../../../"`
Failed on two consecutive runs.
