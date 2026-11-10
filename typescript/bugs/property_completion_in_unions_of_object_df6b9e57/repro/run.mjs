import fs from "fs";
import { createRequire } from "module";
const ts = createRequire(import.meta.url)(process.env.TYPESCRIPT);
const text = fs.readFileSync("input.ts", "utf8");
const host = {
  getScriptFileNames: () => ["input.ts"], getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "input.ts" ? ts.ScriptSnapshot.fromString(text) : fs.existsSync(f) ? ts.ScriptSnapshot.fromString(fs.readFileSync(f,"utf8")) : undefined,
  getCurrentDirectory: () => ".", getCompilationSettings: () => ({strict:true}),
  getDefaultLibFileName: o => ts.getDefaultLibFilePath(o), fileExists: f => f === "input.ts" || fs.existsSync(f), readFile: f => f === "input.ts" ? text : undefined,
};
const ls = ts.createLanguageService(host);
const pos = text.indexOf("{\n  \n}") + 2;
const c = ls.getCompletionsAtPosition("input.ts", pos, {});
console.log((c ? c.entries.map(e => e.name) : []).sort().join(","));
