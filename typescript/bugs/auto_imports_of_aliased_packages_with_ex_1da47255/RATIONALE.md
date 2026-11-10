# Rationale
Single hunk in tree/src/compiler/moduleSpecifiers.ts (tryDirectoryWithPackageJson) matching the single hunk of fix.diff:
removed the directory-name-derived `packageName` and went back to using `packageJsonContent.name` (required to be a string)
for tryGetModuleNameFromExports. For aliased/symlinked packages whose package.json name differs from the node_modules
directory name, the exports-based specifier is wrong or skipped.

SUMMARY: 3/4 oracle cases failing (2 fix-added).
