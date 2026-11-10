const ts = require(process.env.TYPESCRIPT);
const fs = require("fs");
const text = fs.readFileSync("input.ts", "utf8");
const pos = text.indexOf("{\n  \n}") + 4;
const opts = { target: ts.ScriptTarget.ES2022 };
const host = {
  getScriptFileNames: () => ["input.ts"],
  getScriptVersion: () => "1",
  getScriptSnapshot: f => { const t = f === "input.ts" ? text : ts.sys.readFile(f); return t === undefined ? undefined : ts.ScriptSnapshot.fromString(t); },
  getCurrentDirectory: () => ".",
  getCompilationSettings: () => opts,
  getDefaultLibFileName: o => ts.getDefaultLibFilePath(o),
  fileExists: f => f === "input.ts" || ts.sys.fileExists(f),
  readFile: f => f === "input.ts" ? text : ts.sys.readFile(f),
};
const ls = ts.createLanguageService(host);
const c = ls.getCompletionsAtPosition("input.ts", pos, {});
console.log((c ? c.entries.filter(e => e.kind === "property").map(e => e.name) : []).sort().join(","));
