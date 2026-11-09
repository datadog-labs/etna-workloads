const ts = require(process.env.TYPESCRIPT);
const fs = require("fs");
const files = { "/a.d.ts": fs.readFileSync("a.d.ts", "utf8"), "/b.ts": fs.readFileSync("b.ts", "utf8") };
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
const pos = files["/b.ts"].indexOf("A()");
const qi = ls.getQuickInfoAtPosition("/b.ts", pos);
console.log(ts.displayPartsToString(qi.displayParts));
console.log("DOC:", ts.displayPartsToString(qi.documentation));
