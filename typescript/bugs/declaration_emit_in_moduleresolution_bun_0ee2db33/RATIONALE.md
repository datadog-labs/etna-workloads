# Rationale
Hunk: `tree/src/compiler/moduleSpecifiers.ts` (tryGetModuleNameAsNodeModule) — corresponds to the fix.diff moduleSpecifiers.ts hunk (`getConditions(options, importMode)`, previously `importMode === ModuleKind.ESNext`).
Today's getConditions takes a ResolutionMode, so I re-expressed the old boolean collapse: an undefined importMode becomes CommonJS ("require") instead of falling to the default (`import` under bundler). Declaration emit under `--moduleResolution bundler` then picks the wrong exports conditions.
Result: SUMMARY: 2/6 oracle cases failing (2 fix-added).
