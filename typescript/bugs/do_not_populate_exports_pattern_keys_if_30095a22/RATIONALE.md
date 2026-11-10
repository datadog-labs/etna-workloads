# Rationale
Hunk 1 (moduleNameResolver.ts, loadModuleFromImportsOrExports): expandingKeys filter uses `k.includes("*")` instead of `hasOneAsterisk(k)`, so keys with multiple `*` are populated as patterns (fix.diff hunk 1).
Hunk 2: removed the now-unused `hasOneAsterisk` helper (fix.diff hunk 2).

Final: SUMMARY: 3/18 oracle cases failing (3 fix-added).
