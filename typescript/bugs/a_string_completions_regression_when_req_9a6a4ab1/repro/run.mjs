import fs from "fs";
import { createRequire } from "module";
const ts = createRequire(import.meta.url)(process.env.TYPESCRIPT);
const text = fs.readFileSync("input.ts", "utf8");
const host = {
  getScriptFileNames: () => ["input.ts"], getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "input.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => ".", getCompilationSettings: () => ({ strict: true }),
  getDefaultLibFileName: () => "lib.d.ts", fileExists: f => f === "input.ts", readFile: f => f === "input.ts" ? text : undefined,
};
const ls = ts.createLanguageService(host);
const pos = text.indexOf('""') + 1;
const c = ls.getCompletionsAtPosition("input.ts", pos, {});
console.log(JSON.stringify(c && c.entries.map(e => e.name)));
