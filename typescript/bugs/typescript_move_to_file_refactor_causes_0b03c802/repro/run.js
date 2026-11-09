const ts = require(process.env.TYPESCRIPT);
const fs = require("fs");
const files = { "/a.ts": fs.readFileSync("a.ts","utf8"), "/b.ts": fs.readFileSync("b.ts","utf8") };
const host = {
  getScriptFileNames: () => Object.keys(files),
  getScriptVersion: () => "1",
  getScriptSnapshot: f => files[f] !== undefined ? ts.ScriptSnapshot.fromString(files[f]) : undefined,
  getCurrentDirectory: () => "/",
  getCompilationSettings: () => ({}),
  getDefaultLibFileName: () => "/lib.d.ts",
  fileExists: f => files[f] !== undefined,
  readFile: f => files[f],
};
const ls = ts.createLanguageService(host);
const start = files["/b.ts"].indexOf("const Foo");
const end = files["/b.ts"].indexOf("};") + 2;
const edits = ls.getEditsForRefactor("/b.ts", {}, {pos:start,end}, "Move to file", "Move to file", {}, { targetFile: "/a.ts" });
for (const e of edits.edits) { console.log("== " + e.fileName); for (const t of e.textChanges) console.log(JSON.stringify(t)); }
