const ts = require(process.env.TYPESCRIPT);
const fs = require("fs");
const text = fs.readFileSync("input.ts", "utf8");
const host = {
  getScriptFileNames: () => ["input.ts"],
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "input.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "/",
  getCompilationSettings: () => ({ allowJs: true, checkJs: true }),
  getDefaultLibFileName: () => "lib.d.ts",
  fileExists: f => f === "input.ts",
  readFile: f => f === "input.ts" ? text : undefined,
};
const ls = ts.createLanguageService(host);
const diags = ls.getSuggestionDiagnostics("input.ts").filter(d => d.code === 80009);
console.log(diags.length);
for (const d of diags) {
  const fixes = ls.getCodeFixesAtPosition("input.ts", d.start, d.start + d.length, [80009], {}, {});
  for (const f of fixes) for (const c of f.changes) for (const t of c.textChanges) console.log(f.description, JSON.stringify(t.newText), t.span.start, t.span.length);
}
