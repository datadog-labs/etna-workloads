import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const text = `interface I {
    constructor: number;
}
class C implements I {}
`;
const host = {
  getCompilationSettings: () => ({}),
  getScriptFileNames: () => ["a.ts"],
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "a.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "",
  getDefaultLibFileName: () => "lib.d.ts",
  fileExists: f => f === "a.ts",
  readFile: f => f === "a.ts" ? text : undefined,
};
const ls = ts.createLanguageService(host);
const pos = text.indexOf("class C") + 6;
const fixes = ls.getCodeFixesAtPosition("a.ts", pos, pos + 1, [2420], { newLineCharacter: "\n" }, {});
for (const f of fixes) {
  console.log(f.description);
  for (const c of f.changes) for (const t of c.textChanges) console.log(JSON.stringify(t.newText));
}
