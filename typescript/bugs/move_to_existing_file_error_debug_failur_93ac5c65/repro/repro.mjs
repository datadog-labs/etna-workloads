import { createRequire } from "module";
const require = createRequire(import.meta.url);
const ts = require(process.env.TYPESCRIPT);
const files = { "/a.ts": "export const x = 1;\nexport const y = 2;\n", "/other.ts": "export const z = 3;\n" };
const host = {
  getScriptFileNames: () => ["/a.ts"],
  getScriptVersion: () => "1",
  getScriptSnapshot: f => files[f] === undefined ? undefined : ts.ScriptSnapshot.fromString(files[f]),
  getCurrentDirectory: () => "/",
  getCompilationSettings: () => ({}),
  getDefaultLibFileName: () => "/lib.d.ts",
  fileExists: f => files[f] !== undefined,
  readFile: f => files[f],
};
const ls = ts.createLanguageService(host);
try {
  const r = ls.getEditsForRefactor("/a.ts", {}, { pos: 0, end: 19 }, "Move to file", "Move to file", {}, { targetFile: "/other.ts" });
  console.log(JSON.stringify(r && r.edits));
} catch (e) { console.log("threw:", String(e.message).split("\n")[0]); }
