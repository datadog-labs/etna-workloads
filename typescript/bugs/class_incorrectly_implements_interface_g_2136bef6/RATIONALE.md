# Rationale
Only `tree/src/services/codefixes/helpers.ts` changed (the fix's helpers.ts hunks):
- Call site in `addNewNodeForMemberSymbol`: `createDeclarationName(symbol, declaration)` -> the original `getSynthesizedDeepClone(getNameOfDeclaration(declaration), false) as PropertyName` (fix hunk @@ -193). Mapped-type members then take the name from the template-literal declaration (`[`${K}Click`]`-style) instead of the resolved nameType.
- Removed the `createDeclarationName` helper (fix hunk @@ -344) and imports it alone used (CheckFlags, getCheckFlags, getPropertyNameFromType, isTypeUsableAsPropertyName, TransientSymbol, unescapeLeadingUnderscores) so the build's unused-import check passes.
- The checker/utilities hunks (moving the helpers to utilities.ts) are pure refactors and are not reverted; today's utilities still export them.

Final: SUMMARY: 1/2 oracle cases failing (1 fix-added) — codeFixClassImplementInterfaceMappedType2 fails with `Click:` names instead of `addClickListener`/`removeClickListener`.
