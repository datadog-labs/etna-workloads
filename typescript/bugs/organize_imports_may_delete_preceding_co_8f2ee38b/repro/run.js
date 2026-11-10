const ts = require(process.env.TYPESCRIPT);
const fs = require("fs");
const files = { "/a.ts": "export const foo = 1;", "/b.ts": fs.readFileSync("input.ts", "utf8") };
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
const changes = ls.organizeImports({ type: "file", fileName: "/b.ts" }, {}, {});
let text = files["/b.ts"];
for (const c of changes) for (const t of [...c.textChanges].sort((a, b) => b.span.start - a.span.start))
  text = text.slice(0, t.span.start) + t.newText + text.slice(t.span.start + t.span.length);
console.log(text);
