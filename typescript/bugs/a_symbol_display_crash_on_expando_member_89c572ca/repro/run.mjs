import fs from "fs";
import { createRequire } from "module";
const ts = createRequire(import.meta.url)(process.env.TYPESCRIPT);
const text = fs.readFileSync("input.js", "utf8");
const host = {
  getScriptFileNames: () => ["input.js"],
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "input.js" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "/",
  getCompilationSettings: () => ({ allowJs: true, checkJs: true, strict: true }),
  getDefaultLibFileName: () => "lib.d.ts",
  fileExists: f => f === "input.js",
  readFile: f => f === "input.js" ? text : undefined,
};
const ls = ts.createLanguageService(host);
const pos = text.lastIndexOf("x.foo") + 2;
try {
  const qi = ls.getQuickInfoAtPosition("input.js", pos);
  console.log(qi && ts.displayPartsToString(qi.displayParts));
} catch (e) { console.log("crash:", e.message.split("\n")[0]); }
