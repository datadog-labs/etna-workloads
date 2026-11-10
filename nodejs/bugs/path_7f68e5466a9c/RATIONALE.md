# Re-introduced bug: win32 path.resolve/normalize mishandle device roots (`\\.\` and `\\?\`)

**Bug.** `path.win32.resolve` and `path.win32.normalize` treated `\\.\X` and `\\?\X` as UNC roots
(host `.`/`?`, share `X`). `resolve('\\\\.\\PHYSICALDRIVE0')` gives `\\.\PHYSICALDRIVE0\` (extra trailing
backslash), and `normalize('\\\\.\\foo')` gives `\\.\foo\`. `toNamespacedPath('\\\\?\\foo')` gives `\\?\foo\`.

## Hunks
1. `lib/path.js`, `win32.resolve`: removed the `firstPart !== '.' && firstPart !== '?'` check and the device-root
   `else` branch (device=`\\<firstPart>`, rootEnd=4). This matches the fix's first hunk. Everything is a UNC root again.
2. `lib/path.js`, `win32.normalize`: restored the old `if (j === len) return UNC...; if (j !== last) {UNC with leftovers}`
   structure, removing the device-root branch (second hunk of the fix). Today's code had extra reserved-name (`COM1:`) handling
   inside that branch. It goes away with the branch, since it only existed for device roots.
3. `src/path.cc`, `PathResolve`: removed the same device-root check (third hunk of the fix).

## Failing tests
- parallel/test-path-normalize: actual `'\\\\.\\foo\\'`, expected `'\\\\.\\foo'`
- parallel/test-path-makelong: actual `'\\\\?\\foo\\'`, expected `'\\\\?\\foo'`
- parallel/test-path-resolve: actual `"\\\\.\\PHYSICALDRIVE0\\"`, expected `\\.\PHYSICALDRIVE0`

Confirmed over two runs. cctest PathTest.PathResolve/ToNamespacedPath still pass here. Their Windows-only
assertions are compiled out (`#ifdef _WIN32`) on Linux, so the C++ change can't be exercised.
