# Rationale
Changes in tree/src/compiler/checker.ts only:
1. `isExpandoFunction` check (fix hunk at ~47200): restored `p.valueDeclaration && isPropertyAccessExpression(p.valueDeclaration)` instead of `isExpandoPropertyDeclaration(...)`, so element-access expandos (`decl["B"] = ...`) are not recognised as expando members. Import of isExpandoPropertyDeclaration removed (unused; fix's import hunk).
2. `isStringNamed` (fix hunk ~8174): removed the `isElementAccessExpression(name)` branch, so element-access-named expando properties are not treated as string-named.
declarations.ts/utilities.ts were left alone (helper still used there; today's code differs).
Symptom: declaration emit omits `export declare namespace decl { var B: string }` etc.
Final: SUMMARY: 2/6 oracle cases failing (2 fix-added).
