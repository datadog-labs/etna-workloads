# Re-introduced bug: ESM JSON cache collision on file: URLs with query/hash

**Bug.** The ESM `json` translator used the CJS module cache (`CJSModule._cache`) for every `file:` URL, keyed by the file path only. `foo.json`, `foo.json?a=2`, `foo.json#a=2` therefore collapsed into one cached module, and a loader-customized URL (e.g. a `?randomSeed=` query added by `resolve`) returned stale/identical content.

**Change** (lib/internal/modules/esm/translators.js, `jsonStrategy`):
- Removed the `shouldCheckAndPopulateCJSModuleCache` constant (fix hunk 2) and went back to testing `pathname` in the three places (fix hunks 3-5: cache lookup, re-check after `stringify`, cache population). Any `file:` URL now touches the CJS cache regardless of `?`/`#`.
- Removed the now-unused `StringPrototypeIncludes` import (fix hunk 1), to keep lint clean.

**Failing tests** (stable across two runs): `es-module/test-esm-json` (different-URL imports return the same cached object, so `notDeepStrictEqual` fails) and `es-module/test-esm-virtual-json` (two imports with distinct random query URLs return deep-equal modules).
