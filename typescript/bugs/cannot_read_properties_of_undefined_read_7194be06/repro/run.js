const ts = require(process.env.TYPESCRIPT);
const fs = require("fs");
const text = fs.readFileSync("input.ts", "utf8");
const opts = { strict: true };
const host = {
  getScriptFileNames: () => ["input.ts"],
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "input.ts" ? ts.ScriptSnapshot.fromString(text) : fs.existsSync(f) ? ts.ScriptSnapshot.fromString(fs.readFileSync(f,"utf8")) : undefined,
  getCurrentDirectory: () => "",
  getCompilationSettings: () => opts,
  getDefaultLibFileName: o => ts.getDefaultLibFilePath(o),
  fileExists: f => f === "input.ts" || fs.existsSync(f),
  readFile: f => f === "input.ts" ? text : fs.existsSync(f) ? fs.readFileSync(f,"utf8") : undefined,
};
const ls = ts.createLanguageService(host);
const diags = ls.getSemanticDiagnostics("input.ts");
for (const d of diags) {
  console.log(d.code, d.start, d.length);
  try {
    const fixes = ls.getCodeFixesAtPosition("input.ts", d.start, d.start + d.length, [d.code], {}, {});
    console.log("fixes:", fixes.map(f => f.fixName + ": " + f.description));
  } catch (e) { console.log("threw:", e instanceof TypeError ? "TypeError" : e.message); }
}
