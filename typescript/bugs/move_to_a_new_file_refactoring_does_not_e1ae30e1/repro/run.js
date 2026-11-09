const ts = require(process.env.TYPESCRIPT);
const fs = require("fs");
const files = { "/a.ts": fs.readFileSync("a.ts","utf8"), "/b.ts": fs.readFileSync("b.ts","utf8") };
const opts = { module: ts.ModuleKind.ESNext, target: ts.ScriptTarget.ES2020, strict: true };
const host = {
  getScriptFileNames: () => Object.keys(files),
  getScriptVersion: () => "1",
  getScriptSnapshot: f => files[f] !== undefined ? ts.ScriptSnapshot.fromString(files[f]) : undefined,
  getCurrentDirectory: () => "/",
  getCompilationSettings: () => opts,
  getDefaultLibFileName: () => "/lib.d.ts",
  fileExists: f => files[f] !== undefined,
  readFile: f => files[f],
};
const ls = ts.createLanguageService(host);
const text = files["/b.ts"];
const start = text.indexOf("function");
const end = text.length - 1;
const edits = ls.getEditsForRefactor("/b.ts", {}, {pos:start,end}, "Move to a new file", "Move to a new file", {});
for (const e of edits.edits) { console.log("== " + e.fileName); for (const t of e.textChanges) console.log(JSON.stringify(t.newText)); }
