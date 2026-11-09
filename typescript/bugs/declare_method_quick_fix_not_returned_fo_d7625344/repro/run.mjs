import { createRequire } from "module";
import fs from "fs";
const ts = createRequire(import.meta.url)(process.env.TYPESCRIPT);
const text = fs.readFileSync("input.ts", "utf8");
const opts = { target: ts.ScriptTarget.ES2022 };
const host = {
  getScriptFileNames: () => ["input.ts"], getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "input.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "", getCompilationSettings: () => opts,
  getDefaultLibFileName: () => "lib.d.ts", fileExists: f => f === "input.ts",
  readFile: f => f === "input.ts" ? text : undefined,
};
const ls = ts.createLanguageService(host);
const pos = text.indexOf("#foo");
const fixes = ls.getCodeFixesAtPosition("input.ts", pos, pos + 4, [2339, 18013], {}, {});
console.log(fixes.length);
for (const f of fixes) { console.log(f.description); for (const c of f.changes) for (const t of c.textChanges) console.log(JSON.stringify(t.newText)); }
