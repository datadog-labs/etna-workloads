# Rationale
Fix hunks in `createScanner` (regex flag scanning in `reScanSlash` and `scanPatternModifiers`) changed `charCodeChecked(pos)` to `codePointChecked(pos)` so non-BMP flag chars are read as a whole code point.
Re-injected: both loops in `src/compiler/scanner.ts` go back to `charCodeChecked(pos)`. A non-BMP char then reads as a lone surrogate, `isIdentifierPart` is false, and the loop stops mid-character (the original bug). The other fix hunks (renames, the size parameter) are refactors that don't change behaviour without this, so I left them.
Final: SUMMARY: 3/6 oracle cases failing (3 fix-added).
