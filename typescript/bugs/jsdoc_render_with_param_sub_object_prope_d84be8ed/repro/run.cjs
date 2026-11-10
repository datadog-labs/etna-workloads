const ts = require(process.env.TYPESCRIPT);
const fs = require("fs");
const text = fs.readFileSync("input.js", "utf8");
const host = {
  getScriptFileNames: () => ["input.js"],
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "input.js" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "",
  getCompilationSettings: () => ({ allowJs: true }),
  getDefaultLibFileName: () => "lib.d.ts",
  fileExists: f => f === "input.js", readFile: f => f === "input.js" ? text : undefined,
};
const ls = ts.createLanguageService(host);
const qi = ls.getQuickInfoAtPosition("input.js", text.lastIndexOf("f;"));
console.log(JSON.stringify(qi.tags.map(t => [t.name, (t.text||[]).map(p=>p.text).join("")]), null, 1));
