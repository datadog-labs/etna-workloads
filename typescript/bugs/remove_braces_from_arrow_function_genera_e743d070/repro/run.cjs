const ts = require(process.env.TYPESCRIPT);
const fs = require("fs");
const text = fs.readFileSync("input.ts", "utf8");
const host = {
  getScriptFileNames: () => ["input.ts"],
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "input.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "",
  getCompilationSettings: () => ({}),
  getDefaultLibFileName: o => ts.getDefaultLibFilePath(o),
  fileExists: f => f === "input.ts", readFile: f => f === "input.ts" ? text : undefined,
};
const ls = ts.createLanguageService(host);
const start = text.indexOf("(param)");
const end = text.indexOf(";", start);
const eds = ls.getEditsForRefactor("input.ts", {}, {pos: start, end}, "Add or remove braces in an arrow function", "Remove braces from arrow function", {});
let out = text;
for (const c of eds.edits[0].textChanges.slice().reverse()) out = out.slice(0, c.span.start) + c.newText + out.slice(c.span.start + c.span.length);
console.log(out);
