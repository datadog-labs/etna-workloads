# Re-introduced bug: `$` replacement patterns in package exports/imports subpath patterns

**Bug.** In `lib/internal/modules/esm/resolve.js`, when a `*` subpath pattern is expanded, the
subpath was substituted using `String.prototype.replace` with a plain string replacement. Such
replacements interpret `$` sequences (`$$`, `$&`, ...), so a subpath like `a/$$` was resolved as
`a/$` and the wrong file was looked up.

**Hunks (in `resolvePackageTargetString`).**
1. Bare-specifier branch (`exportTarget`): `RegExpPrototypeSymbolReplace(patternRegEx, target, () => subpath)`
   -> `StringPrototypeReplace(target, patternRegEx, subpath)`. Corresponds to fix hunk 2 (exportTarget).
2. Final `new URL(...)` for patterns: `RegExpPrototypeSymbolReplace(patternRegEx, resolved.href, () => subpath)`
   -> `StringPrototypeReplace(resolved.href, patternRegEx, subpath)`. Corresponds to fix hunk 3.
Both restore the string-replacement form, so `$` in the subpath is interpreted specially.
(The fix's win32 `resolveAsCommonJS` hunk is not reproduced; it does not affect the bug.
Other call sites that today use the function form were added later and are left untouched.)

**Failing test.** `es-module/test-esm-exports`:
`AssertionError: "Cannot find module '.../pkgexports/subpath/$.js'" includes "subpath/$$.js"`
