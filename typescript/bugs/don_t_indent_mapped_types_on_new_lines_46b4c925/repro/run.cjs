const ts = require(process.env.TYPESCRIPT);
const fs = require("fs");
const text = fs.readFileSync("input.ts", "utf8");
const host = {
  getScriptFileNames: () => ["input.ts"],
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "input.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => ".",
  getCompilationSettings: () => ({}),
  getDefaultLibFileName: o => ts.getDefaultLibFilePath(o),
  fileExists: () => true, readFile: () => undefined,
};
const ls = ts.createLanguageService(host);
const edits = ls.getFormattingEditsForDocument("input.ts", ts.getDefaultFormatCodeSettings("\n"));
let out = text;
for (const e of edits.slice().sort((a, b) => b.span.start - a.span.start))
  out = out.slice(0, e.span.start) + e.newText + out.slice(e.span.start + e.span.length);
console.log(out);
