import { createRequire } from "module";
import fs from "fs";
const ts = createRequire(import.meta.url)(process.env.TYPESCRIPT);
const text = fs.readFileSync("a.js", "utf8");
const opts = { allowJs: true, checkJs: true, noEmit: true };
const host = {
  getScriptFileNames: () => ["a.js"],
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "a.js" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "",
  getCompilationSettings: () => opts,
  getDefaultLibFileName: () => "lib.d.ts",
  fileExists: f => f === "a.js",
  readFile: f => f === "a.js" ? text : undefined,
};
const ls = ts.createLanguageService(host);
const pos = text.lastIndexOf("b.method") + 3;
const qi = ls.getQuickInfoAtPosition("a.js", pos + 2);
console.log(ts.displayPartsToString(qi.displayParts));
console.log("DOC:", ts.displayPartsToString(qi.documentation));
