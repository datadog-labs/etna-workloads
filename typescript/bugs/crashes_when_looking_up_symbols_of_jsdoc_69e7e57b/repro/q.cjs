const ts = require(process.env.TYPESCRIPT);
const fs = require("fs");
const text = fs.readFileSync("input.ts", "utf8");
const host = {
  getCompilationSettings: () => ({}),
  getScriptFileNames: () => ["input.ts"],
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "input.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "",
  getDefaultLibFileName: () => "lib.d.ts",
  fileExists: f => f === "input.ts",
  readFile: f => f === "input.ts" ? text : undefined,
};
const ls = ts.createLanguageService(host);
for (const m of ["data", "a: string"]) {
  const pos = text.indexOf(m);
  try {
    const qi = ls.getQuickInfoAtPosition("input.ts", pos);
    console.log(m, "=>", qi ? ts.displayPartsToString(qi.displayParts) : "none");
  } catch (e) { console.log(m, "=> crash", e.message.split("\n")[0]); }
}
