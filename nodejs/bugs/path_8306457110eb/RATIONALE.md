# CVE-2025-23084: win32 path.normalize() traversal

**Bug:** On Windows, normalizing a relative path such as `test/../C:/Windows` collapses to `C:\Windows`, which Windows treats as absolute (drive-rooted). The result escapes the intended base directory.

**Change (lib/path.js, `win32.normalize`):** Removed the block, which sat after the trailing-separator handling, that checked `!isAbsolute && device === undefined && path.includes(':')`. That block returned `.\${tail}` when the tail began with a drive-letter+colon, or when a colon in the original path was followed by a separator or the end of the string. This corresponds to the single implementation hunk of the fix (added code, removed here). The `StringPrototypeIncludes` import is left in place because it is harmless. The newer `isWindowsReservedName` logic that came after the fix is untouched.

**Failing tests:** `parallel/test-path-normalize` and `parallel/test-path-join`. The CVE-2024-36139 assertions fail, e.g. `normalize('test/../C:/Windows')` returns `C:\Windows` instead of `.\C:\Windows`.
