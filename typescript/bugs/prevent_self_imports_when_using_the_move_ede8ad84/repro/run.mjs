import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const files = {
  "/bar.ts": 'import { y } from "./a";\n',
  "/a.ts": "export const y = 1;\n",
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
  useCaseSensitiveFileNames: () => true,
};
const ls = ts.createLanguageService(host);
const span = { pos: 0, end: files["/a.ts"].length };
const edits = ls.getEditsForRefactor("/a.ts", {}, span, "Move to file", "Move to file", {}, { targetFile: "/bar.ts" });
for (const e of edits?.edits ?? []) { console.log("== " + e.fileName); for (const t of e.textChanges) console.log(JSON.stringify(t)); }
