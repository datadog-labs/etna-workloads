import { createRequire } from "module";
import fs from "fs";
const ts = createRequire(import.meta.url)(process.env.TYPESCRIPT);
const text = fs.readFileSync("input.ts", "utf8");
const pos = text.indexOf('type: ""') + 7;
const opts = { strict: true, noEmit: true };
const host = {
  getScriptFileNames: () => ["input.ts"],
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "input.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "/",
  getCompilationSettings: () => opts,
  getDefaultLibFileName: o => ts.getDefaultLibFileName(o),
  fileExists: f => f === "input.ts",
  readFile: f => f === "input.ts" ? text : undefined,
};
const ls = ts.createLanguageService(host);
const c = ls.getCompletionsAtPosition("input.ts", pos, {});
console.log(JSON.stringify(c ? c.entries.map(e => e.name) : null));
