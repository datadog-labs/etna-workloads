# Rationale
- `src/compiler/watchUtilities.ts`: removed `getScriptKind` input field/param, the `isSupportedScriptKind()` helper, and the extra condition in `isIgnoredFileFromWildCardWatching` (plus now-unused imports). Matches the fix's watchUtilities hunks. Files whose extension is only supported via a plugin's getScriptKind are again ignored as "non supported extension".
- `src/server/editorServices.ts`: stopped passing `getScriptKind` to `isIgnoredFileFromWildCardWatching` (matches editorServices hunk).
- `src/server/project.ts` hunk not reverted: today's code already differs and reverting is unnecessary for the bug.

Final: SUMMARY: 1/8 oracle cases failing (0 fix-added) — failing: "new files with non ts extensions and wildcard matching" (the test added by the fix; it is just not tagged fix-added).
