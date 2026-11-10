# Rationale
- `tree/src/compiler/emitter.ts` `emitList`: corresponds to the fix's emitter.ts hunk. The fix OR'd `ListFormat.PreferNewLine` into the format when the parent node has `EmitFlags.MultiLine`. Reverted to passing `format` unchanged, so the MultiLine flag set by organizeImports' coalesceImportsWorker (the other fix hunks, which still exist in today's code) is ignored and multiline import specifier lists get collapsed to one line.
- The fix's types.ts hunk (adding EmitFlags.MultiLine) and organizeImports hunks were left intact: the enum member is still used elsewhere, and removing the emitter consumption alone restores the bug.

Final: SUMMARY: 3/35 oracle cases failing (1 fix-added).
