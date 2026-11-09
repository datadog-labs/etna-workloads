import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const files = { "/a.ts": "const a = 123;\nfunction foo() { }\n", "/bar.ts": "\n" };
const sel = { pos: 2, end: 9 };
const host = {
  getScriptFileNames: () => Object.keys(files),
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f in files ? ts.ScriptSnapshot.fromString(files[f]) : undefined,
  getCurrentDirectory: () => "/",
  getCompilationSettings: () => ({}),
  getDefaultLibFileName: () => "/lib.d.ts",
  fileExists: f => f in files,
  readFile: f => files[f],
};
const ls = ts.createLanguageService(host);
const r = ls.getEditsForRefactor("/a.ts", {}, sel, "Move to file", "Move to file", {}, { targetFile: "/bar.ts" });
for (const e of r?.edits ?? []) { console.log("== " + e.fileName); for (const c of e.textChanges) console.log(JSON.stringify(c)); }
if (!r) console.log("no edits");
