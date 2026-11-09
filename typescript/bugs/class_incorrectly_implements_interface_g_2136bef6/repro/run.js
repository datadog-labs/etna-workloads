const ts = require(process.env.TYPESCRIPT);
const fs = require("fs");
const name = "input.ts", text = fs.readFileSync(name, "utf8");
const host = {
  getScriptFileNames: () => [name], getScriptVersion: () => "1",
  getScriptSnapshot: f => f === name ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "", getCompilationSettings: () => ({}),
  getDefaultLibFileName: () => "lib.d.ts", fileExists: f => f === name,
  readFile: f => f === name ? text : undefined,
};
const ls = ts.createLanguageService(host);
const pos = text.indexOf("class C") + 8;
const fixes = ls.getCodeFixesAtPosition(name, pos, pos + 1, [2420], {}, {});
for (const f of fixes) {
  if (!f.description.startsWith("Implement interface")) continue;
  console.log(f.description);
  for (const c of f.changes) for (const t of c.textChanges) console.log(t.newText);
}
