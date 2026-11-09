import fs from "fs";
import { createRequire } from "module";
const ts = createRequire(import.meta.url)(process.env.TYPESCRIPT);
const files = { "/a.js": fs.readFileSync("a.js","utf8"), "/b.js": fs.readFileSync("b.js","utf8") };
const host = {
  getScriptFileNames: () => Object.keys(files),
  getScriptVersion: () => "1",
  getScriptSnapshot: f => files[f] === undefined ? undefined : ts.ScriptSnapshot.fromString(files[f]),
  getCurrentDirectory: () => "/",
  getCompilationSettings: () => ({ allowJs: true, checkJs: true }),
  getDefaultLibFileName: () => "/lib.d.ts",
  fileExists: f => files[f] !== undefined,
  readFile: f => files[f],
};
const ls = ts.createLanguageService(host);
const pos = files["/b.js"].indexOf("Foo") + 1;
const qi = ls.getQuickInfoAtPosition("/b.js", pos);
console.log(qi ? qi.kind + ": " + ts.displayPartsToString(qi.displayParts) : "none");
