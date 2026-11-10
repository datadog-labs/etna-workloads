# Rationale
Hunk (tree/src/compiler/checker.ts, resolveHelpersModule): corresponds to fix.diff hunk changing `resolveHelpersModule`.
The fix resolves tslib from the synthesized `import "tslib"` specifier (file.imports[0]) so the module resolution mode matches
that import. Reverted to resolving from the SourceFile node, so resolution mode comes from the file (wrong under bundler/verbatimModuleSyntax).
The other fix hunks (JSX specifier refactor, program.ts) are either pure refactors or already differ/identical in today's code, so were not changed.

SUMMARY: 2/24 oracle cases failing (2 fix-added).
