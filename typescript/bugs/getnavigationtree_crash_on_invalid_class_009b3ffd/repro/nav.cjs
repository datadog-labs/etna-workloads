const ts = require(process.env.TYPESCRIPT);
const fs = require("fs");
const host = {
  getScriptFileNames: () => ["input.ts"],
  getScriptVersion: () => "1",
  getScriptSnapshot: f => fs.existsSync(f) ? ts.ScriptSnapshot.fromString(fs.readFileSync(f, "utf8")) : undefined,
  getCurrentDirectory: () => process.cwd(),
  getCompilationSettings: () => ({}),
  getDefaultLibFileName: ts.getDefaultLibFilePath,
  fileExists: fs.existsSync, readFile: f => fs.readFileSync(f, "utf8"),
};
const ls = ts.createLanguageService(host);
try {
  const strip = n => ({ text: n.text, kind: n.kind, children: n.childItems && n.childItems.map(strip) });
  console.log(JSON.stringify(strip(ls.getNavigationTree("input.ts")), null, 1));
} catch (e) { console.log("CRASH:", e.message); }
