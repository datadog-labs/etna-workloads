import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const text = "const fn = () =>\n    async () => { };\n";
const host = {
  getScriptFileNames: () => ["a.ts"],
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "a.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "/",
  getCompilationSettings: () => ({}),
  getDefaultLibFileName: () => "lib.d.ts",
  fileExists: f => f === "a.ts",
  readFile: f => f === "a.ts" ? text : undefined,
};
const ls = ts.createLanguageService(host);
const span = { pos: 0, end: text.length - 1 };
const refs = ls.getApplicableRefactors("a.ts", span, { allowTextChangesInNewFiles: true });
const edit = ls.getEditsForRefactor("a.ts", {}, span, "Convert arrow function or function expression", "Convert to named function", {});
for (const fc of edit.edits) for (const c of fc.textChanges) console.log(JSON.stringify(c.newText));
