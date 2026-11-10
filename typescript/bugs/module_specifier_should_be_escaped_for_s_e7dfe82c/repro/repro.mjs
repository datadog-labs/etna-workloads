import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const files = { "/$foo.ts": "export function foo() {}", "/bar.ts": "import f" };
const host = {
  getScriptFileNames: () => Object.keys(files),
  getScriptVersion: () => "1",
  getScriptSnapshot: f => files[f] !== undefined ? ts.ScriptSnapshot.fromString(files[f]) : undefined,
  getCurrentDirectory: () => "/",
  getCompilationSettings: () => ({ module: ts.ModuleKind.ESNext }),
  getDefaultLibFileName: () => "/lib.d.ts",
  fileExists: f => files[f] !== undefined,
  readFile: f => files[f],
};
const ls = ts.createLanguageService(host);
const r = ls.getCompletionsAtPosition("/bar.ts", 8, {
  includeCompletionsForImportStatements: true,
  includeCompletionsForModuleExports: true,
  includeCompletionsWithSnippetText: true,
  includeCompletionsWithInsertText: true,
});
for (const e of r.entries.filter(e => e.name === "foo")) console.log(e.name, e.insertText);
