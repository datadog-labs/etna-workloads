# Rationale
Single hunk in `tree/src/compiler/moduleSpecifiers.ts` (computeModuleSpecifiers loop): module paths that are project-reference redirects are skipped (`continue`) before computing a local (paths-only) specifier.
Corresponds to the fix hunk replacing `if (!specifier && !modulePath.isRedirect)` with `if (!specifier)` + `pathsOnly: modulePath.isRedirect` + the `redirectPathsSpecifiers` bucket. Without it, `paths` mappings pointing at redirect outputs are never used, so auto-import fails/gives wrong specifiers (the original bug).
SUMMARY: 2/4 oracle cases failing (2 fix-added).
