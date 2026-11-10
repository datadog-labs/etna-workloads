import { createRequire } from 'module';
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const text = "const a = 1;;\nconst b = 2;\n;[1, 2, 3]\n";
const host = {
  getCompilationSettings: () => ({}), getScriptFileNames: () => ["a.ts"],
  getScriptVersion: () => "1", getScriptSnapshot: f => ts.ScriptSnapshot.fromString(text),
  getCurrentDirectory: () => "/", getDefaultLibFileName: () => "lib.d.ts",
  fileExists: () => true, readFile: () => text,
};
const ls = ts.createLanguageService(host);
const opts = { ...ts.getDefaultFormatCodeSettings(), semicolons: ts.SemicolonPreference.Remove };
const edits = ls.getFormattingEditsForDocument("a.ts", opts);
let out = text;
for (const e of [...edits].sort((a, b) => b.span.start - a.span.start))
  out = out.slice(0, e.span.start) + e.newText + out.slice(e.span.start + e.span.length);
console.log(out);
