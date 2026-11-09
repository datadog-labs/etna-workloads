const ts = require(process.env.TYPESCRIPT);
const src = require("fs").readFileSync("input.ts", "utf8");
const host = ts.createCompilerHost({});
const opts = {};
const lsHost = {
  getCompilationSettings: () => opts, getScriptFileNames: () => ["input.ts"],
  getScriptVersion: () => "1", getScriptSnapshot: f => f === "input.ts" ? ts.ScriptSnapshot.fromString(src) : undefined,
  getCurrentDirectory: () => "/", getDefaultLibFileName: () => "lib.d.ts",
  fileExists: f => f === "input.ts", readFile: f => f === "input.ts" ? src : undefined,
};
const ls = ts.createLanguageService(lsHost);
const p = (i, d = 0) => { console.log(" ".repeat(d) + i.text); i.childItems.forEach(c => p(c, d + 1)); };
ls.getNavigationBarItems("input.ts").forEach(i => p(i));
