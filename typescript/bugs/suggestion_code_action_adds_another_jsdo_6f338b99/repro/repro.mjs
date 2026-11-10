import { createRequire } from "module";
import fs from "fs";
const ts = createRequire(import.meta.url)(process.env.TYPESCRIPT);
const text = fs.readFileSync("input.ts", "utf8");
const opts = { allowJs: true, checkJs: true };
const host = {
  getScriptFileNames: () => ["input.ts"], getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "input.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "/", getCompilationSettings: () => ({}),
  getDefaultLibFileName: () => "lib.d.ts", fileExists: f => f === "input.ts",
  readFile: f => f === "input.ts" ? text : undefined,
};
const ls = ts.createLanguageService(host);
const diags = ls.getSemanticDiagnostics("input.ts").concat(ls.getSyntacticDiagnostics("input.ts"), ls.getSuggestionDiagnostics("input.ts"));
for (const d of diags) {
  const fixes = ls.getCodeFixesAtPosition("input.ts", d.start, d.start + d.length, [d.code], {}, {});
  for (const f of fixes) {
    if (!/^Delete unused/.test(f.description)) continue;
    console.log(f.description);
    let out = text;
    for (const c of f.changes[0].textChanges.slice().sort((a,b)=>b.span.start-a.span.start))
      out = out.slice(0,c.span.start)+c.newText+out.slice(c.span.start+c.span.length);
    console.log(out);
  }
}
