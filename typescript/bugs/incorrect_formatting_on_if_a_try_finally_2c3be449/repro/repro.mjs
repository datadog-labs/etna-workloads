import { createRequire } from 'module';
const ts = createRequire(import.meta.url)(process.env.TYPESCRIPT);
const text = "if (true) try  {\n    // ...\n}   finally    {\n    // ...\n}\n";
const host = {
  getCompilationSettings: () => ({}), getScriptFileNames: () => ["a.ts"],
  getScriptVersion: () => "1", getScriptSnapshot: () => ts.ScriptSnapshot.fromString(text),
  getCurrentDirectory: () => "/", getDefaultLibFileName: () => "lib.d.ts",
  fileExists: () => true, readFile: () => text,
};
const ls = ts.createLanguageService(host);
const edits = ls.getFormattingEditsForDocument("a.ts", ts.getDefaultFormatCodeSettings("\n"));
let out = text;
for (const e of [...edits].sort((a, b) => b.span.start - a.span.start))
  out = out.slice(0, e.span.start) + e.newText + out.slice(e.span.start + e.span.length);
console.log(out);
