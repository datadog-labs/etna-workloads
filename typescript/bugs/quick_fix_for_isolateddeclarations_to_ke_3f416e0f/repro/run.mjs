import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const text = require("fs").readFileSync("input.ts", "utf8");
const opts = { isolatedDeclarations: true, declaration: true, lib: ["lib.es2015.d.ts"], strict: true };
const host = {
  getScriptFileNames: () => ["input.ts"], getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "input.ts" ? ts.ScriptSnapshot.fromString(text) : (ts.sys.fileExists(f) ? ts.ScriptSnapshot.fromString(ts.sys.readFile(f)) : undefined),
  getCurrentDirectory: () => process.cwd(), getCompilationSettings: () => opts,
  getDefaultLibFileName: o => ts.getDefaultLibFilePath(o),
  fileExists: ts.sys.fileExists, readFile: ts.sys.readFile, readDirectory: ts.sys.readDirectory,
};
const ls = ts.createLanguageService(host);
const pos = text.indexOf("s =");
const diags = ls.getSemanticDiagnostics("input.ts");
for (const d of diags) {
  const fixes = ls.getCodeFixesAtPosition("input.ts", d.start, d.start + d.length, [d.code], {}, {});
  for (const f of fixes) { console.log(f.description); for (const c of f.changes) for (const t of c.textChanges) console.log(JSON.stringify(t.newText)); }
}
