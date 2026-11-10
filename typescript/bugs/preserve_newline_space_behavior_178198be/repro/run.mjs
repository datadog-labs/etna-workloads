import fs from "fs";
import { createRequire } from "module";
const ts = createRequire(import.meta.url)(process.env.TYPESCRIPT);
const text = fs.readFileSync("input.ts", "utf8");
const host = {
  getScriptFileNames: () => ["input.ts"], getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "input.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "", getCompilationSettings: () => ({}),
  getDefaultLibFileName: () => "lib.d.ts", fileExists: f => f === "input.ts", readFile: f => f === "input.ts" ? text : undefined,
};
const ls = ts.createLanguageService(host);
const start = text.indexOf("if"), end = text.lastIndexOf("console.log(3);") + "console.log(3);".length;
const refs = ls.getApplicableRefactors("input.ts", { pos: start, end }, { allowTextChangesInNewFiles: true });
for (const r of refs) for (const a of r.actions) if (/function_scope_0/.test(a.name)) {
  const e = ls.getEditsForRefactor("input.ts", {}, { pos: start, end }, r.name, a.name, {});
  for (const c of e.edits) for (const t of c.textChanges) console.log(t.newText);
}
