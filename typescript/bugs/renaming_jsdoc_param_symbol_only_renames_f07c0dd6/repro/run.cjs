const ts = require(process.env.TYPESCRIPT);
const fs = require("fs");
const text = fs.readFileSync("a.js", "utf8");
const host = {
  getScriptFileNames: () => ["a.js"],
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "a.js" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => ".",
  getCompilationSettings: () => ({ allowJs: true, checkJs: true }),
  getDefaultLibFileName: () => "lib.d.ts",
  fileExists: f => f === "a.js", readFile: f => f === "a.js" ? text : undefined,
};
const ls = ts.createLanguageService(host);
const pos = text.indexOf("options) {}");
const locs = ls.findRenameLocations("a.js", pos, false, false, {}) || [];
let out = text;
for (const l of locs.slice().sort((a, b) => b.textSpan.start - a.textSpan.start))
  out = out.slice(0, l.textSpan.start) + "NEW" + out.slice(l.textSpan.start + l.textSpan.length);
console.log(locs.length); console.log(out);
