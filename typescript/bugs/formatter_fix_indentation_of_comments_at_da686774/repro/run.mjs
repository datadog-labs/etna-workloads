import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const text = "if (true) {\n// test comment\n}";
const host = {
  getScriptFileNames: () => ["a.ts"],
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "a.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "/",
  getCompilationSettings: () => ({}),
  getDefaultLibFileName: () => "lib.d.ts",
  fileExists: f => f === "a.ts",
  readFile: () => undefined,
};
const ls = ts.createLanguageService(host);
const start = text.indexOf("// test"), end = text.indexOf("}");
const edits = ls.getFormattingEditsForRange("a.ts", start, end, ts.getDefaultFormatCodeSettings("\n"));
let out = text;
for (const e of [...edits].sort((a, b) => b.span.start - a.span.start))
  out = out.slice(0, e.span.start) + e.newText + out.slice(e.span.start + e.span.length);
console.log(JSON.stringify(out));
