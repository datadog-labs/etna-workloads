All in tree/src/compiler/program.ts (CRLF preserved), reverting the three fix.diff hunks that removed toFileNameLowerCase:
1. getTypeReferenceResolutionName: lowercases entry.fileName again (fix hunk 1).
2. getResolvedTypeReferenceDirectiveFromTypeReferenceDirective: lowercases typeRef.fileName (fix hunk 2; today's code is multi-line).
3. resolution caching in the type reference loop: `const fileName = toFileNameLowerCase(ref.fileName)` (fix hunk 3).
Effect: type reference directive names with uppercase letters get lowercased, so resolution fails/mis-resolves.
Final: SUMMARY: 5/11 oracle cases failing (1 fix-added).
