# Re-introduced bug (8a96d05e, "module: self resolve bug fix and esm ordering")

**Bug:** package self-resolution was mishandled. It ran only as a last resort after the node_modules lookup failed, and the subpath it computed was malformed. The old C++ ResolveSelf built `"." + specifier.substr(name.length + 1)`, which drops the slash, so `pkg-exports/valid-cjs` became `.valid-cjs`. That is not a valid export key, so a self-require from inside a package fails with ERR_PACKAGE_PATH_NOT_EXPORTED.

Hunks (the release moved the code to JS, so the fix's C++/loader hunks were re-expressed):
1. `lib/internal/modules/cjs/loader.js` `_resolveFilename`: the `trySelf` call is moved after `Module._findPath`. This corresponds to the fix's hunk that moved self-resolution before `_findPath`, undoing the ordering fix. It is the old order, where `_findPath` ended with `trySelf`.
2. `lib/internal/modules/cjs/loader.js` `trySelf`: the expansion is `'.' + request.slice(name.length + 1)`, which drops the slash. This corresponds to the fix's `ResolveSelf` rewrite, which replaced the buggy subpath computation. It restores the old missing-slash subpath bug.
3. `lib/internal/modules/package_json_reader.js` `getPackageJSONURL`: the ResolveSelf block is moved after the node_modules walk. This undoes the fix's `PackageResolve` hunk that calls `ResolveSelf` first. The self branch also returns the slash-less subpath, as in hunk 2.

**Failing test:** `es-module/test-esm-exports` fails with
`Error [ERR_PACKAGE_PATH_NOT_EXPORTED]: Package subpath '.valid-cjs' is not defined by "exports" in .../pkgexports/package.json imported from .../pkgexports/resolve-self.js`.
It failed on both runs.

**Note:** the ordering change alone did not fail the test, because the fixtures have no name collisions. The failure comes from the subpath bug.
