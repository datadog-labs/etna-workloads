const ts = require(process.env.TYPESCRIPT);
const fs = require("fs");
const files = { "/a.js": fs.readFileSync("a.js", "utf8"), "/b.js": fs.readFileSync("b.js", "utf8") };
const opts = { allowJs: true, checkJs: true, module: ts.ModuleKind.CommonJS };
const host = {
  getScriptFileNames: () => Object.keys(files),
  getScriptVersion: () => "1",
  getScriptSnapshot: f => files[f] !== undefined ? ts.ScriptSnapshot.fromString(files[f]) : undefined,
  getCurrentDirectory: () => "/",
  getCompilationSettings: () => opts,
  getDefaultLibFileName: () => "/lib.d.ts",
  fileExists: f => files[f] !== undefined,
  readFile: f => files[f],
};
const ls = ts.createLanguageService(host);
const pos = files["/a.js"].indexOf("A\n");
const refs = ls.findReferences("/a.js", pos) || [];
for (const r of refs) for (const x of r.references) console.log(x.fileName, x.textSpan.start, x.textSpan.length);
