import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const files = {
  "/a.ts": "export const x = 0;\nx;\n",
  "/b.ts": "import { x } from './a'\n\nx;\n",
};
const host = {
  getScriptFileNames: () => Object.keys(files),
  getScriptVersion: () => "1",
  getScriptSnapshot: f => files[f] !== undefined ? ts.ScriptSnapshot.fromString(files[f]) : undefined,
  getCurrentDirectory: () => "/",
  getCompilationSettings: () => ({}),
  getDefaultLibFileName: () => "/lib.d.ts",
  fileExists: f => files[f] !== undefined,
  readFile: f => files[f],
};
const ls = ts.createLanguageService(host);
const start = files["/b.ts"].lastIndexOf("x");
const edits = ls.getEditsForRefactor("/b.ts", {}, { pos: start, end: start + 1 }, "Move to a new file", "Move to a new file", {});
for (const e of edits?.edits ?? []) { console.log("== " + e.fileName); for (const t of e.textChanges) console.log(JSON.stringify(t.newText)); }
