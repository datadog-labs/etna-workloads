const ts = require(process.env.TYPESCRIPT);
const fs = require("fs");
const files = { "/a.js": fs.readFileSync("a.js","utf8"), "/foo.js": fs.readFileSync("foo.js","utf8") };
const host = {
  getScriptFileNames: () => Object.keys(files),
  getScriptVersion: () => "1",
  getScriptSnapshot: f => files[f] !== undefined ? ts.ScriptSnapshot.fromString(files[f]) : undefined,
  getCurrentDirectory: () => "/",
  getCompilationSettings: () => ({ allowJs: true, checkJs: true }),
  getDefaultLibFileName: () => "/lib.d.ts",
  fileExists: f => files[f] !== undefined,
  readFile: f => files[f],
};
const ls = ts.createLanguageService(host);
const text = files["/a.js"];
const r = ls.getEditsForRefactor("/a.js", {}, {pos:0,end:text.indexOf("\n")}, "Convert import", "Convert named imports to namespace import", {});
for (const e of r.edits) for (const c of e.textChanges) console.log(JSON.stringify(c));
