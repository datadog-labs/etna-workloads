import { createRequire } from 'module';
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const text = `export class C extends Error {
    message: string;
    data? = {};
}`;
const host = {
  getScriptFileNames: () => ["a.ts"], getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "a.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "/", getCompilationSettings: () => ({}),
  getDefaultLibFileName: o => "lib.d.ts", fileExists: f => f === "a.ts", readFile: () => undefined,
};
const ls = ts.createLanguageService(host);
const edits = ls.getFormattingEditsForDocument("a.ts", ts.getDefaultFormatCodeSettings());
let out = text;
for (const e of [...edits].reverse()) out = out.slice(0, e.span.start) + e.newText + out.slice(e.span.start + e.span.length);
console.log(out);
