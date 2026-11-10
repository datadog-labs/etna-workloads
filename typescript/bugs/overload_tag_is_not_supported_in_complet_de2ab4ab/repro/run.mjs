import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const text = "/**\n * @\n */\n";
const host = {
  getScriptFileNames: () => ["a.js"],
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "a.js" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "/",
  getCompilationSettings: () => ({ allowJs: true, checkJs: true }),
  getDefaultLibFileName: o => "lib.d.ts",
  fileExists: f => f === "a.js",
  readFile: f => f === "a.js" ? text : undefined,
};
const ls = ts.createLanguageService(host);
const r = ls.getCompletionsAtPosition("a.js", text.indexOf("@") + 1, {});
console.log(r.entries.map(e => e.name).filter(n => n.startsWith("over")).join("\n"));
