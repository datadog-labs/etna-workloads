const ts = require(process.env.TYPESCRIPT);
const fs = require("fs");
const text = fs.readFileSync("input.ts", "utf8");
const host = {
  getScriptFileNames: () => ["input.ts"], getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "input.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => ".", getCompilationSettings: () => ({}),
  getDefaultLibFileName: () => "lib.d.ts", fileExists: f => f === "input.ts", readFile: f => f === "input.ts" ? text : undefined,
};
const ls = ts.createLanguageService(host);
for (const m of ["B", "C"]) {
  const pos = text.indexOf("foo", text.indexOf("class " + m));
  const qi = ls.getQuickInfoAtPosition("input.ts", pos);
  console.log(m, JSON.stringify(qi.tags));
}
