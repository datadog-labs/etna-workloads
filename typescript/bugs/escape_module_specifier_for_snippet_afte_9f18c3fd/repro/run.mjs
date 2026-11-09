import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const files = { "/$foo.ts": "export function foo() {}\n", "/bar.ts": "import f" };
const opts = { target: ts.ScriptTarget.ESNext, module: ts.ModuleKind.ESNext, moduleResolution: ts.ModuleResolutionKind.Bundler };
const host = {
  getScriptFileNames: () => Object.keys(files),
  getScriptVersion: () => "1",
  getScriptSnapshot: f => files[f] !== undefined ? ts.ScriptSnapshot.fromString(files[f]) : undefined,
  getCurrentDirectory: () => "/",
  getCompilationSettings: () => opts,
  getDefaultLibFileName: () => "/lib.d.ts",
  fileExists: f => files[f] !== undefined,
  readFile: f => files[f],
  useCaseSensitiveFileNames: () => true,
};
const ls = ts.createLanguageService(host);
const r = ls.getCompletionsAtPosition("/bar.ts", 8, {
  includeCompletionsForImportStatements: true, includeCompletionsForModuleExports: true,
  includeCompletionsWithSnippetText: true, includeCompletionsWithInsertText: true });
for (const e of r.entries.filter(e => e.name === "foo")) console.log(e.insertText);
