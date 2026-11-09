const ts = require(process.env.TYPESCRIPT);
const fs = require("fs");
const text = fs.readFileSync("input.ts", "utf8");
const host = {
  getCompilationSettings: () => ({}), getScriptFileNames: () => ["input.ts"],
  getScriptVersion: () => "1", getScriptSnapshot: f => f === "input.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "", getDefaultLibFileName: () => "lib.d.ts",
  fileExists: f => f === "input.ts", readFile: f => f === "input.ts" ? text : undefined,
};
const ls = ts.createLanguageService(host);
const p = (n, d) => { console.log("  ".repeat(d) + n.text + " [" + n.kind + "]"); n.childItems.forEach(c => p(c, d + 1)); };
ls.getNavigationBarItems("input.ts").forEach(n => p(n, 0));
