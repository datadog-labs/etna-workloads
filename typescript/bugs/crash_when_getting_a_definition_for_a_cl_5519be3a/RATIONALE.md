# Rationale
Only the `src/services/goToDefinition.ts` hunk of fix.diff was re-expressed (the one that fixes the crash).
In `getDefinitionFromOverriddenMember` I restored the pre-fix code: it always calls
`getTextOfPropertyName(classElement.name)`, with no computed-name branch (`isComputedPropertyName` / `isKnownSymbol`).
For computed names such as `[key]` that hits a Debug Failure, which is the original crash. I also removed the two imports that became unused.
Other fix.diff hunks (checker error message arg, codefix refactors) are not part of the crash and were not reverted.

Final: SUMMARY: 10/24 oracle cases failing (10 fix-added).
