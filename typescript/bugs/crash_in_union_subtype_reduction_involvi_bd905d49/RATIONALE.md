# Rationale
Fix hunk: removeStringLiteralsMatchedByTemplateLiterals only treated TemplateLiteral types as templates; before the fix, string mapping types passed the filter and were handled as TemplateLiteralType, crashing.
Today's code was generalized (templates may be StringMapping, dispatched via isTypeMatchedByTemplateLiteralOrStringMapping). I changed the `some(...)` call in checker.ts to call isTypeMatchedByTemplateLiteralType(t, template as TemplateLiteralType) directly, so string mapping types are again treated as template literals -> crash in inferFromLiteralPartsToTemplateLiteral (texts undefined).

Final: SUMMARY: 6/6 oracle cases failing (0 fix-added).
