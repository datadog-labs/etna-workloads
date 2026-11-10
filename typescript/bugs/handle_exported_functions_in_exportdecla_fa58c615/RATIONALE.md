One hunk, tree/src/compiler/transformers/utilities.ts (collectExternalModuleInfo, ExportSpecifier loop): removed the
`if (decl.kind === FunctionDeclaration) { addExportedFunctionDeclaration(...); continue; }` branch. This corresponds to
the fix.diff hunk "@@ -317,6 +302,11" that added it. Without it, `function f(){}; export { f }` is treated like a plain
binding, so exported functions from export declarations are not hoisted (exports.f = f is not emitted at the top) in CJS/AMD/UMD.
The other fix hunks are refactors (Set vs array) which are not bug behaviour.
Final: SUMMARY: 29/174 oracle cases failing (0 fix-added).
