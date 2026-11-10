import { createRequire } from "module";
const ts = createRequire(import.meta.url)(process.env.TYPESCRIPT);
const text = "try {\n    a();\n} catch {\n    b();\n}\n";
const host = {
  getScriptFileNames: () => ["a.ts"], getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "a.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "/", getCompilationSettings: () => ({}),
  getDefaultLibFileName: () => "lib.d.ts", fileExists: f => f === "a.ts", readFile: () => undefined,
};
const ls = ts.createLanguageService(host);
const edits = ls.getFormattingEditsForDocument("a.ts", {...ts.getDefaultFormatCodeSettings("\n"), placeOpenBraceOnNewLineForControlBlocks: true});
let out = text;
for (const e of [...edits].sort((a, b) => b.span.start - a.span.start))
  out = out.slice(0, e.span.start) + e.newText + out.slice(e.span.start + e.span.length);
console.log(out);
