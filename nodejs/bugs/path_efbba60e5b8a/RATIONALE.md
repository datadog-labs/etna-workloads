# Re-introduced bug (efbba60e, "path: fix bugs and inconsistencies")

The release already lacks the fix's trailing-slash (`slashCheck`) parts, so only the
Windows device-root part remains to re-introduce. Bug: `path.win32.resolve()` treats
`\\.\X` and `\\?\X` as UNC roots (`\\.\X` host/share), so `\\.\PHYSICALDRIVE0` resolves to
`\\.\PHYSICALDRIVE0\` instead of staying unchanged; `toNamespacedPath('\\?\foo')` gets a trailing `\`.

## Hunks
- `lib/path.js` win32.resolve: removed the `firstPart !== '.' && firstPart !== '?'` branch and
  device-root `else` (fix hunk "@@ -268,10 +273,16"), always building a UNC root as before the fix.
- `src/path.cc` Windows `PathResolve`: same removal (fix hunk "@@ -170,9 +175,16"), for consistency.
- win32.normalize's device-root branch was left alone (it has since been merged with reserved-name
  handling; reverting it would break unrelated behaviour).

## Failing tests
- parallel/test-path-resolve: `actual="\\\\.\\PHYSICALDRIVE0\\"` (expected without trailing `\`), also for `\\?\`.
- parallel/test-path-makelong: `actual: '\\\\?\\foo\\', expected: '\\\\?\\foo'`.
- cctest PathTest.* still pass on Linux (the changed code is `_WIN32` only).
Failures stable over two runs.
