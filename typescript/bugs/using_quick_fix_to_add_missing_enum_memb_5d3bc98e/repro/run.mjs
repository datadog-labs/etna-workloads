import fs from "fs";
import { createRequire } from "module";
const ts = createRequire(import.meta.url)(process.env.TYPESCRIPT);
const text = fs.readFileSync("input.ts", "utf8");
const host = {
  getScriptFileNames: () => ["input.ts"],
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "input.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "/",
  getCompilationSettings: () => ({}),
  getDefaultLibFileName: () => "lib.d.ts",
  fileExists: f => f === "input.ts", readFile: f => f === "input.ts" ? text : undefined,
};
const ls = ts.createLanguageService(host);
const fixes = ls.getCodeFixesAtPosition("input.ts", text.indexOf("E.b") + 2, text.indexOf("E.b") + 3, [2339], { newLineCharacter: "\n" }, {});
for (const f of fixes) {
  if (!f.description.includes("enum member")) continue;
  console.log(f.description);
  let out = text;
  for (const c of f.changes[0].textChanges.slice().sort((a, b) => b.span.start - a.span.start))
    out = out.slice(0, c.span.start) + c.newText + out.slice(c.span.start + c.span.length);
  console.log(out);
}
