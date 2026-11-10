import { createRequire } from "module";
import fs from "fs";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
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
const pos = text.indexOf(", )") + 2;
const h = ls.getSignatureHelpItems("input.ts", pos, {});
console.log(JSON.stringify({ argumentIndex: h.argumentIndex, argumentCount: h.argumentCount }));
