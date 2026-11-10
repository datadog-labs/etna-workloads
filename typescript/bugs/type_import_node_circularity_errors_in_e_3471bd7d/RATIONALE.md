# Rationale
One hunk, in `checkImportType` (tree/src/compiler/checker.ts): `checkTypeReferenceOrImport(node)` was changed back to `getTypeFromTypeNode(node)`.
This matches the last hunk of fix.diff (`getTypeFromTypeNode(node)` -> `checkTypeReferenceOrImport(node)`). Without it, import type nodes get no
deprecation suggestion and no type-argument constraint check, which is the behaviour from before the fix.
The other fix hunks were not reverted. The helper functions stay in use by type references, and reverting them would only be a refactor.

Result: `SUMMARY: 1/7 oracle cases failing (1 fix-added)`. The failing case is fourslash typeReferenceAndImportDeprecated.ts, which got one suggestion diagnostic instead of two.
