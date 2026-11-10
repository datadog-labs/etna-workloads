import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const text = "const foo = {\n    async a: 1\n}\n";
const host = {
  getScriptFileNames: () => ["a.ts"],
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "a.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "/",
  getCompilationSettings: () => ({}),
  getDefaultLibFileName: () => "lib.d.ts",
  fileExists: f => f === "a.ts", readFile: () => undefined,
};
const ls = ts.createLanguageService(host);
const start = text.indexOf("async"), end = text.indexOf("1") + 1;
const refs = ls.getApplicableRefactors("a.ts", { pos: start, end }, { allowTextChangesInNewFiles: true });
const name = "Generate 'get' and 'set' accessors";
const edits = ls.getEditsForRefactor("a.ts", { indentSize: 4, tabSize: 4, newLineCharacter: "\n", convertTabsToSpaces: true }, { pos: start, end }, name, name, {});
for (const e of edits?.edits ?? []) for (const c of e.textChanges) console.log(JSON.stringify(c.newText));
