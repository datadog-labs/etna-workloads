# Rationale
Only file changed: tree/src/services/codefixes/fixAddMissingParam.ts

- `updateParameters`: `getParameterType(importAdder, declaration.type, scriptTarget)` -> `declaration.type`. Corresponds to the fix hunk that added getParameterType at that call site. The copied parameter type is again used verbatim, so a type from another file is emitted as `import("./a").A` rather than adding a proper import.
- Removed the `getParameterType` helper and the `importSymbols` / `tryGetAutoImportableReferenceFromTypeNode` imports (fix hunks adding them), required so the build's unused-symbol checks pass.
- The importAdder plumbing in doChange is left in place (it is harmless without the helper).

Final: SUMMARY: 1/1 oracle cases failing (1 fix-added).
