const ts = require(process.env.TYPESCRIPT);
const fs = require("fs");
const text = fs.readFileSync("input.js", "utf8");
const f = "input.js";
const host = {
  getScriptFileNames: () => [f], getScriptVersion: () => "1",
  getScriptSnapshot: n => n === f ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "", getCompilationSettings: () => ({ allowJs: true, checkJs: true, strict: true }),
  getDefaultLibFileName: () => "lib.d.ts", fileExists: n => n === f, readFile: n => n === f ? text : undefined,
};
const ls = ts.createLanguageService(host);
const pos = text.indexOf("m(foo");
const fixes = ls.getCodeFixesAtPosition(f, pos + 2, pos + 2, [80004], {}, {});
for (const fx of fixes) {
  console.log(fx.description);
  for (const c of fx.changes) for (const t of c.textChanges) console.log(JSON.stringify(t.newText));
}
