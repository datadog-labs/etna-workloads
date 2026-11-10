import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const files = {
  "/a.ts": "export const x = 0;",
  "/x.ts": 'import * as a from "./a";\na.x;',
  "/x.1.ts": "",
};
const host = {
  getScriptFileNames: () => Object.keys(files),
  getScriptVersion: () => "1",
  getScriptSnapshot: f => f in files ? ts.ScriptSnapshot.fromString(files[f]) : undefined,
  getCurrentDirectory: () => "/",
  getCompilationSettings: () => ({}),
  getDefaultLibFileName: () => "/lib.d.ts",
  fileExists: f => f in files,
  readFile: f => files[f],
};
const ls = ts.createLanguageService(host);
const range = { pos: 0, end: files["/a.ts"].length };
const edits = ls.getEditsForRefactor("/a.ts", {}, range, "Move to a new file", "Move to a new file", { allowTextChangesInNewFiles: true });
for (const e of edits.edits) {
  console.log("== " + e.fileName);
  for (const t of e.textChanges) console.log(JSON.stringify(t.newText));
}
