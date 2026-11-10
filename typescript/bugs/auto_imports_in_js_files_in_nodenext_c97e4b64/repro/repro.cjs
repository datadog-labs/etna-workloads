const ts = require(process.env.TYPESCRIPT);
const fs = require("fs");
const path=require("path");const files = ["main.js","matrix.js","other.js"].map(f=>path.resolve(f));
const opts = {module: ts.ModuleKind.Node18, allowJs:true, checkJs:true, noEmit:true};
const host = {
  getScriptFileNames: () => files,
  getScriptVersion: () => "1",
  getScriptSnapshot: f => fs.existsSync(f) ? ts.ScriptSnapshot.fromString(fs.readFileSync(f,"utf8")) : undefined,
  getCurrentDirectory: () => process.cwd(),
  getCompilationSettings: () => opts,
  getDefaultLibFileName: o => ts.getDefaultLibFilePath(o),
  fileExists: f => fs.existsSync(f), readFile: f => fs.readFileSync(f,"utf8"),
  readDirectory: ts.sys.readDirectory, directoryExists: ts.sys.directoryExists, getDirectories: ts.sys.getDirectories,
};
const ls = ts.createLanguageService(host);
const text = fs.readFileSync("main.js","utf8");
const pos = text.indexOf("variants") + 8;
const fixes = ls.getCodeFixesAtPosition(files[0], pos-8, pos, [2304], {}, {includeCompletionsForModuleExports:true, allowIncompleteCompletions:true});
for (const f of fixes.filter(f=>f.fixName==="import")) for (const c of f.changes) for (const t of c.textChanges) console.log(f.description, JSON.stringify(t.newText));
