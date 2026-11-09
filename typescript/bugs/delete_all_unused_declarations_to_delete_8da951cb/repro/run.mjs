import fs from "fs";
import { createRequire } from "module";
const ts = createRequire(import.meta.url)(process.env.TYPESCRIPT);
const f = "input.ts";
const text = fs.readFileSync(f, "utf8");
const opts = { noUnusedLocals: true, target: ts.ScriptTarget.ES2020 };
const host = {
  getScriptFileNames: () => [f], getScriptVersion: () => "1",
  getScriptSnapshot: n => n === f ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "/", getCompilationSettings: () => opts,
  getDefaultLibFileName: () => "lib.d.ts", fileExists: n => n === f, readFile: n => n === f ? text : undefined,
};
const ls = ts.createLanguageService(host);
const r = ls.getCombinedCodeFix({ type: "file", fileName: f }, "unusedIdentifier_delete", {}, {});
let out = text;
for (const c of r.changes[0].textChanges.sort((a, b) => b.span.start - a.span.start))
  out = out.slice(0, c.span.start) + c.newText + out.slice(c.span.start + c.span.length);
console.log(JSON.stringify(out));
