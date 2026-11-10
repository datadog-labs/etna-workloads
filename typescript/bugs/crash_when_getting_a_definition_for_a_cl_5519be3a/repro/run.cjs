const ts = require(process.env.TYPESCRIPT);
const fs = require("fs");
const text = fs.readFileSync("input.ts", "utf8");
const host = {
  getScriptFileNames: () => ["input.ts"],
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "input.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => ".",
  getCompilationSettings: () => ({ strict: true, target: ts.ScriptTarget.ESNext }),
  getDefaultLibFileName: o => ts.getDefaultLibFilePath(o),
  fileExists: f => f === "input.ts", readFile: f => f === "input.ts" ? text : undefined,
};
const ls = ts.createLanguageService(host);
const pos = text.indexOf("override");
const defs = ls.getDefinitionAtPosition("input.ts", pos) || [];
console.log(defs.length);
for (const d of defs) console.log(d.fileName, JSON.stringify(text.slice(d.textSpan.start, d.textSpan.start + d.textSpan.length)), d.textSpan.start);
