const ts = require(process.env.TYPESCRIPT);
const fs = require("fs");
const text = fs.readFileSync("input.ts", "utf8");
const host = {
  getCompilationSettings: () => ({}),
  getScriptFileNames: () => ["input.ts"],
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "input.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "",
  getDefaultLibFileName: () => "lib.d.ts",
  fileExists: f => f === "input.ts",
  readFile: f => f === "input.ts" ? text : undefined,
};
const ls = ts.createLanguageService(host);
const d0 = ls.getSemanticDiagnostics("input.ts")[0]; const start = d0.start, end = d0.start + d0.length;
const diags = ls.getSemanticDiagnostics("input.ts");
const codes = [...new Set(diags.map(d => d.code))];
const fixes = ls.getCodeFixesAtPosition("input.ts", start, end, codes, {}, {});
console.log(fixes.map(f=>f.description));for (const f of fixes) if (/missing prop/i.test(f.description)) for (const c of f.changes) for (const t of c.textChanges) console.log(t.newText);
