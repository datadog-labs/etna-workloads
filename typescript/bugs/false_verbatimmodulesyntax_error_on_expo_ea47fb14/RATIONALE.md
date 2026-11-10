# Rationale
One hunk, tree/src/compiler/checker.ts (checkModuleDeclaration): fix.diff added a module-format condition
(CommonJS) to the verbatimModuleSyntax top-level `export` check on namespaces. In today's code that is
`host.getEmitModuleFormatOfFile(node.parent) === ModuleKind.CommonJS`; I removed it, so `export namespace`
in ESM files again gets the false CommonJS-only error.

Final: SUMMARY: 2/12 oracle cases failing (0 fix-added).
