const ts = require(process.env.TYPESCRIPT);
const fs = require("fs");
const text = fs.readFileSync("input.ts", "utf8");
const host = {
  getScriptFileNames: () => ["input.ts"],
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "input.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => ".",
  getCompilationSettings: () => ({ strict: true }),
  getDefaultLibFileName: o => ts.getDefaultLibFilePath(o),
  fileExists: f => f === "input.ts", readFile: f => f === "input.ts" ? text : undefined,
};
const ls = ts.createLanguageService(host);
const hints = ls.provideInlayHints("input.ts", { start: 0, length: text.length }, { includeInlayFunctionLikeReturnTypeHints: true });
console.log(JSON.stringify(hints.map(h => ({ t: h.text, p: h.position }))));
