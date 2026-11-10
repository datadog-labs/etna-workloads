# Rationale
Single hunk in `tree/src/compiler/moduleNameResolver.ts`, `loadModuleFromSpecificNodeModulesDirectory`.
Corresponds to the fix.diff hunk that changed the nested-package.json guard from
`!(features & Exports)` to `rest !== "" && packageInfo && (!Exports || root package.json has no "exports")`.
I restored the old guard `!(state.features & Exports) && packageInfo`, so in exports-respecting modes
(node16/nodenext/bundler) a nested package.json is no longer used when the root has no `exports`,
and lookups with nested package.json in non-exports modes are unaffected. The other fix hunks
(moving parsePackageName up, reusing rootPackageInfo) are refactors that remain harmlessly.
Final: SUMMARY: 6/18 oracle cases failing (6 fix-added).
