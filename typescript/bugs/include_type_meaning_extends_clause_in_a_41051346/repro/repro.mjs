import { createRequire } from "module";
const ts = createRequire(import.meta.url)(process.env.TYPESCRIPT);
const files = {
  "/d.ts": "export declare class Foo { }\n",
  "/g.d.ts": "interface Foo { }\n",
  "/b.ts": "class C extends Foo {}\n",
};
const opts = { module: ts.ModuleKind.CommonJS, strict: true };
const host = {
  getScriptFileNames: () => Object.keys(files),
  getScriptVersion: () => "1",
  getScriptSnapshot: f => files[f] === undefined ? undefined : ts.ScriptSnapshot.fromString(files[f]),
  getCurrentDirectory: () => "/",
  getCompilationSettings: () => opts,
  getDefaultLibFileName: () => "/lib.d.ts",
  fileExists: f => f in files,
  readFile: f => files[f],
};
const ls = ts.createLanguageService(host);
const diags = ls.getSemanticDiagnostics("/b.ts");
console.log(diags.map(d => d.code + " " + ts.flattenDiagnosticMessageText(d.messageText, "\n")));
const fixes = ls.getCodeFixesAtPosition("/b.ts", 16, 19, [2689, 2304, 2552], {}, { includeCompletionsForModuleExports: true });
console.log(JSON.stringify(fixes.map(f => [f.fixName, f.description])));
