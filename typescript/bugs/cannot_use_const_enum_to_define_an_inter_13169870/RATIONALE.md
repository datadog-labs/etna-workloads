Hunk: tree/src/compiler/checker.ts (checkConstEnumAccess, isolatedModules ambient const enum error).
Corresponds to the single fix.diff hunk: the fix added `&& !isValidTypeOnlyAliasUseSite(node)` to the ambient-const-enum error condition. Removed it again in today's code (line ~41802, keeping the redirect check), so type-only use sites (e.g. const enum as interface key in a type position) wrongly report "Cannot access ambient const enums".
Final: SUMMARY: 1/6 oracle cases failing (1 fix-added).
