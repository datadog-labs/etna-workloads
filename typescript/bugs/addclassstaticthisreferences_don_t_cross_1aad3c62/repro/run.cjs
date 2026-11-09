const ts = require(process.env.TYPESCRIPT);
const fs = require("fs");
const text = fs.readFileSync("input.ts", "utf8");
const host = {
  getScriptFileNames: () => ["input.ts"],
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "input.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "",
  getCompilationSettings: () => ({}),
  getDefaultLibFileName: () => "lib.d.ts",
  fileExists: f => f === "input.ts", readFile: f => f === "input.ts" ? text : undefined,
};
const ls = ts.createLanguageService(host);
const refs = ls.findReferences("input.ts", text.indexOf("C {") ) || [];
for (const g of refs) for (const r of g.references) {
  const s = r.textSpan.start;
  console.log(text.split("\n").slice(0).join("\n").slice(0, s).split("\n").length, JSON.stringify(text.substr(s, r.textSpan.length)));
}
