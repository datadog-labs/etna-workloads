# Re-introduced bug: util.inspect fails on undetectable objects (document.all)

`typeof` of an undetectable object (IsHTMLDDA, e.g. `document.all`) is `'undefined'`, so
`formatValue` treated it as a primitive and `getConstructorName` skipped it because it is falsy.
`inspect(undetectable)` therefore printed `undefined` instead of `{}`.

## Changes (lib/internal/util/inspect.js)
1. Removed the `isUndetectableObject` helper (fix hunk 1; no longer used).
2. `getConstructorName`: loop condition back to `while (obj)` (fix hunk 2) - the falsy undetectable object never enters the loop.
3. `formatValue`: primitive check back to `typeof value !== 'object' && typeof value !== 'function'` (fix hunk 3) - undetectable objects go to `formatPrimitive` and print `undefined`.

## Failing test
`parallel/test-util-inspect` fails (stable over repeated runs): the `%GetUndetectable()` assertion,
`inspect(undetectable) === '{}'`, gets `'undefined'`.
