import { createRequire } from 'module';
const ts = createRequire(import.meta.url)(process.env.TYPESCRIPT);
const text = "const x = 1;\nconst y = x.toString();\n";
const host = {
  getScriptFileNames: () => ["a.ts"], getScriptVersion: () => "1",
  getScriptSnapshot: f => f === "a.ts" ? ts.ScriptSnapshot.fromString(text) : undefined,
  getCurrentDirectory: () => "/", getCompilationSettings: () => ({}),
  getDefaultLibFileName: () => "lib.d.ts", fileExists: f => f === "a.ts",
  readFile: f => f === "a.ts" ? text : undefined,
};
const ls = ts.createLanguageService(host);
const pos = text.indexOf("x =");
const edits = ls.getEditsForRefactor("a.ts", {}, pos, "Inline variable", "Inline variable", {});
for (const fc of edits?.edits ?? []) for (const c of fc.textChanges) console.log(JSON.stringify(c.newText));
