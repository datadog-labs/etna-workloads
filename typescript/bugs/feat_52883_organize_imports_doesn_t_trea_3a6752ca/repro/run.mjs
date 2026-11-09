import { createRequire } from "module";
import fs from "fs";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const text = fs.readFileSync("input.ts", "utf8");
const host = {
  getScriptFileNames: () => ["input.ts"], getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "input.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => ".", getCompilationSettings: () => ({}),
  getDefaultLibFileName: o => ts.getDefaultLibFilePath(o),
  fileExists: f => f === "input.ts", readFile: f => f === "input.ts" ? text : undefined,
};
const ls = ts.createLanguageService(host);
const ch = ls.organizeImports({ type: "file", fileName: "input.ts" }, {}, {});
for (const c of ch) for (const t of c.textChanges) console.log(JSON.stringify(t));
