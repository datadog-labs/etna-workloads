import { createRequire } from "module";
import fs from "fs";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const text = fs.readFileSync("input.ts", "utf8");
const host = {
  getScriptFileNames: () => ["input.ts"],
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "input.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => ".",
  getCompilationSettings: () => ({ strict: true }),
  getDefaultLibFileName: o => ts.getDefaultLibFilePath(o),
  fileExists: f => f === "input.ts",
  readFile: f => f === "input.ts" ? text : undefined,
};
const ls = ts.createLanguageService(host);
const diags = ls.getSemanticDiagnostics("input.ts");
const fixes = ls.getCodeFixesAtPosition("input.ts", diags[0].start, diags[0].start + diags[0].length, [diags[0].code], {}, {});
console.log("diag codes:", diags.map(d => d.code).join());
for (const f of fixes) { console.log(f.description); for (const c of f.changes) for (const t of c.textChanges) console.log(JSON.stringify(t)); }
