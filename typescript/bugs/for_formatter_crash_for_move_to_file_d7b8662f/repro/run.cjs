const ts = require(process.env.TYPESCRIPT);
const fs = require("fs");
const files = { "/a.ts": fs.readFileSync("a.ts", "utf8"), "/bar.ts": fs.readFileSync("bar.ts", "utf8") };
const host = {
  getScriptFileNames: () => Object.keys(files),
  getScriptVersion: () => "1",
  getScriptSnapshot: f => files[f] === undefined ? undefined : ts.ScriptSnapshot.fromString(files[f]),
  getCurrentDirectory: () => "/",
  getCompilationSettings: () => ({}),
  getDefaultLibFileName: () => "/lib.d.ts",
  fileExists: f => files[f] !== undefined,
  readFile: f => files[f],
};
const ls = ts.createLanguageService(host);
const range = { pos: 0, end: files["/a.ts"].length };
const edits = ls.getEditsForRefactor("/a.ts", {}, range, "Move to file", "Move to file", {}, { targetFile: "/bar.ts" });
for (const e of edits ? edits.edits : []) {
  console.log("== " + e.fileName);
  let t = files[e.fileName];
  for (const c of [...e.textChanges].sort((x, y) => y.span.start - x.span.start))
    t = t.slice(0, c.span.start) + c.newText + t.slice(c.span.start + c.span.length);
  console.log(t);
}
