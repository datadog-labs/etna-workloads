import fs from "fs";
import { createRequire } from "module";
const ts = createRequire(import.meta.url)(process.env.TYPESCRIPT);
const text = fs.readFileSync("input.ts", "utf8");
const pos = text.indexOf("x(1).") + 5;
const host = {
  getCompilationSettings: () => ({ target: 99, strict: true }),
  getScriptFileNames: () => ["input.ts"],
  getScriptVersion: () => "1",
  getScriptSnapshot: n => n === "input.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "/",
  getDefaultLibFileName: () => "lib.d.ts",
  fileExists: n => n === "input.ts", readFile: n => n === "input.ts" ? text : undefined,
};
const ls = ts.createLanguageService(host);
const r = ls.getCompletionsAtPosition("input.ts", pos, { includeInsertTextCompletions: true });
const e = r.entries.find(e => e.name === "foo");
const s = e.replacementSpan;
console.log(e.insertText, JSON.stringify(text.slice(s.start, s.start + s.length)));
